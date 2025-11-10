Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E429F30E0C5
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781037; cv=none; b=ABIvwZiWprkEYXDfqF9elTQOGbnniwmYRq61V+KmsYvfmyjoO3G3CgoeqM+d8xj/+CpezLJfDUOESWpXGzJq0pKC6YSJa3ka0ufBIHWpEbVaUEMGF39uAfZVuAZsuzVMCCk47lOKdOpjPgQFWEk2GtV5/TvhrIjTd2cgjADViyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781037; c=relaxed/simple;
	bh=/Z79Ven8qoOKaaZbpp8EiI9uLkpItNFJiYhwItPJFl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MECxRZ3aojw02epvx3dOwN2u4Dc0U/BQyYpmuGaxCzHdpPd9Jc88fnGSt+9KYfUPeA7hYX0XKeoOkF+/DWmj+4kysDBt2DmeaaWICejwSetqYusYsuCLEL64uv9g2n2dsZulIswA0wH42W1T2PIKxfpjxn4vwS2jtDR8EtXVicA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VGF62mU6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VGF62mU6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=88Oi2QsqFx589BOqLQfBu01HPtwTMtShXfgbX162DRQ=; b=VGF62mU6h+FZ9TJyz1pVlNPdUn
	5/bpbzkJdzXrwlfZv7uSRRrPMO8NyqWIU6+J1ynAG0LTKsDvi+f0z8/7kjrqgzEEhVhd3UPxVhB+z
	QFchwNFsIREprJltTvrlnDS1mkEnhp3mHzVFViPQyMu9EiA8NWLxdlJ5G18F7u0iSNGyvNGsvvlWi
	ZDY7cYgPkudcy7Di6lZZSyLT2885vh3eI0HL27Gd0YHA/OEss+9OO0e6zJzJTTOrxjmJs4Jjq7Dzj
	mKEyjGsHGi4cQXqFAz4hvIL2JXrr1WA0LbZTYQkr0g47N4vKs5pukrMGnKJkZhFjsAUykJFWTuZ5d
	csRM7Q9g==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsB-00000005USW-04Br;
	Mon, 10 Nov 2025 13:23:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 04/18] xfs: remove xfs_dqunlock and friends
Date: Mon, 10 Nov 2025 14:22:56 +0100
Message-ID: <20251110132335.409466-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110132335.409466-1-hch@lst.de>
References: <20251110132335.409466-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There's really no point in wrapping the basic mutex operations.  Remove
the wrapper to ease lock analysis annotations and make the code a litte
easier to read.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c             |  4 ++--
 fs/xfs/scrub/quota_repair.c      |  6 +++---
 fs/xfs/scrub/quotacheck_repair.c |  8 ++++----
 fs/xfs/xfs_dquot.c               | 14 +++++++-------
 fs/xfs/xfs_dquot.h               | 19 ++-----------------
 fs/xfs/xfs_dquot_item.c          |  6 +++---
 fs/xfs/xfs_qm.c                  | 30 +++++++++++++++---------------
 fs/xfs/xfs_qm_syscalls.c         |  4 ++--
 fs/xfs/xfs_trans_dquot.c         | 18 +++++++++---------
 9 files changed, 47 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 58d6d4ed2853..c78cf9f96cf6 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -158,9 +158,9 @@ xchk_quota_item(
 	 * However, dqiterate gave us a locked dquot, so drop the dquot lock to
 	 * get the ILOCK.
 	 */
-	xfs_dqunlock(dq);
+	mutex_unlock(&dq->q_qlock);
 	xchk_ilock(sc, XFS_ILOCK_SHARED);
-	xfs_dqlock(dq);
+	mutex_lock(&dq->q_qlock);
 
 	/*
 	 * Except for the root dquot, the actual dquot we got must either have
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 8f4c8d41f308..8c89c6cc2950 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -187,9 +187,9 @@ xrep_quota_item(
 	 * dqiterate gave us a locked dquot, so drop the dquot lock to get the
 	 * ILOCK_EXCL.
 	 */
-	xfs_dqunlock(dq);
+	mutex_unlock(&dq->q_qlock);
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
-	xfs_dqlock(dq);
+	mutex_lock(&dq->q_qlock);
 
 	error = xrep_quota_item_bmap(sc, dq, &dirty);
 	xchk_iunlock(sc, XFS_ILOCK_EXCL);
@@ -258,7 +258,7 @@ xrep_quota_item(
 	}
 	xfs_trans_log_dquot(sc->tp, dq);
 	error = xfs_trans_roll(&sc->tp);
-	xfs_dqlock(dq);
+	mutex_lock(&dq->q_qlock);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index dd8554c755b5..415314911499 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -53,9 +53,9 @@ xqcheck_commit_dquot(
 	int			error = 0;
 
 	/* Unlock the dquot just long enough to allocate a transaction. */
-	xfs_dqunlock(dq);
+	mutex_unlock(&dq->q_qlock);
 	error = xchk_trans_alloc(xqc->sc, 0);
-	xfs_dqlock(dq);
+	mutex_lock(&dq->q_qlock);
 	if (error)
 		return error;
 
@@ -122,7 +122,7 @@ xqcheck_commit_dquot(
 	 * dquot).
 	 */
 	error = xrep_trans_commit(xqc->sc);
-	xfs_dqlock(dq);
+	mutex_lock(&dq->q_qlock);
 	return error;
 
 out_unlock:
@@ -131,7 +131,7 @@ xqcheck_commit_dquot(
 	xchk_trans_cancel(xqc->sc);
 
 	/* Re-lock the dquot so the caller can put the reference. */
-	xfs_dqlock(dq);
+	mutex_lock(&dq->q_qlock);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 79e14ee1d7a0..c2326cee7fae 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -31,7 +31,7 @@
  *
  * ip->i_lock
  *   qi->qi_tree_lock
- *     dquot->q_qlock (xfs_dqlock() and friends)
+ *     dquot->q_qlock
  *       dquot->q_flush (xfs_dqflock() and friends)
  *       qi->qi_lru_lock
  *
@@ -816,9 +816,9 @@ xfs_qm_dqget_cache_lookup(
 		return NULL;
 	}
 
-	xfs_dqlock(dqp);
+	mutex_lock(&dqp->q_qlock);
 	if (dqp->q_flags & XFS_DQFLAG_FREEING) {
-		xfs_dqunlock(dqp);
+		mutex_unlock(&dqp->q_qlock);
 		mutex_unlock(&qi->qi_tree_lock);
 		trace_xfs_dqget_freeing(dqp);
 		delay(1);
@@ -865,7 +865,7 @@ xfs_qm_dqget_cache_insert(
 	}
 
 	/* Return a locked dquot to the caller, with a reference taken. */
-	xfs_dqlock(dqp);
+	mutex_lock(&dqp->q_qlock);
 	dqp->q_nrefs = 1;
 	qi->qi_dquots++;
 
@@ -1051,7 +1051,7 @@ xfs_qm_dqget_inode(
 		if (dqp1) {
 			xfs_qm_dqdestroy(dqp);
 			dqp = dqp1;
-			xfs_dqlock(dqp);
+			mutex_lock(&dqp->q_qlock);
 			goto dqret;
 		}
 	} else {
@@ -1136,7 +1136,7 @@ xfs_qm_dqput(
 		if (list_lru_add_obj(&qi->qi_lru, &dqp->q_lru))
 			XFS_STATS_INC(dqp->q_mount, xs_qm_dquot_unused);
 	}
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 }
 
 /*
@@ -1152,7 +1152,7 @@ xfs_qm_dqrele(
 
 	trace_xfs_dqrele(dqp);
 
-	xfs_dqlock(dqp);
+	mutex_lock(&dqp->q_qlock);
 	/*
 	 * We don't care to flush it if the dquot is dirty here.
 	 * That will create stutters that we want to avoid.
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 61217adf5ba5..10c39b8cdd03 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -121,21 +121,6 @@ static inline void xfs_dqfunlock(struct xfs_dquot *dqp)
 	complete(&dqp->q_flush);
 }
 
-static inline int xfs_dqlock_nowait(struct xfs_dquot *dqp)
-{
-	return mutex_trylock(&dqp->q_qlock);
-}
-
-static inline void xfs_dqlock(struct xfs_dquot *dqp)
-{
-	mutex_lock(&dqp->q_qlock);
-}
-
-static inline void xfs_dqunlock(struct xfs_dquot *dqp)
-{
-	mutex_unlock(&dqp->q_qlock);
-}
-
 static inline int
 xfs_dquot_type(const struct xfs_dquot *dqp)
 {
@@ -246,9 +231,9 @@ void xfs_dquot_detach_buf(struct xfs_dquot *dqp);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
-	xfs_dqlock(dqp);
+	mutex_lock(&dqp->q_qlock);
 	dqp->q_nrefs++;
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 	return dqp;
 }
 
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 271b195ebb93..b374cd9f1900 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -132,7 +132,7 @@ xfs_qm_dquot_logitem_push(
 	if (atomic_read(&dqp->q_pincount) > 0)
 		return XFS_ITEM_PINNED;
 
-	if (!xfs_dqlock_nowait(dqp))
+	if (!mutex_trylock(&dqp->q_qlock))
 		return XFS_ITEM_LOCKED;
 
 	/*
@@ -177,7 +177,7 @@ xfs_qm_dquot_logitem_push(
 out_relock_ail:
 	spin_lock(&lip->li_ailp->ail_lock);
 out_unlock:
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 	return rval;
 }
 
@@ -195,7 +195,7 @@ xfs_qm_dquot_logitem_release(
 	 * transaction layer, within trans_commit. Hence, no LI_HOLD flag
 	 * for the logitem.
 	 */
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 18a19947bbdb..3e88bea9a465 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -128,7 +128,7 @@ xfs_qm_dqpurge(
 	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
 	int			error = -EAGAIN;
 
-	xfs_dqlock(dqp);
+	mutex_lock(&dqp->q_qlock);
 	if ((dqp->q_flags & XFS_DQFLAG_FREEING) || dqp->q_nrefs != 0)
 		goto out_unlock;
 
@@ -177,7 +177,7 @@ xfs_qm_dqpurge(
 		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
 
 	xfs_dqfunlock(dqp);
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 
 	radix_tree_delete(xfs_dquot_tree(qi, xfs_dquot_type(dqp)), dqp->q_id);
 	qi->qi_dquots--;
@@ -194,7 +194,7 @@ xfs_qm_dqpurge(
 	return 0;
 
 out_unlock:
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 	return error;
 }
 
@@ -329,7 +329,7 @@ xfs_qm_dqattach_one(
 	 * that the dquot returned is the one that should go in the inode.
 	 */
 	*IO_idqpp = dqp;
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 	return 0;
 }
 
@@ -468,7 +468,7 @@ xfs_qm_dquot_isolate(
 	struct xfs_qm_isolate	*isol = arg;
 	enum lru_status		ret = LRU_SKIP;
 
-	if (!xfs_dqlock_nowait(dqp))
+	if (!mutex_trylock(&dqp->q_qlock))
 		goto out_miss_busy;
 
 	/*
@@ -494,7 +494,7 @@ xfs_qm_dquot_isolate(
 	 * the freelist and try again.
 	 */
 	if (dqp->q_nrefs) {
-		xfs_dqunlock(dqp);
+		mutex_unlock(&dqp->q_qlock);
 		XFS_STATS_INC(dqp->q_mount, xs_qm_dqwants);
 
 		trace_xfs_dqreclaim_want(dqp);
@@ -519,7 +519,7 @@ xfs_qm_dquot_isolate(
 	 * Prevent lookups now that we are past the point of no return.
 	 */
 	dqp->q_flags |= XFS_DQFLAG_FREEING;
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 
 	ASSERT(dqp->q_nrefs == 0);
 	list_lru_isolate_move(lru, &dqp->q_lru, &isol->dispose);
@@ -529,7 +529,7 @@ xfs_qm_dquot_isolate(
 	return LRU_REMOVED;
 
 out_miss_unlock:
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 out_miss_busy:
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
@@ -1467,7 +1467,7 @@ xfs_qm_flush_one(
 	struct xfs_buf		*bp = NULL;
 	int			error = 0;
 
-	xfs_dqlock(dqp);
+	mutex_lock(&dqp->q_qlock);
 	if (dqp->q_flags & XFS_DQFLAG_FREEING)
 		goto out_unlock;
 	if (!XFS_DQ_IS_DIRTY(dqp))
@@ -1489,7 +1489,7 @@ xfs_qm_flush_one(
 		xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
 out_unlock:
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 	return error;
 }
 
@@ -1952,7 +1952,7 @@ xfs_qm_vop_dqalloc(
 			/*
 			 * Get the ilock in the right order.
 			 */
-			xfs_dqunlock(uq);
+			mutex_unlock(&uq->q_qlock);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
@@ -1974,7 +1974,7 @@ xfs_qm_vop_dqalloc(
 				ASSERT(error != -ENOENT);
 				goto error_rele;
 			}
-			xfs_dqunlock(gq);
+			mutex_unlock(&gq->q_qlock);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
@@ -1992,7 +1992,7 @@ xfs_qm_vop_dqalloc(
 				ASSERT(error != -ENOENT);
 				goto error_rele;
 			}
-			xfs_dqunlock(pq);
+			mutex_unlock(&pq->q_qlock);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
@@ -2079,7 +2079,7 @@ xfs_qm_vop_chown(
 	 * back now.
 	 */
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	xfs_dqlock(prevdq);
+	mutex_lock(&prevdq->q_qlock);
 	if (isrt) {
 		ASSERT(prevdq->q_rtb.reserved >= ip->i_delayed_blks);
 		prevdq->q_rtb.reserved -= ip->i_delayed_blks;
@@ -2087,7 +2087,7 @@ xfs_qm_vop_chown(
 		ASSERT(prevdq->q_blk.reserved >= ip->i_delayed_blks);
 		prevdq->q_blk.reserved -= ip->i_delayed_blks;
 	}
-	xfs_dqunlock(prevdq);
+	mutex_unlock(&prevdq->q_qlock);
 
 	/*
 	 * Take an extra reference, because the inode is going to keep
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 0c78f30fa4a3..59ef382900fe 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -303,13 +303,13 @@ xfs_qm_scall_setqlim(
 	}
 
 	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
 	if (error)
 		goto out_rele;
 
-	xfs_dqlock(dqp);
+	mutex_lock(&dqp->q_qlock);
 	xfs_trans_dqjoin(tp, dqp);
 
 	/*
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 765456bf3428..c842ce06acd6 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -393,7 +393,7 @@ xfs_trans_dqlockedjoin(
 	unsigned int		i;
 	ASSERT(q[0].qt_dquot != NULL);
 	if (q[1].qt_dquot == NULL) {
-		xfs_dqlock(q[0].qt_dquot);
+		mutex_lock(&q[0].qt_dquot->q_qlock);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
 	} else if (q[2].qt_dquot == NULL) {
 		xfs_dqlock2(q[0].qt_dquot, q[1].qt_dquot);
@@ -693,7 +693,7 @@ xfs_trans_unreserve_and_mod_dquots(
 			locked = already_locked;
 			if (qtrx->qt_blk_res) {
 				if (!locked) {
-					xfs_dqlock(dqp);
+					mutex_lock(&dqp->q_qlock);
 					locked = true;
 				}
 				dqp->q_blk.reserved -=
@@ -701,7 +701,7 @@ xfs_trans_unreserve_and_mod_dquots(
 			}
 			if (qtrx->qt_ino_res) {
 				if (!locked) {
-					xfs_dqlock(dqp);
+					mutex_lock(&dqp->q_qlock);
 					locked = true;
 				}
 				dqp->q_ino.reserved -=
@@ -710,14 +710,14 @@ xfs_trans_unreserve_and_mod_dquots(
 
 			if (qtrx->qt_rtblk_res) {
 				if (!locked) {
-					xfs_dqlock(dqp);
+					mutex_lock(&dqp->q_qlock);
 					locked = true;
 				}
 				dqp->q_rtb.reserved -=
 					(xfs_qcnt_t)qtrx->qt_rtblk_res;
 			}
 			if (locked && !already_locked)
-				xfs_dqunlock(dqp);
+				mutex_unlock(&dqp->q_qlock);
 
 		}
 	}
@@ -820,7 +820,7 @@ xfs_trans_dqresv(
 	struct xfs_dquot_res	*blkres;
 	struct xfs_quota_limits	*qlim;
 
-	xfs_dqlock(dqp);
+	mutex_lock(&dqp->q_qlock);
 
 	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
 
@@ -887,16 +887,16 @@ xfs_trans_dqresv(
 	    XFS_IS_CORRUPT(mp, dqp->q_ino.reserved < dqp->q_ino.count))
 		goto error_corrupt;
 
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 	return 0;
 
 error_return:
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 	if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
 		return -ENOSPC;
 	return -EDQUOT;
 error_corrupt:
-	xfs_dqunlock(dqp);
+	mutex_unlock(&dqp->q_qlock);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	xfs_fs_mark_sick(mp, XFS_SICK_FS_QUOTACHECK);
 	return -EFSCORRUPTED;
-- 
2.47.3

