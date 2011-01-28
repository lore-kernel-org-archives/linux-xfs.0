Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SGHTuY164064 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 10:17:29 -0600
Subject: Re: [PATCH 3/6] xfs: do not immediately reuse busy extent ranges
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110128015835.GQ21311@dastard>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092550.933551564@bombadil.infradead.org>
	<20110128015835.GQ21311@dastard>
Date: Fri, 28 Jan 2011 10:19:51 -0600
Message-ID: <1296231591.2342.47.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, 2011-01-28 at 12:58 +1100, Dave Chinner wrote:
> On Fri, Jan 21, 2011 at 04:22:30AM -0500, Christoph Hellwig wrote:
> > Every time we reallocate a busy extent, we cause a synchronous log force
> > to occur to ensure the freeing transaction is on disk before we continue
. . .
> > +
> > +	spin_lock(&pag->pagb_lock);
> > +	rbp = pag->pagb_tree.rb_node;
> > +	while (rbp) {

I will amend the loop termination condition I suggested
before to be this:

	while (rbp && len >= args->minlen) {

> > +		struct xfs_busy_extent *busyp =
> > +			rb_entry(rbp, struct xfs_busy_extent, rb_node);
> > +		xfs_agblock_t	end = bno + len;
> > +		xfs_agblock_t	bend = busyp->bno + busyp->length;
> > +
> > +		if (bno + len <= busyp->bno) {
> > +			rbp = rbp->rb_left;
> > +			continue;
> > +		} else if (bno >= busyp->bno + busyp->length) {
> > +			rbp = rbp->rb_right;
> > +			continue;
> > +		}
> 
> 		if (end <= bbno)
> 			left;
> 		else if (bno > bend)
> 			right;

I think the original code is right in this case.
The value of "bend" is the offset *following* the
end of the range.  So if "bno" equals that, we
want to move Right.  (Same reason <= is correct
for the first condition here.)

> 		/* overlap */
> 
> > +
> > +		if (busyp->bno < bno) {
> > +			/* start overlap */
> > +			ASSERT(bend >= bno);
> > +			ASSERT(bend <= end);
> > +			len -= bno - bend;
> > +			bno = bend;
> 
> 		if (bbno < bno) {
> 
> 		bbno           bend
> 		+-----------------+
> Case 1:
> 		   +---------+
> 		   bno     end
> 
> 		   No unbusy region in extent, return failure

Yes, that's right, I missed that.  My suggestion goes
negative in this case.

> Case 2:
> 		   +------------------------+
> 		   bno                    end
> 
> 		   Needs to be trimmed to:
> 		                    +-------+
> 		                    bno   end
> 		   bno = bend;
> 		   len = end - bno;

I like defining len in terms of the updated bno as
you have suggested here.

> > +		} else if (bend > end) {
> > +			/* end overlap */
> > +			ASSERT(busyp->bno >= bno);
> > +			ASSERT(busyp->bno < end);
> > +			len -= bend - end;
> 
. . .


> So, it looks to me like the "overlap found" algorithm shoul dbe
> something like:

For this algorithm, updating the value of len can be done
once, at the bottom (or top) of the loop, based simply on
the (updated) value of end and bno:

	len = end - bno;

You could rearrange things a bit so this gets done at
the top--instead of computing the value of end based
on bno and len.


> 		if (bbno <= bno) {
> 			if (end <= bend) {
> 				/* case 1, 3, 5 */
> 				return failure;
> 			}
> 			/* case 2, 6 */
> 			bno = bend;
> 			len = end - bno;
> 		} else if (bend >= end) {
> 			ASSERT(bbno > bno);
> 			/* case 4, 7 */
> 			end = bbno;
> 			len = end - bno;
> 		} else {
> 			ASSERT(bbno > bno);
> 			ASSERT(bend < end);
> 			/* case 8 */
> 			if (bbno - bno >= args->minlen) {
> 				/* left candidate OK */
> 				left = 1;
> 			}
> 			if (end - bend >= args->maxlen * 4) {

The "4" here I understand, but it's arbitrary (based
on an educated guess) so it needs to at least be explained
here with a comment.  Making it symbolic might make it
something one could search for at some future date.

> 				/* right candidate OK */
> 				right = 1;
> 			}
> 			if (left && right) {
> 				/* take right if left is not a
> 				 * maximal allocation */
> 				if (bbno - bno < args->maxlen)
> 					left = 0;
> 			}
> 			if (left) {
> 				end = bbno;
> 				len = end - bno;
> 			} else if (right) {
> 				bno = bend;
> 				len = end - bno;
> 			} else {
> 				return failure;
> 			}
> 		}
> 
> > @@ -109,19 +109,16 @@ xfs_trim_extents(
> >  		 * If any blocks in the range are still busy, skip the
> >  		 * discard and try again the next time.
> >  		 */
> > -		if (xfs_alloc_busy_search(mp, agno, fbno, flen)) {
> > -			trace_xfs_discard_busy(mp, agno, fbno, flen);
> > -			goto next_extent;
> > -		}
> > +		xfs_alloc_busy_search_trim(mp, pag, fbno, flen, &tbno, &tlen);
> >  
> > -		trace_xfs_discard_extent(mp, agno, fbno, flen);
> > +		trace_xfs_discard_extent(mp, agno, tbno, tlen);
> >  		error = -blkdev_issue_discard(bdev,
> > -				XFS_AGB_TO_DADDR(mp, agno, fbno),
> > -				XFS_FSB_TO_BB(mp, flen),
> > +				XFS_AGB_TO_DADDR(mp, agno, tbno),
> > +				XFS_FSB_TO_BB(mp, tlen),
> >  				GFP_NOFS, 0);
> >  		if (error)
> >  			goto out_del_cursor;
> > -		*blocks_trimmed += flen;
> > +		*blocks_trimmed += tlen;
> 
> Hmmm - that means if we get a case 8 overlap, we'll only trim one
> side of the extent. That's probably not a big deal. However, perhaps
> this should check the size of the trimmed extent before issuing the
> discard against it in case we've reduced it to something smaller
> thanthe minimum requested trim size....

I think all of the places that (ultimately) call this function
need to be looked at to make sure they handle the "error" case
properly--either checking for a returned error or verifying the
returned length is at least the minimum.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
