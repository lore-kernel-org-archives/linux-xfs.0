Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46734 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932118AbdJIWyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 18:54:08 -0400
Date: Mon, 9 Oct 2017 15:54:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 20/25] xfs: scrub directory freespace
Message-ID: <20171009225403.GW7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706337519.19351.13526798476488574495.stgit@magnolia>
 <20171009014429.GB3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009014429.GB3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 12:44:29PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:42:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check the free space information in a directory.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/dir.c |  347 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 347 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> > index e58252b..6ea06c3 100644
> > --- a/fs/xfs/scrub/dir.c
> > +++ b/fs/xfs/scrub/dir.c
> > @@ -239,6 +239,348 @@ xfs_scrub_dir_rec(
> >  	return error;
> >  }
> >  
> > +/* Is this free entry either in the bestfree or smaller than all of them? */
> > +static inline void
> > +xfs_scrub_directory_check_free_entry(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_dablk_t			lblk,
> > +	struct xfs_dir2_data_free	*bf,
> > +	struct xfs_dir2_data_unused	*dup)
> > +{
> > +	struct xfs_dir2_data_free	*dfp;
> > +	unsigned int			smallest;
> > +
> > +	smallest = -1U;
> 
> Urk. That's the same as "smallest = UINT_MAX", and so ......
> 
> > +	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
> > +		if (dfp->offset &&
> > +		    be16_to_cpu(dfp->length) == be16_to_cpu(dup->length))
> > +			return;
> > +		if (smallest < be16_to_cpu(dfp->length))
> > +			smallest = be16_to_cpu(dfp->length);
> 
> .... how does this work? Shouldn't it be a ">" check here?

Yes.  Thanks for catching that.  I might as well change the -1U above to
UINT_MAX while I'm at it.

Though since you later point out that the bestfree array should be
sorted longest to shortest, we can make this function faster:

if (dup length < bestfrees[2].length)
	return;

for (bestfrees in reverse order) {
	if (dup offset == bestfree offset) {
		if (dup length != bestfree length)
			corrupt();
		return;
	}
}

corrupt(); /* should be in bestfree[] but isn't? */

> > +	}
> > +
> > +	if (be16_to_cpu(dup->length) > smallest)
> > +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +}
> > +
> > +/* Check free space info in a directory data block. */
> > +STATIC int
> > +xfs_scrub_directory_data_bestfree(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_dablk_t			lblk,
> > +	bool				is_block)
> > +{
> > +	struct xfs_dir2_data_unused	*dup;
> > +	struct xfs_dir2_data_free	*dfp;
> > +	struct xfs_buf			*bp;
> > +	struct xfs_dir2_data_free	*bf;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	char				*ptr;
> > +	char				*endptr;
> > +	u16				tag;
> > +	int				newlen;
> > +	int				offset;
> > +	int				error;
> > +
> > +	if (is_block) {
> > +		/* dir block format */
> > +		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
> > +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
> > +	} else {
> > +		/* dir data format */
> > +		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, -1, &bp);
> > +	}
> > +	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
> > +		goto out;
> > +
> > +	/* Do the bestfrees correspond to actual free space? */
> > +	bf = sc->ip->d_ops->data_bestfree_p(bp->b_addr);
> 
> With the number of d_ops callouts in this code, a local dops
> variable might be in order.

Ok.

> > +	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
> > +		offset = be16_to_cpu(dfp->offset);
> > +		if (offset == 0)
> > +			continue;
> > +		if (offset >= BBTOB(bp->b_length)) {
> > +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +			continue;
> > +		}
> 
> Not sure I like all the checks against and calculations using
> bp->b_length in this function. it would be more correct to check
> against geo->blksize.

Ok.

> > +		dup = (struct xfs_dir2_data_unused *)(bp->b_addr + offset);
> > +		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
> > +
> > +		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG) ||
> > +		    be16_to_cpu(dup->length) != be16_to_cpu(dfp->length) ||
> > +		    tag != ((char *)dup - (char *)bp->b_addr))
> > +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +	}
> 
> Also, count the number of best frees here.

Ok.

I will also check that the bestfree entries are sorted by length.

> > +
> > +	/* Make sure the bestfrees are actually the best free spaces. */
> > +	ptr = (char *)sc->ip->d_ops->data_entry_p(bp->b_addr);
> > +	if (is_block) {
> > +		struct xfs_dir2_block_tail	*btp;
> > +
> > +		btp = xfs_dir2_block_tail_p(sc->mp->m_dir_geo, bp->b_addr);
> 
> mp->m_dir_geo

Ok.

> > +		endptr = (char *)xfs_dir2_block_leaf_p(btp);
> > +	} else
> > +		endptr = (char *)bp->b_addr + BBTOB(bp->b_length);
> 
> 

Empty space here?

> 
> 
> > +	while (ptr < endptr) {
> > +		dup = (struct xfs_dir2_data_unused *)ptr;
> > +		/* Skip real entries */
> > +		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG)) {
> > +			struct xfs_dir2_data_entry	*dep;
> > +
> > +			dep = (struct xfs_dir2_data_entry *)ptr;
> > +			newlen = sc->ip->d_ops->data_entsize(dep->namelen);
> > +			if (newlen <= 0) {
> > +				xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
> > +						lblk);
> > +				goto out_buf;
> > +			}
> > +			ptr += newlen;
> > +			if (endptr < ptr)
> > +				xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
> > +					      lblk);
> > +			continue;
> > +		}
> > +
> > +		/* Spot check this free entry */
> > +		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
> > +		if (tag != ((char *)dup - (char *)bp->b_addr))
> > +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +
> > +		/*
> > +		 * Either this entry is a bestfree or it's smaller than
> > +		 * any of the bestfrees.
> > +		 */
> > +		xfs_scrub_directory_check_free_entry(sc, lblk, bf, dup);
> 
> SO this checks if the entry is in the bestfree, but it doesn't
> tell us if the bestfree array has the correct number of entries...
> 
> > +
> > +		/* Move on. */
> > +		newlen = be16_to_cpu(dup->length);
> > +		if (newlen <= 0) {
> > +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +			goto out_buf;
> > +		}
> > +		ptr += newlen;
> > +		if (endptr < ptr)
> > +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> 
> Count the number of free entries here.

Ok.

> > +	}
> 
> And now check that the number of bestfrees vs free entries is
> valid. If there's more than 3 free entries in the block, the
> bestfrees array should be full...

Ok, done.

> > +out_buf:
> > +	xfs_trans_brelse(sc->tp, bp);
> > +out:
> > +	return error;
> > +}
> > +
> > +/* Is this the longest free entry in the block? */
> > +static inline void
> > +xfs_scrub_directory_check_freesp(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_dablk_t			lblk,
> > +	struct xfs_buf			*dbp,
> > +	unsigned int			len)
> > +{
> > +	struct xfs_dir2_data_free	*bf;
> > +	struct xfs_dir2_data_free	*dfp;
> > +	unsigned int			longest = 0;
> > +	int				offset;
> > +
> > +	bf = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
> > +	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
> > +		offset = be16_to_cpu(dfp->offset);
> > +		if (!offset)
> > +			continue;
> > +		if (longest < be16_to_cpu(dfp->length))
> > +			longest = be16_to_cpu(dfp->length);
> > +	}
> > +
> > +	if (longest != len)
> > +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +}
> 
> This needs a better explanation - it's called to check whether then
> freespace length in the freespace index matches the longest
> freespace in the data block bests array.
> 
> And from that, the data block bests array is supposed to be ordered
> from largest to smallest, yes? As per __xfs_dir3_data_check():
> 
> 
> 	XFS_WANT_CORRUPTED_RETURN(mp, be16_to_cpu(bf[0].length) >=
> 						be16_to_cpu(bf[1].length));
> 	XFS_WANT_CORRUPTED_RETURN(mp, be16_to_cpu(bf[1].length) >=
> 						be16_to_cpu(bf[2].length));
> 
> So why doesn't this code just check the first entry in the array?

I missed that detail, which means that I'll refactor both
check_free_entry and check_freesp to take advantage of that, having also
added a check that the bestfree array is sorted by length.

> Hmmm, and now I've remembered that, xfs_scrub_directory_check_free_entry()
> probably only needs to do a reverse scan just to find the smallest
> non-zero entry...
> 
> > +/* Check free space info in a directory leaf1 block. */
> > +STATIC int
> > +xfs_scrub_directory_leaf1_bestfree(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_da_args		*args,
> > +	xfs_dablk_t			lblk)
> > +{
> > +	struct xfs_dir2_leaf_tail	*ltp;
> > +	struct xfs_buf			*dbp;
> > +	struct xfs_buf			*bp;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	__be16				*bestp;
> > +	__u16				best;
> > +	int				i;
> > +	int				error;
> > +
> > +	/* Read the free space block */
> > +	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
> > +	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
> > +		goto out;
> > +
> > +	/* Check all the entries. */
> > +	ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, bp->b_addr);
> > +	bestp = xfs_dir2_leaf_bests_p(ltp);
> > +	for (i = 0; i < be32_to_cpu(ltp->bestcount); i++, bestp++) {
> > +		best = be16_to_cpu(*bestp);
> > +		if (best == NULLDATAOFF)
> > +			continue;
> > +		error = xfs_dir3_data_read(sc->tp, sc->ip,
> > +				i * args->geo->fsbcount, -1, &dbp);
> > +		if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
> > +			continue;
> > +		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
> > +		xfs_trans_brelse(sc->tp, dbp);
> > +	}
> > +out:
> > +	return error;
> 
> This needs comments to explain what it is not checking because those
> checks were done in the verifier. (i.e.  hash index does not overlap
> the freespace index, stale entry count is valid).

Ok.

/*
 * Read the free space block.  The verifier will check for hash
 * value ordering problems and check the stale entry count.
 */

> hmmmm. More philosophical question: should we rerun the verifiers
> in the scrubber manually so guarantee that we fully cover whatever
> is in memory on cached and modified buffers?

That's coming in part 4 when I wire up the buf_ops to the raw structure
verifier functions and call them from scrub.

(The order can be changed; this is part 1; cross referencing with other
metadata is part 2; repairs are part 3; and exposing the structure
verifiers to internal code is part 4.)

> > +
> > +/* Check free space info in a directory freespace block. */
> > +STATIC int
> > +xfs_scrub_directory_free_bestfree(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_da_args		*args,
> > +	xfs_dablk_t			lblk)
> > +{
> > +	struct xfs_dir3_icfree_hdr	freehdr;
> > +	struct xfs_buf			*dbp;
> > +	struct xfs_buf			*bp;
> > +	__be16				*bestp;
> > +	__be16				best;
> > +	int				i;
> > +	int				error;
> > +
> > +	/* Read the free space block */
> > +	error = xfs_dir2_free_read(sc->tp, sc->ip, lblk, &bp);
> > +	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
> > +		goto out;
> > +
> > +	/* Check all the entries. */
> > +	sc->ip->d_ops->free_hdr_from_disk(&freehdr, bp->b_addr);
> > +	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
> > +	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
> > +		best = be16_to_cpu(*bestp);
> > +		if (best == NULLDATAOFF)
> > +			continue;
> > +		error = xfs_dir3_data_read(sc->tp, sc->ip,
> > +				(freehdr.firstdb + i) * args->geo->fsbcount,
> > +				-1, &dbp);
> > +		if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
> > +			continue;
> > +		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
> > +		xfs_trans_brelse(sc->tp, dbp);
> > +	}
> > +out:
> > +	return error;
> > +}
> > +
> > +/* Check free space information in directories. */
> > +STATIC int
> > +xfs_scrub_directory_blocks(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_bmbt_irec		got;
> > +	struct xfs_da_args		args;
> > +	struct xfs_ifork		*ifp;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	xfs_fileoff_t			leaf_lblk;
> > +	xfs_fileoff_t			free_lblk;
> > +	xfs_fileoff_t			lblk;
> > +	xfs_extnum_t			idx;
> > +	bool				found;
> > +	int				is_block = 0;
> > +	int				error;
> > +
> > +	/* Ignore local format directories. */
> > +	if (sc->ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> > +	    sc->ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
> > +		return 0;
> > +
> > +	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
> > +	lblk = XFS_B_TO_FSB(mp, XFS_DIR2_DATA_OFFSET);
> > +	leaf_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_LEAF_OFFSET);
> > +	free_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_FREE_OFFSET);
> > +
> > +	/* Is this a block dir? */
> > +	args.dp = sc->ip;
> > +	args.geo = mp->m_dir_geo;
> > +	args.trans = sc->tp;
> > +	error = xfs_dir2_isblock(&args, &is_block);
> > +	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, lblk, &error))
> > +		goto out;
> > +
> > +	/* Iterate all the data extents in the directory... */
> > +	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
> > +	while (found) {
> > +		/* No more data blocks... */
> > +		if (got.br_startoff >= leaf_lblk)
> > +			break;
> 
> If it's a block dir and got.br_startoff > 0, then it's corrupt?

Or if got.br_blockcount != mp->m_dir_geo->fsbcount, right?

> > +
> > +		/* Check each data block's bestfree data */
> > +		for (lblk = roundup((xfs_dablk_t)got.br_startoff,
> > +				args.geo->fsbcount);
> > +		     lblk < got.br_startoff + got.br_blockcount;
> > +		     lblk += args.geo->fsbcount) {
> 
> This is not obvious as to why it works with discontiguous directory
> blocks. I think it's because it grabs the aligned start block of
> each directory block and then internally the blocks get mapped
> correctly via the directory block read functions, but this
> definitely needs a better comment explaining the iteration mechanism
> being used here....
> 
> > +			error = xfs_scrub_directory_data_bestfree(sc, lblk,
> > +					is_block);
> > +			if (error)
> > +				goto out;
> > +		}
> > +
> > +		found = xfs_iext_get_extent(ifp, ++idx, &got);
> 
> As it is, I think this is going to check discontiguous directory
> blocks multiple times. It's going to find each extent in a
> discontiguous dir block, round it up to the next dirblock and
> scan that next dirblock. It then finds the next block in the
> current discontig block, rounds it up to the next dirblock, and
> scans it again....
> 
> I think it would be much better to use xfs_iext_lookup_extent() here
> to iterate by expected start block rather than iterating by extent
> index.

Ok.  I'll add in a comment explaining what we're doing, and change the
directory lookup to round up to the next expected directory block
offset:

/*
 * Check each data block's bestfree data.
 *
 * Iterate all the fsbcount-aligned block offsets in
 * this directory.  The directory block reading code is
 * smart enough to do its own bmap lookups to handle
 * discontiguous directory blocks.  When we're done
 * with the extent record, re-query the bmap at the
 * next fsbcount-aligned offset to avoid redundant
 * block checks.
 */
for (lblk = roundup((xfs_dablk_t)got.br_startoff,
		args.geo->fsbcount);
     lblk < got.br_startoff + got.br_blockcount;
     lblk += args.geo->fsbcount) {
	error = xfs_scrub_directory_data_bestfree(sc, lblk,
			is_block);
	if (error)
		goto out;
}
lblk = roundup((xfs_dablk_t)got.br_startoff + got.br_blockcount,
		args.geo->fsbcount);
found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);

Likewise for the free block iteration.

> > +	}
> > +
> > +	/* Look for a leaf1 block, which has free info. */
> > +	if (xfs_iext_lookup_extent(sc->ip, ifp, leaf_lblk, &idx, &got) &&
> > +	    got.br_startoff == leaf_lblk &&
> > +	    got.br_blockcount == args.geo->fsbcount &&
> > +	    !xfs_iext_get_extent(ifp, ++idx, &got)) {
> > +		if (is_block) {
> > +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +			goto not_leaf1;
> 
> Can just abort the scrub at this point.

Yes.  I'll also abort on corruption prior to the free_lblk scan.

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
