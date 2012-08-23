Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53cBi135196 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:38 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	w6NFJukC3rlweuAa for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaV-0003Gv-7r
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaV-0003eu-5J
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 045/102] xfs: share code for grant head wakeups
Date: Thu, 23 Aug 2012 15:02:03 +1000
Message-Id: <1345698180-13612-46-git-send-email-david@fromorbit.com>
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

Upstream commit: e179840d74606ab1935c83fe5ad9d93c95ddc956

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    1 -
 fs/xfs/xfs_log.c             |   50 +++++++++++++++++-------------------------
 2 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 0e6817c..3617ba1 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -841,7 +841,6 @@ DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7955b1b..ad16114 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
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
 
@@ -804,7 +794,7 @@ xfs_log_space_wake(
 
 		spin_lock(&log->l_write_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
-		xlog_writeq_wake(log, &free_bytes);
+		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
 		spin_unlock(&log->l_write_head.lock);
 	}
 
@@ -813,7 +803,7 @@ xfs_log_space_wake(
 
 		spin_lock(&log->l_reserve_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
-		xlog_reserveq_wake(log, &free_bytes);
+		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
 		spin_unlock(&log->l_reserve_head.lock);
 	}
 }
@@ -2610,7 +2600,7 @@ xlog_grant_log_space(
 	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
 	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
 		spin_lock(&log->l_reserve_head.lock);
-		if (!xlog_reserveq_wake(log, &free_bytes) ||
+		if (!xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes) ||
 		    free_bytes < need_bytes) {
 			error = xlog_grant_head_wait(log, &log->l_reserve_head,
 						     tic, need_bytes);
@@ -2666,7 +2656,7 @@ xlog_regrant_write_log_space(
 	free_bytes = xlog_space_left(log, &log->l_write_head.grant);
 	if (!list_empty_careful(&log->l_write_head.waiters)) {
 		spin_lock(&log->l_write_head.lock);
-		if (!xlog_writeq_wake(log, &free_bytes) ||
+		if (!xlog_grant_head_wake(log, &log->l_write_head, &free_bytes) ||
 		    free_bytes < need_bytes) {
 			error = xlog_grant_head_wait(log, &log->l_write_head,
 						     tic, need_bytes);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
