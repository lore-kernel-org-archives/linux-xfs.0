Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3K7QD5J014497 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 02:26:14 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA416148C360
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 00:28:10 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	IF0RdHuEk5ryor3G for <xfs@oss.sgi.com>;
	Tue, 20 Apr 2010 00:28:10 -0700 (PDT)
Date: Tue, 20 Apr 2010 17:28:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] reviewed patches for -dev tree
Message-ID: <20100420072807.GJ15130@dastard>
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

The following patches have been reviewed and are ready for pulling
into the xfs-dev tree.

We should also consider pushing the swap extents fix into the next
-rc release because it is a corruption fix.

Cheers,

Dave.

The following changes since commit f0ef9eb19288ba3ed213348ea1f581d7b83b451e:
  Andrea Gelmini (1):
        xfs: xfs_trace.c: duplicated include

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git for-dev

Alex Elder (2):
      xfs: record log sector size rather than log2(that)
      xfs: kill off l_sectbb_mask

Christoph Hellwig (5):
      xfs: wait for direct I/O to complete in fsync and write_inode
      xfs: access quotainfo structure directly
      xfs: remove a few macro indirections in the quota code
      xfs: removed unused XFS_QMOPT_ flags
      xfs: remove dead XFS_LOUD_RECOVERY code

Dave Chinner (1):
      xfs: more swap extent fixes for dynamic fork offsets

 fs/xfs/linux-2.6/xfs_file.c    |    2 +
 fs/xfs/linux-2.6/xfs_super.c   |    1 +
 fs/xfs/quota/xfs_dquot.c       |   73 ++++++++++--------
 fs/xfs/quota/xfs_dquot_item.c  |    2 +-
 fs/xfs/quota/xfs_qm.c          |  160 ++++++++++++++++++++--------------------
 fs/xfs/quota/xfs_qm_syscalls.c |  116 ++++++++++++++---------------
 fs/xfs/quota/xfs_quota_priv.h  |   27 -------
 fs/xfs/quota/xfs_trans_dquot.c |   29 ++++----
 fs/xfs/xfs_dfrag.c             |   22 ++++--
 fs/xfs/xfs_log.c               |   32 ++++----
 fs/xfs/xfs_log_priv.h          |    4 +-
 fs/xfs/xfs_log_recover.c       |  106 +++++---------------------
 fs/xfs/xfs_mount.c             |    7 --
 fs/xfs/xfs_quota.h             |    3 -
 14 files changed, 250 insertions(+), 334 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
