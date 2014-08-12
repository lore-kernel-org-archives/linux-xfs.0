Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2C9E7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 07:53:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BEC4F304048
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 05:53:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qg1smTeJVNOOEpoC for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 05:53:28 -0700 (PDT)
Date: Tue, 12 Aug 2014 22:53:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 3.17-rc1
Message-ID: <20140812125313.GX20518@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4974727181754490487=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


--===============4974727181754490487==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Can you please pull the XFS changes from the tree below? The
diffstat is kind of noisy because of the restructuring of the code
to make kernel/userspace code sharing simpler, along with an XFS
wide change to use the standard negative error return convention (at
last!). The rest of the changes are noted in the tag below.

FYI, this will be the last pull request I will send you from a tree
on oss.sgi.com. I'm moving everything XFS related over to kernel.org
so future pull requests should come from there.

-Dave.

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-3.17-rc1

for you to fetch changes up to 645f9857213476407d8ed1b59619fdff7128d3e6:

  Merge branch 'xfs-misc-fixes-3.17-2' into for-next (2014-08-04 13:55:27 +=
1000)

----------------------------------------------------------------

xfs: update for 3.17-rc1

This update contains:
o conversion of the XFS core to pass negative error numbers
o restructing of core XFS code that is shared with userspace to fs/xfs/libx=
fs
o introduction of sysfs interface for XFS
o bulkstat refactoring
o demand driven speculative preallocation removal
o XFS now always requires 64 bit sectors to be configured
o metadata verifier changes to ensure CRCs are calculated during log recove=
ry
o various minor code cleanups
o miscellaneous bug fixes

----------------------------------------------------------------
Brian Foster (11):
      xfs: fix a couple error sequence jumps in xfs_mountfs()
      xfs: add a sysfs kset
      xfs: add xfs_mount sysfs kobject
      xfs: add xlog sysfs kobject and attribute handlers
      xfs: add log attributes for log lsn and grant head data
      xfs: document log sysfs attributes in testing ABI
      xfs: add scan owner field to xfs_eofblocks
      xfs: support a union-based filter for eofblocks scans
      xfs: run an eofblocks scan on ENOSPC/EDQUOT
      xfs: squash prealloc while over quota free space as well
      xfs: fix rounding error of fiemap length parameter

Christoph Hellwig (2):
      xfs: remove xfs_bulkstat_single
      xfs: require 64-bit sector_t

Dave Chinner (22):
      xfs: create libxfs infrastructure
      libxfs: move header files
      libxfs: move source files
      xfs: global error sign conversion
      Revert "xfs: block allocation work needs to be kswapd aware"
      xfs: refine the allocation stack switch
      xfs: null unused quota inodes when quota is on
      Merge branch 'xfs-libxfs-restructure' into for-next
      xfs: catch buffers written without verifiers attached
      xfs: ensure verifiers are attached to recovered buffers
      xfs: quotacheck leaves dquot buffers without verifiers
      xfs: dquot recovery needs verifiers
      xfs: kill VN_DIRTY()
      xfs: kill VN_CACHED
      xfs: kill VN_MAPPED
      xfs: kill xfs_vnode.h
      xfs: fix swapext ilock deadlock
      xfs: flush both inodes in xfs_swap_extents
      Merge branch 'xfs-quota-eofblocks-scan' into for-next
      Merge branch 'xfs-misc-fixes-3.17-1' into for-next
      Merge branch 'xfs-bulkstat-refactor' into for-next
      Merge branch 'xfs-misc-fixes-3.17-2' into for-next

Eric Sandeen (5):
      xfs: return is not a function
      xfs: Nuke XFS_ERROR macro
      xfs: allow inode allocations in post-growfs disk space
      xfs: tidy up xfs_set_inode32
      xfs: avoid false quotacheck after unclean shutdown

Jie Liu (11):
      xfs: remove redundant stat assignment in xfs_bulkstat_one_int
      xfs: consolidate xfs_inumbers
      xfs: fix error handling at xfs_inumbers
      xfs: remove redundant user buffer count checks at xfs_bulkstat
      xfs: fix error handling at xfs_bulkstat
      xfs: introduce xfs_bulkstat_ichunk_ra
      xfs: introduce xfs_bulkstat_grab_ichunk
      xfs: mark xfs_qm_quotacheck as static
      xfs: remove XFS_IS_OQUOTA_ON macros
      xfs: fix uflags detection at xfs_fs_rm_xquota
      xfs: introduce xfs_bulkstat_ag_ichunk

Mark Tinguely (1):
      xfs: fix cil push sequence after log recovery

kbuild test robot (1):
      xfs: fix coccinelle warnings

 Documentation/ABI/testing/sysfs-fs-xfs   |   39 ++
 fs/xfs/Kconfig                           |    1 +
 fs/xfs/Makefile                          |   71 ++--
 fs/xfs/{ =3D> libxfs}/xfs_ag.h             |    0
 fs/xfs/{ =3D> libxfs}/xfs_alloc.c          |   20 +-
 fs/xfs/{ =3D> libxfs}/xfs_alloc.h          |    0
 fs/xfs/{ =3D> libxfs}/xfs_alloc_btree.c    |    6 +-
 fs/xfs/{ =3D> libxfs}/xfs_alloc_btree.h    |    0
 fs/xfs/{ =3D> libxfs}/xfs_attr.c           |   92 ++---
 fs/xfs/{ =3D> libxfs}/xfs_attr_leaf.c      |   78 ++--
 fs/xfs/{ =3D> libxfs}/xfs_attr_leaf.h      |    0
 fs/xfs/{ =3D> libxfs}/xfs_attr_remote.c    |   22 +-
 fs/xfs/{ =3D> libxfs}/xfs_attr_remote.h    |    0
 fs/xfs/{ =3D> libxfs}/xfs_attr_sf.h        |    0
 fs/xfs/{ =3D> libxfs}/xfs_bit.h            |    0
 fs/xfs/{ =3D> libxfs}/xfs_bmap.c           |   67 ++--
 fs/xfs/{ =3D> libxfs}/xfs_bmap.h           |    4 +-
 fs/xfs/{ =3D> libxfs}/xfs_bmap_btree.c     |   99 +----
 fs/xfs/{ =3D> libxfs}/xfs_bmap_btree.h     |    0
 fs/xfs/{ =3D> libxfs}/xfs_btree.c          |  128 +++++--
 fs/xfs/{ =3D> libxfs}/xfs_btree.h          |    2 +-
 fs/xfs/{ =3D> libxfs}/xfs_cksum.h          |    0
 fs/xfs/{ =3D> libxfs}/xfs_da_btree.c       |  112 +++---
 fs/xfs/{ =3D> libxfs}/xfs_da_btree.h       |    0
 fs/xfs/{ =3D> libxfs}/xfs_da_format.c      |    0
 fs/xfs/{ =3D> libxfs}/xfs_da_format.h      |    0
 fs/xfs/{ =3D> libxfs}/xfs_dinode.h         |    0
 fs/xfs/{ =3D> libxfs}/xfs_dir2.c           |   24 +-
 fs/xfs/{ =3D> libxfs}/xfs_dir2.h           |    0
 fs/xfs/{ =3D> libxfs}/xfs_dir2_block.c     |   18 +-
 fs/xfs/{ =3D> libxfs}/xfs_dir2_data.c      |   10 +-
 fs/xfs/{ =3D> libxfs}/xfs_dir2_leaf.c      |   24 +-
 fs/xfs/{ =3D> libxfs}/xfs_dir2_node.c      |   40 +--
 fs/xfs/{ =3D> libxfs}/xfs_dir2_priv.h      |    0
 fs/xfs/{ =3D> libxfs}/xfs_dir2_sf.c        |   75 ++--
 fs/xfs/{ =3D> libxfs}/xfs_dquot_buf.c      |    6 +-
 fs/xfs/{ =3D> libxfs}/xfs_format.h         |   14 +-
 fs/xfs/{ =3D> libxfs}/xfs_ialloc.c         |   34 +-
 fs/xfs/{ =3D> libxfs}/xfs_ialloc.h         |    0
 fs/xfs/{ =3D> libxfs}/xfs_ialloc_btree.c   |    6 +-
 fs/xfs/{ =3D> libxfs}/xfs_ialloc_btree.h   |    0
 fs/xfs/{ =3D> libxfs}/xfs_inode_buf.c      |   10 +-
 fs/xfs/{ =3D> libxfs}/xfs_inode_buf.h      |    0
 fs/xfs/{ =3D> libxfs}/xfs_inode_fork.c     |   36 +-
 fs/xfs/{ =3D> libxfs}/xfs_inode_fork.h     |    0
 fs/xfs/{ =3D> libxfs}/xfs_inum.h           |    4 -
 fs/xfs/{ =3D> libxfs}/xfs_log_format.h     |    4 +-
 fs/xfs/{ =3D> libxfs}/xfs_log_recover.h    |    0
 fs/xfs/{ =3D> libxfs}/xfs_log_rlimit.c     |    0
 fs/xfs/{ =3D> libxfs}/xfs_quota_defs.h     |    2 -
 fs/xfs/{ =3D> libxfs}/xfs_rtbitmap.c       |    0
 fs/xfs/{ =3D> libxfs}/xfs_sb.c             |   81 +++--
 fs/xfs/{ =3D> libxfs}/xfs_sb.h             |    8 +-
 fs/xfs/{ =3D> libxfs}/xfs_shared.h         |    0
 fs/xfs/{ =3D> libxfs}/xfs_symlink_remote.c |    6 +-
 fs/xfs/{ =3D> libxfs}/xfs_trans_resv.c     |    0
 fs/xfs/{ =3D> libxfs}/xfs_trans_resv.h     |    0
 fs/xfs/{ =3D> libxfs}/xfs_trans_space.h    |    0
 fs/xfs/xfs_acl.c                         |    8 +-
 fs/xfs/xfs_aops.c                        |   18 +-
 fs/xfs/xfs_attr_inactive.c               |   22 +-
 fs/xfs/xfs_attr_list.c                   |   38 +-
 fs/xfs/xfs_bmap_util.c                   |  227 +++++-------
 fs/xfs/xfs_bmap_util.h                   |    4 -
 fs/xfs/xfs_buf.c                         |   40 ++-
 fs/xfs/xfs_buf.h                         |    2 +-
 fs/xfs/xfs_buf_item.c                    |    4 +-
 fs/xfs/xfs_dir2_readdir.c                |    4 +-
 fs/xfs/xfs_discard.c                     |   18 +-
 fs/xfs/xfs_dquot.c                       |   41 +--
 fs/xfs/xfs_dquot.h                       |   15 +
 fs/xfs/xfs_error.c                       |   25 +-
 fs/xfs/xfs_error.h                       |   13 +-
 fs/xfs/xfs_export.c                      |   10 +-
 fs/xfs/xfs_extfree_item.c                |    2 +-
 fs/xfs/xfs_file.c                        |   75 ++--
 fs/xfs/xfs_filestream.c                  |    4 +-
 fs/xfs/xfs_fs.h                          |    7 +-
 fs/xfs/xfs_fsops.c                       |   42 +--
 fs/xfs/xfs_icache.c                      |  148 ++++++--
 fs/xfs/xfs_icache.h                      |   13 +-
 fs/xfs/xfs_inode.c                       |   68 ++--
 fs/xfs/xfs_inode.h                       |   10 +
 fs/xfs/xfs_inode_item.c                  |    2 +-
 fs/xfs/xfs_ioctl.c                       |  266 +++++++-------
 fs/xfs/xfs_ioctl32.c                     |  111 +++---
 fs/xfs/xfs_iomap.c                       |   57 +--
 fs/xfs/xfs_iops.c                        |   72 ++--
 fs/xfs/xfs_itable.c                      |  579 ++++++++++++++------------=
----
 fs/xfs/xfs_itable.h                      |   23 +-
 fs/xfs/xfs_linux.h                       |   27 +-
 fs/xfs/xfs_log.c                         |   69 ++--
 fs/xfs/xfs_log_cil.c                     |    8 +-
 fs/xfs/xfs_log_priv.h                    |    2 +
 fs/xfs/xfs_log_recover.c                 |  284 ++++++++-------
 fs/xfs/xfs_mount.c                       |   97 ++---
 fs/xfs/xfs_mount.h                       |    1 +
 fs/xfs/xfs_mru_cache.c                   |   14 +-
 fs/xfs/xfs_qm.c                          |  229 ++++++------
 fs/xfs/xfs_qm.h                          |    1 -
 fs/xfs/xfs_qm_bhv.c                      |    2 +-
 fs/xfs/xfs_qm_syscalls.c                 |   46 +--
 fs/xfs/xfs_quotaops.c                    |   20 +-
 fs/xfs/xfs_rtalloc.c                     |   24 +-
 fs/xfs/xfs_rtalloc.h                     |    2 +-
 fs/xfs/xfs_super.c                       |  132 +++----
 fs/xfs/xfs_super.h                       |   15 +-
 fs/xfs/xfs_symlink.c                     |   30 +-
 fs/xfs/xfs_sysfs.c                       |  165 +++++++++
 fs/xfs/xfs_sysfs.h                       |   59 +++
 fs/xfs/xfs_trans.c                       |   10 +-
 fs/xfs/xfs_trans_ail.c                   |    4 +-
 fs/xfs/xfs_trans_buf.c                   |   37 +-
 fs/xfs/xfs_trans_dquot.c                 |    4 +-
 fs/xfs/xfs_types.h                       |   29 +-
 fs/xfs/xfs_vnode.h                       |   46 ---
 fs/xfs/xfs_xattr.c                       |    6 +-
 117 files changed, 2358 insertions(+), 2116 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-xfs
 rename fs/xfs/{ =3D> libxfs}/xfs_ag.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_alloc.c (99%)
 rename fs/xfs/{ =3D> libxfs}/xfs_alloc.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_alloc_btree.c (99%)
 rename fs/xfs/{ =3D> libxfs}/xfs_alloc_btree.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_attr.c (97%)
 rename fs/xfs/{ =3D> libxfs}/xfs_attr_leaf.c (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_attr_leaf.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_attr_remote.c (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_attr_remote.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_attr_sf.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_bit.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_bmap.c (99%)
 rename fs/xfs/{ =3D> libxfs}/xfs_bmap.h (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_bmap_btree.c (88%)
 rename fs/xfs/{ =3D> libxfs}/xfs_bmap_btree.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_btree.c (97%)
 rename fs/xfs/{ =3D> libxfs}/xfs_btree.h (99%)
 rename fs/xfs/{ =3D> libxfs}/xfs_cksum.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_da_btree.c (97%)
 rename fs/xfs/{ =3D> libxfs}/xfs_da_btree.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_da_format.c (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_da_format.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dinode.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dir2.c (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dir2.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dir2_block.c (99%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dir2_data.c (99%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dir2_leaf.c (99%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dir2_node.c (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dir2_priv.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dir2_sf.c (97%)
 rename fs/xfs/{ =3D> libxfs}/xfs_dquot_buf.c (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_format.h (97%)
 rename fs/xfs/{ =3D> libxfs}/xfs_ialloc.c (99%)
 rename fs/xfs/{ =3D> libxfs}/xfs_ialloc.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_ialloc_btree.c (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_ialloc_btree.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_inode_buf.c (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_inode_buf.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_inode_fork.c (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_inode_fork.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_inum.h (96%)
 rename fs/xfs/{ =3D> libxfs}/xfs_log_format.h (99%)
 rename fs/xfs/{ =3D> libxfs}/xfs_log_recover.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_log_rlimit.c (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_quota_defs.h (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_rtbitmap.c (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_sb.c (93%)
 rename fs/xfs/{ =3D> libxfs}/xfs_sb.h (98%)
 rename fs/xfs/{ =3D> libxfs}/xfs_shared.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_symlink_remote.c (97%)
 rename fs/xfs/{ =3D> libxfs}/xfs_trans_resv.c (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_trans_resv.h (100%)
 rename fs/xfs/{ =3D> libxfs}/xfs_trans_space.h (100%)
 create mode 100644 fs/xfs/xfs_sysfs.c
 create mode 100644 fs/xfs/xfs_sysfs.h
 delete mode 100644 fs/xfs/xfs_vnode.h


--=20
Dave Chinner
david@fromorbit.com

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6g44AAoJEK3oKUf0dfodS40P/irj9NHfLmSTXmOXKAp+rhUs
fDN9bqI/EjQaeqTf2pRP1jFsCO14Pr9j/QVOF/bBminJ6NKqnGuzfYQzRWsQ+IDH
Kx2RFnkOMnj/QEOPGO9fsfzCNqW/rIt2HHFqR+QGfB0dJCcMiTlLGPjMGyNYo7GJ
jkCB3x6hSZY0S33mhyQTKlsGMY+0q77KbVeZQZK90nhIZER7RSALB2N+i9SSokxV
mty9TkLCOFOY9wv38GWokx7N+MZk5IUypPj08z8xD+HMBJ8mrmYpV40ezuYOHVhq
IwAjA7q147BIi9v4BtdObx77//sLQ05uIUriBcZRGTZ7ZJpIEw1aRE7uRGTJvhLo
JATD9y/SAWeinNVRtMzSEGs+KuCHYMDGcqHsFdTRNV++DmnuMJgt+GNrgaLEOLoF
mHokbHGL0saR9uo0Kc4Ztv4P0pSDiywi9M5gYBeKCtWuJluym58XN4neWe02gk5N
ZDNKyIykbn57afT3YoXqvh7XXyeJuYjNjJc2bECK4dlHHlvOGQJ5iofEJ5WyiOBt
jRCHE1QS7c8Xsq4fe/ObvPCBQHfWEk2wdFfa6IYTPUzbn+2KfLKQgl9Ww3AmUCu0
MDei1prTapMu3j6/Y63fol9yknmOe/y0KOpnORqoeCN3vDWCv0HAnXDzVPNMRSFp
YiVOBNxP/zw+YSkKpvnI
=oLm5
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--


--===============4974727181754490487==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4974727181754490487==--
