Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N548qT135553 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:08 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	38rMSZzMi8d1HpGz for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:54 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pb9-0003IL-SS
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Paz-0003gS-Ot
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 063/102] xfs: Account log unmount transaction correctly
Date: Thu, 23 Aug 2012 15:02:21 +1000
Message-Id: <1345698180-13612-64-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

Upstream commit: 3948659e30808fbaa7673bbe89de2ae9769e20a7

There have been a few reports of this warning appearing recently:

XFS (dm-4): xlog_space_left: head behind tail
 tail_cycle = 129, tail_bytes = 20163072
 GH   cycle = 129, GH   bytes = 20162880

The common cause appears to be lots of freeze and unfreeze cycles,
and the output from the warnings indicates that we are leaking
around 8 bytes of log space per freeze/unfreeze cycle.

When we freeze the filesystem, we write an unmount record and that
uses xlog_write directly - a special type of transaction,
effectively. What it doesn't do, however, is correctly account for
the log space it uses. The unmount record writes an 8 byte structure
with a special magic number into the log, and the space this
consumes is not accounted for in the log ticket tracking the
operation. Hence we leak 8 bytes every unmount record that is
written.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d92b442..653cba8 100644
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
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
