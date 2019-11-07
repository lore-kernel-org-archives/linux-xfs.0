Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C591FC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9634C206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IJZ5TStH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfKGS0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:26:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44302 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbfKGS0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iEtN+MYjLFhQfqwzp9qCDY9aE3E4/WpUavhxgRYFudc=; b=IJZ5TStHPJzUFDEv0Fi2XVTiD2
        PHY8yOsZa1HeBiVxgZaMEVeM6NeSYDGutp9/BfCOwnSsa10CjL6iTbyFrO5WYWhYIjRtMe1ofJbxh
        dhMcBp03EUPIAyxiD1nbOCMRU6pysK85eh+JehFGmu5Vfw9mqIVmOo7JeT+CaWViZl9oTXiZh6MZJ
        s7mGB2eaHnqE1Q8ZaqVCIW42791r20ibdldH9KSzEH/K+7/Whz66wYC6o8Lz4CV2+7e6LrmEKrfJt
        KuIhKt8qjctfzAuyI8ZwFKYFkuGmwBnCuqpL1BWcz/g7wz/jP6TkPfygJUWIV12ucGYu3oCbl91nt
        LiBhDtzA==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTt-0004V4-Hm; Thu, 07 Nov 2019 18:26:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 43/46] xfs: devirtualize ->data_get_ftype and ->data_put_ftype
Date:   Thu,  7 Nov 2019 19:24:07 +0100
Message-Id: <20191107182410.12660-44-hch@lst.de>
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

Replace the ->data_get_ftype and ->data_put_ftype dir ops methods with
directly called xfs_dir2_data_get_ftype and xfs_dir2_data_put_ftype
helpers that takes care of the differences between the directory format
with and without the file type field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.c  | 47 ----------------------------------
 fs/xfs/libxfs/xfs_dir2.h       |  3 ---
 fs/xfs/libxfs/xfs_dir2_block.c | 13 +++++-----
 fs/xfs/libxfs/xfs_dir2_data.c  | 43 ++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  6 ++---
 fs/xfs/libxfs/xfs_dir2_node.c  |  6 ++---
 fs/xfs/libxfs/xfs_dir2_priv.h  |  4 +++
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 +-
 fs/xfs/xfs_dir2_readdir.c      |  4 +--
 9 files changed, 51 insertions(+), 77 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index b9f9fbf7eee2..498363ac193d 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -15,60 +15,13 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 
-/*
- * Directory data block operations
- */
-
-static uint8_t
-xfs_dir2_data_get_ftype(
-	struct xfs_dir2_data_entry *dep)
-{
-	return XFS_DIR3_FT_UNKNOWN;
-}
-
-static void
-xfs_dir2_data_put_ftype(
-	struct xfs_dir2_data_entry *dep,
-	uint8_t			ftype)
-{
-	ASSERT(ftype < XFS_DIR3_FT_MAX);
-}
-
-static uint8_t
-xfs_dir3_data_get_ftype(
-	struct xfs_dir2_data_entry *dep)
-{
-	uint8_t		ftype = dep->name[dep->namelen];
-
-	if (ftype >= XFS_DIR3_FT_MAX)
-		return XFS_DIR3_FT_UNKNOWN;
-	return ftype;
-}
-
-static void
-xfs_dir3_data_put_ftype(
-	struct xfs_dir2_data_entry *dep,
-	uint8_t			type)
-{
-	ASSERT(type < XFS_DIR3_FT_MAX);
-	ASSERT(dep->namelen != 0);
-
-	dep->name[dep->namelen] = type;
-}
-
 static const struct xfs_dir_ops xfs_dir2_ops = {
-	.data_get_ftype = xfs_dir2_data_get_ftype,
-	.data_put_ftype = xfs_dir2_data_put_ftype,
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
-	.data_get_ftype = xfs_dir3_data_get_ftype,
-	.data_put_ftype = xfs_dir3_data_put_ftype,
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
-	.data_get_ftype = xfs_dir3_data_get_ftype,
-	.data_put_ftype = xfs_dir3_data_put_ftype,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index b50273b2d970..b44c64a20f67 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -32,9 +32,6 @@ extern unsigned char xfs_mode_to_ftype(int mode);
  * directory operations vector for encode/decode routines
  */
 struct xfs_dir_ops {
-	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
-	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
-				uint8_t ftype);
 };
 
 extern const struct xfs_dir_ops *
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 62b3adb01210..0c481e55c981 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -541,7 +541,7 @@ xfs_dir2_block_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, args->namelen);
-	dp->d_ops->data_put_ftype(dep, args->filetype);
+	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
@@ -633,7 +633,7 @@ xfs_dir2_block_lookup(
 	 * Fill in inode number, CI name if appropriate, release the block.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
-	args->filetype = dp->d_ops->data_get_ftype(dep);
+	args->filetype = xfs_dir2_data_get_ftype(dp->i_mount, dep);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(args->trans, bp);
 	return error;
@@ -865,7 +865,7 @@ xfs_dir2_block_replace(
 	 * Change the inode number to the new value.
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
-	dp->d_ops->data_put_ftype(dep, args->filetype);
+	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	xfs_dir2_data_log_entry(args, bp, dep);
 	xfs_dir3_data_check(dp, bp);
 	return 0;
@@ -1145,7 +1145,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
-	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
+	xfs_dir2_data_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
 	tagp = xfs_dir2_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16(offset);
 	xfs_dir2_data_log_entry(args, bp, dep);
@@ -1160,7 +1160,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
-	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
+	xfs_dir2_data_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
 	tagp = xfs_dir2_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16(offset);
 	xfs_dir2_data_log_entry(args, bp, dep);
@@ -1210,7 +1210,8 @@ xfs_dir2_sf_to_block(
 		dep = bp->b_addr + newoffset;
 		dep->inumber = cpu_to_be64(xfs_dir2_sf_get_ino(mp, sfp, sfep));
 		dep->namelen = sfep->namelen;
-		dp->d_ops->data_put_ftype(dep, xfs_dir2_sf_get_ftype(mp, sfep));
+		xfs_dir2_data_put_ftype(mp, dep,
+				xfs_dir2_sf_get_ftype(mp, sfep));
 		memcpy(dep->name, sfep->name, dep->namelen);
 		tagp = xfs_dir2_data_entry_tag_p(mp, dep);
 		*tagp = cpu_to_be16(newoffset);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 6ed9396225e3..0aa1d165c964 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -47,6 +47,34 @@ xfs_dir2_data_entry_tag_p(
 		xfs_dir2_data_entsize(mp, dep->namelen) - sizeof(__be16));
 }
 
+uint8_t
+xfs_dir2_data_get_ftype(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_data_entry	*dep)
+{
+	if (xfs_sb_version_hasftype(&mp->m_sb)) {
+		uint8_t			ftype = dep->name[dep->namelen];
+
+		if (likely(ftype < XFS_DIR3_FT_MAX))
+			return ftype;
+	}
+
+	return XFS_DIR3_FT_UNKNOWN;
+}
+
+void
+xfs_dir2_data_put_ftype(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_data_entry	*dep,
+	uint8_t				ftype)
+{
+	ASSERT(ftype < XFS_DIR3_FT_MAX);
+	ASSERT(dep->namelen != 0);
+
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		dep->name[dep->namelen] = ftype;
+}
+
 /*
  * The number of leaf entries is limited by the size of the block and the amount
  * of space used by the data entries.  We don't know how much space is used by
@@ -88,21 +116,12 @@ __xfs_dir3_data_check(
 	struct xfs_name		name;
 	unsigned int		offset;
 	unsigned int		end;
-	const struct xfs_dir_ops *ops;
 	struct xfs_da_geometry	*geo = mp->m_dir_geo;
 
 	/*
-	 * We can be passed a null dp here from a verifier, so we need to go the
-	 * hard way to get them.
-	 */
-	ops = xfs_dir_get_ops(mp, dp);
-
-	/*
-	 * If this isn't a directory, or we don't get handed the dir ops,
-	 * something is seriously wrong.  Bail out.
+	 * If this isn't a directory, something is seriously wrong.  Bail out.
 	 */
-	if ((dp && !S_ISDIR(VFS_I(dp)->i_mode)) ||
-	    ops != xfs_dir_get_ops(mp, NULL))
+	if (dp && !S_ISDIR(VFS_I(dp)->i_mode))
 		return __this_address;
 
 	hdr = bp->b_addr;
@@ -206,7 +225,7 @@ __xfs_dir3_data_check(
 			return __this_address;
 		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) != offset)
 			return __this_address;
-		if (ops->data_get_ftype(dep) >= XFS_DIR3_FT_MAX)
+		if (xfs_dir2_data_get_ftype(mp, dep) >= XFS_DIR3_FT_MAX)
 			return __this_address;
 		count++;
 		lastfree = 0;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 7fa485cd0158..bc301c973450 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -865,7 +865,7 @@ xfs_dir2_leaf_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	dp->d_ops->data_put_ftype(dep, args->filetype);
+	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
@@ -1195,7 +1195,7 @@ xfs_dir2_leaf_lookup(
 	 * Return the found inode number & CI name if appropriate
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
-	args->filetype = dp->d_ops->data_get_ftype(dep);
+	args->filetype = xfs_dir2_data_get_ftype(dp->i_mount, dep);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(tp, dbp);
 	xfs_trans_brelse(tp, lbp);
@@ -1526,7 +1526,7 @@ xfs_dir2_leaf_replace(
 	 * Put the new inode number in, log it.
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
-	dp->d_ops->data_put_ftype(dep, args->filetype);
+	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tp = args->trans;
 	xfs_dir2_data_log_entry(args, dbp, dep);
 	xfs_dir3_leaf_check(dp, lbp);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index c97217e57a27..5551be7c29df 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -884,7 +884,7 @@ xfs_dir2_leafn_lookup_for_entry(
 				xfs_trans_brelse(tp, state->extrablk.bp);
 			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
-			args->filetype = dp->d_ops->data_get_ftype(dep);
+			args->filetype = xfs_dir2_data_get_ftype(mp, dep);
 			*indexp = index;
 			state->extravalid = 1;
 			state->extrablk.bp = curbp;
@@ -1969,7 +1969,7 @@ xfs_dir2_node_addname_int(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	dp->d_ops->data_put_ftype(dep, args->filetype);
+	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
@@ -2253,7 +2253,7 @@ xfs_dir2_node_replace(
 		 * Fill in the new inode number and log the entry.
 		 */
 		dep->inumber = cpu_to_be64(inum);
-		args->dp->d_ops->data_put_ftype(dep, ftype);
+		xfs_dir2_data_put_ftype(state->mp, dep, ftype);
 		xfs_dir2_data_log_entry(args, state->extrablk.bp, dep);
 		rval = 0;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 99cdc31eb8c9..82764aa2a6f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -61,6 +61,10 @@ struct xfs_dir2_data_free *xfs_dir2_data_bestfree_p(struct xfs_mount *mp,
 		struct xfs_dir2_data_hdr *hdr);
 __be16 *xfs_dir2_data_entry_tag_p(struct xfs_mount *mp,
 		struct xfs_dir2_data_entry *dep);
+uint8_t xfs_dir2_data_get_ftype(struct xfs_mount *mp,
+		struct xfs_dir2_data_entry *dep);
+void xfs_dir2_data_put_ftype(struct xfs_mount *mp,
+		struct xfs_dir2_data_entry *dep, uint8_t ftype);
 
 #ifdef DEBUG
 extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b5ac27442f9a..db1a82972d9e 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -319,7 +319,7 @@ xfs_dir2_block_to_sf(
 			xfs_dir2_sf_put_ino(mp, sfp, sfep,
 					      be64_to_cpu(dep->inumber));
 			xfs_dir2_sf_put_ftype(mp, sfep,
-					dp->d_ops->data_get_ftype(dep));
+					xfs_dir2_data_get_ftype(mp, dep));
 
 			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 		}
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 5d945219a735..9540ac7f2dfe 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -203,7 +203,7 @@ xfs_dir2_block_getdents(
 		cook = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, offset);
 
 		ctx->pos = cook & 0x7fffffff;
-		filetype = dp->d_ops->data_get_ftype(dep);
+		filetype = xfs_dir2_data_get_ftype(dp->i_mount, dep);
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
@@ -458,7 +458,7 @@ xfs_dir2_leaf_getdents(
 
 		dep = bp->b_addr + offset;
 		length = xfs_dir2_data_entsize(mp, dep->namelen);
-		filetype = dp->d_ops->data_get_ftype(dep);
+		filetype = xfs_dir2_data_get_ftype(mp, dep);
 
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
 		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
-- 
2.20.1

