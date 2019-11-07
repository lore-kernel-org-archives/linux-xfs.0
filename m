Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48127C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18A39214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UVUyjlc7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfKGSZZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WuajrPLX6cBZQxsfwNfh3i2Sbj2C+ZBe6vHW3WXwPQM=; b=UVUyjlc7DP4oXuz2t6OLWmHzy
        TFmJSaavUSGN++h1zF9xb49k1hC2Pzekc7yydp86eoDCRdehFyqTgNRvECWARZrAQQd45gj4xgeNv
        S3XrX9vkn+vJFoMyhTEglZPlLxE17ghcayuq+NeR/e50T2Hd4FZ8u6i8U7O5kZGlM+zh3kjhuly2P
        9RjdHYApvxUORglmscjbOSGsKbZ8qK3AoyY79V2Cr4kW9soIxrJ6NcGwxHLqj/PyYiavUgYVn3/cT
        zCUvbJO4tflNgkJww5roKMazrkiDRTLONgNyqkDfV86Sfojp+Fa3PNsd2aQVg/FnX37GS3x9V184z
        apQ4wsEtQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTE-0004O9-S8
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 27/46] xfs: remove the ->data_dot_entry_p and ->data_dotdot_entry_p methods
Date:   Thu,  7 Nov 2019 19:23:51 +0100
Message-Id: <20191107182410.12660-28-hch@lst.de>
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

The only user of the ->data_dot_entry_p and ->data_dotdot_entry_p
methods is the xfs_dir2_sf_to_block function that builds block format
directorys from a short form directory.  It already uses pointer
arithmetics with a offset variable to do so for the real entries in
the directory, so switch the generation of the . and .. entries to
the same scheme, and clean up some of the later pointer arithmetics
to use bp->b_addr directly as well and avoid some casts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c  | 52 --------------------------------
 fs/xfs/libxfs/xfs_dir2.h       |  4 ---
 fs/xfs/libxfs/xfs_dir2_block.c | 54 ++++++++++++++++------------------
 3 files changed, 26 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 7b783b11790d..711faff4aea2 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -111,52 +111,6 @@ xfs_dir3_data_entry_tag_p(
 		xfs_dir3_data_entsize(dep->namelen) - sizeof(__be16));
 }
 
-/*
- * location of . and .. in data space (always block 0)
- */
-static struct xfs_dir2_data_entry *
-xfs_dir2_data_dot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir2_data_dotdot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR2_DATA_ENTSIZE(1));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir2_ftype_data_dotdot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir3_data_dot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir3_data_dotdot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1));
-}
-
 static struct xfs_dir2_data_free *
 xfs_dir2_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 {
@@ -209,8 +163,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 				XFS_DIR2_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
-	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
-	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 };
@@ -227,8 +179,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
-	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
-	.data_dotdot_entry_p = xfs_dir2_ftype_data_dotdot_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 };
@@ -245,8 +195,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
 
-	.data_dot_entry_p = xfs_dir3_data_dot_entry_p,
-	.data_dotdot_entry_p = xfs_dir3_data_dotdot_entry_p,
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
 };
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 8b937993263d..8bfcf4c1b9c4 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -43,10 +43,6 @@ struct xfs_dir_ops {
 	xfs_dir2_data_aoff_t data_first_offset;
 	size_t	data_entry_offset;
 
-	struct xfs_dir2_data_entry *
-		(*data_dot_entry_p)(struct xfs_dir2_data_hdr *hdr);
-	struct xfs_dir2_data_entry *
-		(*data_dotdot_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_entry *
 		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_unused *
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 6bc82a02b228..e7719356829d 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1038,39 +1038,35 @@ xfs_dir2_leaf_to_block(
  */
 int						/* error */
 xfs_dir2_sf_to_block(
-	xfs_da_args_t		*args)		/* operation arguments */
+	struct xfs_da_args	*args)
 {
+	struct xfs_trans	*tp = args->trans;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
 	xfs_dir2_db_t		blkno;		/* dir-relative block # (0) */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
 	struct xfs_buf		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail pointer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
-	xfs_inode_t		*dp;		/* incore directory inode */
 	int			dummy;		/* trash */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry pointer */
 	int			endoffset;	/* end of data objects */
 	int			error;		/* error return value */
 	int			i;		/* index */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			needlog;	/* need to log block header */
 	int			needscan;	/* need to scan block freespc */
 	int			newoffset;	/* offset from current entry */
-	int			offset;		/* target block offset */
+	unsigned int		offset = dp->d_ops->data_entry_offset;
 	xfs_dir2_sf_entry_t	*sfep;		/* sf entry pointer */
 	xfs_dir2_sf_hdr_t	*oldsfp;	/* old shortform header  */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform header  */
 	__be16			*tagp;		/* end of data entry */
-	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_name		name;
-	struct xfs_ifork	*ifp;
 
 	trace_xfs_dir2_sf_to_block(args);
 
-	dp = args->dp;
-	tp = args->trans;
-	mp = dp->i_mount;
-	ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
 	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 
@@ -1139,35 +1135,37 @@ xfs_dir2_sf_to_block(
 			be16_to_cpu(dup->length), &needlog, &needscan);
 	if (error)
 		goto out_free;
+
 	/*
 	 * Create entry for .
 	 */
-	dep = dp->d_ops->data_dot_entry_p(hdr);
+	dep = bp->b_addr + offset;
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
 	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
-	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	*tagp = cpu_to_be16(offset);
 	xfs_dir2_data_log_entry(args, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
-	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
-				(char *)dep - (char *)hdr));
+	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(offset));
+	offset += dp->d_ops->data_entsize(dep->namelen);
+
 	/*
 	 * Create entry for ..
 	 */
-	dep = dp->d_ops->data_dotdot_entry_p(hdr);
+	dep = bp->b_addr + offset;
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
 	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
-	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	*tagp = cpu_to_be16(offset);
 	xfs_dir2_data_log_entry(args, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
-	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
-				(char *)dep - (char *)hdr));
-	offset = dp->d_ops->data_first_offset;
+	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(offset));
+	offset += dp->d_ops->data_entsize(dep->namelen);
+
 	/*
 	 * Loop over existing entries, stuff them in.
 	 */
@@ -1176,6 +1174,7 @@ xfs_dir2_sf_to_block(
 		sfep = NULL;
 	else
 		sfep = xfs_dir2_sf_firstentry(sfp);
+
 	/*
 	 * Need to preserve the existing offset values in the sf directory.
 	 * Insert holes (unused entries) where necessary.
@@ -1192,11 +1191,10 @@ xfs_dir2_sf_to_block(
 		 * There should be a hole here, make one.
 		 */
 		if (offset < newoffset) {
-			dup = (xfs_dir2_data_unused_t *)((char *)hdr + offset);
+			dup = bp->b_addr + offset;
 			dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 			dup->length = cpu_to_be16(newoffset - offset);
-			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(
-				((char *)dup - (char *)hdr));
+			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(offset);
 			xfs_dir2_data_log_unused(args, bp, dup);
 			xfs_dir2_data_freeinsert(hdr,
 						 dp->d_ops->data_bestfree_p(hdr),
@@ -1207,20 +1205,20 @@ xfs_dir2_sf_to_block(
 		/*
 		 * Copy a real entry.
 		 */
-		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
+		dep = bp->b_addr + newoffset;
 		dep->inumber = cpu_to_be64(xfs_dir2_sf_get_ino(mp, sfp, sfep));
 		dep->namelen = sfep->namelen;
 		dp->d_ops->data_put_ftype(dep, xfs_dir2_sf_get_ftype(mp, sfep));
 		memcpy(dep->name, sfep->name, dep->namelen);
 		tagp = dp->d_ops->data_entry_tag_p(dep);
-		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+		*tagp = cpu_to_be16(newoffset);
 		xfs_dir2_data_log_entry(args, bp, dep);
 		name.name = sfep->name;
 		name.len = sfep->namelen;
-		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
-							hashname(&name));
-		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
-						 (char *)dep - (char *)hdr));
+		blp[2 + i].hashval =
+			cpu_to_be32(mp->m_dirnameops->hashname(&name));
+		blp[2 + i].address =
+			cpu_to_be32(xfs_dir2_byte_to_dataptr(newoffset));
 		offset = (int)((char *)(tagp + 1) - (char *)hdr);
 		if (++i == sfp->count)
 			sfep = NULL;
-- 
2.20.1

