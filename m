Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16BCC433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB162064B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OdlmDS2t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgIAPuj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgIAPu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1D6C061246
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=EAbUX1m1Au28FlVzOiIHuf5DQxWDT6034dWkTvfhKOE=; b=OdlmDS2t9F6w13waUEcmBtAqyP
        Q6KBsyntaHyG1LBYpS3K0mISe9ZuOa254GPcuPmt+af7cO/TjlmDsol+MiGZ1Aoxf6QUv8eAVH9LO
        uIg8taDUIb3TquvSKah5KAslMiVjVd7zyeqIHYLKH+KKuZFXhHIt+rpy6YWdrFBjf2pzYwO8fRcrd
        MLxp6tSnOS+IcWb6hk6ycXrI1THrmW8K3fP/QCR/CCn8h6WI/bWxmeXCYSIp9a59nkEERfOyiupVo
        KBPzDhkcr4a/zj7gTLueN2fLB53GG5jWXP3R4zxAfVOwvEOgmbmpQ8Pxge5LywbYw3E8rsk9Rh7f+
        m/X/YdLg==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YA-0003lV-HF; Tue, 01 Sep 2020 15:50:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/15] xfs: mark xfs_buf_ioend static
Date:   Tue,  1 Sep 2020 17:50:05 +0200
Message-Id: <20200901155018.2524-3-hch@lst.de>
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

