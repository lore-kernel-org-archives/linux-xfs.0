Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3F324CEEC
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 14:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183538; cv=none; b=KCBzeSXPDoeCeIoufzVgNTHSKOKbR1ohYecAjwv2PEBG+anmWzhHjOK0CXn97m0o1plKQb/Ta6eW1q/cp4eGsyPYEO7MU71t9bBqJHZla43yXx6mjqkytGz7pBwuQ31lGsliKZAcnNzrgq6+gFO6d7ceqUgesAFC/jZQpTWd9gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183538; c=relaxed/simple;
	bh=QcmZl1OmHY6DwXp1oSmMHoLMcefypQXONy99J3AU7qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/a7qsVYA+nmW9CqN71t/mwWx4wabIy3oqYbq8g6/acjomlGDkv3hBIo6Gvur/PCd7d/T7idatNjv625b9C/D4JUb1MU/XzXAUTMGnj/8XN37XOO2/DVyTNbJWftlOGY0q8KuNXB0u42RGqRm347Rclw4TNAvN8GO2ocxSYVwlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Loht1mcM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Loht1mcM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AbevzKLwBwDUJ8wuHxMZVE7idQ6bHBimJh6UsRV0Xbw=; b=Loht1mcMqPwX00fSIqL9Tmx+oa
	hra+E6nUnOLe+OgLPBj+JkJlJjcE19Gl/AKxo/f0PnUG9G30JxjuPPyXye1tfbkoCwWQy57Mts9Ni
	aOqQoJxJbqQ3Z4H+10SyOHuxiZRRsSUafmQAwy6rV0NbeNnI3remL9umOHTRTlDqyjvLwCyDVHI+0
	ZjegDdQCQR9ud9LAiKVLQO4Y23Dl/tvcdsTLqDJmvk62X4gfc2C1+5UKh9ulkdlHCvKFBOjt8N7Tv
	LTH14P8m0oKqrKld84P3jjbimUPVyX2CyKoyC9N8IHKzGakL+Gidul6e7kgo1Uxicz6jxIE5bfc4W
	nserSRww==;
Received: from [199.117.230.82] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tppNP-00000008HpH-3Mwo;
	Wed, 05 Mar 2025 14:05:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/12] xfs: convert buffer cache to use high order folios
Date: Wed,  5 Mar 2025 07:05:24 -0700
Message-ID: <20250305140532.158563-8-hch@lst.de>
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

Now that we have the buffer cache using the folio API, we can extend
the use of folios to allocate high order folios for multi-page
buffers rather than an array of single pages that are then vmapped
into a contiguous range.

This creates a new type of single folio buffers that can have arbitrary
order in addition to the existing multi-folio buffers made up of many
single page folios that get vmapped.  The single folio is for now
stashed into the existing b_pages array, but that will go away entirely
later in the series and remove the temporary page vs folio typing issues
that only work because the two structures currently can be used largely
interchangeable.

The code that allocates buffers will optimistically attempt a high
order folio allocation as a fast path if the buffer size is a power
of two and thus fits into a folio. If this high order allocation
fails, then we fall back to the existing multi-folio allocation
code. This now forms the slow allocation path, and hopefully will be
largely unused in normal conditions except for buffers with size
that are not a power of two like larger remote xattrs.

This should improve performance of large buffer operations (e.g.
large directory block sizes) as we should now mostly avoid the
expense of vmapping large buffers (and the vmap lock contention that
can occur) as well as avoid the runtime pressure that frequently
accessing kernel vmapped pages put on the TLBs.

Based on a patch from Dave Chinner <dchinner@redhat.com>, but mutilated
beyond recognition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 52 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 073246d4352f..f0666ef57bd2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -203,9 +203,9 @@ xfs_buf_free_pages(
 
 	for (i = 0; i < bp->b_page_count; i++) {
 		if (bp->b_pages[i])
-			__free_page(bp->b_pages[i]);
+			folio_put(page_folio(bp->b_pages[i]));
 	}
-	mm_account_reclaimed_pages(bp->b_page_count);
+	mm_account_reclaimed_pages(howmany(BBTOB(bp->b_length), PAGE_SIZE));
 
 	if (bp->b_pages != bp->b_page_array)
 		kfree(bp->b_pages);
@@ -277,12 +277,17 @@ xfs_buf_alloc_kmem(
  * For tmpfs-backed buffers used by in-memory btrees this directly maps the
  * tmpfs page cache folios.
  *
- * For real file system buffers there are two different kinds backing memory:
+ * For real file system buffers there are three different kinds backing memory:
  *
  * The first type backs the buffer by a kmalloc allocation.  This is done for
  * less than PAGE_SIZE allocations to avoid wasting memory.
  *
- * The second type of buffer is the multi-page buffer. These are always made
+ * The second type is a single folio buffer - this may be a high order folio or
+ * just a single page sized folio, but either way they get treated the same way
+ * by the rest of the code - the buffer memory spans a single contiguous memory
+ * region that we don't have to map and unmap to access the data directly.
+ *
+ * The third type of buffer is the multi-page buffer. These are always made
  * up of single pages so that they can be fed to vmap_ram() to return a
  * contiguous memory region we can access the data through, or mark it as
  * XBF_UNMAPPED and access the data directly through individual page_address()
@@ -295,6 +300,7 @@ xfs_buf_alloc_backing_mem(
 {
 	size_t		size = BBTOB(bp->b_length);
 	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
+	struct folio	*folio;
 	long		filled = 0;
 
 	if (xfs_buftarg_is_mem(bp->b_target))
@@ -316,7 +322,41 @@ xfs_buf_alloc_backing_mem(
 	if (size < PAGE_SIZE && is_power_of_2(size))
 		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
 
-	/* Make sure that we have a page list */
+	/*
+	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
+	 * won't do any better.
+	 */
+	if (size <= PAGE_SIZE)
+		gfp_mask |= __GFP_NOFAIL;
+
+	/*
+	 * Optimistically attempt a single high order folio allocation for
+	 * larger than PAGE_SIZE buffers.
+	 *
+	 * Allocating a high order folio makes the assumption that buffers are a
+	 * power-of-2 size, matching the power-of-2 folios sizes available.
+	 *
+	 * The exception here are user xattr data buffers, which can be arbitrarily
+	 * sized up to 64kB plus structure metadata, skip straight to the vmalloc
+	 * path for them instead of wasting memory here.
+	 */
+	if (size > PAGE_SIZE && !is_power_of_2(size))
+		goto fallback;
+	folio = folio_alloc(gfp_mask, get_order(size));
+	if (!folio) {
+		if (size <= PAGE_SIZE)
+			return -ENOMEM;
+		goto fallback;
+	}
+	bp->b_addr = folio_address(folio);
+	bp->b_page_array[0] = &folio->page;
+	bp->b_pages = bp->b_page_array;
+	bp->b_page_count = 1;
+	bp->b_flags |= _XBF_PAGES;
+	return 0;
+
+fallback:
+	/* Fall back to allocating an array of single page folios. */
 	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
 	if (bp->b_page_count <= XB_PAGES) {
 		bp->b_pages = bp->b_page_array;
@@ -1474,7 +1514,7 @@ xfs_buf_submit_bio(
 	bio->bi_private = bp;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 
-	if (bp->b_flags & _XBF_KMEM) {
+	if (bp->b_page_count == 1) {
 		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
 				offset_in_page(bp->b_addr));
 	} else {
-- 
2.45.2

