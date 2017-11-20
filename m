Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39060 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751173AbdKTUPg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 15:15:36 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4EE07628754
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2017 14:15:20 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: master updated to 5bb4307 / v4.14.0-rc2
Message-ID: <eee6bf62-e997-ec85-5e9d-26a23f7ee9f8@sandeen.net>
Date: Mon, 20 Nov 2017 14:15:35 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="coGBjtK4xtn60wX3G98mLvAPCXJ4VnXL0"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--coGBjtK4xtn60wX3G98mLvAPCXJ4VnXL0
Content-Type: multipart/mixed; boundary="wqdi9vtk6uRlILfit0AWKxJimsOgeWqou";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <eee6bf62-e997-ec85-5e9d-26a23f7ee9f8@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: master updated to 5bb4307 / v4.14.0-rc2

--wqdi9vtk6uRlILfit0AWKxJimsOgeWqou
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.14.0-rc2 on the master
branch.

(I've also retroactively updated the release files for rc1, and
this is all now merged to the master branch as well).

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

5bb4307 xfsprogs: Release v4.14.0-rc2

This is likely the last rc; there is a remote possibility that the
ranged fiemap patch will get in yet but I'd like to see the tests
in place for that before merging - so it'll probably slip.

New Commits:

Darrick J. Wong (1):
      [255c38f] xfs_copy: don't hang if /all/ the targets hit write error=
s

Eric Sandeen (2):
      [84fe80c] xfsprogs: Release v4.14.0-rc1 (*cough*)
      [5bb4307] xfsprogs: Release v4.14.0-rc2

Goldwyn Rodrigues (4):
      [68c269c] xfs_io: Disable -V if pwritev is not available
      [c5deeac] xfs_io: Add support for pwritev2()
      [0799d5c] xfs_io: Add RWF_NOWAIT to pwritev2()
      [43ba1d6] xfs_io: Allow partial writes

Jeff Mahoney (2):
      [8bb344f] xfs_io: stat: fix typo in statfs->f_flags
      [ce9adab] xfs_io: stat: treat statfs.f_flags as optional

Zirong Lang (2):
      [421c922] xfsprogs: fix wrong variable types in pwrite/pread code
      [ac9a7bc] xfsprogs: fix wrong do_pwritev definition


Code Diffstat:

 VERSION               |  4 +--
 configure.ac          |  4 ++-
 copy/xfs_copy.c       | 12 +++++++
 doc/CHANGES           | 17 +++++++++
 include/builddefs.in  |  2 ++
 io/Makefile           |  8 +++++
 io/io.h               |  1 +
 io/pread.c            | 12 +++----
 io/pwrite.c           | 97 ++++++++++++++++++++++++++++++++++++++++-----=
------
 io/stat.c             |  4 ++-
 m4/package_libcdev.m4 | 30 ++++++++++++++++
 man/man8/xfs_io.8     | 31 ++++++++++------
 12 files changed, 180 insertions(+), 42 deletions(-)


--wqdi9vtk6uRlILfit0AWKxJimsOgeWqou--

--coGBjtK4xtn60wX3G98mLvAPCXJ4VnXL0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAloTN+cACgkQIK4WkuE9
3uB5Tw/+N5NMxswbrFPa6td3jloIVAMMIGH2jqXCxBgHrCOwnKj6orqdsqaBx429
+rNoO6kOIOARZtNA7rkOXP+bodF3zPBr27T6JqIvq2use/UxEdKhaUjYoZo7AMYZ
SFOPPnnepDdBEWgHBfQH1wiY8csfrwNvSILmDk96i9+MNyc/hOIp31uUJrBnZNy4
eW2gRN2zBcFsTvXOVMeS1YQg7ByGTUPTLR0wp0mBOIdn2HD8iuhFaOaGxMiSoiCQ
O8dJBios7IIAuJ8Nct5MMAPRiaL19CRvzGzDpIzNGp+pI6FQrpg1Rbk8AiWJG6ty
d1NLmZE+Br5Uz5i0P00ki2Sxi1G7xdbJVF6c0lsENqd1tho2tnv4FqUEpEbhgAQg
78fqA4OOTRq/MnmD81RLK10O3DmFLof6bkiPl9r0SY6vdJo+YxeurXRfjenEIfDt
Z5JQUckdC8P0OVdjNyuvWKQCueoCmZ4vJQbdCalqFKLVA1nAsVI4bsCIo3J0S3c7
VTIDiDZ0+SYN3F0Lpklt5FEsGGvSKP7QqDz9zTYYaSDjkGFfO/aGHoKEir4XXooa
kaXj+do2r2Op2Mr44KEliWX/NfcGAl1EBuAZcZ+1CWxmoIhbU5y8ZGr32oHRV5a2
nMKteH76Y5ncT+cXPgbHdHCLSXbaKVSycbQwVgOSUUBidjVGqE8=
=zziU
-----END PGP SIGNATURE-----

--coGBjtK4xtn60wX3G98mLvAPCXJ4VnXL0--
