Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QFV5vl048313 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:31:05 -0500
Message-ID: <501162BA.4000108@sgi.com>
Date: Thu, 26 Jul 2012 10:31:06 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] xfs: do not take the iolock in xfs_inactive
References: <20120704151328.928543446@bombadil.infradead.org>
	<20120704151443.765745844@bombadil.infradead.org>
In-Reply-To: <20120704151443.765745844@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 07/04/2012 10:13 AM, Christoph Hellwig wrote:
> An inode that enters xfs_inactive has been removed from all global
> lists but the inode hash, and can't be recycled in xfs_iget before
> it has been marked reclaimable.  Thus taking the iolock in here
> is not nessecary at all, and given the amount of lockdep false
> positives it has triggered already I'd rather remove the locking.
>
> The only change outside of xfs_inactive is relaxing an assert in
> xfs_itruncate_extents.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> ---
>  fs/xfs/xfs_inode.c    |    4 +++-
>  fs/xfs/xfs_vnodeops.c |   29 ++++++++++++-----------------
>  2 files changed, 15 insertions(+), 18 deletions(-)
>
> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c	2012-07-04 09:51:01.347038413 +0200
> +++ xfs/fs/xfs/xfs_vnodeops.c	2012-07-04 09:51:03.913705064 +0200
> @@ -554,7 +554,7 @@ xfs_inactive(
>  		return VN_INACTIVE_CACHE;
>  	}
>
> -	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>
>  	if (S_ISLNK(ip->i_d.di_mode)) {
> @@ -591,21 +591,24 @@ xfs_inactive(
>  		ASSERT(ip->i_d.di_forkoff != 0);
>
>  		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
> -			goto error_unlock;
> +			goto out_unlock;
> +
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>
>  		error = xfs_attr_inactive(ip);
>  		if (error)
> -			goto error_unlock;
> +			goto out;
>
>  		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
>  		error = xfs_trans_reserve(tp, 0,
>  					  XFS_IFREE_LOG_RES(mp),
>  					  0, XFS_TRANS_PERM_LOG_RES,
>  					  XFS_INACTIVE_LOG_COUNT);
> -		if (error)
> -			goto error_cancel;
> +		if (error) {
> +			xfs_trans_cancel(tp, 0);
> +			goto out;
> +		}
>
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, 0);
> @@ -658,21 +661,13 @@ xfs_inactive(
>  	 * Release the dquots held by inode, if any.
>  	 */
>  	xfs_qm_dqdetach(ip);
> -	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> -
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out:
>  	return VN_INACTIVE_CACHE;
>  out_cancel:
>  	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
> -	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> -	return VN_INACTIVE_CACHE;
> -
> -error_cancel:
> -	ASSERT(XFS_FORCED_SHUTDOWN(mp));
> -	xfs_trans_cancel(tp, 0);
> -error_unlock:
> -	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> -	return VN_INACTIVE_CACHE;
> +	goto out_unlock;
>  }
Although I am not a fan of goto statements, this code would be very ugly 
without it.
>
>  /*
> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2012-07-04 09:40:04.413709004 +0200
> +++ xfs/fs/xfs/xfs_inode.c	2012-07-04 09:51:03.913705064 +0200
> @@ -1123,7 +1123,9 @@ xfs_itruncate_extents(
>  	int			error = 0;
>  	int			done = 0;
>
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
> +	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
>  	ASSERT(new_size <= XFS_ISIZE(ip));
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	ASSERT(ip->i_itemp != NULL);
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

This is a good first step to removing the iolock.  Looks good.

Reviewed-by:	Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
