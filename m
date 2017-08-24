Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33258 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752855AbdHXRKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 13:10:35 -0400
Date: Thu, 24 Aug 2017 10:10:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RESEND][PATCH] xfs: add online uevent for mount operation
Message-ID: <20170824171028.GF4796@magnolia>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

On Thu, Aug 24, 2017 at 09:41:55PM +0800, Hou Tao wrote:
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
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  fs/xfs/xfs_super.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 38aaacd..695fe85f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1530,6 +1530,19 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_fdblocks);
>  }
>  
> +static void
> +xfs_fs_uevent(
> +	struct xfs_mount	*mp,
> +	enum kobject_action	action)
> +{
> +	int err;
> +
> +	err = kobject_uevent(&mp->m_kobj.kobject, action);

It might be useful to send kobject_uevent_env so that we can squeeze in
things like the fs uuid for easier identification?  I envision a
/etc/xfs/fs.conf file like this:

[903db5b1-82cd-4f26-8221-443a4ed0563a]
error.metadata.EIO.max_retries = 0
error.fail_at_unmount = 1
config.cowextsize = 1048576
config.inherit_noatime = 1

With a udev helper that uses the fsuuid to find the appropriate section
of the ini^Wconfig file and load the appropriate values into sysfs.  If
we ever decide to expose more config knobs through sysfs then they'll
be automatically supported.

> +	if (err)
> +		xfs_notice(mp, "Sending XFS uevent %d got error %d",
> +				action, err);
> +}
> +
>  STATIC int
>  xfs_fs_fill_super(
>  	struct super_block	*sb,
> @@ -1667,6 +1680,8 @@ xfs_fs_fill_super(
>  		goto out_unmount;
>  	}
>  
> +	xfs_fs_uevent(mp, KOBJ_ONLINE);

That said, I wonder if we ought to move this discussion to fsdevel to
pull in any /other/ filesystems that have sysfs knobs that they might
like to be able to persist?  ext4 has a bunch of tunables too...

--D

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
