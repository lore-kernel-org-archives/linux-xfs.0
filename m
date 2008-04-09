Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 11:40:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39IegoC002535
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 11:40:43 -0700
Received: from minas.ics.muni.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 966EC76DD94
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 11:41:18 -0700 (PDT)
Received: from minas.ics.muni.cz (minas.ics.muni.cz [147.251.4.40]) by cuda.sgi.com with ESMTP id kbrVL2VhbHHDDEPI for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 11:41:18 -0700 (PDT)
Received: from dior.ics.muni.cz (dior.ics.muni.cz [147.251.6.10])
	by minas.ics.muni.cz (8.13.8/8.13.8/SuSE Linux 0.8) with ESMTP id m39IfGBR031952
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 20:41:17 +0200
Received: from album.ics.muni.cz (album.ics.muni.cz [147.251.23.20])
	by dior.ics.muni.cz (8.13.8+Sun/8.13.8) with SMTP id m39IfGm4015135
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 20:41:16 +0200 (CEST)
Date: Wed, 9 Apr 2008 20:41:08 +0200
From: petr.pisar@atlas.cz
Subject: Portability of libattr
Message-ID: <20080409184103.GD20142@album.bayer.ipv6ia.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NGIwU0kFl1Z1A3An"
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--NGIwU0kFl1Z1A3An
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I'm adding support for extended atributes into few applications.
Unfortunatetally API for EA manipulation is not standartized and every
operating system uses its own solution. I thought libattr from attr package
could help me. However attr seems running on Linux (and maybe IRIX) only.

Therefore I've decided to use libc functions from every system directly. I've
succesfully ported my code to Linux, IRIX and Darwin (Max OS X). Their AE
syscalls are very similar. However FreeBSD API is more different. Because I'm
extending more applications I need to share the code.

So, my qustions are: should I write my own library or should I extend libattr.
As I can understand libattr code it's designed to port IRIX application on
Linux. Am I right? Or are you going support more OS's in libattr? Or exists
here some similar library providing unified interface fro more systems?

-- Petr

--NGIwU0kFl1Z1A3An
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH/Q2/uR4f4nEwzHIRAkCrAJsFOvjgIGgcaDSrX83ONhOzaWOOvwCdFFaT
jqKFnvlMxzfFvlEI43yymaQ=
=B2Ha
-----END PGP SIGNATURE-----

--NGIwU0kFl1Z1A3An--
