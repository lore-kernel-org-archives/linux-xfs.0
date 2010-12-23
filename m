Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN1gH0l067811 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:42:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 186ED1478819
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 17:44:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	5opt0qGBGz5pskFp for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 17:44:14 -0800 (PST)
Date: Thu, 23 Dec 2010 12:44:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: add FITRIM support
Message-ID: <20101223014409.GL4907@dastard>
References: <20101125112304.GA4195@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101125112304.GA4195@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Nov 25, 2010 at 06:23:04AM -0500, Christoph Hellwig wrote:
> Allow manual discards from userspace using the FITRIM ioctl.  This is not
> intended to be run during normal workloads, as the freepsace btree walks
> can cause large performance degradation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....

> +STATIC int
> +xfs_trim_extents(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_fsblock_t		start,
> +	xfs_fsblock_t		len,
> +	xfs_fsblock_t		minlen)
> +{
> +	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_buf		*agbp;
> +	struct xfs_perag	*pag;
> +	int			error;
> +	int			i;
> +
> +	pag = xfs_perag_get(mp, agno);
> +
> +	error = xfs_alloc_read_agf(mp, NULL, agno,
> +				   XFS_ALLOC_FLAG_TRYLOCK, &agbp);
> +	if (error || !agbp) {
> +		if (error == EAGAIN)
> +			error = 0;
> +		goto out_put_perag;
> +	}
> +
> +	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
> +
> +	/*
> +	 * Force out the log.  This means any transactions that might have freed
> +	 * space before we took the AGF buffer lock are now on disk, and the
> +	 * volatile disk cache is flushed.
> +	 */
> +	xfs_log_force(mp, XFS_LOG_SYNC);
> +
> +	/*
> +	 * Look up the longest btree in the AGF and start with it.
> +	 */
> +	error = xfs_alloc_lookup_le(cur, 0,
> +				    XFS_BUF_TO_AGF(agbp)->agf_longest, &i);
> +	if (error)
> +		goto out_del_cursor;
> +
> +	/*
> +	 * Loop until we are done with all extents that are large
> +	 * enough to be worth discarding.
> +	 */
> +	while (i) {
> +		xfs_agblock_t fbno;
> +		xfs_extlen_t flen;
> +
> +		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
> +		if (error)
> +			goto out_del_cursor;
> +		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
> +		ASSERT(flen <= XFS_BUF_TO_AGF(agbp)->agf_longest);
> +
> +		/*
> +		 * Too small?  Give up.
> +		 */
> +		if (flen < minlen) {
> +			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
> +			goto out_del_cursor;
> +		}
> +
> +		/*
> +		 * If the extent is entirely outside of the range we are
> +		 * supposed to discard skip it.  Do not bother to trim
> +		 * down partially overlapping ranges for now.
> +		 */
> +		if (XFS_AGB_TO_FSB(mp, agno, fbno) + flen < start ||
> +		    XFS_AGB_TO_FSB(mp, agno, fbno) > start + len) {
> +			trace_xfs_discard_exclude(mp, agno, fbno, flen);
> +			goto next_extent;
> +		}

Hmmmm - if we are given a range to trim, wouldn't we do better to
walk the by-bno btree instead?  i.e, we have two different cases
here - trim an entire AG, and trim part of an AG given by {start, end}. 

We only need these range checks on the AGs that are only partially
trimmed, and it would seem more efficient to me to walk the by-bno
tree for those rather than walk the by-size tree trying to find
range matches.

> +
> +		/*
> +		 * If any blocks in the range are still busy, skip the
> +		 * discard and try again the next time.
> +		 */
> +		if (xfs_alloc_busy_search(mp, agno, fbno, flen)) {
> +			trace_xfs_discard_busy(mp, agno, fbno, flen);
> +			goto next_extent;
> +		}
> +
> +		trace_xfs_discard_extent(mp, agno, fbno, flen);
> +		error = -blkdev_issue_discard(bdev,
> +				XFS_AGB_TO_DADDR(mp, agno, fbno),
> +				XFS_FSB_TO_BB(mp, flen),
> +				GFP_NOFS, 0);
> +		if (error)
> +			goto out_del_cursor;
> +
> +next_extent:
> +		error = xfs_btree_decrement(cur, 0, &i);
> +		if (error)
> +			goto out_del_cursor;
> +	}

Hmmm - so we hold the agf locked for the entire trim? That's a bit
ugly. Given this is best effort, we could avoid this by changing it
to something like:

	longest = 0;
	do {
		lock agf
		force log
		if (!longest)
			longest = agf->longest
		init cursor
		do {
			xfs_alloc_lookup_le(longest)
			alloc_get_rec(&fbno, &flen)
			check flen
			busy search
			discard
			decrement cursor
		} while (flen == longest)
		destroy cursor
		unlock agf
		longest = flen;
	} while(1)

This way we walk the tree in a manner that does not hold the agf for
extended periods of time, but still catches all the extents of the
same size and, when idle, will catch all the extents longer than the
given length to discard. If the filesystem is busy, it will have
much less impact on it due to the much short AGF hold times.

And perhaps the inner loop could simply be terminated on the number
of discards issued or a timer to keep the number of log forces down
to a sane number (e.g. one every 50ms).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
