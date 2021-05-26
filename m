Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1996FC47082
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA6E561378
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhEZWtC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 18:49:02 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:57352 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234651AbhEZWtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 18:49:01 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 8193E1143841;
        Thu, 27 May 2021 08:47:26 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8e-OO; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fAN-Gj; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 06/10] xfs: remove ->b_offset handling for page backed buffers
Date:   Thu, 27 May 2021 08:47:18 +1000
Message-Id: <20210526224722.1111377-7-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526224722.1111377-1-david@fromorbit.com>
References: <20210526224722.1111377-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=Bt4COTtUHS94fNOw9_cA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From : Christoph Hellwig <hch@lst.de>

->b_offset can only be non-zero for _XBF_KMEM backed buffers, so
remove all code dealing with it for page backed buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[dgc: modified to fit this patchset]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 8 +++-----
 fs/xfs/xfs_buf.h | 3 ++-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d15999c41885..87151d78a0d8 100644
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
@@ -281,7 +281,7 @@ xfs_buf_free_pages(
 	ASSERT(bp->b_flags & _XBF_PAGES);
 
 	if (xfs_buf_is_vmapped(bp))
-		vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
+		vm_unmap_ram(bp->b_addr, bp->b_page_count);
 
 	for (i = 0; i < bp->b_page_count; i++) {
 		if (bp->b_pages[i])
@@ -442,7 +442,7 @@ _xfs_buf_map_pages(
 	ASSERT(bp->b_flags & _XBF_PAGES);
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
+		bp->b_addr = page_address(bp->b_pages[0]);
 	} else if (flags & XBF_UNMAPPED) {
 		bp->b_addr = NULL;
 	} else {
@@ -469,7 +469,6 @@ _xfs_buf_map_pages(
 
 		if (!bp->b_addr)
 			return -ENOMEM;
-		bp->b_addr += bp->b_offset;
 	}
 
 	return 0;
@@ -1680,7 +1679,6 @@ xfs_buf_offset(
 	if (bp->b_addr)
 		return bp->b_addr + offset;
 
-	offset += bp->b_offset;
 	page = bp->b_pages[offset >> PAGE_SHIFT];
 	return page_address(page) + (offset & (PAGE_SIZE-1));
 }
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 459ca34f26f5..464dc548fa23 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -167,7 +167,8 @@ struct xfs_buf {
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
-	unsigned int		b_offset;	/* page offset in first page */
+	unsigned int		b_offset;	/* page offset of b_addr,
+						   only for _XBF_KMEM buffers */
 	int			b_error;	/* error code on I/O */
 
 	/*
-- 
2.31.1

