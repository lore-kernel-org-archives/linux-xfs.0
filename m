Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8S2cC3Y216217 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 21:38:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22F80E87B0F
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 19:52:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	BooVYpFdEiC2zPls for <xfs@oss.sgi.com>;
	Mon, 27 Sep 2010 19:52:07 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	29117220-1927428
	for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 12:09:07 +0930 (CST)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1P0Q5y-0004fs-8w
	for xfs@oss.sgi.com; Tue, 28 Sep 2010 12:39:06 +1000
Date: Tue, 28 Sep 2010 12:39:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: metadata scalability
Message-ID: <20100928023906.GE5665@dastard>
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

Hi Alex,

Can you please pull the following branch into the main XFS tree?
These are all patches for the .37 merge, except for the first one
(xfs: force background CIL push under sustained load) which needs to
be sent to Linus for .36.

Thanks,

Dave.

The following changes since commit e89318c670af3959db3aa483da509565f5a2536c:

  xfs: eliminate some newly-reported gcc warnings (2010-09-16 12:56:42 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git metadata-scale

Dave Chinner (18):
      xfs: force background CIL push under sustained load
      xfs: reduce the number of CIL lock round trips during commit
      xfs: remove debug assert for per-ag reference counting
      xfs: lockless per-ag lookups
      xfs: don't use vfs writeback for pure metadata modifications
      xfs: rename xfs_buf_get_nodaddr to be more appropriate
      xfs: introduced uncached buffer read primitve
      xfs: store xfs_mount in the buftarg instead of in the xfs_buf
      xfs: kill XBF_FS_MANAGED buffers
      xfs: use unhashed buffers for size checks
      xfs: remove buftarg hash for external devices
      xfs: split inode AG walking into separate code for reclaim
      xfs: split out inode walk inode grabbing
      xfs: implement batched inode lookups for AG walking
      xfs: batch inode reclaim lookup
      xfs: serialise inode reclaim within an AG
      xfs: convert buffer cache hash to rbtree
      xfs: pack xfs_buf structure more tightly

 fs/xfs/linux-2.6/xfs_buf.c     |  200 +++++++++++---------
 fs/xfs/linux-2.6/xfs_buf.h     |   50 +++---
 fs/xfs/linux-2.6/xfs_ioctl.c   |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c    |   35 ----
 fs/xfs/linux-2.6/xfs_super.c   |   15 +-
 fs/xfs/linux-2.6/xfs_sync.c    |  413 +++++++++++++++++++++++-----------------
 fs/xfs/linux-2.6/xfs_sync.h    |    4 +-
 fs/xfs/linux-2.6/xfs_trace.h   |    4 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   14 +--
 fs/xfs/xfs_ag.h                |    9 +
 fs/xfs/xfs_attr.c              |   31 +--
 fs/xfs/xfs_buf_item.c          |    3 +-
 fs/xfs/xfs_fsops.c             |   11 +-
 fs/xfs/xfs_inode.h             |    1 -
 fs/xfs/xfs_inode_item.c        |    9 -
 fs/xfs/xfs_log.c               |    3 +-
 fs/xfs/xfs_log_cil.c           |  244 +++++++++++++-----------
 fs/xfs/xfs_log_priv.h          |   37 ++--
 fs/xfs/xfs_log_recover.c       |   19 +-
 fs/xfs/xfs_mount.c             |  152 ++++++++-------
 fs/xfs/xfs_mount.h             |    2 +
 fs/xfs/xfs_rename.c            |   12 +-
 fs/xfs/xfs_rtalloc.c           |   29 ++--
 fs/xfs/xfs_trans.h             |    1 +
 fs/xfs/xfs_trans_inode.c       |   30 +++
 fs/xfs/xfs_utils.c             |    4 +-
 fs/xfs/xfs_vnodeops.c          |   23 ++-
 27 files changed, 732 insertions(+), 625 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
