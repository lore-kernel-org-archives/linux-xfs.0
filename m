Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23080 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdITVaE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 17:30:04 -0400
Date: Wed, 20 Sep 2017 14:29:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/19] xfs: don't set XFS_BTCUR_BPRV_WASDEL in xfs_bunmapi
Message-ID: <20170920212958.GK7112@magnolia>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918152422.24345-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 08:24:06AM -0700, Christoph Hellwig wrote:
> The XFS_BTCUR_BPRV_WASDEL flag is supposed to indicate that we are
> converting a delayed allocation to a real one, which isn't the case
> in xfs_bunmapi.  Setting it could theoretically lead to misaccounting
> here, but it's unlikely that we ever hit it in practice.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

I think we need a better comment on #define explaining that the flag is
for making sure that delayed_blks gets updated when performing delalloc
-> real conversion.  I had trace the usage of the flag since
"/* was delayed */" didn't convince me that this patch made sense.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 555ff198e28c..ef30b52c32af 100644
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
>  
>  		error = xfs_bmap_del_extent(ip, tp, &lastx, dfops, cur, &del,
>  				&tmp_logflags, whichfork, flags);
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
