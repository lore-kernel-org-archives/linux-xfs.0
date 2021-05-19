Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD95C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E56361355
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhESTKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbhESTKx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C80CC06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=aT6cEXjVz0BBfBXhwMAOcY5zpXE5UC7tygl5deeVlvU=; b=h+kALjxN4ehhDMWhH1zkfwNq26
        uSYx9z66f7KQ9MW6oIB2Jr84hH+ydOQ7q8QAgD+o+7G8kJDwefi4Pn5+dKfa8Y+d6k0faBGMhj+CN
        qQojoOxr4xWRAq4SYrEbzP7P7ZqD+Um8RL7EOrWThjACK2BI8he4uFjHIc7QY8kKjaaRw/OGkoNfm
        NJyAWG1//R4kGgDTq1JYFGrtrywRYHeuyYw2wlfHA8FZlrC1Chi/NXaSVSKlN0KJgjhl6gorSd5z3
        3e+8USM6El40GUH98hIlMGL+1lr9zGrOwzQRzBf02cMVkeUngTQ26z2pyQGQK2ZbhBFg1Gnk9HNr9
        pV+4omSw==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZT-00Fit5-H1; Wed, 19 May 2021 19:09:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/11] xfs: centralize page allocation and freeing for buffers
Date:   Wed, 19 May 2021 21:08:57 +0200
Message-Id: <20210519190900.320044-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor out two helpers that do everything needed for allocating and
freeing pages that back a buffer, and remove the duplication between
the different interfaces.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 110 ++++++++++++++++-------------------------------
 1 file changed, 37 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 76a107e3cb2a22..31aff8323605cd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -273,35 +273,17 @@ _xfs_buf_alloc(
 }
 
 /*
- *	Allocate a page array capable of holding a specified number
- *	of pages, and point the page buf at it.
+ * Free all pages allocated to the buffer including the page map.
  */
-STATIC int
-_xfs_buf_get_pages(
-	struct xfs_buf		*bp)
+static void
+xfs_buf_free_pages(
+	struct xfs_buf	*bp)
 {
-	ASSERT(bp->b_pages == NULL);
-
-	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
-	if (bp->b_page_count > XB_PAGES) {
-		bp->b_pages = kmem_zalloc(sizeof(struct page *) *
-						bp->b_page_count, KM_NOFS);
-		if (!bp->b_pages)
-			return -ENOMEM;
-	} else {
-		bp->b_pages = bp->b_page_array;
-	}
+	unsigned int	i;
 
-	return 0;
-}
+	for (i = 0; i < bp->b_page_count; i++)
+		__free_page(bp->b_pages[i]);
 
-/*
- *	Frees b_pages if it was allocated.
- */
-STATIC void
-_xfs_buf_free_pages(
-	struct xfs_buf	*bp)
-{
 	if (bp->b_pages != bp->b_page_array) {
 		kmem_free(bp->b_pages);
 		bp->b_pages = NULL;
@@ -324,22 +306,14 @@ xfs_buf_free(
 	ASSERT(list_empty(&bp->b_lru));
 
 	if (bp->b_flags & _XBF_PAGES) {
-		uint		i;
-
 		if (xfs_buf_is_vmapped(bp))
 			vm_unmap_ram(bp->b_addr, bp->b_page_count);
-
-		for (i = 0; i < bp->b_page_count; i++) {
-			struct page	*page = bp->b_pages[i];
-
-			__free_page(page);
-		}
+		xfs_buf_free_pages(bp);
 		if (current->reclaim_state)
 			current->reclaim_state->reclaimed_slab +=
 							bp->b_page_count;
 	} else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
-	_xfs_buf_free_pages(bp);
 	xfs_buf_free_maps(bp);
 	kmem_cache_free(xfs_buf_zone, bp);
 }
@@ -380,34 +354,33 @@ xfs_buf_alloc_slab(
 static int
 xfs_buf_alloc_pages(
 	struct xfs_buf		*bp,
-	uint			flags)
+	gfp_t			gfp_mask,
+	bool			fail_fast)
 {
-	gfp_t			gfp_mask = xb_to_gfp(flags);
-	unsigned short		i;
-	int			error;
-
-	/*
-	 * assure zeroed buffer for non-read cases.
-	 */
-	if (!(flags & XBF_READ))
-		gfp_mask |= __GFP_ZERO;
+	int			i;
 
-	error = _xfs_buf_get_pages(bp);
-	if (unlikely(error))
-		return error;
+	ASSERT(bp->b_pages == NULL);
 
-	bp->b_flags |= _XBF_PAGES;
+	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
+	if (bp->b_page_count > XB_PAGES) {
+		bp->b_pages = kmem_zalloc(sizeof(struct page *) *
+						bp->b_page_count, KM_NOFS);
+		if (!bp->b_pages)
+			return -ENOMEM;
+	} else {
+		bp->b_pages = bp->b_page_array;
+	}
 
 	for (i = 0; i < bp->b_page_count; i++) {
 		struct page	*page;
 		uint		retries = 0;
 retry:
 		page = alloc_page(gfp_mask);
-		if (unlikely(page == NULL)) {
-			if (flags & XBF_READ_AHEAD) {
+		if (unlikely(!page)) {
+			if (fail_fast) {
 				bp->b_page_count = i;
-				error = -ENOMEM;
-				goto out_free_pages;
+				xfs_buf_free_pages(bp);
+				return -ENOMEM;
 			}
 
 			/*
@@ -429,13 +402,9 @@ xfs_buf_alloc_pages(
 
 		bp->b_pages[i] = page;
 	}
-	return 0;
 
-out_free_pages:
-	for (i = 0; i < bp->b_page_count; i++)
-		__free_page(bp->b_pages[i]);
-	bp->b_flags &= ~_XBF_PAGES;
-	return error;
+	bp->b_flags |= _XBF_PAGES;
+	return 0;
 }
 
 /*
@@ -706,7 +675,13 @@ xfs_buf_get_map(
 	 */
 	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
 	    xfs_buf_alloc_slab(new_bp, flags) < 0) {
-		error = xfs_buf_alloc_pages(new_bp, flags);
+		gfp_t			gfp_mask = xb_to_gfp(flags);
+
+		/* assure a zeroed buffer for non-read cases */
+		if (!(flags & XBF_READ))
+			gfp_mask |= __GFP_ZERO;
+		error = xfs_buf_alloc_pages(new_bp, gfp_mask,
+					   flags & XBF_READ_AHEAD);
 		if (error)
 			goto out_free_buf;
 	}
@@ -936,7 +911,7 @@ xfs_buf_get_uncached(
 	int			flags,
 	struct xfs_buf		**bpp)
 {
-	int			error, i;
+	int			error;
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
@@ -947,19 +922,10 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail;
 
-	error = _xfs_buf_get_pages(bp);
+	error = xfs_buf_alloc_pages(bp, xb_to_gfp(flags), true);
 	if (error)
 		goto fail_free_buf;
 
-	for (i = 0; i < bp->b_page_count; i++) {
-		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
-		if (!bp->b_pages[i]) {
-			error = -ENOMEM;
-			goto fail_free_mem;
-		}
-	}
-	bp->b_flags |= _XBF_PAGES;
-
 	error = _xfs_buf_map_pages(bp, 0);
 	if (unlikely(error)) {
 		xfs_warn(target->bt_mount,
@@ -972,9 +938,7 @@ xfs_buf_get_uncached(
 	return 0;
 
  fail_free_mem:
-	while (--i >= 0)
-		__free_page(bp->b_pages[i]);
-	_xfs_buf_free_pages(bp);
+	xfs_buf_free_pages(bp);
  fail_free_buf:
 	xfs_buf_free_maps(bp);
 	kmem_cache_free(xfs_buf_zone, bp);
-- 
2.30.2

