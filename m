Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB8AC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D112206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mO4TskjK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfKGSZN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44136 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TksbDRPSXEeg4K1gv6AMQn825QQogQP3XUcakczh6Oo=; b=mO4TskjKJENP34fR4Rvrlc4GC
        Vi/nkeOKVLl8P0qeGMabgVVJNAUNwPZGQux3YkzBxbGAq80cFMHXSGBLPXSVf67iiomk4hNNcWsVO
        V9osEZNMrmJXJzcqy+9Mlg5CqvMdlnXuG0aka38pWnuRYiotsuN/2vA7IMymRLv7+vW1G/6GHFd6Z
        pYvwmbiHMgqQ1Bbg29gAEmxBbVMSKbZBgG6NoTSi96Znn+UsgmUnAccMVetI9XDkgy2hJ4QlQcYAA
        8hybzZrV9hVNg9xAk4MbfF2l1GkVno06tubjShwhIzCc5+Zv6NkIZjY1hj29fCggRZagiD+0fSVzN
        GrL8mbFrQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmT2-0004Lv-6o
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/46] xfs: devirtualize ->sf_get_ino and ->sf_put_ino
Date:   Thu,  7 Nov 2019 19:23:46 +0100
Message-Id: <20191107182410.12660-23-hch@lst.de>
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

Replace the ->sf_get_ino and ->sf_put_ino dir ops methods with directly
called xfs_dir2_sf_get_ino and xfs_dir2_sf_put_ino helpers that take care
of the difference between the directory format with and without the file
type field.  Also move xfs_dir2_sf_get_parent_ino and
xfs_dir2_sf_put_parent_ino to xfs_dir2_sf.c with the rest of the
low-level short form entry handling and use XFS_MAXINUMBER istead of
opencoded constants.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c  | 94 ----------------------------------
 fs/xfs/libxfs/xfs_dir2.h       |  5 --
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 +
 fs/xfs/libxfs/xfs_dir2_sf.c    | 91 +++++++++++++++++++++++++++-----
 fs/xfs/xfs_dir2_readdir.c      |  2 +-
 6 files changed, 82 insertions(+), 114 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index f80495a38a76..f427f141d001 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -58,94 +58,6 @@ xfs_dir3_sfe_put_ftype(
 	sfep->name[sfep->namelen] = ftype;
 }
 
-/*
- * Inode numbers in short-form directories can come in two versions,
- * either 4 bytes or 8 bytes wide.  These helpers deal with the
- * two forms transparently by looking at the headers i8count field.
- *
- * For 64-bit inode number the most significant byte must be zero.
- */
-static xfs_ino_t
-xfs_dir2_sf_get_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	uint8_t			*from)
-{
-	if (hdr->i8count)
-		return get_unaligned_be64(from) & 0x00ffffffffffffffULL;
-	else
-		return get_unaligned_be32(from);
-}
-
-static void
-xfs_dir2_sf_put_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	uint8_t			*to,
-	xfs_ino_t		ino)
-{
-	ASSERT((ino & 0xff00000000000000ULL) == 0);
-
-	if (hdr->i8count)
-		put_unaligned_be64(ino, to);
-	else
-		put_unaligned_be32(ino, to);
-}
-
-xfs_ino_t
-xfs_dir2_sf_get_parent_ino(
-	struct xfs_dir2_sf_hdr	*hdr)
-{
-	return xfs_dir2_sf_get_ino(hdr, hdr->parent);
-}
-
-void
-xfs_dir2_sf_put_parent_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	xfs_ino_t		ino)
-{
-	xfs_dir2_sf_put_ino(hdr, hdr->parent, ino);
-}
-
-/*
- * In short-form directory entries the inode numbers are stored at variable
- * offset behind the entry name. If the entry stores a filetype value, then it
- * sits between the name and the inode number. Hence the inode numbers may only
- * be accessed through the helpers below.
- */
-static xfs_ino_t
-xfs_dir2_sfe_get_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep)
-{
-	return xfs_dir2_sf_get_ino(hdr, &sfep->name[sfep->namelen]);
-}
-
-static void
-xfs_dir2_sfe_put_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep,
-	xfs_ino_t		ino)
-{
-	xfs_dir2_sf_put_ino(hdr, &sfep->name[sfep->namelen], ino);
-}
-
-static xfs_ino_t
-xfs_dir3_sfe_get_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep)
-{
-	return xfs_dir2_sf_get_ino(hdr, &sfep->name[sfep->namelen + 1]);
-}
-
-static void
-xfs_dir3_sfe_put_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep,
-	xfs_ino_t		ino)
-{
-	xfs_dir2_sf_put_ino(hdr, &sfep->name[sfep->namelen + 1], ino);
-}
-
-
 /*
  * Directory data block operations
  */
@@ -361,8 +273,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 static const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_get_ftype = xfs_dir2_sfe_get_ftype,
 	.sf_put_ftype = xfs_dir2_sfe_put_ftype,
-	.sf_get_ino = xfs_dir2_sfe_get_ino,
-	.sf_put_ino = xfs_dir2_sfe_put_ino,
 
 	.data_entsize = xfs_dir2_data_entsize,
 	.data_get_ftype = xfs_dir2_data_get_ftype,
@@ -388,8 +298,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
 	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
-	.sf_get_ino = xfs_dir3_sfe_get_ino,
-	.sf_put_ino = xfs_dir3_sfe_put_ino,
 
 	.data_entsize = xfs_dir3_data_entsize,
 	.data_get_ftype = xfs_dir3_data_get_ftype,
@@ -415,8 +323,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 static const struct xfs_dir_ops xfs_dir3_ops = {
 	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
 	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
-	.sf_get_ino = xfs_dir3_sfe_get_ino,
-	.sf_put_ino = xfs_dir3_sfe_put_ino,
 
 	.data_entsize = xfs_dir3_data_entsize,
 	.data_get_ftype = xfs_dir3_data_get_ftype,
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c99f0ad6607a..049d844d6a18 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -35,11 +35,6 @@ struct xfs_dir_ops {
 	uint8_t (*sf_get_ftype)(struct xfs_dir2_sf_entry *sfep);
 	void	(*sf_put_ftype)(struct xfs_dir2_sf_entry *sfep,
 				uint8_t ftype);
-	xfs_ino_t (*sf_get_ino)(struct xfs_dir2_sf_hdr *hdr,
-				struct xfs_dir2_sf_entry *sfep);
-	void	(*sf_put_ino)(struct xfs_dir2_sf_hdr *hdr,
-			      struct xfs_dir2_sf_entry *sfep,
-			      xfs_ino_t ino);
 
 	int	(*data_entsize)(int len);
 	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index a6decb4c079a..02b0344508e0 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1208,7 +1208,7 @@ xfs_dir2_sf_to_block(
 		 * Copy a real entry.
 		 */
 		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
-		dep->inumber = cpu_to_be64(dp->d_ops->sf_get_ino(sfp, sfep));
+		dep->inumber = cpu_to_be64(xfs_dir2_sf_get_ino(mp, sfp, sfep));
 		dep->namelen = sfep->namelen;
 		dp->d_ops->data_put_ftype(dep, dp->d_ops->sf_get_ftype(sfep));
 		memcpy(dep->name, sfep->name, dep->namelen);
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 357b388a5be0..a194a7b57277 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -145,6 +145,8 @@ extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, struct xfs_buf **bpp);
 
 /* xfs_dir2_sf.c */
+xfs_ino_t xfs_dir2_sf_get_ino(struct xfs_mount *mp, struct xfs_dir2_sf_hdr *hdr,
+		struct xfs_dir2_sf_entry *sfep);
 xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *hdr);
 void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *hdr, xfs_ino_t ino);
 struct xfs_dir2_sf_entry *xfs_dir2_sf_nextentry(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 36d79ec57d55..f63fb044bd15 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -62,6 +62,70 @@ xfs_dir2_sf_nextentry(
 	return (void *)sfep + xfs_dir2_sf_entsize(mp, hdr, sfep->namelen);
 }
 
+/*
+ * In short-form directory entries the inode numbers are stored at variable
+ * offset behind the entry name. If the entry stores a filetype value, then it
+ * sits between the name and the inode number.  The actual inode numbers can
+ * come in two formats as well, either 4 bytes or 8 bytes wide.
+ */
+xfs_ino_t
+xfs_dir2_sf_get_ino(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_sf_hdr		*hdr,
+	struct xfs_dir2_sf_entry	*sfep)
+{
+	uint8_t				*from = sfep->name + sfep->namelen;
+
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		from++;
+
+	if (!hdr->i8count)
+		return get_unaligned_be32(from);
+	return get_unaligned_be64(from) & XFS_MAXINUMBER;
+}
+
+static void
+xfs_dir2_sf_put_ino(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_sf_hdr		*hdr,
+	struct xfs_dir2_sf_entry	*sfep,
+	xfs_ino_t			ino)
+{
+	uint8_t				*to = sfep->name + sfep->namelen;
+
+	ASSERT(ino <= XFS_MAXINUMBER);
+
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		to++;
+
+	if (hdr->i8count)
+		put_unaligned_be64(ino, to);
+	else
+		put_unaligned_be32(ino, to);
+}
+
+xfs_ino_t
+xfs_dir2_sf_get_parent_ino(
+	struct xfs_dir2_sf_hdr	*hdr)
+{
+	if (!hdr->i8count)
+		return get_unaligned_be32(hdr->parent);
+	return get_unaligned_be64(hdr->parent) & XFS_MAXINUMBER;
+}
+
+void
+xfs_dir2_sf_put_parent_ino(
+	struct xfs_dir2_sf_hdr		*hdr,
+	xfs_ino_t			ino)
+{
+	ASSERT(ino <= XFS_MAXINUMBER);
+
+	if (hdr->i8count)
+		put_unaligned_be64(ino, hdr->parent);
+	else
+		put_unaligned_be32(ino, hdr->parent);
+}
+
 /*
  * Given a block directory (dp/block), calculate its size as a shortform (sf)
  * directory and a header for the sf directory, if it will fit it the
@@ -239,7 +303,7 @@ xfs_dir2_block_to_sf(
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)hdr));
 			memcpy(sfep->name, dep->name, dep->namelen);
-			dp->d_ops->sf_put_ino(sfp, sfep,
+			xfs_dir2_sf_put_ino(mp, sfp, sfep,
 					      be64_to_cpu(dep->inumber));
 			dp->d_ops->sf_put_ftype(sfep,
 					dp->d_ops->data_get_ftype(dep));
@@ -406,7 +470,7 @@ xfs_dir2_sf_addname_easy(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
+	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
 
 	/*
@@ -496,7 +560,7 @@ xfs_dir2_sf_addname_hard(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
+	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
@@ -613,7 +677,7 @@ xfs_dir2_sf_check(
 	     i < sfp->count;
 	     i++, sfep = xfs_dir2_sf_nextentry(dp->i_mount, sfp, sfep)) {
 		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
-		ino = dp->d_ops->sf_get_ino(sfp, sfep);
+		ino = xfs_dir2_sf_get_ino(dp->i_mount, sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		offset =
 			xfs_dir2_sf_get_offset(sfep) +
@@ -705,7 +769,7 @@ xfs_dir2_sf_verify(
 			return __this_address;
 
 		/* Check the inode number. */
-		ino = dops->sf_get_ino(sfp, sfep);
+		ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		error = xfs_dir_ino_validate(mp, ino);
 		if (error)
@@ -848,7 +912,7 @@ xfs_dir2_sf_lookup(
 								sfep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
-			args->inumber = dp->d_ops->sf_get_ino(sfp, sfep);
+			args->inumber = xfs_dir2_sf_get_ino(mp, sfp, sfep);
 			args->filetype = dp->d_ops->sf_get_ftype(sfep);
 			if (cmp == XFS_CMP_EXACT)
 				return -EEXIST;
@@ -901,7 +965,7 @@ xfs_dir2_sf_removename(
 	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep)) {
 		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
-			ASSERT(dp->d_ops->sf_get_ino(sfp, sfep) ==
+			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
 			break;
 		}
@@ -1016,9 +1080,10 @@ xfs_dir2_sf_replace(
 		     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep)) {
 			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
-				ino = dp->d_ops->sf_get_ino(sfp, sfep);
+				ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
 				ASSERT(args->inumber != ino);
-				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
+				xfs_dir2_sf_put_ino(mp, sfp, sfep,
+						args->inumber);
 				dp->d_ops->sf_put_ftype(sfep, args->filetype);
 				break;
 			}
@@ -1123,8 +1188,8 @@ xfs_dir2_sf_toino4(
 		sfep->namelen = oldsfep->namelen;
 		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		dp->d_ops->sf_put_ino(sfp, sfep,
-				      dp->d_ops->sf_get_ino(oldsfp, oldsfep));
+		xfs_dir2_sf_put_ino(mp, sfp, sfep,
+				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
 		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
 	}
 	/*
@@ -1195,8 +1260,8 @@ xfs_dir2_sf_toino8(
 		sfep->namelen = oldsfep->namelen;
 		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		dp->d_ops->sf_put_ino(sfp, sfep,
-				      dp->d_ops->sf_get_ino(oldsfp, oldsfep));
+		xfs_dir2_sf_put_ino(mp, sfp, sfep,
+				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
 		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
 	}
 	/*
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 7d150e914d00..9d318f091a73 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -114,7 +114,7 @@ xfs_dir2_sf_getdents(
 			continue;
 		}
 
-		ino = dp->d_ops->sf_get_ino(sfp, sfep);
+		ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
 		filetype = dp->d_ops->sf_get_ftype(sfep);
 		ctx->pos = off & 0x7fffffff;
 		if (!xfs_dir2_namecheck(sfep->name, sfep->namelen)) {
-- 
2.20.1

