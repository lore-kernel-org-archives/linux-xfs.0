Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 88B687CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 19:12:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C48D7AC004
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 17:12:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rndwwshNliZhlgPf for <xfs@oss.sgi.com>;
	Thu, 05 May 2016 17:12:20 -0700 (PDT)
Date: Fri, 6 May 2016 10:04:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: add configuration of error failure speed
Message-ID: <20160506000433.GG26977@dastard>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
	<1462376600-8617-6-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462376600-8617-6-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, May 04, 2016 at 05:43:18PM +0200, Carlos Maiolino wrote:
> On reception of an error, we can fail immediately, perform some
> bound amount of retries or retry indefinitely. The current behaviour
> we have is to retry forever.
> 
> However, we'd like the ability to choose how long the filesystem should try
> after an error, it can either fail immediately, retry a few times, or retry
> forever. This is implemented by using max_retries sysfs attribute, to hold the
> amount of times we allow the filesystem to retry after an error. Being -1 a
> special case where the filesystem will retry indefinitely.
> 
> Add both a maximum retry count and a retry timeout so that we can bound by
> time and/or physical IO attempts.
> 
> Finally, plumb these into xfs_buf_iodone error processing so that
> the error behaviour follows the selected configuration.
> 
> Changelog:
> 
> V3:
> 	- In xfs_buf_iodone_callback_error, use max_retries to decide how long
> 	  the filesystem should retry on errors instead of XFS_ERR_FAIL enums
> 	  and fail_speed
> 
> 	- Remove all code implementing fail_speed attribute from the original
> 	  patch
> 		-- failure_speed_show/store attributes function implementation
> 		-- max_retries_store() now accepts values from -1 up to INT_MAX
> 
> 	- retry_timeout_seconds_show() print fixed:
> 		-- jiffies_to_msecs() should be divided by MSEC_PER_SEC
> 		-- trailing whitespace removed

Where's XFS_ERR_RETRY_FOREVER?

> @@ -1095,8 +1098,12 @@ xfs_buf_iodone_callback_error(
>  	 * Repeated failure on an async write. Take action according to the
>  	 * error configuration we have been set up to use.
>  	 */
> -	if (!cfg->max_retries)
> -		goto permanent_error;
> +	if ((cfg->max_retries >= 0) &&
> +	    (++bp->b_retries > cfg->max_retries))
> +			goto permanent_error;

I suggested:

        if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
            ++bp->b_retries > cfg->max_retries)
                goto permanent_error;

so that we document that there is a "retry forever" case being
handled here. I really don't like magic "-1", ">= 0" or other
implicit comparisions that don't document that it is valid to retry
forever in these cases.

> +	if (cfg->retry_timeout &&
> +	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
> +			goto permanent_error;
>  
>  	/* still a transient error, higher layers will retry */
>  	xfs_buf_ioerror(bp, 0);
> @@ -1139,6 +1146,7 @@ xfs_buf_iodone_callbacks(
>  	 * retry state here in preparation for the next error that may occur.
>  	 */
>  	bp->b_last_error = 0;
> +	bp->b_retries = 0;
>  
>  	xfs_buf_do_callbacks(bp);
>  	bp->b_fspriv = NULL;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 0c5a976..0382140 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -54,7 +54,8 @@ enum {
>  
>  struct xfs_error_cfg {
>  	struct xfs_kobj	kobj;
> -	int		max_retries;
> +	int		max_retries;	/* -1 = retry forever */

as per my last review, remove the comment, add XFS_ERR_RETRY_FOREVER
to document that "-1 = retry forever" and use that in the code so
it's explicit that the code is intended to handle this case.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
