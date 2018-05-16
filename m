Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47308 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbeEPQqu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 12:46:50 -0400
Date: Wed, 16 May 2018 09:46:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/22] xfs: add helpers to deal with transaction
 allocation and rolling
Message-ID: <20180516164645.GF23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642362544.1556.12056546958129943758.stgit@magnolia>
 <20180516065103.GP23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516065103.GP23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 04:51:03PM +1000, Dave Chinner wrote:
> On Tue, May 15, 2018 at 03:33:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > For repairs, we need to reserve at least as many blocks as we think
> > we're going to need to rebuild the data structure, and we're going to
> > need some helpers to roll transactions while maintaining locks on the AG
> > headers so that other threads cannot wander into the middle of a repair.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/bmap.c   |    2 -
> >  fs/xfs/scrub/common.c |   21 ++++++-
> >  fs/xfs/scrub/common.h |    2 -
> >  fs/xfs/scrub/inode.c  |    4 +
> >  fs/xfs/scrub/repair.c |  152 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/repair.h |   12 ++++
> >  6 files changed, 186 insertions(+), 7 deletions(-)
> 
> mostly looks good.
> 
> [...]
> > +/*
> > + * Figure out how many blocks to reserve for an AG repair.  We calculate the
> > + * worst case estimate for the number of blocks we'd need to rebuild one of
> > + * any type of per-AG btree.
> > + */
> > +xfs_extlen_t
> > +xfs_repair_calc_ag_resblks(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_scrub_metadata	*sm = sc->sm;
> > +	struct xfs_perag		*pag;
> > +	struct xfs_buf			*bp;
> > +	xfs_agino_t			icount = 0;
> > +	xfs_extlen_t			aglen = 0;
> > +	xfs_extlen_t			usedlen;
> > +	xfs_extlen_t			freelen;
> > +	xfs_extlen_t			bnobt_sz;
> > +	xfs_extlen_t			inobt_sz;
> > +	xfs_extlen_t			rmapbt_sz;
> > +	xfs_extlen_t			refcbt_sz;
> > +	int				error;
> > +
> > +	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
> > +		return 0;
> > +
> > +	/* Use in-core counters if possible. */
> > +	pag = xfs_perag_get(mp, sm->sm_agno);
> > +	if (pag->pagi_init)
> > +		icount = pag->pagi_count;
> > +	xfs_perag_put(pag);
> 
> Don't drop the pag here, do it ....
> > +
> > +	/*
> > +	 * Otherwise try to get the actual counters from disk; if not, make
> > +	 * some worst case assumptions.
> > +	 */
> > +	if (icount == 0) {
> > +		error = xfs_ialloc_read_agi(mp, NULL, sm->sm_agno, &bp);
> > +		if (error) {
> > +			icount = mp->m_sb.sb_agblocks / mp->m_sb.sb_inopblock;
> > +		} else {
> > +			pag = xfs_perag_get(mp, sm->sm_agno);
> > +			icount = pag->pagi_count;
> > +			xfs_perag_put(pag);
> > +			xfs_buf_relse(bp);
> > +		}
> > +	}
> > +
> > +	/* Now grab the block counters from the AGF. */
> > +	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
> > +	if (error) {
> > +		aglen = mp->m_sb.sb_agblocks;
> > +		freelen = aglen;
> > +		usedlen = aglen;
> > +	} else {
> > +		pag = xfs_perag_get(mp, sm->sm_agno);
> > +		aglen = be32_to_cpu(XFS_BUF_TO_AGF(bp)->agf_length);
> > +		freelen = pag->pagf_freeblks;
> > +		usedlen = aglen - freelen;
> > +		xfs_perag_put(pag);
> > +		xfs_buf_relse(bp);
> > +	}
> 
> .... here, so we don't have to do repeated lookups.

Ok, fixed.

> > +	trace_xfs_repair_calc_ag_resblks(mp, sm->sm_agno, icount, aglen,
> > +			freelen, usedlen);
> > +
> > +	/*
> > +	 * Figure out how many blocks we'd need worst case to rebuild
> > +	 * each type of btree.  Note that we can only rebuild the
> > +	 * bnobt/cntbt or inobt/finobt as pairs.
> > +	 */
> > +	bnobt_sz = 2 * xfs_allocbt_calc_size(mp, freelen);
> > +	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> > +		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
> > +				XFS_INODES_PER_HOLEMASK_BIT);
> > +	else
> > +		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
> > +				XFS_INODES_PER_CHUNK);
> > +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > +		inobt_sz *= 2;
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > +		rmapbt_sz = xfs_rmapbt_calc_size(mp, aglen);
> > +		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
> > +	} else {
> > +		rmapbt_sz = xfs_rmapbt_calc_size(mp, usedlen);
> > +		refcbt_sz = 0;
> > +	}
> > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > +		rmapbt_sz = 0;
> 
> This looks kinda whacky. reflink and rmapbt are different features,
> maybe a comment to explain why the rmapbt size calc is done all
> back to front?

Yeah.  Replace that whole section with:

	if (xfs_sb_version_hasreflink(&mp->m_sb))
		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
	else
		refcbt_sz = 0;
	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
		/*
		 * Guess how many blocks we need to rebuild the rmapbt.
		 * For non-reflink filesystems we can't have more
		 * records than used blocks.  However, with reflink it's
		 * possible to have more than one rmap record per AG
		 * block.  We don't know how many rmaps there could be
		 * in the AG, so we start off with what we hope is an
		 * generous over-estimation.
		 */
		if (xfs_sb_version_hasreflink(&mp->m_sb))
			rmapbt_sz = xfs_rmapbt_calc_size(mp,
					(unsigned long long)aglen * 2);
		else
			rmapbt_sz = xfs_rmapbt_calc_size(mp, usedlen);
	} else {
		rmapbt_sz = 0;
	}

--D

> 
> Otherwise looks ok.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
