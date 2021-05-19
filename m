Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C034DC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D1846135A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhESTKx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbhESTKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CF7C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/cy5eWWQIvdyzbB/mYkgT4/vz3KYZuZf7V0KB18mFG4=; b=iDIvvTz43J2K7TMtHgItob0w/r
        opTDBzEDkNihf8MtmXnOUhLYy3jscvkUvBbSJmMSbkv7KAB7HybX3U+uX4EKvGQsIYaeZM73WQW+4
        eM2TQk60kQMUf0//mfZ9H7qpnVArAO7X9dgNRM4YvpBjwQ5BWMiPxPCsAgN7qNAK0C4pHp8fdp6Gu
        uzEBLzNEPrnECv1JCBOOvigK4L9wVWJvclOGouJu4/dqoHLBmqGInwA15DSWbgYlZH9wQvPqsZntr
        5JH0aeJ8Q9Moi5V4PnK3l12KSyPwXv5kpNAGSth76P+dTKlQR5IJRvKCnNj3xFUlx20uAlobKjWOf
        a2E1QjbQ==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZQ-00Fisn-Or; Wed, 19 May 2021 19:09:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/11] xfs: simplify the b_page_count calculation
Date:   Wed, 19 May 2021 21:08:56 +0200
Message-Id: <20210519190900.320044-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ever since we stopped using the Linux page cache to back XFS buffes
there is no need to take the start sector into account for calculating
the number of pages in a buffer, as the data always start from the
beginning of the buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 08c8667e6027fc..76a107e3cb2a22 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -278,15 +278,14 @@ _xfs_buf_alloc(
  */
 STATIC int
 _xfs_buf_get_pages(
-	struct xfs_buf		*bp,
-	int			page_count)
+	struct xfs_buf		*bp)
 {
 	ASSERT(bp->b_pages == NULL);
 
-	bp->b_page_count = page_count;
-	if (page_count > XB_PAGES) {
-		bp->b_pages = kmem_zalloc(sizeof(struct page *) * page_count,
-					  KM_NOFS);
+	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
+	if (bp->b_page_count > XB_PAGES) {
+		bp->b_pages = kmem_zalloc(sizeof(struct page *) *
+						bp->b_page_count, KM_NOFS);
 		if (!bp->b_pages)
 			return -ENOMEM;
 	} else {
@@ -384,8 +383,7 @@ xfs_buf_alloc_pages(
 	uint			flags)
 {
 	gfp_t			gfp_mask = xb_to_gfp(flags);
-	unsigned short		page_count, i;
-	xfs_off_t		start, end;
+	unsigned short		i;
 	int			error;
 
 	/*
@@ -394,11 +392,7 @@ xfs_buf_alloc_pages(
 	if (!(flags & XBF_READ))
 		gfp_mask |= __GFP_ZERO;
 
-	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
-	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
-								>> PAGE_SHIFT;
-	page_count = end - start;
-	error = _xfs_buf_get_pages(bp, page_count);
+	error = _xfs_buf_get_pages(bp);
 	if (unlikely(error))
 		return error;
 
@@ -942,7 +936,6 @@ xfs_buf_get_uncached(
 	int			flags,
 	struct xfs_buf		**bpp)
 {
-	unsigned long		page_count;
 	int			error, i;
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
@@ -954,12 +947,11 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail;
 
-	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;
-	error = _xfs_buf_get_pages(bp, page_count);
+	error = _xfs_buf_get_pages(bp);
 	if (error)
 		goto fail_free_buf;
 
-	for (i = 0; i < page_count; i++) {
+	for (i = 0; i < bp->b_page_count; i++) {
 		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
 		if (!bp->b_pages[i]) {
 			error = -ENOMEM;
-- 
2.30.2

