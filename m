Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5895AC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28973206C3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:11:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qVS9Zx7H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGIPLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIPLd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:11:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C22C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=SDP1Z7l66w8fA6uNLWXpiIPGlEb60mQsRZg+xG3JsIA=; b=qVS9Zx7HxNwjHtQBAltE5iViLs
        W6KNPBAfznLr8HFnARhaNWE2FZu8FZJfL9uoEqkoou1sC7lXKYmGfIBjGZvKxFsH0mZKS3Us5ZP+B
        sy5BpPvGrj4BTVFZqLv3dDD9PrpTLW2q52o3WGmND97kGawApusA2/HVGQOBDBYla5NYFJ/L2VBi4
        IPwO8O6pimiIIMeOaV8DESH4KAphhPMqnl0KFyr3pf/AnFJo7p1FAmDo/P9OGv4FKiUVQLjS9bN5r
        aiCX4QGQu6z/mP2ARZarWHEcTuINguEu6zM+ZGqa5M4J7lGd6h7OMb7qgD8yQujU1oU6GXs+4AQiv
        bGNc/Q/Q==;
Received: from 089144201169.atnat0010.highway.a1.net ([89.144.201.169] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYCw-00054F-Nc
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:11:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/13] xfs: mark xfs_buf_ioend static
Date:   Thu,  9 Jul 2020 17:04:42 +0200
Message-Id: <20200709150453.109230-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709150453.109230-1-hch@lst.de>
References: <20200709150453.109230-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 2 +-
 fs/xfs/xfs_buf.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dda0c94458797a..1bce6457a9b943 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1176,7 +1176,7 @@ xfs_buf_wait_unpin(
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
2.26.2

