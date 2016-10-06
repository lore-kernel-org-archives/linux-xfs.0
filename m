Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751346AbcJFQof (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Oct 2016 12:44:35 -0400
Date: Thu, 6 Oct 2016 12:44:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 38/63] xfs: cancel CoW reservations and clear inode
 reflink flag when freeing blocks
Message-ID: <20161006164432.GC16893@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520498644.29434.5014643991183828847.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520498644.29434.5014643991183828847.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 08:09:46PM -0700, Darrick J. Wong wrote:
> When we're freeing blocks (truncate, punch, etc.), clear all CoW
> reservations in the range being freed.  If the file block count
> drops to zero, also clear the inode reflink flag.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 0c25a76..8c971fd 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -49,6 +49,7 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_reflink.h"
>  
>  kmem_zone_t *xfs_inode_zone;
>  
> @@ -1586,6 +1587,18 @@ xfs_itruncate_extents(
>  			goto out;
>  	}
>  
> +	/* Remove all pending CoW reservations. */
> +	error = xfs_reflink_cancel_cow_blocks(ip, &tp, first_unmap_block,
> +			last_block);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Clear the reflink flag if we truncated everything.
> +	 */
> +	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip))
> +		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> +

So this implies the reflink flag is more of an optimization than an
accurate assessment of reflink state (e.g., we can have DIFLAG2_REFLINK
w/o shared extents, but we should never have shared extents w/o the
flag) because this wouldn't clear the flag on a partial truncate that
happened to unmap all of the shared extents from the file.

That seems fine, I'll just note there's one small potential conflict
ahead where we (dis)allow setting the realtime state based on the
reflink flag.

Brian

>  	/*
>  	 * Always re-log the inode so that our permanent transaction can keep
>  	 * on rolling it forward in the log.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
