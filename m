Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:47081 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbeFEKu2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 06:50:28 -0400
Received: by mail-wr0-f171.google.com with SMTP id v13-v6so1877186wrp.13
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jun 2018 03:50:27 -0700 (PDT)
Date: Tue, 5 Jun 2018 12:50:24 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 5/6] xfs: verify root inode more thoroughly
Message-ID: <20180605105024.esot2ruhiuaxot55@odin.usersys.redhat.com>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605062423.4877-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 04:24:22PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When looking up the root inode at mount time, we don't actually do
> any verification to check that the inode is allocated and accounted
> for correctly in the INOBT. Make the checks on the root inode more
> robust by making it an untrusted lookup. This forces the inode
> lookup to use the inode btree to verify the inode is allocated
> and mapped correctly to disk. This will also have the effect of
> catching a significant number of AGI/INOBT related corruptions in
> AG 0 at mount time.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_mount.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 189fa7b615d3..a3378252baa1 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -862,9 +862,12 @@ xfs_mountfs(
>  	 * Get and sanity-check the root inode.
>  	 * Save the pointer to it in the mount structure.
>  	 */
> -	error = xfs_iget(mp, NULL, sbp->sb_rootino, 0, XFS_ILOCK_EXCL, &rip);
> +	error = xfs_iget(mp, NULL, sbp->sb_rootino, XFS_IGET_UNTRUSTED,
> +			 XFS_ILOCK_EXCL, &rip);
>  	if (error) {
> -		xfs_warn(mp, "failed to read root inode");
> +		xfs_warn(mp,
> +			"Failed to read root inode 0x%llx, error %d",
> +			sbp->sb_rootino, -error);
>  		goto out_log_dealloc;
>  	}
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
