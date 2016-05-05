Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F3AD7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 09:11:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89F6EAC004
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 07:10:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1tuxlGCedO10ehx6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 07:10:58 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id C2B093DD47
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:10:57 +0000 (UTC)
Date: Thu, 5 May 2016 10:10:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/7] xfs: add configuration of error failure speed
Message-ID: <20160505141055.GE1231@bfoster.bfoster>
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
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_buf.h      | 23 ++++++++++++++-
>  fs/xfs/xfs_buf_item.c | 12 ++++++--
>  fs/xfs/xfs_mount.h    |  3 +-
>  fs/xfs/xfs_sysfs.c    | 81 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 111 insertions(+), 8 deletions(-)
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

I'd reword the last bit to something like the following:

"This means we can change the retry timeout for buffers already under
I/O and thus avoid getting stuck in retry loops with a really long
timeout."

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
> index 3a30a88..6fe6852 100644
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
> @@ -1095,8 +1098,12 @@ xfs_buf_iodone_callback_error(
>  	 * Repeated failure on an async write. Take action according to the
>  	 * error configuration we have been set up to use.
>  	 */
> -	if (!cfg->max_retries)
> -		goto permanent_error;
> +	if ((cfg->max_retries >= 0) &&
> +	    (++bp->b_retries > cfg->max_retries))
> +			goto permanent_error;
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
> +	unsigned long	retry_timeout;	/* in jiffies, 0 = no timeout */
>  };
>  
>  typedef struct xfs_mount {
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 2a5b1cf..c881360 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -374,10 +374,6 @@ struct kobj_type xfs_log_ktype = {
>   * and any other future type of IO (e.g. special inode or directory error
>   * handling) we care to support.
>   */
> -static struct attribute *xfs_error_attrs[] = {
> -	NULL,
> -};
> -
>  static inline struct xfs_error_cfg *
>  to_error_cfg(struct kobject *kobject)
>  {
> @@ -385,6 +381,79 @@ to_error_cfg(struct kobject *kobject)
>  	return container_of(kobj, struct xfs_error_cfg, kobj);
>  }
>  
> +static ssize_t
> +max_retries_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", cfg->max_retries);
> +}
> +
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
> +

Can an int be greater than INT_MAX? :)

The rest looks fine so you can add:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	cfg->max_retries = val;
> +	return count;
> +}
> +XFS_SYSFS_ATTR_RW(max_retries);
> +
> +static ssize_t
> +retry_timeout_seconds_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
> +
> +	return snprintf(buf, PAGE_SIZE, "%ld\n",
> +			jiffies_to_msecs(cfg->retry_timeout) / MSEC_PER_SEC);
> +}
> +
> +static ssize_t
> +retry_timeout_seconds_store(
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
> +	/* 1 day timeout maximum */
> +	if (val < 0 || val > 86400)
> +		return -EINVAL;
> +
> +	cfg->retry_timeout = msecs_to_jiffies(val * MSEC_PER_SEC);
> +	return count;
> +}
> +XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
> +
> +static struct attribute *xfs_error_attrs[] = {
> +	ATTR_LIST(max_retries),
> +	ATTR_LIST(retry_timeout_seconds),
> +	NULL,
> +};
> +
> +
>  struct kobj_type xfs_error_cfg_ktype = {
>  	.release = xfs_sysfs_release,
>  	.sysfs_ops = &xfs_sysfs_ops,
> @@ -404,11 +473,13 @@ struct kobj_type xfs_error_ktype = {
>  struct xfs_error_init {
>  	char		*name;
>  	int		max_retries;
> +	int		retry_timeout;	/* in seconds */
>  };
>  
>  static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
>  	{ .name = "default",
>  	  .max_retries = -1,
> +	  .retry_timeout = 0,
>  	},
>  };
>  
> @@ -439,6 +510,8 @@ xfs_error_sysfs_init_class(
>  			goto out_error;
>  
>  		cfg->max_retries = init[i].max_retries;
> +		cfg->retry_timeout = msecs_to_jiffies(
> +					init[i].retry_timeout * MSEC_PER_SEC);
>  	}
>  	return 0;
>  
> -- 
> 2.4.11
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
