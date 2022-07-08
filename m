Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31495C43334
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 01:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiGHB4F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 21:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiGHB4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 21:56:04 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AA3C7359A
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 18:56:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 427A262C3D6
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 11:56:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-00FqlR-GS
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 11:56:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-004lDm-Fk
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 11:56:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: l_last_sync_lsn is really tracking AIL state
Date:   Fri,  8 Jul 2022 11:55:54 +1000
Message-Id: <20220708015558.1134330-5-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708015558.1134330-1-david@fromorbit.com>
References: <20220708015558.1134330-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c78eb2
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=fO-0zb4Z4e04_7Ar1f4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The current implementation of xlog_assign_tail_lsn() assumes that
when the AIL is empty, the log tail matches the LSN of the last
written commit record. This is recorded in xlog_state_set_callback()
as log->l_last_sync_lsn when the iclog state changes to
XLOG_STATE_CALLBACK. This change is then immediately followed by
running the callbacks on the iclog which then insert the log items
into the AIL at the "commit lsn" of that checkpoint.

The "commit lsn" of the checkpoint is the LSN of the iclog that the
commit record is place in. This is also the same iclog that the
callback is attached to. Hence the log->l_last_sync_lsn is set to
the same value as the commit lsn recorded for the checkpoint being
inserted into the AIL and it effectively tracks the highest ever LSN
that the AIL has seen.

This value is not used directly by the log. It was used to determine
the maximum push threshold for AIL pushing to ensure we didn't set
a push target larger than had been seen in the AIL, but the AIL now
only needs to look at it's own internal state to set push targets.

The log itself tracks it's current head via the {current_lsn,
current_block} tuple, so it doesn't need l_last_sync_lsn for
tracking the head of the log.  Hence nothing actually uses
log->l_last_sync_lsn except for the tail assignment when the AIL is
empty.

This "highest commit LSN" really doesn't need to be tracked by the
log - the max LSN seen by the AIL can be easily tracked by the AIL
and it can be used to set the log tail LSN correctly when the last
item is removed from the AIL.

Therefore, move the highest committed LSN tracking to the AIL and
remove l_last_sync_lsn from the log code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c         | 94 +++++-----------------------------------
 fs/xfs/xfs_log_priv.h    |  9 ++--
 fs/xfs/xfs_log_recover.c | 19 ++++----
 fs/xfs/xfs_trace.c       |  1 +
 fs/xfs/xfs_trace.h       |  8 ++--
 fs/xfs/xfs_trans_ail.c   | 33 ++++++++++++--
 fs/xfs/xfs_trans_priv.h  | 13 ++++++
 7 files changed, 70 insertions(+), 107 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bef3c0fda5ff..925f32fad5e1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1236,47 +1236,6 @@ xfs_log_cover(
 	return error;
 }
 
-/*
- * We may be holding the log iclog lock upon entering this routine.
- */
-xfs_lsn_t
-xlog_assign_tail_lsn_locked(
-	struct xfs_mount	*mp)
-{
-	struct xlog		*log = mp->m_log;
-	struct xfs_log_item	*lip;
-	xfs_lsn_t		tail_lsn;
-
-	assert_spin_locked(&mp->m_ail->ail_lock);
-
-	/*
-	 * To make sure we always have a valid LSN for the log tail we keep
-	 * track of the last LSN which was committed in log->l_last_sync_lsn,
-	 * and use that when the AIL was empty.
-	 */
-	lip = xfs_ail_min(mp->m_ail);
-	if (lip)
-		tail_lsn = lip->li_lsn;
-	else
-		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
-	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
-	atomic64_set(&log->l_tail_lsn, tail_lsn);
-	return tail_lsn;
-}
-
-xfs_lsn_t
-xlog_assign_tail_lsn(
-	struct xfs_mount	*mp)
-{
-	xfs_lsn_t		tail_lsn;
-
-	spin_lock(&mp->m_ail->ail_lock);
-	tail_lsn = xlog_assign_tail_lsn_locked(mp);
-	spin_unlock(&mp->m_ail->ail_lock);
-
-	return tail_lsn;
-}
-
 /*
  * Return the space in the log between the tail and the head.  The head
  * is passed in the cycle/bytes formal parms.  In the special case where
@@ -1510,7 +1469,6 @@ xlog_alloc_log(
 	log->l_prev_block  = -1;
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
 	xlog_assign_atomic_lsn(&log->l_tail_lsn, 1, 0);
-	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
 
 	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
@@ -2561,46 +2519,6 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
-/*
- * Completion of a iclog IO does not imply that a transaction has completed, as
- * transactions can be large enough to span many iclogs. We cannot change the
- * tail of the log half way through a transaction as this may be the only
- * transaction in the log and moving the tail to point to the middle of it
- * will prevent recovery from finding the start of the transaction. Hence we
- * should only update the last_sync_lsn if this iclog contains transaction
- * completion callbacks on it.
- *
- * We have to do this before we drop the icloglock to ensure we are the only one
- * that can update it.
- *
- * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
- * the reservation grant head pushing. This is due to the fact that the push
- * target is bound by the current last_sync_lsn value. Hence if we have a large
- * amount of log space bound up in this committing transaction then the
- * last_sync_lsn value may be the limiting factor preventing tail pushing from
- * freeing space in the log. Hence once we've updated the last_sync_lsn we
- * should push the AIL to ensure the push target (and hence the grant head) is
- * no longer bound by the old log head location and can move forwards and make
- * progress again.
- */
-static void
-xlog_state_set_callback(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	xfs_lsn_t		header_lsn)
-{
-	trace_xlog_iclog_callback(iclog, _RET_IP_);
-	iclog->ic_state = XLOG_STATE_CALLBACK;
-
-	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
-			   header_lsn) <= 0);
-
-	if (list_empty_careful(&iclog->ic_callbacks))
-		return;
-
-	atomic64_set(&log->l_last_sync_lsn, header_lsn);
-}
-
 /*
  * Return true if we need to stop processing, false to continue to the next
  * iclog. The caller will need to run callbacks if the iclog is returned in the
@@ -2632,7 +2550,17 @@ xlog_state_iodone_process_iclog(
 		lowest_lsn = xlog_get_lowest_lsn(log);
 		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
 			return false;
-		xlog_state_set_callback(log, iclog, header_lsn);
+		/*
+		 * If there are no callbacks on this iclog, we can mark it clean
+		 * immediately and return. Otherwise we need to run the
+		 * callbacks.
+		 */
+		if (list_empty(&iclog->ic_callbacks)) {
+			xlog_state_clean_iclog(log, iclog);
+			return false;
+		}
+		trace_xlog_iclog_callback(iclog, _RET_IP_);
+		iclog->ic_state = XLOG_STATE_CALLBACK;
 		return false;
 	default:
 		/*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 9f8c601a302b..5f4358f18224 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -426,13 +426,10 @@ struct xlog {
 	int			l_prev_block;   /* previous logical log block */
 
 	/*
-	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
-	 * read without needing to hold specific locks. To avoid operations
-	 * contending with other hot objects, place each of them on a separate
-	 * cacheline.
+	 * l_tail_lsn is atomic so it can be set and read without needing to
+	 * hold specific locks. To avoid operations contending with other hot
+	 * objects, it on a separate cacheline.
 	 */
-	/* lsn of last LR on disk */
-	atomic64_t		l_last_sync_lsn ____cacheline_aligned_in_smp;
 	/* lsn of 1st LR with unflushed * buffers */
 	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5f7e4e6e33ce..b8e25da876d8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1177,8 +1177,8 @@ xlog_check_unmount_rec(
 			 */
 			xlog_assign_atomic_lsn(&log->l_tail_lsn,
 					log->l_curr_cycle, after_umount_blk);
-			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
-					log->l_curr_cycle, after_umount_blk);
+			log->l_ailp->ail_max_seen_lsn =
+					atomic64_read(&log->l_tail_lsn);
 			*tail_blk = after_umount_blk;
 
 			*clean = true;
@@ -1212,7 +1212,7 @@ xlog_set_state(
 	if (bump_cycle)
 		log->l_curr_cycle++;
 	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
-	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
+	log->l_ailp->ail_max_seen_lsn = be64_to_cpu(rhead->h_lsn);
 	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
 					BBTOB(log->l_curr_block));
 	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
@@ -3281,14 +3281,13 @@ xlog_do_recover(
 
 	/*
 	 * We now update the tail_lsn since much of the recovery has completed
-	 * and there may be space available to use.  If there were no extent
-	 * or iunlinks, we can free up the entire log and set the tail_lsn to
-	 * be the last_sync_lsn.  This was set in xlog_find_tail to be the
-	 * lsn of the last known good LR on disk.  If there are extent frees
-	 * or iunlinks they will have some entries in the AIL; so we look at
-	 * the AIL to determine how to set the tail_lsn.
+	 * and there may be space available to use.  If there were no extent or
+	 * iunlinks, we can free up the entire log.  This was set in
+	 * xlog_find_tail to be the lsn of the last known good LR on disk.  If
+	 * there are extent frees or iunlinks they will have some entries in the
+	 * AIL; so we look at the AIL to determine how to set the tail_lsn.
 	 */
-	xlog_assign_tail_lsn(mp);
+	xfs_ail_assign_tail_lsn(log->l_ailp);
 
 	/*
 	 * Now that we've finished replaying all buffer and inode updates,
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index d269ef57ff01..dcf9af0108c1 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -22,6 +22,7 @@
 #include "xfs_trans.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
+#include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_quota.h"
 #include "xfs_dquot_item.h"
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0fa1b7a2918c..a208a5a64657 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1383,19 +1383,19 @@ TRACE_EVENT(xfs_log_assign_tail_lsn,
 		__field(dev_t, dev)
 		__field(xfs_lsn_t, new_lsn)
 		__field(xfs_lsn_t, old_lsn)
-		__field(xfs_lsn_t, last_sync_lsn)
+		__field(xfs_lsn_t, max_seen_lsn)
 	),
 	TP_fast_assign(
 		__entry->dev = log->l_mp->m_super->s_dev;
 		__entry->new_lsn = new_lsn;
 		__entry->old_lsn = atomic64_read(&log->l_tail_lsn);
-		__entry->last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
+		__entry->max_seen_lsn = log->l_ailp->ail_max_seen_lsn;
 	),
-	TP_printk("dev %d:%d new tail lsn %d/%d, old lsn %d/%d, last sync %d/%d",
+	TP_printk("dev %d:%d new tail lsn %d/%d, old lsn %d/%d, max lsn %d/%d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  CYCLE_LSN(__entry->new_lsn), BLOCK_LSN(__entry->new_lsn),
 		  CYCLE_LSN(__entry->old_lsn), BLOCK_LSN(__entry->old_lsn),
-		  CYCLE_LSN(__entry->last_sync_lsn), BLOCK_LSN(__entry->last_sync_lsn))
+		  CYCLE_LSN(__entry->max_seen_lsn), BLOCK_LSN(__entry->max_seen_lsn))
 )
 
 DECLARE_EVENT_CLASS(xfs_file_class,
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index b123e8dec76c..f0741c42130a 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -712,6 +712,26 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+void
+xfs_ail_update_tail_lsn(
+	struct xfs_ail		*ailp)
+{
+	struct xlog		*log = ailp->ail_log;
+	xfs_lsn_t		tail_lsn;
+
+	assert_spin_locked(&ailp->ail_lock);
+
+	if (xlog_is_shutdown(log))
+		return;
+
+	tail_lsn = __xfs_ail_min_lsn(ailp);
+	if (!tail_lsn)
+		tail_lsn = ailp->ail_max_seen_lsn;
+
+	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
+	atomic64_set(&log->l_tail_lsn, tail_lsn);
+}
+
 /*
  * Callers should pass the the original tail lsn so that we can detect if the
  * tail has moved as a result of the operation that was performed. If the caller
@@ -725,15 +745,13 @@ xfs_ail_update_finish(
 {
 	struct xlog		*log = ailp->ail_log;
 
-	/* if the tail lsn hasn't changed, don't do updates or wakeups. */
+	/* If the tail lsn hasn't changed, don't do updates or wakeups. */
 	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
 		spin_unlock(&ailp->ail_lock);
 		return;
 	}
 
-	if (!xlog_is_shutdown(log))
-		xlog_assign_tail_lsn_locked(log->l_mp);
-
+	xfs_ail_update_tail_lsn(ailp);
 	if (list_empty(&ailp->ail_head))
 		wake_up_all(&ailp->ail_empty);
 	spin_unlock(&ailp->ail_lock);
@@ -800,6 +818,13 @@ xfs_trans_ail_update_bulk(
 	if (!list_empty(&tmp))
 		xfs_ail_splice(ailp, cur, &tmp, lsn);
 
+	/*
+	 * If this is the highest LSN we've seen in the AIL, update the tracking
+	 * so that we know what to set the tail to when the AIL is next emptied.
+	 */
+	if (XFS_LSN_CMP(lsn, ailp->ail_max_seen_lsn) > 0)
+		ailp->ail_max_seen_lsn = lsn;
+
 	/*
 	 * If this is the first insert, wake up the push daemon so it can
 	 * actively scan for items to push. We also need to do a log tail
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index fc91e9e4d665..9b565c216679 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -58,6 +58,7 @@ struct xfs_ail {
 	struct list_head	ail_cursors;
 	spinlock_t		ail_lock;
 	xfs_lsn_t		ail_last_pushed_lsn;
+	xfs_lsn_t		ail_max_seen_lsn;
 	int			ail_log_flush;
 	unsigned long		ail_opstate;
 	struct list_head	ail_buf_list;
@@ -138,6 +139,18 @@ struct xfs_log_item *	xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur);
 void			xfs_trans_ail_cursor_done(struct xfs_ail_cursor *cur);
 
+void			xfs_ail_update_tail_lsn(struct xfs_ail *ailp);
+
+static inline void
+xfs_ail_assign_tail_lsn(
+	struct xfs_ail		*ailp)
+{
+
+	spin_lock(&ailp->ail_lock);
+	xfs_ail_update_tail_lsn(ailp);
+	spin_unlock(&ailp->ail_lock);
+}
+
 #if BITS_PER_LONG != 64
 static inline void
 xfs_trans_ail_copy_lsn(
-- 
2.36.1

