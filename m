Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 139237F3F
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2014 17:05:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4C59AC004
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2014 15:05:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	99iS2QunL8y3pA9C for <xfs@oss.sgi.com>;
	Thu, 11 Dec 2014 15:05:05 -0800 (PST)
Date: Fri, 12 Dec 2014 10:04:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 3.19-rc1
Message-ID: <20141211230409.GD9756@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the current XFS updates from the tree below?
There's relatively little change in this update; it is mainly bug
fixes, cleanups and more of the on-going libxfs restructuring
and on-disk format header consolidation work.

-Dave.

The following changes since commit 002758992693ae63c04122603ea9261a0a58d728:

  xfs: track bulkstat progress by agino (2014-11-07 08:33:52 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-3.19-rc1

for you to fetch changes up to 6044e4386cd51dece882ea42352cdaaab0f24cad:

  Merge branch 'xfs-misc-fixes-for-3.19-2' into for-next (2014-12-04 09:46:17 +1100)

----------------------------------------------------------------

xfs: update for 3.19-rc1

This update contains:
o more on-disk format header consolidation
o move some structures shared with userspace to libxfs
o new per-mount workqueue to fix for deadlocks between nested loop
  mounted filesystems
o various bug fixes for ENOSPC, stats, quota off and preallocation
o a bunch of compiler warning fixes for set-but-unused variables
o various code cleanups

----------------------------------------------------------------
Brian Foster (5):
      xfs: replace global xfslogd wq with per-mount wq
      xfs: replace on-stack xfs_trans_res with pointer in xfs_create()
      xfs: fix error handling in xfs_qm_log_quotaoff()
      xfs: allow lazy sb counter sync during filesystem freeze sequence
      xfs: split metadata and log buffer completion to separate workqueues

Christoph Hellwig (5):
      xfs: merge xfs_dinode.h into xfs_format.h
      xfs: move acl structures to xfs_format.h
      xfs: merge xfs_ag.h into xfs_format.h
      xfs: move most of xfs_sb.h to xfs_format.h
      xfs: merge xfs_inum.h into xfs_format.h

Dave Chinner (13):
      Merge branch 'xfs-misc-fixes-for-3.19-1' into for-next
      Merge branch 'xfs-consolidate-format-defs' into for-next
      Merge branch 'xfs-coccinelle-cleanups' into for-next
      Merge branch 'xfs-coccinelle-cleanups' into xfs-misc-fixes-for-3.19-2
      xfs: fix premature enospc on inode allocation
      xfs: cleanup xfs_bmse_shift_one goto mess
      xfs: cleanup xfs_bmse_merge returns
      xfs: active inodes stat is broken
      xfs: lobotomise xfs_trans_read_buf_map()
      xfs: move ftype conversion functions to libxfs
      xfs: move type conversion functions to xfs_dir.h
      xfs: fix set-but-unused warnings
      Merge branch 'xfs-misc-fixes-for-3.19-2' into for-next

Eric Sandeen (1):
      xfs: catch invalid negative blknos in _xfs_buf_find()

Markus Elfring (1):
      xfs: remove unnecessary null checks

Peter Watkins (1):
      xfs: overflow in xfs_iomap_eof_align_last_fsb

kbuild test robot (3):
      libxfs: fix simple_return.cocci warnings
      xfs: fix simple_return.cocci warning in xfs_file_readdir
      xfs: fix simple_return.cocci warning in xfs_bmse_shift_one

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
 fs/xfs/xfs_bmap_util.c             |    3 -
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
 fs/xfs/xfs_itable.c                |    6 -
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
 fs/xfs/xfs_super.c                 |   19 +-
 fs/xfs/xfs_symlink.c               |    3 -
 fs/xfs/xfs_trace.c                 |    2 -
 fs/xfs/xfs_trans.c                 |    2 -
 fs/xfs/xfs_trans_ail.c             |    3 +-
 fs/xfs/xfs_trans_buf.c             |  137 ++---
 fs/xfs/xfs_trans_dquot.c           |    2 -
 fs/xfs/xfs_trans_extfree.c         |    3 +-
 fs/xfs/xfs_trans_inode.c           |    2 -
 fs/xfs/xfs_xattr.c                 |    2 -
 89 files changed, 1467 insertions(+), 1835 deletions(-)
 delete mode 100644 fs/xfs/libxfs/xfs_ag.h
 delete mode 100644 fs/xfs/libxfs/xfs_dinode.h
 delete mode 100644 fs/xfs/libxfs/xfs_inum.h
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
