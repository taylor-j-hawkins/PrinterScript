#!/bin/bash

# Author: Taylor Hawkins
# Handle: Marashni
# Purpose: This is a bash script designed to send printer test pages to specified printers
# 	   during DeskCat printer checks. It also allows the user to view the
#	   queue's of the printers


# Declare Specified Printers
EB="eb325bw1 eb325bw2 eb423bw1"
FAB="fab5517bw1 fab5517bw2 fab6001bw1 fab6019bw1 fab8201bw1"
EBFAB="$EB $FAB"
QUEUE="$EBFAB"

# Function To Fill File To Print
randfill()
{
	for i in {1..63}
	do
		CHAR="[:graph:]"
		cat /dev/urandom | tr -cd "$CHAR" | head -c ${1:-80} >> pagePrint
	done
	fold pagePrint >> temp
	mv temp pagePrint
}
# Prepare File For Print
echo "Loading. Please Wait"
randfill
# Prompt For Selection
echo "Please Specify Printers"
echo "EB for Engineering Building Printers"
echo "FAB for Fourth Ave. Building Printers"
echo "EBFAB for both of the above"
echo "QUEUE for Printer Status"
echo "REM for Remote Connection"

# Loop For Input
q=0;
while [ $q != 1 ]
do
	# Read In Selection
	read selection;
	# Print
	case "$selection" in
		EB | [eE][bB] )
			# Print To EB Printers
			for i in $EB
			do
				head -n -1 pagePrint > temp
				mv temp pagePrint
				echo -n "CAT PRINTER TEST | Printer: $i | User: hawkinst | Handle: Marashni" >> pagePrint
				lpr -P $i pagePrint
				echo "Test Page Sent To $i"
			done
			q=1;

		;;
		FAB | [fF][aA][bB] )
			# Print To FAB Printers
			for i in $FAB
			do
				head -n -1 pagePrint > temp
				mv temp pagePrint
				echo -n "CAT PRINTER TEST | Printer: $i | User: hawkinst | Handle: Marashni" >> pagePrint
				lpr -P $i pagePrint
				echo "Test Page Sent To $i"
			done
			q=1;
		;;
		EBFAB | [eE][bB][fF][aA][bB] )
			# Print to EBFAB Printers
			for i in $EBFAB
			do
				head -n -1 pagePrint > temp
				mv temp pagePrint
				echo -n "CAT PRINTER TEST | Printer: $i | User: hawkinst | Handle: Marashni" >> pagePrint
				lpr -P $i pagePrint
				echo "Test Page Sent To $i"
			done
			q=1;
		;;
		QUEUE | [qQ][uU][eE][uU][eE] )
			# Check Printer Queue
			for i in $QUEUE
			do
				lpq -P $i
			done
			q=1;
		;;
		REM | [rR][eE][mM] )
			# Open Remote Connection To Windows
			rdesktop ts.cecs.pdx.edu
			exit 0;
		;;
		DEV | [dD][eE][vV] )
			# For Testing Purposes
			counter=0;
			for i in  $QUEUE
			do
				head -n -1 pagePrint > temp
				mv temp pagePrint
				echo -n "CAT PRINTER TEST | Printer: $i | User: hawkinst | Handle: Marashni" >> pagePrint
				cat pagePrint > testPage"$counter"
				echo "Test Page Sent To $i"
				counter=$((counter+1));
			done
			q=1;
		;;
		*)
			# Invalid Input
			echo "Invalid Input"
			echo "Please Specify Printers"
			echo "EB For Engineering Building Printers"
			echo "FAB For Fourth Ave. Building Printers"
			echo "EBFAB For Both Of The Above"
			echo "QUEUE For	Printer Status"
			echo "MSQUEUE For Remote Connection"
		;;
	esac
done
# Remove Temporary File
rm pagePrint

