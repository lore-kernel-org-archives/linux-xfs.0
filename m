Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master, updated. v3.19-rc1
Message-Id: <20141223214131.6B5457F54@oss.sgi.com>
Date: Tue, 23 Dec 2014 15:41:30 -0600 (CST)
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
  c05e14f Merge tag 'xfs-for-linus-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs
  1366f5d Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
  6044e43 Merge branch 'xfs-misc-fixes-for-3.19-2' into for-next
  b29c70f xfs: split metadata and log buffer completion to separate workqueues
  32296f8 xfs: fix set-but-unused warnings
  9a2cc41 xfs: move type conversion functions to xfs_dir.h
  1b767ee xfs: move ftype conversion functions to libxfs
  2d3d0c5 xfs: lobotomise xfs_trans_read_buf_map()
  cdc9cec xfs: active inodes stat is broken
  4db431f xfs: cleanup xfs_bmse_merge returns
  b11bd67 xfs: cleanup xfs_bmse_shift_one goto mess
  7a1df15 xfs: fix premature enospc on inode allocation
  76b5730 xfs: overflow in xfs_iomap_eof_align_last_fsb
  e77b854 Merge branch 'xfs-coccinelle-cleanups' into xfs-misc-fixes-for-3.19-2
  c14fc01 Merge branch 'xfs-coccinelle-cleanups' into for-next
  d254aae xfs: fix simple_return.cocci warning in xfs_bmse_shift_one
  8300475 xfs: fix simple_return.cocci warning in xfs_file_readdir
  b72091f libxfs: fix simple_return.cocci warnings
  d2a5e3c xfs: remove unnecessary null checks
  216875a Merge branch 'xfs-consolidate-format-defs' into for-next
  4bd47c1 Merge branch 'xfs-misc-fixes-for-3.19-1' into for-next
  508b6b3 xfs: merge xfs_inum.h into xfs_format.h
  bb58e61 xfs: move most of xfs_sb.h to xfs_format.h
  4fb6e8a xfs: merge xfs_ag.h into xfs_format.h
  5beda58 xfs: move acl structures to xfs_format.h
  6d3ebaa xfs: merge xfs_dinode.h into xfs_format.h
  db52d09e xfs: catch invalid negative blknos in _xfs_buf_find()
  91ee575 xfs: allow lazy sb counter sync during filesystem freeze sequence
  5d45ee1 xfs: fix error handling in xfs_qm_log_quotaoff()
  062647a xfs: replace on-stack xfs_trans_res with pointer in xfs_create()
  78c931b xfs: replace global xfslogd wq with per-mount wq
  17ef4fd xfs: Set allowed quota types
  0027589 xfs: track bulkstat progress by agino
  febe3cb xfs: bulkstat error handling is broken
  6e57c542 xfs: bulkstat main loop logic is a mess
  2b831ac xfs: bulkstat chunk-formatter has issues
  bf4a5af xfs: bulkstat chunk formatting cursor is broken
  afa947c xfs: bulkstat btree walk doesn't terminate
  5d11fb4 xfs: rework zero range to prevent invalid i_size updates
  7a19dee xfs: Check error during inode btree iteration in xfs_bulkstat()
  a6bbce5 xfs: bulkstat doesn't release AGI buffer on error
      from  cac7f2429872d3733dc3f9915857b1691da2eb2f (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit c05e14f7b3145ac89635fa398934438240dace40
Merge: 9bfccec 6044e43
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Dec 12 09:48:17 2014 -0800

    Merge tag 'xfs-for-linus-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs
    
    Pull xfs update from Dave Chinner:
     "There's relatively little change in this update; it is mainly bug
      fixes, cleanups and more of the on-going libxfs restructuring and
      on-disk format header consolidation work.
    
      Details:
       - more on-disk format header consolidation
       - move some structures shared with userspace to libxfs
       - new per-mount workqueue to fix for deadlocks between nested loop
         mounted filesystems
       - various bug fixes for ENOSPC, stats, quota off and preallocation
       - a bunch of compiler warning fixes for set-but-unused variables
       - various code cleanups"
    
    * tag 'xfs-for-linus-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs: (24 commits)
      xfs: split metadata and log buffer completion to separate workqueues
      xfs: fix set-but-unused warnings
      xfs: move type conversion functions to xfs_dir.h
      xfs: move ftype conversion functions to libxfs
      xfs: lobotomise xfs_trans_read_buf_map()
      xfs: active inodes stat is broken
      xfs: cleanup xfs_bmse_merge returns
      xfs: cleanup xfs_bmse_shift_one goto mess
      xfs: fix premature enospc on inode allocation
      xfs: overflow in xfs_iomap_eof_align_last_fsb
      xfs: fix simple_return.cocci warning in xfs_bmse_shift_one
      xfs: fix simple_return.cocci warning in xfs_file_readdir
      libxfs: fix simple_return.cocci warnings
      xfs: remove unnecessary null checks
      xfs: merge xfs_inum.h into xfs_format.h
      xfs: move most of xfs_sb.h to xfs_format.h
      xfs: merge xfs_ag.h into xfs_format.h
      xfs: move acl structures to xfs_format.h
      xfs: merge xfs_dinode.h into xfs_format.h
      xfs: catch invalid negative blknos in _xfs_buf_find()
      ...

commit 1366f5d3129f2abde606214de7afc3dd61781fa3
Merge: 4b0a268 fdf2657
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Dec 10 15:43:30 2014 -0800

    Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
    
    Pull quota updates from Jan Kara:
     "Quota improvements and some minor cleanups.
    
      The main portion in the pull request are changes which move i_dquot
      array from struct inode into fs-private part of an inode which saves
      memory for filesystems which don't use VFS quotas"
    
    * 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs:
      udf: One function call less in udf_fill_super() after error detection
      udf: Deletion of unnecessary checks before the function call "iput"
      jbd: Deletion of an unnecessary check before the function call "iput"
      vfs: Remove i_dquot field from inode
      jfs: Convert to private i_dquot field
      reiserfs: Convert to private i_dquot field
      ocfs2: Convert to private i_dquot field
      ext4: Convert to private i_dquot field
      ext3: Convert to private i_dquot field
      ext2: Convert to private i_dquot field
      quota: Use function to provide i_dquot pointers
      xfs: Set allowed quota types
      gfs2: Set allowed quota types
      quota: Allow each filesystem to specify which quota types it supports
      quota: Remove const from function declarations
      quota: Add log level to printk

commit 17ef4fdd379dc7bcbdf46b2630d33958244d0053
Author: Jan Kara <jack@suse.cz>
Date:   Tue Sep 30 22:35:33 2014 +0200

    xfs: Set allowed quota types
    
    We support user, group, and project quotas. Tell VFS about it.
    
    CC: xfs@oss.sgi.com
    CC: Dave Chinner <david@fromorbit.com>
    Acked-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jan Kara <jack@suse.cz>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/libxfs/xfs_ag.h             |  281 ---------
 fs/xfs/libxfs/xfs_alloc.c          |    1 -
 fs/xfs/libxfs/xfs_alloc.h          |    3 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |    1 -
 fs/xfs/libxfs/xfs_attr.c           |    3 -
 fs/xfs/libxfs/xfs_attr_leaf.c      |    2 -
 fs/xfs/libxfs/xfs_attr_remote.c    |    2 -
 fs/xfs/libxfs/xfs_bmap.c           |   77 +--
 fs/xfs/libxfs/xfs_bmap_btree.c     |    3 -
 fs/xfs/libxfs/xfs_btree.c          |    2 -
 fs/xfs/libxfs/xfs_da_btree.c       |    6 -
 fs/xfs/libxfs/xfs_da_format.c      |    2 -
 fs/xfs/libxfs/xfs_dinode.h         |  243 --------
 fs/xfs/libxfs/xfs_dir2.c           |   20 +-
 fs/xfs/libxfs/xfs_dir2.h           |  140 +++++
 fs/xfs/libxfs/xfs_dir2_block.c     |   11 -
 fs/xfs/libxfs/xfs_dir2_data.c      |    2 -
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   12 -
 fs/xfs/libxfs/xfs_dir2_node.c      |   14 -
 fs/xfs/libxfs/xfs_dir2_priv.h      |  140 -----
 fs/xfs/libxfs/xfs_dir2_sf.c        |   13 -
 fs/xfs/libxfs/xfs_dquot_buf.c      |    2 -
 fs/xfs/libxfs/xfs_format.h         | 1107 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c         |   43 +-
 fs/xfs/libxfs/xfs_ialloc.h         |    4 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 -
 fs/xfs/libxfs/xfs_inode_buf.c      |    3 -
 fs/xfs/libxfs/xfs_inode_fork.c     |    4 -
 fs/xfs/libxfs/xfs_inum.h           |   60 --
 fs/xfs/libxfs/xfs_log_format.h     |    2 +-
 fs/xfs/libxfs/xfs_log_rlimit.c     |    2 -
 fs/xfs/libxfs/xfs_rtbitmap.c       |    3 -
 fs/xfs/libxfs/xfs_sb.c             |    2 -
 fs/xfs/libxfs/xfs_sb.h             |  584 -------------------
 fs/xfs/libxfs/xfs_symlink_remote.c |    2 -
 fs/xfs/libxfs/xfs_trans_resv.c     |    2 -
 fs/xfs/xfs_acl.c                   |    2 -
 fs/xfs/xfs_acl.h                   |   36 --
 fs/xfs/xfs_aops.c                  |    3 -
 fs/xfs/xfs_attr_inactive.c         |    3 -
 fs/xfs/xfs_attr_list.c             |    3 -
 fs/xfs/xfs_bmap_util.c             |   75 +--
 fs/xfs/xfs_buf.c                   |   27 +-
 fs/xfs/xfs_buf.h                   |    3 +-
 fs/xfs/xfs_buf_item.c              |    2 +-
 fs/xfs/xfs_dir2_readdir.c          |   21 +-
 fs/xfs/xfs_discard.c               |    1 -
 fs/xfs/xfs_dquot.c                 |    2 -
 fs/xfs/xfs_dquot_item.c            |    2 -
 fs/xfs/xfs_error.c                 |    2 -
 fs/xfs/xfs_export.c                |    3 +-
 fs/xfs/xfs_extent_busy.c           |    1 -
 fs/xfs/xfs_extfree_item.c          |    3 +-
 fs/xfs/xfs_file.c                  |    9 +-
 fs/xfs/xfs_filestream.c            |    3 -
 fs/xfs/xfs_fsops.c                 |    2 -
 fs/xfs/xfs_icache.c                |    4 +-
 fs/xfs/xfs_icache.h                |    8 +
 fs/xfs/xfs_icreate_item.c          |    3 +-
 fs/xfs/xfs_inode.c                 |   29 +-
 fs/xfs/xfs_inode.h                 |    2 -
 fs/xfs/xfs_inode_item.c            |    3 -
 fs/xfs/xfs_ioctl.c                 |    3 -
 fs/xfs/xfs_ioctl32.c               |    2 -
 fs/xfs/xfs_iomap.c                 |   18 +-
 fs/xfs/xfs_iops.c                  |    5 +-
 fs/xfs/xfs_itable.c                |  256 ++++-----
 fs/xfs/xfs_itable.h                |   16 -
 fs/xfs/xfs_linux.h                 |    6 +
 fs/xfs/xfs_log.c                   |    8 +-
 fs/xfs/xfs_log_cil.c               |    3 +-
 fs/xfs/xfs_log_recover.c           |    4 +-
 fs/xfs/xfs_message.c               |    3 +-
 fs/xfs/xfs_mount.c                 |   33 +-
 fs/xfs/xfs_mount.h                 |    8 +-
 fs/xfs/xfs_qm.c                    |   14 +-
 fs/xfs/xfs_qm_bhv.c                |    2 -
 fs/xfs/xfs_qm_syscalls.c           |   27 +-
 fs/xfs/xfs_quotaops.c              |    2 -
 fs/xfs/xfs_rtalloc.c               |    3 -
 fs/xfs/xfs_super.c                 |   20 +-
 fs/xfs/xfs_symlink.c               |    3 -
 fs/xfs/xfs_trace.c                 |    2 -
 fs/xfs/xfs_trans.c                 |    2 -
 fs/xfs/xfs_trans_ail.c             |    3 +-
 fs/xfs/xfs_trans_buf.c             |  137 ++---
 fs/xfs/xfs_trans_dquot.c           |    2 -
 fs/xfs/xfs_trans_extfree.c         |    3 +-
 fs/xfs/xfs_trans_inode.c           |    2 -
 fs/xfs/xfs_xattr.c                 |    2 -
 90 files changed, 1610 insertions(+), 2031 deletions(-)
 delete mode 100644 fs/xfs/libxfs/xfs_ag.h
 delete mode 100644 fs/xfs/libxfs/xfs_dinode.h
 delete mode 100644 fs/xfs/libxfs/xfs_inum.h


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
