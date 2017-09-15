Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbdIORAY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Sep 2017 13:00:24 -0400
Date: Fri, 15 Sep 2017 13:00:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/18] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170915170022.GC7276@bfoster.bfoster>
References: <20170915145426.26194-1-hch@lst.de>
 <20170915145426.26194-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170915145426.26194-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 15, 2017 at 07:54:20AM -0700, Christoph Hellwig wrote:
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
> index 4fb73c0aca05..8606a775c94b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
...
> @@ -2078,16 +2095,8 @@ xfs_bmap_add_extent_delay_real(
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
> +		da_new = PREV.br_blockcount + RIGHT.br_blockcount;

da_new should be the new total indirect reservation. The above sets it
to the total/remaining delalloc block count. E.g., it should probably be
something like this:

	da_new = startblockval(PREV.br_startblock) +
		 startblockval(RIGHT.br_startblock);

Or alternatively you could set da_new right before diff is calculated
and reuse it in that calculation. Otherwise the patch looks good.

Brian

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
