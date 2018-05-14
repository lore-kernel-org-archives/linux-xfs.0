Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59534 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753032AbeENRiG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 13:38:06 -0400
Date: Mon, 14 May 2018 10:37:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2 1/5] fs: copy BTRFS_IOC_[SG]ET_FSLABEL to vfs
Message-ID: <20180514173745.GD4933@magnolia>
References: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
 <4d21659d-5b21-81ff-e759-b1f1519f526c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d21659d-5b21-81ff-e759-b1f1519f526c@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 14, 2018 at 12:35:18PM -0500, Eric Sandeen wrote:
> This retains 256 chars as the maximum size through the interface, which
> is the btrfs limit and AFAIK exceeds any other filesystem's maximum
> label size.
> 
> This just copies the ioctl for now and leaves it in place for btrfs
> for the time being.  A later patch will allow btrfs to use the new
> common ioctl definition, but it may be sent after this is merged.
> 
> (Note, Reviewed-by's were originally given for the combined vfs+btrfs
> patch, some license taken here.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: David Sterba <dsterba@suse.com>

Looks ok, having decided not to fuss about whitespace this time:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  Documentation/ioctl/ioctl-number.txt | 3 ++-
>  include/uapi/linux/fs.h              | 8 ++++++--
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index 7f7413e597f3..27c1b7b78504 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -296,7 +296,8 @@ Code  Seq#(hex)	Include File		Comments
>  0x90	00	drivers/cdrom/sbpcd.h
>  0x92	00-0F	drivers/usb/mon/mon_bin.c
>  0x93	60-7F	linux/auto_fs.h
> -0x94	all	fs/btrfs/ioctl.h
> +0x94	all	fs/btrfs/ioctl.h	Btrfs filesystem
> +		and linux/fs.h		some lifted to vfs/generic
>  0x97	00-7F	fs/ceph/ioctl.h		Ceph file system
>  0x99	00-0F				537-Addinboard driver
>  					<mailto:buk@buks.ipn.de>
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index d2a8313fabd7..9d132f8f2df8 100644
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
> +#define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
> +#define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
>  
>  /*
>   * File system encryption support
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
