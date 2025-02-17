Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E1F2153EC
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 09:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739784739; cv=none; b=PNfsOx/Gf2EuLTV5sb2p6F6tSD8Rl1BdemlCVGDkUg46IeqXC21N+dwpX/Wxa37OMJnGKJQuSZutdr/ol5CClOVjBnd5WytL09AB2p5zCUBpPUsJ6j/xibPX0x6VLUzFM0HAKEnaRTxTGFG3aYDyKk4sfhOzPliBLAOhAJ9CY0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739784739; c=relaxed/simple;
	bh=g0Vd9i3OYXHnZPiA+exC+6zVcgVREF+KzNWhPsaB2qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFRnx2SQXH/GmEGeJ4yPd66uI68reiDdAkrvI+oNbkqqo+Eb7XalEcnNVMrq9x5zHPM/AXR1lyMtxAmGR/k9GS0+XhqfuP6L9rF9HLep9utBiWKTS7swFUmqcIbgPLrYVHfCJNeAzkyJrsJuwLGrps/TMyOe9cW3gn6/C4uPWvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2RWNkq71; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2RWNkq71"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5y+16WDWnez12lYK9jJVb1UuUvs5ET8nseKL3C5X8FM=; b=2RWNkq716TqfbEL2iRsUrbCCx4
	KsTQG8BBOUouR4eFWsFeHIi9bYS9L4x8IIabLHR5KD6xvwHyc0Tc/uUE8D33s0Pm94VLMO0NmKR6Z
	0marg/71bUTNUEyM9kcpCpaJ3ziR6WkrHf6vEXThQqcs1KNLowmAX++pD8CPJQ0QOgksmBYvkFFvW
	hf2MCuxu8vy0BpUr8lYsAR3RW2DzQnC3idaSGAsqziARIFqpf144JIxc5y7LFX5zp/a1moRxmlFhm
	dG/NsPClkBKa4tJ+LAHygPNNnap420f+JgdOaN00gh89aOvYT7QMVfBdscRiFtC5yJuPAGu+4tAgs
	I2iv8xvA==;
Received: from 2a02-8389-2341-5b80-a8df-74d2-0b85-4db2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:a8df:74d2:b85:4db2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tjxU9-00000003wI8-0YYC;
	Mon, 17 Feb 2025 09:32:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: remove most in-flight buffer accounting
Date: Mon, 17 Feb 2025 10:31:28 +0100
Message-ID: <20250217093207.3769550-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250217093207.3769550-1-hch@lst.de>
References: <20250217093207.3769550-1-hch@lst.de>
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
 - for xfs_buf_delwri_submit the only caller (AIL writeback) tracks the
   log items that the buffer attached to

This only leaves only xfs_buf_readahead_map as a submitter of
asynchronous I/O that is not tracked by anything else.  Replace the
bt_io_count per-cpu counter with a more specific bt_readahead_count
counter only tracking readahead I/O.  This allows to simply increment
it when submitting readahead I/O and decrementing it when it completed,
and thus simplify xfs_buf_rele and remove the needed for the
XBF_NO_IOACCT flags and the XFS_BSTATE_IN_FLIGHT buffer state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c     | 90 ++++++++------------------------------------
 fs/xfs/xfs_buf.h     |  5 +--
 fs/xfs/xfs_buf_mem.c |  2 +-
 fs/xfs/xfs_mount.c   |  7 +---
 fs/xfs/xfs_rtalloc.c |  2 +-
 5 files changed, 20 insertions(+), 86 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 52fb85c42e94..f8efdee3c8b4 100644
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
@@ -1369,6 +1311,8 @@ __xfs_buf_ioend(
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
 			bp->b_flags |= XBF_DONE;
+		if (bp->b_flags & XBF_READ_AHEAD)
+			percpu_counter_dec(&bp->b_target->bt_readahead_count);
 	} else {
 		if (!bp->b_error) {
 			bp->b_flags &= ~XBF_WRITE_FAIL;
@@ -1657,9 +1601,6 @@ xfs_buf_submit(
 	 */
 	bp->b_error = 0;
 
-	if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_ioacct_inc(bp);
-
 	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
 		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
 		xfs_buf_ioend(bp);
@@ -1785,9 +1726,8 @@ xfs_buftarg_wait(
 	struct xfs_buftarg	*btp)
 {
 	/*
-	 * First wait on the buftarg I/O count for all in-flight buffers to be
-	 * released. This is critical as new buffers do not make the LRU until
-	 * they are released.
+	 * First wait for all in-flight readahead buffers to be released.  This is
+	 8 critical as new buffers do not make the LRU until they are released.
 	 *
 	 * Next, flush the buffer workqueue to ensure all completion processing
 	 * has finished. Just waiting on buffer locks is not sufficient for
@@ -1796,7 +1736,7 @@ xfs_buftarg_wait(
 	 * all reference counts have been dropped before we start walking the
 	 * LRU list.
 	 */
-	while (percpu_counter_sum(&btp->bt_io_count))
+	while (percpu_counter_sum(&btp->bt_readahead_count))
 		delay(100);
 	flush_workqueue(btp->bt_mount->m_buf_workqueue);
 }
@@ -1913,8 +1853,8 @@ xfs_destroy_buftarg(
 	struct xfs_buftarg	*btp)
 {
 	shrinker_free(btp->bt_shrinker);
-	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
-	percpu_counter_destroy(&btp->bt_io_count);
+	ASSERT(percpu_counter_sum(&btp->bt_readahead_count) == 0);
+	percpu_counter_destroy(&btp->bt_readahead_count);
 	list_lru_destroy(&btp->bt_lru);
 }
 
@@ -1968,7 +1908,7 @@ xfs_init_buftarg(
 
 	if (list_lru_init(&btp->bt_lru))
 		return -ENOMEM;
-	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+	if (percpu_counter_init(&btp->bt_readahead_count, 0, GFP_KERNEL))
 		goto out_destroy_lru;
 
 	btp->bt_shrinker =
@@ -1982,7 +1922,7 @@ xfs_init_buftarg(
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

