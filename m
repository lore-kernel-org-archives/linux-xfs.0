Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F465639
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868129; cv=none; b=sSqjYEs6LorcB4LdmDQFNEPMGa+t9mZc0F8rJOy2XvmzaowT6yPrp2ow1S1oGvWCz349tYNVZBR3gVeudzwiAr99WbbeOUO5ieV7w/NmWdGe5gao6LDwn3IuqNz2X2kODOZFqxw6x/go+7rKbdpTqCSHADXGOnrZwTPuPmv71Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868129; c=relaxed/simple;
	bh=fjibyn2uBA+R3HKCZB5Mp/FkR1/al0glPpsY+Kmg9bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8w8IftxlhZxuf/Dwza7ZoDtDNr51m7Qj/wBdaSGVRdUkwylF5ac/Gd1dGJP4/aW7IUlAAbukKx/r78UlTlbn+TgO3zo5NDr9NMFOxAX+DoyytKFO4NhKpnc5lSzaJX2c9pvx/wVk1pWKomwZvB1Zzx2xCHpW99EShvqFkB4tcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jo1o163D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jo1o163D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4P2ZymEoth/7ohyWbdedzvzbHpTQ4kceVGUgO5UO6rw=; b=Jo1o163Dk4zGuwpxz8i9bWy9m/
	KFyJegFSUU7bI1RYSHSnrghU/hoZ4ld6e7KsfQhABAMBEyCtr/UnJ72G3bzzd6893tuPbchsCZdzd
	xZNZX9ZEqcuwZwCjukQ8DgegvZs6DK+LlaedM91qVASKo9Qth1XKafSg3y+YQuKm8Vka3oeORl7U4
	nW6zQGTEgAFGFS2UfVrxO0eSnAY0nUgKz4co7yxMXdBfQuMZFLzjPHlj8QAIJf4mAaqI5iyPgzh2z
	iSlWBwUikBa8BQqZXfmY9b3GzGGKC6AQxGQn/gFLH1xNRNrgSpvm2cy5prZgts+2NWD1ZOHqmri7G
	SYMbygSw==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7R-00000003xaY-3vMs;
	Thu, 20 Jun 2024 07:22:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 06/11] xfs: l_last_sync_lsn is really AIL state
Date: Thu, 20 Jun 2024 09:21:23 +0200
Message-ID: <20240620072146.530267-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620072146.530267-1-hch@lst.de>
References: <20240620072146.530267-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

The current implementation of xlog_assign_tail_lsn() assumes that
when the AIL is empty, the log tail matches the LSN of the last
written commit record. This is recorded in xlog_state_set_callback()
as log->l_last_sync_lsn when the iclog state changes to
XLOG_STATE_CALLBACK. This change is then immediately followed by
running the callbacks on the iclog which then insert the log items
into the AIL at the "commit lsn" of that checkpoint.

The AIL tracks log items via the start record LSN of the checkpoint,
not the commit record LSN. This is because we can pipeline multiple
checkpoints, and so the start record of checkpoint N+1 can be
written before the commit record of checkpoint N. i.e:

     start N			commit N
	+-------------+------------+----------------+
		  start N+1			commit N+1

The tail of the log cannot be moved to the LSN of commit N when all
the items of that checkpoint are written back, because then the
start record for N+1 is no longer in the active portion of the log
and recovery will fail/corrupt the filesystem.

Hence when all the log items in checkpoint N are written back, the
tail of the log most now only move as far forwards as the start LSN
of checkpoint N+1.

Hence we cannot use the maximum start record LSN the AIL sees as a
replacement the pointer to the current head of the on-disk log
records. However, we currently only use the l_last_sync_lsn when the
AIL is empty - when there is no start LSN remaining, the tail of the
log moves to the LSN of the last commit record as this is where
recovery needs to start searching for recoverable records. THe next
checkpoint will have a start record LSN that is higher than
l_last_sync_lsn, and so everything still works correctly when new
checkpoints are written to an otherwise empty log.

l_last_sync_lsn is an atomic variable because it is currently
updated when an iclog with callbacks attached moves to the CALLBACK
state. While we hold the icloglock at this point, we don't hold the
AIL lock. When we assign the log tail, we hold the AIL lock, not the
icloglock because we have to look up the AIL. Hence it is an atomic
variable so it's not bound to a specific lock context.

However, the iclog callbacks are only used for CIL checkpoints. We
don't use callbacks with unmount record writes, so the
l_last_sync_lsn variable only gets updated when we are processing
CIL checkpoint callbacks. And those callbacks run under AIL lock
contexts, not icloglock context. The CIL checkpoint already knows
what the LSN of the iclog the commit record was written to (obtained
when written into the iclog before submission) and so we can update
the l_last_sync_lsn under the AIL lock in this callback. No other
iclog callbacks will run until the currently executing one
completes, and hence we can update the l_last_sync_lsn under the AIL
lock safely.

This means l_last_sync_lsn can move to the AIL as the "ail_head_lsn"
and it can be used to replace the atomic l_last_sync_lsn in the
iclog code. This makes tracking the log tail belong entirely to the
AIL, rather than being smeared across log, iclog and AIL state and
locking.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c         | 81 +++++-----------------------------------
 fs/xfs/xfs_log_cil.c     | 54 ++++++++++++++++++++-------
 fs/xfs/xfs_log_priv.h    |  9 ++---
 fs/xfs/xfs_log_recover.c | 19 +++++-----
 fs/xfs/xfs_trace.c       |  1 +
 fs/xfs/xfs_trace.h       |  8 ++--
 fs/xfs/xfs_trans_ail.c   | 26 +++++++++++--
 fs/xfs/xfs_trans_priv.h  | 13 +++++++
 8 files changed, 102 insertions(+), 109 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ae22f361627fe4..1977afecd385d5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1230,47 +1230,6 @@ xfs_log_cover(
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
@@ -1501,7 +1460,6 @@ xlog_alloc_log(
 	log->l_prev_block  = -1;
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
 	xlog_assign_atomic_lsn(&log->l_tail_lsn, 1, 0);
-	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
 
 	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
@@ -2549,44 +2507,23 @@ xlog_get_lowest_lsn(
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
 static void
 xlog_state_set_callback(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
 	xfs_lsn_t		header_lsn)
 {
+	/*
+	 * If there are no callbacks on this iclog, we can mark it clean
+	 * immediately and return. Otherwise we need to run the
+	 * callbacks.
+	 */
+	if (list_empty(&iclog->ic_callbacks)) {
+		xlog_state_clean_iclog(log, iclog);
+		return;
+	}
 	trace_xlog_iclog_callback(iclog, _RET_IP_);
 	iclog->ic_state = XLOG_STATE_CALLBACK;
-
-	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
-			   header_lsn) <= 0);
-
-	if (list_empty_careful(&iclog->ic_callbacks))
-		return;
-
-	atomic64_set(&log->l_last_sync_lsn, header_lsn);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 141bde08bd6e3c..482955f1fa1f9f 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -721,6 +721,24 @@ xlog_cil_ail_insert_batch(
  * items into the AIL. This uses bulk insertion techniques to minimise AIL lock
  * traffic.
  *
+ * The AIL tracks log items via the start record LSN of the checkpoint,
+ * not the commit record LSN. This is because we can pipeline multiple
+ * checkpoints, and so the start record of checkpoint N+1 can be
+ * written before the commit record of checkpoint N. i.e:
+ *
+ *   start N			commit N
+ *	+-------------+------------+----------------+
+ *		  start N+1			commit N+1
+ *
+ * The tail of the log cannot be moved to the LSN of commit N when all
+ * the items of that checkpoint are written back, because then the
+ * start record for N+1 is no longer in the active portion of the log
+ * and recovery will fail/corrupt the filesystem.
+ *
+ * Hence when all the log items in checkpoint N are written back, the
+ * tail of the log most now only move as far forwards as the start LSN
+ * of checkpoint N+1.
+ *
  * If we are called with the aborted flag set, it is because a log write during
  * a CIL checkpoint commit has failed. In this case, all the items in the
  * checkpoint have already gone through iop_committed and iop_committing, which
@@ -738,24 +756,33 @@ xlog_cil_ail_insert_batch(
  */
 static void
 xlog_cil_ail_insert(
-	struct xlog		*log,
-	struct list_head	*lv_chain,
-	xfs_lsn_t		commit_lsn,
+	struct xfs_cil_ctx	*ctx,
 	bool			aborted)
 {
 #define LOG_ITEM_BATCH_SIZE	32
-	struct xfs_ail		*ailp = log->l_ailp;
+	struct xfs_ail		*ailp = ctx->cil->xc_log->l_ailp;
 	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
 	struct xfs_log_vec	*lv;
 	struct xfs_ail_cursor	cur;
 	int			i = 0;
 
+	/*
+	 * Update the AIL head LSN with the commit record LSN of this
+	 * checkpoint. As iclogs are always completed in order, this should
+	 * always be the same (as iclogs can contain multiple commit records) or
+	 * higher LSN than the current head. We do this before insertion of the
+	 * items so that log space checks during insertion will reflect the
+	 * space that this checkpoint has already consumed.
+	 */
+	ASSERT(XFS_LSN_CMP(ctx->commit_lsn, ailp->ail_head_lsn) >= 0 ||
+			aborted);
 	spin_lock(&ailp->ail_lock);
-	xfs_trans_ail_cursor_last(ailp, &cur, commit_lsn);
+	ailp->ail_head_lsn = ctx->commit_lsn;
+	xfs_trans_ail_cursor_last(ailp, &cur, ctx->start_lsn);
 	spin_unlock(&ailp->ail_lock);
 
 	/* unpin all the log items */
-	list_for_each_entry(lv, lv_chain, lv_list) {
+	list_for_each_entry(lv, &ctx->lv_chain, lv_list) {
 		struct xfs_log_item	*lip = lv->lv_item;
 		xfs_lsn_t		item_lsn;
 
@@ -768,9 +795,10 @@ xlog_cil_ail_insert(
 		}
 
 		if (lip->li_ops->iop_committed)
-			item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
+			item_lsn = lip->li_ops->iop_committed(lip,
+					ctx->start_lsn);
 		else
-			item_lsn = commit_lsn;
+			item_lsn = ctx->start_lsn;
 
 		/* item_lsn of -1 means the item needs no further processing */
 		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
@@ -787,7 +815,7 @@ xlog_cil_ail_insert(
 			continue;
 		}
 
-		if (item_lsn != commit_lsn) {
+		if (item_lsn != ctx->start_lsn) {
 
 			/*
 			 * Not a bulk update option due to unusual item_lsn.
@@ -810,14 +838,15 @@ xlog_cil_ail_insert(
 		log_items[i++] = lv->lv_item;
 		if (i >= LOG_ITEM_BATCH_SIZE) {
 			xlog_cil_ail_insert_batch(ailp, &cur, log_items,
-					LOG_ITEM_BATCH_SIZE, commit_lsn);
+					LOG_ITEM_BATCH_SIZE, ctx->start_lsn);
 			i = 0;
 		}
 	}
 
 	/* make sure we insert the remainder! */
 	if (i)
-		xlog_cil_ail_insert_batch(ailp, &cur, log_items, i, commit_lsn);
+		xlog_cil_ail_insert_batch(ailp, &cur, log_items, i,
+				ctx->start_lsn);
 
 	spin_lock(&ailp->ail_lock);
 	xfs_trans_ail_cursor_done(&cur);
@@ -863,8 +892,7 @@ xlog_cil_committed(
 		spin_unlock(&ctx->cil->xc_push_lock);
 	}
 
-	xlog_cil_ail_insert(ctx->cil->xc_log, &ctx->lv_chain,
-					ctx->start_lsn, abort);
+	xlog_cil_ail_insert(ctx, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents.extent_list);
 	xfs_extent_busy_clear(mp, &ctx->busy_extents.extent_list,
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 971871b84d8436..4b8ef926044599 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -431,13 +431,10 @@ struct xlog {
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
index 4fe627991e8653..63f667f92c322e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1177,8 +1177,8 @@ xlog_check_unmount_rec(
 			 */
 			xlog_assign_atomic_lsn(&log->l_tail_lsn,
 					log->l_curr_cycle, after_umount_blk);
-			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
-					log->l_curr_cycle, after_umount_blk);
+			log->l_ailp->ail_head_lsn =
+					atomic64_read(&log->l_tail_lsn);
 			*tail_blk = after_umount_blk;
 
 			*clean = true;
@@ -1212,7 +1212,7 @@ xlog_set_state(
 	if (bump_cycle)
 		log->l_curr_cycle++;
 	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
-	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
+	log->l_ailp->ail_head_lsn = be64_to_cpu(rhead->h_lsn);
 	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
 					BBTOB(log->l_curr_block));
 	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
@@ -3363,14 +3363,13 @@ xlog_do_recover(
 
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
index 9c7fbaae2717dd..1aa013fdc36fcf 100644
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
index 25ff6fe1eb6c8a..13f6e6cab572ae 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1404,19 +1404,19 @@ TRACE_EVENT(xfs_log_assign_tail_lsn,
 		__field(dev_t, dev)
 		__field(xfs_lsn_t, new_lsn)
 		__field(xfs_lsn_t, old_lsn)
-		__field(xfs_lsn_t, last_sync_lsn)
+		__field(xfs_lsn_t, head_lsn)
 	),
 	TP_fast_assign(
 		__entry->dev = log->l_mp->m_super->s_dev;
 		__entry->new_lsn = new_lsn;
 		__entry->old_lsn = atomic64_read(&log->l_tail_lsn);
-		__entry->last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
+		__entry->head_lsn = log->l_ailp->ail_head_lsn;
 	),
-	TP_printk("dev %d:%d new tail lsn %d/%d, old lsn %d/%d, last sync %d/%d",
+	TP_printk("dev %d:%d new tail lsn %d/%d, old lsn %d/%d, head lsn %d/%d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  CYCLE_LSN(__entry->new_lsn), BLOCK_LSN(__entry->new_lsn),
 		  CYCLE_LSN(__entry->old_lsn), BLOCK_LSN(__entry->old_lsn),
-		  CYCLE_LSN(__entry->last_sync_lsn), BLOCK_LSN(__entry->last_sync_lsn))
+		  CYCLE_LSN(__entry->head_lsn), BLOCK_LSN(__entry->head_lsn))
 )
 
 DECLARE_EVENT_CLASS(xfs_file_class,
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 7d6ccd21aae2e5..5f03f82c46838e 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -720,6 +720,26 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+void
+__xfs_ail_assign_tail_lsn(
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
+		tail_lsn = ailp->ail_head_lsn;
+
+	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
+	atomic64_set(&log->l_tail_lsn, tail_lsn);
+}
+
 /*
  * Callers should pass the original tail lsn so that we can detect if the tail
  * has moved as a result of the operation that was performed. If the caller
@@ -734,15 +754,13 @@ xfs_ail_update_finish(
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
+	__xfs_ail_assign_tail_lsn(ailp);
 	if (list_empty(&ailp->ail_head))
 		wake_up_all(&ailp->ail_empty);
 	spin_unlock(&ailp->ail_lock);
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 60b4707c3a6583..bd841df93021ff 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -55,6 +55,7 @@ struct xfs_ail {
 	struct list_head	ail_cursors;
 	spinlock_t		ail_lock;
 	xfs_lsn_t		ail_last_pushed_lsn;
+	xfs_lsn_t		ail_head_lsn;
 	int			ail_log_flush;
 	unsigned long		ail_opstate;
 	struct list_head	ail_buf_list;
@@ -130,6 +131,18 @@ struct xfs_log_item *	xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur);
 void			xfs_trans_ail_cursor_done(struct xfs_ail_cursor *cur);
 
+void			__xfs_ail_assign_tail_lsn(struct xfs_ail *ailp);
+
+static inline void
+xfs_ail_assign_tail_lsn(
+	struct xfs_ail		*ailp)
+{
+
+	spin_lock(&ailp->ail_lock);
+	__xfs_ail_assign_tail_lsn(ailp);
+	spin_unlock(&ailp->ail_lock);
+}
+
 #if BITS_PER_LONG != 64
 static inline void
 xfs_trans_ail_copy_lsn(
-- 
2.43.0

