Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48865 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdHaPDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 11:03:42 -0400
Date: Thu, 31 Aug 2017 08:03:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: add online uevent for mount operation
Message-ID: <20170831150334.GI3775@magnolia>
References: <1504189030-18608-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504189030-18608-1-git-send-email-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

On Thu, Aug 31, 2017 at 10:17:10PM +0800, Hou Tao wrote:
> It will be useful if there is a corresponding online uevent after
> a XFS filesystem has been mounted. A typical usage of the uevent
> is setting the error configuration for a specific XFS filesystem
> or all XFS filesystems by using udevd.
> 
> The following is an example of udevd rule which will shutdown
> any XFS filesystem after the filesystem gets any IO error:
> 
>     ACTION=="online", SUBSYSTEM=="xfs", DEVPATH=="/fs/xfs/*", \
>     RUN+="/bin/sh -c 'echo 0 > /sys%p/error/metadata/default/max_retries; \
> 	    echo 0 > /sys%p/error/metadata/EIO/max_retries; \
> 	    echo 0 > /sys%p/error/metadata/ENOSPC/max_retries; \
> 	    echo 0 > /sys%p/error/metadata/ENODEV/max_retries'"
> 
> You also could apply an udevd rule to a specific XFS filesystem by
> UUID filtering:
> 
>     ACTION=="online", SUBSYSTEM=="xfs", \
>     ENV{UUID}=="8f789c27-391f-4bd7-b17d-9bcf2443dc9c", \
>     RUN+="/bin/sh -c 'echo 5 > /sys%p/error/metadata/EIO/max_retries'"
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
> v2:
>     * add UUID property for mount uevent
>     * add an udev example for UUID filtering
> v1:
>     * http://www.spinics.net/lists/linux-xfs/msg09484.html
> ---
>  fs/xfs/xfs_super.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 3a3812b4..6f8351c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -70,6 +70,11 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>  #endif
>  
> +enum {
> +	XFS_UEVENT_ENV_CNT = 2,

XFS_UEVENT_MAX_ENV_COUNT ?

> +	XFS_UEVENT_UUID_LEN = UUID_STRING_LEN + 6,
> +};
> +
>  /*
>   * Table driven mount option parser.
>   */
> @@ -1530,6 +1535,28 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_fdblocks);
>  }
>  
> +static void
> +xfs_fs_uevent(
> +	struct xfs_mount	*mp,
> +	enum kobject_action	action)
> +{
> +	int err;
> +	char *envp[XFS_UEVENT_ENV_CNT];
> +	int i = 0;
> +
> +	if (!uuid_is_null(&mp->m_super->s_uuid)) {
> +		char uuid[XFS_UEVENT_UUID_LEN];
> +
> +		snprintf(uuid, sizeof(uuid), "UUID=%pUb", &mp->m_super->s_uuid);

Should this be "ID_FS_UUID=%pUb" to keep the name consistent with what
blkid injects into the udev environment for block devices?

--D

> +		envp[i++] = uuid;
> +	}
> +	envp[i] = NULL;
> +	err = kobject_uevent_env(&mp->m_kobj.kobject, action, envp);
> +	if (err)
> +		xfs_notice(mp, "Sending XFS uevent %d got error %d",
> +				action, err);
> +}
> +
>  STATIC int
>  xfs_fs_fill_super(
>  	struct super_block	*sb,
> @@ -1667,6 +1694,8 @@ xfs_fs_fill_super(
>  		goto out_unmount;
>  	}
>  
> +	xfs_fs_uevent(mp, KOBJ_ONLINE);
> +
>  	return 0;
>  
>   out_filestream_unmount:
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
