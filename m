Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1619C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2548206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c7ZfQzBP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfKGSYS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42854 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbfKGSYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DKgDHgt5goZJob4WIhXuLUUfUpYOpMg06ZsSXFtsASM=; b=c7ZfQzBP3Pc/Tp9T6keF8ogUvD
        zsx6f5tBPiBylr3PrZskJSBk8j5x6wCkjE/CfXuCS4Kb7sDOZgWk2kR3RGX6nFHylfc0eiCsFka37
        WWY4wGqY0D+vQ0M+MALeqmS3DND1W+4x7/mq95XqyZn8fAXVgxucpZGf2f3vW74yook3xnXSuX570
        2orB6tx/qnlENYHYZeh2SM6HFQdxK4tHXR8B3LfFM+mQjh3LjeQm6EehoXy0Tn7zHaod1JEADYZe6
        hXkeuElM4zQV8FaQLpBbx7GKEQ6YL4FnX1hdN0M9x1sPr8EhZzHP/oFkd3sP9sZ+UhNydIbstH6Q2
        8dsVxQXg==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmS8-0002jT-Et; Thu, 07 Nov 2019 18:24:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/46] xfs: move incore structures out of xfs_da_format.h
Date:   Thu,  7 Nov 2019 19:23:25 +0100
Message-Id: <20191107182410.12660-2-hch@lst.de>
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

Move the abstract in-memory version of various btree block headers
out of xfs_da_format.h as they aren't on-disk formats.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.h | 23 ++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h  | 13 ++++++++
 fs/xfs/libxfs/xfs_da_format.c |  1 +
 fs/xfs/libxfs/xfs_da_format.h | 57 -----------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 ++
 fs/xfs/libxfs/xfs_dir2_priv.h | 19 ++++++++++++
 6 files changed, 58 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index bb0880057ee3..16208a7743df 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -16,6 +16,29 @@ struct xfs_da_state_blk;
 struct xfs_inode;
 struct xfs_trans;
 
+/*
+ * Incore version of the attribute leaf header.
+ */
+struct xfs_attr3_icleaf_hdr {
+	uint32_t	forw;
+	uint32_t	back;
+	uint16_t	magic;
+	uint16_t	count;
+	uint16_t	usedbytes;
+	/*
+	 * Firstused is 32-bit here instead of 16-bit like the on-disk variant
+	 * to support maximum fsb size of 64k without overflow issues throughout
+	 * the attr code. Instead, the overflow condition is handled on
+	 * conversion to/from disk.
+	 */
+	uint32_t	firstused;
+	__u8		holes;
+	struct {
+		uint16_t	base;
+		uint16_t	size;
+	} freemap[XFS_ATTR_LEAF_MAPSIZE];
+};
+
 /*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ae0bbd20d9ca..02f7a21ab3a5 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -124,6 +124,19 @@ typedef struct xfs_da_state {
 						/* for dirv2 extrablk is data */
 } xfs_da_state_t;
 
+/*
+ * In-core version of the node header to abstract the differences in the v2 and
+ * v3 disk format of the headers. Callers need to convert to/from disk format as
+ * appropriate.
+ */
+struct xfs_da3_icnode_hdr {
+	uint32_t		forw;
+	uint32_t		back;
+	uint16_t		magic;
+	uint16_t		count;
+	uint16_t		level;
+};
+
 /*
  * Utility macros to aid in logging changed structure fields.
  */
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index b1ae572496b6..31bb250c1899 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
 
 /*
  * Shortform directory ops
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index ae654e06b2fb..548806060f45 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -93,19 +93,6 @@ struct xfs_da3_intnode {
 	struct xfs_da_node_entry __btree[];
 };
 
-/*
- * In-core version of the node header to abstract the differences in the v2 and
- * v3 disk format of the headers. Callers need to convert to/from disk format as
- * appropriate.
- */
-struct xfs_da3_icnode_hdr {
-	uint32_t	forw;
-	uint32_t	back;
-	uint16_t	magic;
-	uint16_t	count;
-	uint16_t	level;
-};
-
 /*
  * Directory version 2.
  *
@@ -434,14 +421,6 @@ struct xfs_dir3_leaf_hdr {
 	__be32			pad;		/* 64 bit alignment */
 };
 
-struct xfs_dir3_icleaf_hdr {
-	uint32_t		forw;
-	uint32_t		back;
-	uint16_t		magic;
-	uint16_t		count;
-	uint16_t		stale;
-};
-
 /*
  * Leaf block entry.
  */
@@ -520,19 +499,6 @@ struct xfs_dir3_free {
 
 #define XFS_DIR3_FREE_CRC_OFF  offsetof(struct xfs_dir3_free, hdr.hdr.crc)
 
-/*
- * In core version of the free block header, abstracted away from on-disk format
- * differences. Use this in the code, and convert to/from the disk version using
- * xfs_dir3_free_hdr_from_disk/xfs_dir3_free_hdr_to_disk.
- */
-struct xfs_dir3_icfree_hdr {
-	uint32_t	magic;
-	uint32_t	firstdb;
-	uint32_t	nvalid;
-	uint32_t	nused;
-
-};
-
 /*
  * Single block format.
  *
@@ -709,29 +675,6 @@ struct xfs_attr3_leafblock {
 	 */
 };
 
-/*
- * incore, neutral version of the attribute leaf header
- */
-struct xfs_attr3_icleaf_hdr {
-	uint32_t	forw;
-	uint32_t	back;
-	uint16_t	magic;
-	uint16_t	count;
-	uint16_t	usedbytes;
-	/*
-	 * firstused is 32-bit here instead of 16-bit like the on-disk variant
-	 * to support maximum fsb size of 64k without overflow issues throughout
-	 * the attr code. Instead, the overflow condition is handled on
-	 * conversion to/from disk.
-	 */
-	uint32_t	firstused;
-	__u8		holes;
-	struct {
-		uint16_t	base;
-		uint16_t	size;
-	} freemap[XFS_ATTR_LEAF_MAPSIZE];
-};
-
 /*
  * Special value to represent fs block size in the leaf header firstused field.
  * Only used when block size overflows the 2-bytes available on disk.
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f54244779492..e170792c0acc 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -18,6 +18,8 @@ struct xfs_dir2_sf_entry;
 struct xfs_dir2_data_hdr;
 struct xfs_dir2_data_entry;
 struct xfs_dir2_data_unused;
+struct xfs_dir3_icfree_hdr;
+struct xfs_dir3_icleaf_hdr;
 
 extern struct xfs_name	xfs_name_dotdot;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 59f9fb2241a5..d2eaea663e7f 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -8,6 +8,25 @@
 
 struct dir_context;
 
+/*
+ * In-core version of the leaf and free block headers to abstract the
+ * differences in the v2 and v3 disk format of the headers.
+ */
+struct xfs_dir3_icleaf_hdr {
+	uint32_t		forw;
+	uint32_t		back;
+	uint16_t		magic;
+	uint16_t		count;
+	uint16_t		stale;
+};
+
+struct xfs_dir3_icfree_hdr {
+	uint32_t		magic;
+	uint32_t		firstdb;
+	uint32_t		nvalid;
+	uint32_t		nused;
+};
+
 /* xfs_dir2.c */
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
-- 
2.20.1

