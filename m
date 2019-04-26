Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfDZBce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Apr 2019 21:32:34 -0400
Date: Thu, 25 Apr 2019 18:32:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs: add online scrub for superblock counters
Message-ID: <20190426013218.GK178290@magnolia>
References: <155563325882.112668.3605935077532891922.stgit@magnolia>
 <155563328923.112668.18007995408695103782.stgit@magnolia>
 <20190425233059.GF29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425233059.GF29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 26, 2019 at 09:30:59AM +1000, Dave Chinner wrote:
> On Thu, Apr 18, 2019 at 05:21:29PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Teach online scrub how to check the filesystem summary counters.  We use
> > the incore delalloc block counter along with the incore AG headers to
> > compute expected values for fdblocks, icount, and ifree, and then check
> > that the percpu counter is within a certain threshold of the expected
> > value.  This is done to avoid having to freeze or otherwise lock the
> > filesystem, which means that we're only checking that the counters are
> > fairly close, not that they're exactly correct.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> > --- /dev/null
> > +++ b/fs/xfs/scrub/fscounters.c
> > @@ -0,0 +1,348 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_format.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_btree.h"
> > +#include "xfs_bit.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_sb.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_alloc.h"
> > +#include "xfs_ialloc.h"
> > +#include "xfs_rmap.h"
> > +#include "xfs_error.h"
> > +#include "xfs_errortag.h"
> > +#include "xfs_icache.h"
> > +#include "xfs_health.h"
> > +#include "xfs_bmap.h"
> > +#include "scrub/xfs_scrub.h"
> > +#include "scrub/scrub.h"
> > +#include "scrub/common.h"
> > +#include "scrub/trace.h"
> > +
> > +/*
> > + * FS Summary Counters
> > + * ===================
> > + *
> > + * The basics of filesystem summary counter checking are that we iterate the
> > + * AGs counting the number of free blocks, free space btree blocks, per-AG
> > + * reservations, inodes, delayed allocation reservations, and free inodes.
> > + * Then we compare what we computed against the in-core counters.
> > + *
> > + * However, the reality is that summary counters are a tricky beast to check.
> > + * While we /could/ freeze the filesystem and scramble around the AGs counting
> > + * the free blocks, in practice we prefer not do that for a scan because
> > + * freezing is costly.  To get around this, we added a per-cpu counter of the
> > + * delalloc reservations so that we can rotor around the AGs relatively
> > + * quickly, and we allow the counts to be slightly off because we're not
> > + * taking any locks while we do this.
> > + *
> > + * So the first thing we do is warm up the buffer cache in the setup routine
> > + * by walking all the AGs to make sure the incore per-AG structure has been
> > + * initialized.  The expected value calculation then iterates the incore per-AG
> > + * structures as quickly as it can.  We snapshot the percpu counters before and
> > + * after this operation and use the difference in counter values to guess at
> > + * our tolerance for mismatch between expected and actual counter values.
> > + */
> > +
> > +/*
> > + * Since the expected value computation is lockless but only browses incore
> > + * values, the percpu counters should be fairly close to each other.  However,
> > + * we'll allow ourselves to be off by at least this (arbitrary) amount.
> > + */
> > +#define XCHK_FSC_MIN_VARIANCE	(512)
> > +
> > +/*
> > + * Make sure the per-AG structure has been initialized from the on-disk header
> > + * contents and that the incore counters match the ondisk counters.  Do this
> > + * from the setup function so that the inner summation loop runs as quickly
> > + * as possible.
> > + */
> > +STATIC int
> > +xchk_fsc_warmup(
> > +	struct xfs_scrub	*sc)
> > +{
> > +	struct xfs_mount	*mp = sc->mp;
> > +	struct xfs_buf		*agi_bp = NULL;
> > +	struct xfs_buf		*agf_bp = NULL;
> > +	struct xfs_agi		*agi;
> > +	struct xfs_agf		*agf;
> > +	struct xfs_perag	*pag = NULL;
> > +	xfs_agnumber_t		agno;
> > +	int			error = 0;
> > +
> > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > +		/* Lock both AG headers. */
> > +		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
> > +		if (error)
> > +			break;
> > +		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
> > +		if (error)
> > +			break;
> > +		error = -ENOMEM;
> > +		if (!agf_bp)
> > +			break;
> > +
> > +		pag = xfs_perag_get(mp, agno);
> > +
> > +		/*
> > +		 * These are supposed to be initialized by the header read
> > +		 * function.
> > +		 */
> > +		error = -EFSCORRUPTED;
> > +		if (!pag->pagi_init || !pag->pagf_init)
> > +			break;
> > +
> > +		/* Spot-check the incore counters against the ondisk headers */
> > +		agi = XFS_BUF_TO_AGI(agi_bp);
> > +		agf = XFS_BUF_TO_AGF(agf_bp);
> > +		if (pag->pagi_count != be32_to_cpu(agi->agi_count))
> > +			break;
> > +		if (pag->pagi_freecount != be32_to_cpu(agi->agi_freecount))
> > +			break;
> > +		if (pag->pagf_freeblks != be32_to_cpu(agf->agf_freeblks))
> > +			break;
> > +		if (pag->pagf_flcount != be32_to_cpu(agf->agf_flcount))
> > +			break;
> > +		if (pag->pagf_btreeblks != be32_to_cpu(agf->agf_btreeblks))
> > +			break;
> > +
> > +		xfs_perag_put(pag);
> > +		pag = NULL;
> > +		xfs_buf_relse(agf_bp);
> > +		agf_bp = NULL;
> > +		xfs_buf_relse(agi_bp);
> > +		agi_bp = NULL;
> > +		error = 0;
> > +	}
> 
> 
> This will work, but it's going to be expensive on a high AG count
> filesystem (2 synchronous reads per AG). On multi-PB filesystems
> under memory pressure, this could require tens of thousands of IOs
> to be done, and on slow/overloaded disks this could take tens of
> minutes or even hours just to do this initial check.
> 
> Perhaps we should start thinking about this sort of loop as an async
> read with a special verifier to check the pag values and store the
> result in the pag?

An async "read all the AG headers and do something with them" loop, for
sure.  I can think of a few more places where this sort of loop would be
/very/ helpful: (1) the post log recovery summary counter recalculation,
(2) calculating per-AG reservations at mount/remount/whatever time, and
(3) this here scrubber.

I've been working on threading quotacheck this week and think it would
be pretty easy to adapt these "scan the whole world" loops to use the
thread queue.

> After all, the pag will be attached to the buffer
> and available at IO completion, and this way we can just rattle off
> IO submission then when we do the incore pag walk we can look for
> the "check good/bad" flag in the pag and only wait if neither are
> set?

<nod> If we're willing to trust system memory == ondisk contents then we
can optimize this further via "if (pag->pagf_init && pag->pagi_init)
continue;" so we don't have to pull the AG headers back into memory if
they happened to have fallen out.

Hmm, seeing as we've just patched the AGF/AGI scrubbers to check the
xfs_perag fields against the ondisk contents I think I'm fine with
making that little tweak.

> This will allow the AGF/AGI IOs to be merged at the block layer
> (immediate 50% reduction in IO), and we'll only get throttled on
> submission when the queue gets too long. This will greatly reduce
> the "warmup" pre-check time, especially if the disk is loaded and
> individual IO times are measured in tens to hundreds of
> milliseconds...
> 
> Perhaps this can be done as a followup series?

Yes, definitely.

> 
> 
> > +int
> > +xchk_setup_fscounters(
> > +	struct xfs_scrub	*sc,
> > +	struct xfs_inode	*ip)
> > +{
> > +	int			error;
> > +
> > +	sc->buf = kmem_zalloc(sizeof(struct xchk_fscounters), KM_SLEEP);
> > +	if (!sc->buf)
> > +		return -ENOMEM;
> > +
> > +	/* We must get the incore counters set up before we can proceed. */
> > +	error = xchk_fsc_warmup(sc);
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * Pause background reclaim while we're scrubbing to reduce the
> > +	 * likelihood of background perturbations to the counters throwing
> > +	 * off our calculations.
> > +	 */
> > +	xchk_stop_reaping(sc);
> > +
> > +	return xchk_trans_alloc(sc, 0);
> > +}
> > +
> > +/*
> > + * Calculate what the global in-core counters ought to be from the incore
> > + * per-AG structure.  Callers can compare this to the actual in-core counters
> > + * to estimate by how much both in-core and on-disk counters need to be
> > + * adjusted.
> > + */
> > +STATIC int
> > +xchk_fsc_calc(
> > +	struct xfs_scrub	*sc,
> > +	struct xchk_fscounters	*fsc)
> > +{
> > +	struct xfs_mount	*mp = sc->mp;
> > +	struct xfs_perag	*pag;
> > +	unsigned long long	min_icount, max_icount;
> > +	uint64_t		delayed;
> > +	xfs_agnumber_t		agno;
> > +	int			tries = 8;
> > +
> > +retry:
> > +	fsc->icount = 0;
> > +	fsc->ifree = 0;
> > +	fsc->fdblocks = 0;
> > +
> > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > +		pag = xfs_perag_get(mp, agno);
> > +
> > +		/* This somehow got unset since the warmup? */
> > +		if (!pag->pagi_init || !pag->pagf_init) {
> > +			xfs_perag_put(pag);
> > +			return -EFSCORRUPTED;
> > +		}
> > +
> > +		/* Count all the inodes */
> > +		fsc->icount += pag->pagi_count;
> > +		fsc->ifree += pag->pagi_freecount;
> > +
> > +		/* Add up the free/freelist/bnobt/cntbt blocks */
> > +		fsc->fdblocks += pag->pagf_freeblks;
> > +		fsc->fdblocks += pag->pagf_flcount;
> > +		fsc->fdblocks += pag->pagf_btreeblks;
> > +
> > +		/*
> > +		 * Per-AG reservations are taken out of the incore counters,
> > +		 * so they must be left out of the free blocks computation.
> > +		 */
> > +		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
> > +		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
> > +
> > +		xfs_perag_put(pag);
> > +	}
> > +
> > +	/*
> > +	 * The global incore space reservation is taken from the incore
> > +	 * counters, so leave that out of the computation.
> > +	 */
> > +	fsc->fdblocks -= mp->m_resblks_avail;
> > +
> > +	/*
> > +	 * Delayed allocation reservations are taken out of the incore counters
> > +	 * but not recorded on disk, so leave them and their indlen blocks out
> > +	 * of the computation.
> > +	 */
> > +	delayed = percpu_counter_sum(&mp->m_delalloc_blks);
> > +	fsc->fdblocks -= delayed;
> > +
> > +	trace_xchk_fscounters_calc(mp, fsc->icount, fsc->ifree, fsc->fdblocks,
> > +			delayed);
> > +
> > +	xfs_icount_range(mp, &min_icount, &max_icount);
> > +
> > +	/* Bail out if the values we compute are totally nonsense. */
> > +	if (!xfs_verify_icount(mp, fsc->icount) ||
> > +	    fsc->fdblocks > mp->m_sb.sb_dblocks ||
> > +	    fsc->ifree > max_icount)
> 
> This is basically running xfs_icount_range() twice. Get rid of the 
> xfs_verify_icount() helper and just open code it in the two places
> that use it?
> 
> Oh, actually, the other place that uses it (xfs_validate_sb_write)
> checks ifree against sb->sb_icount. I think that for this summation,
> fsc->ifree shoudl never be greater than fsc->icount, right? Because
> for every AG that is aggregated, pagi_freecount should always be
> less than or equal to pagi_count, yes?
> 
> Hence I think the call to xfs_icount_range() can go away here, and
> we just use fsc->ifree > fsc->icount...

Ok.

> 
> > +		return -EFSCORRUPTED;
> > +
> > +	/*
> > +	 * If ifree > icount then we probably had some perturbation in the
> > +	 * counters while we were calculating things.  We'll try a few times
> > +	 * to maintain ifree <= icount before giving up.
> > +	 */
> > +	if (fsc->ifree > fsc->icount) {
> > +		if (tries--)
> > +			goto retry;
> > +		return -EFSCORRUPTED;
> 
> Oh, which you do here, anyway. When do you see perturbations that
> need retries like this? Seems extremely unlikely...

Once, when racing a heavily threaded create/delete workload with the
scrubber being called in a loop.  Also I forgot that I had added things
such as OFLAG_INCOMPLETE so let's use that instead of EFSCORRUPTED.

> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Is the @counter reasonably close to the @expected value?
> > + *
> > + * We neither locked nor froze anything in the filesystem while calculating
> > + * @expected, which means that the counter could have changed.  We know the
> > + * @old_value of the counter, which means that we also know how much the counter
> > + * changed while calculating the expected value, and we'll take that as a rough
> > + * guess at how accurate we have to be.  The expected value calculation runs in
> > + * memory and never does any IO, so the window ought to be pretty small.
> > + *
> > + * First, ensure that @counter must never be negative.
> > + *
> > + * Next, compute the variance from the expected value that we'll accept.
> > + * For now we'll use twice the change in the counter from start to finish
> > + * or the minimum variance, whichever is larger.
> > + */
> > +static inline bool
> > +xchk_fsc_within_range(
> > +	struct xfs_scrub	*sc,
> > +	const int64_t		old_value,
> > +	struct percpu_counter	*counter,
> > +	uint64_t		expected)
> > +{
> > +	int64_t			curr_value = percpu_counter_sum(counter);
> > +	int64_t			range;
> > +
> > +	range = abs(2 * (curr_value - old_value));
> > +	if (range < XCHK_FSC_MIN_VARIANCE)
> > +		range = XCHK_FSC_MIN_VARIANCE;
> 
> Hmmmm. this is the difference between two summations a very short
> period apart, but that doesn't really mean anything w.r.t. the
> @expected value which was calculated over a much longer period of
> time. e.g. aggregating over 10,000 AGs vs summing over 4 CPUs and
> after 5,000 AGs were aggregated a huge file across AGs 10-1000 was
> removed. The variance of the per-cpu counters is going to be
> miniscule compared to the difference between the AG summation and
> the per-cpu counter, but the fact is that both are correct and there
> is no corruption to report.

FWIW we take the first summation before aggregating the AG and the
second summation after the AG, as I pointed out on IRC just now.

> I suspect what we should be doing is taking a summation before
> we do the per-ag aggregation, followed by a summation after the per-ag
> agg. If the per-ag result doesn't land inside the the pre- and post-
> per-cpu counter summations, then we should only report a problem if
> if the two per-cpu summations show no significant difference in values.

Yeah, I like this better.

> i.e. only if the pre- and post- summations are somewhat near to each
> other in value should we consider the per-AG aggregation value to be
> out of range, otherwise we should run the aggregation again. If the
> per-cpu summations continue to have too much change to validate the
> per-ag aggregation, then we should simply return "could not be
> validated" rather than "something is wrong"....

OFLAG_INCOMPLETE here too perhaps?

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
