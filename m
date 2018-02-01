Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38612 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbeBAFLe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 00:11:34 -0500
Date: Wed, 31 Jan 2018 21:11:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: byte range buffer dirty region tracking
Message-ID: <20180201051128.GO4849@magnolia>
References: <20180201010514.30233-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201010514.30233-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 12:05:14PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> One of the biggest performance problems with large directory block
> sizes is the CPU overhead in maintaining the buffer log item direty
> region bitmap.  The bit manipulations and buffer region mapping
> calls are right at the top of the profiles when running tests on 64k
> directory buffers:
> 
>   14.65%  [kernel]             [k] memcpy
>    8.57%  [kernel]             [k] xfs_next_bit
>    4.96%  [kernel]             [k] xfs_buf_item_format
>    4.83%  [kernel]             [k] xfs_buf_item_size_segment.isra.4
>    4.44%  [kernel]             [k] xfs_buf_offset
> 
> 
> 
> The memcpy is the copying of the dirty regions into the log vec
> array, but almost twice as much CPU time is spent working out what
> needs to be copied and where it needs to be copied from. As a
> result, a debug kernel running a parallel fsmark file create
> workload we see performance like this on a 64k block size directory:
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>      0      1600000            0     175994.3         13120040
>      0      3200000            0     167829.7         14089107
>      0      4800000            0     159274.7         15217029
>      0      6400000            0     150097.3         16543647
> ....
> 
> In contrast, a 4k directory block size returns create rates around
> 310,000 files/s - almost 3x faster for the same CPU burn.
> 
> This patch switching the dirty range tracking to just the first and
> last modified bytes in 4 separate regions on the buffer. This only
> gets converted to a bitmap when the item is formatted into the CIL
> log vector array.  Hence the profile of the relevant formatting
> functions now looks like:
> 
>   22.21%  [kernel]  [k] memcpy
>    0.51%  [kernel]  [k] xfs_buf_item_init
>    0.49%  [kernel]  [k] xfs_buf_item_unlock
>    0.39%  [kernel]  [k] xfs_buf_item_size
>    0.29%  [kernel]  [k] xfs_buf_item_format
>    0.20%  [kernel]  [k] xfs_buf_item_log
>    0.14%  [kernel]  [k] xfs_buf_item_committing
> 
> And the performance is:
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>      0      1600000            0     224963.5         12631894
>      0      3200000            0     226142.4         12608851
>      0      4800000            0     237453.1         12509915
>      0      6400000            0     233356.8         12939907
> 
> Substantially higher.
> `
> The memcpy time is higher because that's where we spend most of
> the CPU we saved - in the buffer formatting routine:
> 
> ....
>        __xfs_trans_commit
>         xfs_log_commit_cil
>         xfs_buf_item_format
>         xfs_buf_item_format_segment
>         xfs_buf_iomove
>         memcpy
> 
> Hence we can see that there is major reduction in buffer formatting
> overhead that translates to improved performance.
> 
> The current implementation tracks, at most, four dirty regions per
> buffer.  The nature of directory operations result in almost
> operation modifying a header in the buffer, a tail section in the
> buffer and then some number of bytes/regions in the middle of the
> buffer.
> 
> If we just track a single region, it will almost always cover the
> entire directory buffer as we do updates to both the head and tail
> of most directory buffers.  That's a fairly large cost in terms of
> log space and CPU overhead for random individual operations.
> Similarly, increasing the number of regions to 8 (from 4) reduces
> performance by 5-10%, so the gains from tracking multiple regions
> tail off very quickly.
> 
> We also have to consider non-directory buffer modification patterns.
> freespace, inode and extent btrees are the other major types of
> buffers that get logged, but they also have modification patterns
> that lend themselves well to a small number of ranges for dirty
> tracking. That is, each btree block is kept compact, so when we
> insert or remove a record or pointer we shift then higher
> records/ptrs up or down as a block, and then log the lot of them.
> And they also often have a header that is dirtied with each
> insert/delete, so typically there are usually only one or two dirty
> ranges in a btree block.
> 
> The only metadata type that really seems to benefit from fine
> grained dirty range logging is the inode buffers. Specifically, for
> v4 superblocks the create transaction only dirties the regions of
> the inode core, so for 256 byte inodes only dirties every alternate
> bitmap segment.  Dirty range tracking will double the required log
> bandwidth of inode buffers during create (roughly 25% increase on a
> 4k directory block size filesystem). Typically this won't result in
> a noticable performance differential (except in inode creation
> benchmarks) on typical systems because the log is generally far from
> being bandwidth bound.
> 
> For v5 filesystems, even this isn't an issue because the initialised
> inode buffers are XFS_BLI_ORDERED buffers and so their contents
> aren't logged.
> 
> The same problem happens with unlinks due to the unlinked list being
> logged via the inode buffer. Again this results in an increase
> in log bandwidth on both v4 and v5 filesystems, but there isn't any
> performance differential that occurs because, again, the log isn't
> bandwidth bound. As it is, there is an existing plan of improvement
> to the unlinked list logging (moving the unlinked list logging into
> the inode core transaction) and hence that will avoid any extra
> overhead here as well.
> 
> Hence the overall CPU reduction benefits of minimal dirty range
> tracking versus fine grained dirty bit tracking are overall going to
> be beneficial to performance and throughput on current (v5) format
> filesystems.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c      |   2 +
>  fs/xfs/xfs_buf_item.c | 431 +++++++++++++++++++++++++-------------------------
>  fs/xfs/xfs_buf_item.h |  19 +++
>  3 files changed, 238 insertions(+), 214 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d1da2ee9e6db..7621fabeb505 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1583,6 +1583,8 @@ xfs_buf_iomove(
>  		page = bp->b_pages[page_index];
>  		csize = min_t(size_t, PAGE_SIZE - page_offset,
>  				      BBTOB(bp->b_io_length) - boff);
> +		if (boff + csize > bend)
> +			csize = bend - boff;

How often does csize exceed bend?

>  		ASSERT((csize + page_offset) <= PAGE_SIZE);
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 270ddb4d2313..0629d09406a4 100644
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
>  }
>  
>  /*
> @@ -136,7 +98,9 @@ xfs_buf_item_size(
>  	int			*nbytes)
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> -	int			i;
> +	struct xfs_buf	*bp = bip->bli_buf;

Indentation before '*bp'...

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
> @@ -169,17 +134,45 @@ xfs_buf_item_size(
>  
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
> +	ASSERT(bip->bli_range[0].last != 0);
> +	if (bip->bli_range[0].last == 0) {
> +		/* clean! */
> +		ASSERT(bip->bli_range[0].first == 0);

Hm, so given that the firsts are initialized to UINT_MAX, this only
happens if the first (only?) range we log is ... (0, 0) ?

Mildly confused about what these asserts are going after, since the
first one implies that this shouldn't happen anyway.

> +		return;
>  	}
> +
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
> +	}
> +
> +	for (j = 0; j < bip->bli_ranges; j++)
> +		*nbytes += bip->bli_range[j].last - bip->bli_range[j].first;
> +
> +
>  	trace_xfs_buf_item_size(bip);
>  }
>  
> @@ -192,7 +185,6 @@ xfs_buf_item_copy_iovec(
>  	int			first_bit,
>  	uint			nbits)
>  {
> -	offset += first_bit * XFS_BLF_CHUNK;
>  	xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BCHUNK,
>  			xfs_buf_offset(bp, offset),
>  			nbits * XFS_BLF_CHUNK);
> @@ -215,14 +207,18 @@ xfs_buf_item_format_segment(
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
> @@ -234,16 +230,6 @@ xfs_buf_item_format_segment(
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
>  
> @@ -258,46 +244,40 @@ xfs_buf_item_format_segment(
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
> +	start &= ~((1 << XFS_BLF_SHIFT) - 1);
> +	first_bit = start >> XFS_BLF_SHIFT;
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
> @@ -314,8 +294,8 @@ xfs_buf_item_format(
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
> @@ -326,7 +306,6 @@ xfs_buf_item_format(
>  	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED) ||
>  	       (bip->bli_flags & XFS_BLI_STALE));
>  
> -
>  	/*
>  	 * If it is an inode buffer, transfer the in-memory state to the
>  	 * format flags and clear the in-memory state.
> @@ -349,10 +328,36 @@ xfs_buf_item_format(
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
> @@ -737,6 +742,9 @@ xfs_buf_item_init(
>  	int			error;
>  	int			i;
>  
> +	for (i = 0; i < XFS_BLI_RANGES; i++)
> +		bip->bli_range[i].first = UINT_MAX;
> +
>  	/*
>  	 * Check to see if there is already a buf log item for
>  	 * this buffer. If we do already have one, there is
> @@ -788,133 +796,136 @@ xfs_buf_item_init(
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
> @@ -923,15 +934,7 @@ bool
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

"...ranges is probably..." ?

Mostly looks ok, but whew. :)

--D

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
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
