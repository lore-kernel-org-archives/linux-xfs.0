Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B221A9B3B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612805; cv=none; b=k/aDHjHUQfRs3erZsX73yThZ0yiQu+QteGSSODJHgg116wBYz+ioEt+q1GEVV19Lt6pAScsTz0luFxpyTXn7IeVhEa1mk8RlA6so5baydq7tC0uJN0rCMajxZ24MHrBlT14A1tR3VEaNOxhOREKhBio05hchGdzBBrQ1r/tFClw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612805; c=relaxed/simple;
	bh=uWOp3TQ9dczyh7gJ7sukGxqIdJgNOJSVeC/f8TgbPJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLGO8/WQ1NnnbZlM71N3P6Ub/GjsLomp9FZpY9mUp7fw9KdKp2ifu39nQcIbahz/Kap60eaIYppcpfEezalNq77RBr4Ub9GCj9bM0dQzsJa4g75x3QKUzGTj4xNlj5Qqi3R4e8vnlfO3Cg/sWs+Dkys4QRnUM6ywobt56WlpvvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vLevX5JM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vLevX5JM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UVfEKR+WqtLVriou0pej3pn3ZpMevXFDwXWpqhystKA=; b=vLevX5JMJfrGI0oMA6HcmCy2rG
	C5+FdAnzx72QSNKyGzoYtLbLMr41dISU4YcgnFr19ga+y0+kjvx0lallMMKj8Wm45AvL8mbEA5DJK
	L2dJ1yVjQ/dIIMtNL1Fct4QeXlsLIvEHhotxrbo1MdcLJ3G128ro021xnOqhBsoyQZg5GMVXxI/Fe
	yKC2iP+0h6fX4TdUegZ86WV+iaZzJLAyxQlIEW5cBVHYqrXn5ZscE90l1/iwg1gT1zsYaPj3UEKjU
	vm6QgQAmpPrn9iRv7TbPskHibuUSSvY8NVqIpQqIMDyHffbPY/SV2H24gJzqvVbaScIBF29U/TmTZ
	DPgLv+Kg==;
Received: from [212.185.66.17] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1trd34-00000002lnR-4Avs;
	Mon, 10 Mar 2025 13:20:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for buffer backing memory
Date: Mon, 10 Mar 2025 14:19:13 +0100
Message-ID: <20250310131917.552600-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250310131917.552600-1-hch@lst.de>
References: <20250310131917.552600-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The fallback buffer allocation path currently open codes a suboptimal
version of vmalloc to allocate pages that are then mapped into
vmalloc space.  Switch to using vmalloc instead, which uses all the
optimizations in the common vmalloc code, and removes the need to
track the backing pages in the xfs_buf structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c     | 212 +++++++++++--------------------------------
 fs/xfs/xfs_buf.h     |   7 --
 fs/xfs/xfs_buf_mem.c |  11 +--
 3 files changed, 53 insertions(+), 177 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b5ec7d83210f..4aaa588330e4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -55,13 +55,6 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
 	return bp->b_rhash_key == XFS_BUF_DADDR_NULL;
 }
 
-static inline int
-xfs_buf_vmap_len(
-	struct xfs_buf	*bp)
-{
-	return (bp->b_page_count * PAGE_SIZE);
-}
-
 /*
  * When we mark a buffer stale, we remove the buffer from the LRU and clear the
  * b_lru_ref count so that the buffer is freed immediately when the buffer
@@ -190,29 +183,6 @@ _xfs_buf_alloc(
 	return 0;
 }
 
-static void
-xfs_buf_free_pages(
-	struct xfs_buf	*bp)
-{
-	uint		i;
-
-	ASSERT(bp->b_flags & _XBF_PAGES);
-
-	if (is_vmalloc_addr(bp->b_addr))
-		vm_unmap_ram(bp->b_addr, bp->b_page_count);
-
-	for (i = 0; i < bp->b_page_count; i++) {
-		if (bp->b_pages[i])
-			folio_put(page_folio(bp->b_pages[i]));
-	}
-	mm_account_reclaimed_pages(howmany(BBTOB(bp->b_length), PAGE_SIZE));
-
-	if (bp->b_pages != bp->b_page_array)
-		kfree(bp->b_pages);
-	bp->b_pages = NULL;
-	bp->b_flags &= ~_XBF_PAGES;
-}
-
 static void
 xfs_buf_free_callback(
 	struct callback_head	*cb)
@@ -227,16 +197,23 @@ static void
 xfs_buf_free(
 	struct xfs_buf		*bp)
 {
+	unsigned int		size = BBTOB(bp->b_length);
+
 	trace_xfs_buf_free(bp, _RET_IP_);
 
 	ASSERT(list_empty(&bp->b_lru));
 
+	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
+		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
+
 	if (xfs_buftarg_is_mem(bp->b_target))
 		xmbuf_unmap_page(bp);
-	else if (bp->b_flags & _XBF_PAGES)
-		xfs_buf_free_pages(bp);
+	else if (is_vmalloc_addr(bp->b_addr))
+		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
+	else
+		folio_put(virt_to_folio(bp->b_addr));
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
@@ -264,9 +241,6 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_pages = bp->b_page_array;
-	bp->b_pages[0] = kmem_to_page(bp->b_addr);
-	bp->b_page_count = 1;
 	bp->b_flags |= _XBF_KMEM;
 	return 0;
 }
@@ -287,9 +261,9 @@ xfs_buf_alloc_kmem(
  * by the rest of the code - the buffer memory spans a single contiguous memory
  * region that we don't have to map and unmap to access the data directly.
  *
- * The third type of buffer is the multi-page buffer. These are always made
- * up of single pages so that they can be fed to vmap_ram() to return a
- * contiguous memory region we can access the data through.
+ * The third type of buffer is the vmalloc()d buffer. This provides the buffer
+ * with the required contiguous memory region but backed by discontiguous
+ * physical pages.
  */
 static int
 xfs_buf_alloc_backing_mem(
@@ -299,7 +273,6 @@ xfs_buf_alloc_backing_mem(
 	size_t		size = BBTOB(bp->b_length);
 	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
 	struct folio	*folio;
-	long		filled = 0;
 
 	if (xfs_buftarg_is_mem(bp->b_target))
 		return xmbuf_map_page(bp);
@@ -351,98 +324,18 @@ xfs_buf_alloc_backing_mem(
 		goto fallback;
 	}
 	bp->b_addr = folio_address(folio);
-	bp->b_page_array[0] = &folio->page;
-	bp->b_pages = bp->b_page_array;
-	bp->b_page_count = 1;
-	bp->b_flags |= _XBF_PAGES;
 	return 0;
 
 fallback:
-	/* Fall back to allocating an array of single page folios. */
-	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
-	if (bp->b_page_count <= XB_PAGES) {
-		bp->b_pages = bp->b_page_array;
-	} else {
-		bp->b_pages = kzalloc(sizeof(struct page *) * bp->b_page_count,
-					gfp_mask);
-		if (!bp->b_pages)
-			return -ENOMEM;
-	}
-	bp->b_flags |= _XBF_PAGES;
-
-	/*
-	 * Bulk filling of pages can take multiple calls. Not filling the entire
-	 * array is not an allocation failure, so don't back off if we get at
-	 * least one extra page.
-	 */
 	for (;;) {
-		long	last = filled;
-
-		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
-					  bp->b_pages);
-		if (filled == bp->b_page_count) {
-			XFS_STATS_INC(bp->b_mount, xb_page_found);
+		bp->b_addr = __vmalloc(size, gfp_mask);
+		if (bp->b_addr)
 			break;
-		}
-
-		if (filled != last)
-			continue;
-
-		if (flags & XBF_READ_AHEAD) {
-			xfs_buf_free_pages(bp);
+		if (flags & XBF_READ_AHEAD)
 			return -ENOMEM;
-		}
-
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		memalloc_retry_wait(gfp_mask);
 	}
-	return 0;
-}
-
-/*
- *	Map buffer into kernel address-space if necessary.
- */
-STATIC int
-_xfs_buf_map_pages(
-	struct xfs_buf		*bp,
-	xfs_buf_flags_t		flags)
-{
-	ASSERT(bp->b_flags & _XBF_PAGES);
-	if (bp->b_page_count == 1) {
-		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]);
-	} else {
-		int retried = 0;
-		unsigned nofs_flag;
-
-		/*
-		 * vm_map_ram() will allocate auxiliary structures (e.g.
-		 * pagetables) with GFP_KERNEL, yet we often under a scoped nofs
-		 * context here. Mixing GFP_KERNEL with GFP_NOFS allocations
-		 * from the same call site that can be run from both above and
-		 * below memory reclaim causes lockdep false positives. Hence we
-		 * always need to force this allocation to nofs context because
-		 * we can't pass __GFP_NOLOCKDEP down to auxillary structures to
-		 * prevent false positive lockdep reports.
-		 *
-		 * XXX(dgc): I think dquot reclaim is the only place we can get
-		 * to this function from memory reclaim context now. If we fix
-		 * that like we've fixed inode reclaim to avoid writeback from
-		 * reclaim, this nofs wrapping can go away.
-		 */
-		nofs_flag = memalloc_nofs_save();
-		do {
-			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
-						-1);
-			if (bp->b_addr)
-				break;
-			vm_unmap_aliases();
-		} while (retried++ <= 1);
-		memalloc_nofs_restore(nofs_flag);
-
-		if (!bp->b_addr)
-			return -ENOMEM;
-	}
 
 	return 0;
 }
@@ -562,7 +455,7 @@ xfs_buf_find_lock(
 			return -ENOENT;
 		}
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
+		bp->b_flags &= _XBF_KMEM;
 		bp->b_ops = NULL;
 	}
 	return 0;
@@ -748,18 +641,6 @@ xfs_buf_get_map(
 			xfs_perag_put(pag);
 	}
 
-	/* We do not hold a perag reference anymore. */
-	if (!bp->b_addr) {
-		error = _xfs_buf_map_pages(bp, flags);
-		if (unlikely(error)) {
-			xfs_warn_ratelimited(btp->bt_mount,
-				"%s: failed to map %u pages", __func__,
-				bp->b_page_count);
-			xfs_buf_relse(bp);
-			return error;
-		}
-	}
-
 	/*
 	 * Clear b_error if this is a lookup from a caller that doesn't expect
 	 * valid data to be found in the buffer.
@@ -1002,14 +883,6 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail_free_buf;
 
-	if (!bp->b_addr)
-		error = _xfs_buf_map_pages(bp, 0);
-	if (unlikely(error)) {
-		xfs_warn(target->bt_mount,
-			"%s: failed to map pages", __func__);
-		goto fail_free_buf;
-	}
-
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
 	*bpp = bp;
 	return 0;
@@ -1343,7 +1216,7 @@ __xfs_buf_ioend(
 	if (bp->b_flags & XBF_READ) {
 		if (!bp->b_error && is_vmalloc_addr(bp->b_addr))
 			invalidate_kernel_vmap_range(bp->b_addr,
-					xfs_buf_vmap_len(bp));
+				roundup(BBTOB(bp->b_length), PAGE_SIZE));
 		if (!bp->b_error && bp->b_ops)
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
@@ -1504,29 +1377,48 @@ static void
 xfs_buf_submit_bio(
 	struct xfs_buf		*bp)
 {
-	unsigned int		size = BBTOB(bp->b_length);
-	unsigned int		map = 0, p;
+	unsigned int		map = 0;
 	struct blk_plug		plug;
 	struct bio		*bio;
 
-	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_page_count,
-			xfs_buf_bio_op(bp), GFP_NOIO);
-	bio->bi_private = bp;
-	bio->bi_end_io = xfs_buf_bio_end_io;
+	if (is_vmalloc_addr(bp->b_addr)) {
+		unsigned int	size = BBTOB(bp->b_length);
+		unsigned int	alloc_size = roundup(size, PAGE_SIZE);
+		void		*data = bp->b_addr;
 
-	if (bp->b_page_count == 1) {
-		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
-				offset_in_page(bp->b_addr));
-	} else {
-		for (p = 0; p < bp->b_page_count; p++)
-			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
-		bio->bi_iter.bi_size = size; /* limit to the actual size used */
+		bio = bio_alloc(bp->b_target->bt_bdev, alloc_size >> PAGE_SHIFT,
+				xfs_buf_bio_op(bp), GFP_NOIO);
+
+		do {
+			unsigned int	len = min(size, PAGE_SIZE);
 
-		if (is_vmalloc_addr(bp->b_addr))
-			flush_kernel_vmap_range(bp->b_addr,
-					xfs_buf_vmap_len(bp));
+			ASSERT(offset_in_page(data) == 0);
+			__bio_add_page(bio, vmalloc_to_page(data), len, 0);
+			data += len;
+			size -= len;
+		} while (size);
+
+		flush_kernel_vmap_range(bp->b_addr, alloc_size);
+	} else {
+		/*
+		 * Single folio or slab allocation.  Must be contiguous and thus
+		 * only a single bvec is needed.
+		 *
+		 * This uses the page based bio add helper for now as that is
+		 * the lowest common denominator between folios and slab
+		 * allocations.  To be replaced with a better block layer
+		 * helper soon (hopefully).
+		 */
+		bio = bio_alloc(bp->b_target->bt_bdev, 1, xfs_buf_bio_op(bp),
+				GFP_NOIO);
+		__bio_add_page(bio, virt_to_page(bp->b_addr),
+				BBTOB(bp->b_length),
+				offset_in_page(bp->b_addr));
 	}
 
+	bio->bi_private = bp;
+	bio->bi_end_io = xfs_buf_bio_end_io;
+
 	/*
 	 * If there is more than one map segment, split out a new bio for each
 	 * map except of the last one.  The last map is handled by the
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8db522f19b0c..db43bdc17f55 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -36,7 +36,6 @@ struct xfs_buf;
 #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
 
 /* flags used only internally */
-#define _XBF_PAGES	 (1u << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
 
@@ -61,7 +60,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
-	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
@@ -122,8 +120,6 @@ struct xfs_buftarg {
 	struct xfs_buf_cache	bt_cache[];
 };
 
-#define XB_PAGES	2
-
 struct xfs_buf_map {
 	xfs_daddr_t		bm_bn;	/* block number for I/O */
 	int			bm_len;	/* size of I/O */
@@ -185,13 +181,10 @@ struct xfs_buf {
 	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
 	struct xfs_trans	*b_transp;
-	struct page		**b_pages;	/* array of page pointers */
-	struct page		*b_page_array[XB_PAGES]; /* inline pages */
 	struct xfs_buf_map	*b_maps;	/* compound buffer map */
 	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
 	int			b_map_count;
 	atomic_t		b_pin_count;	/* pin count */
-	unsigned int		b_page_count;	/* size of page array */
 	int			b_error;	/* error code on I/O */
 	void			(*b_iodone)(struct xfs_buf *bp);
 
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index 5b64a2b3b113..b207754d2ee0 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -169,9 +169,6 @@ xmbuf_map_page(
 	unlock_page(page);
 
 	bp->b_addr = page_address(page);
-	bp->b_pages = bp->b_page_array;
-	bp->b_pages[0] = page;
-	bp->b_page_count = 1;
 	return 0;
 }
 
@@ -180,16 +177,10 @@ void
 xmbuf_unmap_page(
 	struct xfs_buf		*bp)
 {
-	struct page		*page = bp->b_pages[0];
-
 	ASSERT(xfs_buftarg_is_mem(bp->b_target));
 
-	put_page(page);
-
+	put_page(virt_to_page(bp->b_addr));
 	bp->b_addr = NULL;
-	bp->b_pages[0] = NULL;
-	bp->b_pages = NULL;
-	bp->b_page_count = 0;
 }
 
 /* Is this a valid daddr within the buftarg? */
-- 
2.45.2

