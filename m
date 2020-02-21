Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C1EC35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA5F0222C4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H9NuUIR7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgBUOL6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:11:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59304 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728640AbgBUOL5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1rGIouOWfJ0k2OvrMCdPkMucPRPBUfqTIZwYXAa+xAo=; b=H9NuUIR7c9Wf5jiQKaGG1SbaA6
        p1Xkmpargfxo9REAsUYivympKe8c6eI+gzw+RMmFNJra5WuCaXCNVJsH576IVjewb0kkOcG1GmUPK
        Z8q7JT7hAC/2KqMew59O4XldtKeiK9743AUraDAKZghud5OYKfFD9uchvNi0nA2j7ZwfwLaIi8Pso
        IgsfaXLKg1+YAMTFFJ0ZE5xSVKGCqSUBOD1e9jQt1hKfs/Z+WjawLUXH1tSX3L0CEjJRIWn5hVJWJ
        6FPbxQhQln3z2fXseQ6hYI4JJq5MLkWGUFchbDvZprXbCMt7bihILSZv9OrVbJIy0xy8Hu3BnGY+C
        BhWv3B3A==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5924-0000Gx-U1; Fri, 21 Feb 2020 14:11:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/31] xfs: move struct xfs_da_args to xfs_types.h
Date:   Fri, 21 Feb 2020 06:11:32 -0800
Message-Id: <20200221141154.476496-10-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To allow passing a struct xfs_da_args to the high-level attr helpers
it needs to be easily includable by files like xfs_xattr.c.  Move the
struct definition to xfs_types.h to allow for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h | 64 ------------------------------------
 fs/xfs/libxfs/xfs_types.h    | 60 +++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 0f4fbb0889ff..dd2f48b8ee07 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -36,70 +36,6 @@ struct xfs_da_geometry {
 	size_t		data_entry_offset;
 };
 
-/*========================================================================
- * Btree searching and modification structure definitions.
- *========================================================================*/
-
-/*
- * Search comparison results
- */
-enum xfs_dacmp {
-	XFS_CMP_DIFFERENT,	/* names are completely different */
-	XFS_CMP_EXACT,		/* names are exactly the same */
-	XFS_CMP_CASE		/* names are same but differ in case */
-};
-
-/*
- * Structure to ease passing around component names.
- */
-typedef struct xfs_da_args {
-	struct xfs_da_geometry *geo;	/* da block geometry */
-	const uint8_t		*name;		/* string (maybe not NULL terminated) */
-	int		namelen;	/* length of string (maybe no NULL) */
-	uint8_t		filetype;	/* filetype of inode for directories */
-	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
-	int		valuelen;	/* length of value */
-	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
-	xfs_dahash_t	hashval;	/* hash value of name */
-	xfs_ino_t	inumber;	/* input/output inode number */
-	struct xfs_inode *dp;		/* directory inode to manipulate */
-	struct xfs_trans *trans;	/* current trans (changes over time) */
-	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
-	int		whichfork;	/* data or attribute fork */
-	xfs_dablk_t	blkno;		/* blkno of attr leaf of interest */
-	int		index;		/* index of attr of interest in blk */
-	xfs_dablk_t	rmtblkno;	/* remote attr value starting blkno */
-	int		rmtblkcnt;	/* remote attr value block count */
-	int		rmtvaluelen;	/* remote attr value length in bytes */
-	xfs_dablk_t	blkno2;		/* blkno of 2nd attr leaf of interest */
-	int		index2;		/* index of 2nd attr in blk */
-	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
-	int		rmtblkcnt2;	/* remote attr value block count */
-	int		rmtvaluelen2;	/* remote attr value length in bytes */
-	int		op_flags;	/* operation flags */
-	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
-} xfs_da_args_t;
-
-/*
- * Operation flags:
- */
-#define XFS_DA_OP_JUSTCHECK	0x0001	/* check for ok with no space */
-#define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
-#define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
-#define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
-#define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
-#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
-#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
-
-#define XFS_DA_OP_FLAGS \
-	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
-	{ XFS_DA_OP_RENAME,	"RENAME" }, \
-	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
-	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
-	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
-	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
-
 /*
  * Storage for holding state during Btree searches and split/join ops.
  *
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 397d94775440..e2711d119665 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -175,6 +175,66 @@ enum xfs_ag_resv_type {
 	XFS_AG_RESV_RMAPBT,
 };
 
+/*
+ * Dir/attr btree search comparison results.
+ */
+enum xfs_dacmp {
+	XFS_CMP_DIFFERENT,	/* names are completely different */
+	XFS_CMP_EXACT,		/* names are exactly the same */
+	XFS_CMP_CASE		/* names are same but differ in case */
+};
+
+/*
+ * Structure to ease passing around dir/attr component names.
+ */
+typedef struct xfs_da_args {
+	struct xfs_da_geometry *geo;	/* da block geometry */
+	const uint8_t	*name;		/* string (maybe not NULL terminated) */
+	int		namelen;	/* length of string (maybe no NULL) */
+	uint8_t		filetype;	/* filetype of inode for directories */
+	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
+	int		valuelen;	/* length of value */
+	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
+	xfs_dahash_t	hashval;	/* hash value of name */
+	xfs_ino_t	inumber;	/* input/output inode number */
+	struct xfs_inode *dp;		/* directory inode to manipulate */
+	struct xfs_trans *trans;	/* current trans (changes over time) */
+	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
+	int		whichfork;	/* data or attribute fork */
+	xfs_dablk_t	blkno;		/* blkno of attr leaf of interest */
+	int		index;		/* index of attr of interest in blk */
+	xfs_dablk_t	rmtblkno;	/* remote attr value starting blkno */
+	int		rmtblkcnt;	/* remote attr value block count */
+	int		rmtvaluelen;	/* remote attr value length in bytes */
+	xfs_dablk_t	blkno2;		/* blkno of 2nd attr leaf of interest */
+	int		index2;		/* index of 2nd attr in blk */
+	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
+	int		rmtblkcnt2;	/* remote attr value block count */
+	int		rmtvaluelen2;	/* remote attr value length in bytes */
+	int		op_flags;	/* operation flags */
+	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+} xfs_da_args_t;
+
+/*
+ * Operation flags:
+ */
+#define XFS_DA_OP_JUSTCHECK	0x0001	/* check for ok with no space */
+#define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
+#define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
+#define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
+#define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
+#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
+#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
+
+#define XFS_DA_OP_FLAGS \
+	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
+	{ XFS_DA_OP_RENAME,	"RENAME" }, \
+	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
+	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
+	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
+	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
+	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
+
 /*
  * Type verifier functions
  */
-- 
2.24.1

