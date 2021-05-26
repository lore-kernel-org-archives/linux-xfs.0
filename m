Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3125C47089
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E34761378
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhEZWtC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 18:49:02 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:50134 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234654AbhEZWtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 18:49:01 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 831856C19B;
        Thu, 27 May 2021 08:47:26 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8g-P5; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fAQ-HX; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 07/10] xfs: simplify the b_page_count calculation
Date:   Thu, 27 May 2021 08:47:19 +1000
Message-Id: <20210526224722.1111377-8-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526224722.1111377-1-david@fromorbit.com>
References: <20210526224722.1111377-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=y6ab51QGq9iBGrkQnh0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Ever since we stopped using the Linux page cache to back XFS buffes
there is no need to take the start sector into account for
calculating the number of pages in a buffer, as the data always
start from the beginning of the buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[dgc: modified to suit this series]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 87151d78a0d8..1500a9c63432 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -348,14 +348,13 @@ xfs_buf_alloc_kmem(
 static int
 xfs_buf_alloc_pages(
 	struct xfs_buf	*bp,
-	uint		page_count,
 	xfs_buf_flags_t	flags)
 {
 	gfp_t		gfp_mask = xb_to_gfp(flags);
 	long		filled = 0;
 
 	/* Make sure that we have a page list */
-	bp->b_page_count = page_count;
+	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
 	if (bp->b_page_count <= XB_PAGES) {
 		bp->b_pages = bp->b_page_array;
 	} else {
@@ -409,7 +408,6 @@ xfs_buf_allocate_memory(
 	uint			flags)
 {
 	size_t			size;
-	xfs_off_t		start, end;
 	int			error;
 
 	/*
@@ -424,11 +422,7 @@ xfs_buf_allocate_memory(
 		if (!error)
 			return 0;
 	}
-
-	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
-	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
-								>> PAGE_SHIFT;
-	return xfs_buf_alloc_pages(bp, end - start, flags);
+	return xfs_buf_alloc_pages(bp, flags);
 }
 
 /*
@@ -922,7 +916,6 @@ xfs_buf_get_uncached(
 	int			flags,
 	struct xfs_buf		**bpp)
 {
-	unsigned long		page_count;
 	int			error;
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
@@ -934,8 +927,7 @@ xfs_buf_get_uncached(
 	if (error)
 		return error;
 
-	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;
-	error = xfs_buf_alloc_pages(bp, page_count, flags);
+	error = xfs_buf_alloc_pages(bp, flags);
 	if (error)
 		goto fail_free_buf;
 
-- 
2.31.1

