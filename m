Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E484F7CAF
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 00:09:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57458AC005
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2016 22:09:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FkUppCwPKeatWwBx for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2016 22:08:58 -0700 (PDT)
Date: Mon, 19 Sep 2016 15:08:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 4d50b3b
Message-ID: <20160919050855.GB340@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5433750519381083959=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@vger.kernel.org
Cc: ross.zwisler@linux.intel.com, hch@lst.de, xfs@oss.sgi.com


--===============5433750519381083959==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This includes various fixes and cleanups, a
bunch of iomap and XFS prep work for reflink, a delayed allocation
rework optimised for the new iomap infrastructure, and a DAX
implementation for the iomap infrastructure. Both XFS and ext2 are
switched over to the new DAX iomap infrastructure.

Christoph and Ross - if there's anything in that I shouldn't have
merged, then let me know. There are no apparent xfstests regressions
that I've seen, so it all looks good from my perspective....

-Dave.

The new head of the for-next branch is commit:

4d50b3b Merge branch 'iomap-4.9-dax' into for-next

New Commits:

Artem Savkov (1):
      [791cc43] Make __xfs_xattr_put_listen preperly report errors.

Carlos Maiolino (1):
      [5694fe9] xfs: Document error handlers behavior

Christoph Hellwig (17):
      [5f4e575] fs: add iomap_file_dirty
      [e9c4973] xfs: move xfs_bmbt_to_iomap up
      [f8e3a82] xfs: factor our a helper to calculate the EOF alignment
      [85a6e76] xfs: make xfs_inode_set_eofblocks_tag cheaper for the commo=
n case
      [51446f5] xfs: rewrite and optimize the delalloc write path
      [ecd5072] iomap: add IOMAP_F_NEW flag
      [befb503] iomap: expose iomap_apply outside iomap.c
      [1aaba09] dax: don't pass buffer_head to dax_insert_mapping
      [b0d5e82] dax: don't pass buffer_head to copy_user_dax
      [a254e56] dax: provide an iomap based dax read/write path
      [a7d73fe] dax: provide an iomap based fault handler
      [17879e8] xfs: fix locking for DAX writes
      [66642c5] xfs: take the ilock shared if possible in xfs_file_iomap_be=
gin
      [e372843] xfs: refactor xfs_setfilesize
      [6c31f49] xfs: use iomap to implement DAX
      [6750ad7] ext2: stop passing buffer_head to ext2_get_blocks
      [25f4e70] ext2: use iomap to implement DAX

Darrick J. Wong (7):
      [e43c460] iomap: add a flag to report shared extents
      [cd00158] xfs: convert RUI log formats to use variable length arrays
      [a1d46cf] xfs: remove xfs_btree_bigkey
      [4ed3f68] xfs: create a standard btree size calculator code
      [c611cc0] xfs: count the blocks in a btree
      [385d655] xfs: defer should allow ->finish_item to request a new tran=
saction
      [3fd129b] xfs: set up per-AG free space reservations

Dave Chinner (5):
      [541d48f] xfs: change mailing list address
      [eb759e37] Merge branch 'iomap-4.9-misc-fixes-1' into for-next
      [e64d79a3] Merge branch 'xfs-4.9-reflink-prep' into for-next
      [30ecf4f] Merge branch 'xfs-4.9-delalloc-rework' into for-next
      [4d50b3b] Merge branch 'iomap-4.9-dax' into for-next

Eric Sandeen (1):
      [7716981] xfs: normalize "infinite" retries in error configs

Eryu Guan (1):
      [a27f6ef] xfs: undo block reservation correctly in xfs_trans_reserve()

Xie XiuQi (1):
      [79c350e] xfs: fix signed integer overflow


Code Diffstat:

 Documentation/filesystems/xfs.txt | 123 ++++++++++
 MAINTAINERS                       |   7 +-
 fs/dax.c                          | 252 ++++++++++++++++++++-
 fs/ext2/Kconfig                   |   1 +
 fs/ext2/ext2.h                    |   1 +
 fs/ext2/file.c                    |  76 ++++++-
 fs/ext2/inode.c                   | 100 +++++++--
 fs/internal.h                     |  11 +
 fs/iomap.c                        |  89 +++++++-
 fs/xfs/Makefile                   |   1 +
 fs/xfs/libxfs/xfs_ag_resv.c       | 325 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag_resv.h       |  35 +++
 fs/xfs/libxfs/xfs_alloc.c         | 112 +++++++---
 fs/xfs/libxfs/xfs_alloc.h         |   8 +-
 fs/xfs/libxfs/xfs_bmap.c          |  95 +-------
 fs/xfs/libxfs/xfs_bmap.h          |  10 +-
 fs/xfs/libxfs/xfs_btree.c         |  59 ++++-
 fs/xfs/libxfs/xfs_btree.h         |  28 +--
 fs/xfs/libxfs/xfs_defer.c         |  79 ++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.c  |   2 +-
 fs/xfs/libxfs/xfs_log_format.h    |  10 +-
 fs/xfs/xfs_aops.c                 |  31 ++-
 fs/xfs/xfs_aops.h                 |   1 +
 fs/xfs/xfs_buf_item.c             |   9 +-
 fs/xfs/xfs_file.c                 |  79 ++-----
 fs/xfs/xfs_filestream.c           |   4 +-
 fs/xfs/xfs_fsops.c                |   2 +-
 fs/xfs/xfs_icache.c               |  14 ++
 fs/xfs/xfs_inode.h                |   1 +
 fs/xfs/xfs_iomap.c                | 494 +++++++++++++++++++---------------=
-------
 fs/xfs/xfs_iomap.h                |   2 -
 fs/xfs/xfs_mount.h                |  44 +++-
 fs/xfs/xfs_rmap_item.c            |  36 +--
 fs/xfs/xfs_rmap_item.h            |   8 +
 fs/xfs/xfs_super.c                |   5 +-
 fs/xfs/xfs_sysfs.c                |  47 +++-
 fs/xfs/xfs_trace.h                |  75 ++++++-
 fs/xfs/xfs_trans.c                |   3 +-
 fs/xfs/xfs_trans_extfree.c        |   3 +-
 fs/xfs/xfs_xattr.c                |   1 +
 include/linux/dax.h               |   6 +
 include/linux/iomap.h             |   4 +
 42 files changed, 1685 insertions(+), 608 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_ag_resv.c
 create mode 100644 fs/xfs/libxfs/xfs_ag_resv.h
--=20
Dave Chinner
david@fromorbit.com

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX33LmAAoJEK3oKUf0dfodBsQP/2vAsNOOzU6zxhuVC/vb/6XN
d9v6oUKL4A3j/LP3jeHjuJLsKBrYmPecva4E/MNEhx9sQBO3MwjTRThtIRwScPka
aikmEEP9WZOZAOq+cbHKFo7VuqF4Ra9lJHZfu7GqGItE5pNEsjg4sj2UvW/aCHbR
od78Smb33QUMcxgqx4WSuG0g/WuNTRBJBOb4LfrtZkl9cg3+hYefQFiZzBObmzKY
nQ2xRjHc4fzInrm7xEKYrYLqpSNK87+TUvYMtcETLH3FMRJYLiHQWZ3M6yPknI3U
ji2CtO6qLlVdK0zeFfdWszP/kN02nqHLxyyLIZ4YMKUoO4kRRY0s8SOhr8Qk/A43
vYdq8H3cb2tziUxWeadvOT6RI6SWpxKp3rHsEyLi54WfqW/QTRSD6JhjnYadrEdT
GMFEBvSzbOEA2OI9CGyoZGXByJSUmx2LPRIzS2DOMv7MR76SRyL6AB0l5p6g3Tc7
Qtj91iLY08/V9hekgS49dLM+vm2Y9j7+tdrSpKzyV0sdayqa/FzKf8oC86R7P3wA
9ls+Nk+YFHdSRfjaWMXQNxQUtf29TyGGRLWal/SiJLl4izSII9/Jjc03YOwP9IUH
ufCdIRboze8TvYESGy37OaASmzF4kWhbeA01Yw6zD0E6prgVXJNNOKUyidZatdD0
VSFvzF8h0B15rI0DwCi1
=q4Et
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--


--===============5433750519381083959==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5433750519381083959==--
