Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60130 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731739AbfDESjG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Apr 2019 14:39:06 -0400
Subject: Re: [PATCH 31/36] libxfs: refactor the open-coded libxfs_trans_bjoin
 calls
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259762358.31886.5732556054840025852.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <747e30c7-1e37-7f71-347a-95074ca1ec5e@sandeen.net>
Date: Fri, 5 Apr 2019 13:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <155259762358.31886.5732556054840025852.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:07 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor open-coded bjoin code to use libxfs_trans_bjoin.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/trans.c |   18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
> 
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 10a35dd4..7bdd1544 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -663,13 +663,9 @@ libxfs_trans_get_buf_map(
>  	fprintf(stderr, "trans_get_buf buffer %p, transaction %p\n", bp, tp);
>  #endif
>  
> -	xfs_buf_item_init(bp, tp->t_mountp);
> +	libxfs_trans_bjoin(tp, bp);
>  	bip = bp->b_log_item;
>  	bip->bli_recur = 0;
> -	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
> -
> -	/* initialize b_transp so we can find it incore */
> -	bp->b_transp = tp;
>  	return bp;
>  }
>  
> @@ -701,13 +697,9 @@ libxfs_trans_getsb(
>  	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
>  #endif
>  
> -	xfs_buf_item_init(bp, mp);
> +	libxfs_trans_bjoin(tp, bp);
>  	bip = bp->b_log_item;
>  	bip->bli_recur = 0;
> -	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
> -
> -	/* initialize b_transp so we can find it incore */
> -	bp->b_transp = tp;
>  	return bp;
>  }
>  
> @@ -758,13 +750,9 @@ libxfs_trans_read_buf_map(
>  	fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
>  #endif
>  
> -	xfs_buf_item_init(bp, tp->t_mountp);
> +	xfs_trans_bjoin(tp, bp);
>  	bip = bp->b_log_item;
>  	bip->bli_recur = 0z
> -	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
> -
> -	/* initialise b_transp so we can find it incore */
> -	bp->b_transp = tp;
>  done:
>  	*bpp = bp;
>  	return 0;
> 
