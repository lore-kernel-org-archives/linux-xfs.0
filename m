Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4EC257CA3
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2016 06:02:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2DC638F8052
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2016 04:02:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8HetdNp6cH06zWUK for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2016 04:02:23 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1bXRHB-0006xJ-3Y
	for xfs@oss.sgi.com; Wed, 10 Aug 2016 21:02:21 +1000
Date: Wed, 10 Aug 2016 21:02:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to 9694212
Message-ID: <20160810110221.GL19025@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0706486093979608995=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0706486093979608995==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The for-next branch of the xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated. This is an update with the initial libxfs
sync from the 4.8-rc1 kernel code. It contains all the libxfs
support for reverse mapping but none of the tool support, so it is
not active yet. I'm pushing this out quickly so that Darrick can
rebase the tool support patchset on top of it, and we can get that
reviewed and merged ASAP so we can enable wider testing of the new
rmap feature.

-Dave.

The new head of the master branch is commit:

9694212 xfs: move (and rename) the deferred bmap-free tracepoints

New Commits:

Christoph Hellwig (3):
      [1faa1a8] xfs: kill xfs_dir2_sf_off_t
      [d8bf9c6] xfs: kill xfs_dir2_inou_t
      [34f7aca] xfs: remove __arch_pack

Darrick J. Wong (45):
      [0b90dda] libxfs: add more list operations
      [2cf6d22] xfs: convert list of extents to free into a regular list
      [730e2a1] xfs: refactor btree maxlevels computation
      [6c668fd] xfs: fix attr shortform structure alignment on cris
      [a62ed6d] xfs: fix locking of the rt bitmap/summary inodes
      [cff8bf9] xfs: set *stat=3D1 after iroot realloc
      [d3cd7a2] xfs: during btree split, save new block key & ptr for futur=
e insertion
      [a3c9cb1] xfs: add function pointers for get/update keys to the btree
      [13e831e] xfs: support btrees with overlapping intervals for keys
      [5d3b7fe] xfs: introduce interval queries on btrees
      [f31736b] xfs: refactor btree owner change into a separate visit-bloc=
ks function
      [a18e1f7] xfs: move deferred operations into a separate file
      [30ad7d6] xfs: add tracepoints for the deferred ops mechanism
      [31a6b02] xfs: enable the xfs_defer mechanism to process extents to f=
ree
      [f944d3d] xfs: rework xfs_bmap_free callers to use xfs_defer_ops
      [6f530e9] xfs: change xfs_bmap_{finish,cancel,init,free} -> xfs_defer=
_*
      [f33cea1] xfs: rename flist/free_list to dfops
      [a9da40d] xfs: add tracepoints and error injection for deferred exten=
t freeing
      [513ec1c] xfs: increase XFS_BTREE_MAXLEVELS to fit the rmapbt
      [e37838e] xfs: introduce rmap btree definitions
      [d2aaeae] xfs: add rmap btree stats infrastructure
      [ef5340c] xfs: rmap btree add more reserved blocks
      [85aec44] xfs: add owner field to extent allocation and freeing
      [631ac87] xfs: introduce rmap extent operation stubs
      [b3a96b4] xfs: define the on-disk rmap btree format
      [e4ce00b] xfs: rmap btree transaction reservations
      [b8a8d6e] xfs: rmap btree requires more reserved free space
      [936ca68] xfs: add rmap btree operations
      [634b234] xfs: support overlapping intervals in the rmap btree
      [890e117] xfs: teach rmapbt to support interval queries
      [631bda2] xfs: add an extent to the rmap btree
      [ae81ebf] xfs: remove an extent from the rmap btree
      [7faf209] xfs: convert unwritten status of reverse mappings
      [b26675c] xfs: add rmap btree insert and delete helpers
      [e2d7f10] xfs: create rmap update intent log items
      [589b52d] xfs: enable the xfs_defer mechanism to process rmaps to upd=
ate
      [d7f8032] xfs: propagate bmap updates to rmapbt
      [966d818] xfs: add rmap btree geometry feature flag
      [e365af6] xfs: don't update rmapbt when fixing agfl
      [2fc5f0e] xfs: enable the rmap btree functionality
      [64dbe04] xfs: remove the get*keys and update_keys btree ops pointers
      [ae01cb8] xfs: remove unnecesary lshift/rshift key initialization
      [e635802] xfs: in btree_lshift, only allocate temporary cursor when n=
eeded
      [f1ade4e] xfs: remove the extents array from the rmap update done log=
 item
      [9694212] xfs: move (and rename) the deferred bmap-free tracepoints

Dave Chinner (3):
      [8e51de5] patch libxfs-apply-formatting
      [fca3ed9] libxfs: fix set-but unused warning in dir2 code
      [2a6da3b] xfs: separate freelist fixing into a separate helper

Eric Sandeen (1):
      [2d066e1] xfs: make several functions static

Hou Tao (1):
      [2873bdf] xfs: remove the magic numbers in xfs_btree_block-related le=
n macros

Kaho Ng (1):
      [dcaff8a] xfs: indentation fix in xfs_btree_get_iroot()


Code Diffstat:

 db/dir2.h                 |    4 +-
 db/dir2sf.c               |   11 +-
 db/faddr.c                |    6 +-
 db/field.c                |    8 +-
 fs/xfs/xfs_rmap_item.c    |    0
 fs/xfs/xfs_rmap_item.h    |    0
 include/libxfs.h          |    4 +-
 include/list.h            |   76 ++-
 include/xfs.h             |    7 +
 include/xfs_arch.h        |    7 -
 include/xfs_mount.h       |    6 +
 include/xfs_trace.h       |   46 +-
 libxfs/Makefile           |    6 +
 libxfs/init.c             |    7 +-
 libxfs/libxfs_api_defs.h  |    6 +-
 libxfs/libxfs_priv.h      |    4 +-
 libxfs/list_sort.c        |  141 +++++
 libxfs/rdwr.c             |    2 +-
 libxfs/util.c             |   34 +-
 libxfs/xfs_alloc.c        |  246 +++++++--
 libxfs/xfs_alloc.h        |   59 +-
 libxfs/xfs_alloc_btree.c  |   12 -
 libxfs/xfs_attr.c         |   71 +--
 libxfs/xfs_attr_leaf.c    |    4 +-
 libxfs/xfs_attr_leaf.h    |    3 -
 libxfs/xfs_attr_remote.c  |   19 +-
 libxfs/xfs_bmap.c         |  256 ++++-----
 libxfs/xfs_bmap.h         |   54 +-
 libxfs/xfs_bmap_btree.c   |   32 +-
 libxfs/xfs_btree.c        |  941 ++++++++++++++++++++++++++------
 libxfs/xfs_btree.h        |   90 +++-
 libxfs/xfs_da_btree.c     |    6 +-
 libxfs/xfs_da_btree.h     |    4 +-
 libxfs/xfs_da_format.c    |   31 +-
 libxfs/xfs_da_format.h    |   44 +-
 libxfs/xfs_defer.c        |  463 ++++++++++++++++
 libxfs/xfs_defer.h        |   97 ++++
 libxfs/xfs_dir2.c         |   15 +-
 libxfs/xfs_dir2.h         |    8 +-
 libxfs/xfs_dir2_sf.c      |   38 +-
 libxfs/xfs_format.h       |  197 +++++--
 libxfs/xfs_fs.h           |    1 +
 libxfs/xfs_ialloc.c       |   43 +-
 libxfs/xfs_ialloc.h       |    2 +-
 libxfs/xfs_ialloc_btree.c |   18 +-
 libxfs/xfs_inode_buf.c    |    1 +
 libxfs/xfs_log_format.h   |   63 ++-
 libxfs/xfs_rmap.c         | 1397 +++++++++++++++++++++++++++++++++++++++++=
+++++++
 libxfs/xfs_rmap.h         |  209 ++++++++
 libxfs/xfs_rmap_btree.c   |  509 ++++++++++++++++++
 libxfs/xfs_rmap_btree.h   |   68 +++
 libxfs/xfs_rtbitmap.c     |    2 +-
 libxfs/xfs_sb.c           |    9 +
 libxfs/xfs_shared.h       |    2 +
 libxfs/xfs_trans_resv.c   |   62 ++-
 libxfs/xfs_trans_resv.h   |   10 -
 libxfs/xfs_types.h        |    4 +-
 mkfs/proto.c              |   56 +-
 mkfs/xfs_mkfs.c           |   16 +-
 repair/phase6.c           |   94 ++--
 tools/libxfs-apply        |  158 +++++-
 61 files changed, 4899 insertions(+), 890 deletions(-)
 create mode 100644 fs/xfs/xfs_rmap_item.c
 create mode 100644 fs/xfs/xfs_rmap_item.h
 create mode 100644 libxfs/list_sort.c
 create mode 100644 libxfs/xfs_defer.c
 create mode 100644 libxfs/xfs_defer.h
 create mode 100644 libxfs/xfs_rmap.c
 create mode 100644 libxfs/xfs_rmap.h
 create mode 100644 libxfs/xfs_rmap_btree.c
 create mode 100644 libxfs/xfs_rmap_btree.h
--=20
Dave Chinner
david@fromorbit.com

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqwm8AAoJEK3oKUf0dfodZ1sP/ipoDqF8Xm1ql1wL9JfN6jc6
QlVvKDR5+UeUbHqRVFTaWEKDaQIVFlBMYdnDRi5+yNQnV/mP0vWpMS8TTTJptP+a
KlYCeJk1+FMmiiQw2pmMrvDbDao23IW6UZj2JuIY4yM452Z1LUjCBArPqhh73TAV
McKL+9EppGNisODH9iWRvVw0Z95FkG+eQB0M7G6+TWQ5tWtO/Og3FA4bj0ri4rIS
PDjdrkyTGZCvfyS5FPqOEplp9NEkcB+FfYKMZOXLCUGmoOYZ1Du09YXmKhjNFt1m
pwR1yoxATO4Ow1SWQ5ItcYrEiPnzf5YrZTWTWTTHcTbYf//S0MH2ZNVGX8Dqtpdn
XXFsEReS4V1SxgQgu926IGRzEqh0qH+F0gzG0VIdIbqsg4F2MuwJo7UDuIwoyipq
ErjgQjkNGIvaZU75iKjPQ187oAQCt/JaNpXivzs56eYOfbaCceENJCaakGZTxXOW
CFoez4w2CMnIzvGZTK3ggHU5IGTaSQW2P/nyNqWaaUXrxWWYJtZPfJOImCv5ltcy
2aGUgoKZjIX1esAbmfKF/Wz5bLBHEHC6zBmiKfsrkmA8LTGp69gMT8+PRWYweaC0
BRNycBbSIYurUEgX618P/xqMgxAtsRXy0LRnI0gQdP/5PnvB+mflgJBfqh8ve+Bj
S6lqgCzbPH8FHcWUv+/8
=xnNR
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--


--===============0706486093979608995==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0706486093979608995==--
