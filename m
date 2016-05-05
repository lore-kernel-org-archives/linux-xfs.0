Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A4B257CBA
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 09:11:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2389DAC003
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 07:11:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vxrQC4KFLzgQlECs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 07:11:04 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id DB080C04B300
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:11:03 +0000 (UTC)
Date: Thu, 5 May 2016 10:11:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/7] xfs: add configuration handlers for specific errors
Message-ID: <20160505141102.GF1231@bfoster.bfoster>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
	<1462376600-8617-7-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462376600-8617-7-git-send-email-cmaiolino@redhat.com>
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

On Wed, May 04, 2016 at 05:43:19PM +0200, Carlos Maiolino wrote:
> now most of the infrastructure is in place, we can start adding
> support for configuring specific errors such as ENODEV, ENOSPC, EIO,
> etc. Add these error configurations and configure them all to have
> appropriate behaviours. That is, all will be configured to retry forever by
> default, except for ENODEV, which is an unrecoverable error, so it will be
> configured to not retry on error
> 
> Changelog:
> 
> V3:
> 	- Do not implement .fail_speed and .fail_at_unmount
> 	- .fail_at_unmount will be implemented in a different patch
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_mount.h |  3 +++
>  fs/xfs/xfs_sysfs.c | 20 ++++++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 0382140..e3b3267 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -49,6 +49,9 @@ enum {
>  };
>  enum {
>  	XFS_ERR_DEFAULT,
> +	XFS_ERR_EIO,
> +	XFS_ERR_ENOSPC,
> +	XFS_ERR_ENODEV,
>  	XFS_ERR_ERRNO_MAX,
>  };
>  
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index c881360..1ed9033 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -481,6 +481,17 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
>  	  .max_retries = -1,
>  	  .retry_timeout = 0,
>  	},
> +	{ .name = "EIO",
> +	  .max_retries = -1,
> +	  .retry_timeout = 0,
> +	},
> +	{ .name = "ENOSPC",
> +	  .max_retries = -1,
> +	  .retry_timeout = 0,
> +	},
> +	{ .name = "ENODEV",
> +	  .max_retries = -1,

Shouldn't this be 0?

Brian

> +	},
>  };
>  
>  static int
> @@ -578,6 +589,15 @@ xfs_error_get_cfg(
>  	struct xfs_error_cfg	*cfg;
>  
>  	switch (error) {
> +	case EIO:
> +		cfg = &mp->m_error_cfg[error_class][XFS_ERR_EIO];
> +		break;
> +	case ENOSPC:
> +		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENOSPC];
> +		break;
> +	case ENODEV:
> +		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENODEV];
> +		break;
>  	default:
>  		cfg = &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
>  		break;
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
