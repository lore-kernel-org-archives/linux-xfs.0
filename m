Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 40A437CB0
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 18:24:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9DC20AC002
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 16:24:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MHuUpJEZV4p8Q7mX for <xfs@oss.sgi.com>;
	Tue, 03 May 2016 16:24:22 -0700 (PDT)
Date: Wed, 4 May 2016 09:24:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: add configuration of error failure speed
Message-ID: <20160503232419.GV26977@dastard>
References: <1462298140-12411-1-git-send-email-cmaiolino@redhat.com>
	<1462298140-12411-6-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462298140-12411-6-git-send-email-cmaiolino@redhat.com>
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

On Tue, May 03, 2016 at 07:55:38PM +0200, Carlos Maiolino wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On reception of an error, we can fail immediately, perform some
> bound amount of retries or retry indefinitely. The current behaviour
> we have is to retry forever.
> 
> However, we'd like the ability to choose what behaviour we have, and
> that requires the ability to configure the behaviour through the new
> sysfs interfaces.
> 
> max_retries is used to set the number of retries to do until permanently fail,
> the only special case is when it is set to -1, which, will cause the system to
> retry indefinitely.

This doesn't read particularly well, and its more a description of
the mechanism (which shoul dbe in the code) rather than the reason
for implementing it.. The original commit message talked about
different failure characteristics, which still need to be mentioned
here. e.g:

	We'd like to be able to configure errors to either fail
	immediately (fail fast), retry for some time before
	failing (fail slow) or retry forever (fail never). This is
	implemented by using specific values for the number of
	retries we allow.
> 
> Add both a maximum retry count and a retry timeout so that we can
> bound by time and/or physical IO attempts.
> 
> Finally, plumb these into xfs_buf_iodone error processing so that
> the error behaviour follows the selected configuration.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com> Signed-off-by:
> Carlos Maiolino <cmaiolino@redhat.com>

You also need to document what changes you've made to the original
patches. I can't tell what you've changed in each patch just by
looking at them - this is the first one where I noticed something
while reading it. i.e. the commit message should have:

[ cmaiolino: removed fail-fast/slow/never and instead use retry count
to determine behaviour ]

> ---
>  fs/xfs/xfs_buf.h      | 23 ++++++++++++++-
>  fs/xfs/xfs_buf_item.c | 13 +++++++--
>  fs/xfs/xfs_mount.h    |  3 +-
>  fs/xfs/xfs_sysfs.c    | 81 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 112 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index adef116..bd978f0 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -183,7 +183,28 @@ typedef struct xfs_buf {
>  	unsigned int		b_page_count;	/* size of page array */
>  	unsigned int		b_offset;	/* page offset in first page */
>  	int			b_error;	/* error code on I/O */
> -	int			b_last_error;	/* previous async I/O error */
> +
> +	/*
> +	 * async write failure retry count. Initialised to zero on the first
> +	 * failure, then when it exceeds the maximum configured without a
> +	 * success the write is considered to be failed permanently and the
> +	 * iodone handler will take appropriate action.
> +	 *
> +	 * For retry timeouts, we record the jiffie of the first failure. This
> +	 * means that we can change the retry timeout and it on the next error
> +	 * it will be checked against the newly configured timeout. This
> +	 * prevents buffers getting stuck in retry loops with a really long
> +	 * timeout.
> +	 *
> +	 * last_error is used to ensure that we are getting repeated errors, not
> +	 * different errors. e.g. a block device might change ENOSPC to EIO when
> +	 * a failure timeout occurs, so we want to re-initialise the error
> +	 * retry behaviour appropriately when that happens.
> +	 */
> +	int			b_retries;
> +	unsigned long		b_first_retry_time; /* in jiffies */
> +	int			b_last_error;
> +
>  	const struct xfs_buf_ops	*b_ops;
>  
>  #ifdef XFS_BUF_LOCK_TRACKING
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 3a30a88..68ed2a0 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1086,6 +1086,9 @@ xfs_buf_iodone_callback_error(
>  		bp->b_flags |= (XBF_WRITE | XBF_ASYNC |
>  			        XBF_DONE | XBF_WRITE_FAIL);
>  		bp->b_last_error = bp->b_error;
> +		bp->b_retries = 0;
> +		bp->b_first_retry_time = jiffies;
> +
>  		xfs_buf_ioerror(bp, 0);
>  		xfs_buf_submit(bp);
>  		return true;
> @@ -1095,8 +1098,13 @@ xfs_buf_iodone_callback_error(
>  	 * Repeated failure on an async write. Take action according to the
>  	 * error configuration we have been set up to use.
>  	 */
> -	if (!cfg->max_retries)
> -		goto permanent_error;
> +	if (cfg->max_retries >= 0)
> +		if (++bp->b_retries > cfg->max_retries)
> +			goto permanent_error;
> +	if (cfg->retry_timeout)
> +		if (time_after(jiffies,
> +			       cfg->retry_timeout + bp->b_first_retry_time))
> +			goto permanent_error;

This is hard to read and the pattern is prone to future maintenance
problems. i.e. nested single line if statements are prone to people
making mistakes with indentation when adding more conditions to
them.

So:

	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
	    ++bp->b_retries > cfg->max_retries)
		goto permanent_error;
	if (cfg->retry_timeout &&
	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
		goto permanent_error;

>  	/* still a transient error, higher layers will retry */
>  	xfs_buf_ioerror(bp, 0);
> @@ -1139,6 +1147,7 @@ xfs_buf_iodone_callbacks(
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
> +	int		max_retries;

#define XFS_ERR_RETRY_FOREVER	(-1)

> +	unsigned long	retry_timeout;	/* in jiffies, 0 = no timeout */
>  };
....
> +static ssize_t
> +max_retries_store(
> +	struct kobject	*kobject,
> +	const char	*buf,
> +	size_t		count)
> +{
> +	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
> +	int		ret;
> +	int		val;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val < -1 || val > INT_MAX)
> +		return -EINVAL;

Should special case XFS_ERR_RETRY_FOREVER here. i.e. range is
0-INT_MAX || XFS_ERR_RETRY_FOREVER.

	if ((val < -1 || val > INT_MAX) &&
	    val != XFS_ERR_RETRY_FOREVER)
		return -EINVAL;

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
