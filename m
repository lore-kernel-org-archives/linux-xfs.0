Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37086 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbfEAWQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 May 2019 18:16:56 -0400
Date: Thu, 2 May 2019 08:16:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: change some error-less functions to void types
Message-ID: <20190501221652.GJ29573@dread.disaster.area>
References: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, May 01, 2019 at 10:55:54AM -0500, Eric Sandeen wrote:
> There are several functions which have no opportunity to retun
> an error, and don't contain any ASSERTs which could be argued
> to be better constructed as error cases.  So, make them voids
> to simplify the callers.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
....
> @@ -1840,7 +1840,6 @@ xlog_sync(
>  	uint		count_init;	/* initial count before roundup */
>  	int		roundoff;       /* roundoff to BB or stripe */
>  	int		split = 0;	/* split write into two regions */
> -	int		error;
>  	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
>  	int		size;
>  
> @@ -1959,11 +1958,8 @@ xlog_sync(
>  	 * Don't call xfs_bwrite here. We do log-syncs even when the filesystem
>  	 * is shutting down.
>  	 */
> -	error = xlog_bdstrat(bp);
> -	if (error) {
> -		xfs_buf_ioerror_alert(bp, "xlog_sync");
> -		return error;
> -	}
> +	xlog_bdstrat(bp);

Shouldn't this be checking bp->b_error rather than completely
ignoring buffer submit errors?

> +
>  	if (split) {
>  		bp = iclog->ic_log->l_xbuf;
>  		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
> @@ -1978,11 +1974,7 @@ xlog_sync(
>  
>  		/* account for internal log which doesn't start at block #0 */
>  		XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
> -		error = xlog_bdstrat(bp);
> -		if (error) {
> -			xfs_buf_ioerror_alert(bp, "xlog_sync (split)");
> -			return error;
> -		}
> +		xlog_bdstrat(bp);

Ditto.

Otherwise it looks fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
