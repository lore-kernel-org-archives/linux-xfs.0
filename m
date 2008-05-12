Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 May 2008 19:21:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4C2LAmC011232
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 19:21:13 -0700
Date: Mon, 12 May 2008 12:21:38 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/10] merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super
Message-ID: <20080512022138.GX155679365@sgi.com>
References: <20080501220048.GA2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501220048.GA2315@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, May 02, 2008 at 12:00:48AM +0200, Christoph Hellwig wrote:
> xfs_unmount is small and already pretty Linux specific, so merge it into
> the callers.  The real unmount path is simplified a little by doing a
> WARN_ON on the xfs_unmount_flush retval directly instead of propagating
> the error back to the caller, and the mout failure case in simplified
> significantly by removing the forced shudown case and all the dmapi
> events that shouldn't be sent because the dmapi mount event hasn't been
> sent by that time either.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-04-25 20:48:31.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-04-25 20:50:16.000000000 +0200
> @@ -1087,14 +1087,61 @@ xfs_fs_put_super(
>  	struct super_block	*sb)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> +	struct xfs_inode	*rip = mp->m_rootip;
> +	int			unmount_event_flags = 0;
>  	int			error;
>  
>  	kthread_stop(mp->m_sync_task);
>  
>  	xfs_sync(mp, SYNC_ATTR | SYNC_DELWRI);
> -	error = xfs_unmount(mp, 0, NULL);
> -	if (error)
> -		printk("XFS: unmount got error=%d\n", error);
> +
> +#ifdef HAVE_DMAPI
> +	if (mp->m_flags & XFS_MOUNT_DMAPI) {
> +		unmount_event_flags =
> +			(mp->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ?
> +				0 : DM_FLAGS_UNWANTED;
> +		/*
> +		 * Ignore error from dmapi here, first unmount is not allowed
> +		 * to fail anyway, and second we wouldn't want to fail a
> +		 * unmount because of dmapi.
> +		 */
> +		XFS_SEND_PREUNMOUNT(mp, rip, DM_RIGHT_NULL, rip, DM_RIGHT_NULL,
> +				NULL, NULL, 0, 0, unmount_event_flags);
> +	}
> +#endif
> +
> +	/*
> +	 * Blow away any referenced inode in the filestreams cache.
> +	 * This can and will cause log traffic as inodes go inactive
> +	 * here.
> +	 */
> +	xfs_filestream_unmount(mp);
> +
> +	XFS_bflush(mp->m_ddev_targp);
> +	error = xfs_unmount_flush(mp, 0);
> +	WARN_ON(error);
> +
> +	IRELE(rip);
> +
> +	/*
> +	 * If we're forcing a shutdown, typically because of a media error,
> +	 * we want to make sure we invalidate dirty pages that belong to
> +	 * referenced vnodes as well.
> +	 */
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		error = xfs_sync(mp, SYNC_WAIT | SYNC_CLOSE);
> +		ASSERT(error != EFSCORRUPTED);
> +	}
> +
> +	if (mp->m_flags & XFS_MOUNT_DMAPI) {
> +		XFS_SEND_UNMOUNT(mp, rip, DM_RIGHT_NULL, 0, 0,
> +				unmount_event_flags);
> +	}

#ifdef HAVE_DMAPI around this chunk? I know the old code didn't,
but it would then match the pre-unmount event hunk above...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
