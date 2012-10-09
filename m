Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99Kxvwx104289 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 15:59:57 -0500
Date: Tue, 9 Oct 2012 16:01:24 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 06/14] xfs: xfs_sync_data is redundant.
Message-ID: <20121009210124.GT13214@sgi.com>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
	<1349693772-8064-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349693772-8064-7-git-send-email-david@fromorbit.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hi Brain,

Given that you found the regression in the output of xfstest 273, could you do
us a favor and review the fix and provide your Reviewed-by, and/or Tested-by?

Thanks much,
Ben


On Mon, Oct 08, 2012 at 09:56:04PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We don't do any data writeback from XFS any more - the VFS is
> completely responsible for that, including for freeze. We can
> replace the remaining caller with a VFS level function that
> achieves the same thing, but without conflicting with current
> writeback work.
> 
> This means we can remove the flush_work and xfs_flush_inodes() - the
> VFS functionality completely replaces the internal flush queue for
> doing this writeback work in a separate context to avoid stack
> overruns.
> 
> This does have one complication - it cannot be called with page
> locks held.  Hence move the flushing of delalloc space when ENOSPC
> occurs back up into xfs_file_aio_buffered_write when we don't hold
> any locks that will stall writeback.
> 
> Unfortunately, writeback_inodes_sb_if_idle() is not sufficient to
> trigger delalloc conversion fast enough to prevent spurious ENOSPC
> whent here are hundreds of writers, thousands of small files and GBs
> of free RAM.  Hence we need to use sync_sb_inodes() to block callers
> while we wait for writeback like the previous xfs_flush_inodes
> implementation did.
> 
> That means we have to hold the s_umount lock here, but because this
> call can nest inside i_mutex (the parent directory in the create
> case, held by the VFS), we have to use down_read_trylock() to avoid
> potential deadlocks. In practice, this trylock will succeed on
> almost every attempt as unmount/remount type operations are
> exceedingly rare.
> 
> Note: we always need to pass a count of zero to
> generic_file_buffered_write() as the previously written byte count.
> We only do this by accident before this patch by the virtue of ret
> always being zero when there are no errors. Make this explicit
> rather than needing to specifically zero ret in the ENOSPC retry
> case.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c     |   13 +++++----
>  fs/xfs/xfs_iomap.c    |   23 +++++----------
>  fs/xfs/xfs_mount.h    |    1 -
>  fs/xfs/xfs_super.c    |   21 +++++++++++--
>  fs/xfs/xfs_super.h    |    1 +
>  fs/xfs/xfs_sync.c     |   78 -------------------------------------------------
>  fs/xfs/xfs_sync.h     |    3 --
>  fs/xfs/xfs_vnodeops.c |    2 +-
>  8 files changed, 34 insertions(+), 108 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1eaeb8b..5902cd6 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -728,16 +728,17 @@ xfs_file_buffered_aio_write(
>  write_retry:
>  	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
>  	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
> -			pos, &iocb->ki_pos, count, ret);
> +			pos, &iocb->ki_pos, count, 0);
> +
>  	/*
> -	 * if we just got an ENOSPC, flush the inode now we aren't holding any
> -	 * page locks and retry *once*
> +	 * If we just got an ENOSPC, try to write back all dirty inodes to
> +	 * convert delalloc space to free up some of the excess reserved
> +	 * metadata space.
>  	 */
>  	if (ret == -ENOSPC && !enospc) {
>  		enospc = 1;
> -		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
> -		if (!ret)
> -			goto write_retry;
> +		xfs_flush_inodes(ip->i_mount);
> +		goto write_retry;
>  	}
>  
>  	current->backing_dev_info = NULL;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 973dff6..f858b90 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -373,7 +373,7 @@ xfs_iomap_write_delay(
>  	xfs_extlen_t	extsz;
>  	int		nimaps;
>  	xfs_bmbt_irec_t imap[XFS_WRITE_IMAPS];
> -	int		prealloc, flushed = 0;
> +	int		prealloc;
>  	int		error;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> @@ -434,26 +434,17 @@ retry:
>  	}
>  
>  	/*
> -	 * If bmapi returned us nothing, we got either ENOSPC or EDQUOT.  For
> -	 * ENOSPC, * flush all other inodes with delalloc blocks to free up
> -	 * some of the excess reserved metadata space. For both cases, retry
> +	 * If bmapi returned us nothing, we got either ENOSPC or EDQUOT. Retry
>  	 * without EOF preallocation.
>  	 */
>  	if (nimaps == 0) {
>  		trace_xfs_delalloc_enospc(ip, offset, count);
> -		if (flushed)
> -			return XFS_ERROR(error ? error : ENOSPC);
> -
> -		if (error == ENOSPC) {
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -			xfs_flush_inodes(ip);
> -			xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		if (prealloc) {
> +			prealloc = 0;
> +			error = 0;
> +			goto retry;
>  		}
> -
> -		flushed = 1;
> -		error = 0;
> -		prealloc = 0;
> -		goto retry;
> +		return XFS_ERROR(error ? error : ENOSPC);
>  	}
>  
>  	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 26e46ae..a54b5aa 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -198,7 +198,6 @@ typedef struct xfs_mount {
>  #endif
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> -	struct work_struct	m_flush_work;	/* background inode flush */
>  	__int64_t		m_update_flags;	/* sb flags we need to update
>  						   on the next remount,rw */
>  	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 69093e9..89e3bc1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -882,6 +882,24 @@ xfs_destroy_mount_workqueues(
>  	destroy_workqueue(mp->m_unwritten_workqueue);
>  }
>  
> +/*
> + * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
> + * or a page lock. We use sync_inodes_sb() here to ensure we block while waiting
> + * for IO to complete so that we effectively throttle multiple callers to the
> + * rate at which IO is completing.
> + */
> +void
> +xfs_flush_inodes(
> +	struct xfs_mount	*mp)
> +{
> +	struct super_block	*sb = mp->m_super;
> +
> +	if (down_read_trylock(&sb->s_umount)) {
> +		sync_inodes_sb(sb);
> +		up_read(&sb->s_umount);
> +	}
> +}
> +
>  /* Catch misguided souls that try to use this interface on XFS */
>  STATIC struct inode *
>  xfs_fs_alloc_inode(
> @@ -1005,8 +1023,6 @@ xfs_fs_put_super(
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
>  
> -	cancel_work_sync(&mp->m_flush_work);
> -
>  	xfs_filestream_unmount(mp);
>  	xfs_unmountfs(mp);
>  
> @@ -1324,7 +1340,6 @@ xfs_fs_fill_super(
>  	spin_lock_init(&mp->m_sb_lock);
>  	mutex_init(&mp->m_growlock);
>  	atomic_set(&mp->m_active_trans, 0);
> -	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
>  	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
>  
>  	mp->m_super = sb;
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 9de4a92..bbe3d15 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -74,6 +74,7 @@ struct block_device;
>  
>  extern __uint64_t xfs_max_file_offset(unsigned int);
>  
> +extern void xfs_flush_inodes(struct xfs_mount *mp);
>  extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
>  extern xfs_agnumber_t xfs_set_inode32(struct xfs_mount *);
>  extern xfs_agnumber_t xfs_set_inode64(struct xfs_mount *);
> diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
> index 7527610..6a2ada3 100644
> --- a/fs/xfs/xfs_sync.c
> +++ b/fs/xfs/xfs_sync.c
> @@ -217,51 +217,6 @@ xfs_inode_ag_iterator(
>  }
>  
>  STATIC int
> -xfs_sync_inode_data(
> -	struct xfs_inode	*ip,
> -	struct xfs_perag	*pag,
> -	int			flags)
> -{
> -	struct inode		*inode = VFS_I(ip);
> -	struct address_space *mapping = inode->i_mapping;
> -	int			error = 0;
> -
> -	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
> -		return 0;
> -
> -	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
> -		if (flags & SYNC_TRYLOCK)
> -			return 0;
> -		xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -	}
> -
> -	error = xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
> -				0 : XBF_ASYNC, FI_NONE);
> -	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> -	return error;
> -}
> -
> -/*
> - * Write out pagecache data for the whole filesystem.
> - */
> -STATIC int
> -xfs_sync_data(
> -	struct xfs_mount	*mp,
> -	int			flags)
> -{
> -	int			error;
> -
> -	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
> -
> -	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags);
> -	if (error)
> -		return XFS_ERROR(error);
> -
> -	xfs_log_force(mp, (flags & SYNC_WAIT) ? XFS_LOG_SYNC : 0);
> -	return 0;
> -}
> -
> -STATIC int
>  xfs_sync_fsdata(
>  	struct xfs_mount	*mp)
>  {
> @@ -415,39 +370,6 @@ xfs_reclaim_worker(
>  	xfs_syncd_queue_reclaim(mp);
>  }
>  
> -/*
> - * Flush delayed allocate data, attempting to free up reserved space
> - * from existing allocations.  At this point a new allocation attempt
> - * has failed with ENOSPC and we are in the process of scratching our
> - * heads, looking about for more room.
> - *
> - * Queue a new data flush if there isn't one already in progress and
> - * wait for completion of the flush. This means that we only ever have one
> - * inode flush in progress no matter how many ENOSPC events are occurring and
> - * so will prevent the system from bogging down due to every concurrent
> - * ENOSPC event scanning all the active inodes in the system for writeback.
> - */
> -void
> -xfs_flush_inodes(
> -	struct xfs_inode	*ip)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -
> -	queue_work(xfs_syncd_wq, &mp->m_flush_work);
> -	flush_work_sync(&mp->m_flush_work);
> -}
> -
> -void
> -xfs_flush_worker(
> -	struct work_struct *work)
> -{
> -	struct xfs_mount *mp = container_of(work,
> -					struct xfs_mount, m_flush_work);
> -
> -	xfs_sync_data(mp, SYNC_TRYLOCK);
> -	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
> -}
> -
>  void
>  __xfs_inode_set_reclaim_tag(
>  	struct xfs_perag	*pag,
> diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
> index 8d58fab..0018e84 100644
> --- a/fs/xfs/xfs_sync.h
> +++ b/fs/xfs/xfs_sync.h
> @@ -26,14 +26,11 @@ struct xfs_perag;
>  
>  extern struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
>  
> -void xfs_flush_worker(struct work_struct *work);
>  void xfs_reclaim_worker(struct work_struct *work);
>  
>  int xfs_quiesce_data(struct xfs_mount *mp);
>  void xfs_quiesce_attr(struct xfs_mount *mp);
>  
> -void xfs_flush_inodes(struct xfs_inode *ip);
> -
>  int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
>  int xfs_reclaim_inodes_count(struct xfs_mount *mp);
>  void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 2a5c6373..1492856 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -777,7 +777,7 @@ xfs_create(
>  			XFS_TRANS_PERM_LOG_RES, log_count);
>  	if (error == ENOSPC) {
>  		/* flush outstanding delalloc blocks and retry */
> -		xfs_flush_inodes(dp);
> +		xfs_flush_inodes(mp);
>  		error = xfs_trans_reserve(tp, resblks, log_res, 0,
>  				XFS_TRANS_PERM_LOG_RES, log_count);
>  	}
> -- 
> 1.7.10
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
