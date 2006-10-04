Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Oct 2006 02:41:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k949fJaG008827
	for <xfs@oss.sgi.com>; Wed, 4 Oct 2006 02:41:20 -0700
Received: from mail.automatix.de (www.automatix.de [213.131.230.237])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BE96405B62
	for <xfs@oss.sgi.com>; Wed,  4 Oct 2006 01:39:47 -0700 (PDT)
Received: from uucp by mail.automatix.de with local-bsmtp (Exim 3.36 #1)
	id 1GV2L5-0007mS-00
	for xfs@oss.sgi.com; Wed, 04 Oct 2006 10:42:51 +0200
Received: from pc2.s.automatix.de ([192.168.11.12])
	by s.automatix.de with esmtp (Exim 3.36 #1)
	id 1GV2Eq-0004DW-00
	for xfs@oss.sgi.com; Wed, 04 Oct 2006 10:36:24 +0200
From: Juergen Sauer <juergen.sauer@automatix.de>
Reply-To: juergen.sauer@automatix.de
Subject: Critical Bugreport: Linux Kernel 2.6.17.13, UNUSABLE
Date: Wed, 4 Oct 2006 10:36:19 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1611629.BaUTkEGrPR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200610041036.23291.juergen.sauer@automatix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--nextPart1611629.BaUTkEGrPR
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi!
The XFS System in Kernel 2.6.17.13 is unusable broken.
I have several servers and clients using XFS as root FS.

The Last screen of death (digicam):
http://www.automatix.de/~jojo/xfs-error-kernel-2.6.17.13.jpg

On many systems (Ubuntu 6.06.1 LTS) with own kernel 2.6.17.13 it happens,
that the kernel crashes like the "upper screen dump".

Booting form Knoppix 5.01 CD can _not_ xfs_repair the filesystem.

This bug make the system completely unusable.
It is not possible to "rm -rf" or to get the filesystem in any clean/usable=
 state.

There are no "badblocks" (since hardware RAID 5 controllers like mgega_raid=
, icp vortex, 3ware)
are used.
Installing a fresh, system does show up the problem after somewhat time in =
production again.

So what to do ?
Please help!

mfG
J. Sauer

--=20
J=C3=BCrgen Sauer - AutomatiX GmbH, +49-4209-4699, jojo@automatix.de
Das Linux Systemhaus - Service - Support - Server - L=C3=B6sungen
http://www.automatix.de OpenOffice erhalten Sie hier kostenfrei http://de.o=
penoffice.org/

--nextPart1611629.BaUTkEGrPR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD4DBQBFI3KHW7UKI9EqarERArmXAJ9UiXIMy3qOJ5OwAiUOdroB82FC0ACXXcPK
PH64PtR0joV9KzipA3/h0g==
=YZ8A
-----END PGP SIGNATURE-----

--nextPart1611629.BaUTkEGrPR--
