Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933648AbeAXOQV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 09:16:21 -0500
Date: Wed, 24 Jan 2018 09:16:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/11] xfs: reflink should break pnfs leases before
 sharing blocks
Message-ID: <20180124141619.GA37554@bfoster.bfoster>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676028366.12349.7219306586282315379.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676028366.12349.7219306586282315379.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 06:18:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Before we share blocks between files, we need to break the pnfs leases
> on the layout before we start slicing and dicing the block map.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 47aea2e..f89a725 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1245,6 +1245,50 @@ xfs_reflink_remap_blocks(
>  }
>  
>  /*
> + * Grab the exclusive iolock for a data copy from src to dest, making
> + * sure to abide vfs locking order (lowest pointer value goes first) and
> + * breaking the pnfs layout leases on dest before proceeding.  The loop
> + * is needed because we cannot call the blocking break_layout() with the
> + * src iolock held, and therefore have to back out both locks.
> + */
> +static int
> +xfs_iolock_two_inodes_and_break_layout(
> +	struct inode		*src,
> +	struct inode		*dest)
> +{
> +	bool			src_first = src < dest;
> +	bool			src_last = src > dest;
> +	int			error;
> +
> +retry:
> +	if (src_first) {
> +		inode_lock(src);
> +		inode_lock_nested(dest, I_MUTEX_NONDIR2);
> +	} else {
> +		inode_lock(dest);
> +	}
> +
> +	error = break_layout(dest, false);
> +	if (error == -EWOULDBLOCK) {
> +		inode_unlock(dest);
> +		if (src_first)
> +			inode_unlock(src);
> +		error = break_layout(dest, true);
> +		if (error)
> +			return error;
> +		goto retry;
> +	} else if (error) {
> +		inode_unlock(dest);
> +		if (src_first)
> +			inode_unlock(src);
> +		return error;
> +	}
> +	if (src_last)
> +		inode_lock_nested(src, I_MUTEX_NONDIR2);
> +	return 0;
> +}
> +
> +/*
>   * Link a range of blocks from one file to another.
>   */
>  int
> @@ -1274,7 +1318,9 @@ xfs_reflink_remap_range(
>  		return -EIO;
>  
>  	/* Lock both files against IO */
> -	lock_two_nondirectories(inode_in, inode_out);
> +	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
> +	if (ret)
> +		return ret;
>  	if (same_inode)
>  		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
>  	else
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
