Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o545uEJt204052 for <xfs@oss.sgi.com>; Fri, 4 Jun 2010 00:56:14 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F825AC4873
	for <xfs@oss.sgi.com>; Thu,  3 Jun 2010 23:01:13 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	ettrtgYfD0DWO3O8 for <xfs@oss.sgi.com>;
	Thu, 03 Jun 2010 23:01:13 -0700 (PDT)
Date: Fri, 4 Jun 2010 15:58:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT] fixes and cleanups for xfs-dev
Message-ID: <20100604055837.GB20641@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

Hi Alex,

Here are the latest list of reviewed patches for the xfs-dev tree.
The inode cluster freeing fix really needs to go to Linus for .35
(and a .34-stable update is probably needed).

You can leave Christoph's cleanups out if further discussion is
needed - it is the above bug fix I'm pushing this branch out for.

Cheers,

Dave.

The following changes since commit fb3b504adeee942e55393396fea8fdf406acf037:

  xfs: fix access to upper inodes without inode64 (2010-05-28 15:19:56 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/git/linux/dgc/xfs for-dev

Christoph Hellwig (17):
      xfs: remove done roadmap item from xfs-delayed-logging-design.txt
      xfs: skip writeback from reclaim context
      xfs: improve xfs_isilocked
      xfs: drop dmapi hooks
      xfs: remove unneeded #include statements
      xfs: simplify log item descriptor tracking
      xfs: merge iop_unpin_remove into iop_unpin
      xfs: give xfs_item_ops methods the correct prototypes
      xfs: give li_cb callbacks the correct prototype
      xfs: simplify buffer pinning
      xfs: simplify inode to transaction joining
      xfs: fix the xfs_log_iovec i_addr type
      xfs: kill the unused xlog_debug variable
      xfs: remove the unused XFS_LOG_SLEEP and XFS_LOG_NOSLEEP flags
      xfs: remove the unused XFS_TRANS_NOSLEEP/XFS_TRANS_WAIT flags
      xfs: remove unused XFS_BMAPI_ flags
      xfs: remove unused delta tracking code in xfs_bmapi

Dave Chinner (1):
      xfs: fix race in inode cluster freeing failing to stale inodes

 .../filesystems/xfs-delayed-logging-design.txt     |    5 -
 fs/xfs/Makefile                                    |    4 +-
 fs/xfs/linux-2.6/xfs_aops.c                        |   26 +-
 fs/xfs/linux-2.6/xfs_buf.c                         |   33 +--
 fs/xfs/linux-2.6/xfs_buf.h                         |    9 +-
 fs/xfs/linux-2.6/xfs_dmapi_priv.h                  |   28 --
 fs/xfs/linux-2.6/xfs_export.c                      |    1 -
 fs/xfs/linux-2.6/xfs_file.c                        |   99 +-----
 fs/xfs/linux-2.6/xfs_fs_subr.c                     |    4 -
 fs/xfs/linux-2.6/xfs_fs_subr.h                     |   25 --
 fs/xfs/linux-2.6/xfs_ioctl.c                       |   23 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c                     |    4 -
 fs/xfs/linux-2.6/xfs_iops.c                        |    8 -
 fs/xfs/linux-2.6/xfs_linux.h                       |    1 -
 fs/xfs/linux-2.6/xfs_quotaops.c                    |    1 -
 fs/xfs/linux-2.6/xfs_super.c                       |   84 +---
 fs/xfs/linux-2.6/xfs_super.h                       |    7 -
 fs/xfs/linux-2.6/xfs_sync.c                        |   14 +-
 fs/xfs/linux-2.6/xfs_trace.c                       |    4 -
 fs/xfs/linux-2.6/xfs_trace.h                       |    2 -
 fs/xfs/quota/xfs_dquot.c                           |  114 ++---
 fs/xfs/quota/xfs_dquot_item.c                      |  301 ++++++--------
 fs/xfs/quota/xfs_qm.c                              |    9 +-
 fs/xfs/quota/xfs_qm_bhv.c                          |   10 -
 fs/xfs/quota/xfs_qm_stats.c                        |   10 -
 fs/xfs/quota/xfs_qm_syscalls.c                     |   10 -
 fs/xfs/quota/xfs_trans_dquot.c                     |   35 +--
 fs/xfs/support/debug.c                             |    1 -
 fs/xfs/xfs_alloc.c                                 |    5 -
 fs/xfs/xfs_alloc_btree.c                           |    5 -
 fs/xfs/xfs_attr.c                                  |   91 ++---
 fs/xfs/xfs_attr_leaf.c                             |    5 +-
 fs/xfs/xfs_bmap.c                                  |  300 ++------------
 fs/xfs/xfs_bmap.h                                  |   37 +--
 fs/xfs/xfs_bmap_btree.c                            |    5 -
 fs/xfs/xfs_btree.c                                 |    5 -
 fs/xfs/xfs_buf_item.c                              |  227 +++++------
 fs/xfs/xfs_buf_item.h                              |    2 +-
 fs/xfs/xfs_da_btree.c                              |   14 +-
 fs/xfs/xfs_dfrag.c                                 |   16 +-
 fs/xfs/xfs_dir2.c                                  |    9 +-
 fs/xfs/xfs_dir2_block.c                            |    2 -
 fs/xfs/xfs_dir2_data.c                             |    2 -
 fs/xfs/xfs_dir2_leaf.c                             |    4 +-
 fs/xfs/xfs_dir2_node.c                             |    2 -
 fs/xfs/xfs_dir2_sf.c                               |    2 -
 fs/xfs/xfs_dmapi.h                                 |  170 --------
 fs/xfs/xfs_dmops.c                                 |   55 ---
 fs/xfs/xfs_error.c                                 |    4 -
 fs/xfs/xfs_extfree_item.c                          |  278 +++++-------
 fs/xfs/xfs_filestream.c                            |    4 -
 fs/xfs/xfs_fsops.c                                 |    7 +-
 fs/xfs/xfs_ialloc.c                                |    4 -
 fs/xfs/xfs_ialloc_btree.c                          |    4 -
 fs/xfs/xfs_iget.c                                  |   30 +-
 fs/xfs/xfs_inode.c                                 |  175 ++++-----
 fs/xfs/xfs_inode_item.c                            |  250 ++++-------
 fs/xfs/xfs_inode_item.h                            |   12 +-
 fs/xfs/xfs_iomap.c                                 |   26 +-
 fs/xfs/xfs_itable.c                                |    4 -
 fs/xfs/xfs_log.c                                   |    7 +-
 fs/xfs/xfs_log.h                                   |   11 +-
 fs/xfs/xfs_log_cil.c                               |    4 +-
 fs/xfs/xfs_log_recover.c                           |   42 +--
 fs/xfs/xfs_mount.c                                 |    3 -
 fs/xfs/xfs_mount.h                                 |   67 ---
 fs/xfs/xfs_rename.c                                |   60 +---
 fs/xfs/xfs_rtalloc.c                               |    9 +-
 fs/xfs/xfs_rw.c                                    |   15 -
 fs/xfs/xfs_trans.c                                 |  211 ++++++----
 fs/xfs/xfs_trans.h                                 |  117 +-----
 fs/xfs/xfs_trans_ail.c                             |    1 -
 fs/xfs/xfs_trans_buf.c                             |   75 +---
 fs/xfs/xfs_trans_extfree.c                         |   23 +-
 fs/xfs/xfs_trans_inode.c                           |   74 ++---
 fs/xfs/xfs_trans_item.c                            |  441 --------------------
 fs/xfs/xfs_trans_priv.h                            |   18 +-
 fs/xfs/xfs_utils.c                                 |    8 +-
 fs/xfs/xfs_vnodeops.c                              |  265 ++----------
 79 files changed, 973 insertions(+), 3106 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/xfs_dmapi_priv.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_fs_subr.h
 delete mode 100644 fs/xfs/xfs_dmapi.h
 delete mode 100644 fs/xfs/xfs_dmops.c
 delete mode 100644 fs/xfs/xfs_trans_item.c
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
