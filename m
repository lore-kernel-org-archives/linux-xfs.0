Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2lRgi042477 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:47:27 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	LFZOwdPkpgAV7FCd (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:31:54 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzJ2g-0005i3-3f
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:31:54 +0000
Message-Id: <20120220023154.083251909@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:31:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/12] xfs: share code for grant head availability checks
References: <20120220023119.435889631@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-factor-xlog_grant_head_check
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

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c |  133 ++++++++++++++++++++++++-------------------------------
 1 file changed, 60 insertions(+), 73 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2012-02-19 13:07:14.849960798 -0800
+++ xfs/fs/xfs/xfs_log.c	2012-02-19 13:11:21.859960129 -0800
@@ -245,6 +245,60 @@ shutdown:
 	return XFS_ERROR(EIO);
 }
 
+/*
+ * Atomically get the log space required for a log ticket.
+ *
+ * Once a ticket gets put onto head->waiters, it will only return after the
+ * needed reservation is satisfied.
+ *
+ * This function is structured so that it has a lock free fast path. This is
+ * necessary because every new transaction reservation will come through this
+ * path. Hence any lock will be globally hot if we take it unconditionally on
+ * every pass.
+ *
+ * As tickets are only ever moved on and off head->waiters under head->lock, we
+ * only need to take that lock if we are going to add the ticket to the queue
+ * and sleep. We can avoid taking the lock if the ticket was never added to
+ * head->waiters because the t_queue list head will be empty and we hold the
+ * only reference to it so it can safely be checked unlocked.
+ */
+STATIC int
+xlog_grant_head_check(
+	struct log		*log,
+	struct xlog_grant_head	*head,
+	struct xlog_ticket	*tic,
+	int			*need_bytes)
+{
+	int			free_bytes;
+	int			error = 0;
+
+	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
+
+	/*
+	 * If there are other waiters on the queue then give them a chance at
+	 * logspace before us.  Wake up the first waiters, if we do not wake
+	 * up all the waiters then go to sleep waiting for more free space,
+	 * otherwise try to get some space for this transaction.
+	 */
+	*need_bytes = xlog_ticket_reservation(log, head, tic);
+	free_bytes = xlog_space_left(log, &head->grant);
+	if (!list_empty_careful(&head->waiters)) {
+		spin_lock(&head->lock);
+		if (!xlog_grant_head_wake(log, head, &free_bytes) ||
+		    free_bytes < *need_bytes) {
+			error = xlog_grant_head_wait(log, head, tic,
+						     *need_bytes);
+		}
+		spin_unlock(&head->lock);
+	} else if (free_bytes < *need_bytes) {
+		spin_lock(&head->lock);
+		error = xlog_grant_head_wait(log, head, tic, *need_bytes);
+		spin_unlock(&head->lock);
+	}
+
+	return error;
+}
+
 static void
 xlog_tic_reset_res(xlog_ticket_t *tic)
 {
@@ -2511,59 +2565,18 @@ restart:
 	return 0;
 }	/* xlog_state_get_iclog_space */
 
-/*
- * Atomically get the log space required for a log ticket.
- *
- * Once a ticket gets put onto the reserveq, it will only return after the
- * needed reservation is satisfied.
- *
- * This function is structured so that it has a lock free fast path. This is
- * necessary because every new transaction reservation will come through this
- * path. Hence any lock will be globally hot if we take it unconditionally on
- * every pass.
- *
- * As tickets are only ever moved on and off the l_reserve.waiters under the
- * l_reserve.lock, we only need to take that lock if we are going to add
- * the ticket to the queue and sleep. We can avoid taking the lock if the ticket
- * was never added to the reserveq because the t_queue list head will be empty
- * and we hold the only reference to it so it can safely be checked unlocked.
- */
 STATIC int
 xlog_grant_log_space(
 	struct log		*log,
 	struct xlog_ticket	*tic)
 {
-	int			free_bytes, need_bytes;
+	int			need_bytes;
 	int			error = 0;
 
-	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
-
 	trace_xfs_log_grant_enter(log, tic);
 
-	/*
-	 * If there are other waiters on the queue then give them a chance at
-	 * logspace before us.  Wake up the first waiters, if we do not wake
-	 * up all the waiters then go to sleep waiting for more free space,
-	 * otherwise try to get some space for this transaction.
-	 */
-	need_bytes = tic->t_unit_res;
-	if (tic->t_flags & XFS_LOG_PERM_RESERV)
-		need_bytes *= tic->t_ocnt;
-	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
-	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
-		spin_lock(&log->l_reserve_head.lock);
-		if (!xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes) ||
-		    free_bytes < need_bytes) {
-			error = xlog_grant_head_wait(log, &log->l_reserve_head,
-						     tic, need_bytes);
-		}
-		spin_unlock(&log->l_reserve_head.lock);
-	} else if (free_bytes < need_bytes) {
-		spin_lock(&log->l_reserve_head.lock);
-		error = xlog_grant_head_wait(log, &log->l_reserve_head, tic,
-					     need_bytes);
-		spin_unlock(&log->l_reserve_head.lock);
-	}
+	error = xlog_grant_head_check(log, &log->l_reserve_head, tic,
+				      &need_bytes);
 	if (error)
 		return error;
 
@@ -2576,16 +2589,13 @@ xlog_grant_log_space(
 
 /*
  * Replenish the byte reservation required by moving the grant write head.
- *
- * Similar to xlog_grant_log_space, the function is structured to have a lock
- * free fast path.
  */
 STATIC int
 xlog_regrant_write_log_space(
 	struct log		*log,
 	struct xlog_ticket	*tic)
 {
-	int			free_bytes, need_bytes;
+	int			need_bytes;
 	int			error = 0;
 
 	tic->t_curr_res = tic->t_unit_res;
@@ -2594,33 +2604,10 @@ xlog_regrant_write_log_space(
 	if (tic->t_cnt > 0)
 		return 0;
 
-	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
-
 	trace_xfs_log_regrant_write_enter(log, tic);
 
-	/*
-	 * If there are other waiters on the queue then give them a chance at
-	 * logspace before us.  Wake up the first waiters, if we do not wake
-	 * up all the waiters then go to sleep waiting for more free space,
-	 * otherwise try to get some space for this transaction.
-	 */
-	need_bytes = tic->t_unit_res;
-	free_bytes = xlog_space_left(log, &log->l_write_head.grant);
-	if (!list_empty_careful(&log->l_write_head.waiters)) {
-		spin_lock(&log->l_write_head.lock);
-		if (!xlog_grant_head_wake(log, &log->l_write_head, &free_bytes) ||
-		    free_bytes < need_bytes) {
-			error = xlog_grant_head_wait(log, &log->l_write_head,
-						     tic, need_bytes);
-		}
-		spin_unlock(&log->l_write_head.lock);
-	} else if (free_bytes < need_bytes) {
-		spin_lock(&log->l_write_head.lock);
-		error = xlog_grant_head_wait(log, &log->l_write_head, tic,
-					     need_bytes);
-		spin_unlock(&log->l_write_head.lock);
-	}
-
+	error = xlog_grant_head_check(log, &log->l_write_head, tic,
+				      &need_bytes);
 	if (error)
 		return error;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
