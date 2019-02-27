Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47700 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727488AbfB0VjU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Feb 2019 16:39:20 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F1BA9326C
        for <linux-xfs@vger.kernel.org>; Wed, 27 Feb 2019 15:38:53 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 6f490d6
Message-ID: <e1bd5016-cef2-c61b-7540-cf75d960c16d@sandeen.net>
Date: Wed, 27 Feb 2019 15:39:18 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zVIXI0CLXQcJddIEZUgwXwlnyavnhqlkY"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zVIXI0CLXQcJddIEZUgwXwlnyavnhqlkY
Content-Type: multipart/mixed; boundary="9tPldOOFcvwrqKVSZwzQYXHnovjLgNRGz";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e1bd5016-cef2-c61b-7540-cf75d960c16d@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 6f490d6

--9tPldOOFcvwrqKVSZwzQYXHnovjLgNRGz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This contains only the sync to the kernel's libxfs updates for v5.0.

The new head of the for-next branch is commit:

6f490d6 xfs: stringify btree cursor types in ftrace output

New Commits:

Darrick J. Wong (11):
      [5afb131] xfs: idiotproof defer op type configuration
      [5a23b29] xfs: streamline defer op type handling
      [c2d5dd0] xfs: const-ify xfs_owner_info arguments
      [9ef0cb4] xfs: remove xfs_rmap_ag_owner and friends
      [09c23f4] xfs: add a block to inode count converter
      [c43dd96] xfs: precalculate inodes and blocks per inode cluster
      [af22104] xfs: precalculate cluster alignment in inodes and blocks
      [5ff3ed4] xfs: fix symbolic enum printing in ftrace output
      [57a6c0e] xfs: move XFS_AG_BTREE_CMP_FORMAT_STR mappings to libxfs
      [51e1848] xfs: move XFS_INODE_FORMAT_STR mappings to libxfs
      [6f490d6] xfs: stringify btree cursor types in ftrace output

Dave Chinner (1):
      [7ab21d5] xfs: zero length symlinks are not valid

Omar Sandoval (1):
      [5dc4588] xfs: cache minimum realtime summary level

Pan Bian (1):
      [972ca59] xfs: libxfs: move xfs_perag_put late


Code Diffstat:

 db/check.c                  |   8 +-
 db/convert.c                |   4 +-
 db/frag.c                   |   4 +-
 db/io.c                     |   2 +-
 db/metadump.c               |   4 +-
 include/xfs_mount.h         |  11 ++
 include/xfs_trans.h         |   5 -
 libxfs/defer_item.c         |  44 +-------
 libxfs/init.c               |  16 +--
 libxfs/libxfs_api_defs.h    |   1 -
 libxfs/xfs_ag.c             |   9 +-
 libxfs/xfs_alloc.c          |  79 +++++++--------
 libxfs/xfs_alloc.h          |   4 +-
 libxfs/xfs_bmap.c           |   6 +-
 libxfs/xfs_bmap.h           |   4 +-
 libxfs/xfs_defer.c          |  67 +++++++------
 libxfs/xfs_defer.h          |  37 +++----
 libxfs/xfs_format.h         |  12 +++
 libxfs/xfs_ialloc.c         |  56 +++++------
 libxfs/xfs_ialloc_btree.c   |   7 +-
 libxfs/xfs_refcount_btree.c |   6 +-
 libxfs/xfs_rmap.c           | 240 +++++++++++++++++++++++++-------------=
------
 libxfs/xfs_rmap.h           |  54 ++++------
 libxfs/xfs_rtbitmap.c       |   6 ++
 libxfs/xfs_symlink_remote.c |  14 ++-
 libxfs/xfs_types.c          |   9 +-
 libxfs/xfs_types.h          |  22 ++++
 repair/dino_chunks.c        |  12 +--
 repair/phase5.c             |   4 +-
 repair/rmap.c               |   5 +-
 repair/xfs_repair.c         |  13 ++-
 31 files changed, 393 insertions(+), 372 deletions(-)


--9tPldOOFcvwrqKVSZwzQYXHnovjLgNRGz--

--zVIXI0CLXQcJddIEZUgwXwlnyavnhqlkY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlx3A4cACgkQIK4WkuE9
3uD88Q/9HBPAZhZugsDDDQKe0+wUrl+F6ah3qECCl+HW2BGJM7LYzUFcxomOcvsW
H9n4Ou47vIBczkrDC7hx61QL2/wWtC+bwvScXuxQ9xcgYyO2OppQpFqoIDVkweAA
4hPbNi8mHcX2/fJomMH+YR5vssks8qP8dx367JXSiv0l1PIhbouzSFmxsbREnQW9
jx1WT8E9hzQOueu+oVzvzfYCuqEIGuSXOOeVKa3RwLKSRAYcDe/knTxixySC1072
dowrDwAzKk063MDs4lWFeHN2u0WPM7ZNBUjqjMEoCwaVgMcuH1dSpRi5Egxjq2aR
e5OZbliLbrkyk7GOlefGpoxGoT4D4of2y5F+OzzmKu8tsDFhP61UFFadVNVmuw6d
VmCckPBALTJkg8yeTMcf3tWVQFo20QtExippsTeNDfUtlodvSmBXlg/F/msjf6OR
alxKa7TaVeeJ39xuT51/GiBMBstXq2opDAPRmfygIoDrfcjFIViAw2CjAEWIGkaD
g3Cl3hmxfrdPaBVqIW7gp7zss3Z0tLzXbyKSLeVpE3K2roHkT87xzCg8rkEDHFl3
nf7ptfas3tk7vNewXJ8tHGalYL2buiS7lDyZ60gsQPj3NgRl2O98djBLIWHuA26+
XuNQc6Y2Y62NcrXl3dN/S18EirvhXVGtRESbORUtTpcjLVypp5w=
=uT50
-----END PGP SIGNATURE-----

--zVIXI0CLXQcJddIEZUgwXwlnyavnhqlkY--
