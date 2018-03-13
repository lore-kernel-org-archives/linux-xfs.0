Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752397AbeCMVKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 17:10:04 -0400
Date: Tue, 13 Mar 2018 14:10:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: remove the unused log_flushed variable in
 xfs_extent_busy_flush
Message-ID: <20180313211000.GM4865@magnolia>
References: <20180313104927.12926-1-hch@lst.de>
 <20180313104927.12926-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313104927.12926-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 11:49:22AM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_extent_busy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 77760dbf0242..1b439db95634 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -611,10 +611,10 @@ xfs_extent_busy_flush(
>  	unsigned		busy_gen)
>  {
>  	DEFINE_WAIT		(wait);
> -	int			log_flushed = 0, error;
> +	int			error;
>  
>  	trace_xfs_log_force(mp, 0, _THIS_IP_);
> -	error = _xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);
> +	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
>  	if (error)
>  		return;
>  
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
