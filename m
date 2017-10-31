Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47634 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbdJaVeN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 17:34:13 -0400
Date: Tue, 31 Oct 2017 14:34:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/18] xfs: allow unaligned extent records in
 xfs_bmbt_disk_set_all
Message-ID: <20171031213408.GJ4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:21PM +0200, Christoph Hellwig wrote:
> To make life a little simpler make xfs_bmbt_set_all unaligned access
> aware so that we can use it directly on the destination buffer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap_btree.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 086e6fc8e4fc..89260972a0f6 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -199,14 +199,14 @@ xfs_bmbt_disk_set_all(
>  	ASSERT(!(s->br_blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)));
>  	ASSERT(!(s->br_startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)));
>  
> -	r->l0 = cpu_to_be64(
> +	put_unaligned_be64(
>  		((xfs_bmbt_rec_base_t)extent_flag << 63) |
>  		 ((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
> -		 ((xfs_bmbt_rec_base_t)s->br_startblock >> 43));
> -	r->l1 = cpu_to_be64(
> +		 ((xfs_bmbt_rec_base_t)s->br_startblock >> 43), &r->l0);
> +	put_unaligned_be64(
>  		((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
>  		 ((xfs_bmbt_rec_base_t)s->br_blockcount &
> -		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
> +		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)), &r->l1);
>  }
>  
>  /*
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
