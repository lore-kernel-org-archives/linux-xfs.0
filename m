Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48560 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfF0SXk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 14:23:40 -0400
Date: Thu, 27 Jun 2019 11:23:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/13] xfs: allow merging ioends over append boundaries
Message-ID: <20190627182309.GP5171@magnolia>
References: <20190627104836.25446-1-hch@lst.de>
 <20190627104836.25446-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627104836.25446-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 27, 2019 at 12:48:30PM +0200, Christoph Hellwig wrote:
> There is no real problem merging ioends that go beyond i_size into an
> ioend that doesn't.  We just need to move the append transaction to the
> base ioend.  Also use the opportunity to use a real error code instead
> of the magic 1 to cancel the transactions, and write a comment
> explaining the scheme.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reading through this patch, I have a feeling it fixes the crash that
Zorro has been seeing occasionally with generic/475...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 8b3070a40245..4ef8343c3759 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -314,11 +314,28 @@ xfs_ioend_can_merge(
>  		return false;
>  	if (ioend->io_offset + ioend->io_size != next->io_offset)
>  		return false;
> -	if (xfs_ioend_is_append(ioend) != xfs_ioend_is_append(next))
> -		return false;
>  	return true;
>  }
>  
> +/*
> + * If the to be merged ioend has a preallocated transaction for file
> + * size updates we need to ensure the ioend it is merged into also
> + * has one.  If it already has one we can simply cancel the transaction
> + * as it is guaranteed to be clean.
> + */
> +static void
> +xfs_ioend_merge_append_transactions(
> +	struct xfs_ioend	*ioend,
> +	struct xfs_ioend	*next)
> +{
> +	if (!ioend->io_append_trans) {
> +		ioend->io_append_trans = next->io_append_trans;
> +		next->io_append_trans = NULL;
> +	} else {
> +		xfs_setfilesize_ioend(next, -ECANCELED);
> +	}
> +}
> +
>  /* Try to merge adjacent completions. */
>  STATIC void
>  xfs_ioend_try_merge(
> @@ -327,7 +344,6 @@ xfs_ioend_try_merge(
>  {
>  	struct xfs_ioend	*next_ioend;
>  	int			ioend_error;
> -	int			error;
>  
>  	if (list_empty(more_ioends))
>  		return;
> @@ -341,10 +357,8 @@ xfs_ioend_try_merge(
>  			break;
>  		list_move_tail(&next_ioend->io_list, &ioend->io_list);
>  		ioend->io_size += next_ioend->io_size;
> -		if (ioend->io_append_trans) {
> -			error = xfs_setfilesize_ioend(next_ioend, 1);
> -			ASSERT(error == 1);
> -		}
> +		if (next_ioend->io_append_trans)
> +			xfs_ioend_merge_append_transactions(ioend, next_ioend);
>  	}
>  }
>  
> -- 
> 2.20.1
> 
