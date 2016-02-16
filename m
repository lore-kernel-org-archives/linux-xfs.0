Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A5F27CA3
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 10:45:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3581DAC005
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 08:45:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 86IwBCtAxW6388ex (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2016 08:45:43 -0800 (PST)
Date: Tue, 16 Feb 2016 11:45:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] xfs: disable specific error configurations
Message-ID: <20160216164540.GD39655@bfoster.bfoster>
References: <1454635407-22276-1-git-send-email-david@fromorbit.com>
	<1454635407-22276-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454635407-22276-9-git-send-email-david@fromorbit.com>
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

On Fri, Feb 05, 2016 at 12:23:26PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Different error classes are going to need different error to be
> configured, so we don't want them all to be visible in sysfs. Add a
> configuration check into the config initialisation an lookup
> code to determine if the default should be used for a specific
> error. If so, the sysfs entry is not created, and on lookup the
> default config is returned.
> 
> Add ENOMEM at this point to exercise this code, as it will be used
> later when adding a kmem error failure class.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.h |  1 +
>  fs/xfs/xfs_sysfs.c | 22 ++++++++++++++++++----
>  2 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c05b500..0ff14a90 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -53,6 +53,7 @@ enum {
>  	XFS_ERR_EIO,
>  	XFS_ERR_ENOSPC,
>  	XFS_ERR_ENODEV,
> +	XFS_ERR_ENOMEM,
>  	XFS_ERR_ERRNO_MAX,
>  };
>  enum {
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index d48dc46..c984c3e 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -522,6 +522,9 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
>  	{ .name = "ENODEV",
>  	  .fail_speed = XFS_ERR_FAIL_FAST,
>  	},
> +	{ .name = "ENOMEM",
> +	  .fail_speed = XFS_ERR_FAIL_DEFAULT,
> +	},
>  };
>  
>  static int
> @@ -545,12 +548,17 @@ xfs_error_sysfs_init_class(
>  
>  	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
>  		cfg = &mp->m_error_cfg[class][i];
> +
> +		/* skip errors that are not configurable for this class */
> +		cfg->fail_speed = init[i].fail_speed;
> +		if (cfg->fail_speed == XFS_ERR_FAIL_DEFAULT)
> +			continue;
> +

It seems like this confuses a default configuration for an error with a
"tunable" or "configurable" flag (or otherwise has confused me ;). E.g.,
what happens if we want to alter ENOMEM behavior from the "default"
behavior, retain the current definition in the "Default" entry, but
still not expose the ENOMEM configuration to the user?

Brian

>  		error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
>  					parent_kobj, init[i].name);
>  		if (error)
>  			goto out_error;
>  
> -		cfg->fail_speed = init[i].fail_speed;
>  		cfg->max_retries = init[i].max_retries;
>  		cfg->retry_timeout = msecs_to_jiffies(
>  					init[i].retry_timeout * MSEC_PER_SEC);
> @@ -605,7 +613,8 @@ xfs_error_sysfs_del(
>  		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
>  			cfg = &mp->m_error_cfg[i][j];
>  
> -			xfs_sysfs_del(&cfg->kobj);
> +			if (cfg->fail_speed != XFS_ERR_FAIL_DEFAULT)
> +				xfs_sysfs_del(&cfg->kobj);
>  		}
>  	}
>  	xfs_sysfs_del(&mp->m_error_meta_kobj);
> @@ -630,10 +639,15 @@ xfs_error_get_cfg(
>  	case ENODEV:
>  		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENODEV];
>  		break;
> -	default:
> -		cfg = &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
> +	case ENOMEM:
> +		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENOMEM];
>  		break;
> +	default:
> +		return &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
>  	}
>  
> +	/* The error may not be not configurable, so uses default behaviour */
> +	if (cfg->fail_speed == XFS_ERR_FAIL_DEFAULT)
> +		return &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
>  	return cfg;
>  }
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
