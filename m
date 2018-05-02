Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbeEBOam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 10:30:42 -0400
Date: Wed, 2 May 2018 07:30:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] fs: hoist BTRFS_IOC_[SG]ET_FSLABEL to vfs
Message-ID: <20180502143039.GN4127@magnolia>
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
 <f763f19b-0da0-ee3f-3d79-eb18ab0a4f11@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f763f19b-0da0-ee3f-3d79-eb18ab0a4f11@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 30, 2018 at 10:42:44AM -0500, Eric Sandeen wrote:
> Move the btrfs label ioctls up to the vfs for general use.
> 
> This retains 256 chars as the maximum size through the interface, which
> is the btrfs limit and AFAIK exceeds any other filesystem's maximum
> label size.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/btrfs/ioctl.c           | 8 ++++----
>  include/uapi/linux/btrfs.h | 6 ++----
>  include/uapi/linux/fs.h    | 8 ++++++--
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 632e26d..2dd4cdf 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5444,6 +5444,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_setflags(file, argp);
>  	case FS_IOC_GETVERSION:
>  		return btrfs_ioctl_getversion(file, argp);
> +	case FS_IOC_GET_FSLABEL:
> +		return btrfs_ioctl_get_fslabel(file, argp);
> +	case FS_IOC_SET_FSLABEL:
> +		return btrfs_ioctl_set_fslabel(file, argp);
>  	case FITRIM:
>  		return btrfs_ioctl_fitrim(file, argp);
>  	case BTRFS_IOC_SNAP_CREATE:
> @@ -5555,10 +5559,6 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_quota_rescan_wait(file, argp);
>  	case BTRFS_IOC_DEV_REPLACE:
>  		return btrfs_ioctl_dev_replace(fs_info, argp);
> -	case BTRFS_IOC_GET_FSLABEL:
> -		return btrfs_ioctl_get_fslabel(file, argp);
> -	case BTRFS_IOC_SET_FSLABEL:
> -		return btrfs_ioctl_set_fslabel(file, argp);
>  	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
>  		return btrfs_ioctl_get_supported_features(argp);
>  	case BTRFS_IOC_GET_FEATURES:
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index c8d99b9..ec611c8 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -823,10 +823,8 @@ enum btrfs_err_code {
>  #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
>  			       struct btrfs_ioctl_quota_rescan_args)
>  #define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
> -#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
> -				   char[BTRFS_LABEL_SIZE])
> -#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
> -				   char[BTRFS_LABEL_SIZE])
> +#define BTRFS_IOC_GET_FSLABEL 	FS_IOC_GET_FSLABEL
> +#define BTRFS_IOC_SET_FSLABEL	FS_IOC_SET_FSLABEL
>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>  				      struct btrfs_ioctl_get_dev_stats)
>  #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index d2a8313..1df3707 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -242,6 +242,8 @@ struct fsxattr {
>  #define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)
>  #define FIDEDUPERANGE	_IOWR(0x94, 54, struct file_dedupe_range)
>  
> +#define FSLABEL_MAX 256	/* Max chars for the interface; each fs may differ */
> +
>  #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
>  #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
>  #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
> @@ -251,8 +253,10 @@ struct fsxattr {
>  #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
>  #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
>  #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
> -#define FS_IOC_FSGETXATTR		_IOR ('X', 31, struct fsxattr)
> -#define FS_IOC_FSSETXATTR		_IOW ('X', 32, struct fsxattr)
> +#define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
> +#define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
> +#define FS_IOC_GET_FSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
> +#define FS_IOC_SET_FSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
>  
>  /*
>   * File system encryption support
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
