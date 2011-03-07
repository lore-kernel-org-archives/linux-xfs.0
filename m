Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p27N4GwW188216 for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 17:04:16 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BCF58AC007
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2011 15:07:07 -0800 (PST)
Subject: Re: [PATCH 3/3] xfs: do not immediately reuse busy extent ranges
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110304130119.656476789@bombadil.infradead.org>
References: <20110304125953.650347660@bombadil.infradead.org>
	<20110304130119.656476789@bombadil.infradead.org>
Date: Mon, 07 Mar 2011 17:01:36 -0600
Message-ID: <1299538896.2578.897.camel@doink>
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

On Fri, 2011-03-04 at 07:59 -0500, Christoph Hellwig wrote:
> plain text document attachment (xfs-skip-busy-extents)
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

This time I just scanned most of the change, since it appears
it's almost the same except for the (renamed) xfs_alloc_busy_trim()
function.  It looks correct now, but I have a few things for you
to consider.  I'll wait for your response in case you want to
change anything.  After that I'll pull in the three patches
(probably tomorrow).

> [hch: merged two earlier patches from Dave and fixed various bugs]
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-02 12:18:01.599040095 -0500
> +++ xfs/fs/xfs/xfs_alloc.c	2011-03-02 12:19:10.599027233 -0500

. . .

> @@ -2657,6 +2727,177 @@ xfs_alloc_busy_search(
>  	return match;
>  }
>  
> +/*
> + * For a given extent [fbno, flen], search the busy extent list
> + * to find a subset of the extent that is not busy.
> + */

I agree that the notation (from Dave) that you use here
is very helpful in visualizing what's going on.  But
the underlying code is pretty simple, and it gets somewhat
lost in the comments I think.  I therefore would kind of
prefer to have the explanation moved up above the function.
It clearly labels the cases being treated, and references
to those can be put in the code, below.

(This is a style thing, so if you feel strongly that it's
better as you have it, so be it.)

> +STATIC void
> +xfs_alloc_busy_trim(
> +	struct xfs_alloc_arg	*args,
> +	xfs_agblock_t		fbno,
> +	xfs_extlen_t		flen,
> +	xfs_agblock_t		*rbno,
> +	xfs_extlen_t		*rlen)
> +{
> +	struct rb_node		*rbp;
> +
> +	ASSERT(flen > 0);
> +
> +	spin_lock(&args->pag->pagb_lock);
> +	rbp = args->pag->pagb_tree.rb_node;
> +	while (rbp && flen >= args->minlen) {
> +		struct xfs_busy_extent *busyp =
> +			rb_entry(rbp, struct xfs_busy_extent, rb_node);
> +		xfs_agblock_t	fend = fbno + flen;

All the nice diagrams refer to the variable "fbno"
and "fend" using "bno" and "end.  I think you should
either drop the "f" in the variables or add it to
the comments.

> +		xfs_agblock_t	bbno = busyp->bno;
> +		xfs_agblock_t	bend = bbno + busyp->length;
> +
> +		if (fbno + flen <= bbno) {

		if (fend <= bbno) {

> +			rbp = rbp->rb_left;
> +			continue;
> +		} else if (fbno >= bend) {
> +			rbp = rbp->rb_right;
> +			continue;
> +		}
> +
> +		if (bbno <= fbno) {
> +			/* start overlap */
> +			ASSERT(bend > fbno);
> +			ASSERT(bend <= fend);

This assertion is wrong (Case 1 is an example).
The only things you know are:
	bbno <= fbno
	bbno  < bend therefore (fbno < bend)
and
	fbno < fend
but you don't know the relationship between bend and fend.

> +
> +			/*
> +			 * Case 1:
> +			 *    bbno           bend
> +			 *    +BBBBBBBBBBBBBBBBB+
> +			 *        +---------+
> +			 *        bno     end
> +			 *

As long as you're enumerating all the cases, there's
one that you don't mention (but which is covered in
this block):
			 *    bbno        bend
			 *    +BBBBBBBBBBBBBB+
			 *        +---------+
			 *        bno     end
			 *
I think this should be added to the description
for completeness.

> +			 * Case 2:
> +			 *    bbno           bend
> +			 *    +BBBBBBBBBBBBBBBBB+
> +			 *    +-------------+
> +			 *    bno         end
> +			 *
> +	
. . .
> +		} else {
> +			/* middle overlap */
> +
> +			/*
> +			 * Case 9:
> +			 *             bbno           bend
> +			 *             +BBBBBBBBBBBBBBBBB+
> +			 *    +-----------------------------------+
> +			 *    bno                               end
> +			 *
> +			 * Can be trimmed to:
> +			 *    +-------+        OR         +-------+
> +			 *    bno   end                   bno   end
> +			 *

The following block of text explains things, but it might
be clearer if it's rearranged a bit:
- Backward allocation leads to significant fragmentation
  of directories, which degrades directory performance.
- Therefore we always want to choose the option that
  produces forward allocation patterns.
- Preferring the lower bno extent will make the next
  request use "end" as the start of the next allocation.
  If the segment is no longer busy at that point, we'll
  then get a contiguous allocation, but even if it is
  still busy, we'll get a forward allocation.
- We try to avoid choosing the segment at "bend",
  because that can lead to the next allocation taking
  the segment at "bno"--which would be a backward
  allocation.
- We only use the segment at "bno" if it is much larger
  than the current requested size, because in that case
  there's a good chance subsequent allocations will
  be contiguous.

(Something like that anyway, I just wanted to provide
an example rather than just saying "it's wrong.")

> +			 * We prefer the lower bno extent because the next
> +			 * allocation for this inode will use "end" as the
> +			 * target for first block.  If the busy segment has
> +			 * cleared, this will get a contiguous allocation next
> +			 * time around; if thebusy segment has not cleared,
> +			 * it will get an allocation at bend, which is a forward
> +			 * allocation.
> +			 *
> +			 * If we choose segment at bend, and this remains the
> +			 * best extent for the next allocation (e.g. NEAR_BNO
> +			 * allocation) we'll next allocate at bno, which will
> +			 * give us backwards allocation.  We already know that
> +			 * backwards allocation direction causes significant
> +			 * fragmentation of directories and degradataion of
> +			 * directory performance.
> +			 *
> +			 * Always chose the option that produces forward
> +			 * allocation patterns so that sequential reads and
> +			 * writes only ever seek in one direction.  Only choose
> +			 * the higher bno extent if the remainin unused extent
> +			 * length is much larger than the current allocation
> +			 * request, promising us a contiguous allocation in
> +			 * the following free space.
> +			 */
> +
> +			if (bbno - fbno >= args->maxlen) {
> +				/* left candidate fits perfect */
> +				fend = bbno;
> +			} else if (fend - bend >= args->maxlen * 4) {

This magic value 4 ought to be justified, or experimented
with, or possibly set as a tunable (for the time being).



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
