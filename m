Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D867C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F6A2206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JE0uXz4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfKGSZH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:07 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7Epw9fzdZ6qFbPaxcu3IMTpL6zWVpePgLxbrJnMChDc=; b=JE0uXz4dTZxVzeXRv/vJc6LSxc
        0SKPbXUVD13zGUR4digsvFAAq/knzRh7u5/7HE8DZTpCpvW8JAh7cOwlRGyygziy7xOjBqiplzjOt
        YqqwdWLaCmh/SXf2IGWnel2Jy8zDzSRv2A+LwuaW1PXYPwdAA2L+jKkBh2PHfBildHFrmqUsLrDz2
        vrfPxVQ0HuwMDxnscK/qHFUm4SZ20aCA9aP3i5+eN+FsNmJIVbMWhd6bopqgyL/yIcH7FWP+BpeKC
        m69ZWUq5EhqXk0A1UAEwc77JfKeZq01FdnnyM+TcjszgF9FacgXK40MEPfunLR/pVyfTOY7CqHfwy
        505yErpw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSx-0003cn-34; Thu, 07 Nov 2019 18:25:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/46] xfs: devirtualize ->sf_get_parent_ino and ->sf_put_parent_ino
Date:   Thu,  7 Nov 2019 19:23:44 +0100
Message-Id: <20191107182410.12660-21-hch@lst.de>
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

The parent inode handling is the same for all directory format variants,
just use direct calls instead of going through a pointless indirect
call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.c  | 10 ++--------
 fs/xfs/libxfs/xfs_dir2.h       |  3 ---
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 20 ++++++++++----------
 fs/xfs/xfs_dir2_readdir.c      |  2 +-
 6 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 2b708b9fae1a..7858469c09e4 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -132,14 +132,14 @@ xfs_dir2_sf_put_ino(
 		put_unaligned_be32(ino, to);
 }
 
-static xfs_ino_t
+xfs_ino_t
 xfs_dir2_sf_get_parent_ino(
 	struct xfs_dir2_sf_hdr	*hdr)
 {
 	return xfs_dir2_sf_get_ino(hdr, hdr->parent);
 }
 
-static void
+void
 xfs_dir2_sf_put_parent_ino(
 	struct xfs_dir2_sf_hdr	*hdr,
 	xfs_ino_t		ino)
@@ -407,8 +407,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_put_ftype = xfs_dir2_sfe_put_ftype,
 	.sf_get_ino = xfs_dir2_sfe_get_ino,
 	.sf_put_ino = xfs_dir2_sfe_put_ino,
-	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
-	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
 
 	.data_entsize = xfs_dir2_data_entsize,
 	.data_get_ftype = xfs_dir2_data_get_ftype,
@@ -438,8 +436,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
 	.sf_get_ino = xfs_dir3_sfe_get_ino,
 	.sf_put_ino = xfs_dir3_sfe_put_ino,
-	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
-	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
 
 	.data_entsize = xfs_dir3_data_entsize,
 	.data_get_ftype = xfs_dir3_data_get_ftype,
@@ -469,8 +465,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
 	.sf_get_ino = xfs_dir3_sfe_get_ino,
 	.sf_put_ino = xfs_dir3_sfe_put_ino,
-	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
-	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
 
 	.data_entsize = xfs_dir3_data_entsize,
 	.data_get_ftype = xfs_dir3_data_get_ftype,
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index e302679d8c80..d3a0b8daab5f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -44,9 +44,6 @@ struct xfs_dir_ops {
 	void	(*sf_put_ino)(struct xfs_dir2_sf_hdr *hdr,
 			      struct xfs_dir2_sf_entry *sfep,
 			      xfs_ino_t ino);
-	xfs_ino_t (*sf_get_parent_ino)(struct xfs_dir2_sf_hdr *hdr);
-	void	(*sf_put_parent_ino)(struct xfs_dir2_sf_hdr *hdr,
-				     xfs_ino_t ino);
 
 	int	(*data_entsize)(int len);
 	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 065fe10a842b..bc47113b78e5 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1157,7 +1157,7 @@ xfs_dir2_sf_to_block(
 	 * Create entry for ..
 	 */
 	dep = dp->d_ops->data_dotdot_entry_p(hdr);
-	dep->inumber = cpu_to_be64(dp->d_ops->sf_get_parent_ino(sfp));
+	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
 	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 9128f7aae0be..bb50853d0988 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -145,6 +145,8 @@ extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, struct xfs_buf **bpp);
 
 /* xfs_dir2_sf.c */
+xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *hdr);
+void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *hdr, xfs_ino_t ino);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
 extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index d6b164a2fe57..c7ca25acdb18 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -125,7 +125,7 @@ xfs_dir2_block_sfsize(
 	 */
 	sfhp->count = count;
 	sfhp->i8count = i8count;
-	dp->d_ops->sf_put_parent_ino(sfhp, parent);
+	xfs_dir2_sf_put_parent_ino(sfhp, parent);
 	return size;
 }
 
@@ -204,7 +204,7 @@ xfs_dir2_block_to_sf(
 		else if (dep->namelen == 2 &&
 			 dep->name[0] == '.' && dep->name[1] == '.')
 			ASSERT(be64_to_cpu(dep->inumber) ==
-			       dp->d_ops->sf_get_parent_ino(sfp));
+			       xfs_dir2_sf_get_parent_ino(sfp));
 		/*
 		 * Normal entry, copy it into shortform.
 		 */
@@ -584,7 +584,7 @@ xfs_dir2_sf_check(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	offset = dp->d_ops->data_first_offset;
-	ino = dp->d_ops->sf_get_parent_ino(sfp);
+	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
@@ -647,7 +647,7 @@ xfs_dir2_sf_verify(
 	endp = (char *)sfp + size;
 
 	/* Check .. entry */
-	ino = dops->sf_get_parent_ino(sfp);
+	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 	error = xfs_dir_ino_validate(mp, ino);
 	if (error)
@@ -757,7 +757,7 @@ xfs_dir2_sf_create(
 	/*
 	 * Now can put in the inode number, since i8count is set.
 	 */
-	dp->d_ops->sf_put_parent_ino(sfp, pino);
+	xfs_dir2_sf_put_parent_ino(sfp, pino);
 	sfp->count = 0;
 	dp->i_d.di_size = size;
 	xfs_dir2_sf_check(args);
@@ -806,7 +806,7 @@ xfs_dir2_sf_lookup(
 	 */
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
-		args->inumber = dp->d_ops->sf_get_parent_ino(sfp);
+		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
 		return -EEXIST;
@@ -984,9 +984,9 @@ xfs_dir2_sf_replace(
 	 */
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
-		ino = dp->d_ops->sf_get_parent_ino(sfp);
+		ino = xfs_dir2_sf_get_parent_ino(sfp);
 		ASSERT(args->inumber != ino);
-		dp->d_ops->sf_put_parent_ino(sfp, args->inumber);
+		xfs_dir2_sf_put_parent_ino(sfp, args->inumber);
 	}
 	/*
 	 * Normal entry, look for the name.
@@ -1092,7 +1092,7 @@ xfs_dir2_sf_toino4(
 	 */
 	sfp->count = oldsfp->count;
 	sfp->i8count = 0;
-	dp->d_ops->sf_put_parent_ino(sfp, dp->d_ops->sf_get_parent_ino(oldsfp));
+	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
 	/*
 	 * Copy the entries field by field.
 	 */
@@ -1165,7 +1165,7 @@ xfs_dir2_sf_toino8(
 	 */
 	sfp->count = oldsfp->count;
 	sfp->i8count = 1;
-	dp->d_ops->sf_put_parent_ino(sfp, dp->d_ops->sf_get_parent_ino(oldsfp));
+	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
 	/*
 	 * Copy the entries field by field.
 	 */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index a0bec0931f3b..6f94d2a45174 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -92,7 +92,7 @@ xfs_dir2_sf_getdents(
 	 * Put .. entry unless we're starting past it.
 	 */
 	if (ctx->pos <= dotdot_offset) {
-		ino = dp->d_ops->sf_get_parent_ino(sfp);
+		ino = xfs_dir2_sf_get_parent_ino(sfp);
 		ctx->pos = dotdot_offset & 0x7fffffff;
 		if (!dir_emit(ctx, "..", 2, ino, DT_DIR))
 			return 0;
-- 
2.20.1

