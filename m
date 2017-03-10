Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20982 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934539AbdCJXVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Mar 2017 18:21:42 -0500
Subject: [PATCH 16/19] xfs: scrub directory freespace
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 10 Mar 2017 15:21:29 -0800
Message-ID: <148918808954.6959.7077033530072092538.stgit@birch.djwong.org>
In-Reply-To: <148918798893.6959.7972227235163150709.stgit@birch.djwong.org>
References: <148918798893.6959.7972227235163150709.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the free space information in a directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h |    2 
 fs/xfs/scrub/dir.c            |  323 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 326 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b887fb2..e7ca764 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -256,7 +256,7 @@ const struct xfs_buf_ops xfs_dir3_leafn_buf_ops = {
 	.verify_write = xfs_dir3_leafn_write_verify,
 };
 
-static int
+int
 xfs_dir3_leaf_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 4cf2956..c586ade 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -58,6 +58,8 @@ extern int xfs_dir3_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 		struct xfs_buf **bpp);
 
 /* xfs_dir2_leaf.c */
+extern int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index ae1751a..f9e7668 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -223,6 +223,326 @@ xfs_scrub_dir_rec(
 #undef XFS_SCRUB_DIRENT_GOTO
 #undef XFS_SCRUB_DIRENT_CHECK
 
+#define XFS_SCRUB_DIR_BLOCK_CHECK(fs_ok) \
+	XFS_SCRUB_DATA_CHECK(sc, XFS_DATA_FORK, \
+		lblk << mp->m_sb.sb_blocklog, "dir", fs_ok)
+#define XFS_SCRUB_DIR_BLOCK_GOTO(fs_ok, label) \
+	XFS_SCRUB_DATA_GOTO(sc, XFS_DATA_FORK, \
+		lblk << mp->m_sb.sb_blocklog, "dir", fs_ok, label)
+#define XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, XFS_DATA_FORK, \
+		lblk << mp->m_sb.sb_blocklog, "dir", &error, label)
+/* Is this free entry either in the bestfree or smaller than all of them? */
+static inline bool
+xfs_scrub_directory_check_free_entry(
+	struct xfs_dir2_data_free	*bf,
+	struct xfs_dir2_data_unused	*dup)
+{
+	struct xfs_dir2_data_free	*dfp;
+	unsigned int			smallest;
+
+	smallest = -1U;
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
+		if (dfp->offset &&
+		    be16_to_cpu(dfp->length) == be16_to_cpu(dup->length))
+			return true;
+		if (smallest < be16_to_cpu(dfp->length))
+			smallest = be16_to_cpu(dfp->length);
+	}
+
+	return be16_to_cpu(dup->length) <= smallest;
+}
+
+/* Check free space info in a directory data block. */
+STATIC int
+xfs_scrub_directory_data_bestfree(
+	struct xfs_scrub_context	*sc,
+	xfs_dablk_t			lblk,
+	bool				is_block)
+{
+	struct xfs_dir2_data_unused	*dup;
+	struct xfs_dir2_data_free	*dfp;
+	struct xfs_buf			*bp;
+	struct xfs_dir2_data_free	*bf;
+	struct xfs_mount		*mp = sc->ip->i_mount;
+	char				*ptr;
+	char				*endptr;
+	u16				tag;
+	int				newlen;
+	int				offset;
+	int				error;
+
+	if (is_block) {
+		/* dir block format */
+		XFS_SCRUB_DIR_BLOCK_CHECK(lblk ==
+				XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET));
+		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
+	} else {
+		/* dir data format */
+		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk,
+				-1, &bp);
+	}
+	XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(out);
+
+	/* Do the bestfrees correspond to actual free space? */
+	bf = sc->ip->d_ops->data_bestfree_p(bp->b_addr);
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
+		offset = be16_to_cpu(dfp->offset);
+		XFS_SCRUB_DIR_BLOCK_GOTO(offset < BBTOB(bp->b_length), nextloop);
+		if (!offset)
+			continue;
+		dup = (struct xfs_dir2_data_unused *)(bp->b_addr + offset);
+		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
+
+		XFS_SCRUB_DIR_BLOCK_CHECK(dup->freetag ==
+				cpu_to_be16(XFS_DIR2_DATA_FREE_TAG));
+		XFS_SCRUB_DIR_BLOCK_CHECK(be16_to_cpu(dup->length) ==
+				be16_to_cpu(dfp->length));
+		XFS_SCRUB_DIR_BLOCK_CHECK(tag ==
+				((char *)dup - (char *)bp->b_addr));
+nextloop:;
+	}
+
+	/* Make sure the bestfrees are actually the best free spaces. */
+	ptr = (char *)sc->ip->d_ops->data_entry_p(bp->b_addr);
+	if (is_block) {
+		struct xfs_dir2_block_tail	*btp;
+
+		btp = xfs_dir2_block_tail_p(sc->ip->i_mount->m_dir_geo,
+				bp->b_addr);
+		endptr = (char *)xfs_dir2_block_leaf_p(btp);
+	} else
+		endptr = (char *)bp->b_addr + BBTOB(bp->b_length);
+	while (ptr < endptr) {
+		dup = (struct xfs_dir2_data_unused *)ptr;
+		/* Skip real entries */
+		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG)) {
+			struct xfs_dir2_data_entry	*dep;
+
+			dep = (struct xfs_dir2_data_entry *)ptr;
+			newlen = sc->ip->d_ops->data_entsize(dep->namelen);
+			XFS_SCRUB_DIR_BLOCK_GOTO(newlen > 0, out_buf);
+			ptr += newlen;
+			XFS_SCRUB_DIR_BLOCK_CHECK(ptr <= endptr);
+			continue;
+		}
+
+		/* Spot check this free entry */
+		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
+		XFS_SCRUB_DIR_BLOCK_CHECK(tag ==
+				((char *)dup - (char *)bp->b_addr));
+
+		/*
+		 * Either this entry is a bestfree or it's smaller than
+		 * any of the bestfrees.
+		 */
+		XFS_SCRUB_DIR_BLOCK_CHECK(
+				xfs_scrub_directory_check_free_entry(bf, dup));
+
+		/* Move on. */
+		newlen = be16_to_cpu(dup->length);
+		XFS_SCRUB_DIR_BLOCK_GOTO(newlen > 0, out_buf);
+		ptr += newlen;
+		XFS_SCRUB_DIR_BLOCK_CHECK(ptr <= endptr);
+	}
+out_buf:
+	xfs_trans_brelse(sc->tp, bp);
+out:
+	return error;
+}
+
+/* Is this the longest free entry in the block? */
+static inline bool
+xfs_scrub_directory_check_freesp(
+	struct xfs_inode		*dp,
+	struct xfs_buf			*dbp,
+	unsigned int			len)
+{
+	struct xfs_dir2_data_free	*bf;
+	struct xfs_dir2_data_free	*dfp;
+	unsigned int			longest = 0;
+	int				offset;
+
+	bf = dp->d_ops->data_bestfree_p(dbp->b_addr);
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
+		offset = be16_to_cpu(dfp->offset);
+		if (!offset)
+			continue;
+		if (longest < be16_to_cpu(dfp->length))
+			longest = be16_to_cpu(dfp->length);
+	}
+
+	return longest == len;
+}
+
+/* Check free space info in a directory leaf1 block. */
+STATIC int
+xfs_scrub_directory_leaf1_bestfree(
+	struct xfs_scrub_context	*sc,
+	xfs_dablk_t			lblk)
+{
+	struct xfs_dir2_leaf_tail	*ltp;
+	struct xfs_buf			*dbp;
+	struct xfs_buf			*bp;
+	struct xfs_mount		*mp = sc->ip->i_mount;
+	__be16				*bestp;
+	__u16				best;
+	int				i;
+	int				error;
+
+	/* Read the free space block */
+	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
+	XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(out);
+
+	/* Check all the entries. */
+	ltp = xfs_dir2_leaf_tail_p(sc->ip->i_mount->m_dir_geo, bp->b_addr);
+	bestp = xfs_dir2_leaf_bests_p(ltp);
+	for (i = 0; i < be32_to_cpu(ltp->bestcount); i++, bestp++) {
+		best = be16_to_cpu(*bestp);
+		if (best == NULLDATAOFF)
+			continue;
+		error = xfs_dir3_data_read(sc->tp, sc->ip, i, -1, &dbp);
+		XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(skip_buf);
+		XFS_SCRUB_DIR_BLOCK_CHECK(
+				xfs_scrub_directory_check_freesp(sc->ip, dbp,
+					best));
+skip_buf:
+		xfs_trans_brelse(sc->tp, dbp);
+	}
+out:
+	return error;
+}
+
+/* Check free space info in a directory freespace block. */
+STATIC int
+xfs_scrub_directory_free_bestfree(
+	struct xfs_scrub_context	*sc,
+	xfs_dablk_t			lblk)
+{
+	struct xfs_dir3_icfree_hdr	freehdr;
+	struct xfs_buf			*dbp;
+	struct xfs_buf			*bp;
+	struct xfs_mount		*mp = sc->ip->i_mount;
+	__be16				*bestp;
+	__be16				best;
+	int				i;
+	int				error;
+
+	/* Read the free space block */
+	error = xfs_dir2_free_read(sc->tp, sc->ip, lblk, &bp);
+	XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(out);
+
+	/* Check all the entries. */
+	sc->ip->d_ops->free_hdr_from_disk(&freehdr, bp->b_addr);
+	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
+	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
+		best = be16_to_cpu(*bestp);
+		if (best == NULLDATAOFF)
+			continue;
+		error = xfs_dir3_data_read(sc->tp, sc->ip, freehdr.firstdb + i,
+				-1, &dbp);
+		XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(skip_buf);
+		XFS_SCRUB_DIR_BLOCK_CHECK(
+				xfs_scrub_directory_check_freesp(sc->ip, dbp,
+					best));
+skip_buf:
+		xfs_trans_brelse(sc->tp, dbp);
+	}
+out:
+	return error;
+}
+
+/* Check free space information in directories. */
+STATIC int
+xfs_scrub_directory_blocks(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_bmbt_irec		got;
+	struct xfs_da_args		args;
+	struct xfs_ifork		*ifp;
+	struct xfs_mount		*mp = sc->ip->i_mount;
+	xfs_fileoff_t			leaf_lblk;
+	xfs_fileoff_t			free_lblk;
+	xfs_fileoff_t			lblk;
+	xfs_extnum_t			idx;
+	bool				found;
+	int				is_block = 0;
+	int				error;
+
+	/* Ignore local format directories. */
+	if (sc->ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
+	    sc->ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
+		return 0;
+
+	/* Is this a block dir? */
+	lblk = 0;
+	args.dp = sc->ip;
+	args.geo = sc->ip->i_mount->m_dir_geo;
+	args.trans = sc->tp;
+	error = xfs_dir2_isblock(&args, &is_block);
+	XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(out);
+
+	/* Iterate all the data extents in the directory... */
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+	leaf_lblk = XFS_DIR2_LEAF_OFFSET >> mp->m_sb.sb_blocklog;
+	free_lblk = XFS_DIR2_FREE_OFFSET >> mp->m_sb.sb_blocklog;
+	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+	while (found) {
+		/* No more data blocks... */
+		lblk = got.br_startoff;
+		if (lblk >= leaf_lblk)
+			break;
+
+		for (lblk = got.br_startoff;
+		     lblk < got.br_startoff + got.br_blockcount;
+		     lblk += args.geo->fsbcount) {
+			/* Check each data block's bestfree data */
+			error = xfs_scrub_directory_data_bestfree(sc, lblk,
+					is_block);
+			if (error)
+				goto out;
+		}
+		found = xfs_iext_get_extent(ifp, ++idx, &got);
+	}
+
+	/* Look for a leaf1 block, which has free info. */
+	if (xfs_iext_lookup_extent(sc->ip, ifp, leaf_lblk, &idx, &got) &&
+	    got.br_startoff == leaf_lblk &&
+	    got.br_blockcount == args.geo->fsbcount &&
+	    !xfs_iext_get_extent(ifp, ++idx, &got)) {
+		XFS_SCRUB_DIR_BLOCK_GOTO(!is_block, not_leaf1);
+		error = xfs_scrub_directory_leaf1_bestfree(sc, leaf_lblk);
+		if (error)
+			goto out;
+	}
+not_leaf1:
+
+	/* Scan for free blocks */
+	lblk = free_lblk;
+	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+	while (found) {
+		lblk = got.br_startoff;
+
+		XFS_SCRUB_DIR_BLOCK_GOTO(!is_block, nextfree);
+
+		/* For each dir free block in the extent... */
+		for (lblk = got.br_startoff;
+		     lblk < got.br_startoff + got.br_blockcount;
+		     lblk += args.geo->fsbcount) {
+			/* Check each data block's bestfree data */
+			error = xfs_scrub_directory_free_bestfree(sc, lblk);
+			if (error)
+				goto out;
+		}
+nextfree:
+		found = xfs_iext_get_extent(ifp, ++idx, &got);
+	}
+out:
+	return error;
+}
+#undef XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO
+#undef XFS_SCRUB_DIR_BLOCK_CHECK
+
 /* Scrub a whole directory. */
 int
 xfs_scrub_directory(
@@ -268,6 +588,9 @@ xfs_scrub_directory(
 
 out_unlock:
 	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+	/* Check the freespace. */
+	error = xfs_scrub_directory_blocks(sc);
 out:
 	return error;
 }

