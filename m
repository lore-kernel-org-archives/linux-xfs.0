Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DC0C47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0365613D2
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhEZWtF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 18:49:05 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58716 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234683AbhEZWtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 18:49:03 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 82296863E15;
        Thu, 27 May 2021 08:47:26 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8T-Jr; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fA8-C6; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 01/10] xfs: split up xfs_buf_allocate_memory
Date:   Thu, 27 May 2021 08:47:13 +1000
Message-Id: <20210526224722.1111377-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526224722.1111377-1-david@fromorbit.com>
References: <20210526224722.1111377-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=6OOVmFOrYTY5mGFiLRsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Based on a patch from Christoph Hellwig.

This splits out the heap allocation and page allocation portions of
the buffer memory allocation into two separate helper functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 126 ++++++++++++++++++++++++++++-------------------
 1 file changed, 74 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 592800c8852f..2e35d344a69b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -347,65 +347,55 @@ xfs_buf_free(
 	kmem_cache_free(xfs_buf_zone, bp);
 }
 
-/*
- * Allocates all the pages for buffer in question and builds it's page list.
- */
-STATIC int
-xfs_buf_allocate_memory(
-	struct xfs_buf		*bp,
-	uint			flags)
+static int
+xfs_buf_alloc_kmem(
+	struct xfs_buf	*bp,
+	size_t		size,
+	xfs_buf_flags_t	flags)
 {
-	size_t			size;
-	size_t			nbytes, offset;
-	gfp_t			gfp_mask = xb_to_gfp(flags);
-	unsigned short		page_count, i;
-	xfs_off_t		start, end;
-	int			error;
-	xfs_km_flags_t		kmflag_mask = 0;
+	int		align_mask = xfs_buftarg_dma_alignment(bp->b_target);
+	xfs_km_flags_t	kmflag_mask = KM_NOFS;
 
-	/*
-	 * assure zeroed buffer for non-read cases.
-	 */
-	if (!(flags & XBF_READ)) {
+	/* Assure zeroed buffer for non-read cases. */
+	if (!(flags & XBF_READ))
 		kmflag_mask |= KM_ZERO;
-		gfp_mask |= __GFP_ZERO;
-	}
 
-	/*
-	 * for buffers that are contained within a single page, just allocate
-	 * the memory from the heap - there's no need for the complexity of
-	 * page arrays to keep allocation down to order 0.
-	 */
-	size = BBTOB(bp->b_length);
-	if (size < PAGE_SIZE) {
-		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
-		bp->b_addr = kmem_alloc_io(size, align_mask,
-					   KM_NOFS | kmflag_mask);
-		if (!bp->b_addr) {
-			/* low memory - use alloc_page loop instead */
-			goto use_alloc_page;
-		}
+	bp->b_addr = kmem_alloc_io(size, align_mask, kmflag_mask);
+	if (!bp->b_addr)
+		return -ENOMEM;
 
-		if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
-		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
-			/* b_addr spans two pages - use alloc_page instead */
-			kmem_free(bp->b_addr);
-			bp->b_addr = NULL;
-			goto use_alloc_page;
-		}
-		bp->b_offset = offset_in_page(bp->b_addr);
-		bp->b_pages = bp->b_page_array;
-		bp->b_pages[0] = kmem_to_page(bp->b_addr);
-		bp->b_page_count = 1;
-		bp->b_flags |= _XBF_KMEM;
-		return 0;
+	if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
+	    ((unsigned long)bp->b_addr & PAGE_MASK)) {
+		/* b_addr spans two pages - use alloc_page instead */
+		kmem_free(bp->b_addr);
+		bp->b_addr = NULL;
+		return -ENOMEM;
 	}
+	bp->b_offset = offset_in_page(bp->b_addr);
+	bp->b_pages = bp->b_page_array;
+	bp->b_pages[0] = kmem_to_page(bp->b_addr);
+	bp->b_page_count = 1;
+	bp->b_flags |= _XBF_KMEM;
+	return 0;
+}
+
+static int
+xfs_buf_alloc_pages(
+	struct xfs_buf	*bp,
+	uint		page_count,
+	xfs_buf_flags_t	flags)
+{
+	gfp_t		gfp_mask = xb_to_gfp(flags);
+	size_t		size;
+	size_t		offset;
+	size_t		nbytes;
+	int		i;
+	int		error;
+
+	/* Assure zeroed buffer for non-read cases. */
+	if (!(flags & XBF_READ))
+		gfp_mask |= __GFP_ZERO;
 
-use_alloc_page:
-	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
-	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
-								>> PAGE_SHIFT;
-	page_count = end - start;
 	error = _xfs_buf_get_pages(bp, page_count);
 	if (unlikely(error))
 		return error;
@@ -458,6 +448,38 @@ xfs_buf_allocate_memory(
 	return error;
 }
 
+
+/*
+ * Allocates all the pages for buffer in question and builds it's page list.
+ */
+static int
+xfs_buf_allocate_memory(
+	struct xfs_buf		*bp,
+	uint			flags)
+{
+	size_t			size;
+	xfs_off_t		start, end;
+	int			error;
+
+	/*
+	 * For buffers that fit entirely within a single page, first attempt to
+	 * allocate the memory from the heap to minimise memory usage. If we
+	 * can't get heap memory for these small buffers, we fall back to using
+	 * the page allocator.
+	 */
+	size = BBTOB(bp->b_length);
+	if (size < PAGE_SIZE) {
+		error = xfs_buf_alloc_kmem(bp, size, flags);
+		if (!error)
+			return 0;
+	}
+
+	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
+	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
+								>> PAGE_SHIFT;
+	return xfs_buf_alloc_pages(bp, end - start, flags);
+}
+
 /*
  *	Map buffer into kernel address-space if necessary.
  */
-- 
2.31.1

