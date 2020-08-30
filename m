Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83645C433E2
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D97204EA
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TAvaSsAY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgH3GP2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgH3GP1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29923C061573
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=LNJkGIGOQ7LITg03Wf4rqulTsuSIKJCXI0RUg/sl3BU=; b=TAvaSsAYB00AA/24kUb8qcbVBK
        8y7UpEcfucK90sLhz945Dq/PlHOhNcpaXn28Q5BPo/q05f/uNso0y31AP5arbdVR7s5XWtH03SlKU
        C4JFxjtyoshBnQ+sfnMlv81Il0SRmw7sWxI0I85WbElwqoxpNivnUygfFcmObriKM/x3WT2ZNS34L
        POgP8r4Z/ILPgQzckMJ+L6/Uc/daOc99TJ4+YVh0PeN4MextdrsIWdXDe2DKtYqcKqT3OoaTgTBLd
        de0XueesjwoomQSLP/FwwurSeeRkjRSDgPdVyb+jGiV5ti6q4TKqniNqw+j/PDb+lKMJe1K0eg+bb
        Qw5b7w2w==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGcf-0001yw-Ng; Sun, 30 Aug 2020 06:15:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/13] xfs: use xfs_buf_item_relse in xfs_buf_item_done
Date:   Sun, 30 Aug 2020 08:15:09 +0200
Message-Id: <20200830061512.1148591-11-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200830061512.1148591-1-hch@lst.de>
References: <20200830061512.1148591-1-hch@lst.de>
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

