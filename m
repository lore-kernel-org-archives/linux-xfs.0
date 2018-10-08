Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33852 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725749AbeJIFYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Oct 2018 01:24:07 -0400
Date: Tue, 9 Oct 2018 09:10:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: hard fail dax mount on unsupported devices
Message-ID: <20181008221011.GF18095@dastard>
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
 <1539027169-23332-2-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539027169-23332-2-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Mon, Oct 08, 2018 at 02:32:47PM -0500, Eric Sandeen wrote:
> As dax inches closer to production use, an administrator should not
> be surprised by silently disabling the feature they asked for.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  fs/xfs/xfs_super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 207ee30..a0a32cd 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1674,9 +1674,9 @@ struct proc_xfs_info {
>  			rtdev_is_dax = bdev_dax_supported(
>  				mp->m_rtdev_targp->bt_bdev, sb->s_blocksize);
>  		if (!rtdev_is_dax && !datadev_is_dax) {
> -			xfs_alert(mp,
> -			"DAX unsupported by block device. Turning off DAX.");
> -			mp->m_flags &= ~XFS_MOUNT_DAX;
> +			xfs_alert(mp, "DAX unsupported by block device.");
> +			error = -EINVAL;
> +			goto out_filestream_unmount;
>  		}
>  		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
>  			xfs_alert(mp,

Looks good, I'll throw it in the stack for 4.20.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
