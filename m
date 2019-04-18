Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42380 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfDRXjQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Apr 2019 19:39:16 -0400
Date: Thu, 18 Apr 2019 16:39:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: add online scrub/repair for superblock counters
Message-ID: <20190418233912.GB4787@magnolia>
References: <155546519998.176278.8300210828717055034.stgit@magnolia>
 <155546522160.176278.12189319767486072198.stgit@magnolia>
 <20190417223052.GU29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417223052.GU29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

[This reply is only about the thresholding stuff...]

On Thu, Apr 18, 2019 at 08:30:52AM +1000, Dave Chinner wrote:
> On Tue, Apr 16, 2019 at 06:40:21PM -0700, Darrick J. Wong wrote:

<snip>

> > +/*
> > + * Is the @counter within an acceptable range of @expected?
> > + *
> > + * Currently that means 1/16th (6%) or @nr_range of the @expected value.
> > + */
> 
> 6% is a lot for large filesystems, especially for block counts. That
> can be entire AGs missing. I suspect the tolerance should be
> related to AG count in some way....

Agreed, 6% is a lot, especially since that's large enough to swallow
several entire AGs.  The other approach (which I've also been testing)
is that we base the threshold on the delta between the
percpu_counter_sum at the start of xchk_fscounters and the second call
in _within_range -- the more that it changes while we're racing to
compute the expected value, the more we let the counter be off by, with
some minimum amount of variance that we tolerate.

Prior to this review, the runtime of the _calc function varied quite a
bit when the fs was running a heavy load because of buffer lock
contention, which made the amount of variance fairly unstable even with
a fairly steady IO load on the filesystem, so I sent the simpler
version.

However, your suggestion of using only the incore perag counters cuts
the runtime down to nearly zero even on crazy-agcount filesystems since
that cuts the synchronization overhead way down, which means that the
counter variance has stabilized and no longer seems quite so crazy of a
way to do it.

Now we have:

counter = percpu_counter_sum()
range = min(512, 2 * (old_counter - counter))
counter >= (expected - range) && counter <= (expected + range)

Granted that 1024 (now 512) value that I use now is more or less
arbitrarily picked to prevent complaints while providing a solid check
that we're at least in the ballpark.

Patches soon,

--D

> > +static inline bool
> > +xchk_fscounter_within_range(
> > +	struct xfs_scrub	*sc,
> > +	struct percpu_counter	*counter,
> > +	uint64_t		expected,
> > +	uint64_t		nr_range)
> > +{
> > +	int64_t			value = percpu_counter_sum(counter);
> > +	uint64_t		range;
> > +
> > +	range = max_t(uint64_t, expected >> 4, nr_range);
> > +	if (value < 0)
> > +		return false;
> > +	if (range < expected && value < expected - range)
> > +		return false;
> > +	if ((int64_t)(expected + range) >= 0 && value > expected + range)
> > +		return false;
> > +	return true;
> > +}
> > +
> > +/* Check the superblock counters. */
> > +int
> > +xchk_fscounters(
> > +	struct xfs_scrub	*sc)
> > +{
> > +	struct xfs_mount	*mp = sc->mp;
> > +	struct xchk_fscounters	*fsc = sc->buf;
> > +	int64_t			icount, ifree, fdblocks;
> > +	int			error;
> > +
> > +	icount = percpu_counter_sum(&sc->mp->m_icount);
> > +	ifree = percpu_counter_sum(&sc->mp->m_ifree);
> > +	fdblocks = percpu_counter_sum(&sc->mp->m_fdblocks);
> 
> We have a local mp var in this function :)
> 
> > +
> > +	if (icount < 0 || ifree < 0 || fdblocks < 0)
> > +		xchk_block_set_corrupt(sc, mp->m_sb_bp);
> > +
> > +	/* See if icount is obviously wrong. */
> > +	if (!xfs_verify_icount(mp, icount))
> > +		xchk_block_set_corrupt(sc, mp->m_sb_bp);
> > +
> > +	/* See if fdblocks / ifree are obviously wrong. */
> > +	if (fdblocks > mp->m_sb.sb_dblocks)
> > +		xchk_block_set_corrupt(sc, mp->m_sb_bp);
> > +	if (ifree > icount)
> > +		xchk_block_set_corrupt(sc, mp->m_sb_bp);
> > +
> > +	/* If we already know it's bad, we can skip the AG iteration. */
> > +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +		return 0;
> > +
> > +	/* Counters seem ok, but let's count them. */
> > +	error = xchk_fscounters_calc(sc, fsc);
> > +	if (!xchk_process_error(sc, 0, XFS_SB_BLOCK(sc->mp), &error))
> > +		return error;
> > +
> > +	/*
> > +	 * Compare the in-core counters with whatever we counted.  We'll
> > +	 * consider the inode counts ok if they're within 1024 inodes, and the
> > +	 * free block counts if they're within 1/64th of the filesystem size.
> > +	 */
> > +	if (!xchk_fscounter_within_range(sc, &mp->m_icount, fsc->icount, 1024))
> > +		xchk_block_set_corrupt(sc, mp->m_sb_bp);
> 
> We've already summed the percpu counters at this point - why do we
> pass them into xchk_fscounter_within_range() and them sum them
> again?
> 
> Also, what's the magic 1024 here?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
