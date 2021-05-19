Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A615C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A7B61355
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhESTKk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbhESTKj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91D4C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=Vx1d4we5CodHEVSGLT8g1Cm7n2EXhXGiSuFPoWP5QZE=; b=eti2Xl7G8EZIiWR6Yy9G5hnWh0
        fRzAXVBH3orACo0dcEse8zjJcqpMlH/ckZUvULE0h1z+GtQ64mecwseWycoyelbWqCVfcnLT4Hmto
        2KPrS2FbbUriAbPFOux1UH0RSURPdbO4NTca6BMLUQ5erJbIetRr0o0jduu8jQJCwgB/74rKXehup
        ddaTIi+Wk99sUP7mMXUcB9QEtquzxXCHTscMlpKhJX/O2NIrP384kNrAySMTQtAWCxoAZWWAK8rEr
        /vyqM9evLR0M9dIR/YuK+gr1Ffs9JjJRh5RwVUsyAMRx3K8Au8t+hiXhWGSTBxLCPWVQSONTYZW8o
        To3Ty+vQ==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZH-00FisV-0A; Wed, 19 May 2021 19:09:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/11] xfs: cleanup _xfs_buf_get_pages
Date:   Wed, 19 May 2021 21:08:53 +0200
Message-Id: <20210519190900.320044-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove the check for an existing b_pages array as this function is always
called right after allocating a buffer, so this can't happen.  Also
use kmem_zalloc to allocate the page array instead of doing a manual
memset gіven that the inline array is already pre-zeroed as part of the
freshly allocated buffer anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 392b85d059bff5..9c64c374411081 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -281,19 +281,18 @@ _xfs_buf_get_pages(
 	struct xfs_buf		*bp,
 	int			page_count)
 {
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
+	ASSERT(bp->b_pages == NULL);
+
+	bp->b_page_count = page_count;
+	if (page_count > XB_PAGES) {
+		bp->b_pages = kmem_zalloc(sizeof(struct page *) * page_count,
+					  KM_NOFS);
+		if (!bp->b_pages)
+			return -ENOMEM;
+	} else {
+		bp->b_pages = bp->b_page_array;
 	}
+
 	return 0;
 }
 
-- 
2.30.2

