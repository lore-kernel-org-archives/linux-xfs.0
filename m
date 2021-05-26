Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDA9C47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 23:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A6A3613D4
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 23:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhEZXHF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 19:07:05 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:44727 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233149AbhEZXHF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 19:07:05 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C444B80F8F6
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 09:05:31 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-005b8U-L9; Thu, 27 May 2021 08:47:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm2JB-004fAB-Cx; Thu, 27 May 2021 08:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH 02/10] xfs: use xfs_buf_alloc_pages for uncached buffers
Date:   Thu, 27 May 2021 08:47:14 +1000
Message-Id: <20210526224722.1111377-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526224722.1111377-1-david@fromorbit.com>
References: <20210526224722.1111377-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=EJc9BWZEyAod2tjSaAkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Use the newly factored out page allocation code. This adds
automatic buffer zeroing for non-read uncached buffers.

This also allows us to greatly simply the error handling in
xfs_buf_get_uncached(). Because xfs_buf_alloc_pages() cleans up
partial allocation failure, we can just call xfs_buf_free() in all
error cases now to clean up after failures.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c |  1 -
 fs/xfs/xfs_buf.c       | 27 ++++++---------------------
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index c68a36688474..be0087825ae0 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -43,7 +43,6 @@ xfs_get_aghdr_buf(
 	if (error)
 		return error;
 
-	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 	bp->b_bn = blkno;
 	bp->b_maps[0].bm_bn = blkno;
 	bp->b_ops = ops;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2e35d344a69b..b1610115d401 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -973,7 +973,7 @@ xfs_buf_get_uncached(
 	struct xfs_buf		**bpp)
 {
 	unsigned long		page_count;
-	int			error, i;
+	int			error;
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
@@ -982,41 +982,26 @@ xfs_buf_get_uncached(
 	/* flags might contain irrelevant bits, pass only what we care about */
 	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
 	if (error)
-		goto fail;
+		return error;
 
 	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;
-	error = _xfs_buf_get_pages(bp, page_count);
+	error = xfs_buf_alloc_pages(bp, page_count, flags);
 	if (error)
 		goto fail_free_buf;
 
-	for (i = 0; i < page_count; i++) {
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
 			"%s: failed to map pages", __func__);
-		goto fail_free_mem;
+		goto fail_free_buf;
 	}
 
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
 	*bpp = bp;
 	return 0;
 
- fail_free_mem:
-	while (--i >= 0)
-		__free_page(bp->b_pages[i]);
-	_xfs_buf_free_pages(bp);
- fail_free_buf:
-	xfs_buf_free_maps(bp);
-	kmem_cache_free(xfs_buf_zone, bp);
- fail:
+fail_free_buf:
+	xfs_buf_free(bp);
 	return error;
 }
 
-- 
2.31.1

