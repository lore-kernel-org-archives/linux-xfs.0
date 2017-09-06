Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49052 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753346AbdIFAwK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 20:52:10 -0400
Date: Wed, 6 Sep 2017 02:52:08 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v3] xfs: add online uevent for mount operation
Message-ID: <20170906005208.GE29261@wotan.suse.de>
References: <1504507859-39323-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504507859-39323-1-git-send-email-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com

On Mon, Sep 04, 2017 at 02:50:59PM +0800, Hou Tao wrote:
> It will be useful if there is a corresponding online uevent after
> a XFS filesystem has been mounted. A typical usage of the uevent
> is setting the error configuration for a specific XFS filesystem
> or all XFS filesystems by using udevd.
> 
> The following is an example of udevd rule which will shutdown
> any XFS filesystem (except the one with the matched UUID) after
> the filesystem gets any IO error and the filesystem with the matched
> UUID will retry 5 times before its shutdown:
> 
>     ACTION=="online", SUBSYSTEM=="xfs", \
>     ENV{ID_FS_UUID}=="6c1eebfd-d1af-4b69-a0f1-c9b4663df44d", \
>     RUN+="/bin/sh -c 'echo 5 > /sys%p/error/metadata/EIO/max_retries'", \
>     GOTO="end"
> 
>     ACTION=="online", SUBSYSTEM=="xfs", DEVPATH=="/fs/xfs/*", \
>     RUN+="/bin/sh -c 'echo 0 > /sys%p/error/metadata/default/max_retries; \
> 	echo 0 > /sys%p/error/metadata/EIO/max_retries; \
> 	echo 0 > /sys%p/error/metadata/ENOSPC/max_retries; \
> 	echo 0 > /sys%p/error/metadata/ENODEV/max_retries'"
> 
>     LABEL="end"
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
> v3:
>     * code style fixes
>     * use "ID_FS_UUID" instead of "UUID" as the name of uuid environment
> v2:
>     * add UUID property for mount uevent
>     * add an udev example for UUID filtering
> v1:
>     * http://www.spinics.net/lists/linux-xfs/msg09484.html
> ---
>  fs/xfs/xfs_super.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 3a3812b4..1f0d895 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1530,6 +1530,28 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_fdblocks);
>  }
>  
> +static void
> +xfs_fs_uevent(
> +	struct xfs_mount	*mp,
> +	enum kobject_action	action)
> +{
> +#define XFS_UEVENT_MAX_ENV_COUNT 1
> +	/* "+ 1" for the trailing NULL pointer */
> +	char			*envp[XFS_UEVENT_MAX_ENV_COUNT + 1];
> +	const char		*prefix = "ID_FS_UUID=";
> +	char			buf[strlen(prefix) + UUID_STRING_LEN + 1];
> +	int			i = 0;
> +	int			err;
> +
> +	snprintf(buf, sizeof(buf), "%s%pUb", prefix, &mp->m_super->s_uuid);
> +	envp[i++] = buf;
> +	envp[i] = NULL;
> +	err = kobject_uevent_env(&mp->m_kobj.kobject, action, envp);
> +	if (err)
> +		xfs_notice(mp, "Sending XFS uevent %d got error %d",


kobject_uevent_env() can fail for a few reasons, most commonly it can fail for
when we're out of memory. I've seen quite a bit of use cases these days where
tons of remounts can happen, one example is actually is when there is not
enough space dockers instances can get restarted. There are many reasons for
restarts of docker instance, but as stupid as it is, since -ENOMEM could
actually be common, I think we should consider treating it as fatal and not
mount. Otherwise the assumption that userspace will configure the filesystem
correctly may be false.

Note that kobject_uevent_env() can also fail during
netlink_broadcast_filtered(),  so perhaps we should consider all errors well
here.

  Luis
