Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2OLskvN036493 for <xfs@oss.sgi.com>; Wed, 24 Mar 2010 16:54:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CA891461726
	for <xfs@oss.sgi.com>; Wed, 24 Mar 2010 14:56:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	syg3jeYFIlzJNcd7 for <xfs@oss.sgi.com>;
	Wed, 24 Mar 2010 14:56:26 -0700 (PDT)
Date: Thu, 25 Mar 2010 08:56:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: transaction and log cleanups and misc bug fixes
Message-ID: <20100324215624.GL3335@dastard>
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

Can you please pull from the below tree. It contains the reviewed
patches form the trans-cleanup branch, as well as Christoph's rework
of the log vector patches. Also included are a couple of patches
picked up off various lists as they went by.

The following changes since commit e8c3753ce4cd6a805ebcfdb3aa6d30e6f4b8b3e0:
  Dave Chinner (1):
        xfs: don't warn about page discards on shutdown

are available in the git repository at:

  git://git.kernel.org//pub/scm/linux/kernel/git/dgc/xfs.git for-dev

Christoph Hellwig (3):
      xfs: clean up xfs_trans_commit logic even more
      xfs: reindent xlog_write
      xfs: clean up xlog_write_adv_cnt

Dave Chinner (10):
      xfs: factor log item initialisation
      xfs: Add inode pin counts to traces
      xfs: remove stale parameter from ->iop_unpin method
      xfs: fix reservation release commit flag in xfs_bmap_add_attrfork()
      xfs: split out iclog writing from xfs_trans_commit()
      xfs: update and factor xfs_trans_committed()
      xfs: Clean up xfs_trans_committed code after factoring
      xfs: log ticket reservation underestimates the number of iclogs
      xfs: factor xlog_write
      xfs: introduce new internal log vector structure

Jan Engelhardt (1):
      xfs: add blockdev name to kthreads

Zhitong Wang (1):
      xfs: Fix integer overflow in fs/xfs/linux-2.6/xfs_ioctl*.c

 fs/xfs/linux-2.6/xfs_buf.c     |   10 +-
 fs/xfs/linux-2.6/xfs_buf.h     |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c   |    4 +
 fs/xfs/linux-2.6/xfs_ioctl32.c |    4 +
 fs/xfs/linux-2.6/xfs_super.c   |    9 +-
 fs/xfs/linux-2.6/xfs_sync.c    |    2 +-
 fs/xfs/linux-2.6/xfs_trace.h   |    9 +-
 fs/xfs/quota/xfs_dquot_item.c  |   28 +-
 fs/xfs/xfs_bmap.c              |    2 +-
 fs/xfs/xfs_buf_item.c          |   55 ++--
 fs/xfs/xfs_extfree_item.c      |   18 +-
 fs/xfs/xfs_inode.c             |    2 +
 fs/xfs/xfs_inode_item.c        |   21 +-
 fs/xfs/xfs_log.c               |  668 ++++++++++++++++++++++-------------
 fs/xfs/xfs_log.h               |   13 +
 fs/xfs/xfs_log_priv.h          |    8 +
 fs/xfs/xfs_trans.c             |  760 +++++++++++++++++++---------------------
 fs/xfs/xfs_trans.h             |    5 +-
 fs/xfs/xfs_trans_buf.c         |    3 +-
 19 files changed, 888 insertions(+), 735 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
