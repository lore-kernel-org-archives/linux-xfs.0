Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45026 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729190AbfHMNwp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 09:52:45 -0400
Received: from [IPv6:2001:4dd3:5b97:0:81f6:d4ff:3bc1:68c7] (2001-4dd3-5b97-0-81f6-d4ff-3bc1-68c7.ipv6dyn.netcologne.de [IPv6:2001:4dd3:5b97:0:81f6:d4ff:3bc1:68c7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: whissi)
        by smtp.gentoo.org (Postfix) with ESMTPSA id D424A349A4F
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 13:52:41 +0000 (UTC)
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
 <20190812214449.GC6129@dread.disaster.area>
 <ddabd271-2820-85f3-4393-99deb5a0eaef@gentoo.org>
 <20190813010447.GE6129@dread.disaster.area>
From: Thomas Deutschmann <whissi@gentoo.org>
Message-ID: <93adbd5c-1231-a94e-f44c-33bd79e26cdf@gentoo.org>
Date: Tue, 13 Aug 2019 15:52:31 +0200
MIME-Version: 1.0
In-Reply-To: <20190813010447.GE6129@dread.disaster.area>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="32nNwqMrD2dVklS1S56I2fsp9yWTIFyrP"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--32nNwqMrD2dVklS1S56I2fsp9yWTIFyrP
Content-Type: multipart/mixed; boundary="Ip1wRxRTw3mnpuRVWuJnQ5LZ3t5iWI7M5";
 protected-headers="v1"
From: Thomas Deutschmann <whissi@gentoo.org>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <93adbd5c-1231-a94e-f44c-33bd79e26cdf@gentoo.org>
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
 <20190812214449.GC6129@dread.disaster.area>
 <ddabd271-2820-85f3-4393-99deb5a0eaef@gentoo.org>
 <20190813010447.GE6129@dread.disaster.area>
In-Reply-To: <20190813010447.GE6129@dread.disaster.area>

--Ip1wRxRTw3mnpuRVWuJnQ5LZ3t5iWI7M5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-08-13 03:04, Dave Chinner wrote:
>> Normally, configure will get the value and the Makefiles will use the
>> value _from_ configure... but using configure _and_ reading _and addin=
g_
>> values from environment _in addition_ seems to be wrong.
>=20
> <sigh>
>=20
> xfsprogs-2.7.18 (16 May 2006)
>         - Fixed a case where xfs_repair was reporting a valid used
>           block as a duplicate during phase 4.
>         - Fixed a case where xfs_repair could incorrectly flag extent
>           b+tree nodes as corrupt.
>         - Portability changes, get xfs_repair compiling on IRIX.
>         - Parent pointer updates in xfs_io checker command.
>         - Allow LDFLAGS to be overridden, for Gentoo punters.
> 	  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> Back in 2006 we added the ability for LDFLAGS to be overriden
> specifically because Gentoo users wanted it.

Well, you got us :-)

Sorry, I wasn't around 2006 and don't know all details. Looks
like commit https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit=
/?id=3D4d32d744f07ce74abac7029c3ee7c6f5e4238d25 caused that
changelog entry.

The request itself, that user should be able to overwrite
CFLAGS/LDFLAGS, is valid. However, I haven't check implementation
yet and I guess that it was implemented the wrong way:

It was and it still is a common problem that people do autotools
wrong when it comes to CFLAGS/LDFLAGS handling. I.e. project
should define two values:

- Initial CFLAGS/LDFLAGS in case user didn't provide these flags.
However, this value will be _overwritten_ when user provided these
flags

- Additional, required general flags. This value will get appended
to previous value.

Autotools will now define one single variable containing these
two values which should be used. If you are now going to link
against an additional dependency you will set CFLAGS/LDFLAGS
just for this component which usually starts with the variable
from above (=3Dthe general CFLAGS/LDFLAGS variable) but will usually
contain component specific CFLAGS/LDFLAGS in addition (for
example when linking against a library which will provide
pkg-config file you will import lib specific CFLAGS/LDFLAGS).

Sorry if this will sound like I am teaching you something. I
guess you all know that (and probably far better than me).

Back to xfsprogs: When you pass your default CFLAGS/LDFLAGS
to configure and different to make, i.e.

CFLAGS=3D"-O2 -pipe -march=3Divybridge -mtune=3Divybridge -mno-xsaveopt -=
frecord-gcc-switches" \
LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed" \
=2E/configure

and=20

CFLAGS=3D"-O2 -pipe -march=3Dnative" \
LDFAGS=3D"-Wl,-fno-lto" \
make V=3D1

you will see

> /bin/bash ../libtool --quiet --tag=3DCC --mode=3Dlink gcc -o mkfs.xfs -=
Wl,-fno-lto  -Wl,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed   -Wl,-O1 =
-Wl,--as-needed -static-libtool-libs  proto.o xfs_mkfs.o   ../libxfs/libx=
fs.la ../libxcmd/libxcmd.la ../libfrog/libfrog.la -lrt -lpthread -lblkid =
-luuid

So we still have 3x "-Wl,-O1 -Wl,--as-needed" which is LDFLAGS
value passed to configure. LDFLAGS from environment is only
picked up once (which is still wrong).


> Yup, but Gentoo wanted it both ways, and so we gave them that
> capability.  And now you're complaining that Gentoo users can shoot
> themselves in the foot with it.... :/

Where is that coming from? From reading a few bugs from that time
in Gentoo and reading our ebuild sources I can say that we were
already using autotools for xfsprogs. So it looks like xfsprogs
was facing the problem I mentioned in the beginning.

To make it clear: Makefile should only use configure values (which
isn't the case at the moment) and configure should  of course
honor environment variables (which it already does).


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--Ip1wRxRTw3mnpuRVWuJnQ5LZ3t5iWI7M5--

--32nNwqMrD2dVklS1S56I2fsp9yWTIFyrP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl1SwKRfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDEz
MTI5MUNFOEY4QjBENzI2MDVDN0I5NDQ0RTZFQkRDOUJGNjA1NTkACgkQRObr3Jv2
BVkdgwf+O3AVGEOdXl4tkHW9K7LGKSwf9EPZKu5UWsxn6V7YtJAAY+HYGbEbBm6W
2yjI+XaVYjMYvr1oDTFKiGo+cVY/enihvr73ovOP/V8B+NuOq45yVEvRI038VL85
/lN/i0DDrMlfX9NFKAqtZUaWFPGZuHOZ7RmPxOgg69xs8LkDGLOZwxV1O2r5wM0D
L/Ha/Cs/Go6XV2MrvK1xcZkw5v72UK9Zz8nTPzJe9QK/Yn79llLD/5zsmy4Ylb6l
ln9vXlRwRCxkMuTN+MXsc6vYAVlq2aSNjPorL7AK598zwfupTH7cpU0Ptd8lA9Ws
99r7etlP3d6BtGgX+Fxyf7A5YNQcZA==
=3ocF
-----END PGP SIGNATURE-----

--32nNwqMrD2dVklS1S56I2fsp9yWTIFyrP--
