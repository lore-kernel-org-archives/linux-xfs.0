Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD5ED7CA3
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 10:44:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B924AC005
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 08:44:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9FeXDYddF0b7hqkB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2016 08:44:53 -0800 (PST)
Date: Tue, 16 Feb 2016 11:44:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/9] xfs: add "fail at unmount" error handling
	configuration
Message-ID: <20160216164451.GC39655@bfoster.bfoster>
References: <1454635407-22276-1-git-send-email-david@fromorbit.com>
	<1454635407-22276-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454635407-22276-7-git-send-email-david@fromorbit.com>
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

On Fri, Feb 05, 2016 at 12:23:24PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we take "retry forever" literally on metadata IO errors, we can
> hang an unmount retries those writes forever. This is the default
> behaviour, unfortunately. Add a error configuration option for this
> behaviour and default it to "fail" so that an unmount will trigger
> actual errors, a shutdown and allow the unmount to succeed. It will
> be noisy, though, as it will log the errors and shutdown that
> occurs.
> 
> To do this, we need to mark the filesystem as being in the process
> of unmounting. Do this with a mount flag that is added at the
> appropriate time (i.e. before the blocking AIL sync). We also need
> to add this flag if mount fails after the initial phase of log
> recovery has been run.
> 
> The config is done by a separate boolean sysfs option rather than a
> new fail_speed enum, as fail_at_unmount is relevant to both
> XFS_ERR_FAIL_NEVER and XFS_ERR_FAIL_SLOW options.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Similar question of scope/granularity here... why would one want to set
this option for a particular error and not any others? In other words,
it seems more useful as a global (or per-mount) option.

Brian

>  fs/xfs/xfs_buf_item.c |  4 ++++
>  fs/xfs/xfs_mount.c    |  9 +++++++++
>  fs/xfs/xfs_mount.h    |  2 ++
>  fs/xfs/xfs_sysfs.c    | 36 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 51 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 7afd4d5..9220283 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1001,6 +1001,10 @@ xfs_buf_iodone_callback_error(
>  		break;
>  	}
>  
> +	/* At unmount we may treat errors differently */
> +	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && cfg->fail_at_unmount)
> +		goto permanent_error;
> +
>  	/* still a transient error, higher layers will retry */
>  	xfs_buf_ioerror(bp, 0);
>  	xfs_buf_relse(bp);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index f6fb5e1..f8c4a50 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -980,6 +980,7 @@ xfs_mountfs(
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
>  	xfs_reclaim_inodes(mp, SYNC_WAIT);
>   out_log_dealloc:
> +	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
>  	xfs_log_mount_cancel(mp);
>   out_fail_wait:
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
> @@ -1031,6 +1032,14 @@ xfs_unmountfs(
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
>  	/*
> +	 * We now need to tell the world we are unmounting. This will allow
> +	 * us to detect that the filesystem is going away and we should error
> +	 * out anything that we have been retrying in the background. This will
> +	 * prevent neverending retries iin AIL pushing from hanging the unmount.
> +	 */
> +	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
> +
> +	/*
>  	 * Flush all pending changes from the AIL.
>  	 */
>  	xfs_ail_push_all_sync(mp->m_ail);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 2a3d178..edeb0b6 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -64,6 +64,7 @@ struct xfs_error_cfg {
>  	int		fail_speed;
>  	int		max_retries;	/* INT_MAX = retry forever */
>  	unsigned long	retry_timeout;	/* in jiffies, 0 = no timeout */
> +	bool		fail_at_unmount;
>  };
>  
>  typedef struct xfs_mount {
> @@ -187,6 +188,7 @@ typedef struct xfs_mount {
>  #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
>  						   must be synchronous except
>  						   for space allocations */
> +#define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
>  #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
>  #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
>  						   operations, typically for
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 51d9fa7..a5b040a 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -435,10 +435,43 @@ retry_timeout_seconds_store(
>  }
>  XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
>  
> +static ssize_t
> +fail_at_unmount_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", cfg->fail_at_unmount);
> +}
> +
> +static ssize_t
> +fail_at_unmount_store(
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
> +	if (val < 0 || val > 1)
> +		return -EINVAL;
> +
> +	cfg->fail_at_unmount = val;
> +	return count;
> +}
> +XFS_SYSFS_ATTR_RW(fail_at_unmount);
> +
>  static struct attribute *xfs_error_attrs[] = {
>  	ATTR_LIST(failure_speed),
>  	ATTR_LIST(max_retries),
>  	ATTR_LIST(retry_timeout_seconds),
> +	ATTR_LIST(fail_at_unmount),
>  	NULL,
>  };
>  
> @@ -464,6 +497,7 @@ struct xfs_error_init {
>  	int		fail_speed;
>  	int		max_retries;
>  	int		retry_timeout;	/* in seconds */
> +	bool		fail_at_unmount;
>  };
>  
>  static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
> @@ -471,6 +505,7 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
>  	  .fail_speed = XFS_ERR_FAIL_NEVER,
>  	  .max_retries = INT_MAX,
>  	  .retry_timeout = 0,
> +	  .fail_at_unmount = true,
>  	},
>  };
>  
> @@ -504,6 +539,7 @@ xfs_error_sysfs_init_class(
>  		cfg->max_retries = init[i].max_retries;
>  		cfg->retry_timeout = msecs_to_jiffies(
>  					init[i].retry_timeout * MSEC_PER_SEC);
> +		cfg->fail_at_unmount = init[i].fail_at_unmount;
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
