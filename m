Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45725C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ACC9206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bZsl/tVy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfKGSZ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbfKGSZ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VP//r4AWSt+dVzIpghAvltIWJJ1sGUOtl2qgfGVq/Bs=; b=bZsl/tVyGx2ka8EF35br7eT45g
        RM59S9YmpAbjz3wZHDLvEIeRQUr7HCnqGYDWIYB2la4uo6nlnqEeximskjdhCmuM6txwXMEak22qo
        ZcdrP+fpmiBQRtX7NTx89E932UUzFnJxycJzyEgqAwPJ41dT7tDAjqCZnwVmTeITnRN3z+id6fn1P
        YxXo2ORUp7YN5WXbjOdK+AvZCE1R3PNnzbav3JKM3aBVnQpt6WnQOvDOmOu3WqPcGn+etfWWIRqmK
        R7lo5uovLYSecnm/vr1cwz+Os7V+kxUAWGcfUIOeaAc/gCR9z9lRkXsyBRbHJXo8sIR2Sdvif7ecz
        F8cbDjFg==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTl-0004Tp-TX; Thu, 07 Nov 2019 18:25:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 40/46] xfs: move the dir2 data block fixed offsets to struct xfs_da_geometry
Date:   Thu,  7 Nov 2019 19:24:04 +0100
Message-Id: <20191107182410.12660-41-hch@lst.de>
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

Move the data block fixed offsets towards our structure for dir/attr
geometry parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h   |  3 +++
 fs/xfs/libxfs/xfs_da_format.c  | 15 ---------------
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++++
 fs/xfs/libxfs/xfs_dir2.h       |  3 ---
 fs/xfs/libxfs/xfs_dir2_block.c |  5 +++--
 fs/xfs/libxfs/xfs_dir2_data.c  | 25 ++++++++++++-------------
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 22 ++++++++++++----------
 fs/xfs/libxfs/xfs_dir2_node.c  | 24 +++++++++++-------------
 fs/xfs/libxfs/xfs_dir2_sf.c    | 16 +++++-----------
 fs/xfs/scrub/dir.c             | 15 ++++++++-------
 fs/xfs/xfs_dir2_readdir.c      | 10 +++++-----
 11 files changed, 67 insertions(+), 79 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 40110acf9f8a..4ac2cc87c28f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -32,6 +32,9 @@ struct xfs_da_geometry {
 	unsigned int	free_hdr_size;	/* dir2 free header size */
 	unsigned int	free_max_bests;	/* # of bests entries in dir2 free */
 	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
+
+	xfs_dir2_data_aoff_t data_first_offset;
+	size_t		data_entry_offset;
 };
 
 /*========================================================================
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 483f4ab6abb8..0e35e613fbf3 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -105,33 +105,18 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_get_ftype = xfs_dir2_data_get_ftype,
 	.data_put_ftype = xfs_dir2_data_put_ftype,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
-
-	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR2_DATA_ENTSIZE(1) +
-				XFS_DIR2_DATA_ENTSIZE(2),
-	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
-
-	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1) +
-				XFS_DIR3_DATA_ENTSIZE(2),
-	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
 	.data_bestfree_p = xfs_dir3_data_bestfree_p,
-
-	.data_first_offset =  sizeof(struct xfs_dir3_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1) +
-				XFS_DIR3_DATA_ENTSIZE(2),
-	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 77a297e7d91c..eccffe7a5ae0 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -126,16 +126,24 @@ xfs_da_mount(
 		dageo->node_hdr_size = sizeof(struct xfs_da3_node_hdr);
 		dageo->leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr);
 		dageo->free_hdr_size = sizeof(struct xfs_dir3_free_hdr);
+		dageo->data_entry_offset =
+				sizeof(struct xfs_dir3_data_hdr);
 	} else {
 		dageo->node_hdr_size = sizeof(struct xfs_da_node_hdr);
 		dageo->leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr);
 		dageo->free_hdr_size = sizeof(struct xfs_dir2_free_hdr);
+		dageo->data_entry_offset =
+				sizeof(struct xfs_dir2_data_hdr);
 	}
 	dageo->leaf_max_ents = (dageo->blksize - dageo->leaf_hdr_size) /
 			sizeof(struct xfs_dir2_leaf_entry);
 	dageo->free_max_bests = (dageo->blksize - dageo->free_hdr_size) /
 			sizeof(xfs_dir2_data_off_t);
 
+	dageo->data_first_offset = dageo->data_entry_offset +
+			xfs_dir2_data_entsize(mp, 1) +
+			xfs_dir2_data_entsize(mp, 2);
+
 	/*
 	 * Now we've set up the block conversion variables, we can calculate the
 	 * segment block constants using the geometry structure.
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 3f46954e9370..830c70a20761 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -37,9 +37,6 @@ struct xfs_dir_ops {
 				uint8_t ftype);
 	struct xfs_dir2_data_free *
 		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
-
-	xfs_dir2_data_aoff_t data_first_offset;
-	size_t	data_entry_offset;
 };
 
 extern const struct xfs_dir_ops *
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 35eda4d18cd8..9529a000838f 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -937,7 +937,7 @@ xfs_dir2_leaf_to_block(
 	while (dp->i_d.di_size > args->geo->blksize) {
 		int hdrsz;
 
-		hdrsz = dp->d_ops->data_entry_offset;
+		hdrsz = args->geo->data_entry_offset;
 		bestsp = xfs_dir2_leaf_bests_p(ltp);
 		if (be16_to_cpu(bestsp[be32_to_cpu(ltp->bestcount) - 1]) ==
 					    args->geo->blksize - hdrsz) {
@@ -1045,6 +1045,7 @@ xfs_dir2_sf_to_block(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
+	struct xfs_da_geometry	*geo = args->geo;
 	xfs_dir2_db_t		blkno;		/* dir-relative block # (0) */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
@@ -1059,7 +1060,7 @@ xfs_dir2_sf_to_block(
 	int			needlog;	/* need to log block header */
 	int			needscan;	/* need to scan block freespc */
 	int			newoffset;	/* offset from current entry */
-	unsigned int		offset = dp->d_ops->data_entry_offset;
+	unsigned int		offset = geo->data_entry_offset;
 	xfs_dir2_sf_entry_t	*sfep;		/* sf entry pointer */
 	xfs_dir2_sf_hdr_t	*oldsfp;	/* old shortform header  */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform header  */
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 3504b230ba1d..c1a843f6a8da 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -45,11 +45,10 @@ xfs_dir2_data_entry_tag_p(
  */
 static inline unsigned int
 xfs_dir2_data_max_leaf_entries(
-	const struct xfs_dir_ops	*ops,
 	struct xfs_da_geometry		*geo)
 {
 	return (geo->blksize - sizeof(struct xfs_dir2_block_tail) -
-		ops->data_entry_offset) /
+		geo->data_entry_offset) /
 			sizeof(struct xfs_dir2_leaf_entry);
 }
 
@@ -97,7 +96,7 @@ __xfs_dir3_data_check(
 		return __this_address;
 
 	hdr = bp->b_addr;
-	offset = ops->data_entry_offset;
+	offset = geo->data_entry_offset;
 
 	switch (hdr->magic) {
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
@@ -106,7 +105,7 @@ __xfs_dir3_data_check(
 		lep = xfs_dir2_block_leaf_p(btp);
 
 		if (be32_to_cpu(btp->count) >=
-		    xfs_dir2_data_max_leaf_entries(ops, geo))
+		    xfs_dir2_data_max_leaf_entries(geo))
 			return __this_address;
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
@@ -586,9 +585,10 @@ xfs_dir2_data_freescan_int(
 	struct xfs_dir2_data_hdr	*hdr,
 	int				*loghead)
 {
+	struct xfs_da_geometry		*geo = mp->m_dir_geo;
 	struct xfs_dir2_data_free	*bf = ops->data_bestfree_p(hdr);
 	void				*addr = hdr;
-	unsigned int			offset = ops->data_entry_offset;
+	unsigned int			offset = geo->data_entry_offset;
 	unsigned int			end;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
@@ -602,7 +602,7 @@ xfs_dir2_data_freescan_int(
 	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
 	*loghead = 1;
 
-	end = xfs_dir3_data_end_offset(mp->m_dir_geo, addr);
+	end = xfs_dir3_data_end_offset(geo, addr);
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = addr + offset;
 		struct xfs_dir2_data_entry	*dep = addr + offset;
@@ -649,6 +649,7 @@ xfs_dir3_data_init(
 	struct xfs_trans		*tp = args->trans;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_da_geometry		*geo = args->geo;
 	struct xfs_buf			*bp;
 	struct xfs_dir2_data_hdr	*hdr;
 	struct xfs_dir2_data_unused	*dup;
@@ -683,9 +684,8 @@ xfs_dir3_data_init(
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 
 	bf = dp->d_ops->data_bestfree_p(hdr);
-	bf[0].offset = cpu_to_be16(dp->d_ops->data_entry_offset);
-	bf[0].length =
-		cpu_to_be16(args->geo->blksize - dp->d_ops->data_entry_offset);
+	bf[0].offset = cpu_to_be16(geo->data_entry_offset);
+	bf[0].length = cpu_to_be16(geo->blksize - geo->data_entry_offset);
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
 		bf[i].length = 0;
 		bf[i].offset = 0;
@@ -694,7 +694,7 @@ xfs_dir3_data_init(
 	/*
 	 * Set up an unused entry for the block's body.
 	 */
-	dup = bp->b_addr + dp->d_ops->data_entry_offset;
+	dup = bp->b_addr + geo->data_entry_offset;
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 	dup->length = bf[0].length;
 	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)hdr);
@@ -747,8 +747,7 @@ xfs_dir2_data_log_header(
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 #endif
 
-	xfs_trans_log_buf(args->trans, bp, 0,
-			  args->dp->d_ops->data_entry_offset - 1);
+	xfs_trans_log_buf(args->trans, bp, 0, args->geo->data_entry_offset - 1);
 }
 
 /*
@@ -816,7 +815,7 @@ xfs_dir2_data_make_free(
 	 * If this isn't the start of the block, then back up to
 	 * the previous entry and see if it's free.
 	 */
-	if (offset > args->dp->d_ops->data_entry_offset) {
+	if (offset > args->geo->data_entry_offset) {
 		__be16			*tagp;	/* tag just before us */
 
 		tagp = (__be16 *)((char *)hdr + offset) - 1;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 4b6d590c5856..2b327d1937f4 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1343,6 +1343,7 @@ int						/* error */
 xfs_dir2_leaf_removename(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
+	struct xfs_da_geometry	*geo = args->geo;
 	__be16			*bestsp;	/* leaf block best freespace */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_db_t		db;		/* data block number */
@@ -1381,12 +1382,12 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
+	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
-	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
+	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
 		xfs_buf_corruption_error(lbp);
@@ -1430,8 +1431,8 @@ xfs_dir2_leaf_removename(
 	 * If the data block is now empty then get rid of the data block.
 	 */
 	if (be16_to_cpu(bf[0].length) ==
-			args->geo->blksize - dp->d_ops->data_entry_offset) {
-		ASSERT(db != args->geo->datablk);
+	    geo->blksize - geo->data_entry_offset) {
+		ASSERT(db != geo->datablk);
 		if ((error = xfs_dir2_shrink_inode(args, db, dbp))) {
 			/*
 			 * Nope, can't get rid of it because it caused
@@ -1473,7 +1474,7 @@ xfs_dir2_leaf_removename(
 	/*
 	 * If the data block was not the first one, drop it.
 	 */
-	else if (db != args->geo->datablk)
+	else if (db != geo->datablk)
 		dbp = NULL;
 
 	xfs_dir3_leaf_check(dp, lbp);
@@ -1594,6 +1595,7 @@ xfs_dir2_leaf_trim_data(
 	struct xfs_buf		*lbp,		/* leaf buffer */
 	xfs_dir2_db_t		db)		/* data block number */
 {
+	struct xfs_da_geometry	*geo = args->geo;
 	__be16			*bestsp;	/* leaf bests table */
 	struct xfs_buf		*dbp;		/* data block buffer */
 	xfs_inode_t		*dp;		/* incore directory inode */
@@ -1607,13 +1609,13 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(args->geo, db),
-				   -1, &dbp);
+	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(geo, db), -1,
+				   &dbp);
 	if (error)
 		return error;
 
 	leaf = lbp->b_addr;
-	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
+	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 
 #ifdef DEBUG
 {
@@ -1623,7 +1625,7 @@ xfs_dir2_leaf_trim_data(
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
 	ASSERT(be16_to_cpu(bf[0].length) ==
-	       args->geo->blksize - dp->d_ops->data_entry_offset);
+	       geo->blksize - geo->data_entry_offset);
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
 }
 #endif
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 00f3440bcd83..8c7af28cea80 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1263,6 +1263,7 @@ xfs_dir2_leafn_remove(
 	xfs_da_state_blk_t	*dblk,		/* data block */
 	int			*rval)		/* resulting block needs join */
 {
+	struct xfs_da_geometry	*geo = args->geo;
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_db_t		db;		/* data block number */
 	struct xfs_buf		*dbp;		/* data block buffer */
@@ -1293,9 +1294,9 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
+	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
 	ASSERT(dblk->index == off);
 
 	/*
@@ -1346,9 +1347,8 @@ xfs_dir2_leafn_remove(
 		 * Convert the data block number to a free block,
 		 * read in the free block.
 		 */
-		fdb = xfs_dir2_db_to_fdb(args->geo, db);
-		error = xfs_dir2_free_read(tp, dp,
-					   xfs_dir2_db_to_da(args->geo, fdb),
+		fdb = xfs_dir2_db_to_fdb(geo, db);
+		error = xfs_dir2_free_read(tp, dp, xfs_dir2_db_to_da(geo, fdb),
 					   &fbp);
 		if (error)
 			return error;
@@ -1358,22 +1358,20 @@ xfs_dir2_leafn_remove(
 		struct xfs_dir3_icfree_hdr freehdr;
 
 		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
-		ASSERT(freehdr.firstdb == args->geo->free_max_bests *
-			(fdb - xfs_dir2_byte_to_db(args->geo,
-						   XFS_DIR2_FREE_OFFSET)));
+		ASSERT(freehdr.firstdb == geo->free_max_bests *
+			(fdb - xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET)));
 	}
 #endif
 		/*
 		 * Calculate which entry we need to fix.
 		 */
-		findex = xfs_dir2_db_to_fdindex(args->geo, db);
+		findex = xfs_dir2_db_to_fdindex(geo, db);
 		longest = be16_to_cpu(bf[0].length);
 		/*
 		 * If the data block is now empty we can get rid of it
 		 * (usually).
 		 */
-		if (longest == args->geo->blksize -
-			       dp->d_ops->data_entry_offset) {
+		if (longest == geo->blksize - geo->data_entry_offset) {
 			/*
 			 * Try to punch out the data block.
 			 */
@@ -1405,9 +1403,9 @@ xfs_dir2_leafn_remove(
 	 * Return indication of whether this leaf block is empty enough
 	 * to justify trying to join it with a neighbor.
 	 */
-	*rval = (args->geo->leaf_hdr_size +
+	*rval = (geo->leaf_hdr_size +
 		 (uint)sizeof(leafhdr.ents) * (leafhdr.count - leafhdr.stale)) <
-		args->geo->magicpct;
+		geo->magicpct;
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index a41715c9b061..b5ac27442f9a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -266,7 +266,7 @@ xfs_dir2_block_to_sf(
 	int			logflags;	/* inode logging flags */
 	struct xfs_dir2_sf_entry *sfep;		/* shortform entry */
 	struct xfs_dir2_sf_hdr	*sfp;		/* shortform directory header */
-	unsigned int		offset = dp->d_ops->data_entry_offset;
+	unsigned int		offset = args->geo->data_entry_offset;
 	unsigned int		end;
 
 	trace_xfs_dir2_block_to_sf(args);
@@ -538,7 +538,7 @@ xfs_dir2_sf_addname_hard(
 	 * to insert the new entry.
 	 * If it's going to end up at the end then oldsfep will point there.
 	 */
-	for (offset = dp->d_ops->data_first_offset,
+	for (offset = args->geo->data_first_offset,
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
 	      add_datasize = xfs_dir2_data_entsize(mp, args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
@@ -616,7 +616,7 @@ xfs_dir2_sf_addname_pick(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = xfs_dir2_data_entsize(mp, args->namelen);
-	offset = dp->d_ops->data_first_offset;
+	offset = args->geo->data_first_offset;
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
 	/*
@@ -681,7 +681,7 @@ xfs_dir2_sf_check(
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	offset = dp->d_ops->data_first_offset;
+	offset = args->geo->data_first_offset;
 	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
@@ -714,7 +714,6 @@ xfs_dir2_sf_verify(
 	struct xfs_dir2_sf_entry	*sfep;
 	struct xfs_dir2_sf_entry	*next_sfep;
 	char				*endp;
-	const struct xfs_dir_ops	*dops;
 	struct xfs_ifork		*ifp;
 	xfs_ino_t			ino;
 	int				i;
@@ -725,11 +724,6 @@ xfs_dir2_sf_verify(
 	uint8_t				filetype;
 
 	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
-	/*
-	 * xfs_iread calls us before xfs_setup_inode sets up ip->d_ops,
-	 * so we can only trust the mountpoint to have the right pointer.
-	 */
-	dops = xfs_dir_get_ops(mp, NULL);
 
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
@@ -750,7 +744,7 @@ xfs_dir2_sf_verify(
 	error = xfs_dir_ino_validate(mp, ino);
 	if (error)
 		return __this_address;
-	offset = dops->data_first_offset;
+	offset = mp->m_dir_geo->data_first_offset;
 
 	/* Check all reported entries */
 	sfep = xfs_dir2_sf_firstentry(sfp);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 2b9822ead835..5e8599d0613c 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -184,6 +184,7 @@ xchk_dir_rec(
 	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
 	struct xfs_mount		*mp = ds->state->mp;
 	struct xfs_inode		*dp = ds->dargs.dp;
+	struct xfs_da_geometry		*geo = mp->m_dir_geo;
 	struct xfs_dir2_data_entry	*dent;
 	struct xfs_buf			*bp;
 	struct xfs_dir2_leaf_entry	*ent;
@@ -217,11 +218,11 @@ xchk_dir_rec(
 		return 0;
 
 	/* Find the directory entry's location. */
-	db = xfs_dir2_dataptr_to_db(mp->m_dir_geo, ptr);
-	off = xfs_dir2_dataptr_to_off(mp->m_dir_geo, ptr);
-	rec_bno = xfs_dir2_db_to_da(mp->m_dir_geo, db);
+	db = xfs_dir2_dataptr_to_db(geo, ptr);
+	off = xfs_dir2_dataptr_to_off(geo, ptr);
+	rec_bno = xfs_dir2_db_to_da(geo, db);
 
-	if (rec_bno >= mp->m_dir_geo->leafblk) {
+	if (rec_bno >= geo->leafblk) {
 		xchk_da_set_corrupt(ds, level);
 		goto out;
 	}
@@ -241,8 +242,8 @@ xchk_dir_rec(
 	dent = bp->b_addr + off;
 
 	/* Make sure we got a real directory entry. */
-	offset = mp->m_dir_inode_ops->data_entry_offset;
-	end = xfs_dir3_data_end_offset(mp->m_dir_geo, bp->b_addr);
+	offset = geo->data_entry_offset;
+	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
 	if (!end) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
@@ -389,7 +390,7 @@ xchk_directory_data_bestfree(
 	}
 
 	/* Make sure the bestfrees are actually the best free spaces. */
-	offset = d_ops->data_entry_offset;
+	offset = mp->m_dir_geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(mp->m_dir_geo, bp->b_addr);
 
 	/* Iterate the entries, stopping when we hit or go past the end. */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index a52f0931b6af..5d945219a735 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -75,9 +75,9 @@ xfs_dir2_sf_getdents(
 	 * entries for "." and "..".
 	 */
 	dot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
-			dp->d_ops->data_entry_offset);
+			geo->data_entry_offset);
 	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
-			dp->d_ops->data_entry_offset +
+			geo->data_entry_offset +
 			xfs_dir2_data_entsize(mp, sizeof(".") - 1));
 
 	/*
@@ -174,7 +174,7 @@ xfs_dir2_block_getdents(
 	 * Loop over the data portion of the block.
 	 * Each object is a real entry (dep) or an unused one (dup).
 	 */
-	offset = dp->d_ops->data_entry_offset;
+	offset = geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
@@ -403,13 +403,13 @@ xfs_dir2_leaf_getdents(
 			/*
 			 * Find our position in the block.
 			 */
-			offset = dp->d_ops->data_entry_offset;
+			offset = geo->data_entry_offset;
 			byteoff = xfs_dir2_byte_to_off(geo, curoff);
 			/*
 			 * Skip past the header.
 			 */
 			if (byteoff == 0)
-				curoff += dp->d_ops->data_entry_offset;
+				curoff += geo->data_entry_offset;
 			/*
 			 * Skip past entries until we reach our offset.
 			 */
-- 
2.20.1

