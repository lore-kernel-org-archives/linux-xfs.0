Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70CD97F3F
	for <xfs@oss.sgi.com>; Fri,  3 Jan 2014 14:53:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55764304067
	for <xfs@oss.sgi.com>; Fri,  3 Jan 2014 12:53:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6N7jqC7irCJbs5tv for
	<xfs@oss.sgi.com>; Fri, 03 Jan 2014 12:53:02 -0800 (PST)
Message-ID: <52C7232B.3050807@redhat.com>
Date: Fri, 03 Jan 2014 15:52:59 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/10] xfs: xfs_bulkstat_single consolidation
References: <52BEB3E7.2080706@oracle.com>
In-Reply-To: <52BEB3E7.2080706@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/28/2013 06:20 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> In xfs_bulkstat_single(), xfs_bulkstat_one() and xfs_bulkstat() might
> return different error if either call failed, we'd better return the
> proper error in this case.  Moreover, the function argument done is
> useless in terms of xfs_ioc_bulkstat(), hence we can get rid of it.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c  |  3 +--
>  fs/xfs/xfs_itable.c | 59 ++++++++++++++++++++++++++---------------------------
>  fs/xfs/xfs_itable.h |  3 +--
>  3 files changed, 31 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 33ad9a7..2fdd750 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -828,8 +828,7 @@ xfs_ioc_bulkstat(
>  		error = xfs_inumbers(mp, &inlast, &count,
>  					bulkreq.ubuffer, xfs_inumbers_fmt);
>  	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
> -		error = xfs_bulkstat_single(mp, &inlast,
> -						bulkreq.ubuffer, &done);
> +		error = xfs_bulkstat_single(mp, &inlast, bulkreq.ubuffer);
>  	else	/* XFS_IOC_FSBULKSTAT */
>  		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
>  				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index b5bb7b6..692671c 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -509,51 +509,50 @@ xfs_bulkstat(
>  }
>  
>  /*
> - * Return stat information in bulk (by-inode) for the filesystem.
> - * Special case for non-sequential one inode bulkstat.
> + * Return stat information in bulk (by-inode) for the filesystem.  Special case
> + * for non-sequential one inode bulkstat.
>   */
> -int					/* error status */
> +int
>  xfs_bulkstat_single(
> -	xfs_mount_t		*mp,	/* mount point for filesystem */
> +	struct xfs_mount	*mp,	/* mount point for filesystem */
>  	xfs_ino_t		*lastinop, /* inode to return */
> -	char			__user *buffer, /* buffer with inode stats */
> -	int			*done)	/* 1 if there are more stats to get */
> +	char			__user *buffer) /* buffer with inode stats */
>  {
> -	int			count;	/* count value for bulkstat call */
> -	int			error;	/* return value */
> -	xfs_ino_t		ino;	/* filesystem inode number */
> +	xfs_ino_t		ino = *lastinop;
>  	int			res;	/* result from bs1 */
> +	int			error;
>  
>  	/*
> -	 * note that requesting valid inode numbers which are not allocated
> +	 * Note that requesting valid inode numbers which are not allocated
>  	 * to inodes will most likely cause xfs_imap_to_bp to generate warning
> -	 * messages about bad magic numbers. This is ok. The fact that
> -	 * the inode isn't actually an inode is handled by the
> -	 * error check below. Done this way to make the usual case faster
> -	 * at the expense of the error case.
> +	 * messages about bad magic numbers. This is ok. The fact that the
> +	 * inode isn't actually an inode is handled by the error check below.
> +	 * Done this way to make the usual case faster at the expense of the
> +	 * error case.
>  	 */
> -
> -	ino = *lastinop;
> -	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t),
> +	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(struct xfs_bstat),
>  				 NULL, &res);
>  	if (error) {
> +		int		count = 1;
> +		int		done, error2;
> +
>  		/*
> -		 * Special case way failed, do it the "long" way
> -		 * to see if that works.
> +		 * Special case way failed, do it the "long" way to see if
> +		 * that works.
>  		 */
>  		(*lastinop)--;
> -		count = 1;
> -		if (xfs_bulkstat(mp, lastinop, &count, xfs_bulkstat_one,
> -				sizeof(xfs_bstat_t), buffer, done))
> -			return error;
> -		if (count == 0 || (xfs_ino_t)*lastinop != ino)
> -			return error == EFSCORRUPTED ?
> -				XFS_ERROR(EINVAL) : error;
> -		else
> -			return 0;
> +		error2 = xfs_bulkstat(mp, lastinop, &count, xfs_bulkstat_one,
> +				      sizeof(struct xfs_bstat), buffer, &done);
> +		if (error2)
> +			return error2;
> +
> +		if (count == 0 || *lastinop != ino) {
> +			if (error == EFSCORRUPTED)
> +				error = XFS_ERROR(EINVAL);
> +		}
>  	}
> -	*done = 0;
> -	return 0;
> +
> +	return error;

Here it looks like you return an error value if the initial
xfs_bulkstat_one() fails and the fallback xfs_bulkstat() succeeds.

Brian

>  }
>  
>  int
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 97295d9..60ce988 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -54,8 +54,7 @@ int
>  xfs_bulkstat_single(
>  	xfs_mount_t		*mp,
>  	xfs_ino_t		*lastinop,
> -	char			__user *buffer,
> -	int			*done);
> +	char			__user *buffer);
>  
>  typedef int (*bulkstat_one_fmt_pf)(  /* used size in bytes or negative error */
>  	void			__user *ubuffer, /* buffer to write to */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
