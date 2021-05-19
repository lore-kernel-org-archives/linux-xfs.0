Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC36BC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9CB36135A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhESTKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhESTKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB3EC06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1LkpMa1xzX12C8HxeXz2GOf4uaSF7Xcc60MsdBNrh94=; b=2aYFVwzhIX36xRFY+swyy0+Dt3
        mSlFsVvQlmpgqGiptfFiHWwtskF1Sk38JvC4yZCwjRwK2IBnovWx5USIAFhY24kcmtAMtX5ktzhl2
        iM+A30/EgWI2WmyTBYpewiq1sFUHwHmm1S/ROfNoKpBSDXvBQbkgh3j+0BZSI6bt75+3FbtTMTsdj
        UfJUGDeuJAEgT8gXwZb26wUIYNlI73p0WgzVRRZcpSyUFQSNJ8gPj6GaPz50wFGaANATTtQwSudGL
        0H2pfr0E5aW4D4OM4xkESdhvQs3lHs9PJ9f3hPTTg2wk+4OfIn0s7+6F9W1Y7UEV79YCc/nfFFPo2
        abfz6oGw==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZD-00FisP-9x; Wed, 19 May 2021 19:09:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/11] xfs: remove ->b_offset handling for page backed buffers
Date:   Wed, 19 May 2021 21:08:52 +0200
Message-Id: <20210519190900.320044-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

->b_offset can only be non-zero for SLAB backed buffers, so remove all
code dealing with it for page backed buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 15 +++++----------
 fs/xfs/xfs_buf.h |  3 ++-
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ac85ec6f0a2fab..392b85d059bff5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -79,7 +79,7 @@ static inline int
 xfs_buf_vmap_len(
 	struct xfs_buf	*bp)
 {
-	return (bp->b_page_count * PAGE_SIZE) - bp->b_offset;
+	return (bp->b_page_count * PAGE_SIZE);
 }
 
 /*
@@ -329,8 +329,7 @@ xfs_buf_free(
 		uint		i;
 
 		if (xfs_buf_is_vmapped(bp))
-			vm_unmap_ram(bp->b_addr - bp->b_offset,
-					bp->b_page_count);
+			vm_unmap_ram(bp->b_addr, bp->b_page_count);
 
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
@@ -386,7 +385,7 @@ xfs_buf_alloc_pages(
 	uint			flags)
 {
 	size_t			size;
-	size_t			nbytes, offset;
+	size_t			nbytes;
 	gfp_t			gfp_mask = xb_to_gfp(flags);
 	unsigned short		page_count, i;
 	xfs_off_t		start, end;
@@ -407,7 +406,6 @@ xfs_buf_alloc_pages(
 	if (unlikely(error))
 		return error;
 
-	offset = bp->b_offset;
 	bp->b_flags |= _XBF_PAGES;
 
 	for (i = 0; i < bp->b_page_count; i++) {
@@ -441,10 +439,9 @@ xfs_buf_alloc_pages(
 
 		XFS_STATS_INC(bp->b_mount, xb_page_found);
 
-		nbytes = min_t(size_t, size, PAGE_SIZE - offset);
+		nbytes = min_t(size_t, size, PAGE_SIZE);
 		size -= nbytes;
 		bp->b_pages[i] = page;
-		offset = 0;
 	}
 	return 0;
 
@@ -466,7 +463,7 @@ _xfs_buf_map_pages(
 	ASSERT(bp->b_flags & _XBF_PAGES);
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
+		bp->b_addr = page_address(bp->b_pages[0]);
 	} else if (flags & XBF_UNMAPPED) {
 		bp->b_addr = NULL;
 	} else {
@@ -493,7 +490,6 @@ _xfs_buf_map_pages(
 
 		if (!bp->b_addr)
 			return -ENOMEM;
-		bp->b_addr += bp->b_offset;
 	}
 
 	return 0;
@@ -1726,7 +1722,6 @@ xfs_buf_offset(
 	if (bp->b_addr)
 		return bp->b_addr + offset;
 
-	offset += bp->b_offset;
 	page = bp->b_pages[offset >> PAGE_SHIFT];
 	return page_address(page) + (offset & (PAGE_SIZE-1));
 }
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 459ca34f26f588..21b4c58fd2fa87 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -167,7 +167,8 @@ struct xfs_buf {
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
-	unsigned int		b_offset;	/* page offset in first page */
+	unsigned int		b_offset;	/* page offset in first page,
+						   only used for SLAB buffers */
 	int			b_error;	/* error code on I/O */
 
 	/*
-- 
2.30.2

