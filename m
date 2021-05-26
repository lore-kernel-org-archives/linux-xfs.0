Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF12C4708A
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F4C61378
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 22:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhEZWtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 18:49:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48466 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234653AbhEZWtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 18:49:01 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 819EF104474E;
        Thu, 27 May 2021 08:47:26 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8w-Rz; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fAZ-Jp; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 10/10] xfs: merge xfs_buf_allocate_memory
Date:   Thu, 27 May 2021 08:47:22 +1000
Message-Id: <20210526224722.1111377-11-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526224722.1111377-1-david@fromorbit.com>
References: <20210526224722.1111377-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=ezXR41oPEK9RR6tHPLQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It only has one caller and is now a simple function, so merge it
into the caller.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 44 +++++++++++++-------------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f56a76f8a653..12f7b20727dd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -313,11 +313,11 @@ xfs_buf_free(
 static int
 xfs_buf_alloc_kmem(
 	struct xfs_buf	*bp,
-	size_t		size,
 	xfs_buf_flags_t	flags)
 {
 	int		align_mask = xfs_buftarg_dma_alignment(bp->b_target);
 	xfs_km_flags_t	kmflag_mask = KM_NOFS;
+	size_t		size = BBTOB(bp->b_length);
 
 	/* Assure zeroed buffer for non-read cases. */
 	if (!(flags & XBF_READ))
@@ -400,33 +400,6 @@ xfs_buf_alloc_pages(
 	return 0;
 }
 
-
-/*
- * Allocates all the pages for buffer in question and builds it's page list.
- */
-static int
-xfs_buf_allocate_memory(
-	struct xfs_buf		*bp,
-	uint			flags)
-{
-	size_t			size;
-	int			error;
-
-	/*
-	 * For buffers that fit entirely within a single page, first attempt to
-	 * allocate the memory from the heap to minimise memory usage. If we
-	 * can't get heap memory for these small buffers, we fall back to using
-	 * the page allocator.
-	 */
-	size = BBTOB(bp->b_length);
-	if (size < PAGE_SIZE) {
-		error = xfs_buf_alloc_kmem(bp, size, flags);
-		if (!error)
-			return 0;
-	}
-	return xfs_buf_alloc_pages(bp, flags);
-}
-
 /*
  *	Map buffer into kernel address-space if necessary.
  */
@@ -688,9 +661,18 @@ xfs_buf_get_map(
 	if (error)
 		return error;
 
-	error = xfs_buf_allocate_memory(new_bp, flags);
-	if (error)
-		goto out_free_buf;
+	/*
+	 * For buffers that fit entirely within a single page, first attempt to
+	 * allocate the memory from the heap to minimise memory usage. If we
+	 * can't get heap memory for these small buffers, we fall back to using
+	 * the page allocator.
+	 */
+	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
+	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
+		error = xfs_buf_alloc_pages(new_bp, flags);
+		if (error)
+			goto out_free_buf;
+	}
 
 	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
 	if (error)
-- 
2.31.1

