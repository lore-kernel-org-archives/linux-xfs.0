Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFD5F7CA3
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 21:04:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56F0AAC002
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 19:03:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GdBwwgcuSsOy3y8b for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2016 19:03:51 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1bFXV5-0001tY-QM
	for xfs@oss.sgi.com; Wed, 22 Jun 2016 12:02:43 +1000
Date: Wed, 22 Jun 2016 12:02:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to v4.7.0-rc1
Message-ID: <20160622020243.GT12670@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6196950543361391877=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6196950543361391877==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GxcwvYAGnODwn7V8"
Content-Disposition: inline


--GxcwvYAGnODwn7V8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged as v4.7.0-rc1. This is the first
candidate release of v4.7.0 with the libxfs codebase up to date with
the kernel 4.7-rc4 code base. Please test and report any problems
you find.

-Dave.

The new head of the master branch is commit:

fb2595e xfsprogs: Release v4.7-rc1

New Commits:

Alex Lyakas (1):
      [4d9e732] xfs: optimise xfs_iext_destroy

Bill O'Donnell (3):
      [82c3a17] libxcmd: generalize topology functions
      [1b1b535] xfs_repair: new secondary superblock search method
      [ef12e07] xfs_repair: further improvement on secondary superblock sea=
rch method

Brian Foster (5):
      [09c93e5] xfs_db: Revert "xfs_db: make check work for sparse inodes"
      [ea8a48f] xfs_check: process sparse inode chunks correctly
      [8359e0b] xfs: update freeblocks counter after extent deletion
      [01d1b78] xfs: refactor delalloc indlen reservation split into helper
      [731ccdf] xfs: borrow indirect blocks from freed extent when available

Christoph Hellwig (9):
      [721948f] xfs.h: define XFS_IOC_FREEZE even if FIFREEZE is defined
      [2be9e93] linux.h: include <linux/fs.h>
      [0268fdc] xfs: remove xfs_trans_get_block_res
      [d2fd405] xfs: always set rvalp in xfs_dir2_node_trim_free
      [219eec7] xfs: factor out a helper to initialize a local format inode=
 fork
      [4cab415] xfs: optimize inline symlinks
      [9074815] xfs: better xfs_trans_alloc interface
      [8e95425] xfs: remove transaction types
      [408c66d] xfs: improve kmem_realloc

Darrick J. Wong (1):
      [d9b2595] xfs: fix computation of inode btree maxlevels

Dave Chinner (3):
      [86769b3] xfs_db: allow recalculating CRCs on invalid metadata
      [0ebbf1d] db: limit AGFL bno array printing
      [fb2595e] xfsprogs: Release v4.7-rc1

Eric Sandeen (5):
      [027e6ef] xfs_db: defang frag command
      [a8b6f52] xfs_quota: check report_mount return value
      [ce211a6] mkfs.xfs: annotate fallthrough cases in cvtnum
      [f61be1b] xfs_quota: only round up timer reporting > 1 day
      [643f6ac] xfs_repair: set rsumino version to 2

Jan Tulak (4):
      [2942ff4] mkfs: fix -l su minval
      [0b514e3] mkfs: update manpage for -i size
      [ef92dd5] mkfs: better error with incorrect b/s value suffix usage
      [587636b] mkfs: test that -l su is a multiple of block size

Kirill A. Shutemov (1):
      [b2327e1] mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release=
} macros

Luis de Bethencourt (1):
      [4d4a192] xfs: remove impossible condition


Code Diffstat:

 Makefile                  |   3 +-
 VERSION                   |   4 +-
 configure.ac              |   2 +-
 db/check.c                | 274 ++++++++++++-----------------------
 db/fprint.c               |   2 +-
 db/frag.c                 |   4 +
 db/io.c                   |   7 +
 db/io.h                   |   1 +
 db/print.c                |   7 +-
 db/type.c                 | 137 ++++++++++--------
 db/type.h                 |   2 +
 db/write.c                |  59 ++++++--
 debian/rules              |   2 +-
 doc/CHANGES               |  20 +++
 include/Makefile          |   1 +
 include/kmem.h            |   2 +-
 include/libxcmd.h         |  56 ++++++++
 include/linux.h           |   1 +
 include/xfs_trans.h       |   7 +-
 libxcmd/Makefile          |   2 +-
 libxcmd/topology.c        | 342 ++++++++++++++++++++++++++++++++++++++++++=
++
 libxfs/kmem.c             |   2 +-
 libxfs/libxfs_api_defs.h  |   1 -
 libxfs/libxfs_priv.h      |   3 +-
 libxfs/trans.c            |  53 +++----
 libxfs/util.c             |   5 +-
 libxfs/xfs_attr.c         |  58 ++------
 libxfs/xfs_bmap.c         | 192 ++++++++++++++++---------
 libxfs/xfs_bmap_btree.c   |   4 +-
 libxfs/xfs_dir2_node.c    |   4 +-
 libxfs/xfs_dir2_sf.c      |   9 +-
 libxfs/xfs_fs.h           |   8 +-
 libxfs/xfs_ialloc.c       |   4 +-
 libxfs/xfs_inode_fork.c   | 101 ++++++++-----
 libxfs/xfs_inode_fork.h   |   1 +
 libxfs/xfs_log_format.h   |   5 +
 libxfs/xfs_sb.c           |   8 +-
 libxfs/xfs_shared.h       | 102 +------------
 libxlog/xfs_log_recover.c |   2 +-
 man/man8/mkfs.xfs.8       |   2 +-
 mkfs/Makefile             |   4 +-
 mkfs/proto.c              |  51 ++++---
 mkfs/xfs_mkfs.c           | 380 ++++++------------------------------------=
-------
 quota/report.c            |   6 +-
 quota/util.c              |  12 ++
 repair/Makefile           |   5 +-
 repair/phase5.c           |   8 +-
 repair/phase6.c           |  85 ++++-------
 repair/phase7.c           |   4 +-
 repair/sb.c               | 122 ++++++++++++----
 50 files changed, 1142 insertions(+), 1034 deletions(-)
 create mode 100644 include/libxcmd.h
 create mode 100644 libxcmd/topology.c
--=20
Dave Chinner
david@fromorbit.com

--GxcwvYAGnODwn7V8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXafHDAAoJEK3oKUf0dfodgkgP/013xoU4rehexw/ENszeDqaH
ap+YG4mHURFxCzQNixGWYCweKSu7RKQEXGDqpj6WxPrCuPCPIOsxTENKhZNkJA1j
RsYl24Lyrv4A46xM/s5l44gGWEeSsX1HJvOSMo2x8GOZ0bMvg5KOoGeAJMoINCdl
Kcj86mpyutXGuvSnOqh3GoXSriREcy+YO5IqVgfmF78RhJ67WEPE+rvEm5J50/rh
MI91USGVw0/Wi680Rqzt5HdH2ZpI8/9Nh6esVUs0eHrWlLwQk2w7XX81ppnVQat6
ehhz2NTKMYZJ1Yron97pgYIE68r0emSZYjwAygxZB9dfdYzzJNQr92ODXfc2DCIs
FvorIosazf0p0aO7F/8KYTnEAa7acrxgHeboKgBhQ2J5iGtmbmJ3/P+R7Wfiny6Y
R+AOVls2Kntq2ABcpzpu1cKZgmP9Pfl8vYu8uzZ5AgZg6fo84ighEUI+EZKCN8wl
MP+zdtFwNLPMdbFBtOkkAWYgjq/WQsT74+99d7C1cDsFpq/i1Ra8VGiRvYGIeDiz
vGhgH9tXWt3PndSFVn8Ds0baNhEaeNL46Us3bnYGFEqutgXLxAVFO2buO+m9zhok
iRQrtgKyJG2aHuqPlaoDHMtMbWtEzcNwZcjwou/eFeH9BexSyERpB6GGNAQ+tnfp
G9MjuvGvr0lRGKJEB1Tb
=JS/4
-----END PGP SIGNATURE-----

--GxcwvYAGnODwn7V8--


--===============6196950543361391877==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6196950543361391877==--
