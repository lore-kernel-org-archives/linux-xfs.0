Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B1B557CA3
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 10:44:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A2C3F8F8039
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 08:44:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7GidurZhCcMj0AGL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2016 08:44:36 -0800 (PST)
Date: Tue, 16 Feb 2016 11:44:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: add configuration of error failure speed
Message-ID: <20160216164432.GB39655@bfoster.bfoster>
References: <1454635407-22276-1-git-send-email-david@fromorbit.com>
	<1454635407-22276-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454635407-22276-6-git-send-email-david@fromorbit.com>
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

On Fri, Feb 05, 2016 at 12:23:23PM +1100, Dave Chinner wrote:
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
>  fs/xfs/xfs_buf.h      |  23 ++++++++-
>  fs/xfs/xfs_buf_item.c |  22 ++++++++-
>  fs/xfs/xfs_mount.h    |   2 +
>  fs/xfs/xfs_sysfs.c    | 128 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  4 files changed, 169 insertions(+), 6 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 68e34d1..7afd4d5 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
...
> @@ -979,9 +982,25 @@ xfs_buf_iodone_callback_error(
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

I wonder a bit how granular this system needs to be in terms of user
interface, at least right now. For example, fail fast and fail never
just seem like variants of fail slow with particular tunables. Fail fast
is roughly equivalent to a retry count of one, whereas fail never
implies an infinite (e.g., -1) retry count. Do we really need the higher
level classification?

>  	/* still a transient error, higher layers will retry */
>  	xfs_buf_ioerror(bp, 0);
>  	xfs_buf_relse(bp);
> @@ -1023,6 +1042,7 @@ xfs_buf_iodone_callbacks(
>  	 * retry state here in preparation for the next error that may occur.
>  	 */
>  	bp->b_last_error = 0;
> +	bp->b_retries = 0;
>  
>  	xfs_buf_do_callbacks(bp);
>  	bp->b_fspriv = NULL;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 9a61f39..2a3d178 100644
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
> index 27487ce..51d9fa7 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
...
> @@ -330,6 +326,123 @@ to_error_cfg(struct kobject *kobject)
...
> +static ssize_t
> +retry_timeout_seconds_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
> +
> +	return snprintf(buf, PAGE_SIZE, "%ld\n", 

Trailing whitespace here ^

Brian

> +			jiffies_to_msecs(cfg->retry_timeout) * MSEC_PER_SEC);
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
> +	ATTR_LIST(failure_speed),
> +	ATTR_LIST(max_retries),
> +	ATTR_LIST(retry_timeout_seconds),
> +	NULL,
> +};
> +
> +
>  struct kobj_type xfs_error_cfg_ktype = {
>  	.release = xfs_sysfs_release,
>  	.sysfs_ops = &xfs_sysfs_ops,
> @@ -349,11 +462,15 @@ struct kobj_type xfs_error_ktype = {
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
> @@ -384,6 +501,9 @@ xfs_error_sysfs_init_class(
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
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
