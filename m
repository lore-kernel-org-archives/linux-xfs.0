Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28298 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbdJLBn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:43:28 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1hRT4001237
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:43:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1hRBD008464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:43:27 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1hRY9001773
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:43:27 GMT
Subject: [PATCH 25/30] xfs: scrub directory freespace
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:43:26 -0700
Message-ID: <150777260602.1724.16339769636569418352.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
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
 fs/xfs/scrub/dir.c |  425 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 425 insertions(+)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e2a8f90..a41310f 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -250,6 +250,426 @@ xfs_scrub_dir_rec(
 	return error;
 }
 
+/*
+ * Is this unused entry either in the bestfree or smaller than all of them?
+ * We assume the bestfrees are sorted longest to shortest, and that there
+ * aren't any bogus entries.
+ */
+static inline void
+xfs_scrub_directory_check_free_entry(
+	struct xfs_scrub_context	*sc,
+	xfs_dablk_t			lblk,
+	struct xfs_dir2_data_free	*bf,
+	struct xfs_dir2_data_unused	*dup)
+{
+	struct xfs_dir2_data_free	*dfp;
+	unsigned int			dup_length;
+
+	dup_length = be16_to_cpu(dup->length);
+
+	/* Unused entry is shorter than any of the bestfrees */
+	if (dup_length < be16_to_cpu(bf[XFS_DIR2_DATA_FD_COUNT - 1].length))
+		return;
+
+	for (dfp = &bf[XFS_DIR2_DATA_FD_COUNT - 1]; dfp >= bf; dfp--)
+		if (dup_length == be16_to_cpu(dfp->length))
+			return;
+
+	/* Unused entry should be in the bestfrees but wasn't found. */
+	xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
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
+	const struct xfs_dir_ops	*d_ops;
+	char				*ptr;
+	char				*endptr;
+	u16				tag;
+	unsigned int			nr_bestfrees = 0;
+	unsigned int			nr_frees = 0;
+	unsigned int			smallest_bestfree;
+	int				newlen;
+	int				offset;
+	int				error;
+
+	d_ops = sc->ip->d_ops;
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
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
+		goto out;
+
+	/* Do the bestfrees correspond to actual free space? */
+	bf = d_ops->data_bestfree_p(bp->b_addr);
+	smallest_bestfree = UINT_MAX;
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
+		offset = be16_to_cpu(dfp->offset);
+		if (offset == 0)
+			continue;
+		if (offset >= mp->m_dir_geo->blksize) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			goto out_buf;
+		}
+		dup = (struct xfs_dir2_data_unused *)(bp->b_addr + offset);
+		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
+
+		/* bestfree doesn't match the entry it points at? */
+		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG) ||
+		    be16_to_cpu(dup->length) != be16_to_cpu(dfp->length) ||
+		    tag != ((char *)dup - (char *)bp->b_addr)) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			goto out_buf;
+		}
+
+		/* bestfree records should be ordered largest to smallest */
+		if (smallest_bestfree < be16_to_cpu(dfp->length)) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			goto out_buf;
+		}
+
+		smallest_bestfree = be16_to_cpu(dfp->length);
+		nr_bestfrees++;
+	}
+
+	/* Make sure the bestfrees are actually the best free spaces. */
+	ptr = (char *)d_ops->data_entry_p(bp->b_addr);
+	if (is_block) {
+		struct xfs_dir2_block_tail	*btp;
+
+		btp = xfs_dir2_block_tail_p(mp->m_dir_geo, bp->b_addr);
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
+			newlen = d_ops->data_entsize(dep->namelen);
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
+		else
+			nr_frees++;
+	}
+
+	/* Did we see at least as many free slots as there are bestfrees? */
+	if (nr_frees < nr_bestfrees)
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+out_buf:
+	xfs_trans_brelse(sc->tp, bp);
+out:
+	return error;
+}
+
+/*
+ * Does the free space length in the free space index block ($len) match
+ * the longest length in the directory data block's bestfree array?
+ * Assume that we've already checked that the data block's bestfree
+ * array is in order.
+ */
+static inline void
+xfs_scrub_directory_check_freesp(
+	struct xfs_scrub_context	*sc,
+	xfs_dablk_t			lblk,
+	struct xfs_buf			*dbp,
+	unsigned int			len)
+{
+	struct xfs_dir2_data_free	*bf;
+	struct xfs_dir2_data_free	*dfp;
+	int				offset;
+
+	if (len == 0)
+		return;
+
+	bf = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
+	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
+		offset = be16_to_cpu(dfp->offset);
+		if (offset == 0)
+			break;
+		if (len == be16_to_cpu(dfp->length))
+			return;
+		/* Didn't find the best length in the bestfree data */
+		break;
+	}
+
+	xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
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
+	/*
+	 * Read the free space block.  The verifier will check for hash
+	 * value ordering problems and check the stale entry count.
+	 */
+	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
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
+		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
+				&error))
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
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
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
+		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
+				&error))
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
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
+		goto out;
+
+	/* Iterate all the data extents in the directory... */
+	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+	while (found) {
+		/* Block directories only have a single block at offset 0. */
+		if (is_block &&
+		    (got.br_startoff > 0 ||
+		     got.br_blockcount != args.geo->fsbcount)) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
+					got.br_startoff);
+			break;
+		}
+
+		/* No more data blocks... */
+		if (got.br_startoff >= leaf_lblk)
+			break;
+
+		/*
+		 * Check each data block's bestfree data.
+		 *
+		 * Iterate all the fsbcount-aligned block offsets in
+		 * this directory.  The directory block reading code is
+		 * smart enough to do its own bmap lookups to handle
+		 * discontiguous directory blocks.  When we're done
+		 * with the extent record, re-query the bmap at the
+		 * next fsbcount-aligned offset to avoid redundant
+		 * block checks.
+		 */
+		for (lblk = roundup((xfs_dablk_t)got.br_startoff,
+				args.geo->fsbcount);
+		     lblk < got.br_startoff + got.br_blockcount;
+		     lblk += args.geo->fsbcount) {
+			error = xfs_scrub_directory_data_bestfree(sc, lblk,
+					is_block);
+			if (error)
+				goto out;
+		}
+		lblk = roundup((xfs_dablk_t)got.br_startoff + got.br_blockcount,
+				args.geo->fsbcount);
+		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+	}
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	/* Look for a leaf1 block, which has free info. */
+	if (xfs_iext_lookup_extent(sc->ip, ifp, leaf_lblk, &idx, &got) &&
+	    got.br_startoff == leaf_lblk &&
+	    got.br_blockcount == args.geo->fsbcount &&
+	    !xfs_iext_get_extent(ifp, ++idx, &got)) {
+		if (is_block) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			goto out;
+		}
+		error = xfs_scrub_directory_leaf1_bestfree(sc, &args,
+				leaf_lblk);
+		if (error)
+			goto out;
+	}
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
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
+			goto out;
+		}
+
+		/*
+		 * Check each dir free block's bestfree data.
+		 *
+		 * Iterate all the fsbcount-aligned block offsets in
+		 * this directory.  The directory block reading code is
+		 * smart enough to do its own bmap lookups to handle
+		 * discontiguous directory blocks.  When we're done
+		 * with the extent record, re-query the bmap at the
+		 * next fsbcount-aligned offset to avoid redundant
+		 * block checks.
+		 */
+		for (lblk = roundup((xfs_dablk_t)got.br_startoff,
+				args.geo->fsbcount);
+		     lblk < got.br_startoff + got.br_blockcount;
+		     lblk += args.geo->fsbcount) {
+			error = xfs_scrub_directory_free_bestfree(sc, &args,
+					lblk);
+			if (error)
+				goto out;
+		}
+		lblk = roundup((xfs_dablk_t)got.br_startoff + got.br_blockcount,
+				args.geo->fsbcount);
+		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+	}
+out:
+	return error;
+}
+
 /* Scrub a whole directory. */
 int
 xfs_scrub_directory(
@@ -278,6 +698,11 @@ xfs_scrub_directory(
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

