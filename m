Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35222 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfHKXa6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 11 Aug 2019 19:30:58 -0400
Received: from [IPv6:2001:4dd6:c89b:0:149a:6c9b:d6bb:ae22] (2001-4dd6-c89b-0-149a-6c9b-d6bb-ae22.ipv6dyn.netcologne.de [IPv6:2001:4dd6:c89b:0:149a:6c9b:d6bb:ae22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: whissi)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 64797349929
        for <linux-xfs@vger.kernel.org>; Sun, 11 Aug 2019 23:30:55 +0000 (UTC)
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
From: Thomas Deutschmann <whissi@gentoo.org>
Message-ID: <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
Date: Mon, 12 Aug 2019 01:30:46 +0200
MIME-Version: 1.0
In-Reply-To: <20190811225307.GF7777@dread.disaster.area>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="0LyhI2gSMAd5KnSQpsDb7e0dGUuObqNAS"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0LyhI2gSMAd5KnSQpsDb7e0dGUuObqNAS
Content-Type: multipart/mixed; boundary="0qNp8zM7VPKNyRN79gvT6nNxrF16d1Efm";
 protected-headers="v1"
From: Thomas Deutschmann <whissi@gentoo.org>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
In-Reply-To: <20190811225307.GF7777@dread.disaster.area>

--0qNp8zM7VPKNyRN79gvT6nNxrF16d1Efm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-08-12 00:53, Dave Chinner wrote:
> How did you configure this build? Can you run a clean build without
> configuring in any of the whacky compiler super-optimisations that
> you have and see if that builds cleanly?

Just add

  --disable-static

and you should be able to reproduce. This option will cause that 3x
"-Wl,-O1 -Wl,--as-needed  " will be passed to the linker.

Complete configure we are using and which worked fine with xfsprogs-5.1.0=
:

--prefix=3D/usr --build=3Dx86_64-pc-linux-gnu --host=3Dx86_64-pc-linux-gn=
u
--mandir=3D/usr/share/man --infodir=3D/usr/share/info --datadir=3D/usr/sh=
are
--sysconfdir=3D/etc --localstatedir=3D/var/lib
--docdir=3D/usr/share/doc/xfsprogs-5.2.0
--htmldir=3D/usr/share/doc/xfsprogs-5.2.0/html --with-sysroot=3D/
--libdir=3D/usr/lib64 --disable-lto --enable-blkid
--with-crond-dir=3D/etc/cron.d --with-systemd-unit-dir=3D/lib/systemd/sys=
tem
--disable-libicu --enable-gettext --enable-readline --disable-editline
--disable-static


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--0qNp8zM7VPKNyRN79gvT6nNxrF16d1Efm--

--0LyhI2gSMAd5KnSQpsDb7e0dGUuObqNAS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl1QpSZfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDEz
MTI5MUNFOEY4QjBENzI2MDVDN0I5NDQ0RTZFQkRDOUJGNjA1NTkACgkQRObr3Jv2
BVmJkQf/RG7YHF2TwNJp2ZDguTOgZazcB3p73M6mtKnPYQTyzwroCuPB5cb+Fz+s
ckpAzzC6BBkWe2WgJ4YtnrpqFJzSNvos8WPG4z0NOKYg2n5kuuxaF8NF/HzSO7kR
ST3xtK7u+u54AIwECRfa3diZJWvJicRzkb8f9a6zxjYBeuEa/XZyDk355DYA0k4V
JzkOLI5BANrBlQO+Xrbve9wQUczGxbV2VE3Gfg5B4x8bxE76jpcovIxR6Xqpr+fj
O4MT6GL7ClbfhmZWKYVrGVEbmPyuTofDbzG+/5T+3y3DIFLW3ILpmk5X3CQmYegE
dfFUdYLmEmUKVp4UizJ4OwpGBNMDSA==
=C1kP
-----END PGP SIGNATURE-----

--0LyhI2gSMAd5KnSQpsDb7e0dGUuObqNAS--
