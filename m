Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750973AbdISQf0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 12:35:26 -0400
Date: Tue, 19 Sep 2017 12:35:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/19] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170919163525.GJ3487@bfoster.bfoster>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918152422.24345-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 08:24:15AM -0700, Christoph Hellwig wrote:
> Use xfs_iext_get_extent to find, and xfs_iext_update_extent to update
> entries in the in-core extent list.  This isolates the function from
> the detailed layout of the extent list, and generally makes the code
> a lot more readable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 181 +++++++++++++++++++++++++----------------------
>  1 file changed, 95 insertions(+), 86 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4fb73c0aca05..731854cc8b58 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
...
> @@ -2064,12 +2082,12 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> -		temp = xfs_bmap_worst_indlen(bma->ip, temp);
> -		temp2 = xfs_bmap_worst_indlen(bma->ip, temp2);
> -		diff = (int)(temp + temp2 -
> -			     (startblockval(PREV.br_startblock) -
> -			      (bma->cur ?
> -			       bma->cur->bc_private.b.allocated : 0)));
> +
> +		da_new = startblockval(PREV.br_blockcount) +
> +			 startblockval(RIGHT.br_blockcount);

s/br_blockcount/br_startblock/ :)

Brian

> +		diff = da_new - startblockval(old.br_startblock);
> +		if (bma->cur)
> +			diff += bma->cur->bc_private.b.allocated;
>  		if (diff > 0) {
>  			error = xfs_mod_fdblocks(bma->ip->i_mount,
>  						 -((int64_t)diff), false);
> @@ -2078,16 +2096,7 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  		}
>  
> -		ep = xfs_iext_get_ext(ifp, bma->idx);
> -		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
> -		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
> -		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
> -		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, bma->idx + 2),
> -			nullstartblock((int)temp2));
> -		trace_xfs_bmap_post_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
> -
>  		bma->idx++;
> -		da_new = temp + temp2;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
