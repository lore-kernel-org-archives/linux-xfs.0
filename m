Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3D6CA9ED0
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA792217D9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jdYMKVsn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfKAWJ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:09:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53810 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWJ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9G1zpI3E/BC/PWg6EC1Cl5+6onIAKI16FAG4KRDQL8M=; b=jdYMKVsnybfBb0QijrpZFdaf1
        oLylfmkTGlsBSU5sU+egmDURhE2iGvrghanApgYltvRQgLCsMfmarAqeQ+uhQD10YbTDAAz8sRSxq
        MsXe9f6OhxFce5gR4SyJ0qnBrVCpdFadTSbEA1ke8VruyLss6/VEPcUMQaf3tG+oCiuz8lHKmCAVI
        zBxTzpiejijZfV5LkZzsrZsXxONXwORBunNCXQEaFf+A/hHjYZZSo2UCLV6YEUotl7c06Y4JaAe8h
        JwzXSqfwZP3NDAbSYLFf2a8zNbMoLnUQDTPEVbMlBy5bWLY0ZrlgsOZ9v63q8r3tnVkcRNDl3OXGv
        MesuvXIAg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf7E-0006Di-T6
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:09:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 28/34] xfs: move the dir2 data block fixed offsets to struct xfs_da_geometry
Date:   Fri,  1 Nov 2019 15:07:13 -0700
Message-Id: <20191101220719.29100-29-hch@lst.de>
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

Move the data block fixed offsets towards our structure for dir/attr
geometry parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.h   |  5 +++++
 fs/xfs/libxfs/xfs_da_format.c  | 24 ------------------------
 fs/xfs/libxfs/xfs_dir2.c       |  9 +++++++++
 fs/xfs/libxfs/xfs_dir2.h       |  5 -----
 fs/xfs/libxfs/xfs_dir2_block.c | 11 ++++++-----
 fs/xfs/libxfs/xfs_dir2_data.c  | 18 +++++++++---------
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 22 ++++++++++++----------
 fs/xfs/libxfs/xfs_dir2_node.c  | 24 +++++++++++-------------
 fs/xfs/libxfs/xfs_dir2_sf.c    | 16 +++++-----------
 fs/xfs/scrub/dir.c             |  4 ++--
 fs/xfs/xfs_dir2_readdir.c      | 13 +++++--------
 11 files changed, 64 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index e3f4329ab882..a3333e7a084d 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -32,6 +32,11 @@ struct xfs_da_geometry {
 	int		free_hdr_size;	/* dir2 free header size */
 	unsigned int	free_max_bests;	/* # of bests entries in dir2 free */
 	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
+
+	xfs_dir2_data_aoff_t data_dot_offset;
+	xfs_dir2_data_aoff_t data_dotdot_offset;
+	xfs_dir2_data_aoff_t data_first_offset;
+	size_t		data_entry_offset;
 };
 
 /*========================================================================
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 9c247223326f..0e35e613fbf3 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -105,42 +105,18 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_get_ftype = xfs_dir2_data_get_ftype,
 	.data_put_ftype = xfs_dir2_data_put_ftype,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
-
-	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
-	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR2_DATA_ENTSIZE(1),
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
-	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
-	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1),
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
-	.data_dot_offset = sizeof(struct xfs_dir3_data_hdr),
-	.data_dotdot_offset = sizeof(struct xfs_dir3_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1),
-	.data_first_offset =  sizeof(struct xfs_dir3_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1) +
-				XFS_DIR3_DATA_ENTSIZE(2),
-	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 6c46893af17e..33a6e8aacdba 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -126,16 +126,25 @@ xfs_da_mount(
 		dageo->node_hdr_size = sizeof(struct xfs_da3_node_hdr);
 		dageo->leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr);
 		dageo->free_hdr_size = sizeof(struct xfs_dir3_free_hdr);
+		dageo->data_entry_offset = dageo->data_dot_offset =
+				sizeof(struct xfs_dir3_data_hdr);
 	} else {
 		dageo->node_hdr_size = sizeof(struct xfs_da_node_hdr);
 		dageo->leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr);
 		dageo->free_hdr_size = sizeof(struct xfs_dir2_free_hdr);
+		dageo->data_entry_offset = dageo->data_dot_offset =
+				sizeof(struct xfs_dir2_data_hdr);
 	}
 	dageo->leaf_max_ents = (dageo->blksize - dageo->leaf_hdr_size) /
 			sizeof(struct xfs_dir2_leaf_entry);
 	dageo->free_max_bests = (dageo->blksize - dageo->free_hdr_size) /
 			sizeof(xfs_dir2_data_off_t);
 
+	dageo->data_dotdot_offset = dageo->data_dot_offset +
+			xfs_dir2_data_entsize(mp, 1);
+	dageo->data_first_offset = dageo->data_dotdot_offset +
+			xfs_dir2_data_entsize(mp, 2);
+
 	/*
 	 * Now we've set up the block conversion variables, we can calculate the
 	 * segment block constants using the geometry structure.
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 8397e35d6b82..11dba3874da0 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -37,11 +37,6 @@ struct xfs_dir_ops {
 				uint8_t ftype);
 	struct xfs_dir2_data_free *
 		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
-
-	xfs_dir2_data_aoff_t data_dot_offset;
-	xfs_dir2_data_aoff_t data_dotdot_offset;
-	xfs_dir2_data_aoff_t data_first_offset;
-	size_t	data_entry_offset;
 };
 
 extern const struct xfs_dir_ops *
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 4230ea945bc4..d5f4b7187b72 100644
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
@@ -1041,6 +1041,7 @@ int						/* error */
 xfs_dir2_sf_to_block(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
+	struct xfs_da_geometry	*geo = args->geo;
 	xfs_dir2_db_t		blkno;		/* dir-relative block # (0) */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
@@ -1123,7 +1124,7 @@ xfs_dir2_sf_to_block(
 	 * The whole thing is initialized to free by the init routine.
 	 * Say we're using the leaf and tail area.
 	 */
-	dup = (void *)hdr + dp->d_ops->data_entry_offset;
+	dup = (void *)hdr + args->geo->data_entry_offset;
 	needlog = needscan = 0;
 	error = xfs_dir2_data_use_free(args, bp, dup, args->geo->blksize - i,
 			i, &needlog, &needscan);
@@ -1149,7 +1150,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Create entry for .
 	 */
-	dep = (void *)hdr + dp->d_ops->data_dot_offset;
+	dep = (void *)hdr + geo->data_dot_offset;
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
@@ -1163,7 +1164,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Create entry for ..
 	 */
-	dep = (void *)hdr + dp->d_ops->data_dotdot_offset;
+	dep = (void *)hdr + geo->data_dotdot_offset;
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
@@ -1174,7 +1175,7 @@ xfs_dir2_sf_to_block(
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
 	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 				(char *)dep - (char *)hdr));
-	offset = dp->d_ops->data_first_offset;
+	offset = geo->data_first_offset;
 	/*
 	 * Loop over existing entries, stuff them in.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 750e95997d8c..81ba13854f8d 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -84,7 +84,7 @@ __xfs_dir3_data_check(
 		return __this_address;
 
 	hdr = bp->b_addr;
-	p = (char *)hdr + ops->data_entry_offset;
+	p = (char *)hdr + geo->data_entry_offset;
 
 	switch (hdr->magic) {
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
@@ -580,6 +580,7 @@ xfs_dir2_data_freescan_int(
 	struct xfs_dir2_data_hdr *hdr,
 	int			*loghead)
 {
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
 	xfs_dir2_data_entry_t	*dep;		/* active data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused data entry */
 	struct xfs_dir2_data_free *bf;
@@ -600,8 +601,8 @@ xfs_dir2_data_freescan_int(
 	/*
 	 * Set up pointers.
 	 */
-	p = (char *)hdr + ops->data_entry_offset;
-	endp = xfs_dir3_data_endp(mp->m_dir_geo, hdr);
+	p = (char *)hdr + geo->data_entry_offset;
+	endp = xfs_dir3_data_endp(geo, hdr);
 	/*
 	 * Loop over the block's entries.
 	 */
@@ -689,7 +690,7 @@ xfs_dir3_data_init(
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 
 	bf = dp->d_ops->data_bestfree_p(hdr);
-	bf[0].offset = cpu_to_be16(dp->d_ops->data_entry_offset);
+	bf[0].offset = cpu_to_be16(args->geo->data_entry_offset);
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
 		bf[i].length = 0;
 		bf[i].offset = 0;
@@ -698,10 +699,10 @@ xfs_dir3_data_init(
 	/*
 	 * Set up an unused entry for the block's body.
 	 */
-	dup = (void *)hdr + dp->d_ops->data_entry_offset;
+	dup = (void *)hdr + args->geo->data_entry_offset;
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 
-	t = args->geo->blksize - (uint)dp->d_ops->data_entry_offset;
+	t = args->geo->blksize - args->geo->data_entry_offset;
 	bf[0].length = cpu_to_be16(t);
 	dup->length = cpu_to_be16(t);
 	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)hdr);
@@ -753,8 +754,7 @@ xfs_dir2_data_log_header(
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 #endif
 
-	xfs_trans_log_buf(args->trans, bp, 0,
-			  args->dp->d_ops->data_entry_offset - 1);
+	xfs_trans_log_buf(args->trans, bp, 0, args->geo->data_entry_offset - 1);
 }
 
 /*
@@ -822,7 +822,7 @@ xfs_dir2_data_make_free(
 	 * If this isn't the start of the block, then back up to
 	 * the previous entry and see if it's free.
 	 */
-	if (offset > args->dp->d_ops->data_entry_offset) {
+	if (offset > args->geo->data_entry_offset) {
 		__be16			*tagp;	/* tag just before us */
 
 		tagp = (__be16 *)((char *)hdr + offset) - 1;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 3a65b7c8aa83..c228ff66b3f0 100644
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
 	if (be16_to_cpu(bestsp[db]) != oldbest)
 		return -EFSCORRUPTED;
@@ -1428,8 +1429,8 @@ xfs_dir2_leaf_removename(
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
@@ -1471,7 +1472,7 @@ xfs_dir2_leaf_removename(
 	/*
 	 * If the data block was not the first one, drop it.
 	 */
-	else if (db != args->geo->datablk)
+	else if (db != geo->datablk)
 		dbp = NULL;
 
 	xfs_dir3_leaf_check(dp, lbp);
@@ -1592,6 +1593,7 @@ xfs_dir2_leaf_trim_data(
 	struct xfs_buf		*lbp,		/* leaf buffer */
 	xfs_dir2_db_t		db)		/* data block number */
 {
+	struct xfs_da_geometry	*geo = args->geo;
 	__be16			*bestsp;	/* leaf bests table */
 	struct xfs_buf		*dbp;		/* data block buffer */
 	xfs_inode_t		*dp;		/* incore directory inode */
@@ -1605,13 +1607,13 @@ xfs_dir2_leaf_trim_data(
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
@@ -1621,7 +1623,7 @@ xfs_dir2_leaf_trim_data(
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
 	ASSERT(be16_to_cpu(bf[0].length) ==
-	       args->geo->blksize - dp->d_ops->data_entry_offset);
+	       geo->blksize - geo->data_entry_offset);
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
 }
 #endif
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7534e35d8aa2..58362169aa57 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1257,6 +1257,7 @@ xfs_dir2_leafn_remove(
 	xfs_da_state_blk_t	*dblk,		/* data block */
 	int			*rval)		/* resulting block needs join */
 {
+	struct xfs_da_geometry	*geo = args->geo;
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_db_t		db;		/* data block number */
 	struct xfs_buf		*dbp;		/* data block buffer */
@@ -1287,9 +1288,9 @@ xfs_dir2_leafn_remove(
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
@@ -1340,9 +1341,8 @@ xfs_dir2_leafn_remove(
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
@@ -1352,22 +1352,20 @@ xfs_dir2_leafn_remove(
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
@@ -1399,9 +1397,9 @@ xfs_dir2_leafn_remove(
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
index 4885a0e920c5..8ecbb0828e42 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -296,7 +296,7 @@ xfs_dir2_block_to_sf(
 	/*
 	 * Set up to loop over the block's entries.
 	 */
-	ptr = (char *)hdr + dp->d_ops->data_entry_offset;
+	ptr = (char *)hdr + args->geo->data_entry_offset;
 	endptr = xfs_dir3_data_endp(args->geo, hdr);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	/*
@@ -562,7 +562,7 @@ xfs_dir2_sf_addname_hard(
 	 * to insert the new entry.
 	 * If it's going to end up at the end then oldsfep will point there.
 	 */
-	for (offset = dp->d_ops->data_first_offset,
+	for (offset = args->geo->data_first_offset,
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
 	      add_datasize = xfs_dir2_data_entsize(mp, args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
@@ -640,7 +640,7 @@ xfs_dir2_sf_addname_pick(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = xfs_dir2_data_entsize(mp, args->namelen);
-	offset = dp->d_ops->data_first_offset;
+	offset = args->geo->data_first_offset;
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
 	/*
@@ -705,7 +705,7 @@ xfs_dir2_sf_check(
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	offset = dp->d_ops->data_first_offset;
+	offset = args->geo->data_first_offset;
 	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
@@ -738,7 +738,6 @@ xfs_dir2_sf_verify(
 	struct xfs_dir2_sf_entry	*sfep;
 	struct xfs_dir2_sf_entry	*next_sfep;
 	char				*endp;
-	const struct xfs_dir_ops	*dops;
 	struct xfs_ifork		*ifp;
 	xfs_ino_t			ino;
 	int				i;
@@ -749,11 +748,6 @@ xfs_dir2_sf_verify(
 	uint8_t				filetype;
 
 	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
-	/*
-	 * xfs_iread calls us before xfs_setup_inode sets up ip->d_ops,
-	 * so we can only trust the mountpoint to have the right pointer.
-	 */
-	dops = xfs_dir_get_ops(mp, NULL);
 
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
@@ -774,7 +768,7 @@ xfs_dir2_sf_verify(
 	error = xfs_dir_ino_validate(mp, ino);
 	if (error)
 		return __this_address;
-	offset = dops->data_first_offset;
+	offset = mp->m_dir_geo->data_first_offset;
 
 	/* Check all reported entries */
 	sfep = xfs_dir2_sf_firstentry(sfp);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index d7ac9423ed86..d13c863d72a5 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -241,7 +241,7 @@ xchk_dir_rec(
 	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
 
 	/* Make sure we got a real directory entry. */
-	p = bp->b_addr + mp->m_dir_inode_ops->data_entry_offset;
+	p = bp->b_addr + mp->m_dir_geo->data_entry_offset;
 	endp = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
 	if (!endp) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
@@ -391,7 +391,7 @@ xchk_directory_data_bestfree(
 	}
 
 	/* Make sure the bestfrees are actually the best free spaces. */
-	ptr = bp->b_addr + d_ops->data_entry_offset;
+	ptr = bp->b_addr + mp->m_dir_geo->data_entry_offset;
 	endptr = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
 
 	/* Iterate the entries, stopping when we hit or go past the end. */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 4cc4102c85f0..7519317d7a21 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -71,14 +71,11 @@ xfs_dir2_sf_getdents(
 
 	/*
 	 * Precalculate offsets for . and .. as we will always need them.
-	 *
-	 * XXX(hch): the second argument is sometimes 0 and sometimes
-	 * geo->datablk
 	 */
 	dot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
-						dp->d_ops->data_dot_offset);
+						geo->data_dot_offset);
 	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
-						dp->d_ops->data_dotdot_offset);
+						geo->data_dotdot_offset);
 
 	/*
 	 * Put . entry unless we're starting past it.
@@ -176,7 +173,7 @@ xfs_dir2_block_getdents(
 	/*
 	 * Set up values for the loop.
 	 */
-	ptr = (char *)hdr + dp->d_ops->data_entry_offset;
+	ptr = (char *)hdr + geo->data_entry_offset;
 	endptr = xfs_dir3_data_endp(geo, hdr);
 
 	/*
@@ -411,13 +408,13 @@ xfs_dir2_leaf_getdents(
 			/*
 			 * Find our position in the block.
 			 */
-			ptr = (char *)hdr + dp->d_ops->data_entry_offset;
+			ptr = (char *)hdr + geo->data_entry_offset;
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

