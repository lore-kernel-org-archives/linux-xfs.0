Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 03FB07F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 14:59:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6552BAC006
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 12:59:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P6sIzjB7DfLEery1 for
	<xfs@oss.sgi.com>; Fri, 06 Jun 2014 12:59:24 -0700 (PDT)
Date: Fri, 6 Jun 2014 15:59:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: fix swapext ilock deadlock
Message-ID: <20140606195920.GD3048@laptop.bfoster>
References: <1402042973-26276-1-git-send-email-david@fromorbit.com>
	<1402042973-26276-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402042973-26276-2-git-send-email-david@fromorbit.com>
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

On Fri, Jun 06, 2014 at 06:22:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_swap_extents() holds the ilock over a call to
> filemap_write_and_wait(), which can then try to write data and take
> the ilock. That causes a self-deadlock.
> 
> Fix the deadlock and clean up the code by separating the locking
> appropriately. Add a lockflags variable to track what locks we are
> holding as we gain and drop them and cleanup the error handling to
> always use "out_unlock" with the lockflags variable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 703b3ec..948eba1 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1686,6 +1686,7 @@ xfs_swap_extents(
>  	int		aforkblks = 0;
>  	int		taforkblks = 0;
>  	__uint64_t	tmp;
> +	int		lock_flags;
>  
>  	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
>  	if (!tempifp) {
> @@ -1694,13 +1695,13 @@ xfs_swap_extents(
>  	}
>  
>  	/*
> -	 * we have to do two separate lock calls here to keep lockdep
> -	 * happy. If we try to get all the locks in one call, lock will
> -	 * report false positives when we drop the ILOCK and regain them
> -	 * below.
> +	 * Lock up the inodes against other IO and truncate to begin with.
> +	 * Then we can ensure the inodes are flushed and have no page cache
> +	 * safely. Once we have done this we can take the ilocks and do the rest
> +	 * of the checks.
>  	 */
> +	lock_flags = XFS_IOLOCK_EXCL;
>  	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
> -	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
>  
>  	/* Verify that both files have the same format */
>  	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {

Perhaps move these checks further down to where we eventually grab the
ilock..? It's not clear to me if that is important.

I was going to suggest to pull up the tp allocation as well to eliminate
the ilock lock/unlock/lock cycle, but it looks like you've done that in
patch 2. However...

> @@ -1719,6 +1720,9 @@ xfs_swap_extents(
>  		goto out_unlock;
>  	truncate_pagecache_range(VFS_I(tip), 0, -1);
>  
> +	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
> +	lock_flags |= XFS_ILOCK_EXCL;
> +
>  	/* Verify O_DIRECT for ftmp */
>  	if (VN_CACHED(VFS_I(tip)) != 0) {
>  		error = XFS_ERROR(EINVAL);
> @@ -1773,6 +1777,7 @@ xfs_swap_extents(
>  
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_iunlock(tip, XFS_ILOCK_EXCL);
> +	lock_flags &= ~XFS_ILOCK_EXCL;
>  
>  	/*
>  	 * There is a race condition here since we gave up the
> @@ -1785,13 +1790,11 @@ xfs_swap_extents(
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
> -	if (error) {
> -		xfs_iunlock(ip,  XFS_IOLOCK_EXCL);
> -		xfs_iunlock(tip, XFS_IOLOCK_EXCL);
> -		xfs_trans_cancel(tp, 0);
> -		goto out;
> -	}
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
> +	lock_flags |= XFS_ILOCK_EXCL;
>  
>  	/*
>  	 * Count the number of extended attribute blocks
> @@ -1810,8 +1813,8 @@ xfs_swap_extents(
>  			goto out_trans_cancel;
>  	}
>  
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> -	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, lock_flags);
> +	xfs_trans_ijoin(tp, tip, lock_flags);
>  

This still stays around in the middle of the function. It looks to me
that the error handling is broken here irrespective of these changes.
e.g., the xfs_trans_cancel() will unlock the inodes assuming the lock
flags are transferred to the tp when the inodes are joined, yes?

If so, out_trans_cancel will try to unlock the inodes after the cancel,
even after the inodes have been joined. It might be good to join the
inodes immediately after we acquire all the required locks (which is
right after we take care of the transaction with both of these patches
applied) and fix out_trans_cancel appropriately.

Brian

>  	/*
>  	 * Before we've swapped the forks, lets set the owners of the forks
> @@ -1940,8 +1943,8 @@ out:
>  	return error;
>  
>  out_unlock:
> -	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> -	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_iunlock(ip, lock_flags);
> +	xfs_iunlock(tip, lock_flags);
>  	goto out;
>  
>  out_trans_cancel:
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
