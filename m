Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CA8C43461
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EAD62083E
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W/eriYwy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgH3GPU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgH3GPT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849E6C061573
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=EAbUX1m1Au28FlVzOiIHuf5DQxWDT6034dWkTvfhKOE=; b=W/eriYwyxsbsSgOL8k8Oue42y2
        ljHodW9W2BulUnPr8unjM1btObj5ww/stZEMB6U4bKcZ9hanso52KLCjvWZmbkumYHeljUjR1ITKi
        xaFt9X+mq4KStI8FxW2e1WzMtr8p2kLFJ9mb3r4YEGWLz69/Djrg60SY1HOHqImFwyw4N8RvSH+lZ
        VlWXQqI1GKWzcz9M/ZwNUBX5PzMGmDtnQBVHpMYaq9G1eu2S+M5b7ywtOOnnzIqNSEfx9kXMRJylC
        8Eud6dhuMqX9K31cXJsCP/0ZRJCmpn2vkCYZwuwaFn+Y4Yy7nhn0RxDMTSVyqM7jw8W0sB4s3uwkq
        QKx0l+yQ==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGcY-0001xE-0y; Sun, 30 Aug 2020 06:15:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/13] xfs: mark xfs_buf_ioend static
Date:   Sun, 30 Aug 2020 08:15:01 +0200
Message-Id: <20200830061512.1148591-3-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 fs/xfs/xfs_buf.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d4cdcb6fb2fe10..03dd12a83b82a1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1174,7 +1174,7 @@ xfs_buf_wait_unpin(
  *	Buffer Utility Routines
  */
 
-void
+static void
 xfs_buf_ioend(
 	struct xfs_buf	*bp)
 {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 755b652e695ace..bea20d43a38191 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -269,7 +269,6 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
 
 /* Buffer Read and Write Routines */
 extern int xfs_bwrite(struct xfs_buf *bp);
-extern void xfs_buf_ioend(struct xfs_buf *bp);
 static inline void xfs_buf_ioend_finish(struct xfs_buf *bp)
 {
 	if (bp->b_flags & XBF_ASYNC)
-- 
2.28.0

