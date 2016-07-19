Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E9BB7CB5
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 02:42:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 213F5AC002
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 00:42:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dk6BGjI6G78dT23P (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Jul 2016 00:42:35 -0700 (PDT)
Date: Tue, 19 Jul 2016 09:42:29 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/1] xfs: don't reset b_retries to 0 on every failure
Message-ID: <20160719074229.GA8134@redhat.com>
References: <9810c6bf-9fd7-bf41-13ab-a96bec861457@redhat.com>
	<19d91779-cfb2-182d-e298-b4d5d1575182@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19d91779-cfb2-182d-e298-b4d5d1575182@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Jul 08, 2016 at 11:33:23PM -0500, Eric Sandeen wrote:
> With the code as it stands today, b_retries never increments
> because it gets reset to 0 in the error callback.
> 
> Remove that, and fix a similar problem where the first retry
> time was constantly being overwritten, which defeated the
> timeout tunable as well.
> 
> We now only set first retry time if a non-zero timeout is
> set, to match the behavior of only incrementing retries if
> a retry value is set.
> 
> This way max retries & timeouts consistently take effect after
> a tunable is set, rather than acting retroactively on a buffer
> which has failed at some point in the past and has accumulated
> state from those prior failures.
> 
> Thanks to dchinner for talking through this with me.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This patch looks good, thanks Eric :)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 6a2f429..3b19e52 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1073,6 +1073,8 @@ xfs_buf_iodone_callback_error(
>  	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
>  	ASSERT(bp->b_iodone != NULL);
>  
> +	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> +
>  	/*
>  	 * If the write was asynchronous then no one will be looking for the
>  	 * error.  If this is the first failure of this type, clear the error
> @@ -1084,8 +1086,8 @@ xfs_buf_iodone_callback_error(
>  	     bp->b_last_error != bp->b_error) {
>  		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
>  		bp->b_last_error = bp->b_error;
> -		bp->b_retries = 0;
> -		bp->b_first_retry_time = jiffies;
> +		if (cfg->retry_timeout && !bp->b_first_retry_time)
> +			bp->b_first_retry_time = jiffies;
>  
>  		xfs_buf_ioerror(bp, 0);
>  		xfs_buf_submit(bp);
> @@ -1096,7 +1098,6 @@ xfs_buf_iodone_callback_error(
>  	 * Repeated failure on an async write. Take action according to the
>  	 * error configuration we have been set up to use.
>  	 */
> -	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
>  
>  	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
>  	    ++bp->b_retries > cfg->max_retries)
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
