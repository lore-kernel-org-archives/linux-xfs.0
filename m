Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B014A18D63E
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 04:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742355; cv=none; b=c2xwPo5/VAaK9TVmE5VyZ8ypM3C5jk+YGJShd+nX5x7KvsTJxnnz/h4yqZG1/DplwJMxIs9yVH849FeHSlk82/Fi2SZa+1Ys3eHotpJbAQN8WnCJgXAjl1C5Tkta5ZHgMUfYEBYAEU3MDSWBb33QVDk0zfyoubhGmZ2MbPPyzxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742355; c=relaxed/simple;
	bh=J2ns9j3PrjC1SoIXR8rBflwdtpvs2kNdDumif0rn9yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/zwdBya+WPF6f8K3MGO9UsEmrA5r4uf9P2kUCprgeTL0qq6TZjDFP4xrh4qHX7WxsUpFN00Q41IC7fSbIJGZMJJzI8m907J4MAaLX+NcRcXN4KRp5k3CDaFNeRjSb7CNp3B4uF7Yvn669fJ9RH6/Cr+5TFZTfHf3hMn8bEn1YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gSb+ee2I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gSb+ee2I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SnkMS0yvVaceb0H/0lekeURAi5+NVvQ/q6AXp1VVR6k=; b=gSb+ee2IjaH+fowjIPICTXJuQ7
	b/ISCwQaWiNWyY/MGD9ZecbK5TAQEgpO74d/iWUZdKRGCCZMur7B4yjKgw2z8lVq0FOJd9NbrfFZ5
	oqnvxR644wzK6NtyLtXrHWnp7eZTtFqgxz3fw0CST3XhP8+KQn4/B2jMm3h/IyvJATOc7G1uhrLf5
	n8LOeyC6N54jBudDEMqzGNH2WUZ2yevboEtVebuJ61b7pYqlaLOUQYNhrxYqZ+a97TG+QPMDZb5Nc
	kGYrYhl8CAnedNBsB7ps0OvF1E5A4rXiiFrBGyZwWs1DnFinDUOTzGyrAZppUBzu9vfRjszJ1SiYm
	SoqguwRg==;
Received: from 2a02-8389-2341-5b80-421b-ad95-8448-da51.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:421b:ad95:8448:da51] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXC1Q-00000003yhP-3kQW;
	Mon, 13 Jan 2025 04:25:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: fix buffer lookup vs release race
Date: Mon, 13 Jan 2025 05:24:27 +0100
Message-ID: <20250113042542.2051287-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113042542.2051287-1-hch@lst.de>
References: <20250113042542.2051287-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Since commit 298f34224506 ("xfs: lockless buffer lookup") the buffer
lookup fastpath is done without a hash-wide lock (then pag_buf_lock, now
bc_lock) and only under RCU protection.  But this means that nothing
serializes lookups against the temporary 0 reference count for buffers
that are added to the LRU after dropping the last regular reference,
and a concurrent lookup would fail to find them.

Fix this by doing all b_hold modifications under b_lock.  We're already
doing this for release so this "only" ~ doubles the b_lock round trips.
We'll later look into the lockref infrastructure to optimize the number
of lock round trips again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c   | 93 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_buf.h   |  4 +-
 fs/xfs/xfs_trace.h | 10 ++---
 3 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f80e39fde53b..dc219678003c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -133,15 +133,6 @@ __xfs_buf_ioacct_dec(
 	}
 }
 
-static inline void
-xfs_buf_ioacct_dec(
-	struct xfs_buf	*bp)
-{
-	spin_lock(&bp->b_lock);
-	__xfs_buf_ioacct_dec(bp);
-	spin_unlock(&bp->b_lock);
-}
-
 /*
  * When we mark a buffer stale, we remove the buffer from the LRU and clear the
  * b_lru_ref count so that the buffer is freed immediately when the buffer
@@ -177,9 +168,9 @@ xfs_buf_stale(
 	atomic_set(&bp->b_lru_ref, 0);
 	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
 	    (list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru)))
-		atomic_dec(&bp->b_hold);
+		bp->b_hold--;
 
-	ASSERT(atomic_read(&bp->b_hold) >= 1);
+	ASSERT(bp->b_hold >= 1);
 	spin_unlock(&bp->b_lock);
 }
 
@@ -238,14 +229,14 @@ _xfs_buf_alloc(
 	 */
 	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
-	atomic_set(&bp->b_hold, 1);
+	spin_lock_init(&bp->b_lock);
+	bp->b_hold = 1;
 	atomic_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
 	INIT_LIST_HEAD(&bp->b_li_list);
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
-	spin_lock_init(&bp->b_lock);
 	bp->b_target = target;
 	bp->b_mount = target->bt_mount;
 	bp->b_flags = flags;
@@ -589,6 +580,20 @@ xfs_buf_find_lock(
 	return 0;
 }
 
+static bool
+xfs_buf_try_hold(
+	struct xfs_buf		*bp)
+{
+	spin_lock(&bp->b_lock);
+	if (bp->b_hold == 0) {
+		spin_unlock(&bp->b_lock);
+		return false;
+	}
+	bp->b_hold++;
+	spin_unlock(&bp->b_lock);
+	return true;
+}
+
 static inline int
 xfs_buf_lookup(
 	struct xfs_buf_cache	*bch,
@@ -601,7 +606,7 @@ xfs_buf_lookup(
 
 	rcu_read_lock();
 	bp = rhashtable_lookup(&bch->bc_hash, map, xfs_buf_hash_params);
-	if (!bp || !atomic_inc_not_zero(&bp->b_hold)) {
+	if (!bp || !xfs_buf_try_hold(bp)) {
 		rcu_read_unlock();
 		return -ENOENT;
 	}
@@ -664,7 +669,7 @@ xfs_buf_find_insert(
 		spin_unlock(&bch->bc_lock);
 		goto out_free_buf;
 	}
-	if (bp && atomic_inc_not_zero(&bp->b_hold)) {
+	if (bp && xfs_buf_try_hold(bp)) {
 		/* found an existing buffer */
 		spin_unlock(&bch->bc_lock);
 		error = xfs_buf_find_lock(bp, flags);
@@ -1043,7 +1048,10 @@ xfs_buf_hold(
 	struct xfs_buf		*bp)
 {
 	trace_xfs_buf_hold(bp, _RET_IP_);
-	atomic_inc(&bp->b_hold);
+
+	spin_lock(&bp->b_lock);
+	bp->b_hold++;
+	spin_unlock(&bp->b_lock);
 }
 
 static void
@@ -1051,10 +1059,15 @@ xfs_buf_rele_uncached(
 	struct xfs_buf		*bp)
 {
 	ASSERT(list_empty(&bp->b_lru));
-	if (atomic_dec_and_test(&bp->b_hold)) {
-		xfs_buf_ioacct_dec(bp);
-		xfs_buf_free(bp);
+
+	spin_lock(&bp->b_lock);
+	if (--bp->b_hold) {
+		spin_unlock(&bp->b_lock);
+		return;
 	}
+	__xfs_buf_ioacct_dec(bp);
+	spin_unlock(&bp->b_lock);
+	xfs_buf_free(bp);
 }
 
 static void
@@ -1064,51 +1077,40 @@ xfs_buf_rele_cached(
 	struct xfs_buftarg	*btp = bp->b_target;
 	struct xfs_perag	*pag = bp->b_pag;
 	struct xfs_buf_cache	*bch = xfs_buftarg_buf_cache(btp, pag);
-	bool			release;
 	bool			freebuf = false;
 
 	trace_xfs_buf_rele(bp, _RET_IP_);
 
-	ASSERT(atomic_read(&bp->b_hold) > 0);
-
-	/*
-	 * We grab the b_lock here first to serialise racing xfs_buf_rele()
-	 * calls. The pag_buf_lock being taken on the last reference only
-	 * serialises against racing lookups in xfs_buf_find(). IOWs, the second
-	 * to last reference we drop here is not serialised against the last
-	 * reference until we take bp->b_lock. Hence if we don't grab b_lock
-	 * first, the last "release" reference can win the race to the lock and
-	 * free the buffer before the second-to-last reference is processed,
-	 * leading to a use-after-free scenario.
-	 */
 	spin_lock(&bp->b_lock);
-	release = atomic_dec_and_lock(&bp->b_hold, &bch->bc_lock);
-	if (!release) {
+	ASSERT(bp->b_hold >= 1);
+	if (bp->b_hold > 1) {
 		/*
 		 * Drop the in-flight state if the buffer is already on the LRU
 		 * and it holds the only reference. This is racy because we
 		 * haven't acquired the pag lock, but the use of _XBF_IN_FLIGHT
 		 * ensures the decrement occurs only once per-buf.
 		 */
-		if ((atomic_read(&bp->b_hold) == 1) && !list_empty(&bp->b_lru))
+		if (--bp->b_hold == 1 && !list_empty(&bp->b_lru))
 			__xfs_buf_ioacct_dec(bp);
 		goto out_unlock;
 	}
 
-	/* the last reference has been dropped ... */
+	/* we are asked to drop the last reference */
+	spin_lock(&bch->bc_lock);
 	__xfs_buf_ioacct_dec(bp);
 	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
 		/*
-		 * If the buffer is added to the LRU take a new reference to the
+		 * If the buffer is added to the LRU, keep the reference to the
 		 * buffer for the LRU and clear the (now stale) dispose list
-		 * state flag
+		 * state flag, else drop the reference.
 		 */
-		if (list_lru_add_obj(&btp->bt_lru, &bp->b_lru)) {
+		if (list_lru_add_obj(&btp->bt_lru, &bp->b_lru))
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
-			atomic_inc(&bp->b_hold);
-		}
+		else
+			bp->b_hold--;
 		spin_unlock(&bch->bc_lock);
 	} else {
+		bp->b_hold--;
 		/*
 		 * most of the time buffers will already be removed from the
 		 * LRU, so optimise that case by checking for the
@@ -1863,13 +1865,14 @@ xfs_buftarg_drain_rele(
 	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
 	struct list_head	*dispose = arg;
 
-	if (atomic_read(&bp->b_hold) > 1) {
+	if (!spin_trylock(&bp->b_lock))
+		return LRU_SKIP;
+	if (bp->b_hold > 1) {
 		/* need to wait, so skip it this pass */
+		spin_unlock(&bp->b_lock);
 		trace_xfs_buf_drain_buftarg(bp, _RET_IP_);
 		return LRU_SKIP;
 	}
-	if (!spin_trylock(&bp->b_lock))
-		return LRU_SKIP;
 
 	/*
 	 * clear the LRU reference count so the buffer doesn't get
@@ -2208,7 +2211,7 @@ xfs_buf_delwri_queue(
 	 */
 	bp->b_flags |= _XBF_DELWRI_Q;
 	if (list_empty(&bp->b_list)) {
-		atomic_inc(&bp->b_hold);
+		xfs_buf_hold(bp);
 		list_add_tail(&bp->b_list, list);
 	}
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 3d56bc7a35cc..cbf7c2a076c7 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -172,7 +172,8 @@ struct xfs_buf {
 
 	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
 	int			b_length;	/* size of buffer in BBs */
-	atomic_t		b_hold;		/* reference count */
+	spinlock_t		b_lock;		/* internal state lock */
+	unsigned int		b_hold;		/* reference count */
 	atomic_t		b_lru_ref;	/* lru reclaim ref count */
 	xfs_buf_flags_t		b_flags;	/* status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
@@ -182,7 +183,6 @@ struct xfs_buf {
 	 * bt_lru_lock and not by b_sema
 	 */
 	struct list_head	b_lru;		/* lru list */
-	spinlock_t		b_lock;		/* internal state lock */
 	unsigned int		b_state;	/* internal state flags */
 	int			b_io_error;	/* internal IO error state */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4fe689410eb6..b29462363b81 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -498,7 +498,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = xfs_buf_daddr(bp);
 		__entry->nblks = bp->b_length;
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = bp->b_hold;
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
@@ -569,7 +569,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->bno = xfs_buf_daddr(bp);
 		__entry->length = bp->b_length;
 		__entry->flags = flags;
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = bp->b_hold;
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->caller_ip = caller_ip;
@@ -612,7 +612,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = xfs_buf_daddr(bp);
 		__entry->length = bp->b_length;
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = bp->b_hold;
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->error = error;
@@ -656,7 +656,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->buf_bno = xfs_buf_daddr(bip->bli_buf);
 		__entry->buf_len = bip->bli_buf->b_length;
 		__entry->buf_flags = bip->bli_buf->b_flags;
-		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
+		__entry->buf_hold = bip->bli_buf->b_hold;
 		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
 		__entry->buf_lockval = bip->bli_buf->b_sema.count;
 		__entry->li_flags = bip->bli_item.li_flags;
@@ -4978,7 +4978,7 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
 		__entry->xfino = file_inode(xfbt->target->bt_file)->i_ino;
 		__entry->bno = xfs_buf_daddr(bp);
 		__entry->nblks = bp->b_length;
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = bp->b_hold;
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
-- 
2.45.2

