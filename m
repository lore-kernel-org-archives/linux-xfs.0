Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6162F1EF07
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 19:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705952388; cv=none; b=dT3bxEKF/TH2J6148Ov5CW/OQ/3H/mVKs/3tpr4LUWfGRuaZbVpcGXat6eUa1v1KrazDG3hmZAHqJLiw2DD/3OJJTDkQGSkdTA3tLncK1gP7wHEy1tRP4kDBde9n1xDc/rHbKbnZKkW2QYQplMOaDHh2v44q3kpbJ8nhzmNXIzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705952388; c=relaxed/simple;
	bh=tOlNQIdxJ8LfTJIkMSwj+DuHqrWfwaNAevXGYxT38kk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J2ZxPppySiGdDkBZz+/XKlxYY9QG7tRfv6h98uA9BoJPsOHwORlNrZo4gX3HL9ArPf2/bBoG6ZSNjU8ZW/GiU0bJ+Rm+78DXJXaEmFaFAidJhDmBah8UBW+IC6b9c0SUICPOflFHR+TFwwS19giGFUxjwIYMGBHivJWretp0gm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DfWRiL9N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DfWRiL9N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RQdjCj/qGfZg49bDD/iy9II5Zl5PHBeiToOyt1DCDp0=; b=DfWRiL9N8lTtWEFVmpXlxgDHZD
	DCCz4xXLeO1HTsVW/tx0Id31sWnxHovZcbNxWt7IRA7HICxaBnghQdQ8rpVM7ZTWRX0sdAstnNuOO
	UrJl+wZv71JOLwl8y53SY+/1o+1Z6CAsSrpk38FFsu85xS4LlKeUQp7N7dBAQ01AF9P+lSZ/A5tJN
	Recb6RpS5KPRwwU7MuE/qhMW+q4k5wiyhLcJ1NcL3IhKSE6TCgrZEjUL77NpaDiE13F7FtODR75Aw
	PWE+HGOin86eTc19g//VZMyFt7PSg+yEs0PK5BJJzfm1bZClGiIi0Os3cclrC4hKIW7ZwXsEH7tfH
	QYia5EKQ==;
Received: from [2001:4bb8:198:a22c:146a:86ef:5806:b115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rS091-00DkWT-0Q;
	Mon, 22 Jan 2024 19:39:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: use vmalloc for multi-page buffers
Date: Mon, 22 Jan 2024 20:39:16 +0100
Message-Id: <20240122193916.1803448-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122193916.1803448-1-hch@lst.de>
References: <20240122193916.1803448-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Instead of allocating the pages manually using the bulk page allocator
and then using vm_map_page just use vmalloc to allocate the entire
buffer - vmalloc will use the bulk allocator internally if it fits.

With this the b_pages array can go away as well as nothing uses it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 96 +++++++++---------------------------------------
 fs/xfs/xfs_buf.h |  4 --
 2 files changed, 18 insertions(+), 82 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ddd917bed22e34..6c2c4c809cc55c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -197,7 +197,7 @@ xfs_buf_get_maps(
 }
 
 /*
- *	Frees b_pages if it was allocated.
+ *	Frees b_maps if it was allocated.
  */
 static void
 xfs_buf_free_maps(
@@ -271,29 +271,6 @@ _xfs_buf_alloc(
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
-	if (xfs_buf_is_vmapped(bp))
-		vm_unmap_ram(bp->b_addr, bp->b_page_count);
-
-	for (i = 0; i < bp->b_page_count; i++) {
-		if (bp->b_pages[i])
-			__free_page(bp->b_pages[i]);
-	}
-	mm_account_reclaimed_pages(bp->b_page_count);
-
-	if (bp->b_pages != bp->b_page_array)
-		kmem_free(bp->b_pages);
-	bp->b_pages = NULL;
-	bp->b_flags &= ~_XBF_PAGES;
-}
-
 static void
 xfs_buf_free_callback(
 	struct callback_head	*cb)
@@ -312,10 +289,15 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
+	if (!(bp->b_flags & _XBF_KMEM))
+		mm_account_reclaimed_pages(bp->b_page_count);
+
 	if (bp->b_flags & _XBF_PAGES)
-		xfs_buf_free_pages(bp);
-	else if (bp->b_flags & _XBF_KMEM)
-		kmem_free(bp->b_addr);
+		put_page(virt_to_page(bp->b_addr));
+	else
+		kvfree(bp->b_addr);
+
+	bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
@@ -343,8 +325,6 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_pages = bp->b_page_array;
-	bp->b_pages[0] = kmem_to_page(bp->b_addr);
 	bp->b_page_count = 1;
 	bp->b_flags |= _XBF_KMEM;
 	return 0;
@@ -356,7 +336,6 @@ xfs_buf_alloc_pages(
 	xfs_buf_flags_t	flags)
 {
 	gfp_t		gfp_mask = __GFP_NOWARN;
-	long		filled = 0;
 
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
@@ -365,56 +344,24 @@ xfs_buf_alloc_pages(
 
 	/* Make sure that we have a page list */
 	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
-	if (bp->b_page_count <= XB_PAGES) {
-		bp->b_pages = bp->b_page_array;
-	} else {
-		bp->b_pages = kzalloc(sizeof(struct page *) * bp->b_page_count,
-					gfp_mask);
-		if (!bp->b_pages)
-			return -ENOMEM;
-	}
-	bp->b_flags |= _XBF_PAGES;
 
 	/* Assure zeroed buffer for non-read cases. */
 	if (!(flags & XBF_READ))
 		gfp_mask |= __GFP_ZERO;
 
-	/*
-	 * Bulk filling of pages can take multiple calls. Not filling the entire
-	 * array is not an allocation failure, so don't back off if we get at
-	 * least one extra page.
-	 */
-	for (;;) {
-		long	last = filled;
-
-		filled = alloc_pages_bulk_array(gfp_mask, bp->b_page_count,
-						bp->b_pages);
-		if (filled == bp->b_page_count) {
-			XFS_STATS_INC(bp->b_mount, xb_page_found);
-			break;
-		}
-
-		if (filled != last)
-			continue;
+	if (bp->b_page_count == 1) {
+		struct page *page;
 
-		if (flags & XBF_READ_AHEAD) {
-			xfs_buf_free_pages(bp);
+		page = alloc_page(gfp_mask);
+		if (!page)
 			return -ENOMEM;
-		}
-
-		XFS_STATS_INC(bp->b_mount, xb_page_retries);
-		memalloc_retry_wait(gfp_mask);
-	}
-
-	if (bp->b_page_count == 1) {
-		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]);
+		bp->b_addr = page_address(page);
+		bp->b_flags |= _XBF_PAGES;
 	} else {
-		int retried = 0;
 		unsigned nofs_flag;
 
 		/*
-		 * vm_map_ram() will allocate auxiliary structures (e.g.
+		 * vmalloc() will allocate auxiliary structures (e.g.
 		 * pagetables) with GFP_KERNEL, yet we are likely to be under
 		 * GFP_NOFS context here. Hence we need to tell memory reclaim
 		 * that we are in such a context via PF_MEMALLOC_NOFS to prevent
@@ -422,20 +369,13 @@ xfs_buf_alloc_pages(
 		 * potentially deadlocking.
 		 */
 		nofs_flag = memalloc_nofs_save();
-		do {
-			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
-						-1);
-			if (bp->b_addr)
-				break;
-			vm_unmap_aliases();
-		} while (retried++ <= 1);
+		bp->b_addr = __vmalloc(BBTOB(bp->b_length), gfp_mask);
 		memalloc_nofs_restore(nofs_flag);
 
 		if (!bp->b_addr) {
 			xfs_warn_ratelimited(bp->b_target->bt_mount,
-				"%s: failed to map %u pages", __func__,
+				"%s: failed to allocate %u pages", __func__,
 				bp->b_page_count);
-			xfs_buf_free_pages(bp);
 			return -ENOMEM;
 		}
 	}
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 2116fed2b53026..b114bfa1b07fb6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -114,8 +114,6 @@ typedef struct xfs_buftarg {
 	struct ratelimit_state	bt_ioerror_rl;
 } xfs_buftarg_t;
 
-#define XB_PAGES	2
-
 struct xfs_buf_map {
 	xfs_daddr_t		bm_bn;	/* block number for I/O */
 	int			bm_len;	/* size of I/O */
@@ -178,8 +176,6 @@ struct xfs_buf {
 	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
 	struct xfs_trans	*b_transp;
-	struct page		**b_pages;	/* array of page pointers */
-	struct page		*b_page_array[XB_PAGES]; /* inline pages */
 	struct xfs_buf_map	*b_maps;	/* compound buffer map */
 	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
 	int			b_map_count;
-- 
2.39.2

