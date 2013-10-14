Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 97EDD7F54
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 23:50:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1873FAC001
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 21:50:12 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	12UYA2vxuX2ySZnc for <xfs@oss.sgi.com>;
	Sun, 13 Oct 2013 21:50:10 -0700 (PDT)
Date: Mon, 14 Oct 2013 15:50:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: always take the iolock around xfs_setattr_size
Message-ID: <20131014045007.GF4446@dastard>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075639.940898263@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131012075639.940898263@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Oct 12, 2013 at 12:55:04AM -0700, Christoph Hellwig wrote:
> There is no reason to conditionally take the iolock inside xfs_setattr_size
> when we can let the caller handle it unconditionally, which just incrases
> the lock hold time for the case where it was previously taken internally
> by a few instructions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_bmap_util.c |    3 +--
>  fs/xfs/xfs_file.c      |    2 +-
>  fs/xfs/xfs_iops.c      |   29 ++++++++++++++++-------------
>  fs/xfs/xfs_iops.h      |    2 +-
>  4 files changed, 19 insertions(+), 17 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_file.c	2013-10-01 21:20:47.564230097 +0200
> +++ xfs/fs/xfs/xfs_file.c	2013-10-01 21:20:54.312230257 +0200
> @@ -852,7 +852,7 @@ xfs_file_fallocate(
>  
>  		iattr.ia_valid = ATTR_SIZE;
>  		iattr.ia_size = new_size;
> -		error = -xfs_setattr_size(ip, &iattr, XFS_ATTR_NOLOCK);
> +		error = -xfs_setattr_size(ip, &iattr);
>  	}
>  
>  out_unlock:
> Index: xfs/fs/xfs/xfs_iops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iops.c	2013-10-01 21:20:47.564230097 +0200
> +++ xfs/fs/xfs/xfs_iops.c	2013-10-01 21:20:54.316230257 +0200
> @@ -709,8 +709,7 @@ out_dqrele:
>  int
>  xfs_setattr_size(
>  	struct xfs_inode	*ip,
> -	struct iattr		*iattr,
> -	int			flags)
> +	struct iattr		*iattr)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
> @@ -733,15 +732,11 @@ xfs_setattr_size(
>  	if (error)
>  		return XFS_ERROR(error);
>  
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
>  	ASSERT(S_ISREG(ip->i_d.di_mode));
>  	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
>  			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
>  
> -	if (!(flags & XFS_ATTR_NOLOCK)) {
> -		lock_flags |= XFS_IOLOCK_EXCL;
> -		xfs_ilock(ip, lock_flags);
> -	}
> -

I think there should be a bit more cleanup of this lock_flags
variable. There's quite a few error paths that now "goto out_unlock"
without actually holding a lock. i.e. they could just become a
straight "return error", and lock_flags can probably go away
completely...

Otherwise it look s good to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
