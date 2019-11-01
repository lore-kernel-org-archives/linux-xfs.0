Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D39FCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 348862085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fo31yT+a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfKAWJJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:09:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53748 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAWJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q+NkVbBImBA0js2zCwywMfoYIen9Wd4QfsS7DhT5PK4=; b=Fo31yT+azZ6XWbhVJPsFSIUBJ
        Xb32j6O0qybUJkYPLtwjFKyAC+yWtqh97eBgphLjoNcJKl0SG0N/SvElm7+7AExJCZkmxOoMsDBWA
        tK3kDhXibfGJQpb6+deWOQ/C84Ehj28v37RbHkuDhRpoxg1BJJ66aLBO9+fv02solvG4qSzBJzFJ9
        E2oMboGlk1W1vJk+qY7V/Xgzha2v+Rx0l9BhCg1unlJePsbcBl18slAdnRSPc6Zpf3TcfhZJb7b/B
        YOLQGLUQay9WMfW6+ASHo9TPnIaXG9BEA+A81vZZow+RrAdlbDR7mGOFxBl+VLXnHIDClS/3Z1Ex7
        nZUxSFUsQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf6T-00060w-GR
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:09:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 19/34] xfs: devirtualize ->sf_get_parent_ino and ->sf_put_parent_ino
Date:   Fri,  1 Nov 2019 15:07:04 -0700
Message-Id: <20191101220719.29100-20-hch@lst.de>
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

The parent inode handling is the same for all directory format variants,
just use direct calls instead of going through a pointless indirect
call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 38886b9c7b48..2ee9fdd182e1 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1163,7 +1163,7 @@ xfs_dir2_sf_to_block(
 	 * Create entry for ..
 	 */
 	dep = dp->d_ops->data_dotdot_entry_p(hdr);
-	dep->inumber = cpu_to_be64(dp->d_ops->sf_get_parent_ino(sfp));
+	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
 	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index b73cf38c6969..d5104fdb8543 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -135,6 +135,8 @@ extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, struct xfs_buf **bpp);
 
 /* xfs_dir2_sf.c */
+xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *hdr);
+void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *hdr, xfs_ino_t ino);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
 extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index ae16ca7c422a..1d7c26d0157c 100644
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
@@ -590,7 +590,7 @@ xfs_dir2_sf_check(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	offset = dp->d_ops->data_first_offset;
-	ino = dp->d_ops->sf_get_parent_ino(sfp);
+	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
@@ -653,7 +653,7 @@ xfs_dir2_sf_verify(
 	endp = (char *)sfp + size;
 
 	/* Check .. entry */
-	ino = dops->sf_get_parent_ino(sfp);
+	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 	error = xfs_dir_ino_validate(mp, ino);
 	if (error)
@@ -763,7 +763,7 @@ xfs_dir2_sf_create(
 	/*
 	 * Now can put in the inode number, since i8count is set.
 	 */
-	dp->d_ops->sf_put_parent_ino(sfp, pino);
+	xfs_dir2_sf_put_parent_ino(sfp, pino);
 	sfp->count = 0;
 	dp->i_d.di_size = size;
 	xfs_dir2_sf_check(args);
@@ -818,7 +818,7 @@ xfs_dir2_sf_lookup(
 	 */
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
-		args->inumber = dp->d_ops->sf_get_parent_ino(sfp);
+		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
 		return -EEXIST;
@@ -1008,9 +1008,9 @@ xfs_dir2_sf_replace(
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
@@ -1116,7 +1116,7 @@ xfs_dir2_sf_toino4(
 	 */
 	sfp->count = oldsfp->count;
 	sfp->i8count = 0;
-	dp->d_ops->sf_put_parent_ino(sfp, dp->d_ops->sf_get_parent_ino(oldsfp));
+	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
 	/*
 	 * Copy the entries field by field.
 	 */
@@ -1189,7 +1189,7 @@ xfs_dir2_sf_toino8(
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

