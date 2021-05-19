Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441DFC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A4256135A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhESTK7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhESTK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F660C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YYqdk4TJiCGpYCEkD18hlIlqWLuyEy1tUHnX7ECwKaQ=; b=X9+41M1hP+rdYm6GSYiGW7Wnrh
        xBBJOmghzkqapRSZjSOdirurbHf8yVg/HLcNNuWcfDXFk+IatDIjJN7w1aN7ThFWEdUmNsuOsAJJ0
        LDy5EVfMHW5tyUBU1aTfS97YDSIb3weW9xLirwtqUR7cTNsMmi2oICXnoLIa/uzYWWep49sr/CpcD
        Q4Vu0mTIhOhSuOl/svhNgVPmjZ63QCrbHX6m+O1Ku7PiencNLpYf1jyd52fWOxJ9NIwgJCxMYvsE6
        m47b764eb66fVw/e+4xyGsDI1k0dnM3ZBuifdypCEuoK2SUwYW1snGWddcdtNMGl4tKSvfFxljXeN
        K9lWHdtA==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZZ-00FitK-UC; Wed, 19 May 2021 19:09:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/11] xfs: retry allocations from xfs_buf_get_uncached as well
Date:   Wed, 19 May 2021 21:08:59 +0200
Message-Id: <20210519190900.320044-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is no good reason why xfs_buf_get_uncached should fail on the
first allocation failure, so make it behave the same as the normal
xfs_buf_get_map path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b3519a43759235..a1295b5b6f0ca6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -351,8 +351,7 @@ xfs_buf_alloc_slab(
 static int
 xfs_buf_alloc_pages(
 	struct xfs_buf		*bp,
-	xfs_buf_flags_t		flags,
-	bool			fail_fast)
+	xfs_buf_flags_t		flags)
 {
 	gfp_t			gfp_mask = __GFP_NOWARN;
 	int			i;
@@ -384,7 +383,7 @@ xfs_buf_alloc_pages(
 retry:
 		page = alloc_page(gfp_mask);
 		if (unlikely(!page)) {
-			if (fail_fast) {
+			if (flags & XBF_READ_AHEAD) {
 				bp->b_page_count = i;
 				xfs_buf_free_pages(bp);
 				return -ENOMEM;
@@ -682,8 +681,7 @@ xfs_buf_get_map(
 	 */
 	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
 	    xfs_buf_alloc_slab(new_bp, flags) < 0) {
-		error = xfs_buf_alloc_pages(new_bp, flags,
-					   flags & XBF_READ_AHEAD);
+		error = xfs_buf_alloc_pages(new_bp, flags);
 		if (error)
 			goto out_free_buf;
 	}
@@ -924,7 +922,7 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail;
 
-	error = xfs_buf_alloc_pages(bp, flags, true);
+	error = xfs_buf_alloc_pages(bp, flags);
 	if (error)
 		goto fail_free_buf;
 
-- 
2.30.2

