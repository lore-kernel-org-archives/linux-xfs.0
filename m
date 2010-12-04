Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB40fgiI114194 for <xfs@oss.sgi.com>; Fri, 3 Dec 2010 18:41:42 -0600
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32E021410F8D
	for <xfs@oss.sgi.com>; Fri,  3 Dec 2010 16:43:24 -0800 (PST)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id ZSEDVQmgV7tOxMTi for
	<xfs@oss.sgi.com>; Fri, 03 Dec 2010 16:43:24 -0800 (PST)
Subject: Re: xfs_repair of critical volume
Mime-Version: 1.0 (Apple Message framework v1082)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <201012021233.07213@zmi.at>
Date: Fri, 3 Dec 2010 16:43:08 -0800
Message-Id: <86C6F4CD-B39B-4702-80E7-350A363D5F55@ucsc.edu>
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<20101117074708.GP22876@dastard>
	<BA70F631-15CB-4E52-913A-3715CC9678A0@ucsc.edu>
	<201012021233.07213@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2549657022117986853=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com


--===============2549657022117986853==
Content-Type: multipart/alternative; boundary=Apple-Mail-2--416424039


--Apple-Mail-2--416424039
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1


On Dec 2, 2010, at 3:33 AM, Michael Monnerie wrote:

> On Dienstag, 30. November 2010 Eli Morris wrote:
>> Thanks for your help with this. I wrote the program and ran it
>> through and it looks like we have we able to preserve 44 TB of valid
>> data, while removing the corrupted files, which is a great result,
>> considering the circumstances.=20
>=20
> Eli, could you post the relevant program here so others can use it if=20=

> needed? There are requests from time to time, and it would be good if=20=

> such a program were available (like I'm sure you'd been happy if it=20
> already existed the time you needed it).
>=20
> Thanks, and wow: what an amazing filesystem can recover such an event!
>=20
> --=20
> mit freundlichen Gr=FCssen,
> Michael Monnerie, Ing. BSc
>=20
> it-management Internet Services: Prot=E9ger
> http://proteger.at [gesprochen: Prot-e-schee]
> Tel: +43 660 / 415 6531
>=20
> // ****** Radiointerview zum Thema Spam ******
> // http://www.it-podcast.at/archiv.html#podcast-100716
> //=20
> // Haus zu verkaufen: http://zmi.at/langegg/


Good idea, here is the program:

Eli

#!/bin/bash
#=20
#    Copyright 2010 Eli Morris, Travis O'Brien, University of California=20=

#=20
#    remove_bad.sh is free software: you can redistribute it under the  =
terms
#    of the GNU General Public License as published by the Free Software
#    Foundation, either version 3 of the License, or (at your option) =
any later
#    version.=20
#=20
#    This program is distributed in the hope that it will be useful, but
#    WITHOUT ANY WARRANTY; without even the implied warranty of =
MERCHANTABILITY
#    or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public =
License
#    for more details.=20
#=20
#    You should have received a copy of the GNU General Public License =
along
#    with this program.  If not, see <http://www.gnu.org/licenses/>.=20
#
#
#remove_bad.sh: A script to determine whether any part of a file falls =
within a
#set of blocks (indicated by arguments 1 and 2).  This script is
#originally written with the intent to find files on a file system that
#exist(ed) on a corrupt section of the file system.  It generates a list =
of files
#that are potentially bad, so that they can be removed by another =
script.
#

#Check command line arguments; grab arguments 1 and 2
if [ $# -eq 2 ]; then
	BAD_BLOCK_BEGINNING=3D$1
	BAD_BLOCK_END=3D$2
	echo "bad block beginning $BAD_BLOCK_BEGINNING"
	echo "bad block ending $BAD_BLOCK_END"
#if there aren't exactly 2 arguments then print the usage to the user
else
	echo "usage: remove_bad.sh beginning_block ending_block"
	exit
fi

remove file from last run
if ( test -e "./naughty_list.txt")=20
then
	echo "removing the previous naughty list"
	rm "./naughty_list.txt"
fi

IFS=3D$'\n' #set the field separator to the carriage return character
ALL_FILES=3D(`find /export/vol5 -type f`) #A list of all files on the =
volume, SUBSTITUTE NAME OF YOUR VOLUME
NUM_FILES=3D${#ALL_FILES[@]} #The number of files on the volume
echo "number of files is $NUM_FILES" #Report the number of files to the =
user

# for each of the file in vol5
for (( COUNT=3D0; COUNT<$NUM_FILES; COUNT++))
do
    	#Report which file is being worked on
	echo "file number: $COUNT is ${ALL_FILES[$COUNT]}"

	# report number of files to go
	FILES_TO_GO=3D$((NUM_FILES-COUNT))
	echo "files left: $FILES_TO_GO"=20

    	#Run xfs_bmap to get the blocks that the file lives within
	OUTPUT=3D(`xfs_bmap ${ALL_FILES[$COUNT]}`)
	# output looks like this
	# vol5dump:
	# 0: [0..1053271]: 5200578944..5201632215

	BAD_FILE=3D0 #Initialize the bad file flag
	NUM_LINES=3D${#OUTPUT[@]} #The number of lines from xfs_bmap

	# echo "number of lines for file: $NUM_LINES" #Report the number =
of lines to the user
    	#Loop through each line
	for (( LINE=3D1; LINE < $NUM_LINES; LINE++))
	do
		# echo "line number $LINE: output: ${OUTPUT[$LINE]}" =
#Report the current working line

		# get the block range from the line
		BLOCKS=3D`echo ${OUTPUT[$LINE]} | cut -d':' -f3`

       	 	#Report the number of blocks occupied
		# echo "blocks after cut: '$BLOCKS'"=20
        	#Use cut to get the first and last block for the file
		FIRST_BLOCK=3D`echo $BLOCKS | cut -d'.' -f1`=20
		LAST_BLOCK=3D`echo $BLOCKS | cut -d'.' -f3`
	=09
        	#Report these to the user
		# echo "beginning block: $FIRST_BLOCK"
		# echo "ending block: $LAST_BLOCK"

		#TODO: I'm not sure what exactly 'hole' means, but I get =
the impression that it has something
		#to do with XFS's way of avoiding file fragmentation. =
TAO
		if [ "$BLOCKS" !=3D " hole" ]; then  #Don't deal with =
lines that report 'hole'
			# compare to bad block region
			#For now, check whether the blocks for the file =
fall within the user-given block range
			#if any of the blocks do, then mark this file as =
bad.

		  	if ( (( "$BAD_BLOCK_BEGINNING" <=3D =
"$FIRST_BLOCK")) && (( "$FIRST_BLOCK" <=3D "$BAD_BLOCK_END")) ); then
				  # echo "hit first criterium"
				  BAD_FILE=3D1
				  break
		  	elif ( (( "$BAD_BLOCK_BEGINNING" <=3D =
"$LAST_BLOCK")) && (( "$LAST_BLOCK" <=3D "$BAD_BLOCK_END")) ); then
				  # echo "hit second criterium"
				  BAD_FILE=3D1
				  break
		  	fi
		fi
	done
	# add the file to the list of bad files
	if (($BAD_FILE =3D=3D 1)); then
                #Report to the user that the current file is bad
		echo "putting file: ${ALL_FILES[$COUNT]} on the naughty =
list"
                #Write the file's name to the list
		echo "${ALL_FILES[$COUNT]}" >> naughty_list.txt
	fi
done
echo "program_ended_succesfully" >> naughty_list.txt


--Apple-Mail-2--416424039
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=iso-8859-1

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><br><div><div>On Dec 2, 2010, at 3:33 AM, Michael Monnerie =
wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><div>On Dienstag, 30. November 2010 Eli Morris =
wrote:<br><blockquote type=3D"cite">Thanks for your help with this. I =
wrote the program and ran it<br></blockquote><blockquote =
type=3D"cite">through and it looks like we have we able to preserve 44 =
TB of valid<br></blockquote><blockquote type=3D"cite">data, while =
removing the corrupted files, which is a great =
result,<br></blockquote><blockquote type=3D"cite">considering the =
circumstances. <br></blockquote><br>Eli, could you post the relevant =
program here so others can use it if <br>needed? There are requests from =
time to time, and it would be good if <br>such a program were available =
(like I'm sure you'd been happy if it <br>already existed the time you =
needed it).<br><br>Thanks, and wow: what an amazing filesystem can =
recover such an event!<br><br>-- <br>mit freundlichen =
Gr=FCssen,<br>Michael Monnerie, Ing. BSc<br><br>it-management Internet =
Services: Prot=E9ger<br><a =
href=3D"http://proteger.at">http://proteger.at</a> [gesprochen: =
Prot-e-schee]<br>Tel: +43 660 / 415 6531<br><br>// ****** Radiointerview =
zum Thema Spam ******<br>// <a =
href=3D"http://www.it-podcast.at/archiv.html#podcast-100716">http://www.it=
-podcast.at/archiv.html#podcast-100716</a><br>// <br>// Haus zu =
verkaufen: <a =
href=3D"http://zmi.at/langegg/">http://zmi.at/langegg/</a><br></div></bloc=
kquote></div><br><div><br></div><div>Good idea, here is the =
program:</div><div><br></div><div>Eli</div><div><br></div><div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#!/bin/bash</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); =
">#&nbsp;</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); ">#&nbsp; &nbsp; Copyright =
2010 Eli Morris, Travis O'Brien, University of =
California&nbsp;</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); ">#&nbsp;</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#&nbsp; &nbsp; remove_bad.sh is free software: you can =
redistribute it under the&nbsp; terms</div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; color: rgb(0, 139, 0); ">#&nbsp; =
&nbsp; of the GNU General Public License as published by the Free =
Software</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); ">#&nbsp; &nbsp; Foundation, =
either version 3 of the License, or (at your option) any later</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#&nbsp; &nbsp; version.&nbsp;</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#&nbsp;</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); ">#&nbsp; &nbsp; =
This program is distributed in the hope that it will be useful, =
but</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); ">#&nbsp; &nbsp; WITHOUT ANY =
WARRANTY; without even the implied warranty of MERCHANTABILITY</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#&nbsp; &nbsp; or FITNESS FOR A PARTICULAR =
PURPOSE.&nbsp; See the GNU General Public License</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#&nbsp; &nbsp; for more details.&nbsp;</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#&nbsp;</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); ">#&nbsp; &nbsp; =
You should have received a copy of the GNU General Public License =
along</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); ">#&nbsp; &nbsp; with this =
program.&nbsp; If not, see &lt;<a =
href=3D"http://www.gnu.org/licenses/"><span style=3D"color: =
#1f00ff">http://www.gnu.org/licenses/</span></a>&gt;.&nbsp;</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); ">#</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#remove_bad.sh: A script to determine whether any part =
of a file falls within a</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); ">#set of blocks =
(indicated by arguments 1 and 2).&nbsp; This script is</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#originally written with the intent to find files on a =
file system that</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); ">#exist(ed) on a corrupt =
section of the file system.&nbsp; It generates a list of files</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#that are potentially bad, so that they can be removed =
by another script.</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); ">#</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; =
min-height: 13px; "><br></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); ">#Check command =
line arguments; grab arguments 1 and 2</div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; "><span style=3D"color: =
#c800a3">if</span> [ $# -eq <span style=3D"color: #2f00dd">2</span> ]; =
<span style=3D"color: #c800a3">then</span></div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; "><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>BAD_BLOCK_BEGINNING=3D$<span =
style=3D"color: #2f00dd">1</span></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; "><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>BAD_BLOCK_END=3D$<span =
style=3D"color: #2f00dd">2</span></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(224, 0, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>echo </span>"bad block beginning =
$BAD_BLOCK_BEGINNING"</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(224, 0, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>echo </span>"bad block ending $BAD_BLOCK_END"</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); ">#if there aren't exactly 2 arguments then print the =
usage to the user</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(200, 0, 163); ">else</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(224, 0, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>echo =
</span>"usage: remove_bad.sh beginning_block ending_block"</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(200, 0, 163); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span>exit</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(200, 0, 163); ">fi</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; =
min-height: 13px; "><br></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; ">remove file from last run</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(224, 0, 0); "><span style=3D"color: #c800a3">if</span><span =
style=3D"color: #000000"> ( test -e </span>"./naughty_list.txt"<span =
style=3D"color: #000000">)&nbsp;</span></div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; color: rgb(200, 0, 163); =
">then</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(224, 0, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>echo </span>"removing the previous naughty list"</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(224, 0, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>rm =
</span>"./naughty_list.txt"</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(200, 0, 163); ">fi</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; =
min-height: 13px; "><br></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000">IFS=3D$</span><span style=3D"color: =
#e00000">'\n'</span><span style=3D"color: #000000"> </span>#set the =
field separator to the carriage return character</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "><span style=3D"color: #000000">ALL_FILES=3D(</span><span=
 style=3D"color: #e00000">`find /export/vol5 -type f`</span><span =
style=3D"color: #000000">) </span>#A list of all files on the volume, =
SUBSTITUTE NAME OF YOUR VOLUME</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000">NUM_FILES=3D${</span>#ALL_FILES[@]} #The number =
of files on the volume</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000">echo </span><span style=3D"color: #e00000">"number of files is =
$NUM_FILES"</span><span style=3D"color: #000000"> </span>#Report the =
number of files to the user</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; min-height: 13px; "><br></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "># for each of the file in vol5</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; "><span =
style=3D"color: #c800a3">for</span> (( COUNT=3D<span style=3D"color: =
#2f00dd">0</span>; COUNT&lt;$NUM_FILES; COUNT++))</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(200, 0, 163); ">do</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000">&nbsp; &nbsp; <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></span>#Report which file is =
being worked on</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(224, 0, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>echo </span>"file number: $COUNT is =
${ALL_FILES[$COUNT]}"</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; min-height: 13px; "><br></div><div style=3D"margin-top:=
 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></span># report number of files =
to go</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; "><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>FILES_TO_GO=3D$((NUM_FILES-COUNT))</div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; color: rgb(224, 0, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>echo </span>"files left: =
$FILES_TO_GO"<span style=3D"color: #000000">&nbsp;</span></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; =
min-height: 13px; "><br></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000">&nbsp; &nbsp; <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></span>#Run xfs_bmap to get the =
blocks that the file lives within</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(224, 0, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>OUTPUT=3D(</span>`xfs_bmap =
${ALL_FILES[$COUNT]}`<span style=3D"color: #000000">)</span></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span></span># =
output looks like this</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span># vol5dump:</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></span># 0: [0..1053271]: =
5200578944..5201632215</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; min-height: 13px; "><br></div><div style=3D"margin-top:=
 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>BAD_FILE=3D</span><span =
style=3D"color: #2f00dd">0</span><span style=3D"color: #000000"> =
</span>#Initialize the bad file flag</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>NUM_LINES=3D${</span>#OUTPUT[@]} =
#The number of lines from xfs_bmap</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; min-height: 13px; "><br></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span></span># =
echo "number of lines for file: $NUM_LINES" #Report the number of lines =
to the user</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000">&nbsp; &nbsp; <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></span>#Loop through each =
line</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; "><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span style=3D"color: =
#c800a3">for</span> (( LINE=3D<span style=3D"color: #2f00dd">1</span>; =
LINE &lt; $NUM_LINES; LINE++))</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(200, 0, 163); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></span>do</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span></span># echo "line number $LINE: output: ${OUTPUT[$LINE]}" =
#Report the current working line</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; min-height: 13px; "><br></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span></span># get the block range from the line</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(224, 0, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span>BLOCKS=3D</span>`echo ${OUTPUT[$LINE]} | cut -d':' -f3`</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; =
min-height: 13px; "><br></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000">&nbsp; &nbsp; &nbsp; &nbsp;<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span>#Report the number of blocks occupied</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span></span># echo "blocks after cut: '$BLOCKS'"&nbsp;</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "><span style=3D"color: #000000">&nbsp; &nbsp; &nbsp; =
&nbsp; <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span>#Use cut to get the first and last block for the =
file</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(224, 0, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span>FIRST_BLOCK=3D</span>`echo $BLOCKS | cut -d'.' -f1`<span =
style=3D"color: #000000">&nbsp;</span></div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; color: rgb(224, 0, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">		</span>LAST_BLOCK=3D</span>`echo =
$BLOCKS | cut -d'.' -f3`</div><p style=3D"margin: 0.0px 0.0px 0.0px =
0.0px; font: 11.0px Menlo; min-height: 13.0px"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span><br class=3D"webkit-block-placeholder"></p><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "><span style=3D"color: #000000">&nbsp; &nbsp; &nbsp; =
&nbsp; <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span>#Report these to the user</div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">		</span></span># echo "beginning =
block: $FIRST_BLOCK"</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span></span># echo "ending block: $LAST_BLOCK"</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; =
min-height: 13px; "><br></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">		</span></span>#TODO: I'm not =
sure what exactly 'hole' means, but I get the impression that it has =
something</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span></span>#to do with XFS's way of avoiding file fragmentation. =
TAO</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span></span><span style=3D"color: #c800a3">if</span><span =
style=3D"color: #000000"> [ </span><span style=3D"color: =
#e00000">"$BLOCKS"</span><span style=3D"color: #000000"> !=3D =
</span><span style=3D"color: #e00000">" hole"</span><span style=3D"color: =
#000000"> ]; </span><span style=3D"color: #c800a3">then</span><span =
style=3D"color: #000000">&nbsp; </span>#Don't deal with lines that =
report 'hole'</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">		=
	</span></span># compare to bad block region</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(0, 139, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">			=
</span></span>#For now, check whether the blocks for the file fall =
within the user-given block range</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; color: rgb(0, 139, 0); "><span =
style=3D"color: #000000"><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">			</span></span>#if any of =
the blocks do, then mark this file as bad.</div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; min-height: 13px; =
"><br></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(224, 0, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span>&nbsp; <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span><span style=3D"color: #c800a3">if</span><span =
style=3D"color: #000000"> ( (( </span>"$BAD_BLOCK_BEGINNING"<span =
style=3D"color: #000000"> &lt;=3D </span>"$FIRST_BLOCK"<span =
style=3D"color: #000000">)) &amp;&amp; (( </span>"$FIRST_BLOCK"<span =
style=3D"color: #000000"> &lt;=3D </span>"$BAD_BLOCK_END"<span =
style=3D"color: #000000">)) ); </span><span style=3D"color: =
#c800a3">then</span></div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">		=
		</span>&nbsp; </span># echo "hit first =
criterium"</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; "><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">				</span>&nbsp; =
BAD_FILE=3D<span style=3D"color: #2f00dd">1</span></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; "><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">				=
</span>&nbsp; <span style=3D"color: #c800a3">break</span></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(224, 0, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span>&nbsp; <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span><span style=3D"color: #c800a3">elif</span><span =
style=3D"color: #000000"> ( (( </span>"$BAD_BLOCK_BEGINNING"<span =
style=3D"color: #000000"> &lt;=3D </span>"$LAST_BLOCK"<span =
style=3D"color: #000000">)) &amp;&amp; (( </span>"$LAST_BLOCK"<span =
style=3D"color: #000000"> &lt;=3D </span>"$BAD_BLOCK_END"<span =
style=3D"color: #000000">)) ); </span><span style=3D"color: =
#c800a3">then</span></div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">		=
		</span>&nbsp; </span># echo "hit second =
criterium"</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; "><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">				</span>&nbsp; =
BAD_FILE=3D<span style=3D"color: #2f00dd">1</span></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; "><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">				=
</span>&nbsp; <span style=3D"color: #c800a3">break</span></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; "><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span>&nbsp; <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span style=3D"color: #c800a3">fi</span></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; "><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span><span style=3D"color: #c800a3">fi</span></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(200, 0, 163); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span>done</div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span># add the file to the list of bad files</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; "><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
style=3D"color: #c800a3">if</span> (($BAD_FILE =3D=3D <span =
style=3D"color: #2f00dd">1</span>)); <span style=3D"color: =
#c800a3">then</span></div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
</span>#Report to the user that the current file is bad</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(224, 0, 0); "><span style=3D"color: #000000"><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">		=
</span>echo </span>"putting file: ${ALL_FILES[$COUNT]} on the naughty =
list"</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(0, 139, 0); "><span style=3D"color: =
#000000">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
</span>#Write the file's name to the list</div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: =
normal normal normal 11px/normal Menlo; "><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">		</span>echo <span style=3D"color: =
#e00000">"${ALL_FILES[$COUNT]}"</span> &gt;&gt; =
naughty_list.txt</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(200, 0, 163); "><span style=3D"color: =
#000000"><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></span>fi</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; font: normal normal normal =
11px/normal Menlo; color: rgb(200, 0, 163); ">done</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; font: normal normal normal 11px/normal Menlo; color: =
rgb(224, 0, 0); "><span style=3D"color: #000000">echo =
</span>"program_ended_succesfully"<span style=3D"color: #000000"> =
&gt;&gt; naughty_list.txt</span></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 11px/normal Menlo; min-height: 13px; =
"><br></div></div></body></html>=

--Apple-Mail-2--416424039--


--===============2549657022117986853==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2549657022117986853==--
