Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755193AbdDMS22 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 14:28:28 -0400
Date: Thu, 13 Apr 2017 14:28:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/10] xfs: rewrite xfs_da_grow_inode_int
Message-ID: <20170413182825.GB25915@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413080517.12564-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:05:09AM +0200, Christoph Hellwig wrote:
> Use one xfs_bmapi_write loop that just iterates if it didn't manage to
> allocate enough blocks.  Get rid of the separate contig call that just
> makes us call the allocator twice, and also get rid of the memory
> allocation for the map array that we don't actually need.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_da_btree.c | 94 +++++++++++++-------------------------------
>  1 file changed, 28 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 1bdf2888295b..00853d332bcd 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2007,84 +2007,46 @@ xfs_da_grow_inode_int(
>  	xfs_fileoff_t		*bno,
>  	int			count)
>  {
> -	struct xfs_trans	*tp = args->trans;
> -	struct xfs_inode	*dp = args->dp;
>  	int			w = args->whichfork;
> -	xfs_rfsblock_t		nblks = dp->i_d.di_nblocks;
> -	struct xfs_bmbt_irec	map, *mapp;
> -	int			nmap, error, got, i, mapi;
> +	xfs_fileoff_t		b;
> +	int			error;
>  
>  	/*
>  	 * Find a spot in the file space to put the new block.
>  	 */
> -	error = xfs_bmap_first_unused(tp, dp, count, bno, w);
> +	error = xfs_bmap_first_unused(args->trans, args->dp, count, bno, w);
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * Try mapping it in one filesystem block.
> -	 */
> -	nmap = 1;
> -	ASSERT(args->firstblock != NULL);
> -	error = xfs_bmapi_write(tp, dp, *bno, count,
> -			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
> -			args->firstblock, args->total, &map, &nmap,
> -			args->dfops);
> -	if (error)
> -		return error;
> +	b = *bno;
> +	do {
> +		xfs_rfsblock_t nblks = args->dp->i_d.di_nblocks;
> +		struct xfs_bmbt_irec imap;
> +		xfs_extlen_t len;
> +		int nmap = 1;
> +
> +		error = xfs_bmapi_write(args->trans, args->dp, b, count,
> +				xfs_bmapi_aflag(w) | XFS_BMAPI_METADATA,
> +				args->firstblock, args->total, &imap, &nmap,
> +				args->dfops);
> +		if (error)
> +			return error;
> +		if (!nmap)
> +			return -ENOSPC;
>  
> -	ASSERT(nmap <= 1);
> -	if (nmap == 1) {
> -		mapp = &map;
> -		mapi = 1;
> -	} else if (nmap == 0 && count > 1) {
> -		xfs_fileoff_t		b;
> -		int			c;
> +		len = imap.br_startoff + imap.br_blockcount - b;
> +		ASSERT(imap.br_startoff <= b);
> +		ASSERT(len > 0);
> +		ASSERT(len <= count);
>  
> -		/*
> -		 * If we didn't get it and the block might work if fragmented,
> -		 * try without the CONTIG flag.  Loop until we get it all.
> -		 */
> -		mapp = kmem_alloc(sizeof(*mapp) * count, KM_SLEEP);
> -		for (b = *bno, mapi = 0; b < *bno + count; ) {
> -			nmap = MIN(XFS_BMAP_MAX_NMAP, count);
> -			c = (int)(*bno + count - b);
> -			error = xfs_bmapi_write(tp, dp, b, c,
> -					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
> -					args->firstblock, args->total,
> -					&mapp[mapi], &nmap, args->dfops);
> -			if (error)
> -				goto out_free_map;
> -			if (nmap < 1)
> -				break;
> -			mapi += nmap;
> -			b = mapp[mapi - 1].br_startoff +
> -			    mapp[mapi - 1].br_blockcount;
> -		}
> -	} else {
> -		mapi = 0;
> -		mapp = NULL;
> -	}
> -
> -	/*
> -	 * Count the blocks we got, make sure it matches the total.
> -	 */
> -	for (i = 0, got = 0; i < mapi; i++)
> -		got += mapp[i].br_blockcount;
> -	if (got != count || mapp[0].br_startoff != *bno ||
> -	    mapp[mapi - 1].br_startoff + mapp[mapi - 1].br_blockcount !=
> -	    *bno + count) {
> -		error = -ENOSPC;
> -		goto out_free_map;
> -	}
> +		/* account for newly allocated blocks in reserved blocks total */
> +		args->total -= (args->dp->i_d.di_nblocks - nblks);
>  
> -	/* account for newly allocated blocks in reserved blocks total */
> -	args->total -= dp->i_d.di_nblocks - nblks;
> +		b += len;
> +		count -= len;
> +	} while (count > 0);
>  
> -out_free_map:
> -	if (mapp != &map)
> -		kmem_free(mapp);
> -	return error;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
