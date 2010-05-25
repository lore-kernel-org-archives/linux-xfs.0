Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4P24wgP216309 for <xfs@oss.sgi.com>; Mon, 24 May 2010 21:04:58 -0500
Received: from smrn.endace.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6461536C2F3
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 19:05:23 -0700 (PDT)
Received: from smrn.endace.com (endace.smrn.com [209.234.97.14]) by
	cuda.sgi.com with ESMTP id wUQkqJ4SBvvPmOwL for
	<xfs@oss.sgi.com>; Mon, 24 May 2010 19:05:23 -0700 (PDT)
Received: from mail.ems.endace.com (105.host-203-152-102.compassnet.co.nz
	[203.152.102.105])
	by smrn.endace.com (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id
	o4P2JsU7022339 for <xfs@oss.sgi.com>; Mon, 24 May 2010 19:19:55 -0700
From: Jeff Zheng <Jeff.Zheng@endace.com>
Subject: Is persistant preallocation possible?
Date: Tue, 25 May 2010 02:05:21 +0000
Message-ID: <9256268935CF66428AC10E736C91455F024036@nzaklmbx01.ad.endace.com>
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
Content-Type: multipart/mixed; boundary="===============5806514106611734913=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5806514106611734913==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_9256268935CF66428AC10E736C91455F024036nzaklmbx01adendac_"

--_000_9256268935CF66428AC10E736C91455F024036nzaklmbx01adendac_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

   We are trying to control where the files are being allocated on the disk=
s, and we tried xfs preallocation. What we found is that each time the file=
 being reopened the location of the pre-allocated space could change (not a=
ll the time). Is there a way to do persistent preallocation in xfs, like th=
e same file will always be on the same location on the disk given that the =
requested size doesn't change?

Thanks in advance.

Jeff

--_000_9256268935CF66428AC10E736C91455F024036nzaklmbx01adendac_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
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
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"Balloon Text Char";
	margin:0cm;
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
	{mso-style-type:export-only;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-NZ link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal>Hi,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp; We are trying to control where the files =
are
being allocated on the disks, and we tried xfs preallocation. What we found=
 is
that each time the file being reopened the location of the pre-allocated sp=
ace
could change (not all the time). Is there a way to do persistent preallocat=
ion
in xfs, like the same file will always be on the same location on the disk
given that the requested size doesn&#8217;t change?<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Thanks in advance.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Jeff<o:p></o:p></p>

</div>

</body>

</html>

--_000_9256268935CF66428AC10E736C91455F024036nzaklmbx01adendac_--


--===============5806514106611734913==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5806514106611734913==--
