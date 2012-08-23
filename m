Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53cqG135202 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:38 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QeEszBssSG7eEgc9 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paf-0003H1-8B
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:21 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaV-0003eq-4O
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 044/102] xfs: share code for grant head waiting
Date: Thu, 23 Aug 2012 15:02:02 +1000
Message-Id: <1345698180-13612-45-git-send-email-david@fromorbit.com>
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

Upstream commit: 23ee3df349b8b8fd153bd02fccf08b31aec5bce3

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    2 --
 fs/xfs/xfs_log.c             |   63 ++++++++++++------------------------------
 2 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index cc7311c..0e6817c 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -841,8 +841,6 @@ DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index eb19abf..7955b1b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -221,12 +221,13 @@ xlog_writeq_wake(
 }
 
 STATIC int
-xlog_reserveq_wait(
+xlog_grant_head_wait(
 	struct log		*log,
+	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic,
 	int			need_bytes)
 {
-	list_add_tail(&tic->t_queue, &log->l_reserve_head.waiters);
+	list_add_tail(&tic->t_queue, &head->waiters);
 
 	do {
 		if (XLOG_FORCED_SHUTDOWN(log))
@@ -234,7 +235,7 @@ xlog_reserveq_wait(
 		xlog_grant_push_ail(log, need_bytes);
 
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&log->l_reserve_head.lock);
+		spin_unlock(&head->lock);
 
 		XFS_STATS_INC(xs_sleep_logspace);
 
@@ -242,44 +243,10 @@ xlog_reserveq_wait(
 		schedule();
 		trace_xfs_log_grant_wake(log, tic);
 
-		spin_lock(&log->l_reserve_head.lock);
+		spin_lock(&head->lock);
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto shutdown;
-	} while (xlog_space_left(log, &log->l_reserve_head.grant) < need_bytes);
-
-	list_del_init(&tic->t_queue);
-	return 0;
-shutdown:
-	list_del_init(&tic->t_queue);
-	return XFS_ERROR(EIO);
-}
-
-STATIC int
-xlog_writeq_wait(
-	struct log		*log,
-	struct xlog_ticket	*tic,
-	int			need_bytes)
-{
-	list_add_tail(&tic->t_queue, &log->l_write_head.waiters);
-
-	do {
-		if (XLOG_FORCED_SHUTDOWN(log))
-			goto shutdown;
-		xlog_grant_push_ail(log, need_bytes);
-
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&log->l_write_head.lock);
-
-		XFS_STATS_INC(xs_sleep_logspace);
-
-		trace_xfs_log_regrant_write_sleep(log, tic);
-		schedule();
-		trace_xfs_log_regrant_write_wake(log, tic);
-
-		spin_lock(&log->l_write_head.lock);
-		if (XLOG_FORCED_SHUTDOWN(log))
-			goto shutdown;
-	} while (xlog_space_left(log, &log->l_write_head.grant) < need_bytes);
+	} while (xlog_space_left(log, &head->grant) < need_bytes);
 
 	list_del_init(&tic->t_queue);
 	return 0;
@@ -2644,12 +2611,15 @@ xlog_grant_log_space(
 	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
 		spin_lock(&log->l_reserve_head.lock);
 		if (!xlog_reserveq_wake(log, &free_bytes) ||
-		    free_bytes < need_bytes)
-			error = xlog_reserveq_wait(log, tic, need_bytes);
+		    free_bytes < need_bytes) {
+			error = xlog_grant_head_wait(log, &log->l_reserve_head,
+						     tic, need_bytes);
+		}
 		spin_unlock(&log->l_reserve_head.lock);
 	} else if (free_bytes < need_bytes) {
 		spin_lock(&log->l_reserve_head.lock);
-		error = xlog_reserveq_wait(log, tic, need_bytes);
+		error = xlog_grant_head_wait(log, &log->l_reserve_head, tic,
+					     need_bytes);
 		spin_unlock(&log->l_reserve_head.lock);
 	}
 	if (error)
@@ -2697,12 +2667,15 @@ xlog_regrant_write_log_space(
 	if (!list_empty_careful(&log->l_write_head.waiters)) {
 		spin_lock(&log->l_write_head.lock);
 		if (!xlog_writeq_wake(log, &free_bytes) ||
-		    free_bytes < need_bytes)
-			error = xlog_writeq_wait(log, tic, need_bytes);
+		    free_bytes < need_bytes) {
+			error = xlog_grant_head_wait(log, &log->l_write_head,
+						     tic, need_bytes);
+		}
 		spin_unlock(&log->l_write_head.lock);
 	} else if (free_bytes < need_bytes) {
 		spin_lock(&log->l_write_head.lock);
-		error = xlog_writeq_wait(log, tic, need_bytes);
+		error = xlog_grant_head_wait(log, &log->l_write_head, tic,
+					     need_bytes);
 		spin_unlock(&log->l_write_head.lock);
 	}
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
