Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB1G1g1G064239 for <xfs@oss.sgi.com>; Sat, 1 Dec 2012 10:01:42 -0600
Received: from relay02.pair.com (relay02.pair.com [209.68.5.16]) by
	cuda.sgi.com with SMTP id GpIlleiD5difh2j7 for
	<xfs@oss.sgi.com>; Sat, 01 Dec 2012 08:04:01 -0800 (PST)
Date: Sat, 01 Dec 2012 11:03:57 -0500
Subject: xfsdump INTERRUPT issue
From: "J. Ellis" <jellis@dhnet.us>
Message-ID: <CCDF949D.B03CC%jellis@dhnet.us>
Mime-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4993618957461118115=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============4993618957461118115==
Content-type: multipart/alternative;
	boundary="B_3437204640_4340140"

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--B_3437204640_4340140
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit

I'm trying to prepare a question regarding an xfsdump INTERRUPT error I'm
getting, and I'm trying to follow the guidelines for reporting such issues
here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_r
eporting_a_problem.3F

But these last two instructions I'm having a problem finding the information
on how to generate:


xfs_info output on the filesystem in question (I tried xfs_info /dev/sdc,
but it keeps saying for each drive that it's not a mounted xfs system IIRC)

dmesg output showing all error messages and stack traces

Then you need to describe your workload that is causing the problem, and a
demonstration of the bad behavior that is occurring. If it is a performance
problem, then 30s - 1 minute samples of:
    1.    iostat -x -d -m 5
    2.    vmstat 5


Do I run this simultaneously while xfstools are working? I'm also not sure
what's meant by describe your workload. Can someone step me through this?

Please excuse my n00bness.

Best,
Jeffrey

--B_3437204640_4340140
Content-type: text/html;
	charset="US-ASCII"
Content-transfer-encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>xfsdump INTERRUPT issue</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:11pt=
'>I'm trying to prepare a question regarding an xfsdump INTERRUPT error I'm =
getting, and I'm trying to follow the guidelines for reporting such issues h=
ere:<BR>
<BR>
</SPAN></FONT><FONT COLOR=3D"#1545FA"><FONT SIZE=3D"1"><FONT FACE=3D"Monaco, Cour=
ier New"><SPAN STYLE=3D'font-size:9pt'><U><a href=3D"http://xfs.org/index.php/XF=
S_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F">http=
://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_repor=
ting_a_problem.3F</a><BR>
</U></SPAN></FONT></FONT></FONT><FONT SIZE=3D"1"><FONT FACE=3D"Monaco, Courier =
New"><SPAN STYLE=3D'font-size:9pt'><BR>
But these last two instructions I'm having a problem finding the informatio=
n on how to generate:<BR>
<BR>
<BR>
xfs_info output on the filesystem in question (I tried xfs_info /dev/sdc, b=
ut it keeps saying for each drive that it's not a mounted xfs system IIRC)<B=
R>
<BR>
dmesg output showing all error messages and stack traces<BR>
<BR>
Then you need to describe your workload that is causing the problem, and a =
demonstration of the bad behavior that is occurring. If it is a performance =
problem, then 30s - 1 minute samples of:<BR>
&nbsp;&nbsp;&nbsp;&nbsp;1. &nbsp;&nbsp;&nbsp;iostat -x -d -m 5<BR>
&nbsp;&nbsp;&nbsp;&nbsp;2. &nbsp;&nbsp;&nbsp;vmstat 5<BR>
<BR>
<BR>
Do I run this simultaneously while xfstools are working? I'm also not sure =
what's meant by describe your workload. Can someone step me through this?<BR=
>
<BR>
Please excuse my n00bness. <BR>
<BR>
Best,<BR>
Jeffrey</SPAN></FONT></FONT>
</BODY>
</HTML>


--B_3437204640_4340140--



--===============4993618957461118115==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4993618957461118115==--
