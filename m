Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682D2C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D644613AA
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhESTKd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhESTKc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AACC06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WkYqFq0gmw0ejfLAS6GN8xck2IlJQRuntWdkGwOpufQ=; b=fjB/5Fx2ETLpIi+hoe7p8GaBoV
        nwG3d6z1Ivl8+LWvx/Z9zty+XTklM+qHluQ2MWRWypBMDkBRiT60cbi/qNh6ETVTKPVzIATkCZkXZ
        YF1UCdOcdNLwx5002YpCM+zPx9FZv7LK5uo2TYU0H7O1BtTc4PQNp18YmQESBxGYdKgN4zLJi9Lgi
        YcNM6NtJKNGMbc8m50tD5Q76FBfKKN4kMpCAUsZAs92ehkg5QV7xtbu9F1GQy5FZuqWMuIxbH03mE
        n8ne87coFyIluQVev0ocpDFNX0inN6DCnLQDxVCKfxfWFtXsUiZAudewtQEQeQ+F5P+/PtR99ZdL4
        5xqxaoAg==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZA-00FisI-8a; Wed, 19 May 2021 19:09:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/11] xfs: split xfs_buf_allocate_memory
Date:   Wed, 19 May 2021 21:08:51 +0200
Message-Id: <20210519190900.320044-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split xfs_buf_allocate_memory into one helper that allocates from
slab and one that allocates using the page allocator.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 83 +++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 80be0333f077c0..ac85ec6f0a2fab 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -347,11 +347,41 @@ xfs_buf_free(
 	kmem_cache_free(xfs_buf_zone, bp);
 }
 
+static int
+xfs_buf_alloc_slab(
+	struct xfs_buf		*bp,
+	unsigned int		flags)
+{
+	struct xfs_buftarg	*btp = bp->b_target;
+	int			align = xfs_buftarg_dma_alignment(btp);
+	size_t			size = BBTOB(bp->b_length);
+	xfs_km_flags_t		km_flags = KM_ZERO;
+
+	if (!(flags & XBF_READ))
+		km_flags |= KM_ZERO;
+	bp->b_addr = kmem_alloc_io(size, align, km_flags);
+	if (!bp->b_addr)
+		return -ENOMEM;
+	if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
+	    ((unsigned long)bp->b_addr & PAGE_MASK)) {
+		/* b_addr spans two pages - use alloc_page instead */
+		kmem_free(bp->b_addr);
+		bp->b_addr = NULL;
+		return -ENOMEM;
+	}
+	bp->b_offset = offset_in_page(bp->b_addr);
+	bp->b_pages = bp->b_page_array;
+	bp->b_pages[0] = kmem_to_page(bp->b_addr);
+	bp->b_page_count = 1;
+	bp->b_flags |= _XBF_KMEM;
+	return 0;
+}
+
 /*
  * Allocates all the pages for buffer in question and builds it's page list.
  */
-STATIC int
-xfs_buf_allocate_memory(
+static int
+xfs_buf_alloc_pages(
 	struct xfs_buf		*bp,
 	uint			flags)
 {
@@ -361,47 +391,14 @@ xfs_buf_allocate_memory(
 	unsigned short		page_count, i;
 	xfs_off_t		start, end;
 	int			error;
-	xfs_km_flags_t		kmflag_mask = 0;
 
 	/*
 	 * assure zeroed buffer for non-read cases.
 	 */
-	if (!(flags & XBF_READ)) {
-		kmflag_mask |= KM_ZERO;
+	if (!(flags & XBF_READ))
 		gfp_mask |= __GFP_ZERO;
-	}
 
-	/*
-	 * for buffers that are contained within a single page, just allocate
-	 * the memory from the heap - there's no need for the complexity of
-	 * page arrays to keep allocation down to order 0.
-	 */
 	size = BBTOB(bp->b_length);
-	if (size < PAGE_SIZE) {
-		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
-		bp->b_addr = kmem_alloc_io(size, align_mask,
-					   KM_NOFS | kmflag_mask);
-		if (!bp->b_addr) {
-			/* low memory - use alloc_page loop instead */
-			goto use_alloc_page;
-		}
-
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
-	}
-
-use_alloc_page:
 	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
 	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
 								>> PAGE_SHIFT;
@@ -720,9 +717,17 @@ xfs_buf_get_map(
 	if (error)
 		return error;
 
-	error = xfs_buf_allocate_memory(new_bp, flags);
-	if (error)
-		goto out_free_buf;
+	/*
+	 * For buffers that are contained within a single page, just allocate
+	 * the memory from the heap - there's no need for the complexity of
+	 * page arrays to keep allocation down to order 0.
+	 */
+	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
+	    xfs_buf_alloc_slab(new_bp, flags) < 0) {
+		error = xfs_buf_alloc_pages(new_bp, flags);
+		if (error)
+			goto out_free_buf;
+	}
 
 	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
 	if (error)
-- 
2.30.2

