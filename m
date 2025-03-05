Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B07524C691
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 14:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183537; cv=none; b=GZmcWWEXH8aZ+zVO5maw3y9g54JuLwCDLomV2Hxn9c06GATHZ59DENH6uHPDN7Fg9bFpKxoboF+cc6qCpNH056OXIRT7qTxEmr2E3habemRZ7yHYyipI95EyTdWGB/6L11/zKfr+8kyZb5dWQnSnqyCHQItd4DxDFV53esLv/Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183537; c=relaxed/simple;
	bh=0g0M51L4Gvq3/U3ExZggc9HBBX+WF8yArGQoOsM3H5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZeKVdubAhvEHtZKrDSNGRuQH+7GyyFNrhdF3+ex7K2IE1tTTZATLqhn2TmPgv6xpSLC0YRAt858ltH23IVM8yk/kPNu6HIfBqayzxjzVYyLSz6oUSObHphjRp/fGk8TmHyq0e9kz80EwU4i0fRENu7D6k5knsITQA41NFKomCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mQQ8MqIG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mQQ8MqIG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=u3u5SBFu977BByac0cc/KeMkkQfggIC2jDRiSSA+4R8=; b=mQQ8MqIGZbJDFOUXQmnPpq49xX
	IOtDDrdpA1O68JeaP6gt+KBQw9zC/2pitDvtv+esn4Z+aHLTnneqnDHP/K+nRKYdIJBibeXtG1BRt
	yic7LtTDkFgRN8MN2/vgnTcOjJVeBUj0AlGSlKSK5r1EUhN+sj/AhEVOz8KvP//BUB3UK5r2JI0H7
	GITX4yiPWDId7bkO5Ls/VfNYyyXdOmrYv7r18ZpiHWTTRFnSMtYVgQe7YcujL7aR3tM6N9XJ7VjBR
	6/MeWG7d/fPagZ+WYjmim9Fu3qRqPDKEW07Ez7w/qHlZ2HV0V9X5gx2dTuKo0XT517XmNvizx02mF
	tcRhf6CA==;
Received: from [199.117.230.82] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tppNO-00000008Hoz-3UQY;
	Wed, 05 Mar 2025 14:05:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/12] xfs: refactor backing memory allocations for buffers
Date: Wed,  5 Mar 2025 07:05:22 -0700
Message-ID: <20250305140532.158563-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250305140532.158563-1-hch@lst.de>
References: <20250305140532.158563-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Lift handling of shmem and slab backed buffers into xfs_buf_alloc_pages
and rename the result to xfs_buf_alloc_backing_mem.  This shares more
code and ensures uncached buffers can also use slab, which slightly
reduces the memory usage of growfs on 512 byte sector size file systems,
but more importantly means the allocation invariants are the same for
cached and uncached buffers.  Document these new invariants with a big
fat comment mostly stolen from a patch by Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 55 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 58eaf5a13c12..18ec1c1fbca1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -271,19 +271,49 @@ xfs_buf_alloc_kmem(
 	return 0;
 }
 
+/*
+ * Allocate backing memory for a buffer.
+ *
+ * For tmpfs-backed buffers used by in-memory btrees this directly maps the
+ * tmpfs page cache folios.
+ *
+ * For real file system buffers there are two different kinds backing memory:
+ *
+ * The first type backs the buffer by a kmalloc allocation.  This is done for
+ * less than PAGE_SIZE allocations to avoid wasting memory.
+ *
+ * The second type of buffer is the multi-page buffer. These are always made
+ * up of single pages so that they can be fed to vmap_ram() to return a
+ * contiguous memory region we can access the data through, or mark it as
+ * XBF_UNMAPPED and access the data directly through individual page_address()
+ * calls.
+ */
 static int
-xfs_buf_alloc_pages(
+xfs_buf_alloc_backing_mem(
 	struct xfs_buf	*bp,
 	xfs_buf_flags_t	flags)
 {
+	size_t		size = BBTOB(bp->b_length);
 	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
 	long		filled = 0;
 
+	if (xfs_buftarg_is_mem(bp->b_target))
+		return xmbuf_map_page(bp);
+
+	/*
+	 * For buffers that fit entirely within a single page, first attempt to
+	 * allocate the memory from the heap to minimise memory usage.  If we
+	 * can't get heap memory for these small buffers, we fall back to using
+	 * the page allocator.
+	 */
+	if (size < PAGE_SIZE && xfs_buf_alloc_kmem(new_bp, flags) == 0)
+		return 0;
+
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
 
 	/* Make sure that we have a page list */
-	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
+	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
 	if (bp->b_page_count <= XB_PAGES) {
 		bp->b_pages = bp->b_page_array;
 	} else {
@@ -564,18 +594,7 @@ xfs_buf_find_insert(
 	if (error)
 		goto out_drop_pag;
 
-	if (xfs_buftarg_is_mem(new_bp->b_target)) {
-		error = xmbuf_map_page(new_bp);
-	} else if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
-		   xfs_buf_alloc_kmem(new_bp, flags) < 0) {
-		/*
-		 * For buffers that fit entirely within a single page, first
-		 * attempt to allocate the memory from the heap to minimise
-		 * memory usage. If we can't get heap memory for these small
-		 * buffers, we fall back to using the page allocator.
-		 */
-		error = xfs_buf_alloc_pages(new_bp, flags);
-	}
+	error = xfs_buf_alloc_backing_mem(new_bp, flags);
 	if (error)
 		goto out_free_buf;
 
@@ -939,14 +958,12 @@ xfs_buf_get_uncached(
 	if (error)
 		return error;
 
-	if (xfs_buftarg_is_mem(bp->b_target))
-		error = xmbuf_map_page(bp);
-	else
-		error = xfs_buf_alloc_pages(bp, flags);
+	error = xfs_buf_alloc_backing_mem(bp, flags);
 	if (error)
 		goto fail_free_buf;
 
-	error = _xfs_buf_map_pages(bp, 0);
+	if (!bp->b_addr)
+		error = _xfs_buf_map_pages(bp, 0);
 	if (unlikely(error)) {
 		xfs_warn(target->bt_mount,
 			"%s: failed to map pages", __func__);
-- 
2.45.2

