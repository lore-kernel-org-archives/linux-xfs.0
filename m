Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73089C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C8836108D
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhESBI4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 21:08:56 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:48672 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229485AbhESBI4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 21:08:56 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 199A91140B6B
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 11:07:35 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljAgQ-002bE4-0x
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:07:34 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljAgP-001t4o-PU
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:07:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: use alloc_pages_bulk_array() for buffers
Date:   Wed, 19 May 2021 11:07:33 +1000
Message-Id: <20210519010733.449999-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=Zp1x2qE9gxlNiri35MEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because it's more efficient than allocating pages one at a time in a
loop.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 91 +++++++++++++++++++++---------------------------
 1 file changed, 39 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 592800c8852f..a6cf607bbc4a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -276,8 +276,8 @@ _xfs_buf_alloc(
  *	Allocate a page array capable of holding a specified number
  *	of pages, and point the page buf at it.
  */
-STATIC int
-_xfs_buf_get_pages(
+static int
+xfs_buf_get_pages(
 	struct xfs_buf		*bp,
 	int			page_count)
 {
@@ -292,8 +292,8 @@ _xfs_buf_get_pages(
 			if (bp->b_pages == NULL)
 				return -ENOMEM;
 		}
-		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
 	}
+	memset(bp->b_pages, 0, sizeof(struct page *) * bp->b_page_count);
 	return 0;
 }
 
@@ -356,10 +356,10 @@ xfs_buf_allocate_memory(
 	uint			flags)
 {
 	size_t			size;
-	size_t			nbytes, offset;
+	size_t			offset;
 	gfp_t			gfp_mask = xb_to_gfp(flags);
-	unsigned short		page_count, i;
 	xfs_off_t		start, end;
+	long			filled = 0;
 	int			error;
 	xfs_km_flags_t		kmflag_mask = 0;
 
@@ -405,55 +405,44 @@ xfs_buf_allocate_memory(
 	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
 	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
 								>> PAGE_SHIFT;
-	page_count = end - start;
-	error = _xfs_buf_get_pages(bp, page_count);
+	error = xfs_buf_get_pages(bp, end - start);
 	if (unlikely(error))
 		return error;
 
 	offset = bp->b_offset;
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
+		int	last = filled;
 
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
@@ -950,8 +939,8 @@ xfs_buf_get_uncached(
 	int			flags,
 	struct xfs_buf		**bpp)
 {
-	unsigned long		page_count;
-	int			error, i;
+	unsigned long		filled;
+	int			error;
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
@@ -962,17 +951,15 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail;
 
-	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;
-	error = _xfs_buf_get_pages(bp, page_count);
+	error = xfs_buf_get_pages(bp, PAGE_ALIGN(BBTOB(numblks)) >> PAGE_SHIFT);
 	if (error)
 		goto fail_free_buf;
 
-	for (i = 0; i < page_count; i++) {
-		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
-		if (!bp->b_pages[i]) {
-			error = -ENOMEM;
-			goto fail_free_mem;
-		}
+	filled = alloc_pages_bulk_array(xb_to_gfp(flags), bp->b_page_count,
+					bp->b_pages);
+	if (filled != bp->b_page_count) {
+		error = -ENOMEM;
+		goto fail_free_mem;
 	}
 	bp->b_flags |= _XBF_PAGES;
 
@@ -988,8 +975,8 @@ xfs_buf_get_uncached(
 	return 0;
 
  fail_free_mem:
-	while (--i >= 0)
-		__free_page(bp->b_pages[i]);
+	while (--filled >= 0)
+		__free_page(bp->b_pages[filled]);
 	_xfs_buf_free_pages(bp);
  fail_free_buf:
 	xfs_buf_free_maps(bp);
-- 
2.31.1

