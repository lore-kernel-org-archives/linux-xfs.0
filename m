Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. xfs-for-linus-3.17-rc1-13176-g52addcf
Message-Id: <20140828110411.86C3D7F47@oss.sgi.com>
Date: Thu, 28 Aug 2014 06:04:10 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, master has been updated
  645f985 Merge branch 'xfs-misc-fixes-3.17-2' into for-next
  b076d87 Merge branch 'xfs-bulkstat-refactor' into for-next
  4d7eece Merge branch 'xfs-misc-fixes-3.17-1' into for-next
  e0ac6d4 Merge branch 'xfs-quota-eofblocks-scan' into for-next
  6eee897 xfs: fix coccinelle warnings
  4ef897a xfs: flush both inodes in xfs_swap_extents
  8121768 xfs: fix swapext ilock deadlock
  b92cc59 xfs: kill xfs_vnode.h
  dd8c38b xfs: kill VN_MAPPED
  2667c6f xfs: kill VN_CACHED
  eac152b xfs: kill VN_DIRTY()
  ad3714b xfs: dquot recovery needs verifiers
  5fd364f xfs: quotacheck leaves dquot buffers without verifiers
  67dc288 xfs: ensure verifiers are attached to recovered buffers
  400b9d8 xfs: catch buffers written without verifiers attached
  5ef828c xfs: avoid false quotacheck after unclean shutdown
  eedf32b xfs: fix rounding error of fiemap length parameter
  1e773c4 xfs: introduce xfs_bulkstat_ag_ichunk
  d5cf09b xfs: require 64-bit sector_t
  74dc93a xfs: fix uflags detection at xfs_fs_rm_xquota
  7b409a7 xfs: remove XFS_IS_OQUOTA_ON macros
  54aa61f xfs: tidy up xfs_set_inode32
  9de67c3 xfs: allow inode allocations in post-growfs disk space
  eb866bb xfs: mark xfs_qm_quotacheck as static
  5c18717 xfs: fix cil push sequence after log recovery
  f074051 xfs: squash prealloc while over quota free space as well
  dc06f398 xfs: run an eofblocks scan on ENOSPC/EDQUOT
  f452639 xfs: support a union-based filter for eofblocks scans
  5400da7 xfs: add scan owner field to xfs_eofblocks
  f3d1e58 xfs: introduce xfs_bulkstat_grab_ichunk
  4b8fdfe xfs: introduce xfs_bulkstat_ichunk_ra
  d4c2734 xfs: fix error handling at xfs_bulkstat
  296dfd7 xfs: remove redundant user buffer count checks at xfs_bulkstat
  c7cb51d xfs: fix error handling at xfs_inumbers
  549fa00 xfs: consolidate xfs_inumbers
  d716f8e xfs: remove xfs_bulkstat_single
  8fe6577 xfs: remove redundant stat assignment in xfs_bulkstat_one_int
  80d6d69 xfs: add log attributes for log lsn and grant head data
  baff4e4 xfs: add xlog sysfs kobject and attribute handlers
  a31b1d3 xfs: add xfs_mount sysfs kobject
  3d87122 xfs: add a sysfs kset
  a70a4fa xfs: fix a couple error sequence jumps in xfs_mountfs()
  7f8a058 Merge branch 'xfs-libxfs-restructure' into for-next
  03e0134 xfs: null unused quota inodes when quota is on
  cf11da9 xfs: refine the allocation stack switch
  aa182e6 Revert "xfs: block allocation work needs to be kswapd aware"
  2451337 xfs: global error sign conversion
  30f712c libxfs: move source files
  84be0ff libxfs: move header files
  69116a1 xfs: create libxfs infrastructure
  b474c7a xfs: Nuke XFS_ERROR macro
  d99831f xfs: return is not a function
      from  a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/Kconfig                           |   1 +
 fs/xfs/Makefile                          |  71 ++--
 fs/xfs/{ => libxfs}/xfs_ag.h             |   0
 fs/xfs/{ => libxfs}/xfs_alloc.c          |  20 +-
 fs/xfs/{ => libxfs}/xfs_alloc.h          |   0
 fs/xfs/{ => libxfs}/xfs_alloc_btree.c    |   6 +-
 fs/xfs/{ => libxfs}/xfs_alloc_btree.h    |   0
 fs/xfs/{ => libxfs}/xfs_attr.c           |  92 ++---
 fs/xfs/{ => libxfs}/xfs_attr_leaf.c      |  78 ++---
 fs/xfs/{ => libxfs}/xfs_attr_leaf.h      |   0
 fs/xfs/{ => libxfs}/xfs_attr_remote.c    |  22 +-
 fs/xfs/{ => libxfs}/xfs_attr_remote.h    |   0
 fs/xfs/{ => libxfs}/xfs_attr_sf.h        |   0
 fs/xfs/{ => libxfs}/xfs_bit.h            |   0
 fs/xfs/{ => libxfs}/xfs_bmap.c           |  67 ++--
 fs/xfs/{ => libxfs}/xfs_bmap.h           |   4 +-
 fs/xfs/{ => libxfs}/xfs_bmap_btree.c     |  99 +-----
 fs/xfs/{ => libxfs}/xfs_bmap_btree.h     |   0
 fs/xfs/{ => libxfs}/xfs_btree.c          | 128 +++++--
 fs/xfs/{ => libxfs}/xfs_btree.h          |   2 +-
 fs/xfs/{ => libxfs}/xfs_cksum.h          |   0
 fs/xfs/{ => libxfs}/xfs_da_btree.c       | 112 +++---
 fs/xfs/{ => libxfs}/xfs_da_btree.h       |   0
 fs/xfs/{ => libxfs}/xfs_da_format.c      |   0
 fs/xfs/{ => libxfs}/xfs_da_format.h      |   0
 fs/xfs/{ => libxfs}/xfs_dinode.h         |   0
 fs/xfs/{ => libxfs}/xfs_dir2.c           |  24 +-
 fs/xfs/{ => libxfs}/xfs_dir2.h           |   0
 fs/xfs/{ => libxfs}/xfs_dir2_block.c     |  18 +-
 fs/xfs/{ => libxfs}/xfs_dir2_data.c      |  10 +-
 fs/xfs/{ => libxfs}/xfs_dir2_leaf.c      |  24 +-
 fs/xfs/{ => libxfs}/xfs_dir2_node.c      |  40 +--
 fs/xfs/{ => libxfs}/xfs_dir2_priv.h      |   0
 fs/xfs/{ => libxfs}/xfs_dir2_sf.c        |  75 ++--
 fs/xfs/{ => libxfs}/xfs_dquot_buf.c      |   6 +-
 fs/xfs/{ => libxfs}/xfs_format.h         |  14 +-
 fs/xfs/{ => libxfs}/xfs_ialloc.c         |  34 +-
 fs/xfs/{ => libxfs}/xfs_ialloc.h         |   0
 fs/xfs/{ => libxfs}/xfs_ialloc_btree.c   |   6 +-
 fs/xfs/{ => libxfs}/xfs_ialloc_btree.h   |   0
 fs/xfs/{ => libxfs}/xfs_inode_buf.c      |  10 +-
 fs/xfs/{ => libxfs}/xfs_inode_buf.h      |   0
 fs/xfs/{ => libxfs}/xfs_inode_fork.c     |  36 +-
 fs/xfs/{ => libxfs}/xfs_inode_fork.h     |   0
 fs/xfs/{ => libxfs}/xfs_inum.h           |   4 -
 fs/xfs/{ => libxfs}/xfs_log_format.h     |   4 +-
 fs/xfs/{ => libxfs}/xfs_log_recover.h    |   0
 fs/xfs/{ => libxfs}/xfs_log_rlimit.c     |   0
 fs/xfs/{ => libxfs}/xfs_quota_defs.h     |   2 -
 fs/xfs/{ => libxfs}/xfs_rtbitmap.c       |   0
 fs/xfs/{ => libxfs}/xfs_sb.c             |  81 +++--
 fs/xfs/{ => libxfs}/xfs_sb.h             |   8 +-
 fs/xfs/{ => libxfs}/xfs_shared.h         |   0
 fs/xfs/{ => libxfs}/xfs_symlink_remote.c |   6 +-
 fs/xfs/{ => libxfs}/xfs_trans_resv.c     |   0
 fs/xfs/{ => libxfs}/xfs_trans_resv.h     |   0
 fs/xfs/{ => libxfs}/xfs_trans_space.h    |   0
 fs/xfs/xfs_acl.c                         |   8 +-
 fs/xfs/xfs_aops.c                        |  18 +-
 fs/xfs/xfs_attr_inactive.c               |  22 +-
 fs/xfs/xfs_attr_list.c                   |  38 +-
 fs/xfs/xfs_bmap_util.c                   | 227 +++++-------
 fs/xfs/xfs_bmap_util.h                   |   4 -
 fs/xfs/xfs_buf.c                         |  40 ++-
 fs/xfs/xfs_buf.h                         |   2 +-
 fs/xfs/xfs_buf_item.c                    |   4 +-
 fs/xfs/xfs_dir2_readdir.c                |   4 +-
 fs/xfs/xfs_discard.c                     |  18 +-
 fs/xfs/xfs_dquot.c                       |  41 +--
 fs/xfs/xfs_dquot.h                       |  15 +
 fs/xfs/xfs_error.c                       |  25 +-
 fs/xfs/xfs_error.h                       |  13 +-
 fs/xfs/xfs_export.c                      |  10 +-
 fs/xfs/xfs_extfree_item.c                |   2 +-
 fs/xfs/xfs_file.c                        |  75 ++--
 fs/xfs/xfs_filestream.c                  |   4 +-
 fs/xfs/xfs_fs.h                          |   7 +-
 fs/xfs/xfs_fsops.c                       |  42 +--
 fs/xfs/xfs_icache.c                      | 148 ++++++--
 fs/xfs/xfs_icache.h                      |  13 +-
 fs/xfs/xfs_inode.c                       |  68 ++--
 fs/xfs/xfs_inode.h                       |  10 +
 fs/xfs/xfs_inode_item.c                  |   2 +-
 fs/xfs/xfs_ioctl.c                       | 266 +++++++-------
 fs/xfs/xfs_ioctl32.c                     | 111 +++---
 fs/xfs/xfs_iomap.c                       |  57 +--
 fs/xfs/xfs_iops.c                        |  72 ++--
 fs/xfs/xfs_itable.c                      | 579 ++++++++++++++-----------------
 fs/xfs/xfs_itable.h                      |  23 +-
 fs/xfs/xfs_linux.h                       |  27 +-
 fs/xfs/xfs_log.c                         |  69 ++--
 fs/xfs/xfs_log_cil.c                     |   8 +-
 fs/xfs/xfs_log_priv.h                    |   2 +
 fs/xfs/xfs_log_recover.c                 | 284 ++++++++-------
 fs/xfs/xfs_mount.c                       |  97 +++---
 fs/xfs/xfs_mount.h                       |   1 +
 fs/xfs/xfs_mru_cache.c                   |  14 +-
 fs/xfs/xfs_qm.c                          | 229 ++++++------
 fs/xfs/xfs_qm.h                          |   1 -
 fs/xfs/xfs_qm_bhv.c                      |   2 +-
 fs/xfs/xfs_qm_syscalls.c                 |  46 +--
 fs/xfs/xfs_quotaops.c                    |  20 +-
 fs/xfs/xfs_rtalloc.c                     |  24 +-
 fs/xfs/xfs_rtalloc.h                     |   2 +-
 fs/xfs/xfs_super.c                       | 132 +++----
 fs/xfs/xfs_super.h                       |  15 +-
 fs/xfs/xfs_symlink.c                     |  30 +-
 fs/xfs/xfs_sysfs.c                       | 165 +++++++++
 fs/xfs/xfs_sysfs.h                       |  59 ++++
 fs/xfs/xfs_trans.c                       |  10 +-
 fs/xfs/xfs_trans_ail.c                   |   4 +-
 fs/xfs/xfs_trans_buf.c                   |  37 +-
 fs/xfs/xfs_trans_dquot.c                 |   4 +-
 fs/xfs/xfs_types.h                       |  29 +-
 fs/xfs/xfs_vnode.h                       |  46 ---
 fs/xfs/xfs_xattr.c                       |   6 +-
 116 files changed, 2319 insertions(+), 2116 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_ag.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_alloc.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_alloc.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_alloc_btree.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_alloc_btree.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_attr.c (97%)
 rename fs/xfs/{ => libxfs}/xfs_attr_leaf.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_attr_leaf.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_attr_remote.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_attr_remote.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_attr_sf.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_bit.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_bmap.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_bmap.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_bmap_btree.c (88%)
 rename fs/xfs/{ => libxfs}/xfs_bmap_btree.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_btree.c (97%)
 rename fs/xfs/{ => libxfs}/xfs_btree.h (99%)
 rename fs/xfs/{ => libxfs}/xfs_cksum.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_da_btree.c (97%)
 rename fs/xfs/{ => libxfs}/xfs_da_btree.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_da_format.c (100%)
 rename fs/xfs/{ => libxfs}/xfs_da_format.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_dinode.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_dir2.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_dir2.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_block.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_data.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_leaf.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_node.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_priv.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_sf.c (97%)
 rename fs/xfs/{ => libxfs}/xfs_dquot_buf.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_format.h (97%)
 rename fs/xfs/{ => libxfs}/xfs_ialloc.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_ialloc.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_ialloc_btree.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_ialloc_btree.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_inode_buf.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_inode_buf.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_inode_fork.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_inode_fork.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_inum.h (96%)
 rename fs/xfs/{ => libxfs}/xfs_log_format.h (99%)
 rename fs/xfs/{ => libxfs}/xfs_log_recover.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_log_rlimit.c (100%)
 rename fs/xfs/{ => libxfs}/xfs_quota_defs.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_rtbitmap.c (100%)
 rename fs/xfs/{ => libxfs}/xfs_sb.c (93%)
 rename fs/xfs/{ => libxfs}/xfs_sb.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_shared.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_symlink_remote.c (97%)
 rename fs/xfs/{ => libxfs}/xfs_trans_resv.c (100%)
 rename fs/xfs/{ => libxfs}/xfs_trans_resv.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_trans_space.h (100%)
 create mode 100644 fs/xfs/xfs_sysfs.c
 create mode 100644 fs/xfs/xfs_sysfs.h
 delete mode 100644 fs/xfs/xfs_vnode.h


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
