Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27203 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdJCR0J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 13:26:09 -0400
Date: Tue, 3 Oct 2017 10:26:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH]  xfs: handle racy AIO in xfs_reflink_end_cow
Message-ID: <20171003172603.GD6503@magnolia>
References: <20171003143416.12188-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003143416.12188-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 04:34:16PM +0200, Christoph Hellwig wrote:
> If we got two AIO writes into a COW area the second one might not have any
> COW extents left to convert.  Handle that case gracefully instead of
> triggering an assert or accessing beyond the bounds of the extent list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, will test.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_reflink.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 3246815c24d6..37e603bf1591 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -736,7 +736,13 @@ xfs_reflink_end_cow(
>  	/* If there is a hole at end_fsb - 1 go to the previous extent */
>  	if (!xfs_iext_lookup_extent(ip, ifp, end_fsb - 1, &idx, &got) ||
>  	    got.br_startoff > end_fsb) {
> -		ASSERT(idx > 0);
> +		/*
> +		 * In case of racing, overlapping AIO writes no COW extents
> +		 * might be left by the time I/O completes for the loser of
> +		 * the race.  In that case we are done.
> +		 */
> +		if (idx <= 0)
> +			goto out_cancel;
>  		xfs_iext_get_extent(ifp, --idx, &got);
>  	}
>  
> @@ -809,6 +815,7 @@ xfs_reflink_end_cow(
>  
>  out_defer:
>  	xfs_defer_cancel(&dfops);
> +out_cancel:
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out:
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
