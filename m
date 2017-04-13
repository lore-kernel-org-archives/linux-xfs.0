Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51149 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752206AbdDMWMY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 18:12:24 -0400
Date: Thu, 13 Apr 2017 15:12:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: handle array index overrun in
 xfs_dir2_leaf_readbuf()
Message-ID: <20170413221219.GA8502@birch.djwong.org>
References: <9d5a5529-894d-bacd-501e-e0d9ece473b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d5a5529-894d-bacd-501e-e0d9ece473b8@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolin@redhat.com>

On Thu, Apr 13, 2017 at 01:45:43PM -0500, Eric Sandeen wrote:
> Carlos had a case where "find" seemed to start spinning
> forever and never return.
> 
> This was on a filesystem with non-default multi-fsb (8k)
> directory blocks, and a fragmented directory with extents
> like this:
> 
> 0:[0,133646,2,0]
> 1:[2,195888,1,0]
> 2:[3,195890,1,0]
> 3:[4,195892,1,0]
> 4:[5,195894,1,0]
> 5:[6,195896,1,0]
> 6:[7,195898,1,0]
> 7:[8,195900,1,0]
> 8:[9,195902,1,0]
> 9:[10,195908,1,0]
> 10:[11,195910,1,0]
> 11:[12,195912,1,0]
> 12:[13,195914,1,0]
> ...
> 
> i.e. the first extent is a contiguous 2-fsb dir block, but
> after that it is fragmented into 1 block extents.
> 
> At the top of the readdir path, we allocate a mapping array
> which (for this filesystem geometry) can hold 10 extents; see
> the assignment to map_info->map_size.  During readdir, we are
> therefore able to map extents 0 through 9 above into the array
> for readahead purposes.  If we count by 2, we see that the last
> mapped index (9) is the first block of a 2-fsb directory block.
> 
> At the end of xfs_dir2_leaf_readbuf() we have 2 loops to fill
> more readahead; the outer loop assumes one full dir block is
> processed each loop iteration, and an inner loop that ensures
> that this is so by advancing to the next extent until a full
> directory block is mapped.
> 
> The problem is that this inner loop may step past the last
> extent in the mapping array as it tries to reach the end of
> the directory block.  This will read garbage for the extent
> length, and as a result the loop control variable 'j' may
> become corrupted and never fail the loop conditional.
> 
> The number of valid mappings we have in our array is stored
> in map->map_valid, so stop this inner loop based on that limit.
> 
> There is an ASSERT at the top of the outer loop for this
> same condition, but we never made it out of the inner loop,
> so the ASSERT never fired.
> 
> Huge appreciation for Carlos for debugging and isolating
> the problem.
> 
> Debugged-and-analyzed-by: Carlos Maiolino <cmaiolin@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index ad9396e..c45de72 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -394,6 +394,7 @@ struct xfs_dir2_leaf_map_info {
>  
>  	/*
>  	 * Do we need more readahead?
> +	 * Each loop tries to process 1 full dir blk; last may be partial.
>  	 */
>  	blk_start_plug(&plug);
>  	for (mip->ra_index = mip->ra_offset = i = 0;
> @@ -425,9 +426,14 @@ struct xfs_dir2_leaf_map_info {
>  		}
>  
>  		/*
> -		 * Advance offset through the mapping table.
> +		 * Advance offset through the mapping table, processing a full
> +		 * dir block even if it is fragmented into several extents.
> +		 * But stop if we have consumed all valid mappings, even if
> +		 * it's not yet a full directory block.
>  		 */
> -		for (j = 0; j < geo->fsbcount; j += length ) {
> +		for (j = 0;
> +		     j < geo->fsbcount && mip->ra_index < mip->map_valid;
> +		     j += length ) {

Seems ok for a bug fix, but /me wonders if it's worth all the loopy
effort if ultimately _dabuf_map can sort through compound (i.e. non
contiguous) directory blocks, which means that we could just
_dir3_data_readahead(dabno + i, -1) until we've scheduled readahead on
32k worth of da blocks.  We've already got the extents loaded, so it
ought to be safe to bmapi_read...

<shrug>  Well now that there's a test I have something to keep the CPUs
warm for a while...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  			/*
>  			 * The rest of this extent but not more than a dir
>  			 * block.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
