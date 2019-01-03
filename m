Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35906 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfACR7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 12:59:52 -0500
Date: Thu, 3 Jan 2019 09:59:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/5] xfs_metadump: Zap freeindex blocks in directory
 inodes
Message-ID: <20190103175947.GG20475@magnolia>
References: <20181105213145.7560-1-stefanrin@gmail.com>
 <20181105213145.7560-4-stefanrin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105213145.7560-4-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 10:31:43PM +0100, Stefan Ring wrote:
> Signed-off-by: Stefan Ring <stefanrin@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  db/metadump.c | 46 ++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 40 insertions(+), 6 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index be7cf360..d4c751c0 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1421,6 +1421,43 @@ process_sf_attr(
>  		memset(asfep, 0, XFS_DFORK_ASIZE(dip, mp) - ino_attr_size);
>  }
>  
> +static void
> +process_dir_free_block(
> +	char				*block)
> +{
> +	struct xfs_dir2_free		*free;
> +	struct xfs_dir3_icfree_hdr	freehdr;
> +
> +	if (!zero_stale_data)
> +		return;
> +
> +	free = (struct xfs_dir2_free *)block;
> +	M_DIROPS(mp)->free_hdr_from_disk(&freehdr, free);
> +
> +	switch (freehdr.magic) {
> +	case XFS_DIR2_FREE_MAGIC:
> +	case XFS_DIR3_FREE_MAGIC: {
> +		__be16			*bests;
> +		char			*high;
> +		int			used;
> +
> +		/* Zero out space from end of bests[] to end of block */
> +		bests = M_DIROPS(mp)->free_bests_p(free);
> +		high = (char *)&bests[freehdr.nvalid];
> +		used = high - (char*)free;
> +		memset(high, 0, mp->m_dir_geo->blksize - used);
> +		iocur_top->need_crc = 1;
> +		break;
> +	}
> +	default:
> +		if (show_warnings)
> +			print_warning("invalid magic in dir inode %llu "
> +				      "free block",
> +				      (unsigned long long)cur_ino);
> +		break;
> +	}
> +}
> +
>  static void
>  process_dir_leaf_block(
>  	char				*block)
> @@ -1518,7 +1555,7 @@ process_dir_data_block(
>  		if (show_warnings)
>  			print_warning(
>  		"invalid magic in dir inode %llu block %ld",
> -					(long long)cur_ino, (long)offset);
> +					(unsigned long long)cur_ino, (long)offset);
>  		return;
>  	}
>  
> @@ -1832,8 +1869,7 @@ process_single_fsb_objects(
>  		switch (btype) {
>  		case TYP_DIR2:
>  			if (o >= mp->m_dir_geo->freeblk) {
> -				/* TODO, zap any stale data */
> -				break;
> +				process_dir_free_block(dp);
>  			} else if (o >= mp->m_dir_geo->leafblk) {
>  				process_dir_leaf_block(dp);
>  			} else {
> @@ -1924,8 +1960,7 @@ process_multi_fsb_objects(
>  
>  			dp = iocur_top->data;
>  			if (o >= mp->m_dir_geo->freeblk) {
> -				/* TODO, zap any stale data */
> -				goto write;
> +				process_dir_free_block(dp);
>  			} else if (o >= mp->m_dir_geo->leafblk) {
>  				process_dir_leaf_block(dp);
>  			} else {
> @@ -1934,7 +1969,6 @@ process_multi_fsb_objects(
>  			}
>  
>  			iocur_top->need_crc = obfuscate || zero_stale_data;
> -write:
>  			ret = write_buf(iocur_top);
>  out_pop:
>  			pop_cur();
> -- 
> 2.14.5
> 
