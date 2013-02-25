Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8FF1C7F94
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 10:01:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C513AC005
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 08:01:56 -0800 (PST)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
	[209.85.215.54]) by cuda.sgi.com with ESMTP id rfMv8f5fGy0wt12t
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Feb 2013 08:01:54 -0800 (PST)
Received: by mail-la0-f54.google.com with SMTP id gw10so2865264lab.27
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 08:01:53 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 25 Feb 2013 10:01:53 -0600
Message-ID: <CAEWpfG_DKJt1MmWS1tARH4OmYwpSt=A-DzwKkGcD67LuR6k=Bg@mail.gmail.com>
Subject: Consistent throughput challenge -- fragmentation?
From: Brian Cain <brian.cain@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7863467593097178970=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7863467593097178970==
Content-Type: multipart/alternative; boundary=f46d0401f899d5d89904d68ea826

--f46d0401f899d5d89904d68ea826
Content-Type: text/plain; charset=ISO-8859-1

All,

I have been observing some odd behavior regarding write throughput to an
XFS partition (the baseline kernel version is 2.6.32.27).  I see
consistently high write throughput (close to the performance of the raw
block device) to the filesystem immediately after a mkfs, but after a few
test cycles, there is sporadic poor performance.

The test mechanism is like so:

[mkfs.xfs <blockdev>] (no flags/options, xfsprogs ver 3.1.1-0.1.36)
...
1. remove a previous test cycle's directory
2. create a new directory
3. open/write/close a small file (4kb) in this directory
4. open/read/close this same small file (by the local NFS server)
5. open[O_DIRECT]/write/write/write/.../close a large file (anywhere from
~100MB to 200GB)

Step #5 contains the high-throughput metrics which becomes an order of
magnitude worse several test cycles after a mkfs.  Omitting steps 1-3 does
not show the poor performance behavior.

Can anyone provide any suggestions as to an explanation for the behavior or
a way to mitigate it?  Running xfs_fsr didn't seem to improve the results.

I'm happy to share benchmarks, specific results data, or describe the
hardware being used for the measurements if it's helpful.

-- 
-Brian

--f46d0401f899d5d89904d68ea826
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>All,<br></div><div style><br></div><div style>I have =
been observing some odd behavior regarding write throughput to an XFS parti=
tion (the baseline kernel version is 2.6.32.27). =A0I see consistently high=
 write throughput (close to the performance of the raw block device) to the=
 filesystem immediately after a mkfs, but after a few test cycles, there is=
 sporadic poor performance.</div>
<div style><br></div><div style>The test mechanism is like so:</div><div st=
yle><br></div><div style>[mkfs.xfs &lt;blockdev&gt;] (no flags/options, xfs=
progs ver=A03.1.1-0.1.36)</div><div style>...</div><div style>1. remove a p=
revious test cycle&#39;s directory=A0</div>
<div style>2. create a new directory</div><div style>3. open/write/close a =
small file (4kb) in this directory</div><div style>4. open/read/close this =
same small file (by the local NFS server)</div><div style>5. open[O_DIRECT]=
/write/write/write/.../close a large file (anywhere from ~100MB to 200GB)</=
div>
<div style><br></div><div style>Step #5 contains the high-throughput metric=
s which becomes an order of magnitude worse several test cycles after a mkf=
s. =A0Omitting steps 1-3 does not show the poor performance behavior.</div>
<div style><br></div><div style>Can anyone provide any suggestions as to an=
 explanation for the behavior or a way to mitigate it? =A0Running xfs_fsr d=
idn&#39;t seem to improve the results.</div><div style><br></div><div style=
>
I&#39;m happy to share benchmarks, specific results data, or describe the h=
ardware being used for the measurements if it&#39;s helpful.</div><div><div=
><br></div>-- <br>-Brian
</div></div>

--f46d0401f899d5d89904d68ea826--


--===============7863467593097178970==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7863467593097178970==--
