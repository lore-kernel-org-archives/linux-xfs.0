Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63593 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932584AbeBLClm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Feb 2018 21:41:42 -0500
Date: Mon, 12 Feb 2018 13:41:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: byte range buffer dirty region tracking
Message-ID: <20180212024138.GB6778@dastard>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180205003415.dn6elcqb4kae3xle@destitution>
 <20180206162141.GA3862@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180206162141.GA3862@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 06, 2018 at 11:21:41AM -0500, Brian Foster wrote:
> On Mon, Feb 05, 2018 at 11:34:15AM +1100, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > One of the biggest performance problems with large directory block
> > sizes is the CPU overhead in maintaining the buffer log item direty
> > region bitmap.  The bit manipulations and buffer region mapping
> > calls are right at the top of the profiles when running tests on 64k
> > directory buffers:
> > 
> ...
> > 
> >  fs/xfs/xfs_buf.c      |  23 ++-
> >  fs/xfs/xfs_buf_item.c | 437 ++++++++++++++++++++++++++------------------------
> >  fs/xfs/xfs_buf_item.h |  19 +++
> >  3 files changed, 261 insertions(+), 218 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 270ddb4d2313..bc6514a08760 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -66,50 +66,12 @@ xfs_buf_item_size_segment(
> >  	int				*nvecs,
> >  	int				*nbytes)
> >  {
> > -	struct xfs_buf			*bp = bip->bli_buf;
> > -	int				next_bit;
> > -	int				last_bit;
> > -
> > -	last_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
> > -	if (last_bit == -1)
> > -		return;
> > -
> >  	/*
> >  	 * initial count for a dirty buffer is 2 vectors - the format structure
> > -	 * and the first dirty region.
> > +	 * and the dirty region. Dirty region is accounted for separately.
> >  	 */
> >  	*nvecs += 2;
> > -	*nbytes += xfs_buf_log_format_size(blfp) + XFS_BLF_CHUNK;
> > -
> > -	while (last_bit != -1) {
> > -		/*
> > -		 * This takes the bit number to start looking from and
> > -		 * returns the next set bit from there.  It returns -1
> > -		 * if there are no more bits set or the start bit is
> > -		 * beyond the end of the bitmap.
> > -		 */
> > -		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
> > -					last_bit + 1);
> > -		/*
> > -		 * If we run out of bits, leave the loop,
> > -		 * else if we find a new set of bits bump the number of vecs,
> > -		 * else keep scanning the current set of bits.
> > -		 */
> > -		if (next_bit == -1) {
> > -			break;
> > -		} else if (next_bit != last_bit + 1) {
> > -			last_bit = next_bit;
> > -			(*nvecs)++;
> > -		} else if (xfs_buf_offset(bp, next_bit * XFS_BLF_CHUNK) !=
> > -			   (xfs_buf_offset(bp, last_bit * XFS_BLF_CHUNK) +
> > -			    XFS_BLF_CHUNK)) {
> > -			last_bit = next_bit;
> > -			(*nvecs)++;
> > -		} else {
> > -			last_bit++;
> > -		}
> > -		*nbytes += XFS_BLF_CHUNK;
> > -	}
> > +	*nbytes += xfs_buf_log_format_size(blfp);
> 
> This function has been reduced such that the comment at the top could
> probably use updating. In fact, we may be able to kill it entirely if
> it's not used anywhere else..?

Killed.

> > @@ -167,19 +132,53 @@ xfs_buf_item_size(
> >  		return;
> >  	}
> >  
> > +
> > +	/*
> > +	 * If the last byte of teh first range is zero, then we've been fed a
> > +	 * clean buffer with a XFS_BLI_DIRTY flag set. This should never happen,
> > +	 * but be paranoid and catch it. If it does happen, then first should be
> > +	 * zero, too.
> > +	 */
> > +	if (bip->bli_range[0].last == 0) {
> > +		ASSERT(0);
> > +		ASSERT(bip->bli_range[0].first == 0);
> > +		return;
> > +	}
> 
> Isn't first == last == 0 a valid, inclusive range?

It indicates someone logged a clean buffer, and we shouldn't ever
get to this point if that has happened. Someone made a programming
mistake, so better we catch it here than silently log an empty range
and hope that log recovery does the right thing...

> > @@ -234,16 +236,6 @@ xfs_buf_item_format_segment(
> >  	 * memory structure.
> >  	 */
> >  	base_size = xfs_buf_log_format_size(blfp);
> > -
> > -	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
> > -	if (!(bip->bli_flags & XFS_BLI_STALE) && first_bit == -1) {
> > -		/*
> > -		 * If the map is not be dirty in the transaction, mark
> > -		 * the size as zero and do not advance the vector pointer.
> > -		 */
> > -		return;
> > -	}
> > -
> >  	blfp = xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
> >  	blfp->blf_size = 1;
> 
> Perhaps we should set the datamap bits before we format out the blf? ;)

No. This code is slightly tricksy, clearly, but that's not something
this patch has changed.

That is: the blfp we pass in is the source data from the incore buf
log format structure attached to the buf log item. xlog_copy_iovec()
returns a pointer to the log iovec data buffer we copied the source
into. IOWS, after the call to xlog_copy_iovec() blfp points to the
structure that will be written to the log, not the in-memory
structure, and we modify that repeatedly as we add new iovecs
containing the buffer data being logged.

I'll clean it up to name the incoming blfp to "src_blfp" so it's
clear we are operating on different structures here.

> 
> >  
> > @@ -258,46 +250,40 @@ xfs_buf_item_format_segment(
> >  		return;
> >  	}
> >  
> > +	blfp->blf_size++;
> >  
> >  	/*
> > -	 * Fill in an iovec for each set of contiguous chunks.
> > +	 * Now we need to set the bits in the bitmap and set up the iovecs
> > +	 * appropriately. We know there is a contiguous range in this buffer
> > +	 * than needs to be set, so find the first bit, the last bit, and
> > +	 * go from there.
> >  	 */
> > -	last_bit = first_bit;
> > -	nbits = 1;
> > -	for (;;) {
> > -		/*
> > -		 * This takes the bit number to start looking from and
> > -		 * returns the next set bit from there.  It returns -1
> > -		 * if there are no more bits set or the start bit is
> > -		 * beyond the end of the bitmap.
> > -		 */
> > -		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
> > -					(uint)last_bit + 1);
> > -		/*
> > -		 * If we run out of bits fill in the last iovec and get out of
> > -		 * the loop.  Else if we start a new set of bits then fill in
> > -		 * the iovec for the series we were looking at and start
> > -		 * counting the bits in the new one.  Else we're still in the
> > -		 * same set of bits so just keep counting and scanning.
> > -		 */
> > -		if (next_bit == -1) {
> > -			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
> > -						first_bit, nbits);
> > -			blfp->blf_size++;
> > -			break;
> > -		} else if (next_bit != last_bit + 1 ||
> > -		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
> 
> FYI... this kills the only callers of xfs_buf_item_copy_iovec() and
> xfs_buf_item_straddle() so they should probably be removed.

Good catch. Removed.

> 
> > -			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
> > -						first_bit, nbits);
> > -			blfp->blf_size++;
> > -			first_bit = next_bit;
> > -			last_bit = next_bit;
> > -			nbits = 1;
> > -		} else {
> > -			last_bit++;
> > -			nbits++;
> > -		}
> > -	}
> > +	start = 0;
> > +	if (offset < rp->first)
> > +		start = rp->first - offset;
> > +	end = length - 1;
> > +	if (offset + length > rp->last)
> > +		end = rp->last - offset - 1;
> > +
> 
> FWIW, it took me a second to identify what was going on here. It might
> be useful to incorporate that we're calculating the relative byte
> offsets in order to convert into the bitmap in the new comment above.

Done.

> 
> Also, I could be lost in the maze a bit here, but why the '- 1' in the
> end calculation above? Isn't rp->last inclusive?

It was fixing a bug in the initial setting of rp->last, in the case
where the first range is being set up (didn't have a "- 1" in that
data). Fixed the initial bug, removed the -1s from here.

> > +	start &= ~((1 << XFS_BLF_SHIFT) - 1);
> > +	first_bit = start >> XFS_BLF_SHIFT;
> 
> Why the mask if we're going to right shift anyways?

Left over debug stuff, I think. Removed.

> > @@ -349,10 +334,36 @@ xfs_buf_item_format(
> >  		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
> >  	}
> >  
> > -	for (i = 0; i < bip->bli_format_count; i++) {
> > -		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
> > -					    &bip->bli_formats[i]);
> > -		offset += BBTOB(bp->b_maps[i].bm_len);
> > +	for (i = 0, offset = 0;
> > +	     i < bip->bli_format_count;
> > +	     i++, offset += BBTOB(bp->b_maps[i].bm_len)) {
> > +
> > +		/* stale regions cover the entire segment */
> 
> Something like "stale regions are fixed size" seems more accurate, since
> we aren't actually logging any range(s).. Hm?

They aren't fixed size, either :P

	/*
	 * Stale buffers do not have any data logged with them, so
	 * shortcut the dirty range checks and just emit a segment
	 * header.
	 */


> > -static void
> > -xfs_buf_item_log_segment(
> > +void
> > +xfs_buf_item_log(
> > +	struct xfs_buf_log_item	*bip,
> >  	uint			first,
> > -	uint			last,
> > -	uint			*map)
> > +	uint			last)
> >  {
> > -	uint		first_bit;
> > -	uint		last_bit;
> > -	uint		bits_to_set;
> > -	uint		bits_set;
> > -	uint		word_num;
> > -	uint		*wordp;
> > -	uint		bit;
> > -	uint		end_bit;
> > -	uint		mask;
> > +	struct xfs_bli_range	*rp = NULL;
> > +	int			i;
> > +	ASSERT(last != 0);
> 
> The current code looks like it implicitly handles this case.

Yes, it may, but logging a zero size dirty region is simply wrong.

> Asserts
> aside, it looks like this code could essentially add the range, fail to
> size it correctly (due to the earlier check in the _size() path), but
> then continue to log it based on the existing xfs_buf_item_log_segment()
> code that has been shifted over to xfs_buf_item_format_segment().
> 
> The interface requests an inclusive range, so perhaps we should just
> check for last == 0 (assuming first == 0) and bump last so the roundup
> and all subsequent code continues to behave exactly as it does today.

No code today passes last == 0 into this function. I want to make
sure it stays taht way, because it's indicative of a bug in the code
that is calling xfs_buf_item_log().

> >  	/*
> >  	 * Finally, set any bits left to be set in one last partial word.
> > +	 * Case 3a: Extend last slot.
> > +	 *
> > +	 * If the range is beyond the last slot, extend the last slot to
> > +	 * cover it. This treated the same as if an overlap existed with
> > +	 * the last range.
> >  	 */
> > -	end_bit = bits_to_set - bits_set;
> > -	if (end_bit) {
> > -		mask = (1U << end_bit) - 1;
> > -		*wordp |= mask;
> > +	if (i == XFS_BLI_RANGES) {
> > +		ASSERT(bip->bli_ranges == XFS_BLI_RANGES);
> > +		rp = &bip->bli_range[XFS_BLI_RANGES - 1];
> > +
> > +		if (first < rp->first)
> > +			rp->first = rounddown(first, XFS_BLF_CHUNK);
> > +		if (last > rp->last)
> > +			rp->last = roundup(last, XFS_BLF_CHUNK) - 1;
> > +		goto merge;
> >  	}
> 
> If I read this right, a 5th range arbitrarily extends the last range,
> regardless of where that range sits in the buffer. For example, if we've
> logged 4 small (128 byte), non-overlapping ranges within [4k-64k], then
> say we log 0-128, we end up logging the entire 64k buffer.

Yup, I just did that for simplicity and convenience.

> It would be nice to be a little smarter here. A couple options could be
> to merge with the first buffer that starts after the new range rather
> than just using the last, or perhaps implementing a mechanism to
> condense non-overlapping ranges to free a slot for a new range if doing
> so would reduce the overall footprint.
> 
> Note that the latter sounded like overkill when I first thought of it,
> but I think it may be possible to enhance the existing merge algorithm
> you've already included into something that could merge non-adjacent
> ranges based on an optional "weight" parameter that describes the
> minimum distance between the new range and the closest existing range.
> With something of that nature factored into a separate helper, it may
> not be that difficult to make a decision on whether to condense, merge
> or pick an existing range to extend. Worth a thought, at least...

Pretty simple to do that, now that I look at it. We don't even need
a weight calculation because the ranges are ordered and we can
easily detect when the incoming range falls between two entries.

I'll post an updated version once I've tested it.

Thanks for looking at this, Brian!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
