Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57484 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750993AbeEBT6Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 15:58:16 -0400
Date: Wed, 2 May 2018 12:58:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: be careful about what we stat in
 platform_check_mount
Message-ID: <20180502195809.GZ4127@magnolia>
References: <92bcf603-5106-9fa0-1b48-0d13ff0608c8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92bcf603-5106-9fa0-1b48-0d13ff0608c8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, May 02, 2018 at 02:56:22PM -0500, Eric Sandeen wrote:
> After we lost ustat(2) in commit 4e7a824, we ended up with a slightly
> bonkers method to determine if our target block device was mounted:
> it goes through every entry returned by getmntent and stats the dir
> to see if its underlying device matches ours.
> 
> Unfortunately that dir might be a hung nfs server and sadness ensues.
> 
> So do some pre-checks; can we stat the mounted "device?"  If so is
> it really a block device?  If not, skip it.
> 
> Fixes: 4e7a824 ("libxfs/linux.c: Replace use of ustat by stat")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/libxfs/linux.c b/libxfs/linux.c
> index 0bace3e..7350fa7 100644
> --- a/libxfs/linux.c
> +++ b/libxfs/linux.c
> @@ -77,7 +77,21 @@ platform_check_mount(char *name, char *block, struct stat *s, int flags)
>  		    progname, name);
>  		return 1;
>  	}
> +	/*
> +	 * This whole business is to work out if our block device is mounted
> +	 * after we lost ustat(2), see:
> +	 * 	4e7a824 libxfs/linux.c: Replace use of ustat by stat
> +	 * We don't really want to stat every single mounted directory,
> +	 * as that may include tmpfs, cgroups, procfs or - worst - hung nfs
> +	 * servers.  So we check the "device" before going after the mountpoint.
> +	 */
>  	while ((mnt = getmntent(f)) != NULL) {
> +		/* If the "fsname" is't a stat-able device, skip it */
> +		if (stat(mnt->mnt_fsname, &mst) < 0)
> +			continue;
> +		if (!S_ISBLK(mst.st_mode))
> +			continue;
> +		/* Ok, this entry does seem to be a mounted block device */
>  		if (stat(mnt->mnt_dir, &mst) < 0)
>  			continue;
>  		if (mst.st_dev != s->st_rdev)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
