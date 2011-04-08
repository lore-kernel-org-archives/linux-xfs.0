Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3858Q7K154558 for <xfs@oss.sgi.com>; Fri, 8 Apr 2011 00:08:26 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C41C23BCF16
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2011 22:11:41 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ip7IB4eMXhq4l2ed for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2011 22:11:41 -0700 (PDT)
Date: Fri, 8 Apr 2011 15:11:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 2.6.39
Message-ID: <20110408051137.GW31057@dastard>
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
To: xfs@oss.sgi.com
Cc: aelder@sgi.com

Hi Alex,

The series of reviewed fixes for 2.6.39 can be found in the git tree
below. Please pull.

Cheers,

Dave.


The following changes since commit 89b3600ccfb01aed6873bc499442fc0bed00bbdd:

  xfs: fix unreferenced var error in xfs_buf.c (2011-03-30 23:34:20 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git xfs-for-2.6.39

Dave Chinner (9):
      xfs: fix extent format buffer allocation size
      xfs: introduce a xfssyncd workqueue
      xfs: convert ENOSPC inode flushing to use new syncd workqueue
      xfs: introduce background inode reclaim work
      xfs: convert the xfsaild threads to a workqueue
      xfs: clean up code layout in xfs_trans_ail.c
      xfs: push the AIL from memory reclaim and periodic sync
      xfs: catch bad block numbers freeing extents.
      xfs: convert log tail checking to a warning

 fs/xfs/linux-2.6/xfs_super.c |  129 +++++---------
 fs/xfs/linux-2.6/xfs_sync.c  |  228 ++++++++++++-----------
 fs/xfs/linux-2.6/xfs_sync.h  |    2 +
 fs/xfs/xfs_alloc.c           |   30 +++-
 fs/xfs/xfs_inode_item.c      |   67 ++++---
 fs/xfs/xfs_log.c             |   38 +++-
 fs/xfs/xfs_log_priv.h        |    1 +
 fs/xfs/xfs_mount.h           |    9 +-
 fs/xfs/xfs_trans_ail.c       |  421 +++++++++++++++++++++++-------------------
 fs/xfs/xfs_trans_priv.h      |   22 ++-
 10 files changed, 500 insertions(+), 447 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
