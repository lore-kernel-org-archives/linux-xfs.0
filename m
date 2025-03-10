Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D70227E8F
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612790; cv=none; b=quKzahaqeRJMB5QAfGULRFl1nzqjho/04KEZe878KUXrpSoXaYHsWrvr9V8YpFFEEwCqdjPj6RMyJsI1pLI5RU8r05U4x+hWonZI82sluem9ZU7h+4PFFx1m0n6wcEs81YxUYeW32QmHbKR2/+d0LE6+YvngIXwVb3ZQKi9lTaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612790; c=relaxed/simple;
	bh=B0ehPUHGeOv3M0CX4pUn3x1oui0EDnkpam52UAuoqbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg8fNWaSMn+bEBZU2TVfUZQrG/GMZS+2md8CMIS7E9FkmXkhUCa8wMR3UQKToEPfFq0blscbIo839oTmZPKLEg01S1fngN3UqRJZ0KF8/6eSqM74vJmcsESk2pO4xCI+MizIgArHKsAnbviLGjGiF/IBuNJdonGt+uWSbp+fBdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UbZSWDtA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UbZSWDtA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4xr/hXnHaZNUxB+fgkE0ZY53GJ1WVWXIzvqyPKD/MlM=; b=UbZSWDtAG3qoUA3/ZUv7x9d32T
	DC7dFYoyoKD5FDMG3mNR3AZF0sA7vBqPt4XaQiA1y42z+fqfHPz4P0Y4WGkUeGSQ2OoAwdJDpQKOW
	riZ7uuRKnuDJTQ0+4T859Nb8yMHurxu1IcCAMs2RtY3Vu6FzltEqxDEhWD+BSk1cfTetJLeRxH6qP
	1+2zFyuzrscRB3dcP6xUpMgjz1nvHIkGAP2AUfCFFBk61qh0Wd7Wx53ZNzy+fP7u5/p+W8Hj5ZLSR
	/wMxRJh16G77ktliQaL2YooFsnAoAR9BUrI8p+t8QP1wNbhpv5ujgRWzspyz9Rx9z25JVW6iH0p6J
	x59mjieA==;
Received: from [212.185.66.17] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1trd2q-00000002lk5-02EW;
	Mon, 10 Mar 2025 13:19:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/12] xfs: remove the kmalloc to page allocator fallback
Date: Mon, 10 Mar 2025 14:19:09 +0100
Message-ID: <20250310131917.552600-7-hch@lst.de>
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

Since commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment
for kmalloc(power-of-two)", kmalloc and friends guarantee that power of
two sized allocations are naturally aligned.  Limit our use of kmalloc
for buffers to these power of two sizes and remove the fallback to
the page allocator for this case, but keep a check in addition to
trusting the slab allocator to get the alignment right.

Also refactor the kmalloc path to reuse various calculations for the
size and gfp flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 18ec1c1fbca1..acf19b5221bf 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -243,23 +243,23 @@ xfs_buf_free(
 
 static int
 xfs_buf_alloc_kmem(
-	struct xfs_buf	*bp,
-	xfs_buf_flags_t	flags)
+	struct xfs_buf		*bp,
+	size_t			size,
+	gfp_t			gfp_mask)
 {
-	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL;
-	size_t		size = BBTOB(bp->b_length);
-
-	/* Assure zeroed buffer for non-read cases. */
-	if (!(flags & XBF_READ))
-		gfp_mask |= __GFP_ZERO;
+	ASSERT(is_power_of_2(size));
+	ASSERT(size < PAGE_SIZE);
 
-	bp->b_addr = kmalloc(size, gfp_mask);
+	bp->b_addr = kmalloc(size, gfp_mask | __GFP_NOFAIL);
 	if (!bp->b_addr)
 		return -ENOMEM;
 
-	if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
-	    ((unsigned long)bp->b_addr & PAGE_MASK)) {
-		/* b_addr spans two pages - use alloc_page instead */
+	/*
+	 * Slab guarantees that we get back naturally aligned allocations for
+	 * power of two sizes.  Keep this check as the canary in the coal mine
+	 * if anything changes in slab.
+	 */
+	if (WARN_ON_ONCE(!IS_ALIGNED((unsigned long)bp->b_addr, size))) {
 		kfree(bp->b_addr);
 		bp->b_addr = NULL;
 		return -ENOMEM;
@@ -300,18 +300,22 @@ xfs_buf_alloc_backing_mem(
 	if (xfs_buftarg_is_mem(bp->b_target))
 		return xmbuf_map_page(bp);
 
-	/*
-	 * For buffers that fit entirely within a single page, first attempt to
-	 * allocate the memory from the heap to minimise memory usage.  If we
-	 * can't get heap memory for these small buffers, we fall back to using
-	 * the page allocator.
-	 */
-	if (size < PAGE_SIZE && xfs_buf_alloc_kmem(new_bp, flags) == 0)
-		return 0;
+	/* Assure zeroed buffer for non-read cases. */
+	if (!(flags & XBF_READ))
+		gfp_mask |= __GFP_ZERO;
 
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
 
+	/*
+	 * For buffers smaller than PAGE_SIZE use a kmalloc allocation if that
+	 * is properly aligned.  The slab allocator now guarantees an aligned
+	 * allocation for all power of two sizes, which matches most of the
+	 * smaller than PAGE_SIZE buffers used by XFS.
+	 */
+	if (size < PAGE_SIZE && is_power_of_2(size))
+		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
+
 	/* Make sure that we have a page list */
 	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
 	if (bp->b_page_count <= XB_PAGES) {
@@ -324,10 +328,6 @@ xfs_buf_alloc_backing_mem(
 	}
 	bp->b_flags |= _XBF_PAGES;
 
-	/* Assure zeroed buffer for non-read cases. */
-	if (!(flags & XBF_READ))
-		gfp_mask |= __GFP_ZERO;
-
 	/*
 	 * Bulk filling of pages can take multiple calls. Not filling the entire
 	 * array is not an allocation failure, so don't back off if we get at
-- 
2.45.2

