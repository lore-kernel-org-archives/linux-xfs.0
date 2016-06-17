Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DF787CA2
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 15:07:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA233AC001
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 13:07:44 -0700 (PDT)
Received: from mail1.bemta12.messagelabs.com (mail1.bemta12.messagelabs.com
	[216.82.251.8]) by cuda.sgi.com with ESMTP id wTvoVFPMnH2cNeYS
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 13:07:40 -0700 (PDT)
From: Benjamin Wirth <Benjamin.Wirth@winmagic.com>
Subject: on-disk free blocks B-Tree update
Date: Fri, 17 Jun 2016 20:02:59 +0000
Message-ID: <97A4F433DEE099488FE21C1718A641D213A0320A@wmsexchsvr02.winmagic.local>
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
Content-Type: multipart/mixed; boundary="===============1416872785594161155=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1416872785594161155==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_97A4F433DEE099488FE21C1718A641D213A0320Awmsexchsvr02win_"

--_000_97A4F433DEE099488FE21C1718A641D213A0320Awmsexchsvr02win_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello XFS community,

I have code that parses the free blocks B-Tree from the disk but it seems t=
o me that the on-disk version of the B-Tree is not updated even when sync()=
 is called, so that the disk version of the B-Tree becomes outdated. Is tha=
t correct?

I have debug information from the kernel BIO layer where I see sectors/bloc=
ks being flushed out by the sync but the B-Tree on disk still lists those b=
locks as free. At what time is the on-disk B-Tree updated, only at umount?

Is there any way to force the in-memory B-Tree to be flushed to disk?

Thanks for any help,
Ben

Benjamin Wirth | Senior Software Developer
WinMagic Inc.
5600A Cancross Court
Mississauga, ON  |  L5R 3E9 |  Canada


--_000_97A4F433DEE099488FE21C1718A641D213A0320Awmsexchsvr02win_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
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
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"Balloon Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Tahoma","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.BalloonTextChar
	{mso-style-name:"Balloon Text Char";
	mso-style-priority:99;
	mso-style-link:"Balloon Text";
	font-family:"Tahoma","sans-serif";}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hello XFS community,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I have code that parses the free blocks B-Tree from =
the disk but it seems to me that the on-disk version of the B-Tree is not u=
pdated even when sync() is called, so that the disk version of the B-Tree b=
ecomes outdated. Is that correct?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I have debug information from the kernel BIO layer w=
here I see sectors/blocks being flushed out by the sync but the B-Tree on d=
isk still lists those blocks as free. At what time is the on-disk B-Tree up=
dated, only at umount?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Is there any way to force the in-memory B-Tree to be=
 flushed to disk?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks for any help,<o:p></o:p></p>
<p class=3D"MsoNormal">Ben<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><b>Benjamin Wirth </b>| Senior Software Developer<sp=
an style=3D"font-size:8.0pt">
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><b><span style=3D"color:#002060">WinMagic Inc.<br>
</span></b>5600A Cancross Court <span style=3D"font-size:9.0pt"><o:p></o:p>=
</span></p>
<p class=3D"MsoNormal">Mississauga, ON&nbsp; |&nbsp; L5R 3E9 |&nbsp; Canada=
<span style=3D"font-size:8.0pt">
</span><o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_97A4F433DEE099488FE21C1718A641D213A0320Awmsexchsvr02win_--


--===============1416872785594161155==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1416872785594161155==--
