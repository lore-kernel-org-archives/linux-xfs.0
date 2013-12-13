Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.12-11704-g46f23ad
Message-Id: <20131213202213.3A4057F53@oss.sgi.com>
Date: Fri, 13 Dec 2013 14:22:11 -0600 (CST)
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

The branch, for-next has been updated
  46f23ad Merge branch 'xfs-factor-icluster-macros' into for-next
  f9e5abc xfs: use xfs_icluster_size_fsb in xfs_imap
  982e939 xfs: use xfs_icluster_size_fsb in xfs_ifree_cluster
  6e0c7b8 xfs: use xfs_icluster_size_fsb in xfs_ialloc_inode_init
  a2ba07b xfs: use xfs_icluster_size_fsb in xfs_bulkstat
  904957b xfs: introduce a common helper xfs_icluster_size_fsb
  126cd10 xfs: get rid of XFS_IALLOC_BLOCKS macros
  0f49efd xfs: get rid of XFS_INODE_CLUSTER_SIZE macros
  7178343 xfs: get rid of XFS_IALLOC_INODES macros
  ffda4e8 xfs: remove the quotaoff log format from the quotaoff log item
  ce8e962 xfs: remove the dquot log format from the dquot log item
  2f25129 xfs: remove the inode log format from the inode log item
  da77650 xfs: format logged extents directly into the CIL
  bde7cff xfs: format log items write directly into the linear CIL buffer
  1234351 xfs: introduce xlog_copy_iovec
  3de559f xfs: refactor xfs_inode_item_format
  ce9641d xfs: refactor xfs_inode_item_size
  7aeb722 xfs: refactor xfs_buf_item_format_segment
  9597df6 xfs: remove duplicate code in xlog_cil_insert_format_items
      from  f9b395a8ef8f34d19cae2cde361e19c96e097fad (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 46f23adf78545c49591619a615edeec41ed5a549
Merge: ffda4e8 f9e5abc
Author: Ben Myers <bpm@sgi.com>
Date:   Fri Dec 13 14:15:33 2013 -0600

    Merge branch 'xfs-factor-icluster-macros' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_buf_item.c     | 103 ++++++------
 fs/xfs/xfs_dquot_item.c   |  67 +++-----
 fs/xfs/xfs_dquot_item.h   |   3 +-
 fs/xfs/xfs_extfree_item.c |  21 +--
 fs/xfs/xfs_ialloc.c       |  53 +++---
 fs/xfs/xfs_ialloc.h       |  21 +--
 fs/xfs/xfs_icreate_item.c |  10 +-
 fs/xfs/xfs_inode.c        |  23 +--
 fs/xfs/xfs_inode_fork.c   |  15 +-
 fs/xfs/xfs_inode_item.c   | 400 +++++++++++++++++++---------------------------
 fs/xfs/xfs_inode_item.h   |   5 -
 fs/xfs/xfs_itable.c       |  22 ++-
 fs/xfs/xfs_log.h          |  46 ++++++
 fs/xfs/xfs_log_cil.c      |  74 +++------
 fs/xfs/xfs_log_recover.c  |  16 +-
 fs/xfs/xfs_trans.h        |   2 +-
 fs/xfs/xfs_trans_resv.c   |  10 +-
 fs/xfs/xfs_trans_space.h  |   2 +-
 18 files changed, 399 insertions(+), 494 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
