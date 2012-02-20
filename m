Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2nucf042725 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:49:56 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NNjSQn2OR9eKPqvN (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:31:54 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzJ2f-0005hX-T1
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:31:53 +0000
Message-Id: <20120220023153.850222485@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:31:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/12] xfs: share code for grant head wakeups
References: <20120220023119.435889631@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-factor-xlog_grant_head_wake
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

Reviewed-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c   |   50 ++++++++++++++++++++------------------------------
 fs/xfs/xfs_trace.h |    1 -
 2 files changed, 20 insertions(+), 31 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2012-02-19 13:06:35.086627572 -0800
+++ xfs/fs/xfs/xfs_log.c	2012-02-19 13:07:14.849960798 -0800
@@ -171,49 +171,39 @@ xlog_grant_head_wake_all(
 	spin_unlock(&head->lock);
 }
 
-STATIC bool
-xlog_reserveq_wake(
+static inline int
+xlog_ticket_reservation(
 	struct log		*log,
-	int			*free_bytes)
+	struct xlog_grant_head	*head,
+	struct xlog_ticket	*tic)
 {
-	struct xlog_ticket	*tic;
-	int			need_bytes;
-
-	list_for_each_entry(tic, &log->l_reserve_head.waiters, t_queue) {
+	if (head == &log->l_write_head) {
+		ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
+		return tic->t_unit_res;
+	} else {
 		if (tic->t_flags & XLOG_TIC_PERM_RESERV)
-			need_bytes = tic->t_unit_res * tic->t_cnt;
+			return tic->t_unit_res * tic->t_cnt;
 		else
-			need_bytes = tic->t_unit_res;
-
-		if (*free_bytes < need_bytes)
-			return false;
-		*free_bytes -= need_bytes;
-
-		trace_xfs_log_grant_wake_up(log, tic);
-		wake_up_process(tic->t_task);
+			return tic->t_unit_res;
 	}
-
-	return true;
 }
 
 STATIC bool
-xlog_writeq_wake(
+xlog_grant_head_wake(
 	struct log		*log,
+	struct xlog_grant_head	*head,
 	int			*free_bytes)
 {
 	struct xlog_ticket	*tic;
 	int			need_bytes;
 
-	list_for_each_entry(tic, &log->l_write_head.waiters, t_queue) {
-		ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
-
-		need_bytes = tic->t_unit_res;
-
+	list_for_each_entry(tic, &head->waiters, t_queue) {
+		need_bytes = xlog_ticket_reservation(log, head, tic);
 		if (*free_bytes < need_bytes)
 			return false;
-		*free_bytes -= need_bytes;
 
-		trace_xfs_log_regrant_write_wake_up(log, tic);
+		*free_bytes -= need_bytes;
+		trace_xfs_log_grant_wake_up(log, tic);
 		wake_up_process(tic->t_task);
 	}
 
@@ -772,7 +762,7 @@ xfs_log_space_wake(
 
 		spin_lock(&log->l_write_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
-		xlog_writeq_wake(log, &free_bytes);
+		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
 		spin_unlock(&log->l_write_head.lock);
 	}
 
@@ -781,7 +771,7 @@ xfs_log_space_wake(
 
 		spin_lock(&log->l_reserve_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
-		xlog_reserveq_wake(log, &free_bytes);
+		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
 		spin_unlock(&log->l_reserve_head.lock);
 	}
 }
@@ -2562,7 +2552,7 @@ xlog_grant_log_space(
 	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
 	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
 		spin_lock(&log->l_reserve_head.lock);
-		if (!xlog_reserveq_wake(log, &free_bytes) ||
+		if (!xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes) ||
 		    free_bytes < need_bytes) {
 			error = xlog_grant_head_wait(log, &log->l_reserve_head,
 						     tic, need_bytes);
@@ -2618,7 +2608,7 @@ xlog_regrant_write_log_space(
 	free_bytes = xlog_space_left(log, &log->l_write_head.grant);
 	if (!list_empty_careful(&log->l_write_head.waiters)) {
 		spin_lock(&log->l_write_head.lock);
-		if (!xlog_writeq_wake(log, &free_bytes) ||
+		if (!xlog_grant_head_wake(log, &log->l_write_head, &free_bytes) ||
 		    free_bytes < need_bytes) {
 			error = xlog_grant_head_wait(log, &log->l_write_head,
 						     tic, need_bytes);
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2012-02-19 13:06:35.089960905 -0800
+++ xfs/fs/xfs/xfs_trace.h	2012-02-19 13:07:14.853294131 -0800
@@ -847,7 +847,6 @@ DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
