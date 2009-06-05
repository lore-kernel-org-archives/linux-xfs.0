Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55KWInk063333 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 15:32:18 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA7601227B5E
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 13:32:36 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id Z1ZTd7VYhUSWZ6YQ for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2009 13:32:36 -0700 (PDT)
Message-ID: <4A2980D9.9050901@sandeen.net>
Date: Fri, 05 Jun 2009 15:32:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 7/7] xfs: split xfs_sync_inodes
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171559.231368000@bombadil.infradead.org>
In-Reply-To: <20090514171559.231368000@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> xfs_sync_inodes is used to write back either file data or inode metadata.
> In generally we always do these separately, except for one fishy case in
  ^^^ "In general"

> xfs_fs_put_super that does both.  So separate xfs_sync_inodes into
> separate xfs_sync_data and xfs_sync_attr functions.  In xfs_fs_put_super
> we first call the data sync and then the attr sync as that was the previous
> order.  The moved log force in that path doesn't make a different because
> we will force the log again as part of the real unmount process.
> 
> The filesystem readonly checks are not performed by the new function but
> instead moved into the callers, given that most callers alredy have it
> further up in the stack.  Also add debug checks that we do not pass in
> incorrect flags in the new xfs_sync_data and xfs_sync_attr function and
> fix the one place that did pass in a wrong flag.
> 
> Also remove a comment mentioning xfs_sync_inodes that has been incorrect
> for a while because we always take either the iolock or ilock in the
> sync path these days.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-05-14 19:09:00.178792110 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-05-14 19:09:05.278808755 +0200
> @@ -1070,7 +1070,18 @@ xfs_fs_put_super(
>  	int			unmount_event_flags = 0;
>  
>  	xfs_syncd_stop(mp);
> -	xfs_sync_inodes(mp, SYNC_ATTR|SYNC_DELWRI);
> +
> +	if (!(sb->s_flags & MS_RDONLY)) {
> +		/*
> +		 * XXX(hch): this should be SYNC_WAIT.
> +		 *
> +		 * Or more likely no needed at all because the VFS is already
> +		 * calling ->sync_fs after shutting down all filestem
> +		 * operations and just before calling ->put_super.
> +		 */
> +		xfs_sync_data(mp, 0);
> +		xfs_sync_attr(mp, 0);
> +	}
>  
>  #ifdef HAVE_DMAPI
>  	if (mp->m_flags & XFS_MOUNT_DMAPI) {
> Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 19:09:04.687659175 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 19:09:05.279808603 +0200
> @@ -265,29 +265,40 @@ xfs_sync_inode_attr(
>  	return error;
>  }
>  
> +/*
> + * Write out pagecache data for the whole filesystem.
> + */
>  int
> -xfs_sync_inodes(
> -	xfs_mount_t	*mp,
> -	int		flags)
> +xfs_sync_data(
> +	struct xfs_mount	*mp,
> +	int			flags)
>  {
> -	int		error = 0;
> -	int		lflags = XFS_LOG_FORCE;
> +	int			error;
>  
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> -		return 0;
> +	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT|SYNC_IOWAIT)) == 0);
>  
> -	if (flags & SYNC_WAIT)
> -		lflags |= XFS_LOG_SYNC;
> +	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags, -1);
> +	if (error)
> +		return XFS_ERROR(error);
>  
> -	if (flags & SYNC_DELWRI)
> -		error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags, -1);
> +	xfs_log_force(mp, 0,
> +		      (flags & SYNC_WAIT) ?
> +		       XFS_LOG_FORCE | XFS_LOG_SYNC :
> +		       XFS_LOG_FORCE);
> +	return 0;
> +}
>  
> -	if (flags & SYNC_ATTR)
> -		error = xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags, -1);
> +/*
> + * Write out inode metadata (attributes) for the whole filesystem.
> + */
> +int
> +xfs_sync_attr(
> +	struct xfs_mount	*mp,
> +	int			flags)
> +{
> +	ASSERT((flags & ~SYNC_WAIT) == 0);
>  
> -	if (!error && (flags & SYNC_DELWRI))
> -		xfs_log_force(mp, 0, lflags);
> -	return XFS_ERROR(error);
> +	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags, -1);
>  }
>  
>  STATIC int
> @@ -401,12 +412,12 @@ xfs_quiesce_data(
>  	int error;
>  
>  	/* push non-blocking */
> -	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_BDFLUSH);
> +	xfs_sync_data(mp, 0);
>  	xfs_qm_sync(mp, SYNC_BDFLUSH);
>  	xfs_filestream_flush(mp);
>  
>  	/* push and block */
> -	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
> +	xfs_sync_data(mp, SYNC_WAIT|SYNC_IOWAIT);
>  	xfs_qm_sync(mp, SYNC_WAIT);
>  
>  	/* write superblock and hoover up shutdown errors */
> @@ -435,7 +446,7 @@ xfs_quiesce_fs(
>  	 * logged before we can write the unmount record.
>  	 */
>  	do {
> -		xfs_sync_inodes(mp, SYNC_ATTR|SYNC_WAIT);
> +		xfs_sync_attr(mp, SYNC_WAIT);
>  		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
>  		if (!pincount) {
>  			delay(50);
> @@ -518,8 +529,8 @@ xfs_flush_inodes_work(
>  	void		*arg)
>  {
>  	struct inode	*inode = arg;
> -	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_TRYLOCK);
> -	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_TRYLOCK | SYNC_IOWAIT);
> +	xfs_sync_data(mp, SYNC_TRYLOCK);
> +	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_IOWAIT);
>  	iput(inode);
>  }
>  
> Index: xfs/fs/xfs/linux-2.6/xfs_quotaops.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_quotaops.c	2009-05-14 19:05:24.908659400 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_quotaops.c	2009-05-14 19:09:05.280834851 +0200
> @@ -50,9 +50,11 @@ xfs_fs_quota_sync(
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
>  
> +	if (sb->s_flags & MS_RDONLY)
> +		return -EROFS;
>  	if (!XFS_IS_QUOTA_RUNNING(mp))
>  		return -ENOSYS;
> -	return -xfs_sync_inodes(mp, SYNC_DELWRI);
> +	return -xfs_sync_data(mp, 0);
>  }
>  
>  STATIC int
> Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-05-14 19:09:04.694659368 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2009-05-14 19:09:05.280834851 +0200
> @@ -29,8 +29,6 @@ typedef struct xfs_sync_work {
>  	struct completion	*w_completion;
>  } xfs_sync_work_t;
>  
> -#define SYNC_ATTR		0x0001	/* sync attributes */
> -#define SYNC_DELWRI		0x0002	/* look at delayed writes */
>  #define SYNC_WAIT		0x0004	/* wait for i/o to complete */
>  #define SYNC_BDFLUSH		0x0008	/* BDFLUSH is calling -- don't block */
>  #define SYNC_IOWAIT		0x0010  /* wait for all I/O to complete */
> @@ -41,7 +39,8 @@ void xfs_syncd_stop(struct xfs_mount *mp
>  
>  int xfs_inode_flush(struct xfs_inode *ip, int sync);
>  
> -int xfs_sync_inodes(struct xfs_mount *mp, int flags);
> +int xfs_sync_attr(struct xfs_mount *mp, int flags);
> +int xfs_sync_data(struct xfs_mount *mp, int flags);
>  int xfs_sync_fsdata(struct xfs_mount *mp, int flags);
>  
>  int xfs_quiesce_data(struct xfs_mount *mp);
> Index: xfs/fs/xfs/xfs_filestream.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_filestream.c	2009-05-14 19:05:24.929659282 +0200
> +++ xfs/fs/xfs/xfs_filestream.c	2009-05-14 19:09:05.283807995 +0200
> @@ -542,10 +542,8 @@ xfs_filestream_associate(
>  	 * waiting for the lock because someone else is waiting on the lock we
>  	 * hold and we cannot drop that as we are in a transaction here.
>  	 *
> -	 * Lucky for us, this inversion is rarely a problem because it's a
> -	 * directory inode that we are trying to lock here and that means the
> -	 * only place that matters is xfs_sync_inodes() and SYNC_DELWRI is
> -	 * used. i.e. freeze, remount-ro, quotasync or unmount.
> +	 * Lucky for us, this inversion is not a problem because it's a
> +	 * directory inode that we are trying to lock here.
>  	 *
>  	 * So, if we can't get the iolock without sleeping then just give up
>  	 */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
