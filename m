Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:17485 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751296AbeBWAuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 19:50:51 -0500
Date: Fri, 23 Feb 2018 11:50:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: implement the lazytime mount options
Message-ID: <20180223005048.GK7000@dastard>
References: <20180222152957.19624-1-hch@lst.de>
 <20180222152957.19624-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180222152957.19624-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Thu, Feb 22, 2018 at 07:29:57AM -0800, Christoph Hellwig wrote:
> Use the VFS dirty inode tracking for lazytime inodes only, and just
> log them in ->dirty_inode.

This is a lot cleaner than what I was looking at doing. :)

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iops.c        |  5 +++++
>  fs/xfs/xfs_super.c       | 23 +++++++++++++++++++++++
>  fs/xfs/xfs_trans_inode.c |  8 ++++++++
>  3 files changed, 36 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 56475fcd76f2..0946a3baae6a 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -46,6 +46,7 @@
>  #include <linux/security.h>
>  #include <linux/iomap.h>
>  #include <linux/slab.h>
> +#include <linux/iversion.h>
>  
>  /*
>   * Directories have different lock order w.r.t. mmap_sem compared to regular
> @@ -1057,6 +1058,10 @@ xfs_vn_update_time(
>  
>  	trace_xfs_update_time(ip);
>  
> +	if ((inode->i_sb->s_flags & SB_LAZYTIME) &&
> +	    !((flags & S_VERSION) && inode_maybe_inc_iversion(inode, false)))
> +		return generic_update_time(inode, now, flags);

So if we've incremented iversion here on a lazytime update (hence
making it not lazy), we won't do the iversion update in
xfs_trans_log_inode() because the query bit has been cleared here.
Hence we won't set XFS_ILOG_CORE in the transaction and the iversion
update will not be logged.

Maybe:

	int	log_flags = XFS_ILOG_TIMESTAMP;
	...

	if (inode->i_sb->s_flags & SB_LAZYTIME) {
		if (!(flags & S_VERSION) ||
		     !inode_maybe_inc_iversion(inode, false)))
			return generic_update_time(inode, now, flags);

		/* Capture the iversion update that just occurred */
		log_flags |= XFS_ILOG_CORE;
	}

	.....
	xfs_trans_log_inode(tp, ip, log_flags);
	.....

> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index fddacf9575df..769943fcc1f2 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -98,9 +98,17 @@ xfs_trans_log_inode(
>  	xfs_inode_t	*ip,
>  	uint		flags)
>  {
> +	struct inode	*inode = VFS_I(ip);
> +
>  	ASSERT(ip->i_itemp != NULL);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
> +	if (inode->i_state & (I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED)) {
> +		spin_lock(&inode->i_lock);
> +		inode->i_state &= ~(I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED);
> +		spin_unlock(&inode->i_lock);
> +	}

I suspect this is racy w.r.t other code that sets/clears the
I_DIRTY_TIME fields. Shouldn't both the check and clear be under the
spin lock?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
