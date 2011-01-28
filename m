Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S1uU9J074439 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 19:56:30 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4714B1A460E6
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 17:58:52 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GTTARBmGGWLiMgAP for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 17:58:52 -0800 (PST)
Date: Fri, 28 Jan 2011 12:58:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: do not immediately reuse busy extent ranges
Message-ID: <20110128015835.GQ21311@dastard>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092550.933551564@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110121092550.933551564@bombadil.infradead.org>
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

On Fri, Jan 21, 2011 at 04:22:30AM -0500, Christoph Hellwig wrote:
> Every time we reallocate a busy extent, we cause a synchronous log force
> to occur to ensure the freeing transaction is on disk before we continue
> and use the newly allocated extent.  This is extremely sub-optimal as we
> have to mark every transaction with blocks that get reused as synchronous.
> 
> Instead of searching the busy extent list after deciding on the extent to
> allocate, check each candidate extent during the allocation decisions as
> to whether they are in the busy list.  If they are in the busy list, we
> trim the busy range out of the extent we have found and determine if that
> trimmed range is still OK for allocation. In many cases, this check can
> be incorporated into the allocation extent alignment code which already
> does trimming of the found extent before determining if it is a valid
> candidate for allocation.
> 
> [hch: merged two earlier patches from Dave and fixed various bugs]
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....
>  	ASSERT(args->agbno % args->alignment == 0);
>  
>  	if (!args->wasfromfl) {
> -		xfs_alloc_update_counters(args->tp, args->pag, args->agbp,
> -					  -((long)(args->len)));
> +		error = xfs_alloc_update_counters(args->tp, args->pag,
> +						  args->agbp,
> +						  -((long)(args->len)));
>  
> -		/*
> -		 * Search the busylist for these blocks and mark the
> -		 * transaction as synchronous if blocks are found. This
> -		 * avoids the need to block due to a synchronous log
> -		 * force to ensure correct ordering as the synchronous
> -		 * transaction will guarantee that for us.
> -		 */
> -		if (xfs_alloc_busy_search(args->mp, args->agno,
> -					args->agbno, args->len))
> -			xfs_trans_set_sync(args->tp);
> +		ASSERT(!xfs_alloc_busy_search(args->mp, args->agno,
> +					      args->agbno, args->len));
>  	}
>  
>  	if (!args->isfl) {
> @@ -559,7 +554,7 @@ xfs_alloc_ag_vextent(
>  
>  	XFS_STATS_INC(xs_allocx);
>  	XFS_STATS_ADD(xs_allocb, args->len);
> -	return 0;
> +	return error;
>  }

These error handling changes could go in the previous patch.

> @@ -2612,7 +2688,7 @@ restart:
>   * will require a synchronous transaction, but it can still be
>   * used to distinguish between a partial or exact match.
>   */
> -int
> +STATIC int
>  xfs_alloc_busy_search(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
> @@ -2654,6 +2730,71 @@ xfs_alloc_busy_search(
>  	return match;
>  }
>  
> +/*
> + * For a given extent [fbno, flen], search the busy extent list
> + * to find a subset of the extent that is not busy.
> + */

How does this function return an indication that the extent selected
is entirrely unsuitable? e.g. the extent lies wholly within
the busy range and gets trimmed to zero length? perhaps it woul dbe
good to return an error in this case?

> +void
> +xfs_alloc_busy_search_trim(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag,
> +	xfs_agblock_t		fbno,
> +	xfs_extlen_t		flen,
> +	xfs_agblock_t		*rbno,
> +	xfs_extlen_t		*rlen)
> +{
> +	struct rb_node		*rbp;
> +	xfs_agblock_t           bno = fbno;
> +	xfs_extlen_t            len = flen;
> +
> +	spin_lock(&pag->pagb_lock);
> +	rbp = pag->pagb_tree.rb_node;
> +	while (rbp) {
> +		struct xfs_busy_extent *busyp =
> +			rb_entry(rbp, struct xfs_busy_extent, rb_node);
> +		xfs_agblock_t	end = bno + len;
> +		xfs_agblock_t	bend = busyp->bno + busyp->length;
> +
> +		if (bno + len <= busyp->bno) {
> +			rbp = rbp->rb_left;
> +			continue;
> +		} else if (bno >= busyp->bno + busyp->length) {
> +			rbp = rbp->rb_right;
> +			continue;
> +		}

		if (end <= bbno)
			left;
		else if (bno > bend)
			right;

		/* overlap */

> +
> +		if (busyp->bno < bno) {
> +			/* start overlap */
> +			ASSERT(bend >= bno);
> +			ASSERT(bend <= end);
> +			len -= bno - bend;
> +			bno = bend;

		if (bbno < bno) {

		bbno           bend
		+-----------------+
Case 1:
		   +---------+
		   bno     end

		   No unbusy region in extent, return failure

Case 2:
		   +------------------------+
		   bno                    end

		   Needs to be trimmed to:
		                    +-------+
		                    bno   end
		   bno = bend;
		   len = end - bno;

> +		} else if (bend > end) {
> +			/* end overlap */
> +			ASSERT(busyp->bno >= bno);
> +			ASSERT(busyp->bno < end);
> +			len -= bend - end;

		} else if (bend > end) {

bno must be <= bbno in this case, so:

		bbno           bend
		+-----------------+

Case 3: bno == bbno:
		+-------------+
		bno         end

		No unbusy region in extent, return failure.

Case 4:
        +------------------+
        bno              end

   Needs to be trimmed to:
        +-------+
        bno   end

		end = bbno;
		len = end - bno;



> +		} else {
> +			/* middle overlap - return larger segment */
> +			ASSERT(busyp->bno >= bno);
> +			ASSERT(bend <= end);
> +			len = busyp->bno - bno;
> +			if (len >= end - bend) {
> +				/* use first segment */
> +				len = len;
> +			} else {
> +				/* use last segment */
> +				bno = bend;
> +				len = end - bend;
> +			}

(bno <= bbno && bend <= end) in this case, so:

		bbno           bend
		+-----------------+

Case 5: Exact match: (bno == bbno && bend == end)
		+-----------------+
		bno             end

		No unbusy region in extent, return failure.

Case 6: (bno == bbno && bend < end)

		+-------------------------+
		bno                     end

		Needs to be trimmed to:
		                  +-------+
		                  bno   end

		Same as Case 2.
			- case 2 can be extend to bbno <= bno.

Case 7: (bno < bbno && bend == end)

        +-------------------------+
        bno                     end

   Needs to be trimmed to:
        +-------+
        bno   end

		Same as case 4.
			- Case 4 can be extented to bend >= end

Case 8: (bno < bbno && bend < end)

        +---------------------------------+
        bno                             end

can be trimmed to:
        +-------+        OR       +-------+
        bno   end                 bno   end

	- Should always want to choose the lower bno extent:
		- next allocation in file will use "end" as
		  the target for first block
		- if busy segment has cleared, will get contiguous
		  allocation
		- if busy segment has not cleared, get allocation at
		  bend, which is forwards allocation.

		- if we choose segment at bend, and this remains the
		  best extent for the next allocation (e.g.
		  NEAR_BNO allocation) we'll next allocate at bno,
		  which will give us backwards allocation.

		- always chose the option that produces forwards
		  allocation patterns so that sequential reads and
		  writes only ever seek in one direction.

		- we already know that backwards allocation
		  direction (due to NEAR_BNO second algorithm)
		  causes significant fragmentation of directories
		  and degradataion of directory performance, so I
		  think we should avoid introducing a new allocation
		  algorithm that can lead to backwards allocation
		  around frequently reused extents.

	- only choose right hand edge if the remainin unused extent
	  length is much larger than the current allocation request.

	- otherwise return failure if we can't use lower bno due to
	  minlen restrictions so a new extent is chosen by the
	  higher level algorithm.


So, it looks to me like the "overlap found" algorithm shoul dbe
something like:

		if (bbno <= bno) {
			if (end <= bend) {
				/* case 1, 3, 5 */
				return failure;
			}
			/* case 2, 6 */
			bno = bend;
			len = end - bno;
		} else if (bend >= end) {
			ASSERT(bbno > bno);
			/* case 4, 7 */
			end = bbno;
			len = end - bno;
		} else {
			ASSERT(bbno > bno);
			ASSERT(bend < end);
			/* case 8 */
			if (bbno - bno >= args->minlen) {
				/* left candidate OK */
				left = 1;
			}
			if (end - bend >= args->maxlen * 4) {
				/* right candidate OK */
				right = 1;
			}
			if (left && right) {
				/* take right if left is not a
				 * maximal allocation */
				if (bbno - bno < args->maxlen)
					left = 0;
			}
			if (left) {
				end = bbno;
				len = end - bno;
			} else if (right) {
				bno = bend;
				len = end - bno;
			} else {
				return failure;
			}
		}

> @@ -109,19 +109,16 @@ xfs_trim_extents(
>  		 * If any blocks in the range are still busy, skip the
>  		 * discard and try again the next time.
>  		 */
> -		if (xfs_alloc_busy_search(mp, agno, fbno, flen)) {
> -			trace_xfs_discard_busy(mp, agno, fbno, flen);
> -			goto next_extent;
> -		}
> +		xfs_alloc_busy_search_trim(mp, pag, fbno, flen, &tbno, &tlen);
>  
> -		trace_xfs_discard_extent(mp, agno, fbno, flen);
> +		trace_xfs_discard_extent(mp, agno, tbno, tlen);
>  		error = -blkdev_issue_discard(bdev,
> -				XFS_AGB_TO_DADDR(mp, agno, fbno),
> -				XFS_FSB_TO_BB(mp, flen),
> +				XFS_AGB_TO_DADDR(mp, agno, tbno),
> +				XFS_FSB_TO_BB(mp, tlen),
>  				GFP_NOFS, 0);
>  		if (error)
>  			goto out_del_cursor;
> -		*blocks_trimmed += flen;
> +		*blocks_trimmed += tlen;

Hmmm - that means if we get a case 8 overlap, we'll only trim one
side of the extent. That's probably not a big deal. However, perhaps
this should check the size of the trimmed extent before issuing the
discard against it in case we've reduced it to something smaller
thanthe minimum requested trim size....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
