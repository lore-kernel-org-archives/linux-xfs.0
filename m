Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96C2C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C830A6135A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhESTLC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhESTLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:11:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6581C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=rP0yISESwpOMZftAxd0WcFDRmBIV6ch7cmoIGzQmN6A=; b=HQ4zLQMDsOVplz9qZkZ+ksezo/
        TtKOTFa8Y0f+dTMJnoDKEQIRRB+zn424s8XYIZqYrLNjI9Z7/3pI8f88XQDRp0TyqpVWv3BDPFBJ5
        Qt4v9VZiuAi8+kDddFbBeOhQlGRQ3eHMB7sCgXooklif2HI4Lmol1h+3/lpuH6OOBcVc2uK4eN0pu
        iS4s/U23NxQ9/TYKDHjJsqFeadjTex9XZRPu0hSwQFCzZqlwy5kgi1zAa1auKYs2letkY/jjJqfkr
        DAAz2bG4tvnlP/PFO1GWlhaWp8X3ryJV7WGqk5w+p8QQ12oWW6d2as8neIoFJMt3yU6Cz9eGSK8vr
        bXmCNSuA==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZc-00Fitt-U9; Wed, 19 May 2021 19:09:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 11/11] xfs: use alloc_pages_bulk_array() for buffers
Date:   Wed, 19 May 2021 21:09:00 +0200
Message-Id: <20210519190900.320044-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because it's more efficient than allocating pages one at a time in a
loop.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[hch: rebased ontop of a bunch of cleanups]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a1295b5b6f0ca6..e2439503fc13bb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -354,7 +354,7 @@ xfs_buf_alloc_pages(
 	xfs_buf_flags_t		flags)
 {
 	gfp_t			gfp_mask = __GFP_NOWARN;
-	int			i;
+	unsigned long		filled = 0;
 
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
@@ -377,36 +377,27 @@ xfs_buf_alloc_pages(
 		bp->b_pages = bp->b_page_array;
 	}
 
-	for (i = 0; i < bp->b_page_count; i++) {
-		struct page	*page;
-		uint		retries = 0;
-retry:
-		page = alloc_page(gfp_mask);
-		if (unlikely(!page)) {
+	/*
+	 * Bulk filling of pages can take multiple calls. Not filling the entire
+	 * array is not an allocation failure, so don't back off if we get at
+	 * least one extra page.
+	 */
+	for (;;) {
+		unsigned long	last = filled;
+
+		filled = alloc_pages_bulk_array(gfp_mask, bp->b_page_count,
+						bp->b_pages);
+		if (filled == bp->b_page_count)
+			break;
+		if (filled == last) {
 			if (flags & XBF_READ_AHEAD) {
-				bp->b_page_count = i;
+				bp->b_page_count = filled;
 				xfs_buf_free_pages(bp);
 				return -ENOMEM;
 			}
-
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
 			XFS_STATS_INC(bp->b_mount, xb_page_retries);
 			congestion_wait(BLK_RW_ASYNC, HZ/50);
-			goto retry;
 		}
-
-		bp->b_pages[i] = page;
 	}
 
 	bp->b_flags |= _XBF_PAGES;
-- 
2.30.2

