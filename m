Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27426 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdJPXih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 19:38:37 -0400
Date: Mon, 16 Oct 2017 16:38:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 25/30] xfs: scrub directory freespace
Message-ID: <20171016233834.GT4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777260602.1724.16339769636569418352.stgit@magnolia>
 <20171016044921.GB3666@dastard>
 <20171016223708.GR4703@magnolia>
 <20171016231413.GM15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171016231413.GM15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2017 at 10:14:13AM +1100, Dave Chinner wrote:
> On Mon, Oct 16, 2017 at 03:37:08PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 16, 2017 at 03:49:21PM +1100, Dave Chinner wrote:
> > > On Wed, Oct 11, 2017 at 06:43:26PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Check the free space information in a directory.
> > > 
> > > ....
> > > 
> > > > +/* Check free space info in a directory leaf1 block. */
> > > > +STATIC int
> > > > +xfs_scrub_directory_leaf1_bestfree(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	struct xfs_da_args		*args,
> > > > +	xfs_dablk_t			lblk)
> > > > +{
> > > > +	struct xfs_dir2_leaf_tail	*ltp;
> > > > +	struct xfs_buf			*dbp;
> > > > +	struct xfs_buf			*bp;
> > > > +	struct xfs_mount		*mp = sc->mp;
> > > > +	__be16				*bestp;
> > > > +	__u16				best;
> > > > +	int				i;
> > > > +	int				error;
> > > > +
> > > > +	/*
> > > > +	 * Read the free space block.  The verifier will check for hash
> > > > +	 * value ordering problems and check the stale entry count.
> > > > +	 */
> > > > +	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
> > > > +	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
> > > > +		goto out;
> > > > +
> > > > +	/* Check all the entries. */
> > > > +	ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, bp->b_addr);
> > > > +	bestp = xfs_dir2_leaf_bests_p(ltp);
> > > > +	for (i = 0; i < be32_to_cpu(ltp->bestcount); i++, bestp++) {
> > > > +		best = be16_to_cpu(*bestp);
> > > > +		if (best == NULLDATAOFF)
> > > > +			continue;
> > > 
> > > Count stale entries, check if matches hdr->stale ?
> > 
> > This should already be done by xfs_dir3_leaf_read ->
> > xfs_dir3_leaf1_read_verify -> __read_verify -> xfs_dir3_leaf_verify ->
> > xfs_dir3_leaf_check_int, right?
> 
> True. However, it's simple to do and we're already iterating over
> all the structures necessary and detecting the case necessary to
> check it, so it doesn't hurt and might catch in-core corruptions
> before they hit the write verifier?

Yes, though the verifier rework series will (in addition to printing
instruction pointer addresses of the failing verifier checks) expose the
structure verification code via a new b_ops function pointer, and then
enhances scrub to call it.

(That said, from a completeness standpoint I don't mind duplicating the
code...)

> And it makes it do the same checks as the free_bestfree checks
> below....
> 
> > > > +		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
> > > > +				&error))
> > > > +			continue;
> > > > +		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
> > > > +		xfs_trans_brelse(sc->tp, dbp);
> > > > +	}
> > > > +out:
> > > > +	return error;
> > > > +}
> > > > +
> > > > +/* Check free space info in a directory freespace block. */
> > > > +STATIC int
> > > > +xfs_scrub_directory_free_bestfree(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	struct xfs_da_args		*args,
> > > > +	xfs_dablk_t			lblk)
> > > > +{
> > > > +	struct xfs_dir3_icfree_hdr	freehdr;
> > > > +	struct xfs_buf			*dbp;
> > > > +	struct xfs_buf			*bp;
> > > > +	__be16				*bestp;
> > > > +	__be16				best;
> > > > +	int				i;
> > > > +	int				error;
> > > > +
> > > > +	/* Read the free space block */
> > > > +	error = xfs_dir2_free_read(sc->tp, sc->ip, lblk, &bp);
> > > > +	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
> > > > +		goto out;
> > > > +
> > > > +	/* Check all the entries. */
> > > > +	sc->ip->d_ops->free_hdr_from_disk(&freehdr, bp->b_addr);
> > > > +	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
> > > > +	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
> > > > +		best = be16_to_cpu(*bestp);
> > > > +		if (best == NULLDATAOFF)
> > > > +			continue;
> > > 
> > > Count stale entries, check freehdr.nvalid + stale = freehdr.nused?
> > 
> > Aha, yes, that needs to be checked.
> > 
> > Also that for loop needs to be terminated on i < freehdr.nused.
> 
> Good catch - I missed that, too :P

Well.... the documentation says that nused is the number of entries that
have been filled out and nvalid is the number of entries that aren't
0xFFFF, but....

fhdr.firstdb = 0
fhdr.nvalid = 11
fhdr.nused = 9
fbests[0-10] = 0:0x60 1:0x8 3:0x10 4:0xffff 5:0x10 6:0x8 7:0x10 8:0xffff
9:0x180 10:0xe10

So the documentation is wrong w.r.t. whatever libxfs writes to disk. :)

"The freeindex’s hdr.nvalid should always be the same as the number of
allocated data directory blocks containing name/inode data and will
always be less than or equal to hdr.nused. The value of hdr.nused should
be the same as the index of the last data directory block plus one (i.e.
when the last data block is freed, nused and nvalid are decremented)."

--D

> 
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
