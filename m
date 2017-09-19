Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750973AbdISQfa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 12:35:30 -0400
Date: Tue, 19 Sep 2017 12:35:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 13/19] xfs: refactor delalloc accounting in
 xfs_bmap_add_extent_delay_real
Message-ID: <20170919163528.GK3487@bfoster.bfoster>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918152422.24345-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 08:24:16AM -0700, Christoph Hellwig wrote:
> Account for all changes to the delalloc reservation in da_new, and use a
> single call xfs_mod_fdblocks to reserve/free blocks, including always
> checking for an error.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 32 +++++++++-----------------------
>  1 file changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 731854cc8b58..dbf87add4d6b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1587,7 +1587,6 @@ xfs_bmap_add_extent_delay_real(
>  	int			whichfork)
>  {
>  	struct xfs_bmbt_irec	*new = &bma->got;
> -	int			diff;	/* temp value */
>  	int			error;	/* error return value */
>  	int			i;	/* temp state */
>  	xfs_ifork_t		*ifp;	/* inode fork pointer */
> @@ -2085,17 +2084,6 @@ xfs_bmap_add_extent_delay_real(
>  
>  		da_new = startblockval(PREV.br_blockcount) +
>  			 startblockval(RIGHT.br_blockcount);
> -		diff = da_new - startblockval(old.br_startblock);
> -		if (bma->cur)
> -			diff += bma->cur->bc_private.b.allocated;
> -		if (diff > 0) {
> -			error = xfs_mod_fdblocks(bma->ip->i_mount,
> -						 -((int64_t)diff), false);
> -			ASSERT(!error);
> -			if (error)
> -				goto done;
> -		}
> -
>  		bma->idx++;
>  		break;
>  
> @@ -2130,19 +2118,17 @@ xfs_bmap_add_extent_delay_real(
>  			goto done;
>  	}
>  
> -	/* adjust for changes in reserved delayed indirect blocks */
> -	if (da_old || da_new) {
> -		temp = da_new;
> -		if (bma->cur)
> -			temp += bma->cur->bc_private.b.allocated;
> -		if (temp < da_old)
> -			xfs_mod_fdblocks(bma->ip->i_mount,
> -					(int64_t)(da_old - temp), false);
> +	if (bma->cur) {
> +		da_new += bma->cur->bc_private.b.allocated;
> +		bma->cur->bc_private.b.allocated = 0;
>  	}
>  
> -	/* clear out the allocated field, done with it now in any case. */
> -	if (bma->cur)
> -		bma->cur->bc_private.b.allocated = 0;
> +	/* adjust for changes in reserved delayed indirect blocks */
> +	if (da_new != da_old) {
> +		ASSERT(state == 0 || da_new < da_old);
> +		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
> +				false);
> +	}
>  
>  	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
>  done:
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
