Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C43ECA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14CF12085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:07:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GoscWU5w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfKAWHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:07:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWHe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kYZZCdVfj1bpIpy3BX8TRF1vGMj79fDkj2efAWguHhU=; b=GoscWU5w6WSNfmFDRpzg5YQG7
        VppjyhC+g0D5nNWpypF8RdpDk7InPuwjoFxrrUvizfefUCmT2yDLrfXiTQR7/V/VY3NceT/ZLuqml
        ncQ4pA4hAVGPsWEYg07Oh7xT89naQg2GEhJg1VS+yNPsdp38VNYM4qLsPbKfD+sbXAD8f7wQZbYVU
        RLCJGj0K7XqlOAKHxQ8rtL5fBizeyEiSM7n8F+n+lNPvhfLLSqA78viezq7Z9ZGJ715Us3ZC4DCpx
        +vCHToz6YpsXggPrARuS/3lvw2DYpw0KP17BTSttKtu9vcYbvn1hcYCEb5MGTqGcCEcLghpdqrqar
        3lhBGAk5g==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf4w-0005r7-Dd
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:07:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/34] xfs: move incore structures out of xfs_da_format.h
Date:   Fri,  1 Nov 2019 15:06:46 -0700
Message-Id: <20191101220719.29100-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101220719.29100-1-hch@lst.de>
References: <20191101220719.29100-1-hch@lst.de>
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
---
 fs/xfs/libxfs/xfs_attr_leaf.h | 23 ++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h  | 13 ++++++++
 fs/xfs/libxfs/xfs_da_format.c |  1 +
 fs/xfs/libxfs/xfs_da_format.h | 57 -----------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 ++
 fs/xfs/libxfs/xfs_dir2_priv.h | 20 ++++++++++++
 6 files changed, 59 insertions(+), 57 deletions(-)

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
index 59f9fb2241a5..973b1527b7ba 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -8,6 +8,26 @@
 
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
+
+};
+
 /* xfs_dir2.c */
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
-- 
2.20.1

