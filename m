Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46520 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfDZWIc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Apr 2019 18:08:32 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7783887E
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2019 17:07:43 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs master updated to b8aba37
Message-ID: <efa25d98-cadf-c937-5649-c6d829309631@sandeen.net>
Date: Fri, 26 Apr 2019 17:08:29 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="K0IRY60EMdtlpsCoUu8ONKgge9tapULIg"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K0IRY60EMdtlpsCoUu8ONKgge9tapULIg
Content-Type: multipart/mixed; boundary="uz8J5oHfYgazXPpxScJ6dtduG0pVTBSap";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <efa25d98-cadf-c937-5649-c6d829309631@sandeen.net>
Subject: [ANNOUNCE] xfsprogs master updated to b8aba37

--uz8J5oHfYgazXPpxScJ6dtduG0pVTBSap
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

0ac79a5 xfsprogs: Release v5.0.0-rc1

New Commits:

Darrick J. Wong (31):
      [1da4e1f] xfs_repair: reinitialize the root directory nlink correct=
ly
      [fe4bd71] xfs_repair: bump the irec on-disk nlink when adding lost+=
found
      [83695f9] xfs_repair: fix uninitialized variable warnings
      [b470990] xfs_repair: refactor buffer ops assignments during phase =
5
      [bc5fb7c] xfs_repair: pass ops through during scan
      [b06ebac] libfrog: hoist bitmap out of scrub
      [513f189] libxfs: refactor the open-coded libxfs_trans_bjoin calls
      [e2dd0e1] libxfs: remove libxfs_trans_iget
      [8872c2a] xfs_scrub: include unicrash.h in unicrash.c
      [ae2883e] xfs_io: don't read garbage stack contents if INUMBERS goe=
s nuts
      [1bce8fe] xfs_io: fix label parsing and validation
      [1f8480b] xfs_repair: better cli option parameter checking
      [9e43c34] xfs_db: refactor metadump handling of multi-fsb objects
      [001df39] xfs_db: refactor multi-fsb object detection decision maki=
ng
      [0e81250] xfs_db: metadump should handle symlinks properly
      [593f2ab] xfs_scrub: remove xfs_ prefixes from structure names
      [557f98d] xfs_scrub: rename confusing structure
      [ed5f9cc] xfs_scrub: remove pointless xfs_verify_error_info struct
      [00d139f] mkfs: don't use DIFLAG values for fsx_xflags
      [888b2a7] xfs_scrub: remove redundant function declarations
      [02d21c4] scrub: fix Makefile targets which depend on builddefs
      [bbb4374] xfs_info: use findmnt to handle mounted block devices
      [1cdc777] xfs_repair: correctly account for free space btree shrink=
s when fixing freelist
      [e0187d7] libxfs: retain ifork_ops when flushing inode
      [3d16890] libxfs: drop the ifork_ops parameter from libxfs_inode_ve=
rify_forks
      [7f0d0b5] misc: fix strncpy length complaints
      [8cc858f] libxfs: refactor buffer item release code
      [bb58193] libxfs: don't touch buffer log item pointer when flushing=
 inode log item
      [7736b0a] libxfs: fix buffer log item lifetime weirdness
      [b1a24a8] libxfs: shorten inode item lifetime
      [b0956ce] libfrog: fix memory leak in bitmap_free

Eric Sandeen (3):
      [5dd33a5] xfsprogs: remove unused function prototypes
      [7a326ce] libxfs: refactor manage_zones()
      [0ac79a5] xfsprogs: Release v5.0.0-rc1


Code Diffstat:

 VERSION                |  6 +--
 configure.ac           |  2 +-
 debian/changelog       | 10 ++++-
 debian/control         |  2 +-
 doc/CHANGES            | 25 ++++++++++++-
 include/xfs_inode.h    |  4 +-
 libfrog/bitmap.c       |  1 +
 libxfs/init.c          | 95 +++++++++++++++++++++++---------------------=
----
 libxfs/rdwr.c          | 16 ++++----
 libxfs/trans.c         | 44 ++++++++++++++++------
 libxfs/util.c          |  3 +-
 libxfs/xfs_dir2_priv.h |  4 ++
 mkfs/xfs_mkfs.c        | 13 ++++++-
 quota/edit.c           |  9 +++--
 repair/rmap.c          | 54 ++++++++++++++++++++++-----
 scrub/Makefile         | 11 +++---
 spaceman/xfs_info.sh   | 22 +++++++++--
 17 files changed, 216 insertions(+), 105 deletions(-)


--uz8J5oHfYgazXPpxScJ6dtduG0pVTBSap--

--K0IRY60EMdtlpsCoUu8ONKgge9tapULIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzDgV0ACgkQIK4WkuE9
3uCK1xAArj3d5UcZBBiUC1C+ugzNyjQ7Q5mo39Uopx2N/HI/9wfSvRbM+Bo/KxF8
psiG8C+j9DMA/bb57/zB8GSaQVS8KdH+wr+F8m0qPIxq+IAnn8ZTEY+RHvSnbjXh
S2SnzSTSss6iTyEVV39NkvH3SimAWXfJzpOAf9iINgWvK3EWXJjaKViHEHe4KbVV
noAnx29DhEC9KtKVzizeLvmpHHoF83gE5tk0xs3161DZhSCk+mqnuEu7pAcQM1Fv
intR9xO0vbWXAm2eDlUFEvq8cuChD8Cn+8kWq58Oj4oXNaMm1UG4SZUZLVC8+MvE
BpshlgaW6mEELGrIoVJNx0K/WuavOSigBVvhQgEtSThVTUnj+GvLbYLyzSNkBa6Z
GQoHHlz4pA+u2dxebLdvkYmKelEiwLxHZBRgIVgOQ+hZAGSxJuJSa8FjcX07isDL
emhquTKmWDa+ScJxSG2610h3XpofxAXqPwbzoYo3Mw7qaappzV3ywUAB4NzGwGg3
iPUmkAWN077e2Y3lTgaX7EHeAJTDX3iJMS0HF/ikCifpYvEXRPXUE5dJ5TikJnpY
Yj1RgfcPgsZAQ9Zdfe5H+AE7t7N+p21sJSnl222J08W4UWigtbXAqINEv8g+KzoL
FyhmwkdiEGyMDm2pG27QSwbMh/7mVx7hvIl9bqdaBOlZiZA54Q0=
=8lc4
-----END PGP SIGNATURE-----

--K0IRY60EMdtlpsCoUu8ONKgge9tapULIg--
