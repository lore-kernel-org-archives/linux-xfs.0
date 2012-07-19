Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6J9V5GV006015 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 04:31:05 -0500
Received: from ilsmtp.nds.com (ilsmtp.nds.com [192.118.32.12]) by cuda.sgi.com
	with ESMTP id glDHz8jwY4OqacPf (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Jul 2012 02:31:03 -0700 (PDT)
From: "Zak, Semion" <SZak@nds.com>
Subject: Superblock restore takes too long
Date: Thu, 19 Jul 2012 09:30:59 +0000
Message-ID: <5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6@ilmbx02.IL.NDS.com>
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
Content-Type: multipart/mixed; boundary="===============0263000914055052795=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0263000914055052795==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6ilmbx02ILNDScom_"

--_000_5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6ilmbx02ILNDScom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,
Corrupted Superblock restore takes too long because xfs_restore searches th=
e disc for reserved Superblock.
Is it possible accelerate the search, for example by giving to xfs_restore =
some hint (reserved Superblock LBA)?

Thanks,

Semion.

________________________________

This message is confidential and intended only for the addressee. If you ha=
ve received this message in error, please immediately notify the postmaster=
@nds.com and delete it from your system as well as any copies. The content =
of e-mails as well as traffic data may be monitored by NDS for employment a=
nd security purposes.
To protect the environment please do not print this e-mail unless necessary=
.

An NDS Group Limited company. www.nds.com

--_000_5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6ilmbx02ILNDScom_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<style>
<!--
@font-face
	{font-family:Calibri}
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif"}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline}
span.EmailStyle17
	{font-family:"Calibri","sans-serif";
	color:windowtext}
.MsoChpDefault
	{font-family:"Calibri","sans-serif"}
@page WordSection1
	{margin:72.0pt 72.0pt 72.0pt 72.0pt}
div.WordSection1
	{}
-->
</style>
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,</p>
<p class=3D"MsoNormal">Corrupted Superblock restore takes too long because =
xfs_restore searches the disc for reserved Superblock.</p>
<p class=3D"MsoNormal">Is it possible accelerate the search, for example by=
 giving to xfs_restore some hint (reserved Superblock LBA)?</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">Thanks,</p>
<p class=3D"MsoNormal">&nbsp;</p>
<p class=3D"MsoNormal">Semion. &nbsp;</p>
</div>
<br>
<hr>
<font face=3D"Arial" color=3D"Gray" size=3D"1"><br>
This message is confidential and intended only for the addressee. If you ha=
ve received this message in error, please immediately notify the postmaster=
@nds.com and delete it from your system as well as any copies. The content =
of e-mails as well as traffic data
 may be monitored by NDS for employment and security purposes.<br>
To protect the environment please do not print this e-mail unless necessary=
.<br>
<br>
An NDS Group Limited company. www.nds.com<br>
</font>
</body>
</html>

--_000_5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6ilmbx02ILNDScom_--


--===============0263000914055052795==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0263000914055052795==--
