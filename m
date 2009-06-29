Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5TCx7ZW131405 for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 07:59:08 -0500
Received: from mail51.messagelabs.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B2AB412612C8
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 05:59:37 -0700 (PDT)
Received: from mail51.messagelabs.com (mail51.messagelabs.com [216.82.241.99])
	by cuda.sgi.com with SMTP id MgVEmgyZseeE821u for
	<xfs@oss.sgi.com>; Mon, 29 Jun 2009 05:59:37 -0700 (PDT)
MIME-Version: 1.0
Subject: Correct usage of inode64/running out of inodes
Message-ID: <OF97A83ACB.604AE440-ON862575E4.00450F9F-862575E4.00475C94@genco.com>
From: Adam Donald <Adam.Donald@gencopharma.com>
Date: Mon, 29 Jun 2009 07:59:33 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3691193767931765803=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multipart message in MIME format.
--===============3691193767931765803==
Content-Type: multipart/alternative; boundary="=_alternative 00475C92862575E4_="

This is a multipart message in MIME format.
--=_alternative 00475C92862575E4_=
Content-Type: text/plain; charset="US-ASCII"

Hello

In short, I believe that I have used the indode64 option correctly in 
mounting my XFS device on my Centos 5.2 system, however, I seem to only 
have 59 free inodes available and 7.5TB of free space.  I would appreciate 
any insight as to what the best approach would be to fix this situation. 
In case it is helpful, I have included output from various commands/files 
below, the XFS device in question is /dev/mapper/VolGroup01-DATA01.  Thank 
you in advance for your assistance!

uname:
Linux NAS01 2.6.18-92.1.6.el5 #1 SMP Wed Jun 25 13:45:47 EDT 2008 x86_64 
x86_64 x86_64 GNU/Linux

df -h:
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00 71G   12G   55G  18% /
/dev/sda1              99M   25M   70M  26% /boot
tmpfs                    3.9G     0  3.9G   0% /dev/shm
/dev/mapper/VolGroup01-DATA01   18T  9.9T  7.5T  57% /DATA01

df -ih:
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/VolGroup00-LogVol00 19M    123K     19M    1% /
/dev/sda1                26K      44     26K    1% /boot
tmpfs                    999K       1    999K    1% /dev/shm
/dev/mapper/VolGroup01-DATA01   18G    297K     18G    1% /DATA01

mount:
...
/dev/mapper/VolGroup01-DATA01 on /DATA01 type xfs (rw,inode64)
...

fstab:
...
/dev/VolGroup01/DATA01  /DATA01                 xfs 
rw,suid,dev,exec,auto,nouser,async,inode64      1 0
...

/usr/sbin/xfs_db -r -c sb -c p /dev/mapper/VolGroup01-DATA01:
magicnum = 0x58465342
blocksize = 4096
dblocks = 4638613504
rblocks = 0
rextents = 0
uuid = 2dc65efd-97e9-429f-a9bd-530bd86eac23
logstart = 4294967300
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 144956672
agcount = 32
rbmblocks = 0
logblocks = 32768
versionnum = 0x3094
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 28
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 303360
ifree = 59
fdblocks = 2001250945
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0

______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
--=_alternative 00475C92862575E4_=
Content-Type: text/html; charset="US-ASCII"


<br><font size=2 face="sans-serif">Hello</font>
<br>
<br><font size=2 face="sans-serif">In short, I believe that I have used
the indode64 option correctly in mounting my XFS device on my Centos 5.2
system, however, I seem to only have 59 free inodes available and 7.5TB
of free space. &nbsp;I would appreciate any insight as to what the best
approach would be to fix this situation. &nbsp;In case it is helpful, I
have included output from various commands/files below, the XFS device
in question is /dev/mapper/VolGroup01-DATA01. &nbsp;Thank you in advance
for your assistance!</font>
<br>
<br><font size=2 face="sans-serif">uname:</font>
<br><font size=2 face="sans-serif">Linux NAS01 2.6.18-92.1.6.el5 #1 SMP
Wed Jun 25 13:45:47 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux</font>
<br>
<br><font size=2 face="sans-serif">df -h:</font>
<br><font size=2 face="sans-serif">Filesystem &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;Size &nbsp;Used Avail Use% Mounted on</font>
<br><font size=2 face="sans-serif">/dev/mapper/VolGroup00-LogVol00 &nbsp;
&nbsp; &nbsp; &nbsp;71G &nbsp; 12G &nbsp; 55G &nbsp;18% /</font>
<br><font size=2 face="sans-serif">/dev/sda1 &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp;99M &nbsp; 25M &nbsp; 70M &nbsp;26% /boot</font>
<br><font size=2 face="sans-serif">tmpfs &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3.9G &nbsp; &nbsp;
0 &nbsp;3.9G &nbsp; 0% /dev/shm</font>
<br><font size=2 face="sans-serif">/dev/mapper/VolGroup01-DATA01 &nbsp;
&nbsp; &nbsp; &nbsp;18T &nbsp;9.9T &nbsp;7.5T &nbsp;57% /DATA01</font>
<br>
<br><font size=2 face="sans-serif">df -ih:</font>
<br><font size=2 face="sans-serif">Filesystem &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;Inodes &nbsp; IUsed &nbsp; IFree IUse% Mounted on</font>
<br><font size=2 face="sans-serif">/dev/mapper/VolGroup00-LogVol00 &nbsp;
&nbsp; &nbsp; &nbsp;19M &nbsp; &nbsp;123K &nbsp; &nbsp; 19M &nbsp;
&nbsp;1% /</font>
<br><font size=2 face="sans-serif">/dev/sda1 &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp;26K &nbsp; &nbsp; &nbsp;44 &nbsp; &nbsp; 26K
&nbsp; &nbsp;1% /boot</font>
<br><font size=2 face="sans-serif">tmpfs &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 999K &nbsp;
&nbsp; &nbsp; 1 &nbsp; &nbsp;999K &nbsp; &nbsp;1% /dev/shm</font>
<br><font size=2 face="sans-serif">/dev/mapper/VolGroup01-DATA01 &nbsp;
&nbsp; &nbsp; &nbsp;18G &nbsp; &nbsp;297K &nbsp; &nbsp; 18G &nbsp;
&nbsp;1% /DATA01</font>
<br>
<br><font size=2 face="sans-serif">mount:</font>
<br><font size=2 face="sans-serif">...</font>
<br><font size=2 face="sans-serif">/dev/mapper/VolGroup01-DATA01 on /DATA01
type xfs (rw,inode64)</font>
<br><font size=2 face="sans-serif">...</font>
<br>
<br><font size=2 face="sans-serif">fstab:</font>
<br><font size=2 face="sans-serif">...</font>
<br><font size=2 face="sans-serif">/dev/VolGroup01/DATA01 &nbsp;/DATA01
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs &nbsp; &nbsp;
rw,suid,dev,exec,auto,nouser,async,inode64 &nbsp; &nbsp; &nbsp;1 0</font>
<br><font size=2 face="sans-serif">...</font>
<br>
<br><font size=2 face="sans-serif">/usr/sbin/xfs_db -r -c sb -c p /dev/mapper/VolGroup01-DATA01:</font>
<br><font size=2 face="sans-serif">magicnum = 0x58465342</font>
<br><font size=2 face="sans-serif">blocksize = 4096</font>
<br><font size=2 face="sans-serif">dblocks = 4638613504</font>
<br><font size=2 face="sans-serif">rblocks = 0</font>
<br><font size=2 face="sans-serif">rextents = 0</font>
<br><font size=2 face="sans-serif">uuid = 2dc65efd-97e9-429f-a9bd-530bd86eac23</font>
<br><font size=2 face="sans-serif">logstart = 4294967300</font>
<br><font size=2 face="sans-serif">rootino = 128</font>
<br><font size=2 face="sans-serif">rbmino = 129</font>
<br><font size=2 face="sans-serif">rsumino = 130</font>
<br><font size=2 face="sans-serif">rextsize = 1</font>
<br><font size=2 face="sans-serif">agblocks = 144956672</font>
<br><font size=2 face="sans-serif">agcount = 32</font>
<br><font size=2 face="sans-serif">rbmblocks = 0</font>
<br><font size=2 face="sans-serif">logblocks = 32768</font>
<br><font size=2 face="sans-serif">versionnum = 0x3094</font>
<br><font size=2 face="sans-serif">sectsize = 512</font>
<br><font size=2 face="sans-serif">inodesize = 256</font>
<br><font size=2 face="sans-serif">inopblock = 16</font>
<br><font size=2 face="sans-serif">fname = &quot;\000\000\000\000\000\000\000\000\000\000\000\000&quot;</font>
<br><font size=2 face="sans-serif">blocklog = 12</font>
<br><font size=2 face="sans-serif">sectlog = 9</font>
<br><font size=2 face="sans-serif">inodelog = 8</font>
<br><font size=2 face="sans-serif">inopblog = 4</font>
<br><font size=2 face="sans-serif">agblklog = 28</font>
<br><font size=2 face="sans-serif">rextslog = 0</font>
<br><font size=2 face="sans-serif">inprogress = 0</font>
<br><font size=2 face="sans-serif">imax_pct = 25</font>
<br><font size=2 face="sans-serif">icount = 303360</font>
<br><font size=2 face="sans-serif">ifree = 59</font>
<br><font size=2 face="sans-serif">fdblocks = 2001250945</font>
<br><font size=2 face="sans-serif">frextents = 0</font>
<br><font size=2 face="sans-serif">uquotino = 0</font>
<br><font size=2 face="sans-serif">gquotino = 0</font>
<br><font size=2 face="sans-serif">qflags = 0</font>
<br><font size=2 face="sans-serif">flags = 0</font>
<br><font size=2 face="sans-serif">shared_vn = 0</font>
<br><font size=2 face="sans-serif">inoalignmt = 2</font>
<br><font size=2 face="sans-serif">unit = 0</font>
<br><font size=2 face="sans-serif">width = 0</font>
<br><font size=2 face="sans-serif">dirblklog = 0</font>
<br><font size=2 face="sans-serif">logsectlog = 0</font>
<br><font size=2 face="sans-serif">logsectsize = 0</font>
<br><font size=2 face="sans-serif">logsunit = 0</font>
<br><font size=2 face="sans-serif">features2 = 0</font>

<BR>
______________________________________________________________________<BR>
This email has been scanned by the MessageLabs Email Security System.<BR>
For more information please visit http://www.messagelabs.com/email <BR>
______________________________________________________________________<BR>

--=_alternative 00475C92862575E4_=--


--===============3691193767931765803==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3691193767931765803==--
