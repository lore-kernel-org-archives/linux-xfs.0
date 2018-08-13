Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:35695
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730203AbeHNBlB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 21:41:01 -0400
Date: Tue, 14 Aug 2018 08:56:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: fix buffer state management in
 xrep_findroot_block
Message-ID: <20180813225638.GD31495@dastard>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400172200.27471.13133656951315541955.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153400172200.27471.13133656951315541955.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Aug 11, 2018 at 08:35:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't quite handle buffer state properly in online repair's findroot
> routine.  If the buffer is already in-core we don't want to trash its
> b_ops and state, so first we should try _get_buf to grab the buffer.  If
> the buffer is loaded, we only want to verify the structure of the buffer
> since it could be dirty and the crc hasn't yet been recalculated.
> 
> Only if the buffer hasn't been read in should try _read_buf, and if we
> were the ones who read the buffer then we must be careful to oneshot the
> buffer so that a subsequent _read_buf won't find a buffer with no ops.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I don't know the history of how this came about, but IMO this isn't
a particularly nice solution.

> ---
>  fs/xfs/scrub/repair.c |   67 +++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 54 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 97c3077fb005..fae50dced8bc 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -697,6 +697,7 @@ xrep_findroot_block(
>  	struct xfs_mount		*mp = ri->sc->mp;
>  	struct xfs_buf			*bp;
>  	struct xfs_btree_block		*btblock;
> +	xfs_failaddr_t			fa;
>  	xfs_daddr_t			daddr;
>  	int				block_level;
>  	int				error;
> @@ -718,28 +719,68 @@ xrep_findroot_block(
>  			return error;
>  	}
>  
> -	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
> -			mp->m_bsize, 0, &bp, NULL);
> -	if (error)
> -		return error;
> -
>  	/*
> -	 * Does this look like a block matching our fs and higher than any
> -	 * other block we've found so far?  If so, reattach buffer verifiers
> -	 * so the AIL won't complain if the buffer is also dirty.
> +	 * Try to grab the buffer, on the off chance it's already in memory.
> +	 * If the buffer doesn't have the DONE flag set it hasn't been read
> +	 * into memory yet.  Drop the buffer and read the buffer with NULL
> +	 * b_ops.  (This could race with another read_buf.)  If we get the
> +	 * buffer back with NULL b_ops then we know that there weren't any
> +	 * other readers.  There's a risk we won't match the buffer with any
> +	 * of the findroot prototypes, so we want to encourage the buffer layer
> +	 * to drop the buffer as soon as possible.
>  	 */
> +	bp = xfs_trans_get_buf(ri->sc->tp, mp->m_ddev_targp, daddr,
> +			mp->m_bsize, 0);
> +	if (!bp)
> +		return -ENOMEM;
> +	if (!(bp->b_flags & XBF_DONE)) {
> +		xfs_trans_brelse(ri->sc->tp, bp);
> +
> +		error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp,
> +				daddr, mp->m_bsize, 0, &bp, NULL);
> +		if (error)
> +			return error;
> +		if (!bp->b_ops)
> +			xfs_buf_oneshot(bp);
> +	}

Let's look a little closer. xfs_trans_read_buf() ends up in
xfs_buf_read_map(), which does:

....
        bp = xfs_buf_get_map(target, map, nmaps, flags);
        if (bp) {
                trace_xfs_buf_read(bp, flags, _RET_IP_);

                if (!(bp->b_flags & XBF_DONE)) {
                        XFS_STATS_INC(target->bt_mount, xb_get_read);
                        bp->b_ops = ops;
                        _xfs_buf_read(bp, flags);
		} else if (flags & XBF_ASYNC) {
.....

But what you are doing in the code above is trying to do is
determine if we needed to call _xfs_buf_read() on the buffer, and if
we do we use a different verify procedure on it.

So isn't there a simpler way to do this? e.g. pass a flag down to
xfs_buf_read_map() that says "use these ops for just this read".

	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp,
				daddr, mp->m_bsize, XBF_ONESHOT_OPS,
				&bp, NULL);

and change xfs_buf_read_map() to do:


....
        bp = xfs_buf_get_map(target, map, nmaps, flags);
        if (bp) {
                trace_xfs_buf_read(bp, flags, _RET_IP_);

                if (!(bp->b_flags & XBF_DONE)) {
                        XFS_STATS_INC(target->bt_mount, xb_get_read);
			if (flags & XBF_ONESHOT_OPS)
				orig_ops = bp->b_ops;
                        bp->b_ops = ops;
                        _xfs_buf_read(bp, flags);
			if (flags & XBF_ONESHOT_OPS)
				bp->b_ops = orig_ops;
		} else if (flags & XBF_ASYNC) {
			ASSERT(!(flags & XBF_ONESHOT_OPS));
....

Now you get back the buffer with it's original ops on it even if had
to be read from disk and you used a different verifier. Hence you
know how to treat it after this because the ops will be null if it
was not in core and had to be read from disk.

That also means you could supply fab->buf_ops to the
xfs_trans_read_buf() call, knowing that they'll be used on read and
you'll get a null bp->b_ops back despite the buffer already having
been fully verified. i.e. if it fails verification, you'll get an
error rather than having to having to run the verification yourself.
That means you only need to run the ->verify_struct() op if you get
back a non-null bp->b_ops, which further simplifies the function...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
