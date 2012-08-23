Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53bCH135184 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:37 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0EFqFyEbmaHr18ll for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:22 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paa-0003Gr-4o
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:16 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaU-0003ea-UP
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 042/102] xfs: add xlog_grant_head_init
Date: Thu, 23 Aug 2012 15:02:00 +1000
Message-Id: <1345698180-13612-43-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: c303c5b8c3b8eace41c4fba26205b50c0f8e4ca0

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5c5aa54..6ef0264 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -150,6 +150,15 @@ xlog_grant_add_space(
 	} while (head_val != old);
 }
 
+STATIC void
+xlog_grant_head_init(
+	struct xlog_grant_head	*head)
+{
+	xlog_assign_grant_head(&head->grant, 1, 0);
+	INIT_LIST_HEAD(&head->waiters);
+	spin_lock_init(&head->lock);
+}
+
 STATIC bool
 xlog_reserveq_wake(
 	struct log		*log,
@@ -1108,12 +1117,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_assign_atomic_lsn(&log->l_tail_lsn, 1, 0);
 	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
-	xlog_assign_grant_head(&log->l_reserve_head.grant, 1, 0);
-	xlog_assign_grant_head(&log->l_write_head.grant, 1, 0);
-	INIT_LIST_HEAD(&log->l_reserve_head.waiters);
-	INIT_LIST_HEAD(&log->l_write_head.waiters);
-	spin_lock_init(&log->l_reserve_head.lock);
-	spin_lock_init(&log->l_write_head.lock);
+
+	xlog_grant_head_init(&log->l_reserve_head);
+	xlog_grant_head_init(&log->l_write_head);
 
 	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
