Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755228AbdIGPqv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 11:46:51 -0400
Date: Thu, 7 Sep 2017 11:46:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/17] xfs: don't set XFS_BTCUR_BPRV_WASDEL in xfs_bunmapi
Message-ID: <20170907154649.GC61662@bfoster.bfoster>
References: <20170903072956.3175-1-hch@lst.de>
 <20170903072956.3175-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903072956.3175-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 09:29:42AM +0200, Christoph Hellwig wrote:
> The XFS_BTCUR_BPRV_WASDEL flag is supposed to indicate that we are
> converting a delayed allocation to a real one, which isn't the case
> in xfs_bunmapi.  Setting it could theoretically lead to misaccounting
> here, but it's unlikely that we ever hit it in practice.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4867df0c1bcd..b5b30415aa2b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5725,11 +5725,7 @@ __xfs_bunmapi(
>  					XFS_QMOPT_RES_REGBLKS);
>  			}
>  			ip->i_delayed_blks -= del.br_blockcount;
> -			if (cur)
> -				cur->bc_private.b.flags |=
> -					XFS_BTCUR_BPRV_WASDEL;
> -		} else if (cur)
> -			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
> +		}

Ok, this flag is checked in xfs_bmbt_alloc_block() which is not a
codepath we should hit when removing a delalloc extent. Indeed, the
del_extent() call below appropriately skips any cur actions based on the
delalloc state. This seems fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  		error = xfs_bmap_del_extent(ip, tp, &lastx, dfops, cur, &del,
>  				&tmp_logflags, whichfork, flags);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
