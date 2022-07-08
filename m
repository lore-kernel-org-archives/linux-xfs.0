Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F085C43334
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 01:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiGHB4I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 21:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiGHB4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 21:56:07 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5817735B6
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 18:56:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 49CB910E7C48
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 11:56:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-00Fqlc-KG
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 11:56:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-004lE9-JL
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 11:56:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: grant heads track byte counts, not LSNs
Date:   Fri,  8 Jul 2022 11:55:58 +1000
Message-Id: <20220708015558.1134330-9-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708015558.1134330-1-david@fromorbit.com>
References: <20220708015558.1134330-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62c78eb3
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=Mwgu4HOEQc4z_Sop6SMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The grant heads in the log track the space reserved in the log for
running transactions. They do this by tracking how far ahead of the
tail that the reservation has reached, and the units for doing this
are {cycle,bytes} for the reserve head rather than {cycle,blocks}
which are normal used by LSNs.

This is annoyingly complex because we have to split, crack and
combined these tuples for any calculation we do to determine log
space and targets. This is computationally expensive as well as
difficult to do atomically and locklessly, as well as limiting the
size of the log to 2^32 bytes.

Really, though, all the grant heads are tracking is how much space
is currently available for use in the log. We can track this as a
simply byte count - we just don't care what the actual physical
location in the log the head and tail are at, just how much space we
have remaining before the head and tail overlap.

So, convert the grant heads to track the byte reservations that are
active rather than the current (cycle, offset) tuples. This means an
empty log has zero bytes consumed, and a full log is when the the
reservations reach the size of the log minus the space consumed by
the AIL.

This greatly simplifies the accounting and checks for whether there
is space available. We no longer need to crack or combine LSNs to
determine how much space the log has left, nor do we need to look at
the head or tail of the log to determine how close to full we are.

There is, however, a complexity that needs to be handled. We know
how much space is being tracked in the AIL now via log->l_tail_space
and the log tickets track active reservations and return the unused
portions to the grant heads when ungranted.  Unfortunately, we don't
track the used portion of the grant, so when we transfer log items
from the CIL to the AIL, the space accounted to the grant heads is
transferred to the log tail space.  Hence when we move the AIL head
forwards on item insert, we have to remove that space from the grant
heads.

We also remove the xlog_verify_grant_tail() debug function as it is
no l onger useful. The check it performs has been racy since delayed
logging was introduced, but now it is clearly only detecting false
positives so remove it.

The result of this substantially simpler accounting algorithm is an
increase in sustained transaction rate from ~1.3 million
transactions/s to ~1.9 million transactions/s with no increase in
CPU usage. We also remove the 32 bit space limitation on the
journal, which will allow us to increase the journal size beyond 2GB
in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c         | 189 ++++++++++-----------------------------
 fs/xfs/xfs_log_priv.h    |  33 +------
 fs/xfs/xfs_log_recover.c |   4 -
 fs/xfs/xfs_sysfs.c       |  17 ++--
 fs/xfs/xfs_trace.h       |  32 +++----
 fs/xfs/xfs_trans_ail.c   |  10 +++
 6 files changed, 84 insertions(+), 201 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 691d9ea6f4da..1a71c158e361 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -53,9 +53,6 @@ xlog_sync(
 	struct xlog_ticket	*ticket);
 #if defined(DEBUG)
 STATIC void
-xlog_verify_grant_tail(
-	struct xlog *log);
-STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
@@ -65,7 +62,6 @@ xlog_verify_tail_lsn(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog);
 #else
-#define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c)
 #define xlog_verify_tail_lsn(a,b)
 #endif
@@ -133,30 +129,13 @@ xlog_prepare_iovec(
 	return buf;
 }
 
-static void
+void
 xlog_grant_sub_space(
 	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(&head->grant);
-	int64_t new, old;
-
-	do {
-		int	cycle, space;
-
-		xlog_crack_grant_head_val(head_val, &cycle, &space);
-
-		space -= bytes;
-		if (space < 0) {
-			space += log->l_logsize;
-			cycle--;
-		}
-
-		old = head_val;
-		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(&head->grant, old, new);
-	} while (head_val != old);
+	atomic64_sub(bytes, &head->grant);
 }
 
 static void
@@ -165,93 +144,34 @@ xlog_grant_add_space(
 	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(&head->grant);
-	int64_t new, old;
-
-	do {
-		int		tmp;
-		int		cycle, space;
-
-		xlog_crack_grant_head_val(head_val, &cycle, &space);
-
-		tmp = log->l_logsize - space;
-		if (tmp > bytes)
-			space += bytes;
-		else {
-			space = bytes - tmp;
-			cycle++;
-		}
-
-		old = head_val;
-		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(&head->grant, old, new);
-	} while (head_val != old);
+	atomic64_add(bytes, &head->grant);
 }
 
-STATIC void
+static void
 xlog_grant_head_init(
 	struct xlog_grant_head	*head)
 {
-	xlog_assign_grant_head(&head->grant, 1, 0);
+	atomic64_set(&head->grant, 0);
 	INIT_LIST_HEAD(&head->waiters);
 	spin_lock_init(&head->lock);
 }
 
 /*
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
+ * Return the space in the log between the tail and the head.  In the case where
+ * we have overrun available reservation space, return 0.
  */
-static int
+static uint64_t
 xlog_grant_space_left(
 	struct xlog		*log,
 	struct xlog_grant_head	*head)
 {
-	int			tail_bytes;
-	int			tail_cycle;
-	int			head_cycle;
-	int			head_bytes;
-
-	xlog_crack_grant_head(&head->grant, &head_cycle, &head_bytes);
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
+	int64_t			free_bytes;
 
-	if (tail_cycle < head_cycle) {
-		ASSERT(tail_cycle == (head_cycle - 1));
-		return tail_bytes - head_bytes;
-	}
-
-	/*
-	 * The reservation head is behind the tail. In this case we just want to
-	 * return the size of the log as the amount of space left.
-	 */
-	xfs_alert(log->l_mp, "xlog_grant_space_left: head behind tail");
-	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
-		  tail_cycle, tail_bytes);
-	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
-		  head_cycle, head_bytes);
-	ASSERT(0);
-	return log->l_logsize;
+	free_bytes = log->l_logsize - READ_ONCE(log->l_tail_space) -
+			atomic64_read(&head->grant);
+	if (free_bytes > 0)
+		return free_bytes;
+	return 0;
 }
 
 STATIC void
@@ -454,7 +374,6 @@ xfs_log_regrant(
 
 	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_regrant_exit(log, tic);
-	xlog_verify_grant_tail(log);
 	return 0;
 
 out_error:
@@ -506,7 +425,6 @@ xfs_log_reserve(
 	xlog_grant_add_space(log, &log->l_reserve_head, need_bytes);
 	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_reserve_exit(log, tic);
-	xlog_verify_grant_tail(log);
 	return 0;
 
 out_error:
@@ -3342,42 +3260,27 @@ xlog_ticket_alloc(
 }
 
 #if defined(DEBUG)
-/*
- * Check to make sure the grant write head didn't just over lap the tail.  If
- * the cycles are the same, we can't be overlapping.  Otherwise, make sure that
- * the cycles differ by exactly one and check the byte count.
- *
- * This check is run unlocked, so can give false positives. Rather than assert
- * on failures, use a warn-once flag and a panic tag to allow the admin to
- * determine if they want to panic the machine when such an error occurs. For
- * debug kernels this will have the same effect as using an assert but, unlinke
- * an assert, it can be turned off at runtime.
- */
-STATIC void
-xlog_verify_grant_tail(
-	struct xlog	*log)
+static void
+xlog_verify_dump_tail(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
 {
-	int		tail_cycle, tail_blocks;
-	int		cycle, space;
-
-	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &space);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
-	if (tail_cycle != cycle) {
-		if (cycle - 1 != tail_cycle &&
-		    !test_and_set_bit(XLOG_TAIL_WARN, &log->l_opstate)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: cycle - 1 != tail_cycle", __func__);
-		}
-
-		if (space > BBTOB(tail_blocks) &&
-		    !test_and_set_bit(XLOG_TAIL_WARN, &log->l_opstate)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: space > BBTOB(tail_blocks)", __func__);
-		}
-	}
-}
-
-/* check if it will fit */
+	xfs_alert(log->l_mp,
+"ran out of log space tail 0x%llx/0x%llx, max seen lsn 0x%llx, head 0x%x/0x%x, prev head 0x%x/0x%x",
+			iclog ? be64_to_cpu(iclog->ic_header.h_tail_lsn) : -1,
+			atomic64_read(&log->l_tail_lsn),
+			log->l_ailp->ail_max_seen_lsn,
+			log->l_curr_cycle, log->l_curr_block,
+			log->l_prev_cycle, log->l_prev_block);
+	xfs_alert(log->l_mp,
+"write grant 0x%llx, reserve grant 0x%llx, tail_space 0x%llx, size 0x%x, iclog flags 0x%x",
+			atomic64_read(&log->l_write_head.grant),
+			atomic64_read(&log->l_reserve_head.grant),
+			log->l_tail_space, log->l_logsize,
+			iclog ? iclog->ic_flags : -1);
+}
+
+/* Check if the new iclog will fit in the log. */
 STATIC void
 xlog_verify_tail_lsn(
 	struct xlog		*log,
@@ -3386,20 +3289,26 @@ xlog_verify_tail_lsn(
 	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
 	int		blocks;
 
-    if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
-	blocks =
-	    log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
-	if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    } else {
-	ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
+	if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
+		blocks = log->l_logBBsize -
+				(log->l_prev_block - BLOCK_LSN(tail_lsn));
+		if (blocks < BTOBB(iclog->ic_offset) +
+					BTOBB(log->l_iclog_hsize)) {
+			xfs_emerg(log->l_mp,
+					"%s: ran out of log space", __func__);
+			xlog_verify_dump_tail(log, iclog);
+		}
+		return;
+	}
 
+	ASSERT(CYCLE_LSN(tail_lsn) + 1 == log->l_prev_cycle);
 	if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
 		xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
 
 	blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
-	if (blocks < BTOBB(iclog->ic_offset) + 1)
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
+	if (blocks < BTOBB(iclog->ic_offset) + 1) {
+		xfs_emerg(log->l_mp, "%s: ran out of iclog space", __func__);
+		xlog_verify_dump_tail(log, iclog);
     }
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 86b5959b5ef2..f5eda226895e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -511,6 +511,9 @@ int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
+void	xlog_grant_sub_space(struct xlog *log, struct xlog_grant_head *head,
+			int bytes);
+
 void xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
 		int eventual_size);
 int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog,
@@ -541,36 +544,6 @@ xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
 	atomic64_set(lsn, xlog_assign_lsn(cycle, block));
 }
 
-/*
- * When we crack the grant head, we sample it first so that the value will not
- * change while we are cracking it into the component values. This means we
- * will always get consistent component values to work from.
- */
-static inline void
-xlog_crack_grant_head_val(int64_t val, int *cycle, int *space)
-{
-	*cycle = val >> 32;
-	*space = val & 0xffffffff;
-}
-
-static inline void
-xlog_crack_grant_head(atomic64_t *head, int *cycle, int *space)
-{
-	xlog_crack_grant_head_val(atomic64_read(head), cycle, space);
-}
-
-static inline int64_t
-xlog_assign_grant_head_val(int cycle, int space)
-{
-	return ((int64_t)cycle << 32) | space;
-}
-
-static inline void
-xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
-{
-	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
-}
-
 /*
  * Committed Item List interfaces
  */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ba2d591a1437..315665f80dc2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1215,10 +1215,6 @@ xlog_set_state(
 	log->l_ailp->ail_max_seen_lsn = be64_to_cpu(rhead->h_lsn);
 	WRITE_ONCE(log->l_tail_space, atomic64_read(&log->l_tail_lsn) -
 						log->l_ailp->ail_max_seen_lsn);
-	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
-					BBTOB(log->l_curr_block));
-	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
-					BBTOB(log->l_curr_block));
 }
 
 /*
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index f7faf6e70d7f..0b19acea28cb 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -376,14 +376,11 @@ STATIC ssize_t
 reserve_grant_head_show(
 	struct kobject	*kobject,
 	char		*buf)
-
 {
-	int cycle;
-	int bytes;
-	struct xlog *log = to_xlog(kobject);
+	struct xlog	*log = to_xlog(kobject);
+	uint64_t	bytes = atomic64_read(&log->l_reserve_head.grant);
 
-	xlog_crack_grant_head(&log->l_reserve_head.grant, &cycle, &bytes);
-	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
+	return sysfs_emit(buf, "%lld\n", bytes);
 }
 XFS_SYSFS_ATTR_RO(reserve_grant_head);
 
@@ -392,12 +389,10 @@ write_grant_head_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	int cycle;
-	int bytes;
-	struct xlog *log = to_xlog(kobject);
+	struct xlog	*log = to_xlog(kobject);
+	uint64_t	bytes = atomic64_read(&log->l_write_head.grant);
 
-	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &bytes);
-	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
+	return sysfs_emit(buf, "%lld\n", bytes);
 }
 XFS_SYSFS_ATTR_RO(write_grant_head);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a208a5a64657..cce5581a0be4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1206,6 +1206,7 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	TP_ARGS(log, tic),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(unsigned long, tic)
 		__field(char, ocnt)
 		__field(char, cnt)
 		__field(int, curr_res)
@@ -1213,16 +1214,16 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__field(unsigned int, flags)
 		__field(int, reserveq)
 		__field(int, writeq)
-		__field(int, grant_reserve_cycle)
-		__field(int, grant_reserve_bytes)
-		__field(int, grant_write_cycle)
-		__field(int, grant_write_bytes)
+		__field(uint64_t, grant_reserve_bytes)
+		__field(uint64_t, grant_write_bytes)
+		__field(uint64_t, tail_space)
 		__field(int, curr_cycle)
 		__field(int, curr_block)
 		__field(xfs_lsn_t, tail_lsn)
 	),
 	TP_fast_assign(
 		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->tic = (unsigned long)tic;
 		__entry->ocnt = tic->t_ocnt;
 		__entry->cnt = tic->t_cnt;
 		__entry->curr_res = tic->t_curr_res;
@@ -1230,23 +1231,23 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->flags = tic->t_flags;
 		__entry->reserveq = list_empty(&log->l_reserve_head.waiters);
 		__entry->writeq = list_empty(&log->l_write_head.waiters);
-		xlog_crack_grant_head(&log->l_reserve_head.grant,
-				&__entry->grant_reserve_cycle,
-				&__entry->grant_reserve_bytes);
-		xlog_crack_grant_head(&log->l_write_head.grant,
-				&__entry->grant_write_cycle,
-				&__entry->grant_write_bytes);
+		__entry->tail_space = READ_ONCE(log->l_tail_space);
+		__entry->grant_reserve_bytes = __entry->tail_space +
+			atomic64_read(&log->l_reserve_head.grant);
+		__entry->grant_write_bytes = __entry->tail_space +
+			atomic64_read(&log->l_write_head.grant);
 		__entry->curr_cycle = log->l_curr_cycle;
 		__entry->curr_block = log->l_curr_block;
 		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
 	),
-	TP_printk("dev %d:%d t_ocnt %u t_cnt %u t_curr_res %u "
+	TP_printk("dev %d:%d tic 0x%lx t_ocnt %u t_cnt %u t_curr_res %u "
 		  "t_unit_res %u t_flags %s reserveq %s "
-		  "writeq %s grant_reserve_cycle %d "
-		  "grant_reserve_bytes %d grant_write_cycle %d "
-		  "grant_write_bytes %d curr_cycle %d curr_block %d "
+		  "writeq %s "
+		  "tail space %llu grant_reserve_bytes %llu "
+		  "grant_write_bytes %llu curr_cycle %d curr_block %d "
 		  "tail_cycle %d tail_block %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tic,
 		  __entry->ocnt,
 		  __entry->cnt,
 		  __entry->curr_res,
@@ -1254,9 +1255,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
 		  __entry->reserveq ? "empty" : "active",
 		  __entry->writeq ? "empty" : "active",
-		  __entry->grant_reserve_cycle,
+		  __entry->tail_space,
 		  __entry->grant_reserve_bytes,
-		  __entry->grant_write_cycle,
 		  __entry->grant_write_bytes,
 		  __entry->curr_cycle,
 		  __entry->curr_block,
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index fd4aa9c4e914..1ea9ec2c07dc 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -823,8 +823,18 @@ xfs_trans_ail_update_bulk(
 	/*
 	 * If this is the highest LSN we've seen in the AIL, update the tracking
 	 * so that we know what to set the tail to when the AIL is next emptied.
+	 * As the space will now be tracked by the log tail space rather than
+	 * the grant heads, subtract the newly used log space from the grant
+	 * heads.
 	 */
 	if (XFS_LSN_CMP(lsn, ailp->ail_max_seen_lsn) > 0) {
+		struct xlog	*log = ailp->ail_log;
+		int64_t		diff;
+
+		diff = xlog_lsn_sub(log, lsn, ailp->ail_max_seen_lsn);
+		xlog_grant_sub_space(log, &log->l_reserve_head, diff);
+		xlog_grant_sub_space(log, &log->l_write_head, diff);
+
 		ailp->ail_max_seen_lsn = lsn;
 		tail_lsn = NULLCOMMITLSN;
 	}
-- 
2.36.1

