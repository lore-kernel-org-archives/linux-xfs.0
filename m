Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51346 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933738AbdHYP5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 11:57:54 -0400
Date: Fri, 25 Aug 2017 08:57:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/9] xfs: move bmbt owner change to last step of extent
 swap
Message-ID: <20170825155749.GP4796@magnolia>
References: <20170825150557.43010-1-bfoster@redhat.com>
 <20170825150557.43010-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825150557.43010-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 25, 2017 at 11:05:55AM -0400, Brian Foster wrote:
> The extent swap operation currently resets bmbt block owners before
> the inode forks are swapped. The bmbt buffers are marked as ordered
> so they do not have to be physically logged in the transaction.
> 
> This use of ordered buffers is not safe as bmbt buffers may have
> been previously physically logged. The bmbt owner change algorithm
> needs to be updated to physically log buffers that are already dirty
> when/if they are encountered. This means that an extent swap will
> eventually require multiple rolling transactions to handle large
> btrees. In addition, all inode related changes must be logged before
> the bmbt owner change scan begins and can roll the transaction for
> the first time to preserve fs consistency via log recovery.
> 
> In preparation for such fixes to the bmbt owner change algorithm,
> refactor the bmbt scan out of the extent fork swap code to the last
> operation before the transaction is committed. Update
> xfs_swap_extent_forks() to only set the inode log flags when an
> owner change scan is necessary. Update xfs_swap_extents() to trigger
> the owner change based on the inode log flags. Note that since the
> owner change now occurs after the extent fork swap, the inode btrees
> must be fixed up with the inode number of the current inode (similar
> to log recovery).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok I think,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_bmap_util.c | 44 ++++++++++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 93e9552..ee8fb9a 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1840,29 +1840,18 @@ xfs_swap_extent_forks(
>  	}
>  
>  	/*
> -	 * Before we've swapped the forks, lets set the owners of the forks
> -	 * appropriately. We have to do this as we are demand paging the btree
> -	 * buffers, and so the validation done on read will expect the owner
> -	 * field to be correctly set. Once we change the owners, we can swap the
> -	 * inode forks.
> +	 * Btree format (v3) inodes have the inode number stamped in the bmbt
> +	 * block headers. We can't start changing the bmbt blocks until the
> +	 * inode owner change is logged so recovery does the right thing in the
> +	 * event of a crash. Set the owner change log flags now and leave the
> +	 * bmbt scan as the last step.
>  	 */
>  	if (ip->i_d.di_version == 3 &&
> -	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> +	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
>  		(*target_log_flags) |= XFS_ILOG_DOWNER;
> -		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK,
> -					      tip->i_ino, NULL);
> -		if (error)
> -			return error;
> -	}
> -
>  	if (tip->i_d.di_version == 3 &&
> -	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> +	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
>  		(*src_log_flags) |= XFS_ILOG_DOWNER;
> -		error = xfs_bmbt_change_owner(tp, tip, XFS_DATA_FORK,
> -					      ip->i_ino, NULL);
> -		if (error)
> -			return error;
> -	}
>  
>  	/*
>  	 * Swap the data forks of the inodes
> @@ -2092,6 +2081,25 @@ xfs_swap_extents(
>  	xfs_trans_log_inode(tp, tip, target_log_flags);
>  
>  	/*
> +	 * The extent forks have been swapped, but crc=1,rmapbt=0 filesystems
> +	 * have inode number owner values in the bmbt blocks that still refer to
> +	 * the old inode. Scan each bmbt to fix up the owner values with the
> +	 * inode number of the current inode.
> +	 */
> +	if (src_log_flags & XFS_ILOG_DOWNER) {
> +		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK,
> +					      ip->i_ino, NULL);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +	if (target_log_flags & XFS_ILOG_DOWNER) {
> +		error = xfs_bmbt_change_owner(tp, tip, XFS_DATA_FORK,
> +					      tip->i_ino, NULL);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
> +	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * transaction goes to disk before returning to the user.
>  	 */
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
