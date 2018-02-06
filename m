Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752236AbeBFQVn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Feb 2018 11:21:43 -0500
Date: Tue, 6 Feb 2018 11:21:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: byte range buffer dirty region tracking
Message-ID: <20180206162141.GA3862@bfoster.bfoster>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180205003415.dn6elcqb4kae3xle@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180205003415.dn6elcqb4kae3xle@destitution>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 05, 2018 at 11:34:15AM +1100, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> One of the biggest performance problems with large directory block
> sizes is the CPU overhead in maintaining the buffer log item direty
> region bitmap.  The bit manipulations and buffer region mapping
> calls are right at the top of the profiles when running tests on 64k
> directory buffers:
> 
...
> 
>  fs/xfs/xfs_buf.c      |  23 ++-
>  fs/xfs/xfs_buf_item.c | 437 ++++++++++++++++++++++++++------------------------
>  fs/xfs/xfs_buf_item.h |  19 +++
>  3 files changed, 261 insertions(+), 218 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 270ddb4d2313..bc6514a08760 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -66,50 +66,12 @@ xfs_buf_item_size_segment(
>  	int				*nvecs,
>  	int				*nbytes)
>  {
> -	struct xfs_buf			*bp = bip->bli_buf;
> -	int				next_bit;
> -	int				last_bit;
> -
> -	last_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
> -	if (last_bit == -1)
> -		return;
> -
>  	/*
>  	 * initial count for a dirty buffer is 2 vectors - the format structure
> -	 * and the first dirty region.
> +	 * and the dirty region. Dirty region is accounted for separately.
>  	 */
>  	*nvecs += 2;
> -	*nbytes += xfs_buf_log_format_size(blfp) + XFS_BLF_CHUNK;
> -
> -	while (last_bit != -1) {
> -		/*
> -		 * This takes the bit number to start looking from and
> -		 * returns the next set bit from there.  It returns -1
> -		 * if there are no more bits set or the start bit is
> -		 * beyond the end of the bitmap.
> -		 */
> -		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
> -					last_bit + 1);
> -		/*
> -		 * If we run out of bits, leave the loop,
> -		 * else if we find a new set of bits bump the number of vecs,
> -		 * else keep scanning the current set of bits.
> -		 */
> -		if (next_bit == -1) {
> -			break;
> -		} else if (next_bit != last_bit + 1) {
> -			last_bit = next_bit;
> -			(*nvecs)++;
> -		} else if (xfs_buf_offset(bp, next_bit * XFS_BLF_CHUNK) !=
> -			   (xfs_buf_offset(bp, last_bit * XFS_BLF_CHUNK) +
> -			    XFS_BLF_CHUNK)) {
> -			last_bit = next_bit;
> -			(*nvecs)++;
> -		} else {
> -			last_bit++;
> -		}
> -		*nbytes += XFS_BLF_CHUNK;
> -	}
> +	*nbytes += xfs_buf_log_format_size(blfp);

This function has been reduced such that the comment at the top could
probably use updating. In fact, we may be able to kill it entirely if
it's not used anywhere else..?

>  }
>  
>  /*
> @@ -136,7 +98,9 @@ xfs_buf_item_size(
>  	int			*nbytes)
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> -	int			i;
> +	struct xfs_buf		*bp = bip->bli_buf;
> +	uint			offset;
> +	int			i, j;
>  
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  	if (bip->bli_flags & XFS_BLI_STALE) {
> @@ -155,6 +119,7 @@ xfs_buf_item_size(
>  	}
>  
>  	ASSERT(bip->bli_flags & XFS_BLI_LOGGED);
> +	ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
>  
>  	if (bip->bli_flags & XFS_BLI_ORDERED) {
>  		/*
> @@ -167,19 +132,53 @@ xfs_buf_item_size(
>  		return;
>  	}
>  
> +
> +	/*
> +	 * If the last byte of teh first range is zero, then we've been fed a
> +	 * clean buffer with a XFS_BLI_DIRTY flag set. This should never happen,
> +	 * but be paranoid and catch it. If it does happen, then first should be
> +	 * zero, too.
> +	 */
> +	if (bip->bli_range[0].last == 0) {
> +		ASSERT(0);
> +		ASSERT(bip->bli_range[0].first == 0);
> +		return;
> +	}

Isn't first == last == 0 a valid, inclusive range? Perhaps this makes
sense since by this point the range should be rounded out to the chunk
size, but more on that below..

> +
>  	/*
>  	 * the vector count is based on the number of buffer vectors we have
> -	 * dirty bits in. This will only be greater than one when we have a
> +	 * dirty ranges in. This will only be greater than one when we have a
>  	 * compound buffer with more than one segment dirty. Hence for compound
> -	 * buffers we need to track which segment the dirty bits correspond to,
> -	 * and when we move from one segment to the next increment the vector
> -	 * count for the extra buf log format structure that will need to be
> -	 * written.
> +	 * buffers we need to track which segment the dirty ranges correspond
> +	 * to, and when we move from one segment to the next increment the
> +	 * vector count for the extra buf log format structure that will need to
> +	 * be written.
>  	 */
> -	for (i = 0; i < bip->bli_format_count; i++) {
> -		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
> -					  nvecs, nbytes);
> +	for (i = 0, offset = 0;
> +	     i < bip->bli_format_count;
> +	     i++, offset += BBTOB(bp->b_maps[i].bm_len)) {
> +		/* Only format dirty regions */
> +		for (j = 0; j < bip->bli_ranges; j++) {
> +			struct xfs_bli_range *rp = &bip->bli_range[j];
> +
> +			/* range ends before segment start, check next range */
> +			if (rp->last < offset)
> +				continue;
> +
> +			/* range beyond segment end, check next segment */
> +			if (rp->first > offset + BBTOB(bp->b_maps[i].bm_len))
> +				break;
> +
> +			/* dirty range overlaps segment, need headers */
> +			xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
> +						  nvecs, nbytes);
> +		}
>  	}
> +
> +	for (j = 0; j < bip->bli_ranges; j++)
> +		*nbytes += bip->bli_range[j].last - bip->bli_range[j].first;
> +
> +
>  	trace_xfs_buf_item_size(bip);
>  }
>  
> @@ -192,7 +191,6 @@ xfs_buf_item_copy_iovec(
>  	int			first_bit,
>  	uint			nbits)
>  {
> -	offset += first_bit * XFS_BLF_CHUNK;
>  	xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BCHUNK,
>  			xfs_buf_offset(bp, offset),
>  			nbits * XFS_BLF_CHUNK);
> @@ -215,14 +213,18 @@ xfs_buf_item_format_segment(
>  	struct xfs_buf_log_item	*bip,
>  	struct xfs_log_vec	*lv,
>  	struct xfs_log_iovec	**vecp,
> +	struct xfs_bli_range	*rp,
>  	uint			offset,
> +	uint			length,
>  	struct xfs_buf_log_format *blfp)
>  {
>  	struct xfs_buf		*bp = bip->bli_buf;
> +	char			*buf;
>  	uint			base_size;
> +	uint			start;
> +	uint			end;
>  	int			first_bit;
>  	int			last_bit;
> -	int			next_bit;
>  	uint			nbits;
>  
>  	/* copy the flags across from the base format item */
> @@ -234,16 +236,6 @@ xfs_buf_item_format_segment(
>  	 * memory structure.
>  	 */
>  	base_size = xfs_buf_log_format_size(blfp);
> -
> -	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
> -	if (!(bip->bli_flags & XFS_BLI_STALE) && first_bit == -1) {
> -		/*
> -		 * If the map is not be dirty in the transaction, mark
> -		 * the size as zero and do not advance the vector pointer.
> -		 */
> -		return;
> -	}
> -
>  	blfp = xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
>  	blfp->blf_size = 1;

Perhaps we should set the datamap bits before we format out the blf? ;)

>  
> @@ -258,46 +250,40 @@ xfs_buf_item_format_segment(
>  		return;
>  	}
>  
> +	blfp->blf_size++;
>  
>  	/*
> -	 * Fill in an iovec for each set of contiguous chunks.
> +	 * Now we need to set the bits in the bitmap and set up the iovecs
> +	 * appropriately. We know there is a contiguous range in this buffer
> +	 * than needs to be set, so find the first bit, the last bit, and
> +	 * go from there.
>  	 */
> -	last_bit = first_bit;
> -	nbits = 1;
> -	for (;;) {
> -		/*
> -		 * This takes the bit number to start looking from and
> -		 * returns the next set bit from there.  It returns -1
> -		 * if there are no more bits set or the start bit is
> -		 * beyond the end of the bitmap.
> -		 */
> -		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
> -					(uint)last_bit + 1);
> -		/*
> -		 * If we run out of bits fill in the last iovec and get out of
> -		 * the loop.  Else if we start a new set of bits then fill in
> -		 * the iovec for the series we were looking at and start
> -		 * counting the bits in the new one.  Else we're still in the
> -		 * same set of bits so just keep counting and scanning.
> -		 */
> -		if (next_bit == -1) {
> -			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
> -						first_bit, nbits);
> -			blfp->blf_size++;
> -			break;
> -		} else if (next_bit != last_bit + 1 ||
> -		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {

FYI... this kills the only callers of xfs_buf_item_copy_iovec() and
xfs_buf_item_straddle() so they should probably be removed.

> -			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
> -						first_bit, nbits);
> -			blfp->blf_size++;
> -			first_bit = next_bit;
> -			last_bit = next_bit;
> -			nbits = 1;
> -		} else {
> -			last_bit++;
> -			nbits++;
> -		}
> -	}
> +	start = 0;
> +	if (offset < rp->first)
> +		start = rp->first - offset;
> +	end = length - 1;
> +	if (offset + length > rp->last)
> +		end = rp->last - offset - 1;
> +

FWIW, it took me a second to identify what was going on here. It might
be useful to incorporate that we're calculating the relative byte
offsets in order to convert into the bitmap in the new comment above.

Also, I could be lost in the maze a bit here, but why the '- 1' in the
end calculation above? Isn't rp->last inclusive?

> +	start &= ~((1 << XFS_BLF_SHIFT) - 1);
> +	first_bit = start >> XFS_BLF_SHIFT;

Why the mask if we're going to right shift anyways?

> +	last_bit = end >> XFS_BLF_SHIFT;
> +	nbits = last_bit - first_bit + 1;
> +	bitmap_set((unsigned long *)blfp->blf_data_map, first_bit, nbits);
> +
> +	ASSERT(end <= length);
> +	ASSERT(start <= length);
> +	ASSERT(length >= nbits * XFS_BLF_CHUNK);
> +	/*
> +	 * Copy needs to be done a buffer page at a time as we can be logging
> +	 * unmapped buffers. hence we have to use xfs_buf_iomove() rather than a
> +	 * straight memcpy here.
> +	 */
> +	offset += first_bit * XFS_BLF_CHUNK;
> +	length = nbits * XFS_BLF_CHUNK;
> +	buf = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_BCHUNK);
> +	xfs_buf_iomove(bp, offset, length, buf, XBRW_READ);
> +	xlog_finish_iovec(lv, *vecp, length);
>  }
>  
>  /*
> @@ -314,8 +300,8 @@ xfs_buf_item_format(
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
>  	struct xfs_log_iovec	*vecp = NULL;
> -	uint			offset = 0;
> -	int			i;
> +	uint			offset;
> +	int			i, j;
>  
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
> @@ -326,7 +312,6 @@ xfs_buf_item_format(
>  	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED) ||
>  	       (bip->bli_flags & XFS_BLI_STALE));
>  
> -
>  	/*
>  	 * If it is an inode buffer, transfer the in-memory state to the
>  	 * format flags and clear the in-memory state.
> @@ -349,10 +334,36 @@ xfs_buf_item_format(
>  		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
>  	}
>  
> -	for (i = 0; i < bip->bli_format_count; i++) {
> -		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
> -					    &bip->bli_formats[i]);
> -		offset += BBTOB(bp->b_maps[i].bm_len);
> +	for (i = 0, offset = 0;
> +	     i < bip->bli_format_count;
> +	     i++, offset += BBTOB(bp->b_maps[i].bm_len)) {
> +
> +		/* stale regions cover the entire segment */

Something like "stale regions are fixed size" seems more accurate, since
we aren't actually logging any range(s).. Hm?

> +		if (bip->bli_flags & XFS_BLI_STALE) {
> +			xfs_buf_item_format_segment(bip, lv, &vecp, NULL, offset,
> +						    BBTOB(bp->b_maps[i].bm_len),
> +						    &bip->bli_formats[i]);
> +			continue;
> +		}
> +
> +		/* only format dirty ranges over the current segment */
> +		for (j = 0; j < bip->bli_ranges; j++) {
> +			struct xfs_bli_range *rp = &bip->bli_range[j];
> +
> +			/* range ends before segment start, check next range */
> +			if (rp->last < offset)
> +				continue;
> +
> +			/* range beyond segment end, check next segment */
> +			if (rp->first > offset + BBTOB(bp->b_maps[i].bm_len))
> +				break;
> +
> +			/* dirty range overlaps segment, need headers */
> +			xfs_buf_item_format_segment(bip, lv, &vecp, rp, offset,
> +						    BBTOB(bp->b_maps[i].bm_len),
> +						    &bip->bli_formats[i]);
> +
> +		}
>  	}
>  
>  	/*
> @@ -751,6 +762,9 @@ xfs_buf_item_init(
>  	bip = kmem_zone_zalloc(xfs_buf_item_zone, KM_SLEEP);
>  	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
>  	bip->bli_buf = bp;
> +	for (i = 0; i < XFS_BLI_RANGES; i++)
> +		bip->bli_range[i].first = UINT_MAX;
> +
>  
>  	/*
>  	 * chunks is the number of XFS_BLF_CHUNK size pieces the buffer
> @@ -788,133 +802,136 @@ xfs_buf_item_init(
>  
>  /*
>   * Mark bytes first through last inclusive as dirty in the buf
> - * item's bitmap.
> + * record dirty regions on the buffer.
>   */
> -static void
> -xfs_buf_item_log_segment(
> +void
> +xfs_buf_item_log(
> +	struct xfs_buf_log_item	*bip,
>  	uint			first,
> -	uint			last,
> -	uint			*map)
> +	uint			last)
>  {
> -	uint		first_bit;
> -	uint		last_bit;
> -	uint		bits_to_set;
> -	uint		bits_set;
> -	uint		word_num;
> -	uint		*wordp;
> -	uint		bit;
> -	uint		end_bit;
> -	uint		mask;
> +	struct xfs_bli_range	*rp = NULL;
> +	int			i;
> +	ASSERT(last != 0);

The current code looks like it implicitly handles this case. Asserts
aside, it looks like this code could essentially add the range, fail to
size it correctly (due to the earlier check in the _size() path), but
then continue to log it based on the existing xfs_buf_item_log_segment()
code that has been shifted over to xfs_buf_item_format_segment().

The interface requests an inclusive range, so perhaps we should just
check for last == 0 (assuming first == 0) and bump last so the roundup
and all subsequent code continues to behave exactly as it does today.

> +	ASSERT(first <= last);
> +	ASSERT(last < BBTOB(bip->bli_buf->b_length));
> +
> +	/* simple case - first range being stored */
> +	if (!bip->bli_ranges) {
> +		bip->bli_ranges = 1;
> +		bip->bli_range[0].first = rounddown(first, XFS_BLF_CHUNK);
> +		bip->bli_range[0].last = roundup(last, XFS_BLF_CHUNK);
> +		ASSERT(bip->bli_range[0].last != 0);
> +		ASSERT(bip->bli_range[0].first <= bip->bli_range[0].last);
> +		return;
> +	}
>  
> -	/*
> -	 * Convert byte offsets to bit numbers.
> -	 */
> -	first_bit = first >> XFS_BLF_SHIFT;
> -	last_bit = last >> XFS_BLF_SHIFT;
> +	/* 2nd case: search for overlaps and extend */
> +	for (i = 0; i < bip->bli_ranges; i++) {
> +		rp = &bip->bli_range[i];
>  
> -	/*
> -	 * Calculate the total number of bits to be set.
> -	 */
> -	bits_to_set = last_bit - first_bit + 1;
> +		/* wholly within an existing dirty range, we're done */
> +		if (first >= rp->first && last <= rp->last)
> +			return;
> +		/* no overlap, continue */
> +		if (first > rp->last || last < rp->first)
> +			continue;
>  
> -	/*
> -	 * Get a pointer to the first word in the bitmap
> -	 * to set a bit in.
> -	 */
> -	word_num = first_bit >> BIT_TO_WORD_SHIFT;
> -	wordp = &map[word_num];
> +		/* left edge overlap, extend */
> +		if (first < rp->first)
> +			rp->first = rounddown(first, XFS_BLF_CHUNK);
>  
> -	/*
> -	 * Calculate the starting bit in the first word.
> -	 */
> -	bit = first_bit & (uint)(NBWORD - 1);
> +		/* right edge overlap, extend */
> +		if (last > rp->last)
> +			rp->last = roundup(last, XFS_BLF_CHUNK) - 1;
>  
> -	/*
> -	 * First set any bits in the first word of our range.
> -	 * If it starts at bit 0 of the word, it will be
> -	 * set below rather than here.  That is what the variable
> -	 * bit tells us. The variable bits_set tracks the number
> -	 * of bits that have been set so far.  End_bit is the number
> -	 * of the last bit to be set in this word plus one.
> -	 */
> -	if (bit) {
> -		end_bit = MIN(bit + bits_to_set, (uint)NBWORD);
> -		mask = ((1U << (end_bit - bit)) - 1) << bit;
> -		*wordp |= mask;
> -		wordp++;
> -		bits_set = end_bit - bit;
> -	} else {
> -		bits_set = 0;
> +		goto merge;
>  	}
>  
> -	/*
> -	 * Now set bits a whole word at a time that are between
> -	 * first_bit and last_bit.
> -	 */
> -	while ((bits_to_set - bits_set) >= NBWORD) {
> -		*wordp |= 0xffffffff;
> -		bits_set += NBWORD;
> -		wordp++;
> -	}
> +	/* 3rd case: not found, insert or extend */
> +	ASSERT(i == bip->bli_ranges);
>  
>  	/*
>  	 * Finally, set any bits left to be set in one last partial word.
> +	 * Case 3a: Extend last slot.
> +	 *
> +	 * If the range is beyond the last slot, extend the last slot to
> +	 * cover it. This treated the same as if an overlap existed with
> +	 * the last range.
>  	 */
> -	end_bit = bits_to_set - bits_set;
> -	if (end_bit) {
> -		mask = (1U << end_bit) - 1;
> -		*wordp |= mask;
> +	if (i == XFS_BLI_RANGES) {
> +		ASSERT(bip->bli_ranges == XFS_BLI_RANGES);
> +		rp = &bip->bli_range[XFS_BLI_RANGES - 1];
> +
> +		if (first < rp->first)
> +			rp->first = rounddown(first, XFS_BLF_CHUNK);
> +		if (last > rp->last)
> +			rp->last = roundup(last, XFS_BLF_CHUNK) - 1;
> +		goto merge;
>  	}

If I read this right, a 5th range arbitrarily extends the last range,
regardless of where that range sits in the buffer. For example, if we've
logged 4 small (128 byte), non-overlapping ranges within [4k-64k], then
say we log 0-128, we end up logging the entire 64k buffer.

It would be nice to be a little smarter here. A couple options could be
to merge with the first buffer that starts after the new range rather
than just using the last, or perhaps implementing a mechanism to
condense non-overlapping ranges to free a slot for a new range if doing
so would reduce the overall footprint.

Note that the latter sounded like overkill when I first thought of it,
but I think it may be possible to enhance the existing merge algorithm
you've already included into something that could merge non-adjacent
ranges based on an optional "weight" parameter that describes the
minimum distance between the new range and the closest existing range.
With something of that nature factored into a separate helper, it may
not be that difficult to make a decision on whether to condense, merge
or pick an existing range to extend. Worth a thought, at least...

Brian

> -}
>  
> -/*
> - * Mark bytes first through last inclusive as dirty in the buf
> - * item's bitmap.
> - */
> -void
> -xfs_buf_item_log(
> -	struct xfs_buf_log_item	*bip,
> -	uint			first,
> -	uint			last)
> -{
> -	int			i;
> -	uint			start;
> -	uint			end;
> -	struct xfs_buf		*bp = bip->bli_buf;
> +	/* Case 3b: insert new range.
> +	 *
> +	 * Find the insertion point for the new range, then make a hole
> +	 * and insert the new range.
> +	 */
> +	for (i = 0; i < bip->bli_ranges; i++) {
> +		rp = &bip->bli_range[i];
>  
> +		/* order ranges by ascending offset */
> +		if (last < rp->first)
> +			break;
> +	}
> +	/* shift down and insert */
> +	ASSERT(i < XFS_BLI_RANGES);
> +	rp = &bip->bli_range[i];
> +	if (i < XFS_BLI_RANGES - 1)
> +		memmove(rp + 1, rp, sizeof(*rp) * (bip->bli_ranges - i));
> +	bip->bli_ranges++;
> +	rp->first = rounddown(first, XFS_BLF_CHUNK);
> +	rp->last = roundup(last, XFS_BLF_CHUNK) - 1;
> +
> +merge:
>  	/*
> -	 * walk each buffer segment and mark them dirty appropriately.
> +	 * Check for overlaping ranges and merge them. If there is only one
> +	 * range, there is nothing to merge so bail early.
>  	 */
> -	start = 0;
> -	for (i = 0; i < bip->bli_format_count; i++) {
> -		if (start > last)
> -			break;
> -		end = start + BBTOB(bp->b_maps[i].bm_len) - 1;
> +	if (bip->bli_ranges == 1)
> +		return;
> +
> +	for (i = 0; i < bip->bli_ranges - 1; i++) {
> +		struct xfs_bli_range *rp_next;
> +
> +		rp = &bip->bli_range[i];
> +		rp_next = &bip->bli_range[i + 1];
>  
> -		/* skip to the map that includes the first byte to log */
> -		if (first > end) {
> -			start += BBTOB(bp->b_maps[i].bm_len);
> +
> +check_merge:
> +		ASSERT(rp->last != 0);
> +		ASSERT(rp->first <= rp->last);
> +
> +		/* no overlap or adjacent, move on */
> +		if (rp->last < rp_next->first - 1)
>  			continue;
> -		}
>  
>  		/*
> -		 * Trim the range to this segment and mark it in the bitmap.
> -		 * Note that we must convert buffer offsets to segment relative
> -		 * offsets (e.g., the first byte of each segment is byte 0 of
> -		 * that segment).
> +		 * overlap: select lowest first, highest last, remove the merged
> +		 * range (rp_next) and then go back and check the next range for
> +		 * whether it can be merged (e.g. we have 4 separate ranges,
> +		 * then something logs the buffer entirely. This merges all
> +		 * ranges into one).
>  		 */
> -		if (first < start)
> -			first = start;
> -		if (end > last)
> -			end = last;
> -		xfs_buf_item_log_segment(first - start, end - start,
> -					 &bip->bli_formats[i].blf_data_map[0]);
> -
> -		start += BBTOB(bp->b_maps[i].bm_len);
> +		rp->first = min(rp->first, rp_next->first);
> +		rp->last = max(rp->last, rp_next->last);
> +		if (i + 2 < bip->bli_ranges)
> +			memmove(rp_next, rp_next + 1, sizeof(*rp) *
> +						(bip->bli_ranges - i - 2));
> +		bip->bli_ranges--;
> +		if (i < bip->bli_ranges - 1)
> +			goto check_merge;
>  	}
>  }
>  
> -
>  /*
>   * Return true if the buffer has any ranges logged/dirtied by a transaction,
>   * false otherwise.
> @@ -923,15 +940,7 @@ bool
>  xfs_buf_item_dirty_format(
>  	struct xfs_buf_log_item	*bip)
>  {
> -	int			i;
> -
> -	for (i = 0; i < bip->bli_format_count; i++) {
> -		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
> -			     bip->bli_formats[i].blf_map_size))
> -			return true;
> -	}
> -
> -	return false;
> +	return bip->bli_ranges > 0;
>  }
>  
>  STATIC void
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 643f53dcfe51..9b278c3a2db9 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -57,6 +57,25 @@ struct xfs_buf_log_item {
>  	unsigned int		bli_recur;	/* lock recursion count */
>  	atomic_t		bli_refcount;	/* cnt of tp refs */
>  	int			bli_format_count;	/* count of headers */
> +
> +	/*
> +	 * logging ranges. Keep a small number of distinct ranges rather than a
> +	 * bitmap which is expensive to maintain.
> +	 * 4 separate ranges s probably optimal so that we
> +	 * can log separate header, tail and content changes (e.g. for dir
> +	 * structures) without capturing the entire buffer unnecessarily for
> +	 * isolated changes.
> +	 *
> +	 * Note: ranges are 32 bit values because we have to support an end
> +	 * range value of 0x10000....
> +	 */
> +#define XFS_BLI_RANGES	4
> +	struct xfs_bli_range {
> +		uint32_t	first;
> +		uint32_t	last;
> +	}			bli_range[XFS_BLI_RANGES];
> +	int			bli_ranges;
> +
>  	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
>  	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
>  };
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
