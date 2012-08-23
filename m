Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53dwM135205 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:39 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jFdNeAu2JhEOGEwu for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:24 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paf-0003H3-8s
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:21 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaV-0003f0-6G
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 046/102] xfs: share code for grant head availability checks
Date: Thu, 23 Aug 2012 15:02:04 +1000
Message-Id: <1345698180-13612-47-git-send-email-david@fromorbit.com>
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

Upstream commit: 42ceedb3caffe67c4ec0dfbb78ce410832d429b9

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log.c |  133 ++++++++++++++++++++++++------------------------------
 1 file changed, 60 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ad16114..795c4c2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
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
@@ -2559,59 +2613,18 @@ restart:
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
 
@@ -2624,16 +2637,13 @@ xlog_grant_log_space(
 
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
@@ -2642,33 +2652,10 @@ xlog_regrant_write_log_space(
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
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
