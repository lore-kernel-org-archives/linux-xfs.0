Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4P3HN9X219972 for <xfs@oss.sgi.com>; Mon, 24 May 2010 22:17:23 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201005250319.o4P3JexR027722@stout.americas.sgi.com>
Date: Mon, 24 May 2010 22:19:40 -0500
Subject: [GIT PULL] XFS update for 2.6.35-rc1 (2 of 2)
MIME-Version: 1.0
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
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Here is the second set of changes for XFS for 2.6.35-rc1.	-Alex

The following changes since commit 7e125f7b9cbfce4101191b8076d606c517a73066:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6 (2010-05-24 08:05:29 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'delayed-logging-for-2.6.35' into for-linus

Dave Chinner (12):
      xfs: Don't reuse the same transaction ID for duplicated transactions.
      xfs: allow log ticket allocation to take allocation flags
      xfs: modify buffer item reference counting
      xfs: Clean up XFS_BLI_* flag namespace
      xfs: clean up log ticket overrun debug output
      xfs: make the log ticket ID available outside the log infrastructure
      xfs: Improve scalability of busy extent tracking
      xfs: Delayed logging design documentation
      xfs: Introduce delayed logging core code
      xfs: forced unmounts need to push the CIL
      xfs: enable background pushing of the CIL
      xfs: Ensure inode allocation buffers are fully replayed

 .../filesystems/xfs-delayed-logging-design.txt     |  816 ++++++++++++++++++++
 fs/xfs/Makefile                                    |    1 +
 fs/xfs/linux-2.6/xfs_buf.c                         |    9 +
 fs/xfs/linux-2.6/xfs_quotaops.c                    |    1 +
 fs/xfs/linux-2.6/xfs_super.c                       |   12 +-
 fs/xfs/linux-2.6/xfs_trace.h                       |   83 ++-
 fs/xfs/quota/xfs_dquot.c                           |    6 +-
 fs/xfs/xfs_ag.h                                    |   24 +-
 fs/xfs/xfs_alloc.c                                 |  357 ++++++---
 fs/xfs/xfs_alloc.h                                 |    7 +-
 fs/xfs/xfs_alloc_btree.c                           |    2 +-
 fs/xfs/xfs_buf_item.c                              |  166 ++--
 fs/xfs/xfs_buf_item.h                              |   18 +-
 fs/xfs/xfs_error.c                                 |    2 +-
 fs/xfs/xfs_log.c                                   |  120 +++-
 fs/xfs/xfs_log.h                                   |   14 +-
 fs/xfs/xfs_log_cil.c                               |  725 +++++++++++++++++
 fs/xfs/xfs_log_priv.h                              |  118 +++-
 fs/xfs/xfs_log_recover.c                           |   46 +-
 fs/xfs/xfs_log_recover.h                           |    2 +-
 fs/xfs/xfs_mount.h                                 |    1 +
 fs/xfs/xfs_trans.c                                 |  144 +++-
 fs/xfs/xfs_trans.h                                 |   44 +-
 fs/xfs/xfs_trans_buf.c                             |   46 +-
 fs/xfs/xfs_trans_item.c                            |  114 +---
 fs/xfs/xfs_trans_priv.h                            |   15 +-
 fs/xfs/xfs_types.h                                 |    2 +
 27 files changed, 2382 insertions(+), 513 deletions(-)
 create mode 100644 Documentation/filesystems/xfs-delayed-logging-design.txt
 create mode 100644 fs/xfs/xfs_log_cil.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
