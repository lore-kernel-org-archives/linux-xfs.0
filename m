Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB6FC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0F792073A
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MHvHyE/W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgGIPNz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIPNz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:13:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF510C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=g4wHTGypAdFbExlFMFign4dMzLvspFkbcqkMlN3Y3eQ=; b=MHvHyE/WdHbw/8I6zKwWQerScb
        Knnku7K7LdqxgGH/9SInifAE45g0+cnfikdnRAEciM0vBgWXd9Plzlk8Ai6i+O/EngJJGY9XUxWul
        tWNbEUqmERQTk+UEfQaP73DZDDXBzihvb4mPnFaXWhGDXeHoUDkcgogHm6IgXKxucXf5YxCGSDaPA
        rCEJ6fwMUPQ99yrfobbiryo63+mWruGLUrXMGyDv2z9URY2oJ1HEiH3YjTohzXFfsgQhuSzNCQXxu
        eQZGXtqY8P8jgABiEyiPI+MvAOcJ7VG/4QHB7oOj7/dRSkz0o6EmfNZ91jdMllFMKmgN9mV2GZixW
        134ZFIDw==;
Received: from [2001:4bb8:188:5f50:7053:304b:bf82:82cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYFF-00058x-Bc
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:13:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/13] xfs: use xfs_buf_item_relse in xfs_buf_item_done
Date:   Thu,  9 Jul 2020 17:04:50 +0200
Message-Id: <20200709150453.109230-11-hch@lst.de>
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

Reuse xfs_buf_item_relse instead of duplicating it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ccc9d69683fae4..ccfd747d32e410 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -959,8 +959,6 @@ void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
 	/*
 	 * If we are forcibly shutting down, this may well be off the AIL
 	 * already. That's because we simulate the log-committed callbacks to
@@ -970,8 +968,7 @@ xfs_buf_item_done(
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
2.26.2

