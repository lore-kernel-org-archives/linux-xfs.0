Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2M5Flkc180516 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 00:15:47 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	91CbbUpg8vhBeuBB for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 22:15:45 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SAaNE-00035z-1W
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:44 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SAaMw-0000Wd-Ij
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: Account log unmount transaction correctly
Date: Thu, 22 Mar 2012 16:15:11 +1100
Message-Id: <1332393313-1955-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1332393313-1955-1-git-send-email-david@fromorbit.com>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

There have been a few reports of this warning appearing recently:

XFS (dm-4): xlog_space_left: head behind tail
 tail_cycle = 129, tail_bytes = 20163072
 GH   cycle = 129, GH   bytes = 20162880

The common cause appears to be lots of freeze and unfreeze cycles,
and the output from the warnings indicates that we are leaking
around 8 bytes of log space per freeze/unfreeze cycle.

When we freeze the filesystem, we write an unmount record and that
uses xlog_write directly - a special type of transaction,
effectively. What it doesn't do, however, is correctly acocunt for
the log space it uses. The unmount record writes an 8 byte structure
with a special magic number into the log, and the space this
consumes is not accounted for in the log ticket tracking the
operation. Hence we leak 8 bytes every unmount record that is
written.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 98a9cb5..6db1fef 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -726,8 +726,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 				.lv_iovecp = &reg,
 			};
 
-			/* remove inited flag */
+			/* remove inited flag, and account for space used */
 			tic->t_flags = 0;
+			tic->t_curr_res -= sizeof(magic);
 			error = xlog_write(log, &vec, tic, &lsn,
 					   NULL, XLOG_UNMOUNT_TRANS);
 			/*
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
