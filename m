Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17B377F55
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 12:40:21 -0500 (CDT)
Subject: [GIT PULL] XFS updates for 3.12-rc1
Message-Id: <20130909174017.697A34266DC@whiskey.americas.sgi.com>
Date: Mon,  9 Sep 2013 12:40:17 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
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
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

   Please pull these XFS updates for 3.12-rc1.  Most of this is related to the
   libxfs kernel/userspace sync, there is also project quota work, performance
   work in the log, recovery, and the CIL.  User namespace support has been
   added, directory entries now have file type support, there is work to
   cleanup log space reservations, a bunch of spelling cleanups, and bug fixes.

Thanks,
	Ben

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/xfs-for-linus-v3.12-rc1

for you to fetch changes up to 1d03c6fa88af35e55047a1f2ab116f0fdf2f55aa:

  xfs: XFS_MOUNT_QUOTA_ALL needed by userspace (2013-09-03 15:00:06 -0500)

----------------------------------------------------------------
xfs: update for v3.12-rc1

For 3.12-rc1 there are a number of bugfixes in addition to work to ease usage
of shared code between libxfs and the kernel, the rest of the work to enable
project and group quotas to be used simultaneously, performance optimisations
in the log and the CIL, directory entry file type support, fixes for log space
reservations, some spelling/grammar cleanups, and the addition of user
namespace support.

- introduce readahead to log recovery
- add directory entry file type support
- fix a number of spelling errors in comments
- introduce new Q_XGETQSTATV quotactl for project quotas
- add USER_NS support
- log space reservation rework
- CIL optimisations
- kernel/userspace libxfs rework

----------------------------------------------------------------
Brian Foster (1):
      xfs: check correct status variable for xfs_inobt_get_rec() call

Chandra Seetharaman (5):
      xfs: Fix a deadlock in xfs_log_commit_cil() code path
      xfs: Initialize all quota inodes to be NULLFSINO
      xfs: Start using pquotaino from the superblock.
      quota: Add a new quotactl command Q_XGETQSTATV
      xfs: Add support for the Q_XGETQSTATV

Dan Carpenter (1):
      xfs: check for underflow in xfs_iformat_fork()

Dave Chinner (53):
      xfs: di_flushiter considered harmful
      xfs: separate out log format definitions
      xfs: split out inode log item format definition
      xfs: split out buf log item format definitions
      xfs: split out EFI/EFD log item format definition
      xfs: separate dquot on disk format definitions out of xfs_quota.h
      xfs: separate icreate log format definitions from xfs_icreate_item.h
      xfs: split out on-disk transaction definitions
      xfs: introduce xfs_rtalloc_defs.h
      xfs: introduce xfs_quota_defs.h
      xfs: sync minor header differences needed by userspace.
      xfs: split out transaction reservation code
      xfs: move inode fork definitions to a new header file
      xfs: move unrelated definitions out of xfs_inode.h
      xfs: introduce xfs_inode_buf.c for inode buffer operations
      xfs: move getdents code into it's own file
      xfs: reshuffle dir2 definitions around for userspace
      xfs: split out attribute listing code into separate file
      xfs: split out attribute fork truncation code into separate file
      xfs: split out the remote symlink handling
      xfs: introduce xfs_sb.c for sharing with libxfs
      xfs: create xfs_bmap_util.[ch]
      xfs: minor cleanups
      xfs: fix issues that cause userspace warnings
      xfs: kill xfs_vnodeops.[ch]
      xfs: consolidate xfs_rename.c
      xfs: consolidate xfs_utils.c
      xfs: consolidate extent swap code
      xfs: don't special case shared superblock mounts
      xfs: kill __KERNEL__ check for debug code in allocation code
      xfs: remove __KERNEL__ from debug code
      xfs: remove __KERNEL__ check from xfs_dir2_leaf.c
      xfs: xfs_filestreams.h doesn't need __KERNEL__
      xfs: move kernel specific type definitions to xfs.h
      xfs: make struct xfs_perag kernel only
      xfs: return log item size in IOP_SIZE
      xfs: Reduce allocations during CIL insertion
      xfs: avoid CIL allocation during insert
      xfs: Combine CIL insert and prepare passes
      xfs: split the CIL lock
      xfs: use reference counts to free clean buffer items
      xfs: Add read-only support for dirent filetype field
      xfs: Add write support for dirent filetype field
      xfs: don't account buffer cancellation during log recovery readahead
      xfs: fix bad dquot buffer size in log recovery readahead
      XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
      xfs: btree block LSN escaping to disk uninitialised
      xfs: check LSN ordering for v5 superblocks during recovery
      xfs: inode buffers may not be valid during recovery readahead
      xfs: inode log reservations are too small
      xfs: finish removing IOP_* macros.
      xfs: dtype changed xfs_dir2_sfe_put_ino to xfs_dir3_sfe_put_ino
      xfs: XFS_MOUNT_QUOTA_ALL needed by userspace

Dwight Engen (8):
      xfs: create wrappers for converting kuid_t to/from uid_t
      xfs: convert kuid_t to/from uid_t in ACLs
      xfs: ioctl check for capabilities in the current user namespace
      xfs: convert kuid_t to/from uid_t for internal structures
      xfs: create internal eofblocks structure with kuid_t types
      xfs: add capability check to free eofblocks ioctl
      enable building user namespace with xfs
      powerpc/spufs: convert userns uid/gid mount options to kuid/kgid

Eric Sandeen (4):
      xfs: avoid double-free in xfs_attr_node_addname
      xfs: free bp in xlog_find_zeroed() error path
      xfs:free bp in xlog_find_tail() error path
      Fix wrong flag ASSERT in xfs_attr_shortform_getvalue

Fengguang Wu (1):
      xfs: xfs_dir3_sfe_put_ino can be static

Jie Liu (11):
      xfs: fix assertion failure in xfs_vm_write_failed()
      xfs: Introduce a new structure to hold transaction reservation items
      xfs: Introduce tr_fsyncts to m_reservation
      xfs: Make writeid transaction use tr_writeid
      xfs: refactor xfs_trans_reserve() interface
      xfs: Get rid of all XFS_XXX_LOG_RES() macro
      xfs: Refactor xfs_ticket_alloc() to extract a new helper
      xfs: Add xfs_log_rlimit.c
      xfs: Validate log space at mount time
      xfs: call roundup_64() to calculate the min_logblks
      xfs: Simplify xfs_ail_min() with list_first_entry_or_null()

Mark Tinguely (1):
      xfs: add xfs sb v4 support for dirent filetype field

Richard Weinberger (1):
      xfs: Register hotcpu notifier after initialization

Tejun Heo (1):
      xfs: WQ_NON_REENTRANT is meaningless and going away

Zhi Yong Wu (25):
      xfs: fix the comment of xfs_check_sizes()
      xfs: fix the comment of xfs_buf_free()
      xfs: fix the comment of xfs_btree_lookup()
      xfs: fix the comment of xfs_mod_incore_sb_unlocked()
      xfs: fix the comment of xlog_write_setup_copy()
      xfs: remove one blank line in xfs_btree_make_block_unfull()
      xfs: fix the comment of xfs_iroot_realloc()
      xfs: fix the comment of xfs_btree_get_iroot()
      xfs: remove two unused macro definitions in xfs_linux.h
      xfs: fix the comment of xlog_recover_buffer_pass2()
      xfs: fix the comment of xlog_find_head()
      xfs: rename bio_add_buffer() to xfs_bio_add_buffer()
      xfs: fix the comment of xfs_bmap_count_tree()
      xfs: fix the comment of xfs_bmap_validate_ret()
      xfs: fix the comment of xfs_bmap_last_before()
      xfs: fix the comment of xfs_bmap_punch_delalloc_range()
      xfs: fix the comment of xfs_setsize_buftarg_early()
      xfs: fix the comment of xfs_extent_busy_update_extent()
      xfs: fix the comment of xfs_ialloc_ag_select()
      xfs: fix the comment of xfs_ifree_cluster()
      xfs: fix the comment of xfs_log_unmount_write()
      xfs: fix the comment of xlog_recover_do_dquot_buffer()
      xfs: fix the comment of xfs_sb_quiet_read_verify()
      xfs: fix the comment of xfs_mountfs()
      xfs: introduce object readahead to log recovery

 arch/powerpc/platforms/cell/spufs/inode.c |    8 +-
 fs/quota/quota.c                          |   29 +
 fs/xfs/Makefile                           |   20 +-
 fs/xfs/xfs_acl.c                          |   24 +-
 fs/xfs/xfs_ag.h                           |   53 -
 fs/xfs/xfs_alloc.c                        |    6 +-
 fs/xfs/xfs_aops.c                         |   23 +-
 fs/xfs/xfs_attr.c                         |  427 +---
 fs/xfs/xfs_attr.h                         |    9 +
 fs/xfs/xfs_attr_inactive.c                |  453 ++++
 fs/xfs/xfs_attr_leaf.c                    |  657 +----
 fs/xfs/xfs_attr_leaf.h                    |    2 +
 fs/xfs/xfs_attr_list.c                    |  655 +++++
 fs/xfs/xfs_attr_remote.c                  |   18 +-
 fs/xfs/xfs_bmap.c                         |  823 +------
 fs/xfs/xfs_bmap.h                         |   56 +-
 fs/xfs/xfs_bmap_btree.c                   |    6 +-
 fs/xfs/xfs_bmap_util.c                    | 2026 +++++++++++++++
 fs/xfs/xfs_bmap_util.h                    |  110 +
 fs/xfs/xfs_btree.c                        |    7 +-
 fs/xfs/xfs_btree.h                        |    2 -
 fs/xfs/xfs_buf.c                          |    5 +-
 fs/xfs/xfs_buf_item.c                     |   58 +-
 fs/xfs/xfs_buf_item.h                     |  100 +-
 fs/xfs/xfs_da_btree.c                     |    8 +-
 fs/xfs/xfs_da_btree.h                     |   12 +-
 fs/xfs/xfs_dfrag.c                        |  459 ----
 fs/xfs/xfs_dfrag.h                        |   53 -
 fs/xfs/xfs_dinode.h                       |    3 +
 fs/xfs/xfs_dir2.c                         |   58 +-
 fs/xfs/xfs_dir2.h                         |   46 +
 fs/xfs/xfs_dir2_block.c                   |  122 +-
 fs/xfs/xfs_dir2_data.c                    |   25 +-
 fs/xfs/xfs_dir2_format.h                  |  186 +-
 fs/xfs/xfs_dir2_leaf.c                    |  404 +--
 fs/xfs/xfs_dir2_node.c                    |   14 +-
 fs/xfs/xfs_dir2_priv.h                    |   49 +-
 fs/xfs/xfs_dir2_readdir.c                 |  695 ++++++
 fs/xfs/xfs_dir2_sf.c                      |  240 +-
 fs/xfs/xfs_discard.c                      |    5 +-
 fs/xfs/xfs_dquot.c                        |    8 +-
 fs/xfs/xfs_dquot_item.c                   |   23 +-
 fs/xfs/xfs_error.c                        |    1 -
 fs/xfs/xfs_export.c                       |    5 +-
 fs/xfs/xfs_extent_busy.c                  |    2 +-
 fs/xfs/xfs_extfree_item.c                 |   50 +-
 fs/xfs/xfs_extfree_item.h                 |   88 +-
 fs/xfs/xfs_file.c                         |    3 +-
 fs/xfs/xfs_filestream.c                   |    8 +-
 fs/xfs/xfs_filestream.h                   |    4 -
 fs/xfs/xfs_format.h                       |  169 ++
 fs/xfs/xfs_fs.h                           |   38 +-
 fs/xfs/xfs_fsops.c                        |    8 +-
 fs/xfs/xfs_ialloc.c                       |    7 +-
 fs/xfs/xfs_icache.c                       |   15 +-
 fs/xfs/xfs_icache.h                       |   50 +
 fs/xfs/xfs_icreate_item.c                 |   21 +-
 fs/xfs/xfs_icreate_item.h                 |   18 -
 fs/xfs/xfs_inode.c                        | 3840 ++++++++++++-----------------
 fs/xfs/xfs_inode.h                        |  312 +--
 fs/xfs/xfs_inode_buf.c                    |  483 ++++
 fs/xfs/xfs_inode_buf.h                    |   53 +
 fs/xfs/xfs_inode_fork.c                   | 1920 +++++++++++++++
 fs/xfs/xfs_inode_fork.h                   |  171 ++
 fs/xfs/xfs_inode_item.c                   |   53 +-
 fs/xfs/xfs_inode_item.h                   |  115 +-
 fs/xfs/xfs_ioctl.c                        |  148 +-
 fs/xfs/xfs_ioctl.h                        |   10 +
 fs/xfs/xfs_ioctl32.c                      |    4 +-
 fs/xfs/xfs_iomap.c                        |   21 +-
 fs/xfs/xfs_iops.c                         |   78 +-
 fs/xfs/xfs_iops.h                         |   13 +
 fs/xfs/xfs_linux.h                        |   60 +-
 fs/xfs/xfs_log.c                          |  113 +-
 fs/xfs/xfs_log.h                          |   90 +-
 fs/xfs/xfs_log_cil.c                      |  371 +--
 fs/xfs/xfs_log_format.h                   |  852 +++++++
 fs/xfs/xfs_log_priv.h                     |  155 +-
 fs/xfs/xfs_log_recover.c                  |  420 +++-
 fs/xfs/xfs_log_rlimit.c                   |  147 ++
 fs/xfs/xfs_mount.c                        |  755 +-----
 fs/xfs/xfs_mount.h                        |  113 +-
 fs/xfs/xfs_qm.c                           |   95 +-
 fs/xfs/xfs_qm.h                           |    2 +
 fs/xfs/xfs_qm_bhv.c                       |    1 +
 fs/xfs/xfs_qm_syscalls.c                  |  126 +-
 fs/xfs/xfs_quota.h                        |  278 +--
 fs/xfs/xfs_quota_defs.h                   |  157 ++
 fs/xfs/xfs_quotaops.c                     |   17 +-
 fs/xfs/xfs_rename.c                       |  346 ---
 fs/xfs/xfs_rtalloc.c                      |   28 +-
 fs/xfs/xfs_rtalloc.h                      |   53 +-
 fs/xfs/xfs_sb.c                           |  834 +++++++
 fs/xfs/xfs_sb.h                           |   72 +-
 fs/xfs/xfs_super.c                        |   31 +-
 fs/xfs/xfs_symlink.c                      |  196 +-
 fs/xfs/xfs_symlink.h                      |   41 +-
 fs/xfs/xfs_symlink_remote.c               |  200 ++
 fs/xfs/xfs_trace.c                        |    1 +
 fs/xfs/xfs_trans.c                        |  732 +-----
 fs/xfs/xfs_trans.h                        |  301 +--
 fs/xfs/xfs_trans_ail.c                    |   18 +-
 fs/xfs/xfs_trans_buf.c                    |    2 +-
 fs/xfs/xfs_trans_dquot.c                  |    1 +
 fs/xfs/xfs_trans_priv.h                   |   15 +
 fs/xfs/xfs_trans_resv.c                   |  803 ++++++
 fs/xfs/xfs_trans_resv.h                   |  116 +
 fs/xfs/xfs_types.h                        |   60 +-
 fs/xfs/xfs_utils.c                        |  314 ---
 fs/xfs/xfs_utils.h                        |   27 -
 fs/xfs/xfs_vnodeops.c                     | 1870 --------------
 fs/xfs/xfs_vnodeops.h                     |   55 -
 fs/xfs/xfs_xattr.c                        |    2 +-
 include/linux/quota.h                     |    1 +
 include/uapi/linux/dqblk_xfs.h            |   47 +
 init/Kconfig                              |   13 -
 kernel/capability.c                       |    1 +
 117 files changed, 13677 insertions(+), 11950 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_inactive.c
 create mode 100644 fs/xfs/xfs_attr_list.c
 create mode 100644 fs/xfs/xfs_bmap_util.c
 create mode 100644 fs/xfs/xfs_bmap_util.h
 delete mode 100644 fs/xfs/xfs_dfrag.c
 delete mode 100644 fs/xfs/xfs_dfrag.h
 create mode 100644 fs/xfs/xfs_dir2_readdir.c
 create mode 100644 fs/xfs/xfs_format.h
 create mode 100644 fs/xfs/xfs_inode_buf.c
 create mode 100644 fs/xfs/xfs_inode_buf.h
 create mode 100644 fs/xfs/xfs_inode_fork.c
 create mode 100644 fs/xfs/xfs_inode_fork.h
 create mode 100644 fs/xfs/xfs_log_format.h
 create mode 100644 fs/xfs/xfs_log_rlimit.c
 create mode 100644 fs/xfs/xfs_quota_defs.h
 delete mode 100644 fs/xfs/xfs_rename.c
 create mode 100644 fs/xfs/xfs_sb.c
 create mode 100644 fs/xfs/xfs_symlink_remote.c
 create mode 100644 fs/xfs/xfs_trans_resv.c
 create mode 100644 fs/xfs/xfs_trans_resv.h
 delete mode 100644 fs/xfs/xfs_utils.c
 delete mode 100644 fs/xfs/xfs_utils.h
 delete mode 100644 fs/xfs/xfs_vnodeops.c
 delete mode 100644 fs/xfs/xfs_vnodeops.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
