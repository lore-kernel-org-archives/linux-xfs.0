Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45100C47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21520613D3
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhEZWtB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 18:49:01 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48464 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234649AbhEZWtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 18:49:00 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6D43F1044749;
        Thu, 27 May 2021 08:47:26 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8X-Lr; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fAE-EG; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 03/10] xfs: use alloc_pages_bulk_array() for buffers
Date:   Thu, 27 May 2021 08:47:15 +1000
Message-Id: <20210526224722.1111377-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526224722.1111377-1-david@fromorbit.com>
References: <20210526224722.1111377-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=KeS95dpyy_nX3SypCP0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because it's more efficient than allocating pages one at a time in a
loop.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 62 +++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b1610115d401..8ca4add138c5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -386,10 +386,7 @@ xfs_buf_alloc_pages(
 	xfs_buf_flags_t	flags)
 {
 	gfp_t		gfp_mask = xb_to_gfp(flags);
-	size_t		size;
-	size_t		offset;
-	size_t		nbytes;
-	int		i;
+	long		filled = 0;
 	int		error;
 
 	/* Assure zeroed buffer for non-read cases. */
@@ -400,50 +397,39 @@ xfs_buf_alloc_pages(
 	if (unlikely(error))
 		return error;
 
-	offset = bp->b_offset;
 	bp->b_flags |= _XBF_PAGES;
 
-	for (i = 0; i < bp->b_page_count; i++) {
-		struct page	*page;
-		uint		retries = 0;
-retry:
-		page = alloc_page(gfp_mask);
-		if (unlikely(page == NULL)) {
-			if (flags & XBF_READ_AHEAD) {
-				bp->b_page_count = i;
-				error = -ENOMEM;
-				goto out_free_pages;
-			}
+	/*
+	 * Bulk filling of pages can take multiple calls. Not filling the entire
+	 * array is not an allocation failure, so don't back off if we get at
+	 * least one extra page.
+	 */
+	for (;;) {
+		long	last = filled;
 
-			/*
-			 * This could deadlock.
-			 *
-			 * But until all the XFS lowlevel code is revamped to
-			 * handle buffer allocation failures we can't do much.
-			 */
-			if (!(++retries % 100))
-				xfs_err(NULL,
-		"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
-					current->comm, current->pid,
-					__func__, gfp_mask);
-
-			XFS_STATS_INC(bp->b_mount, xb_page_retries);
-			congestion_wait(BLK_RW_ASYNC, HZ/50);
-			goto retry;
+		filled = alloc_pages_bulk_array(gfp_mask, bp->b_page_count,
+						bp->b_pages);
+		if (filled == bp->b_page_count) {
+			XFS_STATS_INC(bp->b_mount, xb_page_found);
+			break;
 		}
 
-		XFS_STATS_INC(bp->b_mount, xb_page_found);
+		if (filled != last)
+			continue;
 
-		nbytes = min_t(size_t, size, PAGE_SIZE - offset);
-		size -= nbytes;
-		bp->b_pages[i] = page;
-		offset = 0;
+		if (flags & XBF_READ_AHEAD) {
+			error = -ENOMEM;
+			goto out_free_pages;
+		}
+
+		XFS_STATS_INC(bp->b_mount, xb_page_retries);
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	}
 	return 0;
 
 out_free_pages:
-	for (i = 0; i < bp->b_page_count; i++)
-		__free_page(bp->b_pages[i]);
+	while (--filled >= 0)
+		__free_page(bp->b_pages[filled]);
 	bp->b_flags &= ~_XBF_PAGES;
 	return error;
 }
-- 
2.31.1

