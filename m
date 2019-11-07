Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE32CC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A076218AE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eES2rE46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfKGS0B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:26:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44286 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfKGS0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:26:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0st/dNPg/e/cjEpjRMy8tX+i5ULjUXrUpB4VEPAxkMU=; b=eES2rE46o30qqhz1BsqZlaolV
        oFusxXaTP/p5DvgN33PxQzrEYMWrUWh/+f2QpXHFY9ZbRBGh1TuNgTmUfTpQPB4aqAPVnR2QNa6x3
        GBgpBasQAwlsS5pOUFL17koyrYjhOiP3OlLBqVV0t61cBGFph3bBuHWeFQQyfeM42Fexob8E3SEoF
        O5O6RSchUJW8jHkuCZ9JJtQrPutq2bAmNNUm4I/Ohw5FGucaOkTK7Me0HRc+BvTydLaW80x2ZRrcr
        buE3bdvMHuxlrJC6Ce5UBR39REJMCQC6z9BA0DIkADGmOPyqWLCNGlQf7rRUqG5pg+KdbMqM0Lv4M
        Ev+TpUB2Q==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTo-0004UK-Fk
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:26:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 41/46] xfs: cleanup xfs_dir2_data_entsize
Date:   Thu,  7 Nov 2019 19:24:05 +0100
Message-Id: <20191107182410.12660-42-hch@lst.de>
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

Remove the XFS_DIR2_DATA_ENTSIZE and XFS_DIR3_DATA_ENTSIZE and open
code them in their only caller, which now becomes so simple that
we can turn it into an inline function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c | 33 ---------------------------------
 fs/xfs/libxfs/xfs_dir2_priv.h | 15 ++++++++++++++-
 2 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 0e35e613fbf3..dd2389748672 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -19,39 +19,6 @@
  * Directory data block operations
  */
 
-/*
- * For special situations, the dirent size ends up fixed because we always know
- * what the size of the entry is. That's true for the "." and "..", and
- * therefore we know that they are a fixed size and hence their offsets are
- * constant, as is the first entry.
- *
- * Hence, this calculation is written as a macro to be able to be calculated at
- * compile time and so certain offsets can be calculated directly in the
- * structure initaliser via the macro. There are two macros - one for dirents
- * with ftype and without so there are no unresolvable conditionals in the
- * calculations. We also use round_up() as XFS_DIR2_DATA_ALIGN is always a power
- * of 2 and the compiler doesn't reject it (unlike roundup()).
- */
-#define XFS_DIR2_DATA_ENTSIZE(n)					\
-	round_up((offsetof(struct xfs_dir2_data_entry, name[0]) + (n) +	\
-		 sizeof(xfs_dir2_data_off_t)), XFS_DIR2_DATA_ALIGN)
-
-#define XFS_DIR3_DATA_ENTSIZE(n)					\
-	round_up((offsetof(struct xfs_dir2_data_entry, name[0]) + (n) +	\
-		 sizeof(xfs_dir2_data_off_t) + sizeof(uint8_t)),	\
-		XFS_DIR2_DATA_ALIGN)
-
-int
-xfs_dir2_data_entsize(
-	struct xfs_mount	*mp,
-	int			n)
-{
-	if (xfs_sb_version_hasftype(&mp->m_sb))
-		return XFS_DIR3_DATA_ENTSIZE(n);
-	else
-		return XFS_DIR2_DATA_ENTSIZE(n);
-}
-
 static uint8_t
 xfs_dir2_data_get_ftype(
 	struct xfs_dir2_data_entry *dep)
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index a6c3fb3a2f7b..54bbfdd6ad69 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -57,7 +57,6 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 		struct xfs_buf *lbp, struct xfs_buf *dbp);
 
 /* xfs_dir2_data.c */
-int xfs_dir2_data_entsize(struct xfs_mount *mp, int n);
 __be16 *xfs_dir2_data_entry_tag_p(struct xfs_mount *mp,
 		struct xfs_dir2_data_entry *dep);
 
@@ -172,4 +171,18 @@ extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
 		       struct dir_context *ctx, size_t bufsize);
 
+static inline int
+xfs_dir2_data_entsize(
+	struct xfs_mount	*mp,
+	int			namelen)
+{
+	size_t			len;
+
+	len = offsetof(struct xfs_dir2_data_entry, name[0]) + namelen +
+			sizeof(xfs_dir2_data_off_t) /* tag */;
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		len += sizeof(uint8_t);
+	return round_up(len, XFS_DIR2_DATA_ALIGN);
+}
+
 #endif /* __XFS_DIR2_PRIV_H__ */
-- 
2.20.1

