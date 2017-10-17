Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19781 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757313AbdJQBKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 21:10:50 -0400
Date: Mon, 16 Oct 2017 18:10:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 25/30] xfs: scrub directory freespace
Message-ID: <20171017011045.GZ4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777260602.1724.16339769636569418352.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777260602.1724.16339769636569418352.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

Check the free space information in a directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: make the freespace and leaf checks more complete
---
 fs/xfs/scrub/dir.c |  474 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 474 insertions(+)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index ffdaf60..21c50e4 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -251,6 +251,475 @@ xfs_scrub_dir_rec(
 	return error;
 }
 
+/*
+ * Is this unused entry either in the bestfree or smaller than all of
+ * them?  We've already checked that the bestfrees are sorted longest to
+ * shortest, and that there aren't any bogus entries.
+ */
+STATIC void
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
+		if (ptr <= endptr)
+			nr_frees++;
+	}
+
+	/* Did we go off the end? */
+	if (ptr > endptr)
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
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
+STATIC void
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
+	struct xfs_dir3_icleaf_hdr	leafhdr;
+	struct xfs_dir2_leaf_entry	*ents;
+	struct xfs_dir2_leaf_tail	*ltp;
+	struct xfs_dir2_leaf		*leaf;
+	struct xfs_buf			*dbp;
+	struct xfs_buf			*bp;
+	struct xfs_mount		*mp = sc->mp;
+	const struct xfs_dir_ops	*d_ops = sc->ip->d_ops;
+	__be16				*bestp;
+	__u16				best;
+	__u32				hash;
+	__u32				lasthash = 0;
+	__u32				bestcount;
+	unsigned int			stale = 0;
+	int				i;
+	int				error;
+
+	/* Read the free space block. */
+	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
+		goto out;
+
+	leaf = bp->b_addr;
+	d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	ents = d_ops->leaf_ents_p(leaf);
+	ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
+	bestcount = be32_to_cpu(ltp->bestcount);
+	bestp = xfs_dir2_leaf_bests_p(ltp);
+
+	/*
+	 * There should be as many bestfree slots as there are dir data
+	 * blocks that can fit under i_size.
+	 */
+	if (bestcount != XFS_B_TO_FSB(mp, sc->ip->i_d.di_size)) {
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		goto out;
+	}
+
+	/* Is the leaf count even remotely sane? */
+	if (leafhdr.count > d_ops->leaf_max_ents(mp->m_dir_geo)) {
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		goto out;
+	}
+
+	/* Leaves and bests don't overlap in leaf format. */
+	if ((char *)&ents[leafhdr.count] > (char *)xfs_dir2_leaf_bests_p(ltp)) {
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		goto out;
+	}
+
+	/* Check hash value order, count stale entries.  */
+	for (i = 0; i < leafhdr.count; i++) {
+		hash = be32_to_cpu(ents[i].hashval);
+		if (i > 0 && lasthash > hash)
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		lasthash = hash;
+		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+			stale++;
+	}
+	if (leafhdr.stale != stale)
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+
+	/* Check all the bestfree entries. */
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
+	unsigned int			stale = 0;
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
+		if (best == NULLDATAOFF) {
+			stale++;
+			continue;
+		}
+		error = xfs_dir3_data_read(sc->tp, sc->ip,
+				(freehdr.firstdb + i) * args->geo->fsbcount,
+				-1, &dbp);
+		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
+				&error))
+			continue;
+		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
+		xfs_trans_brelse(sc->tp, dbp);
+	}
+
+	if (freehdr.nused + stale != freehdr.nvalid)
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
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
+	xfs_dablk_t			dabno;
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
+		dabno = got.br_startoff + got.br_blockcount;
+		lblk = roundup(dabno, args.geo->fsbcount);
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
+		dabno = got.br_startoff + got.br_blockcount;
+		lblk = roundup(dabno, args.geo->fsbcount);
+		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+	}
+out:
+	return error;
+}
+
 /* Scrub a whole directory. */
 int
 xfs_scrub_directory(
@@ -279,6 +748,11 @@ xfs_scrub_directory(
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
