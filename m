Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E7597F8B
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:36:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE3878F8039
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:36:29 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yn8ZcKlSpyZlMEdM for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:36:20 -0800 (PST)
Date: Mon, 9 Dec 2013 09:36:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] xfs: add xfs_ilock_attr_map_shared
Message-ID: <20131208223610.GE31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.663030833@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203128.663030833@bombadil.infradead.org>
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

On Fri, Dec 06, 2013 at 12:30:10PM -0800, Christoph Hellwig wrote:
> Equivalent to xfs_ilock_data_map_shared, except for the attribute fork.
> 
> Make xfs_getbmap use it if called for the attribute fork instead of
> xfs_ilock_data_map_shared.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap_util.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-12-06 19:58:15.759137296 +0100
> +++ xfs/fs/xfs/xfs_bmap_util.c	2013-12-06 20:02:23.291132216 +0100
> @@ -617,22 +617,27 @@ xfs_getbmap(
>  		return XFS_ERROR(ENOMEM);
>  
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
> -		if (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size) {
> +	if (whichfork == XFS_DATA_FORK) {
> +		if (!(iflags & BMV_IF_DELALLOC) &&
> +		    (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size)) {
>  			error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
>  			if (error)
>  				goto out_unlock_iolock;
> +
> +			/*
> +			 * Even after flushing the inode, there can still be
> +			 * delalloc blocks on the inode beyond EOF due to
> +			 * speculative reallocation.  These are not removed

"speculative preallocation"

> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2013-12-06 19:58:41.667136764 +0100
> +++ xfs/fs/xfs/xfs_inode.c	2013-12-06 20:00:44.535134243 +0100
> @@ -77,17 +77,18 @@ xfs_get_extsz_hint(
>  }
>  
>  /*
> - * This is a wrapper routine around the xfs_ilock() routine used to centralize
> - * some grungy code.  It is used in places that wish to lock the inode solely
> - * for reading the extents.  The reason these places can't just call
> - * xfs_ilock(SHARED) is that the inode lock also guards to bringing in of the
> - * extents from disk for a file in b-tree format.  If the inode is in b-tree
> - * format, then we need to lock the inode exclusively until the extents are read
> - * in.  Locking it exclusively all the time would limit our parallelism
> - * unnecessarily, though.  What we do instead is check to see if the extents
> - * have been read in yet, and only lock the inode exclusively if they have not.
> + * These two are wrapper routines around the xfs_ilock() routine used to
> + * centralize some grungy code.  They are used in places that wish to lock the
> + * inode solely for reading the extents.  The reason these places can't just
> + * call xfs_ilock(ip, XFS_ILOCK_SHARED) is that the inode lock also guards to
> + * bringing in of the extents from disk for a file in b-tree format.  If the
> + * inode is in b-tree format, then we need to lock the inode exclusively until
> + * the extents are read in.  Locking it exclusively all the time would limit
> + * our parallelism unnecessarily, though.  What we do instead is check to see
> + * if the extents have been read in yet, and only lock the inode exclusively
> + * if they have not.
>   *
> - * The function returns a value which should be given to the corresponding
> + * The functions return a value which should be given to the corresponding
>   * xfs_iunlock() call.
>   */
>  uint
> @@ -101,6 +102,19 @@ xfs_ilock_data_map_shared(
>  		lock_mode = XFS_ILOCK_EXCL;
>  	xfs_ilock(ip, lock_mode);
>  	return lock_mode;
> +}
> +
> +uint
> +xfs_ilock_attr_map_shared(
> +	struct xfs_inode	*ip)
> +{
> +	uint			lock_mode = XFS_ILOCK_SHARED;
> +
> +	if (ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE &&
> +	    (ip->i_afp->if_flags & XFS_IFEXTENTS) == 0)
> +		lock_mode = XFS_ILOCK_EXCL;
> +	xfs_ilock(ip, lock_mode);
> +	return lock_mode;
>  }

Again, I think a static inline is appropriate here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
