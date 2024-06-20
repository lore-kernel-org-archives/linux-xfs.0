Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D40639
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868123; cv=none; b=rEu/EdOxaqPt5uSFpZdc6hs5smcpuR9s0mFqhhFoiB+lMww9CSmFX66hkvxJ12XbAaweJiH30V03jgGKIBvH1kKm2vKfKQ3mgm/79C2lae/lVv4dtcHacMyU0h3OojsQSlv27tljOyxxwasXEw9A7Q6uf7v5121O8kl82ZU8vvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868123; c=relaxed/simple;
	bh=XFFeGXQGXLZvnvqbRQ/GdD7RlskbLRQ3tDL0nrvypvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxMMVOITYwqBpGCSlL786BqbaYmeAXhps/zlyMCUuGM5YPA1sRIQ6n3NnYwEsgVGLvQ7zsF1VINg2p3Dz7wsCKUadrx6ejVPMTBylrOeLiMD78+aiQZh6N+wEKqyfpRHuVFom10oK/f4sISbTYuV9L5AXAcfMzRfgwcAtyUg+Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x0luDyTa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x0luDyTa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aLqjl32smzVF0du46DWjQITWA++/JWp0RD4uyBY1jCs=; b=x0luDyTaIjk8avsy+IY09OEv/2
	wjuEth3rkgfrAPxyxoJTJnQVi99qd3sIsLzKf97zj3PnAJ8jPMy265dI8LbIZfIeyg45+4+BN+T4x
	SFFHMnl63A+Eb0kJAG06Plue61Pt0eokmbaJXP4s4wxq4/dBYkd5Wjw6qHBTHlHbebQtMm3AgTY25
	cwv01FDtw+spy7Qv6NXyImAKn2w7D5h+x1teDxYKnO48O3VwqBDTDI8dw6+iYYFLAIfApPwwW9RV0
	FP2oa49z1F/18rlpVTyC1MGi9dp2noRfT5CDlKxhCLSuX+4ugXwyHWtYiPPDUhF1A0rcxIGA5SwTF
	ahCMDXzA==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7N-00000003xZC-1W30;
	Thu, 20 Jun 2024 07:22:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 04/11] xfs: background AIL push should target physical space
Date: Thu, 20 Jun 2024 09:21:21 +0200
Message-ID: <20240620072146.530267-5-hch@lst.de>
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

Currently the AIL attempts to keep 25% of the "log space" free,
where the current used space is tracked by the reserve grant head.
That is, it tracks both physical space used plus the amount reserved
by transactions in progress.

When we start tail pushing, we are trying to make space for new
reservations by writing back older metadata and the log is generally
physically full of dirty metadata, and reservations for modifications
in flight take up whatever space the AIL can physically free up.

Hence we don't really need to take into account the reservation
space that has been used - we just need to keep the log tail moving
as fast as we can to free up space for more reservations to be made.
We know exactly how much physical space the journal is consuming in
the AIL (i.e. max LSN - min LSN) so we can base push thresholds
directly on this state rather than have to look at grant head
reservations to determine how much to physically push out of the
log.

This also allows code that needs to know if log items in the current
transaction need to be pushed or re-logged to simply sample the
current target - they don't need to calculate the current target
themselves. This avoids the need for any locking when doing such
checks.

Further, moving to a physical target means we don't need "push all
until empty semantics" like were introduced in the previous patch.
We can now test and clear the "push all" as a one-shot command to
set the target to the current head of the AIL. This allows the
xfsaild to maximise the use of log space right up to the point where
conditions indicate that the xfsaild is not keeping up with load and
it needs to work harder, and as soon as those constraints go away
(i.e. external code no longer needs everything pushed) the xfsaild
will return to maintaining the normal 25% free space thresholds.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c |   2 +-
 fs/xfs/xfs_log_priv.h     |  18 ++++++
 fs/xfs/xfs_trans_ail.c    | 116 +++++++++++++++++++-------------------
 fs/xfs/xfs_trans_priv.h   |  11 +---
 4 files changed, 80 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e2c8308d518b56..40021849b42f0a 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -558,7 +558,7 @@ xfs_defer_relog(
 		 * the log threshold once per call.
 		 */
 		if (threshold_lsn == NULLCOMMITLSN) {
-			threshold_lsn = xfs_ail_push_target(log->l_ailp);
+			threshold_lsn = xfs_ail_get_push_target(log->l_ailp);
 			if (threshold_lsn == NULLCOMMITLSN)
 				break;
 		}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 0482b11965e248..971871b84d8436 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -625,6 +625,24 @@ xlog_wait(
 int xlog_wait_on_iclog(struct xlog_in_core *iclog)
 		__releases(iclog->ic_log->l_icloglock);
 
+/* Calculate the distance between two LSNs in bytes */
+static inline uint64_t
+xlog_lsn_sub(
+	struct xlog	*log,
+	xfs_lsn_t	high,
+	xfs_lsn_t	low)
+{
+	uint32_t	hi_cycle = CYCLE_LSN(high);
+	uint32_t	hi_block = BLOCK_LSN(high);
+	uint32_t	lo_cycle = CYCLE_LSN(low);
+	uint32_t	lo_block = BLOCK_LSN(low);
+
+	if (hi_cycle == lo_cycle)
+		return BBTOB(hi_block - lo_block);
+	ASSERT((hi_cycle == lo_cycle + 1) || xlog_is_shutdown(log));
+	return (uint64_t)log->l_logsize - BBTOB(lo_block - hi_block);
+}
+
 /*
  * The LSN is valid so long as it is behind the current LSN. If it isn't, this
  * means that the next log record that includes this metadata could have a
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index a6b6fca1d13852..26d4d9b3e35789 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -398,51 +398,69 @@ xfsaild_push_item(
 /*
  * Compute the LSN that we'd need to push the log tail towards in order to have
  * at least 25% of the log space free.  If the log free space already meets this
- * threshold, this function returns NULLCOMMITLSN.
+ * threshold, this function returns the lowest LSN in the AIL to slowly keep
+ * writeback ticking over and the tail of the log moving forward.
  */
-xfs_lsn_t
-__xfs_ail_push_target(
+static xfs_lsn_t
+xfs_ail_calc_push_target(
 	struct xfs_ail		*ailp)
 {
-	struct xlog	*log = ailp->ail_log;
-	xfs_lsn_t	threshold_lsn = 0;
-	xfs_lsn_t	last_sync_lsn;
-	int		free_blocks;
-	int		free_bytes;
-	int		threshold_block;
-	int		threshold_cycle;
-	int		free_threshold;
-
-	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
-	free_blocks = BTOBBT(free_bytes);
+	struct xlog		*log = ailp->ail_log;
+	struct xfs_log_item	*lip;
+	xfs_lsn_t		target_lsn;
+	xfs_lsn_t		max_lsn;
+	xfs_lsn_t		min_lsn;
+	int32_t			free_bytes;
+	uint32_t		target_block;
+	uint32_t		target_cycle;
+
+	lockdep_assert_held(&ailp->ail_lock);
+
+	lip = xfs_ail_max(ailp);
+	if (!lip)
+		return NULLCOMMITLSN;
+
+	max_lsn = lip->li_lsn;
+	min_lsn = __xfs_ail_min_lsn(ailp);
 
 	/*
-	 * The threshold for the minimum number of free blocks is one quarter of
-	 * the entire log space.
+	 * If we are supposed to push all the items in the AIL, we want to push
+	 * to the current head. We then clear the push flag so that we don't
+	 * keep pushing newly queued items beyond where the push all command was
+	 * run. If the push waiter wants to empty the ail, it should queue
+	 * itself on the ail_empty wait queue.
 	 */
-	free_threshold = log->l_logBBsize >> 2;
-	if (free_blocks >= free_threshold)
-		return NULLCOMMITLSN;
+	if (test_and_clear_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate))
+		return max_lsn;
+
+	/* If someone wants the AIL empty, keep pushing everything we have. */
+	if (waitqueue_active(&ailp->ail_empty))
+		return max_lsn;
 
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
-						&threshold_block);
-	threshold_block += free_threshold;
-	if (threshold_block >= log->l_logBBsize) {
-		threshold_block -= log->l_logBBsize;
-		threshold_cycle += 1;
-	}
-	threshold_lsn = xlog_assign_lsn(threshold_cycle,
-					threshold_block);
 	/*
-	 * Don't pass in an lsn greater than the lsn of the last
-	 * log record known to be on disk. Use a snapshot of the last sync lsn
-	 * so that it doesn't change between the compare and the set.
+	 * Background pushing - attempt to keep 25% of the log free and if we
+	 * have that much free retain the existing target.
 	 */
-	last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
-	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
-		threshold_lsn = last_sync_lsn;
+	free_bytes = log->l_logsize - xlog_lsn_sub(log, max_lsn, min_lsn);
+	if (free_bytes >= log->l_logsize >> 2)
+		return ailp->ail_target;
+
+	target_cycle = CYCLE_LSN(min_lsn);
+	target_block = BLOCK_LSN(min_lsn) + (log->l_logBBsize >> 2);
+	if (target_block >= log->l_logBBsize) {
+		target_block -= log->l_logBBsize;
+		target_cycle += 1;
+	}
+	target_lsn = xlog_assign_lsn(target_cycle, target_block);
+
+	/* Cap the target to the highest LSN known to be in the AIL. */
+	if (XFS_LSN_CMP(target_lsn, max_lsn) > 0)
+		return max_lsn;
 
-	return threshold_lsn;
+	/* If the existing target is higher than the new target, keep it. */
+	if (XFS_LSN_CMP(ailp->ail_target, target_lsn) >= 0)
+		return ailp->ail_target;
+	return target_lsn;
 }
 
 static long
@@ -453,7 +471,6 @@ xfsaild_push(
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	xfs_lsn_t		lsn;
-	xfs_lsn_t		target = NULLCOMMITLSN;
 	long			tout;
 	int			stuck = 0;
 	int			flushing = 0;
@@ -478,25 +495,8 @@ xfsaild_push(
 	}
 
 	spin_lock(&ailp->ail_lock);
-
-	/*
-	 * If we have a sync push waiter, we always have to push till the AIL is
-	 * empty. Update the target to point to the end of the AIL so that
-	 * capture updates that occur after the sync push waiter has gone to
-	 * sleep.
-	 */
-	if (test_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate) ||
-	    waitqueue_active(&ailp->ail_empty)) {
-		lip = xfs_ail_max(ailp);
-		if (lip)
-			target = lip->li_lsn;
-		else
-			clear_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate);
-	} else {
-		target = __xfs_ail_push_target(ailp);
-	}
-
-	if (target == NULLCOMMITLSN)
+	WRITE_ONCE(ailp->ail_target, xfs_ail_calc_push_target(ailp));
+	if (ailp->ail_target == NULLCOMMITLSN)
 		goto out_done;
 
 	/* we're done if the AIL is empty or our push has reached the end */
@@ -506,10 +506,10 @@ xfsaild_push(
 
 	XFS_STATS_INC(mp, xs_push_ail);
 
-	ASSERT(target != NULLCOMMITLSN);
+	ASSERT(ailp->ail_target != NULLCOMMITLSN);
 
 	lsn = lip->li_lsn;
-	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
+	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
 		int	lock_result;
 
 		/*
@@ -595,7 +595,7 @@ xfsaild_push(
 	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
 		ailp->ail_log_flush++;
 
-	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
+	if (!count || XFS_LSN_CMP(lsn, ailp->ail_target) >= 0) {
 		/*
 		 * We reached the target or the AIL is empty, so wait a bit
 		 * longer for I/O to complete and remove pushed items from the
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 9a131e7fae9467..60b4707c3a6583 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -59,6 +59,7 @@ struct xfs_ail {
 	unsigned long		ail_opstate;
 	struct list_head	ail_buf_list;
 	wait_queue_head_t	ail_empty;
+	xfs_lsn_t		ail_target;
 };
 
 /* Push all items out of the AIL immediately. */
@@ -111,15 +112,9 @@ static inline void xfs_ail_push_all(struct xfs_ail *ailp)
 		xfs_ail_push(ailp);
 }
 
-xfs_lsn_t		__xfs_ail_push_target(struct xfs_ail *ailp);
-static inline xfs_lsn_t xfs_ail_push_target(struct xfs_ail *ailp)
+static inline xfs_lsn_t xfs_ail_get_push_target(struct xfs_ail *ailp)
 {
-	xfs_lsn_t	lsn;
-
-	spin_lock(&ailp->ail_lock);
-	lsn = __xfs_ail_push_target(ailp);
-	spin_unlock(&ailp->ail_lock);
-	return lsn;
+	return READ_ONCE(ailp->ail_target);
 }
 
 void			xfs_ail_push_all_sync(struct xfs_ail *ailp);
-- 
2.43.0

