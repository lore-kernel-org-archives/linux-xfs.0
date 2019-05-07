Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36526 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfEGW2V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 May 2019 18:28:21 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0DCBC1164B
        for <linux-xfs@vger.kernel.org>; Tue,  7 May 2019 17:28:12 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 93ad4d9
Message-ID: <c9de816b-14c7-688d-bfa8-f4efc972b30c@sandeen.net>
Date: Tue, 7 May 2019 17:28:18 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZAWb2rsuCbC0jeiFpPCn0UZN2N1ppUhik"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZAWb2rsuCbC0jeiFpPCn0UZN2N1ppUhik
Content-Type: multipart/mixed; boundary="hfPT0ZKQnZdCW0HmEnd17R5Q5KpzFHATZ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <c9de816b-14c7-688d-bfa8-f4efc972b30c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 93ad4d9

--hfPT0ZKQnZdCW0HmEnd17R5Q5KpzFHATZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This includes only the libxfs kernelspace sync up at this point,
and associated non-libxfs adjustments.

The new head of the for-next branch is commit:

93ad4d9 xfs: always init bma in xfs_bmapi_write

New Commits:

Brian Foster (13):
      [a2fa97f] xfs: update fork seq counter on data fork changes
      [98da7e1] xfs: remove superfluous writeback mapping eof trimming
      [badaa59] xfs: create delalloc bmapi wrapper for full extent alloca=
tion
      [bbbbfd0] xfs: use the latest extent at writeback delalloc conversi=
on time
      [7563fc9] xfs: always check magic values in on-disk byte order
      [035ae96] xfs: create a separate finobt verifier
      [c08793b] xfs: distinguish between inobt and finobt magic values
      [fce74e9] xfs: split up allocation btree verifier
      [1d8220b] xfs: distinguish between bnobt and cntbt magic values
      [26b7b8f] xfs: use verifier magic field in dir2 leaf verifiers
      [68dbe77] xfs: miscellaneous verifier magic value fixups
      [6b27f70] xfs: factor xfs_da3_blkinfo verification into common help=
er
      [82ed51d] xfs: don't trip over uninitialized buffer on extent read =
of corrupted inode

Christoph Hellwig (6):
      [939ebc1] xfs: simplify the xfs_bmap_btree_to_extents calling conve=
ntions
      [ee62279] xfs: factor out two helpers from xfs_bmapi_write
      [330a35f] xfs: split XFS_BMAPI_DELALLOC handling from xfs_bmapi_wri=
te
      [c784c9d] xfs: move transaction handling to xfs_bmapi_convert_delal=
loc
      [44e165d] xfs: move stat accounting to xfs_bmapi_convert_delalloc
      [9fa4db1] xfs: make COW fork unwritten extent conversions more robu=
st

Darrick J. Wong (14):
      [95a8c91] xfs: scrub should flag dir/attr offsets that aren't mappa=
ble with xfs_dablk_t
      [d2b2d41] xfs: check directory name validity
      [0692657] xfs: check attribute name validity
      [7a425ea] xfs: add xfs_verify_agino_or_null helper
      [d9fa440] xfs: cache unlinked pointers in an rhashtable
      [62031c2] xfs: add inode magic to inode verifier
      [7a97b8e] xfs: add magic numbers to dquot buffer ops
      [4c7161c] xfs: rename m_inotbt_nores to m_finobt_nores
      [9e26de8] xfs: fix xfs_buf magic number endian checks
      [ed76255] xfs: fix uninitialized error variables
      [d8ddf13] xfs: clean up xfs_dir2_leafn_add
      [732a9d4] xfs: zero initialize highstale and lowstale in xfs_dir2_l=
eaf_addname
      [c01c6d6] xfs: clean up xfs_dir2_leaf_addname
      [93ad4d9] xfs: always init bma in xfs_bmapi_write

Nathan Chancellor (1):
      [e02a7d4] xfs: Zero initialize highstale and lowstale in xfs_dir2_l=
eafn_add


Code Diffstat:

 db/type.c                   |  12 +-
 include/xfs_mount.h         |   2 +-
 io/inject.c                 |   1 +
 libxfs/libxfs_io.h          |   7 +
 libxfs/libxfs_priv.h        |   3 +-
 libxfs/rdwr.c               |  37 ++++++
 libxfs/xfs_ag.c             |   6 +-
 libxfs/xfs_ag_resv.c        |   2 +-
 libxfs/xfs_alloc.c          |  12 +-
 libxfs/xfs_alloc_btree.c    |  74 +++++------
 libxfs/xfs_attr.c           |  17 +++
 libxfs/xfs_attr.h           |   2 +-
 libxfs/xfs_attr_leaf.c      |  21 +--
 libxfs/xfs_attr_remote.c    |   8 +-
 libxfs/xfs_bmap.c           | 317 ++++++++++++++++++++++++++------------=
------
 libxfs/xfs_bmap.h           |  16 +--
 libxfs/xfs_bmap_btree.c     |  13 +-
 libxfs/xfs_da_btree.c       |  49 ++++---
 libxfs/xfs_da_format.h      |   3 +
 libxfs/xfs_dir2.c           |  17 +++
 libxfs/xfs_dir2.h           |   1 +
 libxfs/xfs_dir2_block.c     |  10 +-
 libxfs/xfs_dir2_data.c      |  12 +-
 libxfs/xfs_dir2_leaf.c      | 137 ++++++-------------
 libxfs/xfs_dir2_node.c      |  28 ++--
 libxfs/xfs_dquot_buf.c      |   4 +
 libxfs/xfs_errortag.h       |   4 +-
 libxfs/xfs_ialloc.c         |   3 +-
 libxfs/xfs_ialloc_btree.c   |  29 ++--
 libxfs/xfs_iext_tree.c      |  13 +-
 libxfs/xfs_inode_buf.c      |  11 +-
 libxfs/xfs_inode_fork.h     |   2 +-
 libxfs/xfs_refcount_btree.c |   3 +-
 libxfs/xfs_rmap_btree.c     |   3 +-
 libxfs/xfs_sb.c             |   7 +-
 libxfs/xfs_shared.h         |   4 +-
 libxfs/xfs_symlink_remote.c |   3 +-
 libxfs/xfs_types.c          |  24 ++++
 libxfs/xfs_types.h          |   3 +
 mkfs/xfs_mkfs.c             |   6 +-
 repair/phase5.c             |   6 +-
 repair/scan.c               |   6 +-
 42 files changed, 542 insertions(+), 396 deletions(-)


--hfPT0ZKQnZdCW0HmEnd17R5Q5KpzFHATZ--

--ZAWb2rsuCbC0jeiFpPCn0UZN2N1ppUhik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzSBoMACgkQIK4WkuE9
3uBa8Q//U1GQmM7StR1ccIksueHVbP5yiL1is/FTjxrN7Ppn2v9yJMvLdu8iB8ig
7XhCkIlbqWEU6Hi4CPNdH9vhzIBGWe1omTMdgBGYsYp5R8NaBqsBTWn0Yq+YuD9J
ytnRGr0kMRwY1sUuEJ+aG595MN2jN6biSc9VxOgb9MYjQajXrSmWD54uNMGvyKzC
YcW86JE3kGoqS6sAq2mx1l7a8X/yMYVTK3QlMloNnpkWA8ygSyKbo2sSg5UB1Gsw
v98mFMRrrNgdo8KqclDYuV/FPKMccYchiSL4dPXxCu01IV6VjRRxWkSsmO/MiaNj
R9WUTqHM6tCUzp2mAOrwf09fBD8IQll11gJhrQa/950iY8GBHycpPFWc8HTeKQjC
AMJyYk4FeRXzDGkkqBZC55z/1jvKQR87JI8EL69oiaQWm12Yn6gO9iMSsMH2hnYd
h8j/SdBmKkGhlQN2UciCL6zzisrfsAIgQVHKchhnKGWtWLWGU1zarQRqMr4TxvUf
qz/zlLYrH35JOQQ1bwSSyeAD2L6S8RTE/57FKI6Yt6FBI91PxSUNS/1jsIHUcIDJ
uMMOxB8KKWPs8i9M5fbhpZKD2Fl7/lcXa5C0+NvuPTCuk5baIG916VTYu9rCTfdG
JqBq4Y9GXNSIEWfxTg7UauCYWNdT/kNLkKM9JDLAg2A1HcGaciE=
=PFwY
-----END PGP SIGNATURE-----

--ZAWb2rsuCbC0jeiFpPCn0UZN2N1ppUhik--
