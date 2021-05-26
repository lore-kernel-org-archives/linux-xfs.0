Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFD3C4708E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D66E61378
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhEZWtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 18:49:04 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:42893 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234673AbhEZWtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 18:49:03 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 6EB991B0D76;
        Thu, 27 May 2021 08:47:26 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8a-Mm; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fAH-F7; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 04/10] xfs: merge _xfs_buf_get_pages()
Date:   Thu, 27 May 2021 08:47:16 +1000
Message-Id: <20210526224722.1111377-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526224722.1111377-1-david@fromorbit.com>
References: <20210526224722.1111377-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=UyA6ty1ra5lAQunl68IA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Only called from one place now, so merge it into
xfs_buf_alloc_pages(). Because page array allocation is dependent on
bp->b_pages being null, always ensure that when the pages array is
freed we always set bp->b_pages to null.

Also convert the page array to use kmalloc() rather than
kmem_alloc() so we can use the gfp flags we've already calculated
for the allocation context instead of hard coding KM_NOFS semantics.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 48 ++++++++++++++----------------------------------
 1 file changed, 14 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8ca4add138c5..aa978111c01f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -272,31 +272,6 @@ _xfs_buf_alloc(
 	return 0;
 }
 
-/*
- *	Allocate a page array capable of holding a specified number
- *	of pages, and point the page buf at it.
- */
-STATIC int
-_xfs_buf_get_pages(
-	struct xfs_buf		*bp,
-	int			page_count)
-{
-	/* Make sure that we have a page list */
-	if (bp->b_pages == NULL) {
-		bp->b_page_count = page_count;
-		if (page_count <= XB_PAGES) {
-			bp->b_pages = bp->b_page_array;
-		} else {
-			bp->b_pages = kmem_alloc(sizeof(struct page *) *
-						 page_count, KM_NOFS);
-			if (bp->b_pages == NULL)
-				return -ENOMEM;
-		}
-		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
-	}
-	return 0;
-}
-
 /*
  *	Frees b_pages if it was allocated.
  */
@@ -304,10 +279,9 @@ STATIC void
 _xfs_buf_free_pages(
 	struct xfs_buf	*bp)
 {
-	if (bp->b_pages != bp->b_page_array) {
+	if (bp->b_pages != bp->b_page_array)
 		kmem_free(bp->b_pages);
-		bp->b_pages = NULL;
-	}
+	bp->b_pages = NULL;
 }
 
 /*
@@ -389,16 +363,22 @@ xfs_buf_alloc_pages(
 	long		filled = 0;
 	int		error;
 
+	/* Make sure that we have a page list */
+	bp->b_page_count = page_count;
+	if (bp->b_page_count <= XB_PAGES) {
+		bp->b_pages = bp->b_page_array;
+	} else {
+		bp->b_pages = kzalloc(sizeof(struct page *) * bp->b_page_count,
+					gfp_mask);
+		if (!bp->b_pages)
+			return -ENOMEM;
+	}
+	bp->b_flags |= _XBF_PAGES;
+
 	/* Assure zeroed buffer for non-read cases. */
 	if (!(flags & XBF_READ))
 		gfp_mask |= __GFP_ZERO;
 
-	error = _xfs_buf_get_pages(bp, page_count);
-	if (unlikely(error))
-		return error;
-
-	bp->b_flags |= _XBF_PAGES;
-
 	/*
 	 * Bulk filling of pages can take multiple calls. Not filling the entire
 	 * array is not an allocation failure, so don't back off if we get at
-- 
2.31.1

