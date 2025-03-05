Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7A924CED7
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 14:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183537; cv=none; b=TDzH0BzodW4o4FHfD/F9AgocudKlTnj5CJuppzabHF1UnGg5EoAzinI3ZXLNUEqd6WVrDATjlqSF3uHU15EnTv3ZcBAs6ywyL/Rv3x81GYrLmRbD8w6FG8FinA/xWsfu5oKLCI0s+OmbkYuqfd9jFpmOq8viDUsl1oGfwQg0F2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183537; c=relaxed/simple;
	bh=Xmequ+BGBaXKstKLGYY6NGlsLTR2Bgf3MF7zHlzT29k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6UcYLAnXyAYnip+7r4234QMClNT9BWSRkW7VCllUDWcSymWRV8gMN40hs1XO6Cajn96SJavC3Aq9XvK8mPXbtNU5MzCJu7OY/FUZ78RnBD3uqNrYiWoKi6Ah85IFyDBlSjrVvaTo4OQFStEbyQE+kP7YG5GQlNSZsW2GR/OtZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zGu8d/JD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zGu8d/JD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+eCLGyLETe//T0Wy8nOPKwtPiW8qQ2ykwredvCRXjYg=; b=zGu8d/JDMyfTCFSUajje9eghyK
	SYTbDuZ+FL0tJ6p5ZhFaL8NZJ1OOZbh+Yd7bXPtqYa//9+QAxFEiG1D63EtIkED2ifajpGaHcYi11
	neE5f49Bnh64EG1RcTcoqeoYba8YE2+xZltjNXwNUUhf2QE1tQx6nFRLEseG81osEM/aWiGUd2db7
	0EFW2JqsZbw5OZmt05FLFSOxaHEZWqKXEdBJF6ZLzRUPVInwVguyRwMxKFLXcrhwyUloYZYeGqMT3
	thCiQd8mPliYg66+jMRTbaRBhq9fqDz+9UcaCNjyHZJAbmzs52yw8Xf8lwdxPqP/RN12CDxm+uoLS
	R0B2V92g==;
Received: from [199.117.230.82] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tppNP-00000008Hp6-1Jps;
	Wed, 05 Mar 2025 14:05:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/12] xfs: remove the kmalloc to page allocator fallback
Date: Wed,  5 Mar 2025 07:05:23 -0700
Message-ID: <20250305140532.158563-7-hch@lst.de>
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

Since commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment
for kmalloc(power-of-two)", kmalloc and friends guarantee that power of
two sized allocations are naturally aligned.  Limit our use of kmalloc
for buffers to these power of two sizes and remove the fallback to
the page allocator for this case, but keep a check in addition to
trusting the slab allocator to get the alignment right.

Also refactor the kmalloc path to reuse various calculations for the
size and gfp flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 18ec1c1fbca1..073246d4352f 100644
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
+	 * allocation for all power of two sizes, we matches most of the smaller
+	 * than PAGE_SIZE buffers used by XFS.
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

