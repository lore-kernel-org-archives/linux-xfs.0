Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEFFCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 555D92085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m6UzlAi1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfKAWJ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:09:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53770 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfKAWJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:09:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BPNasBTAGouqnqf/Bx5tyebUB/hN7348NZmEQiHsSZo=; b=m6UzlAi1Gg6vmYc3I6rV+PPBr
        hYf+PbguCvZJuNSBwZa7pKDS+gjOkoN5MeG/89xZFG+2eSpFA9f6gYe73Tj6Q2iOHz4HyoYcj3Yd7
        Wu7g84E0DvVeYgOCHzCxFIUP+W4g7J5QkNo87vwfx6coL9vqUUYX9CDlLxxnHWFIyX7MpuVzoqpJg
        R7BHNFelcyyoIeTS6BT843Yh0S2o0DGvUnjexeebxZWKwDojhP4o+L+U6a8m7Sqw04qCuXN1gaJLm
        2Ix3wvrE4lLfQ/zkADXXoOt1WNMjK4M0KmZTG3bW0QwHAyDNEoEMV5bNTHr77Tl0IscoNkbn8EGE4
        V1bG5HSyw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf6j-00064E-8n
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:09:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/34] xfs: devirtualize ->sf_get_ftype and ->sf_put_ftype
Date:   Fri,  1 Nov 2019 15:07:07 -0700
Message-Id: <20191101220719.29100-23-hch@lst.de>
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

Replace the ->sf_get_ftype and ->sf_put_ftype dir ops methods with
directly called xfs_dir2_sf_get_ftype and xfs_dir2_sf_put_ftype helpers
that takes care of the differences between the directory format with and
without the file type field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c  | 52 -----------------------------
 fs/xfs/libxfs/xfs_dir2.h       |  4 ---
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 60 ++++++++++++++++++++++++++--------
 fs/xfs/xfs_dir2_readdir.c      |  2 +-
 6 files changed, 50 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index f427f141d001..1c72b46344d6 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -15,49 +15,6 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 
-/*
- * For filetype enabled shortform directories, the file type field is stored at
- * the end of the name.  Because it's only a single byte, endian conversion is
- * not necessary. For non-filetype enable directories, the type is always
- * unknown and we never store the value.
- */
-static uint8_t
-xfs_dir2_sfe_get_ftype(
-	struct xfs_dir2_sf_entry *sfep)
-{
-	return XFS_DIR3_FT_UNKNOWN;
-}
-
-static void
-xfs_dir2_sfe_put_ftype(
-	struct xfs_dir2_sf_entry *sfep,
-	uint8_t			ftype)
-{
-	ASSERT(ftype < XFS_DIR3_FT_MAX);
-}
-
-static uint8_t
-xfs_dir3_sfe_get_ftype(
-	struct xfs_dir2_sf_entry *sfep)
-{
-	uint8_t		ftype;
-
-	ftype = sfep->name[sfep->namelen];
-	if (ftype >= XFS_DIR3_FT_MAX)
-		return XFS_DIR3_FT_UNKNOWN;
-	return ftype;
-}
-
-static void
-xfs_dir3_sfe_put_ftype(
-	struct xfs_dir2_sf_entry *sfep,
-	uint8_t			ftype)
-{
-	ASSERT(ftype < XFS_DIR3_FT_MAX);
-
-	sfep->name[sfep->namelen] = ftype;
-}
-
 /*
  * Directory data block operations
  */
@@ -271,9 +228,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 }
 
 static const struct xfs_dir_ops xfs_dir2_ops = {
-	.sf_get_ftype = xfs_dir2_sfe_get_ftype,
-	.sf_put_ftype = xfs_dir2_sfe_put_ftype,
-
 	.data_entsize = xfs_dir2_data_entsize,
 	.data_get_ftype = xfs_dir2_data_get_ftype,
 	.data_put_ftype = xfs_dir2_data_put_ftype,
@@ -296,9 +250,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
-	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
-	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
-
 	.data_entsize = xfs_dir3_data_entsize,
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
@@ -321,9 +272,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
-	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
-	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
-
 	.data_entsize = xfs_dir3_data_entsize,
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 049d844d6a18..61cc9ae837d5 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -32,10 +32,6 @@ extern unsigned char xfs_mode_to_ftype(int mode);
  * directory operations vector for encode/decode routines
  */
 struct xfs_dir_ops {
-	uint8_t (*sf_get_ftype)(struct xfs_dir2_sf_entry *sfep);
-	void	(*sf_put_ftype)(struct xfs_dir2_sf_entry *sfep,
-				uint8_t ftype);
-
 	int	(*data_entsize)(int len);
 	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
 	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 0f3024386a5c..5877272dc63e 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1216,7 +1216,7 @@ xfs_dir2_sf_to_block(
 		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
 		dep->inumber = cpu_to_be64(xfs_dir2_sf_get_ino(mp, sfp, sfep));
 		dep->namelen = sfep->namelen;
-		dp->d_ops->data_put_ftype(dep, dp->d_ops->sf_get_ftype(sfep));
+		dp->d_ops->data_put_ftype(dep, xfs_dir2_sf_get_ftype(mp, sfep));
 		memcpy(dep->name, sfep->name, dep->namelen);
 		tagp = dp->d_ops->data_entry_tag_p(dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 57c0f7aee7a4..a92d9f0f83e0 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -139,6 +139,8 @@ xfs_ino_t xfs_dir2_sf_get_ino(struct xfs_mount *mp, struct xfs_dir2_sf_hdr *hdr,
 		struct xfs_dir2_sf_entry *sfep);
 xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *hdr);
 void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *hdr, xfs_ino_t ino);
+uint8_t xfs_dir2_sf_get_ftype(struct xfs_mount *mp,
+		struct xfs_dir2_sf_entry *sfep);
 struct xfs_dir2_sf_entry *xfs_dir2_sf_nextentry(struct xfs_mount *mp,
 		struct xfs_dir2_sf_hdr *hdr, struct xfs_dir2_sf_entry *sfep);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index c33d838b1a5c..10199261c94c 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -126,6 +126,37 @@ xfs_dir2_sf_put_parent_ino(
 		put_unaligned_be32(ino, hdr->parent);
 }
 
+/*
+ * The file type field is stored at the end of the name for filetype enabled
+ * shortform directories, or not at all otherwise.
+ */
+uint8_t
+xfs_dir2_sf_get_ftype(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_sf_entry	*sfep)
+{
+	if (xfs_sb_version_hasftype(&mp->m_sb)) {
+		uint8_t			ftype = sfep->name[sfep->namelen];
+
+		if (ftype < XFS_DIR3_FT_MAX)
+			return ftype;
+	}
+
+	return XFS_DIR3_FT_UNKNOWN;
+}
+
+static void
+xfs_dir2_sf_put_ftype(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_sf_entry *sfep,
+	uint8_t			ftype)
+{
+	ASSERT(ftype < XFS_DIR3_FT_MAX);
+
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		sfep->name[sfep->namelen] = ftype;
+}
+
 /*
  * Given a block directory (dp/block), calculate its size as a shortform (sf)
  * directory and a header for the sf directory, if it will fit it the
@@ -305,7 +336,7 @@ xfs_dir2_block_to_sf(
 			memcpy(sfep->name, dep->name, dep->namelen);
 			xfs_dir2_sf_put_ino(mp, sfp, sfep,
 					      be64_to_cpu(dep->inumber));
-			dp->d_ops->sf_put_ftype(sfep,
+			xfs_dir2_sf_put_ftype(mp, sfep,
 					dp->d_ops->data_get_ftype(dep));
 
 			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
@@ -477,7 +508,7 @@ xfs_dir2_sf_addname_easy(
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
-	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
 
 	/*
 	 * Update the header and inode.
@@ -567,7 +598,7 @@ xfs_dir2_sf_addname_hard(
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
-	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
@@ -664,7 +695,8 @@ static void
 xfs_dir2_sf_check(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
-	xfs_inode_t		*dp;		/* incore directory inode */
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	int			i;		/* entry number */
 	int			i8count;	/* number of big inode#s */
 	xfs_ino_t		ino;		/* entry inode number */
@@ -672,8 +704,6 @@ xfs_dir2_sf_check(
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform dir entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
-	dp = args->dp;
-
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	offset = dp->d_ops->data_first_offset;
 	ino = xfs_dir2_sf_get_parent_ino(sfp);
@@ -681,14 +711,14 @@ xfs_dir2_sf_check(
 
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->count;
-	     i++, sfep = xfs_dir2_sf_nextentry(dp->i_mount, sfp, sfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep)) {
 		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
-		ino = xfs_dir2_sf_get_ino(dp->i_mount, sfp, sfep);
+		ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		offset =
 			xfs_dir2_sf_get_offset(sfep) +
 			dp->d_ops->data_entsize(sfep->namelen);
-		ASSERT(dp->d_ops->sf_get_ftype(sfep) < XFS_DIR3_FT_MAX);
+		ASSERT(xfs_dir2_sf_get_ftype(mp, sfep) < XFS_DIR3_FT_MAX);
 	}
 	ASSERT(i8count == sfp->i8count);
 	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);
@@ -782,7 +812,7 @@ xfs_dir2_sf_verify(
 			return __this_address;
 
 		/* Check the file type. */
-		filetype = dops->sf_get_ftype(sfep);
+		filetype = xfs_dir2_sf_get_ftype(mp, sfep);
 		if (filetype >= XFS_DIR3_FT_MAX)
 			return __this_address;
 
@@ -925,7 +955,7 @@ xfs_dir2_sf_lookup(
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
 			args->inumber = xfs_dir2_sf_get_ino(mp, sfp, sfep);
-			args->filetype = dp->d_ops->sf_get_ftype(sfep);
+			args->filetype = xfs_dir2_sf_get_ftype(mp, sfep);
 			if (cmp == XFS_CMP_EXACT)
 				return -EEXIST;
 			ci_sfep = sfep;
@@ -1108,7 +1138,7 @@ xfs_dir2_sf_replace(
 				ASSERT(args->inumber != ino);
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
-				dp->d_ops->sf_put_ftype(sfep, args->filetype);
+				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
 				break;
 			}
 		}
@@ -1214,7 +1244,8 @@ xfs_dir2_sf_toino4(
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
 		xfs_dir2_sf_put_ino(mp, sfp, sfep,
 				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
-		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
+		xfs_dir2_sf_put_ftype(mp, sfep,
+				xfs_dir2_sf_get_ftype(mp, oldsfep));
 	}
 	/*
 	 * Clean up the inode.
@@ -1286,7 +1317,8 @@ xfs_dir2_sf_toino8(
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
 		xfs_dir2_sf_put_ino(mp, sfp, sfep,
 				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
-		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
+		xfs_dir2_sf_put_ftype(mp, sfep,
+				xfs_dir2_sf_get_ftype(mp, oldsfep));
 	}
 	/*
 	 * Clean up the inode.
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 9d318f091a73..e18045465455 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -115,7 +115,7 @@ xfs_dir2_sf_getdents(
 		}
 
 		ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
-		filetype = dp->d_ops->sf_get_ftype(sfep);
+		filetype = xfs_dir2_sf_get_ftype(mp, sfep);
 		ctx->pos = off & 0x7fffffff;
 		if (!xfs_dir2_namecheck(sfep->name, sfep->namelen)) {
 			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-- 
2.20.1

