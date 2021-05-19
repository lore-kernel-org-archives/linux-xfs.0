Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28CAC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC4E61355
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhESTKq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhESTKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D89FC06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ztLngLnonem8HyO2pemD9+ceJ55Ddo3sC/yMHr8/BVI=; b=bL9Lr8Rg/DMFGeIa0+cFUuSGka
        By8Ubr5joA8mj9kQSOk+51fcXWzZTD99Y0KbAEqw0MkwnTFbMAf1wCEdBQAXuRw/5F7iuQLuCGmDQ
        8niLL08apH+6n2HjuHBwlhDBb+fsnTIbqF380AP8A+MTzkjSktoPRd7hUk9AMk+T2VnA4j4voR7Su
        aoZYVJNy/A74IVnlSe9HDBnTbij/rG+tEHglbm2hQ4K6jKm2mDz2rrI8XWf9UsdZ9dC3iXO5ecuXc
        K+nTR9NCb+pH2f3zrHAPCFa47a0HKfga789aaSaoO3a9Jseg3xAdWlDS7qGosChEzgC67llM06exb
        bUBrJYBg==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZN-00Fish-LM; Wed, 19 May 2021 19:09:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/11] xfs: remove the size and nbytes variables in xfs_buf_alloc_pages
Date:   Wed, 19 May 2021 21:08:55 +0200
Message-Id: <20210519190900.320044-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These variables are not used for anything but recursively updating each
other.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 76240d84d58b61..08c8667e6027fc 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -383,8 +383,6 @@ xfs_buf_alloc_pages(
 	struct xfs_buf		*bp,
 	uint			flags)
 {
-	size_t			size;
-	size_t			nbytes;
 	gfp_t			gfp_mask = xb_to_gfp(flags);
 	unsigned short		page_count, i;
 	xfs_off_t		start, end;
@@ -396,7 +394,6 @@ xfs_buf_alloc_pages(
 	if (!(flags & XBF_READ))
 		gfp_mask |= __GFP_ZERO;
 
-	size = BBTOB(bp->b_length);
 	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
 	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
 								>> PAGE_SHIFT;
@@ -436,8 +433,6 @@ xfs_buf_alloc_pages(
 			goto retry;
 		}
 
-		nbytes = min_t(size_t, size, PAGE_SIZE);
-		size -= nbytes;
 		bp->b_pages[i] = page;
 	}
 	return 0;
-- 
2.30.2

