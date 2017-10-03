Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42302 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdJCUm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:42:59 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93KgwNl003571
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v93KgvOf004028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:58 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v93KgvPb004883
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:57 GMT
Subject: [PATCH 20/25] xfs: scrub directory freespace
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:42:55 -0700
Message-ID: <150706337519.19351.13526798476488574495.stgit@magnolia>
In-Reply-To: <150706324963.19351.17715069858921948692.stgit@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the free space information in a directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c |  347 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 347 insertions(+)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e58252b..6ea06c3 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -239,6 +239,348 @@ xfs_scrub_dir_rec(
 	return error;
 }
 
+/* Is this free entry either in the bestfree or smaller than all of them? */
+static inline void
+xfs_scrub_directory_check_free_entry(
+	struct xfs_scrub_context	*sc,
+	xfs_dablk_t			lblk,
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
+			return;
+		if (smallest < be16_to_cpu(dfp->length))
+			smallest = be16_to_cpu(dfp->length);
+	}
+
+	if (be16_to_cpu(dup->length) > smallest)
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
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
+	struct xfs_mount		*mp = sc->mp;
+	char				*ptr;
+	char				*endptr;
+	u16				tag;
+	int				newlen;
+	int				offset;
+	int				error;
+
+	if (is_block) {
+		/* dir block format */
+		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
+	} else {
+		/* dir data format */
+		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, -1, &bp);
+	}
+	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
+		goto out;
+
+	/* Do the bestfrees correspond to actual free space? */
+	bf = sc->ip->d_ops->data_bestfree_p(bp->b_addr);
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
+		offset = be16_to_cpu(dfp->offset);
+		if (offset == 0)
+			continue;
+		if (offset >= BBTOB(bp->b_length)) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			continue;
+		}
+		dup = (struct xfs_dir2_data_unused *)(bp->b_addr + offset);
+		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
+
+		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG) ||
+		    be16_to_cpu(dup->length) != be16_to_cpu(dfp->length) ||
+		    tag != ((char *)dup - (char *)bp->b_addr))
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+	}
+
+	/* Make sure the bestfrees are actually the best free spaces. */
+	ptr = (char *)sc->ip->d_ops->data_entry_p(bp->b_addr);
+	if (is_block) {
+		struct xfs_dir2_block_tail	*btp;
+
+		btp = xfs_dir2_block_tail_p(sc->mp->m_dir_geo, bp->b_addr);
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
+			if (newlen <= 0) {
+				xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
+						lblk);
+				goto out_buf;
+			}
+			ptr += newlen;
+			if (endptr < ptr)
+				xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
+					      lblk);
+			continue;
+		}
+
+		/* Spot check this free entry */
+		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
+		if (tag != ((char *)dup - (char *)bp->b_addr))
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+
+		/*
+		 * Either this entry is a bestfree or it's smaller than
+		 * any of the bestfrees.
+		 */
+		xfs_scrub_directory_check_free_entry(sc, lblk, bf, dup);
+
+		/* Move on. */
+		newlen = be16_to_cpu(dup->length);
+		if (newlen <= 0) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			goto out_buf;
+		}
+		ptr += newlen;
+		if (endptr < ptr)
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+	}
+out_buf:
+	xfs_trans_brelse(sc->tp, bp);
+out:
+	return error;
+}
+
+/* Is this the longest free entry in the block? */
+static inline void
+xfs_scrub_directory_check_freesp(
+	struct xfs_scrub_context	*sc,
+	xfs_dablk_t			lblk,
+	struct xfs_buf			*dbp,
+	unsigned int			len)
+{
+	struct xfs_dir2_data_free	*bf;
+	struct xfs_dir2_data_free	*dfp;
+	unsigned int			longest = 0;
+	int				offset;
+
+	bf = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
+		offset = be16_to_cpu(dfp->offset);
+		if (!offset)
+			continue;
+		if (longest < be16_to_cpu(dfp->length))
+			longest = be16_to_cpu(dfp->length);
+	}
+
+	if (longest != len)
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+}
+
+/* Check free space info in a directory leaf1 block. */
+STATIC int
+xfs_scrub_directory_leaf1_bestfree(
+	struct xfs_scrub_context	*sc,
+	struct xfs_da_args		*args,
+	xfs_dablk_t			lblk)
+{
+	struct xfs_dir2_leaf_tail	*ltp;
+	struct xfs_buf			*dbp;
+	struct xfs_buf			*bp;
+	struct xfs_mount		*mp = sc->mp;
+	__be16				*bestp;
+	__u16				best;
+	int				i;
+	int				error;
+
+	/* Read the free space block */
+	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
+	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
+		goto out;
+
+	/* Check all the entries. */
+	ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, bp->b_addr);
+	bestp = xfs_dir2_leaf_bests_p(ltp);
+	for (i = 0; i < be32_to_cpu(ltp->bestcount); i++, bestp++) {
+		best = be16_to_cpu(*bestp);
+		if (best == NULLDATAOFF)
+			continue;
+		error = xfs_dir3_data_read(sc->tp, sc->ip,
+				i * args->geo->fsbcount, -1, &dbp);
+		if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
+			continue;
+		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
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
+	struct xfs_da_args		*args,
+	xfs_dablk_t			lblk)
+{
+	struct xfs_dir3_icfree_hdr	freehdr;
+	struct xfs_buf			*dbp;
+	struct xfs_buf			*bp;
+	__be16				*bestp;
+	__be16				best;
+	int				i;
+	int				error;
+
+	/* Read the free space block */
+	error = xfs_dir2_free_read(sc->tp, sc->ip, lblk, &bp);
+	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
+		goto out;
+
+	/* Check all the entries. */
+	sc->ip->d_ops->free_hdr_from_disk(&freehdr, bp->b_addr);
+	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
+	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
+		best = be16_to_cpu(*bestp);
+		if (best == NULLDATAOFF)
+			continue;
+		error = xfs_dir3_data_read(sc->tp, sc->ip,
+				(freehdr.firstdb + i) * args->geo->fsbcount,
+				-1, &dbp);
+		if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
+			continue;
+		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
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
+	struct xfs_mount		*mp = sc->mp;
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
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+	lblk = XFS_B_TO_FSB(mp, XFS_DIR2_DATA_OFFSET);
+	leaf_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_LEAF_OFFSET);
+	free_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_FREE_OFFSET);
+
+	/* Is this a block dir? */
+	args.dp = sc->ip;
+	args.geo = mp->m_dir_geo;
+	args.trans = sc->tp;
+	error = xfs_dir2_isblock(&args, &is_block);
+	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
+		goto out;
+
+	/* Iterate all the data extents in the directory... */
+	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+	while (found) {
+		/* No more data blocks... */
+		if (got.br_startoff >= leaf_lblk)
+			break;
+
+		/* Check each data block's bestfree data */
+		for (lblk = roundup((xfs_dablk_t)got.br_startoff,
+				args.geo->fsbcount);
+		     lblk < got.br_startoff + got.br_blockcount;
+		     lblk += args.geo->fsbcount) {
+			error = xfs_scrub_directory_data_bestfree(sc, lblk,
+					is_block);
+			if (error)
+				goto out;
+		}
+
+		found = xfs_iext_get_extent(ifp, ++idx, &got);
+	}
+
+	/* Look for a leaf1 block, which has free info. */
+	if (xfs_iext_lookup_extent(sc->ip, ifp, leaf_lblk, &idx, &got) &&
+	    got.br_startoff == leaf_lblk &&
+	    got.br_blockcount == args.geo->fsbcount &&
+	    !xfs_iext_get_extent(ifp, ++idx, &got)) {
+		if (is_block) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			goto not_leaf1;
+		}
+		error = xfs_scrub_directory_leaf1_bestfree(sc, &args,
+				leaf_lblk);
+		if (error)
+			goto out;
+	}
+not_leaf1:
+
+	/* Scan for free blocks */
+	lblk = free_lblk;
+	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+	while (found) {
+		/*
+		 * Dirs can't have blocks mapped above 2^32.
+		 * Single-block dirs shouldn't even be here.
+		 */
+		lblk = got.br_startoff;
+		if (lblk & ~0xFFFFFFFFULL) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			goto out;
+		}
+		if (is_block) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			goto nextfree;
+		}
+
+		/* Check each dir free block's bestfree data */
+		for (lblk = roundup((xfs_dablk_t)got.br_startoff,
+				args.geo->fsbcount);
+		     lblk < got.br_startoff + got.br_blockcount;
+		     lblk += args.geo->fsbcount) {
+			error = xfs_scrub_directory_free_bestfree(sc, &args,
+					lblk);
+			if (error)
+				goto out;
+		}
+
+nextfree:
+		found = xfs_iext_get_extent(ifp, ++idx, &got);
+	}
+out:
+	return error;
+}
+
 /* Scrub a whole directory. */
 int
 xfs_scrub_directory(
@@ -266,6 +608,11 @@ xfs_scrub_directory(
 	if (error)
 		return error;
 
+	/* Check the freespace. */
+	error = xfs_scrub_directory_blocks(sc);
+	if (error)
+		return error;
+
 	/*
 	 * Check that every dirent we see can also be looked up by hash.
 	 * Userspace usually asks for a 32k buffer, so we will too.

