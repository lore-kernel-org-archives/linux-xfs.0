Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDB919ABC3
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585168; cv=none; b=cKCV7sOz8I7nbNJnDzU2XUepCOcOaMhNf4VQ9dWMLDtzMWxmTHyY1+d12RraZENIALipGcoKhji1ajTRB6Uv2Z5/PyNk6YcIUNrzc2csIxdc0c+q8mVMmC4igGjRT+WBv6aYwgkosLBEPBUr9fY/Xrd75GrM1Dl4mc8JpbNxHwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585168; c=relaxed/simple;
	bh=4bc/ddENqE3FBldChmG4jSbV/HC8sIrIGxhd31B6pJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkEDvlq4TlhUw5B6WCbSAW0SDEdjYoCIN6UxI7APHpGVkDIH/CVMrYW35Wur64M1mcd3TTp6vKPcjTshX6mVJOPEZraoMo3MJoU57UW0pWTkZoSWZIdTvddivSYNLbbUjaXnjsHYGJ4z9HaGbnPVAo7VgAMQ/Ey6fzyYurHXmvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uD9PRSRL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uD9PRSRL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3FqZSWqApVrVerO84f5903mZzMqeE9zfd8V7Ewsz0/A=; b=uD9PRSRLiVNY8g+qhbn1eoOYy5
	toKPtRO14p04ubAhj3sulxjobRzjqlcvcB9qmU7e84NCswwmhs3OM1yAhDaSVNk6RAGAUOMwcFVfn
	RV/zBTLFZ8pD5eIsbyEdOjYmjtKNkfH+j56cfOZpRXbT9n9M9rQrA5AlKY5xSOZqA65Nlav34lKgi
	h3cIb47U9hjYeJTEOmiUjjLwtGJzlYh7IzxT+0v8974LY4zVJM3YN3De1p6/It6URwFAhHgEFEERr
	6kVWZxbn+lQP2+Ewx0goeEBlXzyRMK/qyNIWjDjmce8Ct1m3owP7x+loGSvquB0gHo6R48LMJqZhh
	g3w5rOCg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiI-00000004PM7-2Bqx;
	Wed, 26 Feb 2025 15:52:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/12] xfs: refactor backing memory allocations for buffers
Date: Wed, 26 Feb 2025 07:51:33 -0800
Message-ID: <20250226155245.513494-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226155245.513494-1-hch@lst.de>
References: <20250226155245.513494-1-hch@lst.de>
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
---
 fs/xfs/xfs_buf.c | 55 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index af1389ebdd69..e8783ee23623 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -329,19 +329,49 @@ xfs_buf_alloc_kmem(
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
@@ -622,18 +652,7 @@ xfs_buf_find_insert(
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
 
@@ -995,14 +1014,12 @@ xfs_buf_get_uncached(
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

