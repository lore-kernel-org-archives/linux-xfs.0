Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:57252 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbfDQWt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 18:49:57 -0400
Date: Thu, 18 Apr 2019 08:30:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: add online scrub/repair for superblock counters
Message-ID: <20190417223052.GU29573@dread.disaster.area>
References: <155546519998.176278.8300210828717055034.stgit@magnolia>
 <155546522160.176278.12189319767486072198.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155546522160.176278.12189319767486072198.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 16, 2019 at 06:40:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach online scrub and repair how to check and reset the superblock
> inode and block counters.  The AG rebuilding functions will need these
> to adjust the counts if they need to change as a part of recovering from
> corruption.  We must use the repair freeze mechanism to prevent any
> other changes while we do this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> +/*
> + * FS Summary Counters
> + * ===================
> + *
> + * The basics of filesystem summary counter checking are that we iterate the
> + * AGs counting the number of free blocks, free space btree blocks, per-AG
> + * reservations, inodes, delayed allocation reservations, and free inodes.
> + * Then we compare what we computed against the in-core counters.
> + *
> + * However, the reality is that summary counters are a tricky beast to check.
> + * While we /could/ freeze the filesystem and scramble around the AGs counting
> + * the free blocks, in practice we prefer not do that for a scan because
> + * freezing is costly.  To get around this, we added a per-cpu counter of the
> + * delalloc reservations so that we can rotor around the AGs relatively
> + * quickly, and we allow the counts to be slightly off because we're not
> + * taking any locks while we do this.
> + */
> +
> +int
> +xchk_setup_fscounters(
> +	struct xfs_scrub	*sc,
> +	struct xfs_inode	*ip)
> +{
> +	sc->buf = kmem_zalloc(sizeof(struct xchk_fscounters), KM_SLEEP);
> +	if (!sc->buf)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Pause background reclaim while we're scrubbing to reduce the
> +	 * likelihood of background perturbations to the counters throwing
> +	 * off our calculations.
> +	 */
> +	xchk_disable_reclaim(sc);

Naming :)

> +
> +	return xchk_trans_alloc(sc, 0);
> +}
> +
> +/*
> + * Calculate what the global in-core counters ought to be from the AG header
> + * contents.  Callers can compare this to the actual in-core counters to
> + * calculate by how much both in-core and on-disk counters need to be
> + * adjusted.
> + */
> +STATIC int
> +xchk_fscounters_calc(
> +	struct xfs_scrub	*sc,
> +	struct xchk_fscounters	*fsc)
> +{
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_buf		*agi_bp;
> +	struct xfs_buf		*agf_bp;
> +	struct xfs_agi		*agi;
> +	struct xfs_agf		*agf;
> +	struct xfs_perag	*pag;
> +	uint64_t		delayed;
> +	xfs_agnumber_t		agno;
> +	int			error;
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		/* Lock both AG headers. */
> +		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
> +		if (error)
> +			return error;
> +		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
> +		if (error)
> +			return error;
> +		if (!agf_bp)
> +			return -ENOMEM;
> +
> +		/* Count all the inodes */
> +		agi = XFS_BUF_TO_AGI(agi_bp);
> +		fsc->icount += be32_to_cpu(agi->agi_count);
> +		fsc->ifree += be32_to_cpu(agi->agi_freecount);
> +
> +		/* Add up the free/freelist/bnobt/cntbt blocks */
> +		agf = XFS_BUF_TO_AGF(agf_bp);
> +		fsc->fdblocks += be32_to_cpu(agf->agf_freeblks);
> +		fsc->fdblocks += be32_to_cpu(agf->agf_flcount);
> +		fsc->fdblocks += be32_to_cpu(agf->agf_btreeblks);
> +
> +		/*
> +		 * Per-AG reservations are taken out of the incore counters,
> +		 * so they must be left out of the free blocks computation.
> +		 */
> +		pag = xfs_perag_get(mp, agno);
> +		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
> +		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
> +		xfs_perag_put(pag);
> +
> +		xfs_trans_brelse(sc->tp, agf_bp);
> +		xfs_trans_brelse(sc->tp, agi_bp);
> +	}

Hmmmm. Do we have all these counters in the perag? If we do, we've
already checked them against the on-disk structures, yes? So can we
just do a pass across the perags to sum the space usage?

And if we don't ahve them all in the perag, should we add them?

> +
> +	/*
> +	 * The global incore space reservation is taken from the incore
> +	 * counters, so leave that out of the computation.
> +	 */
> +	fsc->fdblocks -= mp->m_resblks_avail;
> +
> +	/*
> +	 * Delayed allocation reservations are taken out of the incore counters
> +	 * but not recorded on disk, so leave them and their indlen blocks out
> +	 * of the computation.
> +	 */
> +	delayed = percpu_counter_sum(&mp->m_delalloc_blks);
> +	fsc->fdblocks -= delayed;
> +
> +	trace_xchk_fscounters_calc(mp, fsc->icount, fsc->ifree, fsc->fdblocks,
> +			delayed);
> +
> +	/* Bail out if the values we compute are totally nonsense. */
> +	if (!xfs_verify_icount(mp, fsc->icount) ||
> +	    fsc->fdblocks > mp->m_sb.sb_dblocks ||
> +	    fsc->ifree > fsc->icount)
> +		return -EFSCORRUPTED;

I suspect we need some tolerance here on ifree vs icount as icount
can decrease as we free inode chunks....

> +/*
> + * Is the @counter within an acceptable range of @expected?
> + *
> + * Currently that means 1/16th (6%) or @nr_range of the @expected value.
> + */

6% is a lot for large filesystems, especially for block counts. That
can be entire AGs missing. I suspect the tolerance should be
related to AG count in some way....

> +static inline bool
> +xchk_fscounter_within_range(
> +	struct xfs_scrub	*sc,
> +	struct percpu_counter	*counter,
> +	uint64_t		expected,
> +	uint64_t		nr_range)
> +{
> +	int64_t			value = percpu_counter_sum(counter);
> +	uint64_t		range;
> +
> +	range = max_t(uint64_t, expected >> 4, nr_range);
> +	if (value < 0)
> +		return false;
> +	if (range < expected && value < expected - range)
> +		return false;
> +	if ((int64_t)(expected + range) >= 0 && value > expected + range)
> +		return false;
> +	return true;
> +}
> +
> +/* Check the superblock counters. */
> +int
> +xchk_fscounters(
> +	struct xfs_scrub	*sc)
> +{
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xchk_fscounters	*fsc = sc->buf;
> +	int64_t			icount, ifree, fdblocks;
> +	int			error;
> +
> +	icount = percpu_counter_sum(&sc->mp->m_icount);
> +	ifree = percpu_counter_sum(&sc->mp->m_ifree);
> +	fdblocks = percpu_counter_sum(&sc->mp->m_fdblocks);

We have a local mp var in this function :)

> +
> +	if (icount < 0 || ifree < 0 || fdblocks < 0)
> +		xchk_block_set_corrupt(sc, mp->m_sb_bp);
> +
> +	/* See if icount is obviously wrong. */
> +	if (!xfs_verify_icount(mp, icount))
> +		xchk_block_set_corrupt(sc, mp->m_sb_bp);
> +
> +	/* See if fdblocks / ifree are obviously wrong. */
> +	if (fdblocks > mp->m_sb.sb_dblocks)
> +		xchk_block_set_corrupt(sc, mp->m_sb_bp);
> +	if (ifree > icount)
> +		xchk_block_set_corrupt(sc, mp->m_sb_bp);
> +
> +	/* If we already know it's bad, we can skip the AG iteration. */
> +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		return 0;
> +
> +	/* Counters seem ok, but let's count them. */
> +	error = xchk_fscounters_calc(sc, fsc);
> +	if (!xchk_process_error(sc, 0, XFS_SB_BLOCK(sc->mp), &error))
> +		return error;
> +
> +	/*
> +	 * Compare the in-core counters with whatever we counted.  We'll
> +	 * consider the inode counts ok if they're within 1024 inodes, and the
> +	 * free block counts if they're within 1/64th of the filesystem size.
> +	 */
> +	if (!xchk_fscounter_within_range(sc, &mp->m_icount, fsc->icount, 1024))
> +		xchk_block_set_corrupt(sc, mp->m_sb_bp);

We've already summed the percpu counters at this point - why do we
pass them into xchk_fscounter_within_range() and them sum them
again?

Also, what's the magic 1024 here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
