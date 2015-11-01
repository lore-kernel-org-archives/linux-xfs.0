Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A5E8A7F54
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 09:10:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F0B9AC003
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 07:10:49 -0800 (PST)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net
	[217.70.183.194]) by cuda.sgi.com with ESMTP id
	f7FlQbuUi0bf2u7f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 01 Nov 2015 07:10:45 -0800 (PST)
Received: from mfilter27-d.gandi.net (mfilter27-d.gandi.net [217.70.178.155])
	by relay2-d.mail.gandi.net (Postfix) with ESMTP id 91DBEC5A40
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 16:10:44 +0100 (CET)
Received: from relay2-d.mail.gandi.net ([IPv6:::ffff:217.70.183.194])
	by mfilter27-d.gandi.net (mfilter27-d.gandi.net [::ffff:10.0.15.180])
	(amavisd-new, port 10024)
	with ESMTP id EXzpSEy0YG4p for <xfs@oss.sgi.com>;
	Sun,  1 Nov 2015 16:10:43 +0100 (CET)
Received: from [192.168.1.1] (host31-51-17-90.range31-51.btcentralplus.com
	[31.51.17.90]) (Authenticated sender: jose@calhariz.com)
	by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id F3D88C5A44
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 16:10:42 +0100 (CET)
Message-ID: <56362B71.4070709@calhariz.com>
Date: Sun, 01 Nov 2015 15:10:41 +0000
From: Jose M Calhariz <jose@calhariz.com>
MIME-Version: 1.0
Subject: Problems compiling xfsdump on Debian unstable
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9016262192074380431=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============9016262192074380431==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qVsehd3HWmHQjmB5FRtOvcxXR3p8hVJ7M"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qVsehd3HWmHQjmB5FRtOvcxXR3p8hVJ7M
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I am trying to compile the latest xfsdump from the git repository.

While I can compile it on Debian stable (jessie) and testing(stretch), I
have problems compiling it on Debian unstable.=20
I think the problem is because of new software on Debian unstable.

One fragment of the errors that I get when linking the .o files:

cldmgr.o: In function `cldmgr_create':
/home/cal/source.xfsdump/git-xfsdump/dump/cldmgr.c:82: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/cldmgr.c:101: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/cldmgr.c:86: undefined
reference to `_'
content_common.o: In function `Media_prompt_change':
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:65: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:69: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:74: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:80: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:83: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:85: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:86: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:106:
undefined reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:112:
undefined reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:117:
undefined reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:121:
undefined reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:108:
undefined reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:109:
undefined reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:112:
undefined reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:117:
undefined reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/content_common.c:121:
undefined reference to `assert'
dlog.o: In function `dlog_string_query_print':
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:362: undefined
reference to `assert'
dlog.o: In function `promptinput':
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:508: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:486: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:503: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:513: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:499: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:490: undefined
reference to `_'
dlog.o: In function `dlog_init':
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:60: undefined reference
to `assert'
dlog.o: In function `dlog_multi_query':
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:189: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:221: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:257: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:213: undefined
reference to `_'
dlog.o: In function `dlog_string_query':
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:298: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/dlog.c:310: undefined
reference to `_'
drive.o: In function `drive_alloc':
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:359: undefined
reference to `assert'
drive.o: In function `drive_init1':
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:91: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:145: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:218: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:223: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:172: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:186: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:110: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:155: undefined
reference to `_'
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:132: undefined
reference to `_'
drive.o: In function `drive_allochdrs':
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:414: undefined
reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/drive.c:400: undefined
reference to `assert'
drive_scsitape.o: In function `do_get_align_cnt':
/home/cal/source.xfsdump/git-xfsdump/dump/drive_scsitape.c:2132:
undefined reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/drive_scsitape.c:2133:
undefined reference to `assert'
/home/cal/source.xfsdump/git-xfsdump/dump/drive_scsitape.c:2134:
undefined reference to `assert'



Software on testing that may makes a difference:

gcc --version
gcc (Debian 4.9.3-3) 4.9.3
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is N=
O
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOS=
E.

dpkg --status xfslibs-dev
Package: xfslibs-dev
Status: install ok installed
Priority: extra
Section: libdevel
Installed-Size: 80
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Architecture: amd64
Source: xfsprogs
Version: 3.2.1
Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>=3D 3.0.0)
Breaks: xfsprogs (<< 3.0.0)
Description: XFS filesystem-specific static libraries and headers

On Debian unstable:
gcc --version
gcc (Debian 5.2.1-23) 5.2.1 20151028
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is N=
O
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOS=
E.

0 2  Dom Nov 01 15:02:32 CWD=3D~/source.xfsdump/git-xfsdump
cal@chr-amd64-sid.mccoy[3895]>dpkg --status xfslibs-dev
Package: xfslibs-dev
Status: install ok installed
Priority: extra
Section: libdevel
Installed-Size: 219
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Architecture: amd64
Source: xfsprogs
Version: 4.2.0
Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>=3D 3.0.0)
Breaks: xfsprogs (<< 3.0.0)
Description: XFS filesystem-specific static libraries and headers



Why is important to me to compile xfsdump on unstable.  Because it was
removed from Debian testing and
because of that the amanda software was removed too.  As the maintainer
of amanda for Debian I am doing
my best to fix this problem.

I am not on the list.

Kind regards
Jose M Calhariz


--qVsehd3HWmHQjmB5FRtOvcxXR3p8hVJ7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJWNitxAAoJEDSKd41ohe+PQxUP/20XfbhoDU3l55hYQUm39BuW
FPVg1X1wtuGALY2EVQ+75b46VnzJVr8kOIaZaOBiyYOOS+NMr2ZZsJ1W1CwB/rGo
k5Pz6VTBijK3b8W9GrX1v3Qm96hEXm4I0uYZum1ZJN7Q0up+aQpuoZZWpOuMXRCt
7/JS4C254pK2YW2hRW6hK4Uz7YhCUJnYCbTEyI0yKgWsj6g4ulycqilK52062NiA
vXiSqd8Y/lOQIPfYQKY4C0Zb2n97L47qa1TlfjH4UOfdBEni4Ys7aVehdtnV7KxE
J8izGqlcWtZy7beuxEKnxXlY8EKZGNa4giabcRmyt57i1lzLwNC0w77naSBJ7Uuc
J3pvy2Rviz6Q8xOLxHUkYcAPp74RoC/UzAj7lgEp6V3ykpwSFyNcXWZt4M/mb1yB
SkDHYkDrPkcI9Je2vY+f87XW5bcHyVr0W9Miuub2atnBjlqsJa1V0atJSY/2vKk/
86gf5DcIqD9wEyhBc1qkyWrIydjwm93kC+3VO1KbyevsBjTyT4RcYLaOj8P9b+ma
63EYL7qiQM9Y6P1Mj2Lz12lc1aSNynYA3SYfW64zbteFgjBzj1D7ca7Np1UavXX4
KyzVOTnfot/Pv6hYZjSjmjG70pxi4rDwy5SGUpstFaLZdf8Y3mXnf+oJsK2GB6vy
v36ye3HtfqAXh3y1Cjpc
=Slbi
-----END PGP SIGNATURE-----

--qVsehd3HWmHQjmB5FRtOvcxXR3p8hVJ7M--


--===============9016262192074380431==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9016262192074380431==--
