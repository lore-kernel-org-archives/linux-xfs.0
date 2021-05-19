Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DF4C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D24816135C
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhESTK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbhESTKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56B8C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=AQG7hdc76wBJojhmWFQ1bYS2kaeFVVO1wHJ31xKHIwY=; b=K2waGnlS9xauZsOMAyE7IiSgiH
        GWPvlWKUeGTU9WpMDMpkAGEjh2O/9z8y0kSSVP3fCLLrqVoFNyMyQ8SV2OwbI6Zzv0SN9uwsIFe15
        +GjK0B3jGAMbpK46UGhev9qG0p5QNDxLUTgRFOHmzJBxJpYkPg4uTKObzKz+uqCiJlyBnYRfsgZAf
        5I6Chkem78oIhsqS82jvKaSB5p394p17LK4qxZgMiRlUBwDNwL0gnRiXDkNqIewfRzb86+Pni7ROF
        dJtIDjnUsLmxuZ6bXGkzQByPNsNFF6Z+et4NQZftsgYjYn0cRHID5DCvh2WdEZY7KXN1nGSBhkgrm
        ZaTeUXVg==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZW-00FitC-Uo; Wed, 19 May 2021 19:09:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/11] xfs: lift the buffer zeroing logic into xfs_buf_alloc_pages
Date:   Wed, 19 May 2021 21:08:58 +0200
Message-Id: <20210519190900.320044-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift the buffer zeroing logic from xfs_buf_get_map into so that it also
covers uncached buffers, and remove the now obsolete manual zeroing in
the only direct caller of xfs_buf_get_uncached.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c |  1 -
 fs/xfs/xfs_buf.c       | 24 +++++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index c68a3668847499..be0087825ae06b 100644
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
index 31aff8323605cd..b3519a43759235 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -22,9 +22,6 @@
 
 static kmem_zone_t *xfs_buf_zone;
 
-#define xb_to_gfp(flags) \
-	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : GFP_NOFS) | __GFP_NOWARN)
-
 /*
  * Locking orders
  *
@@ -354,11 +351,21 @@ xfs_buf_alloc_slab(
 static int
 xfs_buf_alloc_pages(
 	struct xfs_buf		*bp,
-	gfp_t			gfp_mask,
+	xfs_buf_flags_t		flags,
 	bool			fail_fast)
 {
+	gfp_t			gfp_mask = __GFP_NOWARN;
 	int			i;
 
+	if (flags & XBF_READ_AHEAD)
+		gfp_mask |= __GFP_NORETRY;
+	else
+		gfp_mask |= GFP_NOFS;
+
+	/* assure a zeroed buffer for non-read cases */
+	if (!(flags & XBF_READ))
+		gfp_mask |= __GFP_ZERO;
+
 	ASSERT(bp->b_pages == NULL);
 
 	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
@@ -675,12 +682,7 @@ xfs_buf_get_map(
 	 */
 	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
 	    xfs_buf_alloc_slab(new_bp, flags) < 0) {
-		gfp_t			gfp_mask = xb_to_gfp(flags);
-
-		/* assure a zeroed buffer for non-read cases */
-		if (!(flags & XBF_READ))
-			gfp_mask |= __GFP_ZERO;
-		error = xfs_buf_alloc_pages(new_bp, gfp_mask,
+		error = xfs_buf_alloc_pages(new_bp, flags,
 					   flags & XBF_READ_AHEAD);
 		if (error)
 			goto out_free_buf;
@@ -922,7 +924,7 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail;
 
-	error = xfs_buf_alloc_pages(bp, xb_to_gfp(flags), true);
+	error = xfs_buf_alloc_pages(bp, flags, true);
 	if (error)
 		goto fail_free_buf;
 
-- 
2.30.2

