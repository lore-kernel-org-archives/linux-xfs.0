Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7BB1A9B3B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612794; cv=none; b=KigvbutNLITAEqaItg3MhV8Dt892yOVSVVrX/G2Kw7ShK1igDxk+HBewS0WnffxLFWWQ9zzvquu5MVJFErhlg/1dCjC92t142rjeATeIR41ghEccFASGPQcpkX0peLarQcpHQ+K5hEzAsqB4CkIPCZSzylUfgd4+JdtT/gFAN2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612794; c=relaxed/simple;
	bh=5IEQ6TY+SKTkOft5NNBYc1gbucdVzhK5l+PmrlXWaqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMiFCaTznZE6M9mmVYoO8dRflSczGcUOMLht5NLIo1tJ8dFkmWDfC+JtoSknGONVH3GiquqH21OmjKzzv/712hSfBWD2SiH2vixMtEkYrKR3UyFTtTvb1U/E6P5XbgM78p2KAq0CGH6mvsjRmm7zSP6XboLld/m3nFAhukFI8ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lO6K0AuJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lO6K0AuJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Zp7YuC/6iQS9Rh4KdtE0xlRDdCblW3KUxAEhk89UD5k=; b=lO6K0AuJ6X37clIjbgGvFlaTTl
	sL24CJTfKUl+1ntIUvluI3D64BnV8iyAionLr+Z45BwgQoFcAfsRZwmvscA8rbkm4iYnBsZikPdxL
	sbhUENXx4gBgFHlb5OLfSQrrnwqKEI9riXQ1M+oH8OoT+tsEJ6AGS7S7IB3j70O9lMgDbr3yVaXWs
	aaiKGQin5aL+v+a/gVZS8eq7Dre92l4cW4tDmFg1Ggt6jEgoVK+tzhSb+5MPzXueRgsrCDv4zupBE
	RJ2LcCctIUKz41jx5pvfDfLn11O8hJuQtoOX9ib9gGP2+jGFc/WOSCYgp0ah4WX8Z+6M5Rna106e5
	6kE1Bo7g==;
Received: from [212.185.66.17] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1trd2u-00000002lks-1rUO;
	Mon, 10 Mar 2025 13:19:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/12] xfs: convert buffer cache to use high order folios
Date: Mon, 10 Mar 2025 14:19:10 +0100
Message-ID: <20250310131917.552600-8-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 56 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index acf19b5221bf..a831e8c755cb 100644
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
@@ -316,7 +322,45 @@ xfs_buf_alloc_backing_mem(
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
+	if (size > PAGE_SIZE) {
+		if (!is_power_of_2(size))
+			goto fallback;
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+		gfp_mask |= __GFP_NORETRY;
+	}
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
@@ -1474,7 +1518,7 @@ xfs_buf_submit_bio(
 	bio->bi_private = bp;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 
-	if (bp->b_flags & _XBF_KMEM) {
+	if (bp->b_page_count == 1) {
 		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
 				offset_in_page(bp->b_addr));
 	} else {
-- 
2.45.2

