Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750748AbdEAScq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 May 2017 14:32:46 -0400
Date: Mon, 1 May 2017 14:32:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: refactor dir2 leaf readahead shadow buffer
 cleverness
Message-ID: <20170501183240.GA3775@bfoster.bfoster>
References: <20170428194652.GG22884@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170428194652.GG22884@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Fri, Apr 28, 2017 at 12:46:52PM -0700, Darrick J. Wong wrote:
> Currently, the dir2 leaf block getdents function uses a complex state
> tracking mechanism to create a shadow copy of the block mappings and
> then uses the shadow copy to schedule readahead.  Since the read and
> readahead functions are perfectly capable of reading the mappings
> themselves, we can tear all that out in favor of a simpler function that
> simply keeps pushing the readahead window further out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: use sliding window to constrain the amount of readahead
> v2: fix readahead of more than ra_want
> ---

Thanks for the updates. This looks much more simple and seems true to
the current readahead behavior. The code also looks fine to me (one bit
of whitespace damage noted below).

That aside, have you happened to test this against a huge/ugly directory
to verify it works as expected? Note that I don't think in depth
performance analysis is required. Verification of any kind of dir that
is known to benefit from readahead is probably sufficient IMO. Perhaps
dm-delay with a small enough latency to allow us to measure the effect
of readahead could help us here.

>  fs/xfs/xfs_dir2_readdir.c |  316 ++++++++++++---------------------------------
>  1 file changed, 82 insertions(+), 234 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 20b7a5c..d05c1ec 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -243,214 +243,98 @@ xfs_dir2_block_getdents(
>  	return 0;
>  }
>  
...
>  	/*
> -	 * Do we need more readahead?
> -	 * Each loop tries to process 1 full dir blk; last may be partial.
> +	 * Start readahead for the next bufsize's worth of dir data blocks.
> +	 * We may have already issued readahead for some of that range;
> +	 * ra_blk tracks the last block we tried to read(ahead).
>  	 */
> +	ra_want = howmany(bufsize + geo->blksize, (1 << geo->fsblog));
> +	if (*ra_blk >= last_da)
> +		goto out;
> +	else if (*ra_blk == 0)
> +		*ra_blk = map.br_startoff;
> +	next_ra = map.br_startoff + geo->fsbcount;
> +	if (next_ra >= last_da)
> +		goto out_no_ra;
> +	found = xfs_iext_lookup_extent(dp, ifp, next_ra, &idx, &map);
> +	if (!found || map.br_startoff >= last_da)
> +		goto out_no_ra;
> +	xfs_trim_extent(&map, next_ra, last_da - next_ra);
> + 

^ trailing space.

Brian

> +	/* Start ra for each dir (not fs) block that has a mapping. */
>  	blk_start_plug(&plug);
> -	for (mip->ra_index = mip->ra_offset = i = 0;
> -	     mip->ra_want > mip->ra_current && i < mip->map_blocks;
> -	     i += geo->fsbcount) {
> -		ASSERT(mip->ra_index < mip->map_valid);
> -		/*
> -		 * Read-ahead a contiguous directory block.
> -		 */
> -		if (i > mip->ra_current &&
> -		    (map[mip->ra_index].br_blockcount - mip->ra_offset) >=
> -		    geo->fsbcount) {
> -			xfs_dir3_data_readahead(dp,
> -				map[mip->ra_index].br_startoff + mip->ra_offset,
> -				XFS_FSB_TO_DADDR(dp->i_mount,
> -					map[mip->ra_index].br_startblock +
> -							mip->ra_offset));
> -			mip->ra_current = i;
> -		}
> -
> -		/*
> -		 * Read-ahead a non-contiguous directory block.  This doesn't
> -		 * use our mapping, but this is a very rare case.
> -		 */
> -		else if (i > mip->ra_current) {
> -			xfs_dir3_data_readahead(dp,
> -					map[mip->ra_index].br_startoff +
> -							mip->ra_offset, -1);
> -			mip->ra_current = i;
> -		}
> -
> -		/*
> -		 * Advance offset through the mapping table, processing a full
> -		 * dir block even if it is fragmented into several extents.
> -		 * But stop if we have consumed all valid mappings, even if
> -		 * it's not yet a full directory block.
> -		 */
> -		for (j = 0;
> -		     j < geo->fsbcount && mip->ra_index < mip->map_valid;
> -		     j += length ) {
> -			/*
> -			 * The rest of this extent but not more than a dir
> -			 * block.
> -			 */
> -			length = min_t(int, geo->fsbcount - j,
> -					map[mip->ra_index].br_blockcount -
> -							mip->ra_offset);
> -			mip->ra_offset += length;
> -
> -			/*
> -			 * Advance to the next mapping if this one is used up.
> -			 */
> -			if (mip->ra_offset == map[mip->ra_index].br_blockcount) {
> -				mip->ra_offset = 0;
> -				mip->ra_index++;
> +	while (ra_want > 0) {
> +		next_ra = roundup((xfs_dablk_t)map.br_startoff, geo->fsbcount);
> +		while (ra_want > 0 &&
> +		       next_ra < map.br_startoff + map.br_blockcount) {
> +			if (next_ra >= last_da) {
> +				*ra_blk = last_da;
> +				break;
> +			} else if (next_ra > *ra_blk) {
> +				xfs_dir3_data_readahead(dp, next_ra, -2);
> +				*ra_blk = next_ra;
>  			}
> +			ra_want -= geo->fsbcount;
> +			next_ra += geo->fsbcount;
> +		}
> +		found = xfs_iext_get_extent(ifp, ++idx, &map);
> +		if (!found) {
> +			*ra_blk = last_da;
> +			break;
>  		}
>  	}
>  	blk_finish_plug(&plug);
> @@ -458,6 +342,9 @@ xfs_dir2_leaf_readbuf(
>  out:
>  	*bpp = bp;
>  	return error;
> +out_no_ra:
> +	*ra_blk = last_da;
> +	goto out;
>  }
>  
>  /*
> @@ -475,14 +362,14 @@ xfs_dir2_leaf_getdents(
>  	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
>  	xfs_dir2_data_entry_t	*dep;		/* data entry */
>  	xfs_dir2_data_unused_t	*dup;		/* unused entry */
> -	int			error = 0;	/* error return value */
> -	int			length;		/* temporary length value */
> -	int			byteoff;	/* offset in current block */
> -	xfs_dir2_off_t		curoff;		/* current overall offset */
> -	xfs_dir2_off_t		newoff;		/* new curoff after new blk */
>  	char			*ptr = NULL;	/* pointer to current data */
> -	struct xfs_dir2_leaf_map_info *map_info;
>  	struct xfs_da_geometry	*geo = args->geo;
> +	xfs_dablk_t		rablk = 0;	/* current readahead block */
> +	xfs_dir2_off_t		curoff;		/* current overall offset */
> +	int			length;		/* temporary length value */
> +	int			byteoff;	/* offset in current block */
> +	int			lock_mode;
> +	int			error = 0;	/* error return value */
>  
>  	/*
>  	 * If the offset is at or past the largest allowed value,
> @@ -492,30 +379,12 @@ xfs_dir2_leaf_getdents(
>  		return 0;
>  
>  	/*
> -	 * Set up to bmap a number of blocks based on the caller's
> -	 * buffer size, the directory block size, and the filesystem
> -	 * block size.
> -	 */
> -	length = howmany(bufsize + geo->blksize, (1 << geo->fsblog));
> -	map_info = kmem_zalloc(offsetof(struct xfs_dir2_leaf_map_info, map) +
> -				(length * sizeof(struct xfs_bmbt_irec)),
> -			       KM_SLEEP | KM_NOFS);
> -	map_info->map_size = length;
> -
> -	/*
>  	 * Inside the loop we keep the main offset value as a byte offset
>  	 * in the directory file.
>  	 */
>  	curoff = xfs_dir2_dataptr_to_byte(ctx->pos);
>  
>  	/*
> -	 * Force this conversion through db so we truncate the offset
> -	 * down to get the start of the data block.
> -	 */
> -	map_info->map_off = xfs_dir2_db_to_da(geo,
> -					      xfs_dir2_byte_to_db(geo, curoff));
> -
> -	/*
>  	 * Loop over directory entries until we reach the end offset.
>  	 * Get more blocks and readahead as necessary.
>  	 */
> @@ -527,38 +396,18 @@ xfs_dir2_leaf_getdents(
>  		 * current buffer, need to get another one.
>  		 */
>  		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
> -			int	lock_mode;
> -			bool	trim_map = false;
> -
>  			if (bp) {
> -				xfs_trans_brelse(NULL, bp);
> +				xfs_trans_brelse(args->trans, bp);
>  				bp = NULL;
> -				trim_map = true;
>  			}
>  
>  			lock_mode = xfs_ilock_data_map_shared(dp);
> -			error = xfs_dir2_leaf_readbuf(args, bufsize, map_info,
> -						      &curoff, &bp, trim_map);
> +			error = xfs_dir2_leaf_readbuf(args, bufsize, &curoff,
> +					&rablk, &bp);
>  			xfs_iunlock(dp, lock_mode);
> -			if (error || !map_info->map_valid)
> +			if (error || !bp)
>  				break;
>  
> -			/*
> -			 * Having done a read, we need to set a new offset.
> -			 */
> -			newoff = xfs_dir2_db_off_to_byte(geo,
> -							 map_info->curdb, 0);
> -			/*
> -			 * Start of the current block.
> -			 */
> -			if (curoff < newoff)
> -				curoff = newoff;
> -			/*
> -			 * Make sure we're in the right block.
> -			 */
> -			else if (curoff > newoff)
> -				ASSERT(xfs_dir2_byte_to_db(geo, curoff) ==
> -				       map_info->curdb);
>  			hdr = bp->b_addr;
>  			xfs_dir3_data_check(dp, bp);
>  			/*
> @@ -643,7 +492,6 @@ xfs_dir2_leaf_getdents(
>  		ctx->pos = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
>  	else
>  		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
> -	kmem_free(map_info);
>  	if (bp)
>  		xfs_trans_brelse(NULL, bp);
>  	return error;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
