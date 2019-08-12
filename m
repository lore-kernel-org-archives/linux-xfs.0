Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42770 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbfHLQfA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Aug 2019 12:35:00 -0400
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5aff83b5-2ff3-4c2c-e0ef-c04bc506fe4f@sandeen.net>
Date: Mon, 12 Aug 2019 11:34:56 -0500
MIME-Version: 1.0
In-Reply-To: <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pisG2onWkJFSznO9hIZiEMsNQHioRVFCH"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Deutschmann <whissi@gentoo.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pisG2onWkJFSznO9hIZiEMsNQHioRVFCH
Content-Type: multipart/mixed; boundary="pvSy01QCrO70y4in7HudnJ6LFvlFw2ebk";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Thomas Deutschmann <whissi@gentoo.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <5aff83b5-2ff3-4c2c-e0ef-c04bc506fe4f@sandeen.net>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
In-Reply-To: <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>

--pvSy01QCrO70y4in7HudnJ6LFvlFw2ebk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/12/19 5:57 AM, Thomas Deutschmann wrote:
> Hi,
>=20
> On 2019-08-12 06:30, Dave Chinner wrote:
>>>> In a clear environment, do:
>>>>
>>>>> tar -xaf xfsprogs-5.2.0.tar.xz
>>>>> cd xfsprogs-5.2.0
>>>>> export CFLAGS=3D"-O2 -pipe -march=3Divybridge -mtune=3Divybridge -m=
no-xsaveopt"
>>>>> export LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed"
>>>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> Don't do this.
>>>
>>> "--as-needed" is the default linker behaviour since gcc 4.x. You do
>>> not need this. As for passing "-O1" to the linker, that's not going
>>> to do anything measurable for you. Use --enable-lto to turn on link
>>> time optimisations if they are supported by the compiler.
>>
>> Ok, I could reproduce your link time failure for a while with
>> --enable-lto, but I ran 'make distclean' and the problem went away
>> completely. And I can build with your options successfully, too:
>>
>> $ make realclean
>> $ make configure
>> <builds new configure script>
>> $ LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed" ./configure
>=20
> That's not the correct way to reproduce. It's really important to
> _export_ the variable to trigger the problem and _this_ is a problem in=

> xfsprogs' build system.
>=20
> But keep in mind that 3x "-Wl,-O1 -Wl,--as-needed" don't cause a failur=
e
> without "--disable-static" for me... that's just the answer for your
> question where this is coming from.

My takeaway here is that I should probably stub out some things to make
this issue go away altogether, but that it can also be remedied by adjust=
ing
compiler/linker flags.  Correct?  I'm not sure if this warrants a 5.2.1 r=
elease.

Thanks,
-Eric


--pvSy01QCrO70y4in7HudnJ6LFvlFw2ebk--

--pisG2onWkJFSznO9hIZiEMsNQHioRVFCH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIyBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl1RlTAACgkQIK4WkuE9
3uDRqw/2JkVJuPr3AymxYLg3I/Jqkni/HQpxiaCwdSkRZIkws28EmADzyAn1Gf5B
/Bo+OHIXnHKKfc/C2PvL7wd7jzy7mSOWRmsftnVWx/4DIVsX2eICpqo3DJdhjBa/
Tf7/bzvhF+CJ0uuqWzm0FPmFoSOFNhohWWO+hqPCjHRGIRwJFGqOFMeg8Nt/8zTh
MF8kFLymMQEnTJreWgZ31Id2pZr+PzMPl53Djj9faDKn6g3fCdIGgERBJSIgdjwf
OaQ5X4gmusuv3U6IpkOgAz/tm+KwXmdA3OSCp8LwUVb/06xa/pQKKlgRczCkSTuy
yUFMS2uswsgPkkr4qqUz3NTgqghY8R4Yc16v/A7TLaJ0BfLY8Ti5/X6J8+Vdt60J
GTlLa42i3z350kriNX0/BSMVbsZS2xF4UlMxWZSVCfIJWWM4nfLvF603UJWqjGbx
ljVDNhGYoWAj1LRKwpZXcPh8SRy/jS5A08/HsAnnDUiEfSGhBNkgMwcXIzxmZU65
yLCMiS3Vr096L+z8T0oFE4+ZWyaGCpluh6R2kLAD1axTiMI6BR7dxk/tF5lt82NJ
gUy3M3pYb6wUUILH9qbHNbKCmELVdJULb5mFhb3/3G7KwamJ4JyflE65dA6/kua1
75glPdIrpWh43Xk6UaBvh2JInYIGmEyO4yY9MzG7stEN4wFUXw==
=RUc+
-----END PGP SIGNATURE-----

--pisG2onWkJFSznO9hIZiEMsNQHioRVFCH--
