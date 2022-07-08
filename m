Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE7FCCA479
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 01:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiGHB4G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 21:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiGHB4F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 21:56:05 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADDAC735B4
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 18:56:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9F81510E7C3F
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 11:56:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-00FqlY-IM
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 11:56:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-004lDv-HR
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 11:56:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: pass the full grant head to accounting functions
Date:   Fri,  8 Jul 2022 11:55:56 +1000
Message-Id: <20220708015558.1134330-7-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708015558.1134330-1-david@fromorbit.com>
References: <20220708015558.1134330-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c78eb2
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=K1RfENA8UGTXfJ9mUEgA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because we are going to need them soon. API change only, no logic
changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 157 +++++++++++++++++++++---------------------
 fs/xfs/xfs_log_priv.h |   2 -
 2 files changed, 77 insertions(+), 82 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 925f32fad5e1..691d9ea6f4da 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -136,10 +136,10 @@ xlog_prepare_iovec(
 static void
 xlog_grant_sub_space(
 	struct xlog		*log,
-	atomic64_t		*head,
+	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(head);
+	int64_t	head_val = atomic64_read(&head->grant);
 	int64_t new, old;
 
 	do {
@@ -155,17 +155,17 @@ xlog_grant_sub_space(
 
 		old = head_val;
 		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(head, old, new);
+		head_val = atomic64_cmpxchg(&head->grant, old, new);
 	} while (head_val != old);
 }
 
 static void
 xlog_grant_add_space(
 	struct xlog		*log,
-	atomic64_t		*head,
+	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(head);
+	int64_t	head_val = atomic64_read(&head->grant);
 	int64_t new, old;
 
 	do {
@@ -184,7 +184,7 @@ xlog_grant_add_space(
 
 		old = head_val;
 		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(head, old, new);
+		head_val = atomic64_cmpxchg(&head->grant, old, new);
 	} while (head_val != old);
 }
 
@@ -197,6 +197,63 @@ xlog_grant_head_init(
 	spin_lock_init(&head->lock);
 }
 
+/*
+ * Return the space in the log between the tail and the head.  The head
+ * is passed in the cycle/bytes formal parms.  In the special case where
+ * the reserve head has wrapped passed the tail, this calculation is no
+ * longer valid.  In this case, just return 0 which means there is no space
+ * in the log.  This works for all places where this function is called
+ * with the reserve head.  Of course, if the write head were to ever
+ * wrap the tail, we should blow up.  Rather than catch this case here,
+ * we depend on other ASSERTions in other parts of the code.   XXXmiken
+ *
+ * If reservation head is behind the tail, we have a problem. Warn about it,
+ * but then treat it as if the log is empty.
+ *
+ * If the log is shut down, the head and tail may be invalid or out of whack, so
+ * shortcut invalidity asserts in this case so that we don't trigger them
+ * falsely.
+ */
+static int
+xlog_grant_space_left(
+	struct xlog		*log,
+	struct xlog_grant_head	*head)
+{
+	int			tail_bytes;
+	int			tail_cycle;
+	int			head_cycle;
+	int			head_bytes;
+
+	xlog_crack_grant_head(&head->grant, &head_cycle, &head_bytes);
+	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
+	tail_bytes = BBTOB(tail_bytes);
+	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
+		return log->l_logsize - (head_bytes - tail_bytes);
+	if (tail_cycle + 1 < head_cycle)
+		return 0;
+
+	/* Ignore potential inconsistency when shutdown. */
+	if (xlog_is_shutdown(log))
+		return log->l_logsize;
+
+	if (tail_cycle < head_cycle) {
+		ASSERT(tail_cycle == (head_cycle - 1));
+		return tail_bytes - head_bytes;
+	}
+
+	/*
+	 * The reservation head is behind the tail. In this case we just want to
+	 * return the size of the log as the amount of space left.
+	 */
+	xfs_alert(log->l_mp, "xlog_grant_space_left: head behind tail");
+	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
+		  tail_cycle, tail_bytes);
+	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
+		  head_cycle, head_bytes);
+	ASSERT(0);
+	return log->l_logsize;
+}
+
 STATIC void
 xlog_grant_head_wake_all(
 	struct xlog_grant_head	*head)
@@ -276,7 +333,7 @@ xlog_grant_head_wait(
 		spin_lock(&head->lock);
 		if (xlog_is_shutdown(log))
 			goto shutdown;
-	} while (xlog_space_left(log, &head->grant) < need_bytes);
+	} while (xlog_grant_space_left(log, head) < need_bytes);
 
 	list_del_init(&tic->t_queue);
 	return 0;
@@ -321,7 +378,7 @@ xlog_grant_head_check(
 	 * otherwise try to get some space for this transaction.
 	 */
 	*need_bytes = xlog_ticket_reservation(log, head, tic);
-	free_bytes = xlog_space_left(log, &head->grant);
+	free_bytes = xlog_grant_space_left(log, head);
 	if (!list_empty_careful(&head->waiters)) {
 		spin_lock(&head->lock);
 		if (!xlog_grant_head_wake(log, head, &free_bytes) ||
@@ -395,7 +452,7 @@ xfs_log_regrant(
 	if (error)
 		goto out_error;
 
-	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_regrant_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -446,8 +503,8 @@ xfs_log_reserve(
 	if (error)
 		goto out_error;
 
-	xlog_grant_add_space(log, &log->l_reserve_head.grant, need_bytes);
-	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	xlog_grant_add_space(log, &log->l_reserve_head, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_reserve_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -1113,7 +1170,7 @@ xfs_log_space_wake(
 		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_write_head.lock);
-		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
+		free_bytes = xlog_grant_space_left(log, &log->l_write_head);
 		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
 		spin_unlock(&log->l_write_head.lock);
 	}
@@ -1122,7 +1179,7 @@ xfs_log_space_wake(
 		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_reserve_head.lock);
-		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
+		free_bytes = xlog_grant_space_left(log, &log->l_reserve_head);
 		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
 		spin_unlock(&log->l_reserve_head.lock);
 	}
@@ -1236,64 +1293,6 @@ xfs_log_cover(
 	return error;
 }
 
-/*
- * Return the space in the log between the tail and the head.  The head
- * is passed in the cycle/bytes formal parms.  In the special case where
- * the reserve head has wrapped passed the tail, this calculation is no
- * longer valid.  In this case, just return 0 which means there is no space
- * in the log.  This works for all places where this function is called
- * with the reserve head.  Of course, if the write head were to ever
- * wrap the tail, we should blow up.  Rather than catch this case here,
- * we depend on other ASSERTions in other parts of the code.   XXXmiken
- *
- * If reservation head is behind the tail, we have a problem. Warn about it,
- * but then treat it as if the log is empty.
- *
- * If the log is shut down, the head and tail may be invalid or out of whack, so
- * shortcut invalidity asserts in this case so that we don't trigger them
- * falsely.
- */
-int
-xlog_space_left(
-	struct xlog	*log,
-	atomic64_t	*head)
-{
-	int		tail_bytes;
-	int		tail_cycle;
-	int		head_cycle;
-	int		head_bytes;
-
-	xlog_crack_grant_head(head, &head_cycle, &head_bytes);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
-	tail_bytes = BBTOB(tail_bytes);
-	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
-		return log->l_logsize - (head_bytes - tail_bytes);
-	if (tail_cycle + 1 < head_cycle)
-		return 0;
-
-	/* Ignore potential inconsistency when shutdown. */
-	if (xlog_is_shutdown(log))
-		return log->l_logsize;
-
-	if (tail_cycle < head_cycle) {
-		ASSERT(tail_cycle == (head_cycle - 1));
-		return tail_bytes - head_bytes;
-	}
-
-	/*
-	 * The reservation head is behind the tail. In this case we just want to
-	 * return the size of the log as the amount of space left.
-	 */
-	xfs_alert(log->l_mp, "xlog_space_left: head behind tail");
-	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
-		  tail_cycle, tail_bytes);
-	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
-		  head_cycle, head_bytes);
-	ASSERT(0);
-	return log->l_logsize;
-}
-
-
 static void
 xlog_ioend_work(
 	struct work_struct	*work)
@@ -1882,8 +1881,8 @@ xlog_sync(
 	if (ticket) {
 		ticket->t_curr_res -= roundoff;
 	} else {
-		xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
-		xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
+		xlog_grant_add_space(log, &log->l_reserve_head, roundoff);
+		xlog_grant_add_space(log, &log->l_write_head, roundoff);
 	}
 
 	/* put cycle number in every block */
@@ -2814,17 +2813,15 @@ xfs_log_ticket_regrant(
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	xlog_grant_sub_space(log, &log->l_reserve_head.grant,
-					ticket->t_curr_res);
-	xlog_grant_sub_space(log, &log->l_write_head.grant,
-					ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_reserve_head, ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_write_head, ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 
 	trace_xfs_log_ticket_regrant_sub(log, ticket);
 
 	/* just return if we still have some of the pre-reserved space */
 	if (!ticket->t_cnt) {
-		xlog_grant_add_space(log, &log->l_reserve_head.grant,
+		xlog_grant_add_space(log, &log->l_reserve_head,
 				     ticket->t_unit_res);
 		trace_xfs_log_ticket_regrant_exit(log, ticket);
 
@@ -2872,8 +2869,8 @@ xfs_log_ticket_ungrant(
 		bytes += ticket->t_unit_res*ticket->t_cnt;
 	}
 
-	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
-	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
+	xlog_grant_sub_space(log, &log->l_reserve_head, bytes);
+	xlog_grant_sub_space(log, &log->l_write_head, bytes);
 
 	trace_xfs_log_ticket_ungrant_exit(log, ticket);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 8a005cb08a02..86b5959b5ef2 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -571,8 +571,6 @@ xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
 	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
 }
 
-int xlog_space_left(struct xlog	 *log, atomic64_t *head);
-
 /*
  * Committed Item List interfaces
  */
-- 
2.36.1

