Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB1Hb20h071074 for <xfs@oss.sgi.com>; Sat, 1 Dec 2012 11:37:03 -0600
Received: from relay00.pair.com (relay00.pair.com [209.68.5.9]) by
	cuda.sgi.com with SMTP id JjORXcfbJO530HDQ for
	<xfs@oss.sgi.com>; Sat, 01 Dec 2012 09:39:21 -0800 (PST)
Subject: Re: xfsdump INTERRUPT issue
References: <CCDF949D.B03CC%jellis@dhnet.us>
From: Jeffrey Ellis <jellis@dhnet.us>
In-Reply-To: <CCDF949D.B03CC%jellis@dhnet.us>
Message-Id: <988A65DE-A0CB-412C-8F78-187AD0270613@dhnet.us>
Date: Sat, 1 Dec 2012 12:39:20 -0500
Mime-Version: 1.0 (1.0)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2669308666162131179=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--===============2669308666162131179==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-067D33A0-1C97-4D45-8047-9E324A6FF551
Content-Transfer-Encoding: 7bit


--Apple-Mail-067D33A0-1C97-4D45-8047-9E324A6FF551
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable

Anyone?

Or do I have enough to ask the question?

Best,
J.=20

On Dec 1, 2012, at 11:03 AM, "J. Ellis" <jellis@dhnet.us> wrote:

> I'm trying to prepare a question regarding an xfsdump INTERRUPT error I'm g=
etting, and I'm trying to follow the guidelines for reporting such issues he=
re:
>=20
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when=
_reporting_a_problem.3F
>=20
> But these last two instructions I'm having a problem finding the informati=
on on how to generate:
>=20
>=20
> xfs_info output on the filesystem in question (I tried xfs_info /dev/sdc, b=
ut it keeps saying for each drive that it's not a mounted xfs system IIRC)
>=20
> dmesg output showing all error messages and stack traces
>=20
> Then you need to describe your workload that is causing the problem, and a=
 demonstration of the bad behavior that is occurring. If it is a performance=
 problem, then 30s - 1 minute samples of:
>     1.    iostat -x -d -m 5
>     2.    vmstat 5
>=20
>=20
> Do I run this simultaneously while xfstools are working? I'm also not sure=
 what's meant by describe your workload. Can someone step me through this?
>=20
> Please excuse my n00bness.=20
>=20
> Best,
> Jeffrey
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--Apple-Mail-067D33A0-1C97-4D45-8047-9E324A6FF551
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: 7bit

<html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"></head><body dir="auto"><div>Anyone?</div><div><br></div><div>Or do I have enough to ask the question?<br><br>Best,<div>J.&nbsp;</div></div><div><br>On Dec 1, 2012, at 11:03 AM, "J. Ellis" &lt;<a href="mailto:jellis@dhnet.us">jellis@dhnet.us</a>&gt; wrote:<br><br></div><blockquote type="cite"><div>

<title>xfsdump INTERRUPT issue</title>


<font face="Calibri, Verdana, Helvetica, Arial"><span style="font-size:11pt">I'm trying to prepare a question regarding an xfsdump INTERRUPT error I'm getting, and I'm trying to follow the guidelines for reporting such issues here:<br>
<br>
</span></font><font color="#1545FA"><font size="1"><font face="Monaco, Courier New"><span style="font-size:9pt"><u><a href="http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F">http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F</a><br>
</u></span></font></font></font><font size="1"><font face="Monaco, Courier New"><span style="font-size:9pt"><br>
But these last two instructions I'm having a problem finding the information on how to generate:<br>
<br>
<br>
xfs_info output on the filesystem in question (I tried xfs_info /dev/sdc, but it keeps saying for each drive that it's not a mounted xfs system IIRC)<br>
<br>
dmesg output showing all error messages and stack traces<br>
<br>
Then you need to describe your workload that is causing the problem, and a demonstration of the bad behavior that is occurring. If it is a performance problem, then 30s - 1 minute samples of:<br>
&nbsp;&nbsp;&nbsp;&nbsp;1. &nbsp;&nbsp;&nbsp;iostat -x -d -m 5<br>
&nbsp;&nbsp;&nbsp;&nbsp;2. &nbsp;&nbsp;&nbsp;vmstat 5<br>
<br>
<br>
Do I run this simultaneously while xfstools are working? I'm also not sure what's meant by describe your workload. Can someone step me through this?<br>
<br>
Please excuse my n00bness. <br>
<br>
Best,<br>
Jeffrey</span></font></font>



</div></blockquote><blockquote type="cite"><div><span>_______________________________________________</span><br><span>xfs mailing list</span><br><span><a href="mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a></span><br><span><a href="http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/listinfo/xfs</a></span><br></div></blockquote></body></html>
--Apple-Mail-067D33A0-1C97-4D45-8047-9E324A6FF551--


--===============2669308666162131179==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2669308666162131179==--
