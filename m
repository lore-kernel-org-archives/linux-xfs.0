Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 13:03:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l15L2q3c031153
	for <xfs@oss.sgi.com>; Mon, 5 Feb 2007 13:02:55 -0800
Date: Tue, 6 Feb 2007 08:02:45 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: freezing sometimes leaves the log dirty
Message-ID: <20070205210245.GP44411608@melbourne.sgi.com>
References: <20070130220326.GM33919298@melbourne.sgi.com> <20070202114623.GA23187@infradead.org> <20070202140706.GX33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202140706.GX33919298@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Sat, Feb 03, 2007 at 01:07:06AM +1100, David Chinner wrote:
> Patch below cleans all this up and also fixes the 2.4 tree as well.

Can I get an ack from someone on this?

> BTW, i think further cleanup in xfs_quiesce_fs() can be done - that
> flush loop looks redundant - neither Irix nor 2.4 linux need it,
> and I can't see why it would be needed on 2.6. It looks to me like
> it was trying to fix the problem I'm fixing right now. I'll look
> into it further at some point...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> ---
>  fs/xfs/linux-2.4/xfs_super.c |    8 +++-----
>  fs/xfs/linux-2.4/xfs_vfs.h   |    2 +-
>  fs/xfs/linux-2.6/xfs_super.c |    2 +-
>  fs/xfs/linux-2.6/xfs_vfs.h   |    3 +--
>  fs/xfs/xfs_vfsops.c          |   17 +++++++++--------
>  5 files changed, 15 insertions(+), 17 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_super.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.4/xfs_super.c	2007-02-02 16:35:36.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_super.c	2007-02-03 00:59:00.453115972 +1100
> @@ -669,13 +669,11 @@ struct super_block *freeze_bdev(struct b
>  		wmb();
>  
>  		/* Flush the refcache */
> -		bhv_vfs_sync(vfsp, SYNC_REFCACHE | SYNC_WAIT, NULL);;
> +		bhv_vfs_sync(vfsp, SYNC_REFCACHE | SYNC_WAIT, NULL);
>  
>  		/* Flush delalloc and delwri data */
> -		bhv_vfs_sync(vfsp, SYNC_DELWRI | SYNC_WAIT, NULL);;
> -
> -		/* Flush out everything to it's normal place */
> -		bhv_vfs_sync(vfsp, SYNC_QUIESCE, NULL);
> +		bhv_vfs_sync(vfsp,
> +			SYNC_FSDATA|SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT, NULL);
>  
>  		/* Pause transaction subsystem */
>  		vfsp->vfs_frozen = SB_FREEZE_TRANS;
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_vfs.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.4/xfs_vfs.h	2007-01-16 10:54:15.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_vfs.h	2007-02-03 00:51:38.255434540 +1100
> @@ -92,7 +92,7 @@ typedef enum {
>  #define SYNC_FSDATA		0x0020	/* flush fs data (e.g. superblocks) */
>  #define SYNC_REFCACHE		0x0040  /* prune some of the nfs ref cache */
>  #define SYNC_REMOUNT		0x0080  /* remount readonly, no dummy LRs */
> -#define SYNC_QUIESCE		0x0100  /* quiesce fileystem for a snapshot */
> +#define SYNC_IOWAIT		0x0100  /* wait for all I/O to complete */
>  
>  #define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
>  #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-02-02 16:35:36.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-02-03 00:59:03.236749054 +1100
> @@ -674,7 +674,7 @@ xfs_fs_sync_super(
>  		 * occur here so don't bother flushing the buftarg (i.e
>  		 * SYNC_QUIESCE) because it'll just get dirty again.
>  		 */
> -		flags = SYNC_FSDATA | SYNC_DELWRI | SYNC_WAIT | SYNC_DIO_WAIT;
> +		flags = SYNC_FSDATA | SYNC_DELWRI | SYNC_WAIT | SYNC_IOWAIT;
>  	} else
>  		flags = SYNC_FSDATA | (wait ? SYNC_WAIT : 0);
>  
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-02-02 16:35:02.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h	2007-02-03 00:51:41.638988060 +1100
> @@ -91,8 +91,7 @@ typedef enum {
>  #define SYNC_FSDATA		0x0020	/* flush fs data (e.g. superblocks) */
>  #define SYNC_REFCACHE		0x0040  /* prune some of the nfs ref cache */
>  #define SYNC_REMOUNT		0x0080  /* remount readonly, no dummy LRs */
> -#define SYNC_QUIESCE		0x0100  /* quiesce fileystem for a snapshot */
> -#define SYNC_DIO_WAIT		0x0200  /* wait for direct I/O to complete */
> +#define SYNC_IOWAIT		0x0100  /* wait for all I/O to complete */
>  
>  #define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
>  #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
> Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-02-02 16:35:36.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-02-03 00:49:10.946876638 +1100
> @@ -881,10 +881,10 @@ xfs_statvfs(
>   *		       this by simply making sure the log gets flushed
>   *		       if SYNC_BDFLUSH is set, and by actually writing it
>   *		       out otherwise.
> - *	SYNC_DIO_WAIT - The caller wants us to wait for all direct I/Os
> - *		       as well to ensure all data I/O completes before we
> - *		       return. Forms the drain side of the write barrier needed
> - *		       to safely quiesce the filesystem.
> + *	SYNC_IOWAIT  - The caller wants us to wait for all data I/O to complete
> + *		       before we return (including direct I/O). Forms the drain
> + *		       side of the write barrier needed to safely quiesce the
> + *		       filesystem.
>   *
>   */
>  /*ARGSUSED*/
> @@ -1183,10 +1183,11 @@ xfs_sync_inodes(
>  
>  		}
>  		/*
> -		 * When freezing, we need to wait ensure direct I/O is complete
> -		 * as well to ensure all data modification is complete here
> +		 * When freezing, we need to wait ensure all I/O (including direct
> +		 * I/O) is complete to ensure no further data modification can take
> +		 * place after this point
>  		 */
> -		if (flags & SYNC_DIO_WAIT)
> +		if (flags & SYNC_IOWAIT)
>  			vn_iowait(vp);
>  
>  		if (flags & SYNC_BDFLUSH) {
> @@ -1984,7 +1985,7 @@ xfs_freeze(
>  	/* flush inodes and push all remaining buffers out to disk */
>  	xfs_quiesce_fs(mp);
>  
> -	BUG_ON(atomic_read(&mp->m_active_trans) > 0);
> +	ASSERT(atomic_read(&mp->m_active_trans) == 0);
>  
>  	/* Push the superblock and write an unmount record */
>  	xfs_log_unmount_write(mp);

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
