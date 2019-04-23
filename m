Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbfDWU43 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 16:56:29 -0400
Date: Tue, 23 Apr 2019 15:56:27 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH v2 07/10] libxfs: refactor buffer item release code
Message-ID: <20190423205627.GB19086@redhat.com>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594793429.115924.9115512760848857551.stgit@magnolia>
 <20190423205133.GB178290@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423205133.GB178290@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Tue, Apr 23, 2019 at 01:51:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the buffer item release code into a helper, which we will use
> in subsequent patches to make the buffer log item lifetime match the
> kernel equivalents.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> v2: fix a bug where we put the buf log item after the buf
> ---
>  libxfs/trans.c |   21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 9de77c8b..121636b5 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -505,6 +505,16 @@ libxfs_trans_ordered_buf(
>  	return ret;
>  }
>  
> +static void
> +xfs_buf_item_put(
> +	struct xfs_buf_log_item	*bip)
> +{
> +	struct xfs_buf		*bp = bip->bli_buf;
> +
> +	bp->b_log_item = NULL;
> +	kmem_zone_free(xfs_buf_item_zone, bip);
> +}
> +
>  void
>  libxfs_trans_brelse(
>  	xfs_trans_t		*tp,
> @@ -846,7 +856,6 @@ buf_item_done(
>  
>  	bp = bip->bli_buf;
>  	ASSERT(bp != NULL);
> -	bp->b_log_item = NULL;			/* remove log item */
>  	bp->b_transp = NULL;			/* remove xact ptr */
>  
>  	hold = (bip->bli_flags & XFS_BLI_HOLD);
> @@ -857,12 +866,12 @@ buf_item_done(
>  #endif
>  		libxfs_writebuf_int(bp, 0);
>  	}
> +
> +	bip->bli_flags &= ~XFS_BLI_HOLD;
> +	xfs_buf_item_put(bip);
>  	if (hold)
> -		bip->bli_flags &= ~XFS_BLI_HOLD;
> -	else
> -		libxfs_putbuf(bp);
> -	/* release the buf item */
> -	kmem_zone_free(xfs_buf_item_zone, bip);
> +		return;
> +	libxfs_putbuf(bp);
>  }
>  
>  static void
