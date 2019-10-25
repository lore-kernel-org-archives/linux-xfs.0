Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9CDCA9EAF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 02:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4598621929
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 02:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JJWhdPfP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732948AbfJYCPC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 22:15:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732877AbfJYCPC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 22:15:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nic9IsHXv0CajPU2VqPPl00Yvyh8cVE5EzqB3DMWX6I=; b=JJWhdPfPo2coslwpxcL+2eYcV
        dZZff6Bf6PdS2/xNUFtDwN8Jt7rHc5px0IDG6DmfRFN097gKo1xWpUXilS21ut0q241tJocUO0RZf
        yQrsfYoXZKaBWDZyPWcM75Dw8CqPuPPiR2rXOmK//Na4VOQTBoYUmgY8XxtMa8sFBbLdiECPZLVke
        4zKU9I7CUQbqjo3WwYoBKeGZy8UGbJeMo448QPf8s99xMY7H05b3zacmqtstc/61goJ18yP005ztZ
        5xNR/b6yWG8mJDhR8UhXblnPb74yuRJcVfjylN3IxYXOsvlE1FJoaPu08JY4czyxNvQrlrYOyeC8u
        EG/4X9enQ==;
Received: from p91006-ipngnfx01marunouchi.tokyo.ocn.ne.jp ([153.156.43.6] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNp82-0003k1-0d
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 02:15:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: mark xfs_buf_free static
Date:   Fri, 25 Oct 2019 11:14:58 +0900
Message-Id: <20191025021458.20007-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
index 0abba171aa89..9640e4174552 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -304,7 +304,7 @@ _xfs_buf_free_pages(
  * 	The buffer must not be on any hash - use xfs_buf_rele instead for
  * 	hashed and refcounted buffers
  */
-void
+static void
 xfs_buf_free(
 	xfs_buf_t		*bp)
 {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f6ce17d8d848..56e081dd1d96 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -244,7 +244,6 @@ int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
-extern void xfs_buf_free(xfs_buf_t *);
 extern void xfs_buf_rele(xfs_buf_t *);
 
 /* Locking and Unlocking Buffers */
-- 
2.20.1

