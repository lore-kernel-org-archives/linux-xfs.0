Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942255AbcJFQol (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Oct 2016 12:44:41 -0400
Date: Thu, 6 Oct 2016 12:44:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 39/63] xfs: cancel pending CoW reservations when
 destroying inodes
Message-ID: <20161006164438.GD16893@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520499278.29434.8445614313262327612.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520499278.29434.8445614313262327612.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 08:09:52PM -0700, Darrick J. Wong wrote:
> When destroying the inode, cancel all pending reservations in the CoW
> fork so that all the reserved blocks go back to the free pile.  In
> theory this sort of cleanup is only needed to clean up after write
> errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_super.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 204b794..26b45b3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -49,6 +49,7 @@
>  #include "xfs_rmap_item.h"
>  #include "xfs_refcount_item.h"
>  #include "xfs_bmap_item.h"
> +#include "xfs_reflink.h"
>  
>  #include <linux/namei.h>
>  #include <linux/init.h>
> @@ -938,6 +939,7 @@ xfs_fs_destroy_inode(
>  	struct inode		*inode)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
> +	int			error;
>  
>  	trace_xfs_destroy_inode(ip);
>  
> @@ -945,6 +947,12 @@ xfs_fs_destroy_inode(
>  	XFS_STATS_INC(ip->i_mount, vn_rele);
>  	XFS_STATS_INC(ip->i_mount, vn_remove);
>  
> +	error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
> +	if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
> +		xfs_warn(ip->i_mount, "Error %d while evicting CoW blocks "
> +				"for inode %llu.",
> +				error, ip->i_ino);
> +

We don't actually check the inode reflink flag until down in
xfs_reflink_cancel_cow_blocks(), after we've allocated a transaction.
That seems potentially heavy weight for reclaim, as if there's a
performance impact (which I haven't tested) it would affect all
filesystems afaict (i.e., regardless of whether reflink is supported).

Further, if this isn't a reflink inode, it looks like we actually commit
the transaction rather than cancel it as well.

Brian

>  	xfs_inactive(ip);
>  
>  	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
