Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0C5C4708C
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ED2F613E2
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhEZWtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 18:49:03 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35934 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234660AbhEZWtC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 18:49:02 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 82CE980C860;
        Thu, 27 May 2021 08:47:26 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8c-Ni; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fAK-Fw; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 05/10] xfs: move page freeing into _xfs_buf_free_pages()
Date:   Thu, 27 May 2021 08:47:17 +1000
Message-Id: <20210526224722.1111377-6-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526224722.1111377-1-david@fromorbit.com>
References: <20210526224722.1111377-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=4rCGOey_rmJM0Zr55FoA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rather than open coding it just before we call
_xfs_buf_free_pages(). Also, rename the function to
xfs_buf_free_pages() as the leading underscore has no useful
meaning.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 61 ++++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index aa978111c01f..d15999c41885 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -272,25 +272,30 @@ _xfs_buf_alloc(
 	return 0;
 }
 
-/*
- *	Frees b_pages if it was allocated.
- */
-STATIC void
-_xfs_buf_free_pages(
+static void
+xfs_buf_free_pages(
 	struct xfs_buf	*bp)
 {
+	uint		i;
+
+	ASSERT(bp->b_flags & _XBF_PAGES);
+
+	if (xfs_buf_is_vmapped(bp))
+		vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
+
+	for (i = 0; i < bp->b_page_count; i++) {
+		if (bp->b_pages[i])
+			__free_page(bp->b_pages[i]);
+	}
+	if (current->reclaim_state)
+		current->reclaim_state->reclaimed_slab += bp->b_page_count;
+
 	if (bp->b_pages != bp->b_page_array)
 		kmem_free(bp->b_pages);
 	bp->b_pages = NULL;
+	bp->b_flags &= ~_XBF_PAGES;
 }
 
-/*
- *	Releases the specified buffer.
- *
- * 	The modification state of any associated pages is left unchanged.
- * 	The buffer must not be on any hash - use xfs_buf_rele instead for
- * 	hashed and refcounted buffers
- */
 static void
 xfs_buf_free(
 	struct xfs_buf		*bp)
@@ -299,24 +304,11 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
-	if (bp->b_flags & _XBF_PAGES) {
-		uint		i;
-
-		if (xfs_buf_is_vmapped(bp))
-			vm_unmap_ram(bp->b_addr - bp->b_offset,
-					bp->b_page_count);
-
-		for (i = 0; i < bp->b_page_count; i++) {
-			struct page	*page = bp->b_pages[i];
-
-			__free_page(page);
-		}
-		if (current->reclaim_state)
-			current->reclaim_state->reclaimed_slab +=
-							bp->b_page_count;
-	} else if (bp->b_flags & _XBF_KMEM)
+	if (bp->b_flags & _XBF_PAGES)
+		xfs_buf_free_pages(bp);
+	else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
-	_xfs_buf_free_pages(bp);
+
 	xfs_buf_free_maps(bp);
 	kmem_cache_free(xfs_buf_zone, bp);
 }
@@ -361,7 +353,6 @@ xfs_buf_alloc_pages(
 {
 	gfp_t		gfp_mask = xb_to_gfp(flags);
 	long		filled = 0;
-	int		error;
 
 	/* Make sure that we have a page list */
 	bp->b_page_count = page_count;
@@ -398,20 +389,14 @@ xfs_buf_alloc_pages(
 			continue;
 
 		if (flags & XBF_READ_AHEAD) {
-			error = -ENOMEM;
-			goto out_free_pages;
+			xfs_buf_free_pages(bp);
+			return -ENOMEM;
 		}
 
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	}
 	return 0;
-
-out_free_pages:
-	while (--filled >= 0)
-		__free_page(bp->b_pages[filled]);
-	bp->b_flags &= ~_XBF_PAGES;
-	return error;
 }
 
 
-- 
2.31.1

