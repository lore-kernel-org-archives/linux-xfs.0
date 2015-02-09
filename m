Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F1897FAE
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 14:31:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E3F38F8087
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 12:31:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7xgEN2nQVe5mBqnJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 12:31:42 -0800 (PST)
Date: Mon, 9 Feb 2015 15:31:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfs: take i_mmap_lock on extent manipulation
	operations
Message-ID: <20150209203136.GK18336@laptop.bfoster>
References: <1423083859-28439-1-git-send-email-david@fromorbit.com>
	<1423083859-28439-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083859-28439-5-git-send-email-david@fromorbit.com>
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

On Thu, Feb 05, 2015 at 08:04:17AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have the i_mmap_lock being held across the page fault IO
> path, we now add extent manipulation operation exclusion by adding
> the lock to the paths that directly modify extent maps. This
> includes truncate, hole punching and other fallocate based
> operations. The operations will now take both the i_iolock and the
> i_mmaplock in exclusive mode, thereby ensuring that all IO and page
> faults block without holding any page locks while the extent
> manipulation is in progress.
> 
> This gives us the lock order during truncate of i_iolock ->
> i_mmaplock -> page_lock -> i_lock, hence providing the same
> lock order as the iolock provides the normal IO path without
> involving the mmap_sem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c  | 4 ++--
>  fs/xfs/xfs_ioctl.c | 4 ++--
>  fs/xfs/xfs_iops.c  | 5 +++--
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 2bb25fd..76bf14a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -830,7 +830,7 @@ xfs_file_fallocate(
>  		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
>  		return -EOPNOTSUPP;
>  
> -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +	xfs_ilock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
>  		error = xfs_free_file_space(ip, offset, len);
>  		if (error)
> @@ -894,7 +894,7 @@ xfs_file_fallocate(
>  	}
>  
>  out_unlock:
> -	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +	xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index b88ab92..972fa13 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -636,7 +636,7 @@ xfs_ioc_space(
>  	if (error)
>  		return error;
>  
> -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +	xfs_ilock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
>  
>  	switch (bf->l_whence) {
>  	case 0: /*SEEK_SET*/
> @@ -725,7 +725,7 @@ xfs_ioc_space(
>  	error = xfs_update_prealloc_flags(ip, flags);
>  
>  out_unlock:
> -	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +	xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
>  	mnt_drop_write_file(filp);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 8be5bb5..0362b65 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -769,6 +769,7 @@ xfs_setattr_size(
>  		return error;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
>  	ASSERT(S_ISREG(ip->i_d.di_mode));
>  	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
>  		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
> @@ -984,9 +985,9 @@ xfs_vn_setattr(
>  	int			error;
>  
>  	if (iattr->ia_valid & ATTR_SIZE) {
> -		xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +		xfs_ilock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
>  		error = xfs_setattr_size(ip, iattr);
> -		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +		xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
>  	} else {
>  		error = xfs_setattr_nonsize(ip, iattr, 0);
>  	}
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
