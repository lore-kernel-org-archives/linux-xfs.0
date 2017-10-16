Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40797 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdJPWhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 18:37:13 -0400
Date: Mon, 16 Oct 2017 15:37:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 25/30] xfs: scrub directory freespace
Message-ID: <20171016223708.GR4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777260602.1724.16339769636569418352.stgit@magnolia>
 <20171016044921.GB3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016044921.GB3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 03:49:21PM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2017 at 06:43:26PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check the free space information in a directory.
> 
> ....
> 
> > diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> > index e2a8f90..a41310f 100644
> > --- a/fs/xfs/scrub/dir.c
> > +++ b/fs/xfs/scrub/dir.c
> > @@ -250,6 +250,426 @@ xfs_scrub_dir_rec(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Is this unused entry either in the bestfree or smaller than all of them?
> > + * We assume the bestfrees are sorted longest to shortest, and that there
> > + * aren't any bogus entries.
> 
> s/We assume/We've already checked/

Ok.

> > + */
> > +static inline void
> > +xfs_scrub_directory_check_free_entry(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_dablk_t			lblk,
> > +	struct xfs_dir2_data_free	*bf,
> > +	struct xfs_dir2_data_unused	*dup)
> 
> ....
> 
> > +	while (ptr < endptr) {
> > +		dup = (struct xfs_dir2_data_unused *)ptr;
> > +		/* Skip real entries */
> > +		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG)) {
> > +			struct xfs_dir2_data_entry	*dep;
> > +
> > +			dep = (struct xfs_dir2_data_entry *)ptr;
> > +			newlen = d_ops->data_entsize(dep->namelen);
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
> I'd prefer this matches the loop logic order. ie.
> 
> 		if (ptr >= endptr)
> 

Ok.  That check can be lifted out of the loop anyway.

> > +		else
> > +			nr_frees++;
> > +	}
> > +
> > +	/* Did we see at least as many free slots as there are bestfrees? */
> > +	if (nr_frees < nr_bestfrees)
> > +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +out_buf:
> > +	xfs_trans_brelse(sc->tp, bp);
> > +out:
> > +	return error;
> > +}
> > +
> > +/*
> > + * Does the free space length in the free space index block ($len) match
> > + * the longest length in the directory data block's bestfree array?
> > + * Assume that we've already checked that the data block's bestfree
> > + * array is in order.
> > + */
> > +static inline void
> > +xfs_scrub_directory_check_freesp(
> 
> No need for inline here, the compiler will do that automatically if
> appropriate.

Ok.  I'll make it STATIC like everything else here.

> > +	struct xfs_scrub_context	*sc,
> > +	xfs_dablk_t			lblk,
> > +	struct xfs_buf			*dbp,
> > +	unsigned int			len)
> > +{
> > +	struct xfs_dir2_data_free	*bf;
> > +	struct xfs_dir2_data_free	*dfp;
> > +	int				offset;
> > +
> > +	if (len == 0)
> > +		return;
> > +
> > +	bf = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
> > +	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
> > +		offset = be16_to_cpu(dfp->offset);
> > +		if (offset == 0)
> > +			break;
> > +		if (len == be16_to_cpu(dfp->length))
> > +			return;
> > +		/* Didn't find the best length in the bestfree data */
> > +		break;
> > +	}
> > +
> > +	xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +}
> > +
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
> > +	/*
> > +	 * Read the free space block.  The verifier will check for hash
> > +	 * value ordering problems and check the stale entry count.
> > +	 */
> > +	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
> > +	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
> > +		goto out;
> > +
> > +	/* Check all the entries. */
> > +	ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, bp->b_addr);
> > +	bestp = xfs_dir2_leaf_bests_p(ltp);
> > +	for (i = 0; i < be32_to_cpu(ltp->bestcount); i++, bestp++) {
> > +		best = be16_to_cpu(*bestp);
> > +		if (best == NULLDATAOFF)
> > +			continue;
> 
> Count stale entries, check if matches hdr->stale ?

This should already be done by xfs_dir3_leaf_read ->
xfs_dir3_leaf1_read_verify -> __read_verify -> xfs_dir3_leaf_verify ->
xfs_dir3_leaf_check_int, right?

> 
> > +		error = xfs_dir3_data_read(sc->tp, sc->ip,
> > +				i * args->geo->fsbcount, -1, &dbp);
> > +		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
> > +				&error))
> > +			continue;
> > +		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
> > +		xfs_trans_brelse(sc->tp, dbp);
> > +	}
> > +out:
> > +	return error;
> > +}
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
> > +	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
> > +		goto out;
> > +
> > +	/* Check all the entries. */
> > +	sc->ip->d_ops->free_hdr_from_disk(&freehdr, bp->b_addr);
> > +	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
> > +	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
> > +		best = be16_to_cpu(*bestp);
> > +		if (best == NULLDATAOFF)
> > +			continue;
> 
> Count stale entries, check freehdr.nvalid + stale = freehdr.nused?

Aha, yes, that needs to be checked.

Also that for loop needs to be terminated on i < freehdr.nused.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
