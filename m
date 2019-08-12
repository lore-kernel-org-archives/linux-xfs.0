Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34112 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfHLK5p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Aug 2019 06:57:45 -0400
Received: from [IPv6:2001:4dd6:f35f:0:149a:6c9b:d6bb:ae22] (2001-4dd6-f35f-0-149a-6c9b-d6bb-ae22.ipv6dyn.netcologne.de [IPv6:2001:4dd6:f35f:0:149a:6c9b:d6bb:ae22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: whissi)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 1658B349972
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 10:57:41 +0000 (UTC)
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
From: Thomas Deutschmann <whissi@gentoo.org>
Message-ID: <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
Date: Mon, 12 Aug 2019 12:57:32 +0200
MIME-Version: 1.0
In-Reply-To: <20190812043046.GB6129@dread.disaster.area>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Ev48FaiHfMOM8Ci7y760sesN7JvyGwroA"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ev48FaiHfMOM8Ci7y760sesN7JvyGwroA
Content-Type: multipart/mixed; boundary="nFfiI8eyexJ6WE9akVGZkTVKWsDYNEzRl";
 protected-headers="v1"
From: Thomas Deutschmann <whissi@gentoo.org>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
In-Reply-To: <20190812043046.GB6129@dread.disaster.area>

--nFfiI8eyexJ6WE9akVGZkTVKWsDYNEzRl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

On 2019-08-12 06:30, Dave Chinner wrote:
>>> In a clear environment, do:
>>>
>>>> tar -xaf xfsprogs-5.2.0.tar.xz
>>>> cd xfsprogs-5.2.0
>>>> export CFLAGS=3D"-O2 -pipe -march=3Divybridge -mtune=3Divybridge -mn=
o-xsaveopt"
>>>> export LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed"
>>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> Don't do this.
>>
>> "--as-needed" is the default linker behaviour since gcc 4.x. You do
>> not need this. As for passing "-O1" to the linker, that's not going
>> to do anything measurable for you. Use --enable-lto to turn on link
>> time optimisations if they are supported by the compiler.
>=20
> Ok, I could reproduce your link time failure for a while with
> --enable-lto, but I ran 'make distclean' and the problem went away
> completely. And I can build with your options successfully, too:
>=20
> $ make realclean
> $ make configure
> <builds new configure script>
> $ LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed" ./configure

That's not the correct way to reproduce. It's really important to
_export_ the variable to trigger the problem and _this_ is a problem in
xfsprogs' build system.

But keep in mind that 3x "-Wl,-O1 -Wl,--as-needed" don't cause a failure
without "--disable-static" for me... that's just the answer for your
question where this is coming from.


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--nFfiI8eyexJ6WE9akVGZkTVKWsDYNEzRl--

--Ev48FaiHfMOM8Ci7y760sesN7JvyGwroA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl1RRhxfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDEz
MTI5MUNFOEY4QjBENzI2MDVDN0I5NDQ0RTZFQkRDOUJGNjA1NTkACgkQRObr3Jv2
BVn3xgf+OevUJPOZ8/iEb4QyzdDr2dx/bwL/M7hP7oWadGGWj7QuPeYYL7XnszRc
pphOURc8XoJ6gbzIaN6r9Z12j3XUgGXWM1xZssPBA77uAkXAp4HTlATxcnmSfCdt
8a/2HgyKWduuGF6CAQ/PnLq/i4RR0U3zEUfiNhVVHZTthq1v+r2iR9ReDRYJ8s2T
Tf84XjguS7M5qPgQPoviDLIh4tjEGD4SERefL/shls591cll+Vgmxkhr6bpsoRNv
+elcCccyISw9ivaqApiRv+4hKbPCpx6apuMjAo7gYTJNW+THv9GD4qZzjWmaGY2a
Ga1QFPOC3oo7g2H4Zu9dUOHYjC9p3w==
=CVkQ
-----END PGP SIGNATURE-----

--Ev48FaiHfMOM8Ci7y760sesN7JvyGwroA--
