Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1882C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EA0214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V+G/jGT+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfKGSYV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfKGSYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=x1IIvKdLTq/h5fMI357eelvQ/1Dd5TGYToXzmngE+f0=; b=V+G/jGT+RAwWvQlJHSJyWOb0L
        kVQ8tWcxJOGkuqLCRWIqT3V9OrfejSkLVXSWy7MIQQGH/vJvB8YIIqIh9E0vraB+LTbZJfc3k1D+/
        wkOyIxaNy23NPMZvyJM6A3IqmI42xIXWb4G5jrJzjpxLHuKyyHXMtR5y07diAIl/n3lWQeCXVIaol
        GxUMaivHfxKjYiI8yskfkGybqCEYob+21RXTT8J8/ynLY9q09bmWGX0CjbBYD2KjEYv3YCkrrL52a
        SE/mwC5+W7lT9zDGBeBOpk5WoxmqgTx6iiBpVd9EUrmlqGwfqXvWEIEeXyEQmjpna2lvA4NVBgRH/
        +50FbhZpg==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSB-0002lm-B2
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:24:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/46] xfs: use unsigned int for all size values in struct xfs_da_geometry
Date:   Thu,  7 Nov 2019 19:23:26 +0100
Message-Id: <20191107182410.12660-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

None of these can ever be negative, so use unsigned types.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 02f7a21ab3a5..01b0bbe8b266 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -18,12 +18,12 @@ struct xfs_dir_ops;
  * structures will be attached to the xfs_mount.
  */
 struct xfs_da_geometry {
-	int		blksize;	/* da block size in bytes */
-	int		fsbcount;	/* da block size in filesystem blocks */
+	unsigned int	blksize;	/* da block size in bytes */
+	unsigned int	fsbcount;	/* da block size in filesystem blocks */
 	uint8_t		fsblog;		/* log2 of _filesystem_ block size */
 	uint8_t		blklog;		/* log2 of da block size */
-	uint		node_ents;	/* # of entries in a danode */
-	int		magicpct;	/* 37% of block size in bytes */
+	unsigned int	node_ents;	/* # of entries in a danode */
+	unsigned int	magicpct;	/* 37% of block size in bytes */
 	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
 	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
 	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
-- 
2.20.1

