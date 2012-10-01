Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91KBXvS181325 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 15:11:33 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vUE7jBvWhKzUWUuW for
	<xfs@oss.sgi.com>; Mon, 01 Oct 2012 13:12:56 -0700 (PDT)
Message-ID: <5069F9B0.50804@redhat.com>
Date: Mon, 01 Oct 2012 16:14:40 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1348807485-20165-7-git-send-email-david@fromorbit.com>
Content-Type: multipart/mixed; boundary="------------070000030202020407060804"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070000030202020407060804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/28/2012 12:44 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We don't do any data writeback from XFS any more - the VFS is
> completely responsible for that, including for freeze. We can
> replace the remaining caller with the VFS level function that
> achieves the same thing, but without conflicting with current
> writeback work - writeback_inodes_sb_if_idle().
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
> Note that we always need to pass a count of zero to
> generic_file_buffered_write() as the previously written byte count.
> We only do this by accident before this patch by the virtue of ret
> always being zero when there are no errors. Make this explicit
> rather than needing to specifically zero ret in the ENOSPC retry
> case.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Heads up... I was doing some testing against my eofblocks set rebased
against this patchset and I'm reproducing a new 273 failure. The failure
bisects down to this patch.

With the bisection, I'm running xfs top of tree plus the following patch:

xfs: only update the last_sync_lsn when a transaction completes

... and patches 1-6 of this set on top of that. i.e.:

xfs: xfs_sync_data is redundant.
xfs: Bring some sanity to log unmounting
xfs: sync work is now only periodic log work
xfs: don't run the sync work if the filesystem is read-only
xfs: rationalise xfs_mount_wq users
xfs: xfs_syncd_stop must die
xfs: only update the last_sync_lsn when a transaction completes
xfs: Make inode32 a remountable option

This is on a 16p (according to /proc/cpuinfo) x86-64 system with 32GB
RAM. The test and scratch volumes are both 500GB lvm volumes on top of a
hardware raid. I haven't looked into this at all yet but I wanted to
drop it on the list for now. The 273 output is attached.

Brian

> ---
>  fs/xfs/xfs_file.c  |   13 +++++----
>  fs/xfs/xfs_inode.h |   10 +++++++
>  fs/xfs/xfs_iomap.c |   23 +++++-----------
>  fs/xfs/xfs_mount.h |    1 -
>  fs/xfs/xfs_super.c |    3 --
>  fs/xfs/xfs_sync.c  |   78 ----------------------------------------------------
>  fs/xfs/xfs_sync.h  |    3 --
>  7 files changed, 24 insertions(+), 107 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1eaeb8b..2cadcf7 100644
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
> +		xfs_flush_inodes(ip);
> +		goto write_retry;
>  	}
>  
>  	current->backing_dev_info = NULL;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 94b32f9..a12fe18 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -288,6 +288,16 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
>  }
>  
>  /*
> + * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
> + * or a page lock.
> + */
> +static inline void
> +xfs_flush_inodes(struct xfs_inode *ip)
> +{
> +	writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb, WB_REASON_FS_FREE_SPACE);
> +}
> +
> +/*
>   * i_flags helper functions
>   */
>  static inline void
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
> index b85ca2d..fed1eb2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -918,8 +918,6 @@ xfs_fs_put_super(
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
>  
> -	cancel_work_sync(&mp->m_flush_work);
> -
>  	xfs_filestream_unmount(mp);
>  	xfs_unmountfs(mp);
>  
> @@ -1231,7 +1229,6 @@ xfs_fs_fill_super(
>  	spin_lock_init(&mp->m_sb_lock);
>  	mutex_init(&mp->m_growlock);
>  	atomic_set(&mp->m_active_trans, 0);
> -	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
>  	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
>  
>  	mp->m_super = sb;
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
> 


--------------070000030202020407060804
Content-Type: text/plain; charset=UTF-8;
 name="273.out.bad"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="273.out.bad"

QA output created by 273
------------------------------
start the workload
------------------------------
_porter 31 not complete
_porter 79 not complete
_porter 149 not complete_porter 74 not complete
_porter 161 not complete
_porter 54 not complete
_porter 98 not complete
_porter 99 not complete
_porter 167 not complete
_porter 76 not complete
_porter 45 not complete
_porter 152 not complete
_porter 173 not complete_porter 24 not complete

_porter 6 not complete
_porter 104 not complete
_porter 117 not complete
_porter 181 not complete
_porter 30 not complete
_porter 148 not complete
_porter 147 not complete
_porter 77 not complete
_porter 111 not complete
_porter 56 not complete

_porter 49 not complete
_porter 165 not complete
_porter 97 not complete
_porter 158 not complete
_porter 157 not complete
_porter 179 not complete
_porter 191 not complete
_porter 57 not complete
_porter 123 not complete
_porter 160 not complete
_porter 100 not complete
_porter 9 not complete
_porter 95 not complete
_porter 10 not complete
_porter 53 not complete
_porter 73 not complete
_porter 27 not complete
_porter 4 not complete
_porter 5 not complete
_porter 39 not complete
_porter 43 not complete
_porter 13 not complete
_porter 48 not complete
_porter 35 not complete
_porter 70 not complete
_porter 29 not complete
_porter 7 not complete
_porter 71 not complete
_porter 93 not complete
_porter 78 not complete

_porter 135 not complete
_porter 174 not complete
_porter 80 not complete
_porter 102 not complete
_porter 183 not complete
_porter 185 not complete_porter 168 not complete
_porter 178 not complete
_porter 129 not complete
_porter 193 not complete
_porter 192 not complete
_porter 199 not complete
_porter 120 not complete
_porter 125 not complete
_porter 126 not complete
_porter 145 not complete
_porter 124 not complete
_porter 172 not complete

--------------070000030202020407060804
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------070000030202020407060804--
