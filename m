Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B088A35948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323762; cv=none; b=iF1FJ8id2roa8yKf1rc6h9x0cKzrwRUkb3EiTxLURvItpve+bejYrAtA+UiEeU/zfbFhOMjgCW94EMJxO8wPh48CbncgHirQ8rx0T3QBeN6SzLOJw3+dFKUglABe8Y6Mx3n1Vj9DmWe2VBow35LBkxxSOVo+KSJ4TZWqxqn56FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323762; c=relaxed/simple;
	bh=cC3KdgQRa9BLXyHiuJiZ/ep2Bb0jxH0Vt+k/CQn9nPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZfwIlM/3uT/RIhyA1ZqWrwl5TMmhsU1ZkZCcyYbICl75aHRAKYPVx32KbqKy/zfjAtgiGDV+rH8T2giXxxTlU7Ay1SKBnmFzCRO4GYgjuDldGe9EnAyYxWPvrDFi+X2RNgXwvb0mCLv6L6HobiqHSDYaSnR416lyiyBxtA98wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=knD1JUcc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="knD1JUcc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=l8yMrVcVLRqKzJA3zRYG2xzdIKAfCCt5sEnfrEro3yg=; b=knD1JUccod7kt2lU65fKiZpomZ
	0orFCCqAYy+X2MRLp4drXSoM+2C4dkBOqJBUqPyWaQ+wPOpbSCTwTr5rPDuGUELEZhv6JeVrxu7cK
	gMmf9GmtK3eBiA1w5dWO4djUjK3Mcs5daNa/sEX3Iy6Wtj8lijvOujbUgHR6cvbBu3et382coUKw+
	n24XM2os9NxrUdPcY0XEtMyTrl6/YkGp1XB4igmVZfEc0Kl1IH8fIckLBefSw6UtPky6+uAuZ1RAA
	6txODerdfdUfQTOCF1rlc8+DvA5TDn77R0AwYahk5d+grhPAnKCGFS4nWePuRgqK8V7njVBbUYPEa
	lbWYyU3Q==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88ch-0000000C7e6-3epm;
	Mon, 13 Oct 2025 02:49:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/17] xfs: use a lockref for the xfs_dquot reference count
Date: Mon, 13 Oct 2025 11:48:06 +0900
Message-ID: <20251013024851.4110053-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024851.4110053-1-hch@lst.de>
References: <20251013024851.4110053-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The xfs_dquot structure currently uses the anti-pattern of using the
in-object lock that protects the content to also serialize reference
count updates for the structure, leading to a cumbersome free path.
This is partiall papered over by the fact that we never free the dquot
directly but always through the LRU.  Switch to use a lockref instead and
move the reference counter manipulations out of q_qlock.

To make this work, xfs_qm_flush_one and xfs_qm_flush_one are converted to
acquire a dquot reference while flushing to integrate with the lockref
"get if not dead" scheme.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_quota_defs.h |  4 +--
 fs/xfs/xfs_dquot.c             | 17 ++++++------
 fs/xfs/xfs_dquot.h             |  6 ++--
 fs/xfs/xfs_qm.c                | 50 ++++++++++++++++------------------
 fs/xfs/xfs_trace.h             |  2 +-
 5 files changed, 37 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 763d941a8420..551d7ae46c5c 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -29,11 +29,9 @@ typedef uint8_t		xfs_dqtype_t;
  * flags for q_flags field in the dquot.
  */
 #define XFS_DQFLAG_DIRTY	(1u << 0)	/* dquot is dirty */
-#define XFS_DQFLAG_FREEING	(1u << 1)	/* dquot is being torn down */
 
 #define XFS_DQFLAG_STRINGS \
-	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
-	{ XFS_DQFLAG_FREEING,	"FREEING" }
+	{ XFS_DQFLAG_DIRTY,	"DIRTY" }
 
 /*
  * We have the possibility of all three quota types being active at once, and
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 97f037fa4181..e53dffe2dcab 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -816,20 +816,17 @@ xfs_qm_dqget_cache_lookup(
 		return NULL;
 	}
 
-	mutex_lock(&dqp->q_qlock);
-	if (dqp->q_flags & XFS_DQFLAG_FREEING) {
-		mutex_unlock(&dqp->q_qlock);
+	if (!lockref_get_not_dead(&dqp->q_lockref)) {
 		mutex_unlock(&qi->qi_tree_lock);
 		trace_xfs_dqget_freeing(dqp);
 		delay(1);
 		goto restart;
 	}
-
-	dqp->q_nrefs++;
 	mutex_unlock(&qi->qi_tree_lock);
 
 	trace_xfs_dqget_hit(dqp);
 	XFS_STATS_INC(mp, xs_qm_dqcachehits);
+	mutex_lock(&dqp->q_qlock);
 	return dqp;
 }
 
@@ -867,7 +864,7 @@ xfs_qm_dqget_cache_insert(
 
 	/* Return a locked dquot to the caller, with a reference taken. */
 	mutex_lock(&dqp->q_qlock);
-	dqp->q_nrefs = 1;
+	lockref_init(&dqp->q_lockref);
 	qi->qi_dquots++;
 
 out_unlock:
@@ -1119,18 +1116,22 @@ void
 xfs_qm_dqput(
 	struct xfs_dquot	*dqp)
 {
-	ASSERT(dqp->q_nrefs > 0);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
 	trace_xfs_dqput(dqp);
 
-	if (--dqp->q_nrefs == 0) {
+	if (lockref_put_or_lock(&dqp->q_lockref))
+		goto out_unlock;
+
+	if (!--dqp->q_lockref.count) {
 		struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
 		trace_xfs_dqput_free(dqp);
 
 		if (list_lru_add_obj(&qi->qi_lru, &dqp->q_lru))
 			XFS_STATS_INC(dqp->q_mount, xs_qm_dquot_unused);
 	}
+	spin_unlock(&dqp->q_lockref.lock);
+out_unlock:
 	mutex_unlock(&dqp->q_qlock);
 }
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 10c39b8cdd03..c56fbc39d089 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -71,7 +71,7 @@ struct xfs_dquot {
 	xfs_dqtype_t		q_type;
 	uint16_t		q_flags;
 	xfs_dqid_t		q_id;
-	uint			q_nrefs;
+	struct lockref		q_lockref;
 	int			q_bufoffset;
 	xfs_daddr_t		q_blkno;
 	xfs_fileoff_t		q_fileoffset;
@@ -231,9 +231,7 @@ void xfs_dquot_detach_buf(struct xfs_dquot *dqp);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
-	mutex_lock(&dqp->q_qlock);
-	dqp->q_nrefs++;
-	mutex_unlock(&dqp->q_qlock);
+	lockref_get(&dqp->q_lockref);
 	return dqp;
 }
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ca3cbff9d873..0d2243d549ad 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -126,14 +126,16 @@ xfs_qm_dqpurge(
 	void			*data)
 {
 	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
-	int			error = -EAGAIN;
 
-	mutex_lock(&dqp->q_qlock);
-	if ((dqp->q_flags & XFS_DQFLAG_FREEING) || dqp->q_nrefs != 0)
-		goto out_unlock;
-
-	dqp->q_flags |= XFS_DQFLAG_FREEING;
+	spin_lock(&dqp->q_lockref.lock);
+	if (dqp->q_lockref.count > 0 || __lockref_is_dead(&dqp->q_lockref)) {
+		spin_unlock(&dqp->q_lockref.lock);
+		return -EAGAIN;
+	}
+	lockref_mark_dead(&dqp->q_lockref);
+	spin_unlock(&dqp->q_lockref.lock);
 
+	mutex_lock(&dqp->q_qlock);
 	xfs_qm_dqunpin_wait(dqp);
 	xfs_dqflock(dqp);
 
@@ -144,6 +146,7 @@ xfs_qm_dqpurge(
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
+		int		error;
 
 		/*
 		 * We don't care about getting disk errors here. We need
@@ -151,9 +154,9 @@ xfs_qm_dqpurge(
 		 */
 		error = xfs_dquot_use_attached_buf(dqp, &bp);
 		if (error == -EAGAIN) {
-			xfs_dqfunlock(dqp);
-			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
-			goto out_unlock;
+			/* resurrect the refcount from the dead. */
+			dqp->q_lockref.count = 0;
+			goto out_funlock;
 		}
 		if (!bp)
 			goto out_funlock;
@@ -192,10 +195,6 @@ xfs_qm_dqpurge(
 
 	xfs_qm_dqdestroy(dqp);
 	return 0;
-
-out_unlock:
-	mutex_unlock(&dqp->q_qlock);
-	return error;
 }
 
 /*
@@ -468,7 +467,7 @@ xfs_qm_dquot_isolate(
 	struct xfs_qm_isolate	*isol = arg;
 	enum lru_status		ret = LRU_SKIP;
 
-	if (!mutex_trylock(&dqp->q_qlock))
+	if (!spin_trylock(&dqp->q_lockref.lock))
 		goto out_miss_busy;
 
 	/*
@@ -476,7 +475,7 @@ xfs_qm_dquot_isolate(
 	 * from the LRU, leave it for the freeing task to complete the freeing
 	 * process rather than risk it being free from under us here.
 	 */
-	if (dqp->q_flags & XFS_DQFLAG_FREEING)
+	if (__lockref_is_dead(&dqp->q_lockref))
 		goto out_miss_unlock;
 
 	/*
@@ -485,16 +484,15 @@ xfs_qm_dquot_isolate(
 	 * again.
 	 */
 	ret = LRU_ROTATE;
-	if (XFS_DQ_IS_DIRTY(dqp) || atomic_read(&dqp->q_pincount) > 0) {
+	if (XFS_DQ_IS_DIRTY(dqp) || atomic_read(&dqp->q_pincount) > 0)
 		goto out_miss_unlock;
-	}
 
 	/*
 	 * This dquot has acquired a reference in the meantime remove it from
 	 * the freelist and try again.
 	 */
-	if (dqp->q_nrefs) {
-		mutex_unlock(&dqp->q_qlock);
+	if (dqp->q_lockref.count) {
+		spin_unlock(&dqp->q_lockref.lock);
 		XFS_STATS_INC(dqp->q_mount, xs_qm_dqwants);
 
 		trace_xfs_dqreclaim_want(dqp);
@@ -518,10 +516,9 @@ xfs_qm_dquot_isolate(
 	/*
 	 * Prevent lookups now that we are past the point of no return.
 	 */
-	dqp->q_flags |= XFS_DQFLAG_FREEING;
-	mutex_unlock(&dqp->q_qlock);
+	lockref_mark_dead(&dqp->q_lockref);
+	spin_unlock(&dqp->q_lockref.lock);
 
-	ASSERT(dqp->q_nrefs == 0);
 	list_lru_isolate_move(lru, &dqp->q_lru, &isol->dispose);
 	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot_unused);
 	trace_xfs_dqreclaim_done(dqp);
@@ -529,7 +526,7 @@ xfs_qm_dquot_isolate(
 	return LRU_REMOVED;
 
 out_miss_unlock:
-	mutex_unlock(&dqp->q_qlock);
+	spin_unlock(&dqp->q_lockref.lock);
 out_miss_busy:
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
@@ -1466,9 +1463,10 @@ xfs_qm_flush_one(
 	struct xfs_buf		*bp = NULL;
 	int			error = 0;
 
+	if (!lockref_get_not_dead(&dqp->q_lockref))
+		return 0;
+
 	mutex_lock(&dqp->q_qlock);
-	if (dqp->q_flags & XFS_DQFLAG_FREEING)
-		goto out_unlock;
 	if (!XFS_DQ_IS_DIRTY(dqp))
 		goto out_unlock;
 
@@ -1488,7 +1486,7 @@ xfs_qm_flush_one(
 		xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
 out_unlock:
-	mutex_unlock(&dqp->q_qlock);
+	xfs_qm_dqput(dqp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 79b8641880ab..46d21eb11ccb 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1350,7 +1350,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		__entry->id = dqp->q_id;
 		__entry->type = dqp->q_type;
 		__entry->flags = dqp->q_flags;
-		__entry->nrefs = dqp->q_nrefs;
+		__entry->nrefs = data_race(dqp->q_lockref.count);
 
 		__entry->res_bcount = dqp->q_blk.reserved;
 		__entry->res_rtbcount = dqp->q_rtb.reserved;
-- 
2.47.3

