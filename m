Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 09F327F80
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 02:30:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EAE218F8035
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 00:30:27 -0700 (PDT)
Received: from na01-bn1-obe.outbound.protection.outlook.com
	(mail-bn1on0117.outbound.protection.outlook.com
	[157.56.110.117]) by cuda.sgi.com with ESMTP id
	DNmXxuPn36o54qZw (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 00:30:25 -0700 (PDT)
From: Simon Dray <sdray@Espial.com>
Subject: XFS issue xfs goes offline with various messages drive not
	recoverable without reboot
Date: Thu, 25 Sep 2014 07:30:23 +0000
Message-ID: <dd6d1d6e9fa7469584e72574347bb088@BN1PR0301MB0625.namprd03.prod.outlook.com>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6668784180750477343=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6668784180750477343==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_dd6d1d6e9fa7469584e72574347bb088BN1PR0301MB0625namprd03_"

--_000_dd6d1d6e9fa7469584e72574347bb088BN1PR0301MB0625namprd03_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Dear Sirs

I wonder if you can help with an issue we see re-occuring on a regular basi=
s with one of our HP systems which uses a HP 420 Raid controller

Action taken

We first saw the following:
[root@ content]# ls
ls: cannot open directory .: Input/output error


[root@ /]# ls -ltr
ls: cannot access content
total 358
d?????????? ? ? ? ? ? content
drwxr-xr-x. 2 root root 4096 Jun 28 2011 srv
drwxr-xr-x. 2 root root 4096 Jun 28 2011 media
drwxr-xr-x. 2 root root 4096 Feb 22 2012 cgroup
drwx------. 2 root root 16384 Jul 21 2012 lost+found
drwxr-xr-x. 2 root root 4096 Jul 21 2012 selinux

We try to run:
[root@ /]# xfs_check /dev/md0
xfs_check: /dev/md0 contains a mounted and writable filesystem
fatal error -- couldn't initialize XFS library
We also tried to umount the /dev/md0 before runniing xfs_check but no luck.=
 We received the error: device is in use

We use xfs for one of our large raid file systems and we are seeing the xfs=
 filesystem go offline with the following messages in dmesg

messages-20140921:Sep 18 23:01: kernel: XFS (md0): Device md0: metadata wri=
te error block 0x5e28623d8
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): I/O error occurred: me=
ta-data dev md0 block 0x445cccc40 ("xlog_iodone") error 5 buf count 32768
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_do_force_shutdown(=
0x2) called from line 891 of file fs/xfs/xfs_log.c. Return address =3D 0xff=
ffffffa2c428dc
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): Log I/O Error Detected=
. Shutting down filesystem
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): Please umount the file=
system and rectify the problem(s)
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_imap_to_bp: xfs_tr=
ans_read_buf() returned error 5.
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_iunlink_remove: xf=
s_itobp() returned error 5.
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): I/O error occurred: me=
ta-data dev md0 block 0x445cccc80 ("xlog_iodone") error 5 buf count 32768
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_do_force_shutdown(=
0x2) called from line 891 of file fs/xfs/xfs_log.c. Return address =3D 0xff=
ffffffa2c428dc

XFS (md0): xfs_log_force: error 5 returned.
XFS (md0): xfs_log_force: error 5 returned.
XFS (md0): xfs_log_force: error 5 returned.

In all occurrences the only way to recover from this is to reboot the syste=
m and allow xfs_repair to run during boot this clears the issue until next =
time

We have checked the RAID health and nothing seems to be amiss, if you could=
 help with this it would be much appreciated


Best regards Simon


Simon Dray *

p: +44.1223 716.400
p: +44.1223 716.476
e: sdray@espial.com

1st Floor, 335 Cambridge Science Park, Milton Road, Cambridge, Cambridgeshi=
re, CB4 0WN, United Kingdom.

Understanding is a three-edged sword


--_000_dd6d1d6e9fa7469584e72574347bb088BN1PR0301MB0625namprd03_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 12 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Corbel;
	panose-1:2 11 5 3 2 2 4 2 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-GB" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Dear Sirs <o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I wonder if you can help with an issue we see re-occ=
uring on a regular basis with one of our HP systems which uses a HP 420 Rai=
d controller
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Action taken <o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">We first saw the following: <br>
[root@ content]# ls <br>
ls: cannot open directory .: Input/output error <br>
<br>
<br>
[root@ /]# ls -ltr <br>
ls: cannot access content <br>
total 358 <br>
d?????????? ? ? ? ? ? content <br>
drwxr-xr-x. 2 root root 4096 Jun 28 2011 srv <br>
drwxr-xr-x. 2 root root 4096 Jun 28 2011 media <br>
drwxr-xr-x. 2 root root 4096 Feb 22 2012 cgroup <br>
drwx------. 2 root root 16384 Jul 21 2012 lost&#43;found <br>
drwxr-xr-x. 2 root root 4096 Jul 21 2012 selinux <br>
<br>
We try to run: <br>
[root@ /]# xfs_check /dev/md0 <br>
xfs_check: /dev/md0 contains a mounted and writable filesystem <br>
fatal error -- couldn't initialize XFS library <br>
We also tried to umount the /dev/md0 before runniing xfs_check but no luck.=
 We received the error: device is in use<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">We use xfs for one of our large raid file systems an=
d we are seeing the xfs filesystem go offline with the following messages i=
n dmesg
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">messages-20140921:Sep 18 23:01: kernel: XFS (md0): D=
evice md0: metadata write error block 0x5e28623d8
<br>
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): I/O error occurred: me=
ta-data dev md0 block 0x445cccc40 (&quot;xlog_iodone&quot;) error 5 buf cou=
nt 32768
<br>
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_do_force_shutdown(=
0x2) called from line 891 of file fs/xfs/xfs_log.c. Return address =3D 0xff=
ffffffa2c428dc
<br>
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): Log I/O Error Detected=
. Shutting down filesystem
<br>
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): Please umount the file=
system and rectify the problem(s)
<br>
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_imap_to_bp: xfs_tr=
ans_read_buf() returned error 5.
<br>
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_iunlink_remove: xf=
s_itobp() returned error 5.
<br>
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): I/O error occurred: me=
ta-data dev md0 block 0x445cccc80 (&quot;xlog_iodone&quot;) error 5 buf cou=
nt 32768
<br>
messages-20140921:Sep 18 23:01:04 kernel: XFS (md0): xfs_do_force_shutdown(=
0x2) called from line 891 of file fs/xfs/xfs_log.c. Return address =3D 0xff=
ffffffa2c428dc<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">XFS (md0): xfs_log_force: error 5 returned. <br>
XFS (md0): xfs_log_force: error 5 returned. <br>
XFS (md0): xfs_log_force: error 5 returned.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">In all occurrences the only way to recover from this=
 is to reboot the system and allow xfs_repair to run during boot this clear=
s the issue until next time
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">We have checked the RAID health and nothing seems to=
 be amiss, if you could help with this it would be much appreciated
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Best regards Simon <o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><b><span lang=3D"EN-CA" style=3D"font-family:&quot;A=
rial&quot;,&quot;sans-serif&quot;"><o:p>&nbsp;</o:p></span></b></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA" style=3D"font-size:10.0pt;font-=
family:&quot;Arial&quot;,&quot;sans-serif&quot;">Simon Dray
</span><span lang=3D"EN-CA" style=3D"font-size:10.0pt;font-family:Wingdings=
">s</span><span lang=3D"EN-CA" style=3D"font-size:10.0pt;font-family:&quot;=
Arial&quot;,&quot;sans-serif&quot;">
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA" style=3D"font-size:10.0pt;font-=
family:&quot;Arial&quot;,&quot;sans-serif&quot;"><o:p>&nbsp;</o:p></span></=
p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA" style=3D"font-size:10.0pt;font-=
family:&quot;Arial&quot;,&quot;sans-serif&quot;">p: &#43;44.1223 716.400<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA" style=3D"font-size:10.0pt;font-=
family:&quot;Arial&quot;,&quot;sans-serif&quot;">p: &#43;44.1223 716.476
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA" style=3D"font-size:10.0pt;font-=
family:&quot;Arial&quot;,&quot;sans-serif&quot;">e: sdray@espial.com
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-bottom:12.0pt"><span style=3D"font-s=
ize:8.0pt;font-family:&quot;Corbel&quot;,&quot;sans-serif&quot;"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Ar=
ial&quot;,&quot;sans-serif&quot;">1st Floor, 335 Cambridge Science Park, Mi=
lton Road, Cambridge, Cambridgeshire, CB4 0WN, United Kingdom.
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Ar=
ial&quot;,&quot;sans-serif&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-bottom:12.0pt"><span style=3D"font-s=
ize:8.0pt;font-family:&quot;Corbel&quot;,&quot;sans-serif&quot;">Understand=
ing is a three-edged sword</span><span style=3D"font-size:8.0pt;font-family=
:&quot;Corbel&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_dd6d1d6e9fa7469584e72574347bb088BN1PR0301MB0625namprd03_--


--===============6668784180750477343==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6668784180750477343==--
