Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1FJkr7K092782 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 13:46:53 -0600
Date: Sun, 15 Feb 2009 14:46:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Various fixes for extent list indexing
Message-ID: <20090215194619.GA27955@infradead.org>
References: <4992227B.3010107@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4992227B.3010107@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 11, 2009 at 11:57:31AM +1100, Lachlan McIlroy wrote:
> I suspect what has happened here is that xfs_bmap_last_offset() has
> accessed the extent list without acquiring the ilock and has raced
> with another thread that has changed the extent list.  The other
> thread has reduced the extent count so we've tried to access an
> extent beyond the end of the list.
>
> I added some ASSERTs in xfs_iext_get_ext() and xfs_iext_idx_to_irec()
> to catch this and sure enough they triggered very quickly.  Looking
> closely at the algorithm in xfs_iext_idx_to_irec(), if we try to
> lookup an extent beyond the end of the list the search terminates
> with 'low > high' and page_idx never gets updated to be an index
> into a specific extent buffer.
>
> Back in xfs_iext_get_ext(), if page_idx is > 255 it is off the end
> of the extent buffer and potentially in unmapped memory which is how
> the system panicked.  Some debugging in xfs_iext_get_ext() on a heavily
> fragmented file revealed that page_idx was 167532 while the actual
> count of extents in the buffer was only 254 so we accessed way outside
> the bounds of the extent buffer.
>
> I put together a test program (attached) and ran it as:
>
> # ./extent -t -l 163840000 <file>

Can't reproduce it on my system, although I can see how it could
happen from code review.

Also your patch doesn't apply for me, but I have no idea why as
all the context seems correct to me.


> and it found many places where we try to index an extent beyond the
> end of the extent list.  There's code in xfs_bmapi() and xfs_bunmapi()
> that uses the value of if_lastex in the data fork to index an extent
> so it's important to make sure that field holds a sane value.  The
> primary culprit there is xfs_bmap_del_extent() when deleting an entire
> extent - it leaves if_lastex as the index of the extent that was removed.
> If there is another extent beyond that one then if_lastex now points to
> that.  If the removed extent was the last extent then if_lastex is now
> beyond the end of the list.
>
>
> Index: xfs-fix/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs-fix.orig/fs/xfs/xfs_bmap.c
> +++ xfs-fix/fs/xfs/xfs_bmap.c
> @@ -1887,7 +1887,7 @@ xfs_bmap_add_extent_hole_delay(
>  #define	SWITCH_STATE		(state & MASK2(LEFT_CONTIG, RIGHT_CONTIG))
>
>  	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> -	ep = xfs_iext_get_ext(ifp, idx);
> +	ep = NULL;
>  	state = 0;
>  	ASSERT(isnullstartblock(new->br_startblock));
>  	/*
> @@ -1904,6 +1904,7 @@ xfs_bmap_add_extent_hole_delay(
>  	if (STATE_SET_TEST(RIGHT_VALID,
>  			   idx <
>  			   ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
> +		ep = xfs_iext_get_ext(ifp, idx);
>  		xfs_bmbt_get_all(ep, &right);
>  		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
>  	}
> @@ -2078,7 +2079,7 @@ xfs_bmap_add_extent_hole_real(
>
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT(idx <= ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
> -	ep = xfs_iext_get_ext(ifp, idx);
> +	ep = NULL;
>  	state = 0;
>  	/*
>  	 * Check and set flags if this segment has a left neighbor.
> @@ -2094,6 +2095,7 @@ xfs_bmap_add_extent_hole_real(
>  	if (STATE_SET_TEST(RIGHT_VALID,
>  			   idx <
>  			   ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
> +		ep = xfs_iext_get_ext(ifp, idx);
>  		xfs_bmbt_get_all(ep, &right);
>  		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
>  	}

I don't quite understand the relation of these hunks to anything else
in this patch, and these changes seem rather gratious to me.  One
cleanup in that area would be to implement the right side like the left
side and just don't use an ep variable but put the xfs_iext_get_ext
call directly into the argument of xfs_bmbt_get_all for the two calls
per function.

> @@ -3206,6 +3208,8 @@ xfs_bmap_del_extent(
>  		 */
>  		XFS_BMAP_TRACE_DELETE("3", ip, idx, 1, whichfork);
>  		xfs_iext_remove(ifp, idx, 1);
> +		if (idx >= (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)))
> +			idx--;

This probably wants the comment from the introduction here, so that
people know what's going on.  Also the braces around the RHS and the
uint cast are not needed (same for various asserts later in the patch)

> @@ -5723,15 +5728,15 @@ nodelete:

>  		 * Reset ep in case the extents array was re-alloced.

This comment isn't true anymore, is it?  We should never have the
extents array reallocated under us because the proper locks are held,
any we now only reset ep if there is a lastx index.

>  		if (bno != (xfs_fileoff_t)-1 && bno >= start) {
> +			if (lastx >= 0) {
> +				ep = xfs_iext_get_ext(ifp, lastx);
> +				if (xfs_bmbt_get_startoff(ep) > bno) {
> +					if (--lastx >= 0)
> +						ep = xfs_iext_get_ext(ifp, lastx);
> +				}
>  				xfs_bmbt_get_all(ep, &got);
> +			}

And this stuff needs some comments, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
