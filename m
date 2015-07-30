Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A3D97F78
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 16:51:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F44E304043
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 14:51:26 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id GYYhIGEuAHiGyaIM (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 14:51:19 -0700 (PDT)
Subject: Bug#794158: xfsprogs FTCBFS: fails to pass --host to configure
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.794158.B.143829304126532@bugs.debian.org>
Date: Thu, 30 Jul 2015 23:50:22 +0200
From: Helmut Grohne <helmut@subdivi.de>
Message-ID: <20150730215021.GA32262@alf.mars>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
Reply-To: Helmut Grohne <helmut@subdivi.de>, 794158@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Debian Bug Tracking System <submit@bugs.debian.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Source: xfsprogs
Version: 3.2.3
Tags: patch
User: helmutg@debian.org
Usertags: rebootstrap

xfsprogs FTCBFS, because it fails to pass --host to configure. Thus it
selects the build architecture as host architecture and fails configure,
because the requested libraries are only installed for the host
architecture. Once adding the switch it fails, because it runs host
architecture executables, which is not possible during cross
compilation. Some programs are only used during build and need to be
compiled with the build architecture compiler.

I am attaching a failing build log and a patch that makes the cross
build succeed

Helmut

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="xfsprogs_3.2.3_arm64.build"
Content-Transfer-Encoding: quoted-printable

sbuild (Debian sbuild) 0.65.2 (24 Mar 2015) on misc-debomatic3

=E2=95=94=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=97
=E2=95=91 xfsprogs 3.2.3 (CROSS host=3Darm64/build=3Damd64)              28=
 Jul 2015 03:07 =E2=95=91
=E2=95=9A=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=9D

Package: xfsprogs
Version: 3.2.3
Source Version: 3.2.3
Distribution: unstable
Machine Architecture: amd64
Host Architecture: arm64
Build Architecture: amd64

I: NOTICE: Log filtering will replace 'build/xfsprogs-uNA7Yd/xfsprogs-3.2.3=
' with '=C2=ABPKGBUILDDIR=C2=BB'
I: NOTICE: Log filtering will replace 'build/xfsprogs-uNA7Yd' with '=C2=ABB=
UILDDIR=C2=BB'
I: NOTICE: Log filtering will replace 'var/lib/schroot/mount/unstable-amd64=
-debomatic-9f549ba3-d88d-4c5c-9d7d-2aea2718618b' with '=C2=ABCHROOT=C2=BB'

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Chroot Setup Commands                                            =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98


/home/debomatic/debomatic/sbuildcommands/chroot-setup-commands/dpkg-speedup
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80


I: Finished running '/home/debomatic/debomatic/sbuildcommands/chroot-setup-=
commands/dpkg-speedup'.

Finished processing commands.
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Update chroot                                                    =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98

Get:1 http://httpredir.debian.org unstable InRelease [200 kB]
Get:2 http://httpredir.debian.org unstable/main Sources/DiffIndex [7876 B]
Get:3 http://httpredir.debian.org unstable/contrib Sources/DiffIndex [7819 =
B]
Get:4 http://httpredir.debian.org unstable/non-free Sources/DiffIndex [7819=
 B]
Get:5 http://httpredir.debian.org unstable/main amd64 Packages/DiffIndex [7=
876 B]
Get:6 http://httpredir.debian.org unstable/contrib amd64 Packages/DiffIndex=
 [7819 B]
Get:7 http://httpredir.debian.org unstable/non-free amd64 Packages/DiffInde=
x [7819 B]
Get:8 http://httpredir.debian.org unstable/main arm64 Packages/DiffIndex [7=
876 B]
Get:9 http://httpredir.debian.org unstable/contrib arm64 Packages/DiffIndex=
 [7819 B]
Get:10 http://httpredir.debian.org unstable/non-free arm64 Packages/DiffInd=
ex [7819 B]
Get:11 http://httpredir.debian.org unstable/contrib Translation-en/DiffInde=
x [7819 B]
Get:12 http://httpredir.debian.org unstable/main Translation-en/DiffIndex [=
7876 B]
Get:13 http://httpredir.debian.org unstable/non-free Translation-en/DiffInd=
ex [7819 B]
Get:14 http://httpredir.debian.org unstable/main 2015-07-20-2047.52.pdiff [=
12.4 kB]
Get:15 http://httpredir.debian.org unstable/main 2015-07-21-0250.43.pdiff [=
8812 B]
Get:16 http://httpredir.debian.org unstable/main 2015-07-21-0850.03.pdiff [=
3397 B]
Get:17 http://httpredir.debian.org unstable/main 2015-07-21-1449.47.pdiff [=
18.8 kB]
Get:18 http://httpredir.debian.org unstable/main 2015-07-21-2049.10.pdiff [=
8292 B]
Get:19 http://httpredir.debian.org unstable/main 2015-07-22-0250.18.pdiff [=
12.2 kB]
Get:20 http://httpredir.debian.org unstable/main 2015-07-22-0848.26.pdiff [=
5555 B]
Get:21 http://httpredir.debian.org unstable/main 2015-07-22-1449.38.pdiff [=
13.7 kB]
Get:22 http://httpredir.debian.org unstable/main 2015-07-22-2049.44.pdiff [=
19.5 kB]
Get:23 http://httpredir.debian.org unstable/main 2015-07-23-0247.58.pdiff [=
19.4 kB]
Get:24 http://httpredir.debian.org unstable/main 2015-07-23-0910.58.pdiff [=
13.2 kB]
Get:25 http://httpredir.debian.org unstable/main 2015-07-23-1448.36.pdiff [=
16.0 kB]
Get:26 http://httpredir.debian.org unstable/main 2015-07-23-2049.31.pdiff [=
17.1 kB]
Get:27 http://httpredir.debian.org unstable/main 2015-07-24-0250.04.pdiff [=
12.6 kB]
Get:28 http://httpredir.debian.org unstable/main 2015-07-24-0851.36.pdiff [=
2008 B]
Get:29 http://httpredir.debian.org unstable/main 2015-07-24-1452.49.pdiff [=
21.2 kB]
Get:30 http://httpredir.debian.org unstable/main 2015-07-24-2051.02.pdiff [=
23.9 kB]
Get:31 http://httpredir.debian.org unstable/main 2015-07-25-0251.08.pdiff [=
4449 B]
Get:32 http://httpredir.debian.org unstable/main 2015-07-25-0850.02.pdiff [=
2819 B]
Get:33 http://httpredir.debian.org unstable/main 2015-07-25-2052.33.pdiff [=
30.1 kB]
Get:34 http://httpredir.debian.org unstable/main 2015-07-26-0254.09.pdiff [=
10.2 kB]
Get:35 http://httpredir.debian.org unstable/main 2015-07-26-0850.47.pdiff [=
4581 B]
Get:36 http://httpredir.debian.org unstable/main 2015-07-26-1450.39.pdiff [=
7768 B]
Get:37 http://httpredir.debian.org unstable/main 2015-07-26-2049.45.pdiff [=
19.0 kB]
Get:38 http://httpredir.debian.org unstable/main 2015-07-27-0250.55.pdiff [=
17.0 kB]
Get:39 http://httpredir.debian.org unstable/main 2015-07-27-0850.30.pdiff [=
5362 B]
Get:40 http://httpredir.debian.org unstable/main 2015-07-27-1452.54.pdiff [=
4593 B]
Get:41 http://httpredir.debian.org unstable/main 2015-07-27-2050.33.pdiff [=
25.0 kB]
Get:42 http://httpredir.debian.org unstable/main 2015-07-27-2050.33.pdiff [=
25.0 kB]
Get:43 http://httpredir.debian.org unstable/contrib 2015-07-27-1452.54.pdif=
f [26 B]
Get:44 http://httpredir.debian.org unstable/contrib 2015-07-27-2050.33.pdif=
f [707 B]
Get:45 http://httpredir.debian.org unstable/non-free 2015-07-23-0247.58.pdi=
ff [277 B]
Get:46 http://httpredir.debian.org unstable/non-free 2015-07-23-1448.36.pdi=
ff [653 B]
Get:47 http://httpredir.debian.org unstable/non-free 2015-07-24-0250.04.pdi=
ff [393 B]
Get:48 http://httpredir.debian.org unstable/main amd64 2015-07-20-2047.52.p=
diff [29.9 kB]
Get:49 http://httpredir.debian.org unstable/main amd64 2015-07-21-0250.43.p=
diff [48.0 kB]
Get:50 http://httpredir.debian.org unstable/main amd64 2015-07-21-0850.03.p=
diff [2644 B]
Get:51 http://httpredir.debian.org unstable/main amd64 2015-07-21-1449.47.p=
diff [28.8 kB]
Get:52 http://httpredir.debian.org unstable/main amd64 2015-07-21-2049.10.p=
diff [13.7 kB]
Get:53 http://httpredir.debian.org unstable/main amd64 2015-07-22-0250.18.p=
diff [20.9 kB]
Get:54 http://httpredir.debian.org unstable/contrib 2015-07-27-2050.33.pdif=
f [707 B]
Get:55 http://httpredir.debian.org unstable/non-free 2015-07-24-0250.04.pdi=
ff [393 B]
Get:56 http://httpredir.debian.org unstable/main amd64 2015-07-22-0848.26.p=
diff [6177 B]
Get:57 http://httpredir.debian.org unstable/main amd64 2015-07-22-1449.38.p=
diff [20.5 kB]
Get:58 http://httpredir.debian.org unstable/main amd64 2015-07-22-2049.44.p=
diff [21.7 kB]
Get:59 http://httpredir.debian.org unstable/main amd64 2015-07-23-0247.58.p=
diff [5830 B]
Get:60 http://httpredir.debian.org unstable/main amd64 2015-07-23-0910.58.p=
diff [27.3 kB]
Get:61 http://httpredir.debian.org unstable/main amd64 2015-07-23-1448.36.p=
diff [29.5 kB]
Get:62 http://httpredir.debian.org unstable/main amd64 2015-07-23-2049.31.p=
diff [17.6 kB]
Get:63 http://httpredir.debian.org unstable/main amd64 2015-07-24-0250.04.p=
diff [10.0 kB]
Get:64 http://httpredir.debian.org unstable/main amd64 2015-07-24-0851.36.p=
diff [9233 B]
Get:65 http://httpredir.debian.org unstable/main amd64 2015-07-24-1452.49.p=
diff [21.3 kB]
Get:66 http://httpredir.debian.org unstable/main amd64 2015-07-24-2051.02.p=
diff [28.6 kB]
Get:67 http://httpredir.debian.org unstable/main amd64 2015-07-25-0251.08.p=
diff [7310 B]
Get:68 http://httpredir.debian.org unstable/main amd64 2015-07-25-0850.02.p=
diff [2412 B]
Get:69 http://httpredir.debian.org unstable/main amd64 2015-07-25-2052.33.p=
diff [30.4 kB]
Get:70 http://httpredir.debian.org unstable/main amd64 2015-07-26-0254.09.p=
diff [7277 B]
Get:71 http://httpredir.debian.org unstable/main amd64 2015-07-26-0850.47.p=
diff [3111 B]
Get:72 http://httpredir.debian.org unstable/main amd64 2015-07-26-1450.39.p=
diff [6377 B]
Get:73 http://httpredir.debian.org unstable/main amd64 2015-07-26-2049.45.p=
diff [24.2 kB]
Get:74 http://httpredir.debian.org unstable/main amd64 2015-07-27-0250.55.p=
diff [8822 B]
Get:75 http://httpredir.debian.org unstable/main amd64 2015-07-27-0850.30.p=
diff [3433 B]
Get:76 http://httpredir.debian.org unstable/main amd64 2015-07-27-1452.54.p=
diff [2794 B]
Get:77 http://httpredir.debian.org unstable/main amd64 2015-07-27-2050.33.p=
diff [29.1 kB]
Get:78 http://httpredir.debian.org unstable/main amd64 2015-07-27-2050.33.p=
diff [29.1 kB]
Get:79 http://httpredir.debian.org unstable/contrib amd64 2015-07-20-2047.5=
2.pdiff [870 B]
Get:80 http://httpredir.debian.org unstable/contrib amd64 2015-07-21-0250.4=
3.pdiff [1237 B]
Get:81 http://httpredir.debian.org unstable/contrib amd64 2015-07-21-0850.0=
3.pdiff [38 B]
Get:82 http://httpredir.debian.org unstable/contrib amd64 2015-07-21-1449.4=
7.pdiff [518 B]
Get:83 http://httpredir.debian.org unstable/contrib amd64 2015-07-21-2049.1=
0.pdiff [29 B]
Get:84 http://httpredir.debian.org unstable/contrib amd64 2015-07-22-1449.3=
8.pdiff [388 B]
Get:85 http://httpredir.debian.org unstable/contrib amd64 2015-07-22-2049.4=
4.pdiff [29 B]
Get:86 http://httpredir.debian.org unstable/contrib amd64 2015-07-26-0850.4=
7.pdiff [423 B]
Get:87 http://httpredir.debian.org unstable/contrib amd64 2015-07-27-0250.5=
5.pdiff [42 B]
Get:88 http://httpredir.debian.org unstable/contrib amd64 2015-07-27-2050.3=
3.pdiff [811 B]
Get:89 http://httpredir.debian.org unstable/non-free amd64 2015-07-23-0247.=
58.pdiff [970 B]
Get:90 http://httpredir.debian.org unstable/non-free amd64 2015-07-23-1448.=
36.pdiff [427 B]
Get:91 http://httpredir.debian.org unstable/contrib amd64 2015-07-27-2050.3=
3.pdiff [811 B]
Get:92 http://httpredir.debian.org unstable/non-free amd64 2015-07-24-0250.=
04.pdiff [319 B]
Get:93 http://httpredir.debian.org unstable/non-free amd64 2015-07-24-0250.=
04.pdiff [319 B]
Get:94 http://httpredir.debian.org unstable/main arm64 2015-07-20-2047.52.p=
diff [21.7 kB]
Get:95 http://httpredir.debian.org unstable/main arm64 2015-07-21-0250.43.p=
diff [54.3 kB]
Get:96 http://httpredir.debian.org unstable/main arm64 2015-07-21-0850.03.p=
diff [2647 B]
Get:97 http://httpredir.debian.org unstable/main arm64 2015-07-21-1449.47.p=
diff [27.6 kB]
Get:98 http://httpredir.debian.org unstable/main arm64 2015-07-21-2049.10.p=
diff [13.7 kB]
Get:99 http://httpredir.debian.org unstable/main arm64 2015-07-22-0250.18.p=
diff [15.8 kB]
Get:100 http://httpredir.debian.org unstable/main arm64 2015-07-22-0848.26.=
pdiff [3902 B]
Get:101 http://httpredir.debian.org unstable/main arm64 2015-07-22-1449.38.=
pdiff [8493 B]
Get:102 http://httpredir.debian.org unstable/main arm64 2015-07-22-2049.44.=
pdiff [19.2 kB]
Get:103 http://httpredir.debian.org unstable/main arm64 2015-07-23-0247.58.=
pdiff [9265 B]
Get:104 http://httpredir.debian.org unstable/main arm64 2015-07-23-0910.58.=
pdiff [18.6 kB]
Get:105 http://httpredir.debian.org unstable/main arm64 2015-07-23-1448.36.=
pdiff [27.4 kB]
Get:106 http://httpredir.debian.org unstable/main arm64 2015-07-23-2049.31.=
pdiff [21.0 kB]
Get:107 http://httpredir.debian.org unstable/main arm64 2015-07-24-0250.04.=
pdiff [11.3 kB]
Get:108 http://httpredir.debian.org unstable/main arm64 2015-07-24-0851.36.=
pdiff [322 B]
Get:109 http://httpredir.debian.org unstable/main arm64 2015-07-24-1452.49.=
pdiff [22.9 kB]
Get:110 http://httpredir.debian.org unstable/main arm64 2015-07-24-2051.02.=
pdiff [25.2 kB]
Get:111 http://httpredir.debian.org unstable/main arm64 2015-07-25-0251.08.=
pdiff [6527 B]
Get:112 http://httpredir.debian.org unstable/main arm64 2015-07-25-0850.02.=
pdiff [2765 B]
Get:113 http://httpredir.debian.org unstable/main arm64 2015-07-25-2052.33.=
pdiff [23.1 kB]
Get:114 http://httpredir.debian.org unstable/main arm64 2015-07-26-0254.09.=
pdiff [3931 B]
Get:115 http://httpredir.debian.org unstable/main arm64 2015-07-26-0850.47.=
pdiff [3061 B]
Get:116 http://httpredir.debian.org unstable/main arm64 2015-07-26-1450.39.=
pdiff [4947 B]
Get:117 http://httpredir.debian.org unstable/main arm64 2015-07-26-2049.45.=
pdiff [20.7 kB]
Get:118 http://httpredir.debian.org unstable/main arm64 2015-07-27-0250.55.=
pdiff [11.2 kB]
Get:119 http://httpredir.debian.org unstable/main arm64 2015-07-27-0850.30.=
pdiff [3425 B]
Get:120 http://httpredir.debian.org unstable/main arm64 2015-07-27-1452.54.=
pdiff [3681 B]
Get:121 http://httpredir.debian.org unstable/main arm64 2015-07-27-2050.33.=
pdiff [25.8 kB]
Get:122 http://httpredir.debian.org unstable/main arm64 2015-07-27-2050.33.=
pdiff [25.8 kB]
Get:123 http://httpredir.debian.org unstable/contrib arm64 2015-07-20-2047.=
52.pdiff [870 B]
Get:124 http://httpredir.debian.org unstable/contrib arm64 2015-07-21-0250.=
43.pdiff [852 B]
Get:125 http://httpredir.debian.org unstable/contrib arm64 2015-07-21-0850.=
03.pdiff [637 B]
Get:126 http://httpredir.debian.org unstable/contrib arm64 2015-07-21-1449.=
47.pdiff [517 B]
Get:127 http://httpredir.debian.org unstable/contrib arm64 2015-07-21-2049.=
10.pdiff [29 B]
Get:128 http://httpredir.debian.org unstable/contrib arm64 2015-07-22-1449.=
38.pdiff [247 B]
Get:129 http://httpredir.debian.org unstable/contrib arm64 2015-07-22-2049.=
44.pdiff [252 B]
Get:130 http://httpredir.debian.org unstable/contrib arm64 2015-07-27-0250.=
55.pdiff [40 B]
Get:131 http://httpredir.debian.org unstable/contrib arm64 2015-07-27-2050.=
33.pdiff [811 B]
Get:132 http://httpredir.debian.org unstable/non-free arm64 2015-07-23-0247=
=2E58.pdiff [454 B]
Get:133 http://httpredir.debian.org unstable/contrib arm64 2015-07-27-2050.=
33.pdiff [811 B]
Get:134 http://httpredir.debian.org unstable/contrib 2015-07-27-0250.55.pdi=
ff [26 B]
Get:135 http://httpredir.debian.org unstable/non-free arm64 2015-07-23-1448=
=2E36.pdiff [427 B]
Get:136 http://httpredir.debian.org unstable/non-free arm64 2015-07-23-1448=
=2E36.pdiff [427 B]
Get:137 http://httpredir.debian.org unstable/contrib 2015-07-27-2050.33.pdi=
ff [574 B]
Get:138 http://httpredir.debian.org unstable/contrib 2015-07-27-2050.33.pdi=
ff [574 B]
Get:139 http://httpredir.debian.org unstable/main 2015-07-20-2047.52.pdiff =
[854 B]
Get:140 http://httpredir.debian.org unstable/main 2015-07-21-0250.43.pdiff =
[879 B]
Get:141 http://httpredir.debian.org unstable/main 2015-07-21-0850.03.pdiff =
[281 B]
Get:142 http://httpredir.debian.org unstable/main 2015-07-21-1449.47.pdiff =
[4183 B]
Get:143 http://httpredir.debian.org unstable/main 2015-07-21-2049.10.pdiff =
[1232 B]
Get:144 http://httpredir.debian.org unstable/main 2015-07-22-0250.18.pdiff =
[685 B]
Get:145 http://httpredir.debian.org unstable/main 2015-07-22-0848.26.pdiff =
[1080 B]
Get:146 http://httpredir.debian.org unstable/main 2015-07-22-1449.38.pdiff =
[1158 B]
Get:147 http://httpredir.debian.org unstable/main 2015-07-22-2049.44.pdiff =
[1204 B]
Get:148 http://httpredir.debian.org unstable/main 2015-07-23-0247.58.pdiff =
[613 B]
Get:149 http://httpredir.debian.org unstable/main 2015-07-23-0910.58.pdiff =
[2559 B]
Get:150 http://httpredir.debian.org unstable/main 2015-07-23-1448.36.pdiff =
[2957 B]
Get:151 http://httpredir.debian.org unstable/main 2015-07-23-2049.31.pdiff =
[1938 B]
Get:152 http://httpredir.debian.org unstable/main 2015-07-24-0250.04.pdiff =
[283 B]
Get:153 http://httpredir.debian.org unstable/main 2015-07-24-1452.49.pdiff =
[3527 B]
Get:154 http://httpredir.debian.org unstable/main 2015-07-24-2051.02.pdiff =
[8563 B]
Get:155 http://httpredir.debian.org unstable/main 2015-07-25-0850.02.pdiff =
[128 B]
Get:156 http://httpredir.debian.org unstable/main 2015-07-25-2052.33.pdiff =
[4674 B]
Get:157 http://httpredir.debian.org unstable/main 2015-07-26-0254.09.pdiff =
[966 B]
Get:158 http://httpredir.debian.org unstable/main 2015-07-26-0850.47.pdiff =
[55 B]
Get:159 http://httpredir.debian.org unstable/main 2015-07-26-1450.39.pdiff =
[845 B]
Get:160 http://httpredir.debian.org unstable/main 2015-07-26-2049.45.pdiff =
[662 B]
Get:161 http://httpredir.debian.org unstable/main 2015-07-27-0250.55.pdiff =
[2929 B]
Get:162 http://httpredir.debian.org unstable/main 2015-07-27-0850.30.pdiff =
[832 B]
Get:163 http://httpredir.debian.org unstable/main 2015-07-27-1452.54.pdiff =
[581 B]
Get:164 http://httpredir.debian.org unstable/main 2015-07-27-2050.33.pdiff =
[6126 B]
Get:165 http://httpredir.debian.org unstable/main 2015-07-27-2050.33.pdiff =
[6126 B]
Get:166 http://httpredir.debian.org unstable/non-free 2015-07-23-1448.36.pd=
iff [493 B]
Get:167 http://httpredir.debian.org unstable/non-free 2015-07-23-1448.36.pd=
iff [493 B]
Fetched 1596 kB in 20s (77.9 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following packages will be upgraded:
  bash cpp-4.9 cpp-4.9-aarch64-linux-gnu g++-4.9 g++-4.9-aarch64-linux-gnu
  gcc-4.9 gcc-4.9-aarch64-linux-gnu gcc-4.9-base gcc-4.9-base:arm64 libasan1
  libdebconfclient0 libexpat1 libgcc-4.9-dev:arm64 libgcc-4.9-dev
  libstdc++-4.9-dev libstdc++-4.9-dev:arm64
16 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 48.7 MB of archives.
After this operation, 241 kB disk space will be freed.
Get:1 http://httpredir.debian.org/debian/ unstable/main bash amd64 4.3-13 [=
1173 kB]
Get:2 http://httpredir.debian.org/debian/ unstable/main gcc-4.9-aarch64-lin=
ux-gnu amd64 4.9.3-3 [4743 kB]
Get:3 http://httpredir.debian.org/debian/ unstable/main g++-4.9 amd64 4.9.3=
-3 [17.8 MB]
Get:4 http://httpredir.debian.org/debian/ unstable/main g++-4.9-aarch64-lin=
ux-gnu amd64 4.9.3-3 [4956 kB]
Get:5 http://httpredir.debian.org/debian/ unstable/main cpp-4.9-aarch64-lin=
ux-gnu amd64 4.9.3-3 [4683 kB]
Get:6 http://httpredir.debian.org/debian/ unstable/main libstdc++-4.9-dev a=
rm64 4.9.3-3 [1086 kB]
Get:7 http://httpredir.debian.org/debian/ unstable/main libgcc-4.9-dev arm6=
4 4.9.3-3 [181 kB]
Get:8 http://httpredir.debian.org/debian/ unstable/main libgcc-4.9-dev amd6=
4 4.9.3-3 [2062 kB]
Get:9 http://httpredir.debian.org/debian/ unstable/main gcc-4.9-base arm64 =
4.9.3-3 [162 kB]
Get:10 http://httpredir.debian.org/debian/ unstable/main gcc-4.9 amd64 4.9.=
3-3 [5343 kB]
Get:11 http://httpredir.debian.org/debian/ unstable/main cpp-4.9 amd64 4.9.=
3-3 [5005 kB]
Get:12 http://httpredir.debian.org/debian/ unstable/main libstdc++-4.9-dev =
amd64 4.9.3-3 [1114 kB]
Get:13 http://httpredir.debian.org/debian/ unstable/main libasan1 amd64 4.9=
=2E3-3 [194 kB]
Get:14 http://httpredir.debian.org/debian/ unstable/main gcc-4.9-base amd64=
 4.9.3-3 [162 kB]
Get:15 http://httpredir.debian.org/debian/ unstable/main libdebconfclient0 =
amd64 0.195 [46.3 kB]
Get:16 http://httpredir.debian.org/debian/ unstable/main libexpat1 amd64 2.=
1.0-7 [80.0 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 48.7 MB in 2s (16.6 MB/s)
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 14308 files and directories currently installed.)=0D
Preparing to unpack .../archives/bash_4.3-13_amd64.deb ...=0D
Unpacking bash (4.3-13) over (4.3-12) ...=0D
Setting up bash (4.3-13) ...=0D
update-alternatives: using /usr/share/man/man7/bash-builtins.7.gz to provid=
e /usr/share/man/man7/builtins.7.gz (builtins.7.gz) in auto mode=0D
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 14308 files and directories currently installed.)=0D
Preparing to unpack .../g++-4.9_4.9.3-3_amd64.deb ...=0D
Unpacking g++-4.9 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../gcc-4.9_4.9.3-3_amd64.deb ...=0D
Unpacking gcc-4.9 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../cpp-4.9_4.9.3-3_amd64.deb ...=0D
Unpacking cpp-4.9 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../g++-4.9-aarch64-linux-gnu_4.9.3-3_amd64.deb ...=0D
Unpacking g++-4.9-aarch64-linux-gnu (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../gcc-4.9-aarch64-linux-gnu_4.9.3-3_amd64.deb ...=0D
Unpacking gcc-4.9-aarch64-linux-gnu (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../cpp-4.9-aarch64-linux-gnu_4.9.3-3_amd64.deb ...=0D
Unpacking cpp-4.9-aarch64-linux-gnu (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../libstdc++-4.9-dev_4.9.3-3_arm64.deb ...=0D
De-configuring libstdc++-4.9-dev:amd64 (4.9.3-2) ...=0D
Unpacking libstdc++-4.9-dev:arm64 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../libstdc++-4.9-dev_4.9.3-3_amd64.deb ...=0D
Unpacking libstdc++-4.9-dev:amd64 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../libgcc-4.9-dev_4.9.3-3_amd64.deb ...=0D
De-configuring libgcc-4.9-dev:arm64 (4.9.3-2) ...=0D
Unpacking libgcc-4.9-dev:amd64 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../libgcc-4.9-dev_4.9.3-3_arm64.deb ...=0D
Unpacking libgcc-4.9-dev:arm64 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../libasan1_4.9.3-3_amd64.deb ...=0D
Unpacking libasan1:amd64 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../gcc-4.9-base_4.9.3-3_amd64.deb ...=0D
De-configuring gcc-4.9-base:arm64 (4.9.3-2) ...=0D
Unpacking gcc-4.9-base:amd64 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../gcc-4.9-base_4.9.3-3_arm64.deb ...=0D
Unpacking gcc-4.9-base:arm64 (4.9.3-3) over (4.9.3-2) ...=0D
Preparing to unpack .../libdebconfclient0_0.195_amd64.deb ...=0D
Unpacking libdebconfclient0:amd64 (0.195) over (0.194) ...=0D
Setting up libdebconfclient0:amd64 (0.195) ...=0D
Processing triggers for libc-bin (2.21-0experimental0) ...=0D
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 14308 files and directories currently installed.)=0D
Preparing to unpack .../libexpat1_2.1.0-7_amd64.deb ...=0D
Unpacking libexpat1:amd64 (2.1.0-7) over (2.1.0-6+b3) ...=0D
Setting up gcc-4.9-base:amd64 (4.9.3-3) ...=0D
Setting up gcc-4.9-base:arm64 (4.9.3-3) ...=0D
Setting up cpp-4.9 (4.9.3-3) ...=0D
Setting up libasan1:amd64 (4.9.3-3) ...=0D
Setting up libgcc-4.9-dev:amd64 (4.9.3-3) ...=0D
Setting up libgcc-4.9-dev:arm64 (4.9.3-3) ...=0D
Setting up gcc-4.9 (4.9.3-3) ...=0D
Setting up libstdc++-4.9-dev:amd64 (4.9.3-3) ...=0D
Setting up libstdc++-4.9-dev:arm64 (4.9.3-3) ...=0D
Setting up g++-4.9 (4.9.3-3) ...=0D
Setting up cpp-4.9-aarch64-linux-gnu (4.9.3-3) ...=0D
Setting up gcc-4.9-aarch64-linux-gnu (4.9.3-3) ...=0D
Setting up g++-4.9-aarch64-linux-gnu (4.9.3-3) ...=0D
Setting up libexpat1:amd64 (2.1.0-7) ...=0D
Processing triggers for libc-bin (2.21-0experimental0) ...=0D

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Fetch source files                                               =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98


Local sources
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80

/srv/debomatic-staging/xfsprogs_3.2.3.dsc exists in /srv/debomatic-staging;=
 copying to chroot

Check architectures
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80

Initial Foreign Architectures: arm64=20

Check dependencies
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80

Merged Build-Depends: build-essential:amd64, fakeroot:amd64, crossbuild-ess=
ential-arm64:amd64
Filtered Build-Depends: build-essential:amd64, fakeroot:amd64, crossbuild-e=
ssential-arm64:amd64
dpkg-deb: building package 'sbuild-build-depends-core-dummy' in '/=C2=ABBUI=
LDDIR=C2=BB/resolver-bgAMr6/apt_archive/sbuild-build-depends-core-dummy.deb=
'.
OK
Ign file: ./ InRelease
Get:1 file: ./ Release.gpg [299 B]
Get:2 file: ./ Release [2119 B]
Ign file: ./ Translation-en
Reading package lists...
Reading package lists...

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Install core build dependencies (apt-based resolver)             =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98

Installing build dependencies
Reading package lists...
Building dependency tree...
Reading state information...
The following NEW packages will be installed:
  sbuild-build-depends-core-dummy:arm64
debconf: delaying package configuration, since apt-utils is not installed
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 0 B/774 B of archives.
After this operation, 0 B of additional disk space will be used.
Selecting previously unselected package sbuild-build-depends-core-dummy:arm=
64.=0D
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 14307 files and directories currently installed.)=0D
Preparing to unpack .../sbuild-build-depends-core-dummy.deb ...=0D
Unpacking sbuild-build-depends-core-dummy:arm64 (0.invalid.0) ...=0D
Setting up sbuild-build-depends-core-dummy:arm64 (0.invalid.0) ...=0D
dpkg-deb: building package 'sbuild-build-depends-essential-dummy' in '/=C2=
=ABBUILDDIR=C2=BB/resolver-kN7jvz/apt_archive/sbuild-build-depends-essentia=
l-dummy.deb'.
OK
Ign file: ./ InRelease
Get:1 file: ./ Release.gpg [299 B]
Get:2 file: ./ Release [2119 B]
Ign file: ./ Translation-en
Reading package lists...
Reading package lists...

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Install essential build dependencies (apt-based resolver)        =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98

Installing build dependencies
Reading package lists...
Building dependency tree...
Reading state information...
The following NEW packages will be installed:
  sbuild-build-depends-essential-dummy:arm64
debconf: delaying package configuration, since apt-utils is not installed
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 0 B/742 B of archives.
After this operation, 0 B of additional disk space will be used.
Selecting previously unselected package sbuild-build-depends-essential-dumm=
y:arm64.=0D
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 14307 files and directories currently installed.)=0D
Preparing to unpack .../sbuild-build-depends-essential-dummy.deb ...=0D
Unpacking sbuild-build-depends-essential-dummy:arm64 (0.invalid.0) ...=0D
Setting up sbuild-build-depends-essential-dummy:arm64 (0.invalid.0) ...=0D
Merged Build-Depends: uuid-dev, dh-autoreconf, debhelper (>=3D 5), gettext,=
 libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>=3D 2.17=
), linux-libc-dev
Filtered Build-Depends: uuid-dev, dh-autoreconf, debhelper (>=3D 5), gettex=
t, libtool, libreadline-gplv2-dev, libblkid-dev (>=3D 2.17), linux-libc-dev
dpkg-deb: building package 'sbuild-build-depends-xfsprogs-dummy' in '/=C2=
=ABBUILDDIR=C2=BB/resolver-fUkMcS/apt_archive/sbuild-build-depends-xfsprogs=
-dummy.deb'.
OK
Ign file: ./ InRelease
Get:1 file: ./ Release.gpg [299 B]
Get:2 file: ./ Release [2119 B]
Ign file: ./ Translation-en
Reading package lists...
Reading package lists...

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Install xfsprogs build dependencies (apt-based resolver)         =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98

Installing build dependencies
Reading package lists...
Building dependency tree...
Reading state information...
The following NEW packages will be installed:
  autoconf automake autopoint autotools-dev bsdmainutils debhelper
  dh-autoreconf gettext gettext-base groff-base intltool-debian libasprintf=
0c2
  libblkid-dev:arm64 libblkid1:arm64 libcroco3 libffi6 libglib2.0-0 libicu52
  libpipeline1 libreadline-gplv2-dev:arm64 libreadline5:arm64 libsigsegv2
  libtinfo-dev:arm64 libtinfo5:arm64 libtool libunistring0 libuuid1:arm64
  libxml2 m4 man-db po-debconf uuid-dev:arm64
0 upgraded, 32 newly installed, 0 to remove and 0 not upgraded.
Need to get 18.6 MB of archives.
After this operation, 61.4 MB of additional disk space will be used.
Get:1 http://httpredir.debian.org/debian/ unstable/main libpipeline1 amd64 =
1.4.0-1 [27.9 kB]
Get:2 http://httpredir.debian.org/debian/ unstable/main groff-base amd64 1.=
22.3-1 [1205 kB]
Get:3 http://httpredir.debian.org/debian/ unstable/main bsdmainutils amd64 =
9.0.6 [183 kB]
Get:4 http://httpredir.debian.org/debian/ unstable/main man-db amd64 2.7.0.=
2-5 [1000 kB]
Get:5 http://httpredir.debian.org/debian/ unstable/main libasprintf0c2 amd6=
4 0.19.4-1 [31.6 kB]
Get:6 http://httpredir.debian.org/debian/ unstable/main libicu52 amd64 52.1=
-10 [6786 kB]
Get:7 http://httpredir.debian.org/debian/ unstable/main libuuid1 arm64 2.26=
=2E2-6 [65.4 kB]
Get:8 http://httpredir.debian.org/debian/ unstable/main libxml2 amd64 2.9.2=
+dfsg1-3 [934 kB]
Get:9 http://httpredir.debian.org/debian/ unstable/main libffi6 amd64 3.2.1=
-3 [20.1 kB]
Get:10 http://httpredir.debian.org/debian/ unstable/main libglib2.0-0 amd64=
 2.44.1-1.1 [2461 kB]
Get:11 http://httpredir.debian.org/debian/ unstable/main libblkid1 arm64 2.=
26.2-6 [142 kB]
Get:12 http://httpredir.debian.org/debian/ unstable/main libcroco3 amd64 0.=
6.8-3+b1 [135 kB]
Get:13 http://httpredir.debian.org/debian/ unstable/main libsigsegv2 amd64 =
2.10-4+b1 [29.2 kB]
Get:14 http://httpredir.debian.org/debian/ unstable/main libunistring0 amd6=
4 0.9.3-5.2+b1 [288 kB]
Get:15 http://httpredir.debian.org/debian/ unstable/main uuid-dev arm64 2.2=
6.2-6 [79.7 kB]
Get:16 http://httpredir.debian.org/debian/ unstable/main libblkid-dev arm64=
 2.26.2-6 [178 kB]
Get:17 http://httpredir.debian.org/debian/ unstable/main libtinfo5 arm64 5.=
9+20150516-2 [275 kB]
Get:18 http://httpredir.debian.org/debian/ unstable/main gettext-base amd64=
 0.19.4-1 [121 kB]
Get:19 http://httpredir.debian.org/debian/ unstable/main m4 amd64 1.4.17-4 =
[254 kB]
Get:20 http://httpredir.debian.org/debian/ unstable/main autoconf all 2.69-=
8 [340 kB]
Get:21 http://httpredir.debian.org/debian/ unstable/main autotools-dev all =
20140911.1 [70.5 kB]
Get:22 http://httpredir.debian.org/debian/ unstable/main automake all 1:1.1=
5-2 [735 kB]
Get:23 http://httpredir.debian.org/debian/ unstable/main autopoint all 0.19=
=2E4-1 [415 kB]
Get:24 http://httpredir.debian.org/debian/ unstable/main gettext amd64 0.19=
=2E4-1 [1241 kB]
Get:25 http://httpredir.debian.org/debian/ unstable/main intltool-debian al=
l 0.35.0+20060710.2 [25.9 kB]
Get:26 http://httpredir.debian.org/debian/ unstable/main po-debconf all 1.0=
=2E18 [248 kB]
Get:27 http://httpredir.debian.org/debian/ unstable/main debhelper all 9.20=
150628 [817 kB]
Get:28 http://httpredir.debian.org/debian/ unstable/main libtool all 2.4.2-=
1.11 [190 kB]
Get:29 http://httpredir.debian.org/debian/ unstable/main dh-autoreconf all =
10 [15.2 kB]
Get:30 http://httpredir.debian.org/debian/ unstable/main libreadline5 arm64=
 5.2+dfsg-3 [100 kB]
Get:31 http://httpredir.debian.org/debian/ unstable/main libtinfo-dev arm64=
 5.9+20150516-2 [71.9 kB]
Get:32 http://httpredir.debian.org/debian/ unstable/main libreadline-gplv2-=
dev arm64 5.2+dfsg-3 [116 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 18.6 MB in 3s (4733 kB/s)
Selecting previously unselected package libpipeline1:amd64.=0D
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 14307 files and directories currently installed.)=0D
Preparing to unpack .../libpipeline1_1.4.0-1_amd64.deb ...=0D
Unpacking libpipeline1:amd64 (1.4.0-1) ...=0D
Selecting previously unselected package groff-base.=0D
Preparing to unpack .../groff-base_1.22.3-1_amd64.deb ...=0D
Unpacking groff-base (1.22.3-1) ...=0D
Selecting previously unselected package bsdmainutils.=0D
Preparing to unpack .../bsdmainutils_9.0.6_amd64.deb ...=0D
Unpacking bsdmainutils (9.0.6) ...=0D
Selecting previously unselected package man-db.=0D
Preparing to unpack .../man-db_2.7.0.2-5_amd64.deb ...=0D
Unpacking man-db (2.7.0.2-5) ...=0D
Selecting previously unselected package libasprintf0c2:amd64.=0D
Preparing to unpack .../libasprintf0c2_0.19.4-1_amd64.deb ...=0D
Unpacking libasprintf0c2:amd64 (0.19.4-1) ...=0D
Selecting previously unselected package libicu52:amd64.=0D
Preparing to unpack .../libicu52_52.1-10_amd64.deb ...=0D
Unpacking libicu52:amd64 (52.1-10) ...=0D
Selecting previously unselected package libxml2:amd64.=0D
Preparing to unpack .../libxml2_2.9.2+dfsg1-3_amd64.deb ...=0D
Unpacking libxml2:amd64 (2.9.2+dfsg1-3) ...=0D
Selecting previously unselected package libffi6:amd64.=0D
Preparing to unpack .../libffi6_3.2.1-3_amd64.deb ...=0D
Unpacking libffi6:amd64 (3.2.1-3) ...=0D
Selecting previously unselected package libglib2.0-0:amd64.=0D
Preparing to unpack .../libglib2.0-0_2.44.1-1.1_amd64.deb ...=0D
Unpacking libglib2.0-0:amd64 (2.44.1-1.1) ...=0D
Selecting previously unselected package libcroco3:amd64.=0D
Preparing to unpack .../libcroco3_0.6.8-3+b1_amd64.deb ...=0D
Unpacking libcroco3:amd64 (0.6.8-3+b1) ...=0D
Selecting previously unselected package libsigsegv2:amd64.=0D
Preparing to unpack .../libsigsegv2_2.10-4+b1_amd64.deb ...=0D
Unpacking libsigsegv2:amd64 (2.10-4+b1) ...=0D
Selecting previously unselected package libunistring0:amd64.=0D
Preparing to unpack .../libunistring0_0.9.3-5.2+b1_amd64.deb ...=0D
Unpacking libunistring0:amd64 (0.9.3-5.2+b1) ...=0D
Selecting previously unselected package libuuid1:arm64.=0D
Preparing to unpack .../libuuid1_2.26.2-6_arm64.deb ...=0D
Unpacking libuuid1:arm64 (2.26.2-6) ...=0D
Selecting previously unselected package libblkid1:arm64.=0D
Preparing to unpack .../libblkid1_2.26.2-6_arm64.deb ...=0D
Unpacking libblkid1:arm64 (2.26.2-6) ...=0D
Selecting previously unselected package uuid-dev:arm64.=0D
Preparing to unpack .../uuid-dev_2.26.2-6_arm64.deb ...=0D
Unpacking uuid-dev:arm64 (2.26.2-6) ...=0D
Selecting previously unselected package libblkid-dev:arm64.=0D
Preparing to unpack .../libblkid-dev_2.26.2-6_arm64.deb ...=0D
Unpacking libblkid-dev:arm64 (2.26.2-6) ...=0D
Selecting previously unselected package libtinfo5:arm64.=0D
Preparing to unpack .../libtinfo5_5.9+20150516-2_arm64.deb ...=0D
Unpacking libtinfo5:arm64 (5.9+20150516-2) ...=0D
Selecting previously unselected package gettext-base.=0D
Preparing to unpack .../gettext-base_0.19.4-1_amd64.deb ...=0D
Unpacking gettext-base (0.19.4-1) ...=0D
Selecting previously unselected package m4.=0D
Preparing to unpack .../archives/m4_1.4.17-4_amd64.deb ...=0D
Unpacking m4 (1.4.17-4) ...=0D
Selecting previously unselected package autoconf.=0D
Preparing to unpack .../autoconf_2.69-8_all.deb ...=0D
Unpacking autoconf (2.69-8) ...=0D
Selecting previously unselected package autotools-dev.=0D
Preparing to unpack .../autotools-dev_20140911.1_all.deb ...=0D
Unpacking autotools-dev (20140911.1) ...=0D
Selecting previously unselected package automake.=0D
Preparing to unpack .../automake_1%3a1.15-2_all.deb ...=0D
Unpacking automake (1:1.15-2) ...=0D
Selecting previously unselected package autopoint.=0D
Preparing to unpack .../autopoint_0.19.4-1_all.deb ...=0D
Unpacking autopoint (0.19.4-1) ...=0D
Selecting previously unselected package gettext.=0D
Preparing to unpack .../gettext_0.19.4-1_amd64.deb ...=0D
Unpacking gettext (0.19.4-1) ...=0D
Selecting previously unselected package intltool-debian.=0D
Preparing to unpack .../intltool-debian_0.35.0+20060710.2_all.deb ...=0D
Unpacking intltool-debian (0.35.0+20060710.2) ...=0D
Selecting previously unselected package po-debconf.=0D
Preparing to unpack .../po-debconf_1.0.18_all.deb ...=0D
Unpacking po-debconf (1.0.18) ...=0D
Selecting previously unselected package debhelper.=0D
Preparing to unpack .../debhelper_9.20150628_all.deb ...=0D
Unpacking debhelper (9.20150628) ...=0D
Selecting previously unselected package libtool.=0D
Preparing to unpack .../libtool_2.4.2-1.11_all.deb ...=0D
Unpacking libtool (2.4.2-1.11) ...=0D
Selecting previously unselected package dh-autoreconf.=0D
Preparing to unpack .../dh-autoreconf_10_all.deb ...=0D
Unpacking dh-autoreconf (10) ...=0D
Selecting previously unselected package libreadline5:arm64.=0D
Preparing to unpack .../libreadline5_5.2+dfsg-3_arm64.deb ...=0D
Unpacking libreadline5:arm64 (5.2+dfsg-3) ...=0D
Selecting previously unselected package libtinfo-dev:arm64.=0D
Preparing to unpack .../libtinfo-dev_5.9+20150516-2_arm64.deb ...=0D
Unpacking libtinfo-dev:arm64 (5.9+20150516-2) ...=0D
Selecting previously unselected package libreadline-gplv2-dev:arm64.=0D
Preparing to unpack .../libreadline-gplv2-dev_5.2+dfsg-3_arm64.deb ...=0D
Unpacking libreadline-gplv2-dev:arm64 (5.2+dfsg-3) ...=0D
Setting up libpipeline1:amd64 (1.4.0-1) ...=0D
Setting up groff-base (1.22.3-1) ...=0D
Setting up bsdmainutils (9.0.6) ...=0D
update-alternatives: using /usr/bin/bsd-write to provide /usr/bin/write (wr=
ite) in auto mode=0D
update-alternatives: using /usr/bin/bsd-from to provide /usr/bin/from (from=
) in auto mode=0D
Setting up man-db (2.7.0.2-5) ...=0D
Not building database; man-db/auto-update is not 'true'.=0D
Setting up libasprintf0c2:amd64 (0.19.4-1) ...=0D
Setting up libicu52:amd64 (52.1-10) ...=0D
Setting up libxml2:amd64 (2.9.2+dfsg1-3) ...=0D
Setting up libffi6:amd64 (3.2.1-3) ...=0D
Setting up libglib2.0-0:amd64 (2.44.1-1.1) ...=0D
No schema files found: doing nothing.=0D
Setting up libcroco3:amd64 (0.6.8-3+b1) ...=0D
Setting up libsigsegv2:amd64 (2.10-4+b1) ...=0D
Setting up libunistring0:amd64 (0.9.3-5.2+b1) ...=0D
Setting up libuuid1:arm64 (2.26.2-6) ...=0D
Setting up libblkid1:arm64 (2.26.2-6) ...=0D
Setting up uuid-dev:arm64 (2.26.2-6) ...=0D
Setting up libblkid-dev:arm64 (2.26.2-6) ...=0D
Setting up libtinfo5:arm64 (5.9+20150516-2) ...=0D
Setting up gettext-base (0.19.4-1) ...=0D
Setting up m4 (1.4.17-4) ...=0D
Setting up autoconf (2.69-8) ...=0D
Setting up autotools-dev (20140911.1) ...=0D
Setting up automake (1:1.15-2) ...=0D
update-alternatives: using /usr/bin/automake-1.15 to provide /usr/bin/autom=
ake (automake) in auto mode=0D
Setting up autopoint (0.19.4-1) ...=0D
Setting up gettext (0.19.4-1) ...=0D
Setting up intltool-debian (0.35.0+20060710.2) ...=0D
Setting up po-debconf (1.0.18) ...=0D
Setting up debhelper (9.20150628) ...=0D
Setting up libtool (2.4.2-1.11) ...=0D
Setting up dh-autoreconf (10) ...=0D
Setting up libreadline5:arm64 (5.2+dfsg-3) ...=0D
Setting up libtinfo-dev:arm64 (5.9+20150516-2) ...=0D
Setting up libreadline-gplv2-dev:arm64 (5.2+dfsg-3) ...=0D
Processing triggers for libc-bin (2.21-0experimental0) ...=0D

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Build environment                                                =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98

Kernel: Linux 3.16.0-4-amd64 amd64 (x86_64)
Toolchain package versions: binutils_2.25-10 dpkg-dev_1.18.1 g++-4.9_4.9.3-=
3 gcc-4.9_4.9.3-3 libc6-dev_2.21-0experimental0 libstdc++-4.9-dev_4.9.3-3 l=
ibstdc++6_5.2.1-11 linux-libc-dev_4.1.2-1~exp1
Package versions: adduser_3.113+nmu3 apt_1.0.9.10 autoconf_2.69-8 automake_=
1:1.15-2 autopoint_0.19.4-1 autotools-dev_20140911.1 base-files_9.2 base-pa=
sswd_3.5.38 bash_4.3-13 binutils_2.25-10 binutils-aarch64-linux-gnu_2.25-8 =
bsdmainutils_9.0.6 bsdutils_1:2.26.2-6 build-essential_11.7 bzip2_1.0.6-8 c=
a-certificates_20150426 coreutils_8.23-4 cpp_4:4.9.2-4 cpp-4.9_4.9.3-3 cpp-=
4.9-aarch64-linux-gnu_4.9.3-3 crossbuild-essential-arm64_12 dash_0.5.7-4+b1=
 debconf_1.5.57 debconf-i18n_1.5.57 debfoster_2.7-2 debhelper_9.20150628 de=
bian-archive-keyring_2014.3 debianutils_4.5.1 dh-autoreconf_10 diffutils_1:=
3.3-1+b1 dmsetup_2:1.02.99-2 dpkg_1.18.1 dpkg-cross_2.6.13 dpkg-dev_1.18.1 =
e2fslibs_1.42.13-1 e2fsprogs_1.42.13-1 fakeroot_1.20.2-1 file_1:5.22+15-2 f=
indutils_4.4.2-9+b1 g++_4:4.9.2-4 g++-4.9_4.9.3-3 g++-4.9-aarch64-linux-gnu=
_4.9.3-3 g++-aarch64-linux-gnu_4.9.2-10.1 gcc_4:4.9.2-4 gcc-4.8-base_4.8.5-=
1 gcc-4.9_4.9.3-3 gcc-4.9-aarch64-linux-gnu_4.9.3-3 gcc-4.9-base_4.9.3-3 gc=
c-5-base_5.2.1-11 gcc-aarch64-linux-gnu_4.9.2-10.1 gettext_0.19.4-1 gettext=
-base_0.19.4-1 gnupg_1.4.19-3 gpgv_1.4.19-3 grep_2.21-2 groff-base_1.22.3-1=
 gzip_1.6-4 hostname_3.15 ifupdown_0.7.54 init_1.23 initscripts_2.88dsf-59.=
2 insserv_1.14.0-5 intltool-debian_0.35.0+20060710.2 iproute2_4.0.0-1 isc-d=
hcp-client_4.3.2-1 isc-dhcp-common_4.3.2-1 libacl1_2.2.52-2 libapparmor1_2.=
9.2-3 libapt-pkg4.12_1.0.9.10 libasan1_4.9.3-3 libasprintf0c2_0.19.4-1 liba=
tm1_1:2.5.1-1.5 libatomic1_5.2.1-11 libattr1_1:2.4.47-2 libaudit-common_1:2=
=2E4.2-1 libaudit1_1:2.4.2-1 libauthen-sasl-perl_2.1600-1 libblkid-dev_2.26=
=2E2-6 libblkid1_2.26.2-6 libbz2-1.0_1.0.6-8 libc-bin_2.21-0experimental0 l=
ibc-dev-bin_2.21-0experimental0 libc6_2.21-0experimental0 libc6-dev_2.21-0e=
xperimental0 libcap2_1:2.24-9 libcap2-bin_1:2.24-9 libcilkrts5_5.2.1-11 lib=
cloog-isl4_0.18.3-1 libcomerr2_1.42.13-1 libconfig-auto-perl_0.44-1 libconf=
ig-inifiles-perl_2.83-3 libcroco3_0.6.8-3+b1 libcryptsetup4_2:1.6.6-5 libdb=
5.3_5.3.28-9 libdebconfclient0_0.195 libdebian-dpkgcross-perl_2.6.13 libdev=
mapper1.02.1_2:1.02.99-2 libdns-export100_1:9.9.5.dfsg-10 libdpkg-perl_1.18=
=2E1 libencode-locale-perl_1.03-1 libexpat1_2.1.0-7 libexporter-tiny-perl_0=
=2E042-1 libfakeroot_1.20.2-1 libfdisk1_2.26.2-6 libffi6_3.2.1-3 libfile-ho=
medir-perl_1.00-1 libfile-listing-perl_6.04-1 libfile-which-perl_1.18-1 lib=
font-afm-perl_1.20-1 libgc1c2_1:7.2d-6.4 libgcc-4.9-dev_4.9.3-3 libgcc1_1:5=
=2E2.1-11 libgcrypt20_1.6.3-2 libgdbm3_1.8.3-13.1 libglib2.0-0_2.44.1-1.1 l=
ibgmp10_2:6.0.0+dfsg-7 libgomp1_5.2.1-11 libgpg-error0_1.19-2 libhtml-form-=
perl_6.03-1 libhtml-format-perl_2.11-2 libhtml-parser-perl_3.71-2 libhtml-t=
agset-perl_3.20-2 libhtml-tree-perl_5.03-2 libhttp-cookies-perl_6.01-1 libh=
ttp-daemon-perl_6.01-1 libhttp-date-perl_6.02-1 libhttp-message-perl_6.06-1=
 libhttp-negotiate-perl_6.00-2 libicu52_52.1-10 libio-html-perl_1.001-1 lib=
io-socket-ssl-perl_2.016-1 libio-string-perl_1.08-3 libirs-export91_1:9.9.5=
=2Edfsg-10 libisc-export95_1:9.9.5.dfsg-10 libisccfg-export90_1:9.9.5.dfsg-=
10 libisl13_0.14-2 libitm1_5.2.1-11 libkmod2_21-1 liblist-moreutils-perl_0.=
413-1 liblocale-gettext-perl_1.05-9 liblsan0_5.2.1-11 liblwp-mediatypes-per=
l_6.02-1 liblwp-protocol-https-perl_6.06-2 liblzma5_5.1.1alpha+20120614-2.1=
 libmagic1_1:5.22+15-2 libmailtools-perl_2.13-1 libmount1_2.26.2-6 libmpc3_=
1.0.3-1 libmpfr4_3.1.3-1 libncurses5_5.9+20150516-2 libncursesw5_5.9+201505=
16-2 libnet-http-perl_6.07-1 libnet-smtp-ssl-perl_1.01-3 libnet-ssleay-perl=
_1.70-1 libpam-modules_1.1.8-3.1 libpam-modules-bin_1.1.8-3.1 libpam-runtim=
e_1.1.8-3.1 libpam0g_1.1.8-3.1 libpcre3_2:8.35-7 libpipeline1_1.4.0-1 libpr=
ocps4_2:3.3.10-2 libquadmath0_5.2.1-11 libreadline-gplv2-dev_5.2+dfsg-3 lib=
readline5_5.2+dfsg-3 libreadline6_6.3-8+b3 libseccomp2_2.2.1-2 libselinux1_=
2.3-2+b1 libsemanage-common_2.3-1 libsemanage1_2.3-1+b2 libsepol1_2.3-2 lib=
sigsegv2_2.10-4+b1 libslang2_2.3.0-2+b1 libsmartcols1_2.26.2-6 libss2_1.42.=
13-1 libssl1.0.0_1.0.2d-1 libstdc++-4.9-dev_4.9.3-3 libstdc++6_5.2.1-11 lib=
systemd0_222-2 libtext-charwidth-perl_0.04-7+b3 libtext-iconv-perl_1.7-5+b2=
 libtext-wrapi18n-perl_0.06-7 libtimedate-perl_2.3000-2 libtinfo-dev_5.9+20=
150516-2 libtinfo5_5.9+20150516-2 libtool_2.4.2-1.11 libtsan0_5.2.1-11 libu=
bsan0_5.2.1-11 libudev1_222-2 libunistring0_0.9.3-5.2+b1 liburi-perl_1.64-1=
 libusb-0.1-4_2:0.1.12-25 libustr-1.0-1_1.0.4-5 libuuid1_2.26.2-6 libwww-pe=
rl_6.13-1 libwww-robotrules-perl_6.01-1 libxml-namespacesupport-perl_1.11-1=
 libxml-parser-perl_2.41-3 libxml-sax-base-perl_1.07-1 libxml-sax-expat-per=
l_0.40-2 libxml-sax-perl_0.99+dfsg-2 libxml-simple-perl_2.20-1 libxml2_2.9.=
2+dfsg1-3 libxtables10_1.4.21-2+b1 libyaml-libyaml-perl_0.41-6 libyaml-perl=
_1.13-1 linux-libc-dev_4.1.2-1~exp1 login_1:4.2-3 lsb-base_4.1+Debian13+nmu=
1 m4_1.4.17-4 make_4.0-8.1 man-db_2.7.0.2-5 mawk_1.3.3-17 mount_2.26.2-6 mu=
ltiarch-support_2.19-19 nano_2.4.2-1 ncurses-base_5.9+20150516-2 ncurses-bi=
n_5.9+20150516-2 netbase_5.3 openssl_1.0.2d-1 passwd_1:4.2-3 patch_2.7.5-1 =
perl_5.20.2-6 perl-base_5.20.2-6 perl-modules_5.20.2-6 po-debconf_1.0.18 pr=
ocps_2:3.3.10-2 readline-common_6.3-8 sbuild-build-depends-core-dummy_0.inv=
alid.0 sbuild-build-depends-essential-dummy_0.invalid.0 sed_4.2.2-6.1 sensi=
ble-utils_0.0.9 startpar_0.59-3 systemd_222-2 systemd-sysv_222-2 sysv-rc_2.=
88dsf-59.2 sysvinit-utils_2.88dsf-59.2 tar_1.27.1-2+b1 tzdata_2015e-1 ucf_3=
=2E0030 udev_222-2 util-linux_2.26.2-6 uuid-dev_2.26.2-6 xz-utils_5.1.1alph=
a+20120614-2.1 zlib1g_1:1.2.8.dfsg-2+b1

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Build                                                            =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98


Unpack source
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80

gpgv: keyblock resource `/sbuild-nonexistent/.gnupg/trustedkeys.gpg': file =
open error
gpgv: Signature made Mon Jun 15 01:01:58 2015 UTC using RSA key ID 36DD8C0C
gpgv: Can't check signature: public key not found
dpkg-source: warning: failed to verify signature on ./xfsprogs_3.2.3.dsc
dpkg-source: info: extracting xfsprogs in xfsprogs-3.2.3
dpkg-source: info: unpacking xfsprogs_3.2.3.tar.gz

Check disc space
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80

Sufficient free space for build

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Starting Timed Build Commands                                    =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98


/home/debomatic/debomatic/sbuildcommands/starting-build-commands/no-network
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80

Reading package lists...
Building dependency tree...
Reading state information...
util-linux is already the newest version.
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.

I: Finished running '/home/debomatic/debomatic/sbuildcommands/starting-buil=
d-commands/no-network'.

Finished processing commands.
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80

User Environment
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80

CONFIG_SITE=3D/etc/dpkg-cross/cross-config.arm64
DEB_BUILD_OPTIONS=3Dnocheck
HOME=3D/sbuild-nonexistent
LOGNAME=3Droot
PATH=3D/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
SCHROOT_ALIAS_NAME=3Dunstable-amd64-debomatic
SCHROOT_CHROOT_NAME=3Dunstable-amd64-debomatic
SCHROOT_COMMAND=3Denv
SCHROOT_GID=3D0
SCHROOT_GROUP=3Droot
SCHROOT_SESSION_ID=3Dunstable-amd64-debomatic-9f549ba3-d88d-4c5c-9d7d-2aea2=
718618b
SCHROOT_UID=3D0
SCHROOT_USER=3Droot
SHELL=3D/bin/sh
TERM=3Dscreen
USER=3Droot
USERNAME=3Droot

dpkg-buildpackage
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80

dpkg-buildpackage: warning: using a gain-root-command while being root
dpkg-buildpackage: source package xfsprogs
dpkg-buildpackage: source version 3.2.3
dpkg-buildpackage: source distribution unstable
dpkg-architecture: warning: specified GNU system type aarch64-linux-gnu doe=
s not match gcc system type x86_64-linux-gnu, try setting a correct CC envi=
ronment variable
 dpkg-source --before-build xfsprogs-3.2.3
dpkg-buildpackage: host architecture arm64
 fakeroot debian/rules clean
=3D=3D dpkg-buildpackage: clean
test -f debian/rules
rm -f built .census mkfs/mkfs.xfs-xfsprogs-udeb
/usr/bin/make distclean
make[1]: Entering directory '/=C2=ABPKGBUILDDIR=C2=BB'
make[1]: Leaving directory '/=C2=ABPKGBUILDDIR=C2=BB'
rm -rf debian/xfsprogs debian/xfslibs-dev debian/xfsprogs-udeb
rm -f debian/*substvars debian/files* debian/*.debhelper
dh_autoreconf_clean
dh_clean
	rm -f debian/xfsprogs.substvars
	rm -f debian/xfsprogs.*.debhelper
	rm -rf debian/xfsprogs/
	rm -f debian/xfslibs-dev.substvars
	rm -f debian/xfslibs-dev.*.debhelper
	rm -rf debian/xfslibs-dev/
	rm -f debian/xfsprogs-udeb.substvars
	rm -f debian/xfsprogs-udeb.*.debhelper
	rm -rf debian/xfsprogs-udeb/
	rm -rf debian/.debhelper/
	rm -f debian/*.debhelper.log
	rm -f debian/files
	find .  \( \( \
		\( -path .\*/.git -o -path .\*/.svn -o -path .\*/.bzr -o -path .\*/.hg -o=
 -path .\*/CVS \) -prune -o -type f -a \
	        \( -name '#*#' -o -name '.*~' -o -name '*~' -o -name DEADJOE \
		 -o -name '*.orig' -o -name '*.rej' -o -name '*.bak' \
		 -o -name '.*.orig' -o -name .*.rej -o -name '.SUMS' \
		 -o -name TAGS -o \( -path '*/.deps/*' -a -name '*.P' \) \
		\) -exec rm -f {} + \) -o \
		\( -type d -a -name autom4te.cache -prune -exec rm -rf {} + \) \)
dpkg-buildpackage: warning: debian/rules must be updated to support the 'bu=
ild-arch' and 'build-indep' targets (at least 'build-arch' seems to be miss=
ing)
 debian/rules build
test -f debian/rules
=3D=3D dpkg-buildpackage: installer
if [ ! -f mkfs/mkfs.xfs-xfsprogs-udeb ]; then \
	export DEBUG=3D-DNDEBUG DISTRIBUTION=3Ddebian INSTALL_USER=3Droot INSTALL_=
GROUP=3Droot LOCAL_CONFIGURE_OPTIONS=3D"--enable-readline=3Dyes --enable-bl=
kid=3Dyes" ; export OPTIMIZER=3D-Os LOCAL_CONFIGURE_OPTIONS=3D"--enable-get=
text=3Dno" ; /usr/bin/make include/platform_defs.h; \
	for dir in include libxfs libdisk mkfs; do \
		/usr/bin/make -C $dir; \
	done; \
	mv mkfs/mkfs.xfs mkfs/mkfs.xfs-xfsprogs-udeb; \
	/usr/bin/make distclean; \
fi
make[1]: Entering directory '/=C2=ABPKGBUILDDIR=C2=BB'
=2E/configure $LOCAL_CONFIGURE_OPTIONS
configure: loading site script /etc/dpkg-cross/cross-config.arm64
Reading Cross Config Cache (/etc/dpkg-cross/cross-config.arm64)
Reading /etc/dpkg-cross/cross-config.cache
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking how to print strings... printf
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...=20
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for a sed that does not truncate output... /bin/sed
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for fgrep... /bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+=3D"... yes
checking how to convert x86_64-unknown-linux-gnu file names to x86_64-unkno=
wn-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-unknown-linux-gnu file names to toolchain fo=
rmat... func_convert_file_noop
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... @
checking for strip... strip
checking for ranlib... ranlib
checking for gawk... no
checking for mawk... mawk
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for mt... no
checking if : is a manifest tool... no
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared=
 libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking for gcc... (cached) gcc
checking whether we are using the GNU C compiler... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ISO C89... (cached) none needed
checking for gcc... (cached) gcc
checking whether we are using the GNU C compiler... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ISO C89... (cached) none needed
checking for gmake... no
checking for make... /usr/bin/make
checking for tar... /bin/tar
checking for gzip... /bin/gzip
checking whether gcc -MM is supported... yes
checking for sort... /usr/bin/sort
checking whether ln -s works... yes
checking for rpm... no
checking aio.h usability... yes
checking aio.h presence... yes
checking for aio.h... yes
checking for lio_listio... no
checking for lio_listio in -lrt... yes
checking uuid.h usability... no
checking uuid.h presence... no
checking for uuid.h... no
checking sys/uuid.h usability... no
checking sys/uuid.h presence... no
checking for sys/uuid.h... no
checking uuid/uuid.h usability... yes
checking uuid/uuid.h presence... yes
checking for uuid/uuid.h... yes
checking for uuid_compare... no
checking for uuid_compare in -luuid... no

FATAL ERROR: could not find a valid UUID library.
Install the Universally Unique Identifiers library package.
Makefile:89: recipe for target 'include/builddefs' failed
make[1]: *** [include/builddefs] Error 1
make[1]: Leaving directory '/=C2=ABPKGBUILDDIR=C2=BB'
make[1]: Entering directory '/=C2=ABPKGBUILDDIR=C2=BB/include'
Makefile:19: ../include/builddefs: No such file or directory
make[1]: *** No rule to make target '../include/builddefs'.  Stop.
make[1]: Leaving directory '/=C2=ABPKGBUILDDIR=C2=BB/include'
make[1]: Entering directory '/=C2=ABPKGBUILDDIR=C2=BB/libxfs'
Makefile:6: ../include/builddefs: No such file or directory
make[1]: *** No rule to make target '../include/builddefs'.  Stop.
make[1]: Leaving directory '/=C2=ABPKGBUILDDIR=C2=BB/libxfs'
make[1]: Entering directory '/=C2=ABPKGBUILDDIR=C2=BB/libdisk'
Makefile:6: ../include/builddefs: No such file or directory
make[1]: *** No rule to make target '../include/builddefs'.  Stop.
make[1]: Leaving directory '/=C2=ABPKGBUILDDIR=C2=BB/libdisk'
make[1]: Entering directory '/=C2=ABPKGBUILDDIR=C2=BB/mkfs'
Makefile:6: ../include/builddefs: No such file or directory
make[1]: *** No rule to make target '../include/builddefs'.  Stop.
make[1]: Leaving directory '/=C2=ABPKGBUILDDIR=C2=BB/mkfs'
mv: cannot stat 'mkfs/mkfs.xfs': No such file or directory
make[1]: Entering directory '/=C2=ABPKGBUILDDIR=C2=BB'
make[1]: Leaving directory '/=C2=ABPKGBUILDDIR=C2=BB'
=3D=3D dpkg-buildpackage: configure
test -f debian/rules
AUTOHEADER=3D/bin/true dh_autoreconf
	find ! -ipath "./debian/*" -a ! \( -path '*/.git/*' -o -path '*/.hg/*' -o =
-path '*/.bzr/*' -o -path '*/.svn/*' -o -path '*/CVS/*' \) -a  -type f -exe=
c md5sum {} \; > debian/autoreconf.before
	autoreconf -f -i
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
	find ! -ipath "./debian/*" -a ! \( -path '*/.git/*' -o -path '*/.hg/*' -o =
-path '*/.bzr/*' -o -path '*/.svn/*' -o -path '*/CVS/*' \) -a  -type f -exe=
c md5sum {} \; > debian/autoreconf.after
export DEBUG=3D-DNDEBUG DISTRIBUTION=3Ddebian INSTALL_USER=3Droot INSTALL_G=
ROUP=3Droot LOCAL_CONFIGURE_OPTIONS=3D"--enable-readline=3Dyes --enable-blk=
id=3Dyes" ; /usr/bin/make include/platform_defs.h
make[1]: Entering directory '/=C2=ABPKGBUILDDIR=C2=BB'
=2E/configure $LOCAL_CONFIGURE_OPTIONS
configure: loading site script /etc/dpkg-cross/cross-config.arm64
Reading Cross Config Cache (/etc/dpkg-cross/cross-config.arm64)
Reading /etc/dpkg-cross/cross-config.cache
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking how to print strings... printf
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...=20
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for a sed that does not truncate output... /bin/sed
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for fgrep... /bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+=3D"... yes
checking how to convert x86_64-unknown-linux-gnu file names to x86_64-unkno=
wn-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-unknown-linux-gnu file names to toolchain fo=
rmat... func_convert_file_noop
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... @
checking for strip... strip
checking for ranlib... ranlib
checking for gawk... no
checking for mawk... mawk
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for mt... no
checking if : is a manifest tool... no
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared=
 libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking for gcc... (cached) gcc
checking whether we are using the GNU C compiler... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ISO C89... (cached) none needed
checking for gcc... (cached) gcc
checking whether we are using the GNU C compiler... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ISO C89... (cached) none needed
checking for gmake... no
checking for make... /usr/bin/make
checking for tar... /bin/tar
checking for gzip... /bin/gzip
checking whether gcc -MM is supported... yes
checking for sort... /usr/bin/sort
checking whether ln -s works... yes
checking for msgfmt... /usr/bin/msgfmt
checking for msgmerge... /usr/bin/msgmerge
checking for xgettext... /usr/bin/xgettext
checking for rpm... no
checking aio.h usability... yes
checking aio.h presence... yes
checking for aio.h... yes
checking for lio_listio... no
checking for lio_listio in -lrt... yes
checking uuid.h usability... no
checking uuid.h presence... no
checking for uuid.h... no
checking sys/uuid.h usability... no
checking sys/uuid.h presence... no
checking for sys/uuid.h... no
checking uuid/uuid.h usability... yes
checking uuid/uuid.h presence... yes
checking for uuid/uuid.h... yes
checking for uuid_compare... no
checking for uuid_compare in -luuid... no

FATAL ERROR: could not find a valid UUID library.
Install the Universally Unique Identifiers library package.
Makefile:89: recipe for target 'include/builddefs' failed
make[1]: *** [include/builddefs] Error 1
make[1]: Leaving directory '/=C2=ABPKGBUILDDIR=C2=BB'
debian/rules:36: recipe for target '.census' failed
make: *** [.census] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
Build finished at 20150728-0308

Finished
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80

E: Build failure (dpkg-buildpackage died)

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Cleanup                                                          =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98

Purging /=C2=ABBUILDDIR=C2=BB
Not cleaning session: cloned chroot in use

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82 Summary                                                          =
            =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98

Build Architecture: amd64
Build-Space: 8980
Build-Time: 21
Distribution: unstable
Fail-Stage: build
Foreign Architectures: arm64
Host Architecture: arm64
Install-Time: 28
Job: /srv/debomatic-staging/xfsprogs_3.2.3.dsc
Machine Architecture: amd64
Package: xfsprogs
Package-Time: 89
Source-Version: 3.2.3
Space: 8980
Status: attempted
Version: 3.2.3
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
Finished at 20150728-0308
Build needed 00:01:29, 8980k disc space

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfsprogs_3.2.3+nmu1.debdiff"

Binary files /tmp/xr3U_4h9in/xfsprogs-3.2.3/.configure.ac.swp and /tmp/NqIHa9bVs5/xfsprogs-3.2.3+nmu1/.configure.ac.swp differ
diff -Nru xfsprogs-3.2.3/debian/changelog xfsprogs-3.2.3+nmu1/debian/changelog
--- xfsprogs-3.2.3/debian/changelog	2015-06-01 03:35:09.000000000 +0200
+++ xfsprogs-3.2.3+nmu1/debian/changelog	2015-07-30 23:32:50.000000000 +0200
@@ -1,3 +1,12 @@
+xfsprogs (3.2.3+nmu1) UNRELEASED; urgency=medium
+
+  * Non-maintainer upload.
+  * Fix FTCBFS. (Closes: #-1)
+    + Pass --build and --host to configure.
+    + Compile gen_crc32table and crc32selftest using CC_FOR_BUILD.
+
+ -- Helmut Grohne <helmut@subdivi.de>  Thu, 30 Jul 2015 23:00:34 +0200
+
 xfsprogs (3.2.3) unstable; urgency=low
 
   * New upstream release
diff -Nru xfsprogs-3.2.3/debian/rules xfsprogs-3.2.3+nmu1/debian/rules
--- xfsprogs-3.2.3/debian/rules	2014-11-10 01:51:18.000000000 +0100
+++ xfsprogs-3.2.3+nmu1/debian/rules	2015-07-30 23:23:08.000000000 +0200
@@ -6,6 +6,10 @@
 develop = xfslibs-dev
 bootpkg = xfsprogs-udeb
 
+DEB_BUILD_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_BUILD_GNU_TYPE)
+DEB_HOST_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_HOST_GNU_TYPE)
+export CC_FOR_BUILD ?= cc
+
 version = $(shell dpkg-parsechangelog | grep ^Version: | cut -d ' ' -f 2)
 target ?= $(shell dpkg-architecture -qDEB_HOST_ARCH)
 udebpkg = $(bootpkg)_$(version)_$(target).udeb
@@ -18,11 +22,13 @@
 pkgdi  = DIST_ROOT=`pwd`/$(dirdi); export DIST_ROOT;
 stdenv = @GZIP=-q; export GZIP;
 
+configure_options = --build=$(DEB_BUILD_GNU_TYPE) --host=$(DEB_HOST_GNU_TYPE)
+
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes" ;
+	  LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-readline=yes --enable-blkid=yes" ;
 diopts  = $(options) \
-	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no" ;
+	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-gettext=no" ;
 checkdir = test -f debian/rules
 
 build: built
diff -Nru xfsprogs-3.2.3/libxfs/Makefile xfsprogs-3.2.3+nmu1/libxfs/Makefile
--- xfsprogs-3.2.3/libxfs/Makefile	2014-05-02 02:09:15.000000000 +0200
+++ xfsprogs-3.2.3+nmu1/libxfs/Makefile	2015-07-30 23:32:23.000000000 +0200
@@ -67,7 +67,7 @@
 
 crc32table.h: gen_crc32table.c
 	@echo "    [CC]     gen_crc32table"
-	$(Q) $(CC) $(CFLAGS) -o gen_crc32table $<
+	$(Q) $(CC_FOR_BUILD) $(CFLAGS) -o gen_crc32table $<
 	@echo "    [GENERATE] $@"
 	$(Q) ./gen_crc32table > crc32table.h
 
@@ -78,7 +78,7 @@
 # disk.
 crc32selftest: gen_crc32table.c crc32table.h crc32.c
 	@echo "    [TEST]    CRC32"
-	$(Q) $(CC) $(CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
+	$(Q) $(CC_FOR_BUILD) $(CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
 	$(Q) ./$@
 
 include $(BUILDRULES)

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--pWyiEgJYm5f9v55/--
