Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMLdJPF033470 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 15:39:19 -0600
Subject: Re: xfs: add FITRIM support
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101125112304.GA4195@infradead.org>
References: <20101125112304.GA4195@infradead.org>
Date: Wed, 22 Dec 2010 15:41:13 -0600
Message-ID: <1293054073.2408.374.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

(I actually wrote most of this last week and
finally decided it'd be better to send it than
to sit on it.)

On Thu, 2010-11-25 at 06:23 -0500, Christoph Hellwig wrote: 
> Allow manual discards from userspace using the FITRIM ioctl.  This is not
> intended to be run during normal workloads, as the freepsace btree walks
> can cause large performance degradation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I missed this when it first came through, sorry.

A few comments and questions, below.  Mostly
driven by my not knowing where to find a
reference on what (precisely) FITRIM is supposed
to do.

					-Alex

. . .

> Index: linux-2.6/fs/xfs/linux-2.6/xfs_discard.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_discard.c	2010-11-25 12:14:43.270005863 +0100
> @@ -0,0 +1,187 @@

. . .

> +
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

EAGAIN is ignored because it's an advisory interface, right?
How hard are we expected to try?  What I really mean is,
is the benefit of FITRIM enough that we should try again
later when we can get a buffer or lock on it?

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
> +
> +out_del_cursor:
> +	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_buf_relse(agbp);
> +out_put_perag:
> +	xfs_perag_put(pag);
> +	return error;
> +}
> +
> +int
> +xfs_ioc_trim(
> +	struct xfs_mount	*mp,
> +	struct fstrim_range	*urange)

        struct fstrim_range __user *urange)

> +{
> +	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
> +	unsigned int		granularity = q->limits.discard_granularity;
> +	struct fstrim_range	range;
> +	xfs_fsblock_t		start, len, minlen;
> +	xfs_agnumber_t		start_agno, end_agno, agno;
> +	int			error, last_error = 0;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -XFS_ERROR(EPERM);
> +	if (copy_from_user(&range, urange, sizeof(range)))
> +		return -XFS_ERROR(EFAULT);
> +
> +	/*
> +	 * Truncating down the len isn't actually quite correct, but using
> +	 * XFS_B_TO_FSB would mean we trivially get overflows for values
> +	 * of ULLONG_MAX or slightly lower.  And ULLONG_MAX is the default
> +	 * used by the fstrim application.  In the end it really doesn't
> +	 * matter as trimming blocks is an advisory interface.

I don't know where (or if) FITRIM is precisely documented.
But I question whether truncating down the start offset is
the correct thing to do.  If the starting byte offset given
were not block-aligned, it seems like you should not assume
that the caller wanted the bytes below unmapped.  (This is
a broader question, not related directly to your change.)

Similarly, on the length it is probably best to truncate
it, because it avoids any bytes beyond the specified range
getting unmapped.  (I.e., in my mind what you did is the
right way to do it.)  But these interpretations are
dependent on the specific interpretation of FITRIM...

> +	 */
> +	start = XFS_B_TO_FSBT(mp, range.start);
> +	len = XFS_B_TO_FSBT(mp, range.len);
> +	minlen = XFS_B_TO_FSB(mp, max_t(u64, granularity, range.minlen));
> +
> +	start_agno = XFS_FSB_TO_AGNO(mp, start);
> +	if (start_agno >= mp->m_sb.sb_agcount)
> +		return -XFS_ERROR(EINVAL);
> +
> +	end_agno = XFS_FSB_TO_AGNO(mp, start + len);
> +	if (end_agno >= mp->m_sb.sb_agcount)
> +		end_agno = mp->m_sb.sb_agcount - 1;
> +
> +	for (agno = start_agno; agno <= end_agno; agno++) {
> +		error = -xfs_trim_extents(mp, agno, start, len, minlen);
> +		if (error)
> +			last_error = error;
> +	}
> +

You don't update range anywhere, so the copyout below
is not really doing anything useful.  However I think
it should stay, and the number of bytes actually
trimmed should be updated and returned to the user.
That seems to be what ext4 does (the only reference
I found at the moment for what FITRIM is supposed
to return).

> +	if (copy_to_user(urange, &range, sizeof(range)))
> +		return -XFS_ERROR(EFAULT);
> +	return last_error;
> +}

. . . 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
