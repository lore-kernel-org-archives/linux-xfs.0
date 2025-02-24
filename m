Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F1020C023
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 23:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740440947; cv=none; b=XvuJMx/M6H0VTASqCkOcxk6yMMO/1HImkLuGYqYmm7vZJUpNpwAKXmzYZYZ+95/oe0fILjlduZl9RnLaBnpfPYeCrG3OWA8EKJo0a2NIOAISGSqdWGlqg5yli2k/rsB28D6F6alN2JY9m7K5VPcU8tUIJPCBhapuaZqH0V/tIuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740440947; c=relaxed/simple;
	bh=SgOIOSK+qWLWdKMptIp3lMcpnICwSgA8FbSCHi2L3qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0Vh9BTYc8QqR3f465Ikb5YKXbvdnW6KVAUta7Va5t3v+FSbIn8Y3LaKXViZVMGRVP+ERTVpFj2WO0mEWeG1ExE2JPA2Fg862dEtpRY3mf6PTJgBPfnmei2jBE+BAmHpY7dq/3KNN9KDvORvME+dVsvc7awPTzIa2s2WQ5Z8F9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jnDTtlAR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jnDTtlAR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=T+i5rT+iIAg0aOyp3osc/SXJKAiJm2Ohv0kwx/jx69E=; b=jnDTtlARJHTqyHfys+lUnjxsFZ
	rc/5kbAwiSANJedS50LGbeJ7dRLTgARnU5KR0YcD2N+T0p87k0918MYk71dUQmPaMQSxWslS3kF4S
	CjJSQX1hxO5bXA3PRvM08wADvRxD601rhCSgS/VWGvL2yCGYxHfJf2QMOxBVKJQ8Vg1GtkcaS75Of
	vPygBfX7mP20GXB1HDbXrdIe3IhVLLLg5iWtpFmgNH7ZO6KLF/hEP+rCg+aah+LFWVvz2zFf0meTU
	AnlJ83M2iNC55+kXDVbluilw/WwRnZiY2C0qIVhvsPlSTRHfoKJ6ufm0bg3B2M9+Vh4GKtgdQeFNa
	XfdWvfWw==;
Received: from [208.223.66.147] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tmiC9-0000000FXJk-2UPf;
	Mon, 24 Feb 2025 23:49:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 3/4] xfs: remove most in-flight buffer accounting
Date: Mon, 24 Feb 2025 15:48:54 -0800
Message-ID: <20250224234903.402657-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250224234903.402657-1-hch@lst.de>
References: <20250224234903.402657-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The buffer cache keeps a bt_io_count per-CPU counter to track all
in-flight I/O, which is used to ensure no I/O is in flight when
unmounting the file system.

For most I/O we already keep track of inflight I/O at higher levels:

 - for synchronous I/O (xfs_buf_read/xfs_bwrite/xfs_buf_delwri_submit),
   the caller has a reference and waits for I/O completions using
   xfs_buf_iowait
 - for xfs_buf_delwri_submit_nowait the only caller (AIL writeback)
   tracks the log items that the buffer attached to

This only leaves only xfs_buf_readahead_map as a submitter of
asynchronous I/O that is not tracked by anything else.  Replace the
bt_io_count per-cpu counter with a more specific bt_readahead_count
counter only tracking readahead I/O.  This allows to simply increment
it when submitting readahead I/O and decrementing it when it completed,
and thus simplify xfs_buf_rele and remove the needed for the
XBF_NO_IOACCT flags and the XFS_BSTATE_IN_FLIGHT buffer state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c     | 90 ++++++++------------------------------------
 fs/xfs/xfs_buf.h     |  5 +--
 fs/xfs/xfs_buf_mem.c |  2 +-
 fs/xfs/xfs_mount.c   |  7 +---
 fs/xfs/xfs_rtalloc.c |  2 +-
 5 files changed, 20 insertions(+), 86 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4ea20483d521..e161f3ab4108 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -29,11 +29,6 @@ struct kmem_cache *xfs_buf_cache;
 /*
  * Locking orders
  *
- * xfs_buf_ioacct_inc:
- * xfs_buf_ioacct_dec:
- *	b_sema (caller holds)
- *	  b_lock
- *
  * xfs_buf_stale:
  *	b_sema (caller holds)
  *	  b_lock
@@ -81,51 +76,6 @@ xfs_buf_vmap_len(
 	return (bp->b_page_count * PAGE_SIZE);
 }
 
-/*
- * Bump the I/O in flight count on the buftarg if we haven't yet done so for
- * this buffer. The count is incremented once per buffer (per hold cycle)
- * because the corresponding decrement is deferred to buffer release. Buffers
- * can undergo I/O multiple times in a hold-release cycle and per buffer I/O
- * tracking adds unnecessary overhead. This is used for sychronization purposes
- * with unmount (see xfs_buftarg_drain()), so all we really need is a count of
- * in-flight buffers.
- *
- * Buffers that are never released (e.g., superblock, iclog buffers) must set
- * the XBF_NO_IOACCT flag before I/O submission. Otherwise, the buftarg count
- * never reaches zero and unmount hangs indefinitely.
- */
-static inline void
-xfs_buf_ioacct_inc(
-	struct xfs_buf	*bp)
-{
-	if (bp->b_flags & XBF_NO_IOACCT)
-		return;
-
-	ASSERT(bp->b_flags & XBF_ASYNC);
-	spin_lock(&bp->b_lock);
-	if (!(bp->b_state & XFS_BSTATE_IN_FLIGHT)) {
-		bp->b_state |= XFS_BSTATE_IN_FLIGHT;
-		percpu_counter_inc(&bp->b_target->bt_io_count);
-	}
-	spin_unlock(&bp->b_lock);
-}
-
-/*
- * Clear the in-flight state on a buffer about to be released to the LRU or
- * freed and unaccount from the buftarg.
- */
-static inline void
-__xfs_buf_ioacct_dec(
-	struct xfs_buf	*bp)
-{
-	lockdep_assert_held(&bp->b_lock);
-
-	if (bp->b_state & XFS_BSTATE_IN_FLIGHT) {
-		bp->b_state &= ~XFS_BSTATE_IN_FLIGHT;
-		percpu_counter_dec(&bp->b_target->bt_io_count);
-	}
-}
-
 /*
  * When we mark a buffer stale, we remove the buffer from the LRU and clear the
  * b_lru_ref count so that the buffer is freed immediately when the buffer
@@ -156,8 +106,6 @@ xfs_buf_stale(
 	 * status now to preserve accounting consistency.
 	 */
 	spin_lock(&bp->b_lock);
-	__xfs_buf_ioacct_dec(bp);
-
 	atomic_set(&bp->b_lru_ref, 0);
 	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
 	    (list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru)))
@@ -946,6 +894,7 @@ xfs_buf_readahead_map(
 	bp->b_ops = ops;
 	bp->b_flags &= ~(XBF_WRITE | XBF_DONE);
 	bp->b_flags |= flags;
+	percpu_counter_inc(&target->bt_readahead_count);
 	xfs_buf_submit(bp);
 }
 
@@ -1002,10 +951,12 @@ xfs_buf_get_uncached(
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
+	/* there are currently no valid flags for xfs_buf_get_uncached */
+	ASSERT(flags == 0);
+
 	*bpp = NULL;
 
-	/* flags might contain irrelevant bits, pass only what we care about */
-	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
+	error = _xfs_buf_alloc(target, &map, 1, flags, &bp);
 	if (error)
 		return error;
 
@@ -1059,7 +1010,6 @@ xfs_buf_rele_uncached(
 		spin_unlock(&bp->b_lock);
 		return;
 	}
-	__xfs_buf_ioacct_dec(bp);
 	spin_unlock(&bp->b_lock);
 	xfs_buf_free(bp);
 }
@@ -1078,19 +1028,11 @@ xfs_buf_rele_cached(
 	spin_lock(&bp->b_lock);
 	ASSERT(bp->b_hold >= 1);
 	if (bp->b_hold > 1) {
-		/*
-		 * Drop the in-flight state if the buffer is already on the LRU
-		 * and it holds the only reference. This is racy because we
-		 * haven't acquired the pag lock, but the use of _XBF_IN_FLIGHT
-		 * ensures the decrement occurs only once per-buf.
-		 */
-		if (--bp->b_hold == 1 && !list_empty(&bp->b_lru))
-			__xfs_buf_ioacct_dec(bp);
+		bp->b_hold--;
 		goto out_unlock;
 	}
 
 	/* we are asked to drop the last reference */
-	__xfs_buf_ioacct_dec(bp);
 	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
 		/*
 		 * If the buffer is added to the LRU, keep the reference to the
@@ -1370,6 +1312,8 @@ __xfs_buf_ioend(
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
 			bp->b_flags |= XBF_DONE;
+		if (bp->b_flags & XBF_READ_AHEAD)
+			percpu_counter_dec(&bp->b_target->bt_readahead_count);
 	} else {
 		if (!bp->b_error) {
 			bp->b_flags &= ~XBF_WRITE_FAIL;
@@ -1658,9 +1602,6 @@ xfs_buf_submit(
 	 */
 	bp->b_error = 0;
 
-	if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_ioacct_inc(bp);
-
 	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
 		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
 		xfs_buf_ioend(bp);
@@ -1786,9 +1727,8 @@ xfs_buftarg_wait(
 	struct xfs_buftarg	*btp)
 {
 	/*
-	 * First wait on the buftarg I/O count for all in-flight buffers to be
-	 * released. This is critical as new buffers do not make the LRU until
-	 * they are released.
+	 * First wait for all in-flight readahead buffers to be released.  This is
+	 * critical as new buffers do not make the LRU until they are released.
 	 *
 	 * Next, flush the buffer workqueue to ensure all completion processing
 	 * has finished. Just waiting on buffer locks is not sufficient for
@@ -1797,7 +1737,7 @@ xfs_buftarg_wait(
 	 * all reference counts have been dropped before we start walking the
 	 * LRU list.
 	 */
-	while (percpu_counter_sum(&btp->bt_io_count))
+	while (percpu_counter_sum(&btp->bt_readahead_count))
 		delay(100);
 	flush_workqueue(btp->bt_mount->m_buf_workqueue);
 }
@@ -1914,8 +1854,8 @@ xfs_destroy_buftarg(
 	struct xfs_buftarg	*btp)
 {
 	shrinker_free(btp->bt_shrinker);
-	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
-	percpu_counter_destroy(&btp->bt_io_count);
+	ASSERT(percpu_counter_sum(&btp->bt_readahead_count) == 0);
+	percpu_counter_destroy(&btp->bt_readahead_count);
 	list_lru_destroy(&btp->bt_lru);
 }
 
@@ -1969,7 +1909,7 @@ xfs_init_buftarg(
 
 	if (list_lru_init(&btp->bt_lru))
 		return -ENOMEM;
-	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+	if (percpu_counter_init(&btp->bt_readahead_count, 0, GFP_KERNEL))
 		goto out_destroy_lru;
 
 	btp->bt_shrinker =
@@ -1983,7 +1923,7 @@ xfs_init_buftarg(
 	return 0;
 
 out_destroy_io_count:
-	percpu_counter_destroy(&btp->bt_io_count);
+	percpu_counter_destroy(&btp->bt_readahead_count);
 out_destroy_lru:
 	list_lru_destroy(&btp->bt_lru);
 	return -ENOMEM;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 2e747555ad3f..80e06eecaf56 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -27,7 +27,6 @@ struct xfs_buf;
 #define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
 #define XBF_WRITE	 (1u << 1) /* buffer intended for writing to device */
 #define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
-#define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
 #define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
 #define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
 #define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
@@ -58,7 +57,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_READ,		"READ" }, \
 	{ XBF_WRITE,		"WRITE" }, \
 	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
-	{ XBF_NO_IOACCT,	"NO_IOACCT" }, \
 	{ XBF_ASYNC,		"ASYNC" }, \
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
@@ -77,7 +75,6 @@ typedef unsigned int xfs_buf_flags_t;
  * Internal state flags.
  */
 #define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
-#define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
 
 struct xfs_buf_cache {
 	struct rhashtable	bc_hash;
@@ -116,7 +113,7 @@ struct xfs_buftarg {
 	struct shrinker		*bt_shrinker;
 	struct list_lru		bt_lru;
 
-	struct percpu_counter	bt_io_count;
+	struct percpu_counter	bt_readahead_count;
 	struct ratelimit_state	bt_ioerror_rl;
 
 	/* Atomic write unit values */
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index 07bebbfb16ee..5b64a2b3b113 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -117,7 +117,7 @@ xmbuf_free(
 	struct xfs_buftarg	*btp)
 {
 	ASSERT(xfs_buftarg_is_mem(btp));
-	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
+	ASSERT(percpu_counter_sum(&btp->bt_readahead_count) == 0);
 
 	trace_xmbuf_free(btp);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 477c5262cf91..b69356582b86 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -181,14 +181,11 @@ xfs_readsb(
 
 	/*
 	 * Allocate a (locked) buffer to hold the superblock. This will be kept
-	 * around at all times to optimize access to the superblock. Therefore,
-	 * set XBF_NO_IOACCT to make sure it doesn't hold the buftarg count
-	 * elevated.
+	 * around at all times to optimize access to the superblock.
 	 */
 reread:
 	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-				      BTOBB(sector_size), XBF_NO_IOACCT, &bp,
-				      buf_ops);
+				      BTOBB(sector_size), 0, &bp, buf_ops);
 	if (error) {
 		if (loud)
 			xfs_warn(mp, "SB validate failed with error %d.", error);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d8e6d073d64d..57bef567e011 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1407,7 +1407,7 @@ xfs_rtmount_readsb(
 
 	/* m_blkbb_log is not set up yet */
 	error = xfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
-			mp->m_sb.sb_blocksize >> BBSHIFT, XBF_NO_IOACCT, &bp,
+			mp->m_sb.sb_blocksize >> BBSHIFT, 0, &bp,
 			&xfs_rtsb_buf_ops);
 	if (error) {
 		xfs_warn(mp, "rt sb validate failed with error %d.", error);
-- 
2.45.2

