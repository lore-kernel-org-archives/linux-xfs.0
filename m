Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39448 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753969AbeGEUdV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Jul 2018 16:33:21 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DB34AB6E
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jul 2018 15:32:54 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to bf297b1
Message-ID: <c70d00b8-c754-166f-1f07-37cbeea4e7c7@sandeen.net>
Date: Thu, 5 Jul 2018 15:33:17 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CKMkBRtDot7B8yR3cWwGqVfYwvWMfy1LU"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CKMkBRtDot7B8yR3cWwGqVfYwvWMfy1LU
Content-Type: multipart/mixed; boundary="vcz3vtl9z9zggjIu1GsCWqVFoVLU44wWe";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <c70d00b8-c754-166f-1f07-37cbeea4e7c7@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to bf297b1

--vcz3vtl9z9zggjIu1GsCWqVFoVLU44wWe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is really only the libxfs sync, so no need to panic if your patches
are not yet included.

The new head of the for-next branch is commit:

bf297b1 xfsprogs: Release v4.18.0-rc0

Note:

I've decided to start tagging things with -rc0 once the majority of libxf=
s
is synced up after the previous point release so that tarballs, packages,=
 etc
have a version newer than the last point release.  It was confusing and a=

hassle to be creating "4.17.0" tarballs well past the 4.17.0 point releas=
e.

If this bothers people let me know, for-next is still malleable.  ;)

New Commits:

Darrick J. Wong (3):
      [5b50159] xfs: don't allow insert-range to shift extents past the m=
aximum=20
      [a4b61d9] xfs: fix off-by-one error in xfs_rtalloc_query_range
      [2d49506] xfs: fix fdblocks accounting w/ RMAPBT per-AG reservation=


Dave Chinner (1):
      [8ac50ba] xfs: More robust inode extent count validation

Eric Sandeen (1):
      [bf297b1] xfsprogs: Release v4.18.0-rc0


Code Diffstat:

 VERSION                |  4 +--
 configure.ac           |  2 +-
 debian/changelog       |  7 +++++
 doc/CHANGES            |  3 ++
 libxfs/xfs_ag_resv.c   | 31 +++++++++++++++++---
 libxfs/xfs_bmap.c      | 26 +++++++++++++++++
 libxfs/xfs_bmap.h      |  2 ++
 libxfs/xfs_format.h    |  5 ++++
 libxfs/xfs_inode_buf.c | 76 +++++++++++++++++++++++++++++++-------------=
------
 libxfs/xfs_rtbitmap.c  |  4 +--
 10 files changed, 122 insertions(+), 38 deletions(-)


--vcz3vtl9z9zggjIu1GsCWqVFoVLU44wWe--

--CKMkBRtDot7B8yR3cWwGqVfYwvWMfy1LU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAls+gI4ACgkQIK4WkuE9
3uDhWA/8C5Ar5AA4scuwVTDjVQck38qvjxxz0VHCubyy2GbntNAJJviHoSaKlbjl
cAsOcJm3IOyLuidsl+MyvN9Knia0sUL+tJWCJ+rHvxKhYzlS3quW6/cnL//K4HvC
8td7CBCrX1K1zO7atDhnj/CLogfjP4KaJi9tSuScEVCyeY64gKbbWF3cwClGkQXJ
6BstvNczsLxziuDZKIHulU488Rsduzas7K1bIAkkt+QZgHuXuul2rXPU1PuB9Elh
R6C9Z/nVLluYg5ToNz0lcFYanwZIL/LijxLOp55WWPboK5mKG49OVJbpIKgN8H07
n2BgTE9qpDpYYfySQgJ7O+Dz3rP5dc8d+I4XlJanEG1k8zwf7Sl62y0vHhwqOpGW
QqqNP3AUa55jHx12bwiOzFRa6HjJvfVyxucDJK5p1yzb/6GpRz6/+7USyU767Jxi
uWEvdyvFuYsYjGr2M0MFdCULFyu/g5ZfxDujsDWvTiKHadD591PuJODe5gTl46Ed
ZzQa3f5XuCRjMkCQZUZIDgEKkDR3Ewsure3Rdz4n2cVnN16E91/ScNuaGaJzylHC
FV2i8xa2RkWt3DuVh6SmPNjPLrSkQlhZQA8fG5K2k0TJGcthqmjdekBOLnYcDhgT
hd+DutRjeohngjk+KX2v+oOj71gO4nSJ0c7ZBTeBwtFupqWsLdI=
=Cnzc
-----END PGP SIGNATURE-----

--CKMkBRtDot7B8yR3cWwGqVfYwvWMfy1LU--
