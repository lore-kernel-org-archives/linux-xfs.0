Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PL0CHB246732 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 16:00:12 -0500
Subject: Re: [PATCH 2/6] xfs: do not immediately reuse busy extent ranges
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110322200137.474878707@bombadil.infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.474878707@bombadil.infradead.org>
Date: Fri, 25 Mar 2011 16:03:19 -0500
Message-ID: <1301086999.2537.688.camel@doink>
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

On Tue, 2011-03-22 at 15:55 -0400, Christoph Hellwig wrote:
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
> Based on two earlier patches from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I already reviewed this, but I noticed a few things
that I think are worth clarifying in one comment.
There are a few typo's in that same block that you
might as well fix while you're at it.

. . .

> @@ -2634,6 +2704,181 @@ xfs_alloc_busy_search(
>  	return match;
>  }
>  
> +/*
> + * For a given extent [fbno, flen], search the busy extent list
> + * to find a subset of the extent that is not busy.
> + */
> +STATIC void
> +xfs_alloc_busy_trim(
> +	struct xfs_alloc_arg	*args,
> +	xfs_agblock_t		fbno,
> +	xfs_extlen_t		flen,
> +	xfs_agblock_t		*rbno,
> +	xfs_extlen_t		*rlen)
> +{

. . .

> +		} else {
> +			/* middle overlap */
> +
> +			/*
> +			 * Case 9:
> +			 *             bbno           bend
> +			 *             +BBBBBBBBBBBBBBBBB+
> +			 *    +-----------------------------------+
> +			 *    fbno                             fend
> +			 *
> +			 * Can be trimmed to:
> +			 *    +-------+        OR         +-------+
> +			 *    fbno fend                   fbno fend
> +			 *
> +			 * We prefer the lower bno extent because the next
> +			 * allocation for this inode will use "end" as the
> +			 * target for first block.  If the busy segment has

...will use the updated value of fend as the target...

> +			 * cleared, this will get a contiguous allocation next
> +			 * time around; if thebusy segment has not cleared,
                                             the busy

> +			 * it will get an allocation at bend, which is a forward
> +			 * allocation.
> +			 *
> +			 * If we choose segment at bend, and this remains the
> +			 * best extent for the next allocation (e.g. NEAR_BNO
> +			 * allocation) we'll next allocate at bno, which will
...we'll next allocate at (pre-update) fbno, which will...

(Actually, correct this if my statements are wrong.  The point is
to use "fbno" and "fend" where you currently just have "bno" and
"end".)

> +			 * give us backwards allocation.  We already know that
> +			 * backwards allocation direction causes significant
> +			 * fragmentation of directories and degradataion of
> +			 * directory performance.
> +			 *
> +			 * Always chose the option that produces forward
                                   choose 
> +			 * allocation patterns so that sequential reads and
> +			 * writes only ever seek in one direction.  Only choose
> +			 * the higher bno extent if the remainin unused extent
                                                          remaining 
> +			 * length is much larger than the current allocation
> +			 * request, promising us a contiguous allocation in
> +			 * the following free space.
> +			 */
> +
> +			if (bbno - fbno >= args->maxlen) {

. . . 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
