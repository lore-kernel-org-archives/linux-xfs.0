Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2570A7FB6
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 14:31:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DDA6C8F8087
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 12:31:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hZfFlXygXzbrZsnt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 12:31:55 -0800 (PST)
Date: Mon, 9 Feb 2015 15:31:50 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/6] xfs: lock out page faults from extent swap operations
Message-ID: <20150209203150.GM18336@laptop.bfoster>
References: <1423083859-28439-1-git-send-email-david@fromorbit.com>
	<1423083859-28439-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083859-28439-7-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 05, 2015 at 08:04:19AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Extent swap operations are another extent manipulation operation
> that we need to ensure does not race against mmap page faults. The
> current code returns if the file is mapped prior to the swap being
> done, but it could potentially race against new page faults while
> the swap is in progress. Hence we should use the XFS_MMAPLOCK_EXCL
> for this operation, too.
> 
> While there, fix the error path handling that can result in double
> unlocks of the inodes when cancelling the swapext transaction.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 22a5dcb..7efa23e 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1599,13 +1599,6 @@ xfs_swap_extent_flush(
>  	/* Verify O_DIRECT for ftmp */
>  	if (VFS_I(ip)->i_mapping->nrpages)
>  		return -EINVAL;
> -
> -	/*
> -	 * Don't try to swap extents on mmap()d files because we can't lock
> -	 * out races against page faults safely.
> -	 */
> -	if (mapping_mapped(VFS_I(ip)->i_mapping))
> -		return -EBUSY;
>  	return 0;
>  }
>  
> @@ -1633,13 +1626,14 @@ xfs_swap_extents(
>  	}
>  
>  	/*
> -	 * Lock up the inodes against other IO and truncate to begin with.
> -	 * Then we can ensure the inodes are flushed and have no page cache
> -	 * safely. Once we have done this we can take the ilocks and do the rest
> -	 * of the checks.
> +	 * Lock the inodes against other IO, page faults and truncate to
> +	 * begin with.  Then we can ensure the inodes are flushed and have no
> +	 * page cache safely. Once we have done this we can take the ilocks and
> +	 * do the rest of the checks.
>  	 */
> -	lock_flags = XFS_IOLOCK_EXCL;
> +	lock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
> +	xfs_lock_two_inodes(ip, tip, XFS_MMAPLOCK_EXCL);
>  
>  	/* Verify that both files have the same format */
>  	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
> @@ -1666,8 +1660,16 @@ xfs_swap_extents(
>  		xfs_trans_cancel(tp, 0);
>  		goto out_unlock;
>  	}
> +
> +	/*
> +	 * Lock and join the inodes to the tansaction so that transaction commit
> +	 * or cancel will unlock the inodes from this point onwards.
> +	 */
>  	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
>  	lock_flags |= XFS_ILOCK_EXCL;
> +	xfs_trans_ijoin(tp, ip, lock_flags);
> +	xfs_trans_ijoin(tp, tip, lock_flags);
> +
>  
>  	/* Verify all data are being swapped */
>  	if (sxp->sx_offset != 0 ||
> @@ -1720,9 +1722,6 @@ xfs_swap_extents(
>  			goto out_trans_cancel;
>  	}
>  
> -	xfs_trans_ijoin(tp, ip, lock_flags);
> -	xfs_trans_ijoin(tp, tip, lock_flags);
> -
>  	/*
>  	 * Before we've swapped the forks, lets set the owners of the forks
>  	 * appropriately. We have to do this as we are demand paging the btree
> @@ -1856,5 +1855,5 @@ out_unlock:
>  
>  out_trans_cancel:
>  	xfs_trans_cancel(tp, 0);
> -	goto out_unlock;
> +	goto out;
>  }
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
