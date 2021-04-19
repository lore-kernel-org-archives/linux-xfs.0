Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40331C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2675B61151
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbhDSI2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 04:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbhDSI2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 04:28:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E793C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 19 Apr 2021 01:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EGIuZQS8nFxsan/Q4gwJB7xZ3TnCUbgtHaX+RaxuL6U=; b=eRlxYKJ8RksPwdNon1l6lHQth/
        HIuZRTTsVPxrmlEQLn+P5GrgdGQdpm2RjmYip3pa5oy50oZrdHxGhzhcvE40srFs9ELiuBT+xumFK
        utYDZk4HfWBWp/BSI+l2g1p4JSBtLZfJ/nyLIBTk+8HS43AekRJb6zhYmjT2xwzw9MYw2MRR/hSpr
        JcUfNFVyJ5JwJTC8qiY5vTv61r+/AwbgbEWMLrcEW+Ssl3WweNT6CzuvkRjXOuLsJOL74e34tv8yI
        0owvLSplYIx+wpd/1a3wzYray4ssYVHo2vs3ABb54mxKbgTtXcdqdjCuAuEH+THDGSCM4nEQJKS1s
        7XqbgNQQ==;
Received: from [2001:4bb8:19b:f845:9ac9:3ef5:afc7:c325] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYPGU-00BBeY-HO; Mon, 19 Apr 2021 08:28:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH 4/7]  xfs: pass a xfs_efd_log_item to xfs_efd_item_sizeof
Date:   Mon, 19 Apr 2021 10:28:01 +0200
Message-Id: <20210419082804.2076124-5-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210419082804.2076124-1-hch@lst.de>
References: <20210419082804.2076124-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_efd_log_item only looks at the embedded xfs_efd_log_item structure,
so pass that directly and rename the function to xfs_efd_log_item_sizeof.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 7ae570d1944590..f15d6cfca6e2f1 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -195,11 +195,11 @@ xfs_efd_item_free(struct xfs_efd_log_item *efdp)
  * structure.
  */
 static inline int
-xfs_efd_item_sizeof(
-	struct xfs_efd_log_item *efdp)
+xfs_efd_log_item_sizeof(
+	struct xfs_efd_log_format *elf)
 {
 	return sizeof(struct xfs_efd_log_format) +
-	       (efdp->efd_format.efd_nextents - 1) * sizeof(struct xfs_extent);
+	       (elf->efd_nextents - 1) * sizeof(struct xfs_extent);
 }
 
 STATIC void
@@ -209,7 +209,7 @@ xfs_efd_item_size(
 	int			*nbytes)
 {
 	*nvecs += 1;
-	*nbytes += xfs_efd_item_sizeof(EFD_ITEM(lip));
+	*nbytes += xfs_efd_log_item_sizeof(&EFD_ITEM(lip)->efd_format);
 }
 
 /*
@@ -234,7 +234,7 @@ xfs_efd_item_format(
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFD_FORMAT,
 			&efdp->efd_format,
-			xfs_efd_item_sizeof(efdp));
+			xfs_efd_log_item_sizeof(&efdp->efd_format));
 }
 
 /*
-- 
2.30.1

