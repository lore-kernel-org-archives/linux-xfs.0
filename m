Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32978 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965224AbdAIVVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 16:21:34 -0500
Date: Mon, 9 Jan 2017 13:21:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't print warnings when xfs_log_force fails
Message-ID: <20170109212129.GD14038@birch.djwong.org>
References: <1482999799-11776-1-git-send-email-hch@lst.de>
 <1482999799-11776-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482999799-11776-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 29, 2016 at 09:23:19AM +0100, Christoph Hellwig wrote:
> There are only two reasons for xfs_log_force / xfs_log_force_lsn to fail:
> one is an I/O error, for which xlog_bdstrat already logs a warning, and
> the second is an already shutdown log due to a previous I/O errors.  In
> the latter case we'll already have a previous indication for the actual
> error, but the large stream of misleading warnings from xfs_log_force
> will probably scroll it out of the message buffer.
> 
> Simply removing the warnings thus makes the XFS log reporting significantly
> better.

Looks ok to me, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c39ac14..b1469f0 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3317,12 +3317,8 @@ xfs_log_force(
>  	xfs_mount_t	*mp,
>  	uint		flags)
>  {
> -	int	error;
> -
>  	trace_xfs_log_force(mp, 0, _RET_IP_);
> -	error = _xfs_log_force(mp, flags, NULL);
> -	if (error)
> -		xfs_warn(mp, "%s: error %d returned.", __func__, error);
> +	_xfs_log_force(mp, flags, NULL);
>  }
>  
>  /*
> @@ -3466,12 +3462,8 @@ xfs_log_force_lsn(
>  	xfs_lsn_t	lsn,
>  	uint		flags)
>  {
> -	int	error;
> -
>  	trace_xfs_log_force(mp, lsn, _RET_IP_);
> -	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
> -	if (error)
> -		xfs_warn(mp, "%s: error %d returned.", __func__, error);
> +	_xfs_log_force_lsn(mp, lsn, flags, NULL);
>  }
>  
>  /*
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
