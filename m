Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962E03644A0
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 07:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774252273; cv=none; b=HBzKGxXB8nxdpkmBoOL/Cr+P5Bc5IxjpAfo6li3Yv2LN5LGEenzyhhSkI3lJXeGv0Nq72rFkz9VCbavnDj3D4PouwAPvpRwGyC+U7MCkGmbtv54IJEjilWWwGEq3M/mMskco20m9su7LrGPAlbDHfnKbx64UbLYeWio02OVT2/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774252273; c=relaxed/simple;
	bh=mwpbjjrcBhD11kq1L45CT711Ybxj0YZu3dlt+bh1kBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDYzQzG8mN84tnfVRqTSara0phmH9qr8FERTZZ7bc8mZalcdfW5zXn9ffcFJNta/MJoWc+0lM8YVJcY8Y777dNR7gyXThi5OaUn7uB0f0YRazLClcKyiua9Lro0aQgjhIrLY20xT2Ut/q/wvO5P41yOf+DWBXyjd7pCiYwQ1I9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LnKML6pY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LnKML6pY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ByIPFo8zH0JqEV4j633meezmmE0MLBVT28BFCQIA/Xo=; b=LnKML6pYuq9DAAjzWxK8CocywL
	Oc5aj3a13hevShz9g1oqRDA3V0YoG0YzLgDJsiv7Jb9s8V3bCDe8r45h2qEGA23BHBWoPUDALLeDb
	B7uLQhhPffmqIKlG14XO72vlebkdVbp/Fk8Xb/GECuXUnfMPPAR9nhqx16uHLCZ0VvHFgMDswRSIQ
	FVYW91MPS9fna+KcufTju7w4NB6NcPhFnxzGMP1l8P6Kee0GM71Q0ez7H8Vn/HKvvBrl7uUTz9KaW
	lNM/HnTYXCgd9py31VPEYUzX4HcDXTEVcMvMOQIXiKCYqc+k4uBzXBgoLHcBVn1bdY8ufJ/skAwfz
	IvP1Tu3g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4a45-0000000GEfy-3Zm0;
	Mon, 23 Mar 2026 07:51:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 1/4] xfs: don't keep a reference for buffers on the LRU
Date: Mon, 23 Mar 2026 08:50:51 +0100
Message-ID: <20260323075102.2952705-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323075102.2952705-1-hch@lst.de>
References: <20260323075102.2952705-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the buffer cache adds a reference to b_hold for buffers that
are on the LRU.  This seems to go all the way back and allows releasing
buffers from the LRU using xfs_buf_rele.  But it makes xfs_buf_rele
really complicated in differs from how other LRUs are implemented in
Linux.

Switch to not having a reference for buffers in the LRU, and use a
separate negative hold value to mark buffers as dead.  This simplifies
xfs_buf_rele, which now just deal with the last "real" reference,
and prepares for using the lockref primitive.

This also removes the b_lock protection for removing buffers from the
buffer hash.  This is the desired outcome because the rhashtable is
fully internally synchronized, and previously the lock was mostly
held out of ordering constrains in xfs_buf_rele_cached.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 134 +++++++++++++++++------------------------------
 fs/xfs/xfs_buf.h |   8 +--
 2 files changed, 50 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d2f3c50d80e7..61e393ac4952 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -80,11 +80,8 @@ xfs_buf_stale(
 
 	spin_lock(&bp->b_lock);
 	atomic_set(&bp->b_lru_ref, 0);
-	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
-	    (list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru)))
-		bp->b_hold--;
-
-	ASSERT(bp->b_hold >= 1);
+	if (bp->b_hold >= 0)
+		list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
 	spin_unlock(&bp->b_lock);
 }
 
@@ -442,7 +439,7 @@ xfs_buf_try_hold(
 	struct xfs_buf		*bp)
 {
 	spin_lock(&bp->b_lock);
-	if (bp->b_hold == 0) {
+	if (bp->b_hold == -1) {
 		spin_unlock(&bp->b_lock);
 		return false;
 	}
@@ -862,76 +859,24 @@ xfs_buf_hold(
 }
 
 static void
-xfs_buf_rele_uncached(
-	struct xfs_buf		*bp)
-{
-	ASSERT(list_empty(&bp->b_lru));
-
-	spin_lock(&bp->b_lock);
-	if (--bp->b_hold) {
-		spin_unlock(&bp->b_lock);
-		return;
-	}
-	spin_unlock(&bp->b_lock);
-	xfs_buf_free(bp);
-}
-
-static void
-xfs_buf_rele_cached(
+xfs_buf_destroy(
 	struct xfs_buf		*bp)
 {
-	struct xfs_buftarg	*btp = bp->b_target;
-	struct xfs_perag	*pag = bp->b_pag;
-	struct xfs_buf_cache	*bch = xfs_buftarg_buf_cache(btp, pag);
-	bool			freebuf = false;
-
-	trace_xfs_buf_rele(bp, _RET_IP_);
-
-	spin_lock(&bp->b_lock);
-	ASSERT(bp->b_hold >= 1);
-	if (bp->b_hold > 1) {
-		bp->b_hold--;
-		goto out_unlock;
-	}
+	ASSERT(bp->b_hold < 0);
+	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 
-	/* we are asked to drop the last reference */
-	if (atomic_read(&bp->b_lru_ref)) {
-		/*
-		 * If the buffer is added to the LRU, keep the reference to the
-		 * buffer for the LRU and clear the (now stale) dispose list
-		 * state flag, else drop the reference.
-		 */
-		if (list_lru_add_obj(&btp->bt_lru, &bp->b_lru))
-			bp->b_state &= ~XFS_BSTATE_DISPOSE;
-		else
-			bp->b_hold--;
-	} else {
-		bp->b_hold--;
-		/*
-		 * most of the time buffers will already be removed from the
-		 * LRU, so optimise that case by checking for the
-		 * XFS_BSTATE_DISPOSE flag indicating the last list the buffer
-		 * was on was the disposal list
-		 */
-		if (!(bp->b_state & XFS_BSTATE_DISPOSE)) {
-			list_lru_del_obj(&btp->bt_lru, &bp->b_lru);
-		} else {
-			ASSERT(list_empty(&bp->b_lru));
-		}
+	if (!xfs_buf_is_uncached(bp)) {
+		struct xfs_buf_cache	*bch =
+			xfs_buftarg_buf_cache(bp->b_target, bp->b_pag);
 
-		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 		rhashtable_remove_fast(&bch->bc_hash, &bp->b_rhash_head,
 				xfs_buf_hash_params);
-		if (pag)
-			xfs_perag_put(pag);
-		freebuf = true;
-	}
 
-out_unlock:
-	spin_unlock(&bp->b_lock);
+		if (bp->b_pag)
+			xfs_perag_put(bp->b_pag);
+	}
 
-	if (freebuf)
-		xfs_buf_free(bp);
+	xfs_buf_free(bp);
 }
 
 /*
@@ -942,10 +887,22 @@ xfs_buf_rele(
 	struct xfs_buf		*bp)
 {
 	trace_xfs_buf_rele(bp, _RET_IP_);
-	if (xfs_buf_is_uncached(bp))
-		xfs_buf_rele_uncached(bp);
-	else
-		xfs_buf_rele_cached(bp);
+
+	spin_lock(&bp->b_lock);
+	if (!--bp->b_hold) {
+		if (xfs_buf_is_uncached(bp) || !atomic_read(&bp->b_lru_ref))
+			goto kill;
+		list_lru_add_obj(&bp->b_target->bt_lru, &bp->b_lru);
+	}
+	spin_unlock(&bp->b_lock);
+	return;
+
+kill:
+	bp->b_hold = -1;
+	list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
+	spin_unlock(&bp->b_lock);
+
+	xfs_buf_destroy(bp);
 }
 
 /*
@@ -1254,9 +1211,11 @@ xfs_buf_ioerror_alert(
 
 /*
  * To simulate an I/O failure, the buffer must be locked and held with at least
- * three references. The LRU reference is dropped by the stale call. The buf
- * item reference is dropped via ioend processing. The third reference is owned
- * by the caller and is dropped on I/O completion if the buffer is XBF_ASYNC.
+ * two references.
+ *
+ * The buf item reference is dropped via ioend processing. The second reference
+ * is owned by the caller and is dropped on I/O completion if the buffer is
+ * XBF_ASYNC.
  */
 void
 xfs_buf_ioend_fail(
@@ -1514,19 +1473,14 @@ xfs_buftarg_drain_rele(
 
 	if (!spin_trylock(&bp->b_lock))
 		return LRU_SKIP;
-	if (bp->b_hold > 1) {
+	if (bp->b_hold > 0) {
 		/* need to wait, so skip it this pass */
 		spin_unlock(&bp->b_lock);
 		trace_xfs_buf_drain_buftarg(bp, _RET_IP_);
 		return LRU_SKIP;
 	}
 
-	/*
-	 * clear the LRU reference count so the buffer doesn't get
-	 * ignored in xfs_buf_rele().
-	 */
-	atomic_set(&bp->b_lru_ref, 0);
-	bp->b_state |= XFS_BSTATE_DISPOSE;
+	bp->b_hold = -1;
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lock);
 	return LRU_REMOVED;
@@ -1581,7 +1535,7 @@ xfs_buftarg_drain(
 "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
 					(long long)xfs_buf_daddr(bp));
 			}
-			xfs_buf_rele(bp);
+			xfs_buf_destroy(bp);
 		}
 		if (loop++ != 0)
 			delay(100);
@@ -1625,7 +1579,17 @@ xfs_buftarg_isolate(
 		return LRU_ROTATE;
 	}
 
-	bp->b_state |= XFS_BSTATE_DISPOSE;
+	/*
+	 * If the buffer is in use, remove it from the LRU for now as we can't
+	 * free it.  It will be freed when the last reference drops.
+	 */
+	if (bp->b_hold > 0) {
+		list_lru_isolate(lru, &bp->b_lru);
+		spin_unlock(&bp->b_lock);
+		return LRU_REMOVED;
+	}
+
+	bp->b_hold = -1;
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lock);
 	return LRU_REMOVED;
@@ -1647,7 +1611,7 @@ xfs_buftarg_shrink_scan(
 		struct xfs_buf *bp;
 		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
 		list_del_init(&bp->b_lru);
-		xfs_buf_rele(bp);
+		xfs_buf_destroy(bp);
 	}
 
 	return freed;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index e25cd2a160f3..e7324d58bd96 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -68,11 +68,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_INCORE,		"INCORE" }, \
 	{ XBF_TRYLOCK,		"TRYLOCK" }
 
-/*
- * Internal state flags.
- */
-#define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
-
 struct xfs_buf_cache {
 	struct rhashtable	bc_hash;
 };
@@ -159,7 +154,7 @@ struct xfs_buf {
 
 	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
 	int			b_length;	/* size of buffer in BBs */
-	unsigned int		b_hold;		/* reference count */
+	int			b_hold;		/* reference count */
 	atomic_t		b_lru_ref;	/* lru reclaim ref count */
 	xfs_buf_flags_t		b_flags;	/* status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
@@ -170,7 +165,6 @@ struct xfs_buf {
 	 */
 	struct list_head	b_lru;		/* lru list */
 	spinlock_t		b_lock;		/* internal state lock */
-	unsigned int		b_state;	/* internal state flags */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;
-- 
2.47.3

