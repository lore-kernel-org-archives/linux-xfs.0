Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FD1C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D06F206EB
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jXAPzoxr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgIAPup (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbgIAPui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22289C061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=LNJkGIGOQ7LITg03Wf4rqulTsuSIKJCXI0RUg/sl3BU=; b=jXAPzoxrLDZ6IeBjNs9f/twekb
        Ig/DOZfTYbwtHhUcQBxphcsIIuvbrRSQbNFU372OK7EWGPVFO7ttp7FvZSobyaTaSBlqOzYk4/ANd
        zkEOdQmT3nTbhqd5afzuDUfg5tn2ndsA2tH5eTaz5066XJt5+n/SiI3m+7UH+K42clg/lwUsQ1AvY
        3WFHkHWHqEeSt2u+gWCjxGiLqPhCZK4rBXt94L/QlyvMM8MAz4zKxN73eUjupEK8E4jMyDW+6+sAz
        U/QvCSuzBpOThiR5KmXdDchdeGLYizKxlxGxH8ItMTAiT8bYfV0W+UY7R8HtVgyhU18zK4zsZ7AkD
        +d1yzlSQ==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YN-0003mm-Hb; Tue, 01 Sep 2020 15:50:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/15] xfs: use xfs_buf_item_relse in xfs_buf_item_done
Date:   Tue,  1 Sep 2020 17:50:13 +0200
Message-Id: <20200901155018.2524-11-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901155018.2524-1-hch@lst.de>
References: <20200901155018.2524-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reuse xfs_buf_item_relse instead of duplicating it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9245c62b48f9f3..5a7293d0719bb4 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -958,8 +958,6 @@ void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
 	/*
 	 * If we are forcibly shutting down, this may well be off the AIL
 	 * already. That's because we simulate the log-committed callbacks to
@@ -969,8 +967,7 @@ xfs_buf_item_done(
 	 *
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
-	xfs_trans_ail_delete(&bip->bli_item, SHUTDOWN_CORRUPT_INCORE);
-	bp->b_log_item = NULL;
-	xfs_buf_item_free(bip);
-	xfs_buf_rele(bp);
+	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
+			     SHUTDOWN_CORRUPT_INCORE);
+	xfs_buf_item_relse(bp);
 }
-- 
2.28.0

