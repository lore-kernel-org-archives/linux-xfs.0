Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29103A0EA6
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675745; cv=none; b=hbiSeaxR8qxpM45gWCU9NA27/+dlhOcM+GZKSDoE0dI7fxS0ApsjsFQ+x9U+9JY0a+0mwtNVvCEyG9lPDu/QPFoFN55IBK4VZEgg4ThVh6YDxIl5MFL+5HRW/gI3/ds5aVky0e6SOmul3vVyPDPtGz7HFUQNlNwmovMzGOcd0Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675745; c=relaxed/simple;
	bh=5+uONNnlfyKYQ8/nAud9Gwlzt6A+Lt8PjRBMV/bKz98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bn8cEY38y6EV6yFhaVjcxaze40bbwVVCirzs+42j9cirkL9DisduZe+4Y5kgEOeXUI1aShPkMHFQ25/12//FU0OGmWUh7rW1J58ALbmRtiI85Zj0IS6nDB3lHiKzGkHx32BsauvGEa7GJNARCEPpZfF0AoVxmN4G8zL4G4WvxoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h0+amdwd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h0+amdwd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JEkpyHB6RtwiRBsPLUj2KIIWL5+6YiD2Gf2HZ/Okj1Y=; b=h0+amdwdZt0jAXL6iPytZOam5U
	C/8rV9nbxkdEms4+ex2NBeqFbpaiU6iwbBKEbEvJWC6eXJowoQsTOLFbEpSZ1mxxzMFFZKD2Ut8HD
	dAg6gOM3nxgep6xkOznuVDqGPWLL/hDKopsmTTNvhyGN3IkzVpjFGvg3NiNTeOhmg5elK0NI7CUon
	mmmuQKrREVKiHLvZ3aTcP+IIjHXomlkgIdj72PuPItRfI/6yQIoszdTBd8TByDsjwedJw7RfYRHyB
	jDMMM9H+42XVkWLEgf5cMbu/BVR5NwrioF7Hjyl3u51U2j69AsbOegTu6/V1fMAs5tGw15jR3Cxcd
	1CT4gJrA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2A5G-00000004MKk-3p6k;
	Mon, 16 Mar 2026 15:42:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 1/3] xfs: use a lockref for the buffer reference count
Date: Mon, 16 Mar 2026 16:41:33 +0100
Message-ID: <20260316154216.1598410-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316154216.1598410-1-hch@lst.de>
References: <20260316154216.1598410-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The lockref structure allows incrementing/decrementing counters like
an atomic_t for the fast path, while still allowing complex slow path
operations as if the counter was protected by a lock.  The only slow
path operations that actually need to take the lock are the final
put, LRU evictions and marking a buffer stale.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c   | 79 ++++++++++++++++++----------------------------
 fs/xfs/xfs_buf.h   |  4 +--
 fs/xfs/xfs_trace.h | 10 +++---
 3 files changed, 38 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3cd37f082a69..d585848a6be1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -31,20 +31,20 @@ struct kmem_cache *xfs_buf_cache;
  *
  * xfs_buf_stale:
  *	b_sema (caller holds)
- *	  b_lock
+ *	  b_lockref.lock
  *	    lru_lock
  *
  * xfs_buf_rele:
- *	b_lock
+ *	b_lockref.lock
  *	  lru_lock
  *
  * xfs_buftarg_drain_rele
  *	lru_lock
- *	  b_lock (trylock due to inversion)
+ *	  b_lockref.lock (trylock due to inversion)
  *
  * xfs_buftarg_isolate
  *	lru_lock
- *	  b_lock (trylock due to inversion)
+ *	  b_lockref.lock (trylock due to inversion)
  */
 
 static void xfs_buf_submit(struct xfs_buf *bp);
@@ -78,11 +78,11 @@ xfs_buf_stale(
 	 */
 	bp->b_flags &= ~_XBF_DELWRI_Q;
 
-	spin_lock(&bp->b_lock);
+	spin_lock(&bp->b_lockref.lock);
 	atomic_set(&bp->b_lru_ref, 0);
-	if (bp->b_hold >= 0)
+	if (!__lockref_is_dead(&bp->b_lockref))
 		list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
-	spin_unlock(&bp->b_lock);
+	spin_unlock(&bp->b_lockref.lock);
 }
 
 static void
@@ -274,10 +274,8 @@ xfs_buf_alloc(
 	 * inserting into the hash table are safe (and will have to wait for
 	 * the unlock to do anything non-trivial).
 	 */
-	bp->b_hold = 1;
+	lockref_init(&bp->b_lockref);
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
-
-	spin_lock_init(&bp->b_lock);
 	atomic_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_lru);
@@ -434,20 +432,6 @@ xfs_buf_find_lock(
 	return 0;
 }
 
-static bool
-xfs_buf_try_hold(
-	struct xfs_buf		*bp)
-{
-	spin_lock(&bp->b_lock);
-	if (bp->b_hold == -1) {
-		spin_unlock(&bp->b_lock);
-		return false;
-	}
-	bp->b_hold++;
-	spin_unlock(&bp->b_lock);
-	return true;
-}
-
 static inline int
 xfs_buf_lookup(
 	struct xfs_buf_cache	*bch,
@@ -460,7 +444,7 @@ xfs_buf_lookup(
 
 	rcu_read_lock();
 	bp = rhashtable_lookup(&bch->bc_hash, map, xfs_buf_hash_params);
-	if (!bp || !xfs_buf_try_hold(bp)) {
+	if (!bp || !lockref_get_not_dead(&bp->b_lockref)) {
 		rcu_read_unlock();
 		return -ENOENT;
 	}
@@ -511,7 +495,7 @@ xfs_buf_find_insert(
 		error = PTR_ERR(bp);
 		goto out_free_buf;
 	}
-	if (bp && xfs_buf_try_hold(bp)) {
+	if (bp && lockref_get_not_dead(&bp->b_lockref)) {
 		/* found an existing buffer */
 		rcu_read_unlock();
 		error = xfs_buf_find_lock(bp, flags);
@@ -853,16 +837,14 @@ xfs_buf_hold(
 {
 	trace_xfs_buf_hold(bp, _RET_IP_);
 
-	spin_lock(&bp->b_lock);
-	bp->b_hold++;
-	spin_unlock(&bp->b_lock);
+	lockref_get(&bp->b_lockref);
 }
 
 static void
 xfs_buf_destroy(
 	struct xfs_buf		*bp)
 {
-	ASSERT(bp->b_hold < 0);
+	ASSERT(__lockref_is_dead(&bp->b_lockref));
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 
 	if (!xfs_buf_is_uncached(bp)) {
@@ -888,19 +870,20 @@ xfs_buf_rele(
 {
 	trace_xfs_buf_rele(bp, _RET_IP_);
 
-	spin_lock(&bp->b_lock);
-	if (!--bp->b_hold) {
+	if (lockref_put_or_lock(&bp->b_lockref))
+		return;
+	if (!--bp->b_lockref.count) {
 		if (xfs_buf_is_uncached(bp) || !atomic_read(&bp->b_lru_ref))
 			goto kill;
 		list_lru_add_obj(&bp->b_target->bt_lru, &bp->b_lru);
 	}
-	spin_unlock(&bp->b_lock);
+	spin_unlock(&bp->b_lockref.lock);
 	return;
 
 kill:
-	bp->b_hold = -1;
+	lockref_mark_dead(&bp->b_lockref);
 	list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
-	spin_unlock(&bp->b_lock);
+	spin_unlock(&bp->b_lockref.lock);
 
 	xfs_buf_destroy(bp);
 }
@@ -1471,18 +1454,18 @@ xfs_buftarg_drain_rele(
 	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
 	struct list_head	*dispose = arg;
 
-	if (!spin_trylock(&bp->b_lock))
+	if (!spin_trylock(&bp->b_lockref.lock))
 		return LRU_SKIP;
-	if (bp->b_hold > 0) {
+	if (bp->b_lockref.count > 0) {
 		/* need to wait, so skip it this pass */
-		spin_unlock(&bp->b_lock);
+		spin_unlock(&bp->b_lockref.lock);
 		trace_xfs_buf_drain_buftarg(bp, _RET_IP_);
 		return LRU_SKIP;
 	}
 
-	bp->b_hold = -1;
+	lockref_mark_dead(&bp->b_lockref);
 	list_lru_isolate_move(lru, item, dispose);
-	spin_unlock(&bp->b_lock);
+	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
 }
 
@@ -1564,10 +1547,10 @@ xfs_buftarg_isolate(
 	struct list_head	*dispose = arg;
 
 	/*
-	 * We are inverting the lru lock vs bp->b_lock order here, so use a
-	 * trylock. If we fail to get the lock, just skip the buffer.
+	 * We are inverting the lru lock vs bp->b_lockref.lock order here, so
+	 * use a trylock. If we fail to get the lock, just skip the buffer.
 	 */
-	if (!spin_trylock(&bp->b_lock))
+	if (!spin_trylock(&bp->b_lockref.lock))
 		return LRU_SKIP;
 
 	/*
@@ -1576,7 +1559,7 @@ xfs_buftarg_isolate(
 	 * buffer, otherwise it gets another trip through the LRU.
 	 */
 	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
-		spin_unlock(&bp->b_lock);
+		spin_unlock(&bp->b_lockref.lock);
 		return LRU_ROTATE;
 	}
 	
@@ -1584,15 +1567,15 @@ xfs_buftarg_isolate(
 	 * If the buffer is in use, remove it from the LRU for now as we can't
 	 * free it.  It will be freed when the last reference drops.
 	 */
-	if (bp->b_hold > 0) {
+	if (bp->b_lockref.count > 0) {
 		list_lru_isolate(lru, &bp->b_lru);
-		spin_unlock(&bp->b_lock);
+		spin_unlock(&bp->b_lockref.lock);
 		return LRU_REMOVED;
 	}
 
-	bp->b_hold = -1;
+	lockref_mark_dead(&bp->b_lockref);
 	list_lru_isolate_move(lru, item, dispose);
-	spin_unlock(&bp->b_lock);
+	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index e7324d58bd96..3a1d066e1c13 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -14,6 +14,7 @@
 #include <linux/dax.h>
 #include <linux/uio.h>
 #include <linux/list_lru.h>
+#include <linux/lockref.h>
 
 extern struct kmem_cache *xfs_buf_cache;
 
@@ -154,7 +155,7 @@ struct xfs_buf {
 
 	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
 	int			b_length;	/* size of buffer in BBs */
-	int			b_hold;		/* reference count */
+	struct lockref		b_lockref;	/* refcount + lock */
 	atomic_t		b_lru_ref;	/* lru reclaim ref count */
 	xfs_buf_flags_t		b_flags;	/* status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
@@ -164,7 +165,6 @@ struct xfs_buf {
 	 * bt_lru_lock and not by b_sema
 	 */
 	struct list_head	b_lru;		/* lru list */
-	spinlock_t		b_lock;		/* internal state lock */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 813e5a9f57eb..c191f4b163a8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -739,7 +739,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = xfs_buf_daddr(bp);
 		__entry->nblks = bp->b_length;
-		__entry->hold = bp->b_hold;
+		__entry->hold = bp->b_lockref.count;
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
@@ -813,7 +813,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->bno = xfs_buf_daddr(bp);
 		__entry->length = bp->b_length;
 		__entry->flags = flags;
-		__entry->hold = bp->b_hold;
+		__entry->hold = bp->b_lockref.count;
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->caller_ip = caller_ip;
@@ -857,7 +857,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = xfs_buf_daddr(bp);
 		__entry->length = bp->b_length;
-		__entry->hold = bp->b_hold;
+		__entry->hold = bp->b_lockref.count;
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->error = error;
@@ -901,7 +901,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->buf_bno = xfs_buf_daddr(bip->bli_buf);
 		__entry->buf_len = bip->bli_buf->b_length;
 		__entry->buf_flags = bip->bli_buf->b_flags;
-		__entry->buf_hold = bip->bli_buf->b_hold;
+		__entry->buf_hold = bip->bli_buf->b_lockref.count;
 		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
 		__entry->buf_lockval = bip->bli_buf->b_sema.count;
 		__entry->li_flags = bip->bli_item.li_flags;
@@ -5185,7 +5185,7 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
 		__entry->xfino = file_inode(xfbt->target->bt_file)->i_ino;
 		__entry->bno = xfs_buf_daddr(bp);
 		__entry->nblks = bp->b_length;
-		__entry->hold = bp->b_hold;
+		__entry->hold = bp->b_lockref.count;
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
-- 
2.47.3

