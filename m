Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38650 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727572AbeIFC01 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Sep 2018 22:26:27 -0400
Date: Thu, 6 Sep 2018 07:54:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't fail dax mount w/ reflink if dax gets disabled
Message-ID: <20180905215414.GY5631@dastard>
References: <d4e84fa3-6cf5-4ea1-d61c-e1c74f2b0d06@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4e84fa3-6cf5-4ea1-d61c-e1c74f2b0d06@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Sep 05, 2018 at 11:24:45AM -0500, Eric Sandeen wrote:
> Today, we can get an interesting result when mounting a reflink filesystem
> with -o dax on a device that doesn't support it:
> 
> XFS (sda1): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> XFS (sda1): DAX unsupported by block device. Turning off DAX.
> XFS (sda1): DAX and reflink cannot be used together!
> 
> <fail mount>
> 
> If we're willing to silently turn off DAX due to incompatibility with the
> block device, it makes no sense to then fail the mount due to
> incompatibility with the filesystem format.  So, skip this check if we
> already decided to turn off DAX and proceed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 207ee30..c85c432 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1677,8 +1677,7 @@ struct proc_xfs_info {
>  			xfs_alert(mp,
>  			"DAX unsupported by block device. Turning off DAX.");
>  			mp->m_flags &= ~XFS_MOUNT_DAX;
> -		}
> -		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		} else if (xfs_sb_version_hasreflink(&mp->m_sb)) {

Shouldn't this be:

		if ((mp->m_flags & XFS_MOUNT_DAX) &&
		    xfs_sb_version_hasreflink(&mp->m_sb)) {

>  			xfs_alert(mp,
>  		"DAX and reflink cannot be used together!");
>  			error = -EINVAL;

I.e. separate the reflink check form the initial mount option check
which may turn the mount option off?

I suspect we need to be more harsh are rejecting mounts with -o dax
on devices DAX isn't supported on. This mount option is going into
production systems - it's not just for "testing" as the comments all
claim. i Things will break in production systems if DAX isn't
enabled and they are expecting it to be enabled.

Combine that with block devices that can change their DAX support
without warning (see recent thread about dm dax behaviour), and
we've got a landmine that looks like "DAX works, I reboot, now DAX
doesn't work and I got no errors".

So perhaps this needs more thought w.r.t to rejection when -o dax is
used on non-dax devices.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
