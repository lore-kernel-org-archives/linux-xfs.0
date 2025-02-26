Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F0A1A238B
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585168; cv=none; b=OYfVi8JwEi+qffF3y1OP86JgYq3PA6XwpudyDinCts3u3bX6nxgHiKEq7yHg+mESkvZmadaa8jVs9r0jCHe5/r8GY6yzvBWDz0DAEDel1IaKO23BbDaO3r8TmRuQqm6t9KnvQU4K2wYbvIniS5jmAIOyfR84G7U+nSO4ujWqs+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585168; c=relaxed/simple;
	bh=4Mea2IyTZn698tpYHAOz4Am+ltGpBFN/5ydRGI2kpRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMKjhA35L0Sk9efIfeUVfWspK2vSxhi45NEV4WUDh53qNUsMpSGWH9VWQnxBIVNlrTyd9qp5UGQAUpxt3jF2sfKkAMVrbaJCGMhjrqiKr5TUBpDHRVdv0Q1GBH4ZTE3A98JGchut+T9cvSj+gaWu5tLT3dOPqDl5SQjwvHLuqko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NpyTUfHm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NpyTUfHm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sMxdrwsWit8CQgbW4NFF0seZY6kKMZsOaHMwfuJcpEk=; b=NpyTUfHmUkn1hh1OjrzKdXElrP
	pSkRw8ewTmFoDskHMuAfEvetdCMuG7uSqvZEp0fVNPu70okw05r5e3/KGDXA0XEvNOk8wGY9h65cr
	MboP7QcVColQi4dtHJKdGiHogUrIfBs1gN5HX7Yc+fUzTLH0YZkqnAOZh14LVnkuOX1bok+8x2Hi0
	F2lqBA5JEJ4575b5OOZYnOy50pmEd6WWkAATl/PL/jLaqxkEpC/WmLVjezg12gJH/h6e+cFVR9Hcj
	twmeVtIVvLTUbBaF84/hP89ruH4D+jU1FJujubFO8FxWkvjl5NOLHcx0Q4Yd+KjT26EiB6ipt7xXV
	FALSjmMg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiI-00000004PMD-2s7y;
	Wed, 26 Feb 2025 15:52:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/12] xfs: remove the kmalloc to page allocator fallback
Date: Wed, 26 Feb 2025 07:51:34 -0800
Message-ID: <20250226155245.513494-7-hch@lst.de>
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
 fs/xfs/xfs_buf.c | 49 ++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e8783ee23623..f327bf5b04c0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -301,23 +301,24 @@ xfs_buf_free(
 
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
+	if (!IS_ALIGNED((unsigned long)bp->b_addr, size)) {
+		ASSERT(IS_ALIGNED((unsigned long)bp->b_addr, size));
 		kfree(bp->b_addr);
 		bp->b_addr = NULL;
 		return -ENOMEM;
@@ -358,18 +359,22 @@ xfs_buf_alloc_backing_mem(
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
+	 * allocation for all power of two sizes, we matches must of the smaller
+	 * than PAGE_SIZE buffers used by XFS.
+	 */
+	if (size < PAGE_SIZE && is_power_of_2(size))
+		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
+
 	/* Make sure that we have a page list */
 	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
 	if (bp->b_page_count <= XB_PAGES) {
@@ -382,10 +387,6 @@ xfs_buf_alloc_backing_mem(
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

