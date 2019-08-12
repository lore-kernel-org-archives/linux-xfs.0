Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54370 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbfHLBVj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 11 Aug 2019 21:21:39 -0400
Received: from [IPv6:2001:4dd6:c89b:0:149a:6c9b:d6bb:ae22] (2001-4dd6-c89b-0-149a-6c9b-d6bb-ae22.ipv6dyn.netcologne.de [IPv6:2001:4dd6:c89b:0:149a:6c9b:d6bb:ae22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: whissi)
        by smtp.gentoo.org (Postfix) with ESMTPSA id B1B9034992E
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 01:21:36 +0000 (UTC)
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
From: Thomas Deutschmann <whissi@gentoo.org>
Message-ID: <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
Date: Mon, 12 Aug 2019 03:21:28 +0200
MIME-Version: 1.0
In-Reply-To: <20190812002306.GH7777@dread.disaster.area>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="3zqWurH15WEVzZn119NZKn5vzL4izrk8u"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3zqWurH15WEVzZn119NZKn5vzL4izrk8u
Content-Type: multipart/mixed; boundary="xh4DQbO1yk1tBLrab7ekrGKT35rFElrJH";
 protected-headers="v1"
From: Thomas Deutschmann <whissi@gentoo.org>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
In-Reply-To: <20190812002306.GH7777@dread.disaster.area>

--xh4DQbO1yk1tBLrab7ekrGKT35rFElrJH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-08-12 02:23, Dave Chinner wrote:
> That still doesn't explain where all the whacky gcc options are
> coming from - that's got to be something specific to your build or
> distro environment.

Mh, at the moment it looks like xfsprogs' build system is adding
$LDFLAGS multiple times when LDFLAGS is set in environment.

In a clear environment, do:

> tar -xaf xfsprogs-5.2.0.tar.xz
> cd xfsprogs-5.2.0
> export CFLAGS=3D"-O2 -pipe -march=3Divybridge -mtune=3Divybridge -mno-x=
saveopt"
> export LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed"
> ./configure
> make V=3D1

And you will end up

> /bin/bash ../libtool --quiet --tag=3DCC --mode=3Dlink x86_64-pc-linux-g=
nu-gcc -o xfs_repair -Wl,-O1 -Wl,--as-needed  -Wl,-O1 -Wl,--as-needed   -=
Wl,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed -static-libtool-libs  ag=
header.o attr_repair.o avl.o bmap.o btree.o da_util.o dino_chunks.o dinod=
e.o dir2.o globals.o incore.o incore_bmc.o init.o incore_ext.o incore_ino=
=2Eo phase1.o phase2.o phase3.o phase4.o phase5.o phase6.o phase7.o progr=
ess.o prefetch.o rmap.o rt.o sb.o scan.o slab.o threads.o versions.o xfs_=
repair.o   ../libxfs/libxfs.la ../libxlog/libxlog.la ../libxcmd/libxcmd.l=
a ../libfrog/libfrog.la -luuid -lrt -lpthread -lblkid


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--xh4DQbO1yk1tBLrab7ekrGKT35rFElrJH--

--3zqWurH15WEVzZn119NZKn5vzL4izrk8u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl1QvxhfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDEz
MTI5MUNFOEY4QjBENzI2MDVDN0I5NDQ0RTZFQkRDOUJGNjA1NTkACgkQRObr3Jv2
BVmZTAf+Md5TzvB+pGOmgTi5jQ2YQPO44Jy+I8aPrFrqY60E2oeSjwrcdHcrr836
VryoS6aP55OfANffw/aE4ugRB0NN8KPyUNgAaJs28+LDzypbhwbPFqH411Lz2Y7O
S7dEvoV+J3WfXBnaSwzVZsXVBg6tXpjYimjq6RCaRdryNF64pA4rKbJSpld4V/Kz
Yn3qyfUxWyLARVJ5l6nBXYEdlMEF+9rcUDjkkBGY7aX2LQUc+MX8P7Fb0kJuACQR
NY+q8/H7g68Wkci39K9XXtwoYXOPI/O9r85T12UFBNJvZV5COctieMYMY//uDSla
hl9+lRAWbrpd9NuFo/P5h798EDDfuw==
=sG3l
-----END PGP SIGNATURE-----

--3zqWurH15WEVzZn119NZKn5vzL4izrk8u--
