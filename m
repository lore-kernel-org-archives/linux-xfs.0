Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36972 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbfHKNG1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 11 Aug 2019 09:06:27 -0400
Received: from [IPv6:2001:4dd6:c89b:0:149a:6c9b:d6bb:ae22] (2001-4dd6-c89b-0-149a-6c9b-d6bb-ae22.ipv6dyn.netcologne.de [IPv6:2001:4dd6:c89b:0:149a:6c9b:d6bb:ae22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: whissi)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 1B7793498DD
        for <linux-xfs@vger.kernel.org>; Sun, 11 Aug 2019 13:06:24 +0000 (UTC)
From: Thomas Deutschmann <whissi@gentoo.org>
Subject: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined reference
 to `xfs_ag_geom_health'
Message-ID: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
Date: Sun, 11 Aug 2019 15:06:13 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="aduwMIZJ5TV5fV939CWFI9tKvSTNlM56g"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aduwMIZJ5TV5fV939CWFI9tKvSTNlM56g
Content-Type: multipart/mixed; boundary="Yt7XgXB1tYWiJt658E0deFWxeB9wNMjLP";
 protected-headers="v1"
From: Thomas Deutschmann <whissi@gentoo.org>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
Subject: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined reference
 to `xfs_ag_geom_health'

--Yt7XgXB1tYWiJt658E0deFWxeB9wNMjLP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

building xfsprogs-5.2.0 is failing with the following error:

>     [CC]     xfs_copy.o
> x86_64-pc-linux-gnu-gcc -O2 -pipe -march=3Divybridge -mtune=3Divybridge=
 -mno-xsaveopt -frecord-gcc-switches -D_FILE_OFFSET_BITS=3D64 -O2 -pipe -=
march=3Divybridge -mtune=3Divybridge -mno-xsaveopt -frecord-gcc-switches =
 -O2 -pipe -march=3Divybridge -mtune=3Divybridge -mno-xsaveopt -frecord-g=
cc-switches -DNDEBUG -DVERSION=3D\"5.2.0\" -DLOCALEDIR=3D\"/usr/share/loc=
ale\" -DPACKAGE=3D\"xfsprogs\" -I../include -I../libxfs -DENABLE_GETTEXT =
-D_GNU_SOURCE -funsigned-char -fno-strict-aliasing -Wall -DHAVE_MNTENT -D=
HAVE_FSETXATTR -DENABLE_BLKID -DHAVE_GETFSMAP  -c xfs_copy.c
>     [LD]     xfs_copy
> /bin/bash ../libtool --quiet --tag=3DCC --mode=3Dlink x86_64-pc-linux-g=
nu-gcc -o xfs_copy -Wl,-O1 -Wl,--as-needed  -Wl,-O1 -Wl,--as-needed   -Wl=
,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed   xfs_copy.o   ../libxfs/l=
ibxfs.la ../libxlog/libxlog.la ../libfrog/libfrog.la -luuid -lpthread -lr=
t =20
> /usr/lib/gcc/x86_64-pc-linux-gnu/9.1.0/../../../../x86_64-pc-linux-gnu/=
bin/ld: ../libxfs/.libs/libxfs.so: undefined reference to `xfs_ag_geom_he=
alth'
> collect2: error: ld returned 1 exit status
> gmake[2]: *** [../include/buildrules:65: xfs_copy] Error 1
> gmake[1]: *** [include/buildrules:36: copy] Error 2
> make: *** [Makefile:92: default] Error 2


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--Yt7XgXB1tYWiJt658E0deFWxeB9wNMjLP--

--aduwMIZJ5TV5fV939CWFI9tKvSTNlM56g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl1QEstfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDEz
MTI5MUNFOEY4QjBENzI2MDVDN0I5NDQ0RTZFQkRDOUJGNjA1NTkACgkQRObr3Jv2
BVkJSQf/aiZj39iSC/cr5QbTkCDg966e/71MHXUHg997PwyDudgyfGuJHPbM8R7g
cc0i0NaGeQl88pAyx2wsmINhg6FYf0bIYRY6HAsqH8LWDJVKPTGdJbgZBRERGIAx
n/YEUu4GO8wzzKdV7RL3dcrU8Yu8+OUE/ESsCFrfW/s0vDStTUPM2JnetZqakRZd
baOO/uFzAEvOiIcUzCZoadrXU/DLafSe/gYE4zYPffkK/SaxrEYvOcS7pMj07gS3
kboPnOcAO6ZC5SVzlA12HBh2Q1wsTJasatLIZ+GFYDMgtCldtBFS51W/ohzSgPuM
EUgjdb1/oZymoTX8XvW5fzwu+Uf77Q==
=ZPnV
-----END PGP SIGNATURE-----

--aduwMIZJ5TV5fV939CWFI9tKvSTNlM56g--
