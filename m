Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F002C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D78E206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XZSeqLcp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfKGS0D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:26:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44292 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfKGS0D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:26:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4P1OECYR1Q7qqMTMTppOOjPtyfQSCzuEpYIX+F4A3VM=; b=XZSeqLcpyk2hbJLhdlV1p6Fdto
        7HEKqFHlDzB3w0SGFJ410KW1+9/KwmySx8FVfdDUCA7Ti465wddpiQCa7dwrAyeIrV2iADwiIPtXh
        zlOpiFlrXP9lqyHhJG0niOebUAWWxF9HCyDieydMUkLseggYEQEawxMMjYuzwfw4qHnit1GCaODEc
        LzFmcFrsbQDV8tWrWW2NbYF6G8jgw38i51W4D8omVSECpcX07B5ARDXsAkI5sK4hon7I9pyiXCPMX
        434xXTFBgd1SFXYMMIyyWgI7HVKezoDcUF/6kSgwwaxT5iWErBUmzjA/9g3eVebyBRnvQhSX7HTS+
        J4TpGZGQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTr-0004Ue-0i; Thu, 07 Nov 2019 18:26:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 42/46] xfs: devirtualize ->data_bestfree_p
Date:   Thu,  7 Nov 2019 19:24:06 +0100
Message-Id: <20191107182410.12660-43-hch@lst.de>
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

Replace the ->data_bestfree_p dir ops method with a directly called
xfs_dir2_data_bestfree_p helper that takes care of the differences
between the v4 and v5 on-disk format.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.c  | 15 ---------------
 fs/xfs/libxfs/xfs_dir2.h       |  3 ---
 fs/xfs/libxfs/xfs_dir2_block.c |  6 +++---
 fs/xfs/libxfs/xfs_dir2_data.c  | 23 ++++++++++++++++-------
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 11 ++++++-----
 fs/xfs/libxfs/xfs_dir2_node.c  |  6 +++---
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
 fs/xfs/scrub/dir.c             |  7 ++-----
 8 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index dd2389748672..b9f9fbf7eee2 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -56,34 +56,19 @@ xfs_dir3_data_put_ftype(
 	dep->name[dep->namelen] = type;
 }
 
-static struct xfs_dir2_data_free *
-xfs_dir2_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return hdr->bestfree;
-}
-
-static struct xfs_dir2_data_free *
-xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
-}
-
 static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_get_ftype = xfs_dir2_data_get_ftype,
 	.data_put_ftype = xfs_dir2_data_put_ftype,
-	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
-	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
-	.data_bestfree_p = xfs_dir3_data_bestfree_p,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 830c70a20761..b50273b2d970 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -35,8 +35,6 @@ struct xfs_dir_ops {
 	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
 	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
 				uint8_t ftype);
-	struct xfs_dir2_data_free *
-		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
 };
 
 extern const struct xfs_dir_ops *
@@ -81,7 +79,6 @@ extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_buf *bp);
 
 extern void xfs_dir2_data_freescan_int(struct xfs_mount *mp,
-		const struct xfs_dir_ops *ops,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
 extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 9529a000838f..62b3adb01210 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -172,7 +172,7 @@ xfs_dir2_block_need_space(
 	struct xfs_dir2_data_unused	*enddup = NULL;
 
 	*compact = 0;
-	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
 
 	/*
 	 * If there are stale entries we'll use one for the leaf.
@@ -1199,8 +1199,8 @@ xfs_dir2_sf_to_block(
 			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(offset);
 			xfs_dir2_data_log_unused(args, bp, dup);
 			xfs_dir2_data_freeinsert(hdr,
-						 dp->d_ops->data_bestfree_p(hdr),
-						 dup, &dummy);
+					xfs_dir2_data_bestfree_p(mp, hdr),
+					dup, &dummy);
 			offset += be16_to_cpu(dup->length);
 			continue;
 		}
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index c1a843f6a8da..6ed9396225e3 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -25,6 +25,16 @@ static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_unused *dup,
 		struct xfs_dir2_data_free **bf_ent);
 
+struct xfs_dir2_data_free *
+xfs_dir2_data_bestfree_p(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_data_hdr	*hdr)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
+	return hdr->bestfree;
+}
+
 /*
  * Pointer to an entry's tag word.
  */
@@ -121,7 +131,7 @@ __xfs_dir3_data_check(
 	/*
 	 * Account for zero bestfree entries.
 	 */
-	bf = ops->data_bestfree_p(hdr);
+	bf = xfs_dir2_data_bestfree_p(mp, hdr);
 	count = lastfree = freeseen = 0;
 	if (!bf[0].length) {
 		if (bf[0].offset)
@@ -581,12 +591,11 @@ xfs_dir2_data_freeremove(
 void
 xfs_dir2_data_freescan_int(
 	struct xfs_mount		*mp,
-	const struct xfs_dir_ops	*ops,
 	struct xfs_dir2_data_hdr	*hdr,
 	int				*loghead)
 {
 	struct xfs_da_geometry		*geo = mp->m_dir_geo;
-	struct xfs_dir2_data_free	*bf = ops->data_bestfree_p(hdr);
+	struct xfs_dir2_data_free	*bf = xfs_dir2_data_bestfree_p(mp, hdr);
 	void				*addr = hdr;
 	unsigned int			offset = geo->data_entry_offset;
 	unsigned int			end;
@@ -633,7 +642,7 @@ xfs_dir2_data_freescan(
 	struct xfs_dir2_data_hdr *hdr,
 	int			*loghead)
 {
-	return xfs_dir2_data_freescan_int(dp->i_mount, dp->d_ops, hdr, loghead);
+	return xfs_dir2_data_freescan_int(dp->i_mount, hdr, loghead);
 }
 
 /*
@@ -683,7 +692,7 @@ xfs_dir3_data_init(
 	} else
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 
-	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf = xfs_dir2_data_bestfree_p(mp, hdr);
 	bf[0].offset = cpu_to_be16(geo->data_entry_offset);
 	bf[0].length = cpu_to_be16(geo->blksize - geo->data_entry_offset);
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
@@ -841,7 +850,7 @@ xfs_dir2_data_make_free(
 	 * Previous and following entries are both free,
 	 * merge everything into a single free entry.
 	 */
-	bf = args->dp->d_ops->data_bestfree_p(hdr);
+	bf = xfs_dir2_data_bestfree_p(args->dp->i_mount, hdr);
 	if (prevdup && postdup) {
 		xfs_dir2_data_free_t	*dfp2;	/* another bestfree pointer */
 
@@ -1032,7 +1041,7 @@ xfs_dir2_data_use_free(
 	 * Look up the entry in the bestfree table.
 	 */
 	oldlen = be16_to_cpu(dup->length);
-	bf = args->dp->d_ops->data_bestfree_p(hdr);
+	bf = xfs_dir2_data_bestfree_p(args->dp->i_mount, hdr);
 	dfp = xfs_dir2_data_freefind(hdr, bf, dup);
 	ASSERT(dfp || oldlen <= be16_to_cpu(bf[2].length));
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 2b327d1937f4..7fa485cd0158 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -425,7 +425,7 @@ xfs_dir2_block_to_leaf(
 	xfs_dir3_data_check(dp, dbp);
 	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
-	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
 
 	/*
 	 * Set the counts in the leaf header.
@@ -823,7 +823,7 @@ xfs_dir2_leaf_addname(
 		else
 			xfs_dir3_leaf_log_bests(args, lbp, use_block, use_block);
 		hdr = dbp->b_addr;
-		bf = dp->d_ops->data_bestfree_p(hdr);
+		bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
 		bestsp[use_block] = bf[0].length;
 		grown = 1;
 	} else {
@@ -839,7 +839,7 @@ xfs_dir2_leaf_addname(
 			return error;
 		}
 		hdr = dbp->b_addr;
-		bf = dp->d_ops->data_bestfree_p(hdr);
+		bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
 		grown = 0;
 	}
 	/*
@@ -1376,7 +1376,7 @@ xfs_dir2_leaf_removename(
 	leaf = lbp->b_addr;
 	hdr = dbp->b_addr;
 	xfs_dir3_data_check(dp, dbp);
-	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
 
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
@@ -1620,7 +1620,8 @@ xfs_dir2_leaf_trim_data(
 #ifdef DEBUG
 {
 	struct xfs_dir2_data_hdr *hdr = dbp->b_addr;
-	struct xfs_dir2_data_free *bf = dp->d_ops->data_bestfree_p(hdr);
+	struct xfs_dir2_data_free *bf =
+		xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 8c7af28cea80..c97217e57a27 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1317,7 +1317,7 @@ xfs_dir2_leafn_remove(
 	dbp = dblk->bp;
 	hdr = dbp->b_addr;
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr + off);
-	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
 	longest = be16_to_cpu(bf[0].length);
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(args, dbp, off,
@@ -1775,7 +1775,7 @@ xfs_dir2_node_add_datablk(
 	}
 
 	/* Update the freespace value for the new block in the table. */
-	bf = dp->d_ops->data_bestfree_p(dbp->b_addr);
+	bf = xfs_dir2_data_bestfree_p(mp, dbp->b_addr);
 	hdr->bests[*findex] = bf[0].length;
 
 	*dbpp = dbp;
@@ -1948,7 +1948,7 @@ xfs_dir2_node_addname_int(
 
 	/* setup for data block up now */
 	hdr = dbp->b_addr;
-	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
 	ASSERT(be16_to_cpu(bf[0].length) >= length);
 
 	/* Point to the existing unused space. */
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 54bbfdd6ad69..99cdc31eb8c9 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -57,6 +57,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 		struct xfs_buf *lbp, struct xfs_buf *dbp);
 
 /* xfs_dir2_data.c */
+struct xfs_dir2_data_free *xfs_dir2_data_bestfree_p(struct xfs_mount *mp,
+		struct xfs_dir2_data_hdr *hdr);
 __be16 *xfs_dir2_data_entry_tag_p(struct xfs_mount *mp,
 		struct xfs_dir2_data_entry *dep);
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 5e8599d0613c..f53ee6a9078a 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -327,7 +327,6 @@ xchk_directory_data_bestfree(
 	struct xfs_buf			*bp;
 	struct xfs_dir2_data_free	*bf;
 	struct xfs_mount		*mp = sc->mp;
-	const struct xfs_dir_ops	*d_ops;
 	u16				tag;
 	unsigned int			nr_bestfrees = 0;
 	unsigned int			nr_frees = 0;
@@ -337,8 +336,6 @@ xchk_directory_data_bestfree(
 	unsigned int			end;
 	int				error;
 
-	d_ops = sc->ip->d_ops;
-
 	if (is_block) {
 		/* dir block format */
 		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
@@ -358,7 +355,7 @@ xchk_directory_data_bestfree(
 		goto out_buf;
 
 	/* Do the bestfrees correspond to actual free space? */
-	bf = d_ops->data_bestfree_p(bp->b_addr);
+	bf = xfs_dir2_data_bestfree_p(mp, bp->b_addr);
 	smallest_bestfree = UINT_MAX;
 	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
 		offset = be16_to_cpu(dfp->offset);
@@ -465,7 +462,7 @@ xchk_directory_check_freesp(
 {
 	struct xfs_dir2_data_free	*dfp;
 
-	dfp = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
+	dfp = xfs_dir2_data_bestfree_p(sc->mp, dbp->b_addr);
 
 	if (len != be16_to_cpu(dfp->length))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
-- 
2.20.1

