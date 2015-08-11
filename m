Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 111757F54
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 09:19:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF60A8F804B
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 07:19:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oA1pTVIlzOu9OrbL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 07:19:25 -0700 (PDT)
Date: Tue, 11 Aug 2015 10:19:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/10] xfs: add configuration of error failure speed
Message-ID: <20150811141923.GC59636@bfoster.bfoster>
References: <1438772921-28715-1-git-send-email-david@fromorbit.com>
	<1438772921-28715-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438772921-28715-7-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 05, 2015 at 09:08:37PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On reception of an error, we can fail immediately, perform some
> bound amount of retries or retry indefinitely. The current behaviour
> we have is to retry forever.
> 
> However, we'd like the ability to choose what behaviour we have, and
> that requires the ability to configure the behaviour through the new
> sysfs interfaces. Add configuration options for fail fast, slow or
> never to reflect the three choices above. Fail fast or fail never
> don't require any other options, but "fail slow" needs configuration
> to bound the retry behaviour. Add both a maximum retry count and a
> retry timeout so that we can bound by time and/or physical IO
> attempts.
> 
> Finally, plumb these into xfs_buf_iodone error processing so that
> the error behaviour follows the selected configuration.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.h      |  23 +++++++++-
>  fs/xfs/xfs_buf_item.c |  22 +++++++++-
>  fs/xfs/xfs_mount.h    |   2 +
>  fs/xfs/xfs_sysfs.c    | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 164 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index ed0ea41..afc2d2b 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -181,7 +181,28 @@ typedef struct xfs_buf {
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
> index a09ae26..c785698 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -968,6 +968,9 @@ xfs_buf_iodone_callback_error(

There's a 5 second xfs_buf_ioerror_alert() further up in this function.
I wonder if we should figure out a way to tie that into the failure
speed mechanism..? It might make sense to retain the original alert to
indicate that a failure occurred in the first place, but I'm not sure a
5 second repetition makes sense if an admin has set a 5 minute error
timeout, for example.

It also might be a good idea to make this initial alert more informative
in terms of indicating the error sequence has kicked in and retries are
in progress. Perhaps even indicate what metric (timeout, retries)
triggers a final shutdown if we get to that point. Otherwise, it's not
really clear to the user where we're at when alerts start firing,
particularly for somebody who might not know that fs shutdown is the
endgame.

>  		bp->b_flags |= (XBF_WRITE | XBF_ASYNC |
>  			        XBF_DONE | XBF_WRITE_FAIL);
>  		bp->b_last_error = bp->b_error;
> +		bp->b_retries = 0;
> +		bp->b_first_retry_time = jiffies;
> +
>  		xfs_buf_ioerror(bp, 0);
>  		xfs_buf_submit(bp);
>  		return true;
> @@ -977,9 +980,25 @@ xfs_buf_iodone_callback_error(
>  	 * Repeated failure on an async write. Take action according to the
>  	 * error configuration we have been set up to use.
>  	 */
> -	if (cfg->fail_speed == XFS_ERR_FAIL_FAST)
> +	switch (cfg->fail_speed) {
> +	case XFS_ERR_FAIL_FAST:
>  		goto permanent_error;
>  
> +	case XFS_ERR_FAIL_SLOW:
> +		if (++bp->b_retries > cfg->max_retries)
> +			goto permanent_error;
> +		if (!cfg->retry_timeout)
> +			break;
> +		if (time_after(jiffies,
> +			       cfg->retry_timeout + bp->b_first_retry_time))
> +			goto permanent_error;
> +		break;
> +
> +	case XFS_ERR_FAIL_NEVER:
> +	default:
> +		break;
> +	}
> +

Where is the actual resubmission for the fail slow/never cases?

>  	/* still a transient error, higher layers will retry */
>  	xfs_buf_ioerror(bp, 0);
>  	xfs_buf_relse(bp);
> @@ -1021,6 +1040,7 @@ xfs_buf_iodone_callbacks(
>  	 * retry state here in preparation for the next error that may occur.
>  	 */
>  	bp->b_last_error = 0;
> +	bp->b_retries = 0;
>  
>  	xfs_buf_do_callbacks(bp);
>  	bp->b_fspriv = NULL;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 21caa5a..a684a72b 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -62,6 +62,8 @@ enum {
>  struct xfs_error_cfg {
>  	struct xfs_kobj	kobj;
>  	int		fail_speed;
> +	int		max_retries;	/* INT_MAX = retry forever */
> +	unsigned long	retry_timeout;	/* in jiffies, 0 = no timeout */
>  };
>  
>  typedef struct xfs_mount {
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 9d66095..1f078e1 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -252,7 +252,119 @@ struct kobj_type xfs_log_ktype = {
>   * and any other future type of IO (e.g. special inode or directory error
>   * handling) we care to support.
>   */
> +static ssize_t
> +failure_speed_store(
> +	const char	*buf,
> +	size_t		count,
> +	void		*data)
> +{
> +	struct xfs_error_cfg *cfg = data;
> +	char		*str = kstrdup(buf, GFP_KERNEL);
> +	char		*sp;
> +	int		len;
> +
> +	if (!str)
> +		return -ENOMEM;
> +
> +	sp = strstrip(str);
> +	len = strlen(sp);
> +	if (strncmp(sp, "fast", len) == 0)
> +		cfg->fail_speed = XFS_ERR_FAIL_FAST;
> +	else if (strncmp(sp, "slow", len) == 0)
> +		cfg->fail_speed = XFS_ERR_FAIL_SLOW;
> +	else if (strncmp(sp, "never", len) == 0)
> +		cfg->fail_speed = XFS_ERR_FAIL_NEVER;
> +	else
> +		count = -EINVAL;
> +	kfree(str);
> +	return count;
> +}
> +
> +static ssize_t
> +failure_speed_show(
> +	char	*buf,
> +	void	*data)
> +{
> +	struct xfs_error_cfg *cfg = data;
> +
> +	if (cfg->fail_speed == XFS_ERR_FAIL_FAST)
> +		return snprintf(buf, PAGE_SIZE, "[fast] slow never\n");
> +	if (cfg->fail_speed == XFS_ERR_FAIL_SLOW)
> +		return snprintf(buf, PAGE_SIZE, "fast [slow] never\n");
> +	return snprintf(buf, PAGE_SIZE, "fast slow [never]\n");
> +}
> +XFS_SYSFS_ATTR_RW(failure_speed);
> +
> +static ssize_t
> +max_retries_store(
> +	const char	*buf,
> +	size_t		count,
> +	void		*data)
> +{
> +	struct xfs_error_cfg *cfg = data;
> +	int		ret;
> +	int		val;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val < 0 || val > INT_MAX)
> +		return -EINVAL;
> +
> +	cfg->max_retries = val;
> +	return count;
> +}
> +
> +static ssize_t
> +max_retries_show(
> +	char	*buf,
> +	void	*data)
> +{
> +	struct xfs_error_cfg *cfg = data;
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", cfg->max_retries);
> +}
> +XFS_SYSFS_ATTR_RW(max_retries);
> +
> +static ssize_t
> +retry_timeout_seconds_store(
> +	const char	*buf,
> +	size_t		count,
> +	void		*data)
> +{
> +	struct xfs_error_cfg *cfg = data;
> +	int		ret;
> +	int		val;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	/* 1 day timeout maximum */
> +	if (val < 0 || val > 86400)
> +		return -EINVAL;
> +
> +	cfg->retry_timeout = msecs_to_jiffies(val * MSEC_PER_SEC);
> +	return count;
> +}
> +
> +static ssize_t
> +retry_timeout_seconds_show(
> +	char	*buf,
> +	void	*data)
> +{
> +	struct xfs_error_cfg *cfg = data;
> +
> +	return snprintf(buf, PAGE_SIZE, "%ld\n", 

Trailing whitespace above.

> +			jiffies_to_msecs(cfg->retry_timeout) * MSEC_PER_SEC);

... and a conversion to microseconds. ;)

Brian

> +}
> +XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
> +
>  static struct attribute *xfs_error_attrs[] = {
> +	ATTR_LIST(failure_speed),
> +	ATTR_LIST(max_retries),
> +	ATTR_LIST(retry_timeout_seconds),
>  	NULL,
>  };
>  
> @@ -312,11 +424,15 @@ struct kobj_type xfs_error_ktype = {
>  struct xfs_error_init {
>  	char		*name;
>  	int		fail_speed;
> +	int		max_retries;
> +	int		retry_timeout;	/* in seconds */
>  };
>  
>  static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
>  	{ .name = "Default",
>  	  .fail_speed = XFS_ERR_FAIL_NEVER,
> +	  .max_retries = INT_MAX,
> +	  .retry_timeout = 0,
>  	},
>  };
>  
> @@ -347,6 +463,9 @@ xfs_error_sysfs_init_class(
>  			goto out_error;
>  
>  		cfg->fail_speed = init[i].fail_speed;
> +		cfg->max_retries = init[i].max_retries;
> +		cfg->retry_timeout = msecs_to_jiffies(
> +					init[i].retry_timeout * MSEC_PER_SEC);
>  	}
>  	return 0;
>  
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
