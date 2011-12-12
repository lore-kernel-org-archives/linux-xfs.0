Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCEEaY7101957 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 08:14:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6A8716EEFD0
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 06:14:35 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Xa8JoTMrTUAczO8z for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 06:14:35 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Ra6eJ-0007vl-5E
	for xfs@oss.sgi.com; Mon, 12 Dec 2011 14:14:35 +0000
Message-Id: <20111212141435.111380168@bombadil.infradead.org>
Date: Mon, 12 Dec 2011 09:13:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 09/12] xfs: share code for grant head waiting
References: <20111212141346.986825692@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-factor-xlog_grant_head_wait
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c   |   63 +++++++++++++++--------------------------------------
 fs/xfs/xfs_trace.h |    2 -
 2 files changed, 18 insertions(+), 47 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 21:28:57.128011556 +0100
+++ xfs/fs/xfs/xfs_log.c	2011-12-11 21:31:10.580621915 +0100
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
@@ -2596,12 +2563,15 @@ xlog_grant_log_space(
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
@@ -2649,12 +2619,15 @@ xlog_regrant_write_log_space(
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
 
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2011-12-11 21:28:55.964684526 +0100
+++ xfs/fs/xfs/xfs_trace.h	2011-12-11 21:31:41.697120010 +0100
@@ -838,8 +838,6 @@ DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
