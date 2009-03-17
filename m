Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2HDATDx158725 for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 08:10:50 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D07F1C4B68C
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 06:09:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id Da48w9MMAroKag11 for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2009 06:09:47 -0700 (PDT)
Date: Tue, 17 Mar 2009 09:08:36 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/5] [XFS] Use xfs_sync_inodes() for device flushing
In-Reply-To: <1237114679-18808-2-git-send-email-david@fromorbit.com>
Message-ID: <Pine.LNX.4.64.0903170857050.26754@hs20-bc2-1.build.redhat.com>
References: <1237114679-18808-1-git-send-email-david@fromorbit.com>
	<1237114679-18808-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, 15 Mar 2009, Dave Chinner wrote:

> From: Dave Chinner <dgc@evostor.com>
> 
> Currently xfs_device_flush calls sync_blockdev() which is
> a no-op for XFS as all it's metadata is held in a different
> address to the one sync_blockdev() works on.
> 
> Call xfs_sync_inodes() instead to flush all the delayed
> allocation blocks out. To do this as efficiently as possible,
> do it via two passes - one to do an async flush of all the
> dirty blocks and a second to wait for all the IO to complete.
> This requires some modification to the xfs-sync_inodes_ag()
> flush code to do efficiently.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/linux-2.6/xfs_fs_subr.c |   14 ++++++------
>  fs/xfs/linux-2.6/xfs_sync.c    |   43 +++++++++++++++++++++++----------------
>  fs/xfs/linux-2.6/xfs_sync.h    |    7 +++--
>  fs/xfs/xfs_iomap.c             |    2 +-
>  fs/xfs/xfs_mount.h             |    2 +-
>  5 files changed, 38 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
> index 5aeb777..08be36d 100644
> --- a/fs/xfs/linux-2.6/xfs_fs_subr.c
> +++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
> @@ -74,14 +74,14 @@ xfs_flush_pages(
>  
>  	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
>  		xfs_iflags_clear(ip, XFS_ITRUNCATED);
> -		ret = filemap_fdatawrite(mapping);
> -		if (flags & XFS_B_ASYNC)
> -			return -ret;
> -		ret2 = filemap_fdatawait(mapping);
> -		if (!ret)
> -			ret = ret2;
> +		ret = -filemap_fdatawrite(mapping);
>  	}
> -	return -ret;
> +	if (flags & XFS_B_ASYNC)
> +		return ret;
> +	ret2 = xfs_wait_on_pages(ip, first, last);
> +	if (!ret)
> +		ret = ret2;
> +	return ret;
>  }
>  
>  int
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index a608e72..88caafc 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -62,12 +62,6 @@ xfs_sync_inodes_ag(
>  	uint32_t	first_index = 0;
>  	int		error = 0;
>  	int		last_error = 0;
> -	int		fflag = XFS_B_ASYNC;
> -
> -	if (flags & SYNC_DELWRI)
> -		fflag = XFS_B_DELWRI;
> -	if (flags & SYNC_WAIT)
> -		fflag = 0;		/* synchronous overrides all */
>  
>  	do {
>  		struct inode	*inode;
> @@ -128,11 +122,23 @@ xfs_sync_inodes_ag(
>  		 * If we have to flush data or wait for I/O completion
>  		 * we need to hold the iolock.
>  		 */
> -		if ((flags & SYNC_DELWRI) && VN_DIRTY(inode)) {
> -			xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -			lock_flags |= XFS_IOLOCK_SHARED;
> -			error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
> -			if (flags & SYNC_IOWAIT)
> +		if (flags & SYNC_DELWRI) {
> +			if (VN_DIRTY(inode)) {
> +				if (flags & SYNC_TRYLOCK) {
> +					if (xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
> +						lock_flags |= XFS_IOLOCK_SHARED;
> +				} else {
> +					xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +					lock_flags |= XFS_IOLOCK_SHARED;
> +				}
> +				if (lock_flags & XFS_IOLOCK_SHARED) {
> +					error = xfs_flush_pages(ip, 0, -1,
> +							(flags & SYNC_WAIT) ? 0
> +								: XFS_B_ASYNC,
> +							FI_NONE);
> +				}
> +			}
> +			if (VN_CACHED(inode) && (flags & SYNC_IOWAIT))
>  				xfs_ioend_wait(ip);
>  		}
>  		xfs_ilock(ip, XFS_ILOCK_SHARED);
> @@ -400,9 +406,9 @@ xfs_syncd_queue_work(
>  	void		*data,
>  	void		(*syncer)(struct xfs_mount *, void *))
>  {
> -	struct bhv_vfs_sync_work *work;
> +	struct xfs_sync_work *work;
>  
> -	work = kmem_alloc(sizeof(struct bhv_vfs_sync_work), KM_SLEEP);
> +	work = kmem_alloc(sizeof(struct xfs_sync_work), KM_SLEEP);
>  	INIT_LIST_HEAD(&work->w_list);
>  	work->w_syncer = syncer;
>  	work->w_data = data;
> @@ -445,23 +451,24 @@ xfs_flush_inode(
>   * (IOW, "If at first you don't succeed, use a Bigger Hammer").
>   */
>  STATIC void
> -xfs_flush_device_work(
> +xfs_flush_inodes_work(
>  	struct xfs_mount *mp,
>  	void		*arg)
>  {
>  	struct inode	*inode = arg;
> -	sync_blockdev(mp->m_super->s_bdev);
> +	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_TRYLOCK);
> +	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_TRYLOCK | SYNC_IOWAIT);
>  	iput(inode);
>  }

I tested the code and it works fine.

But I'm not somehow convinced that that TRYLOCK is right ... that it will 
avoid that pagelock-deadlock that I found before.

What is the ordering of pagelock, ILOCK and IOLOCK? If you keep the 
ordering right, you don't need trylock. And if the ordering is wrong, 
trylock will only lower the probability of a deadlock, not avoid it 
completely.

Mikulas

>  void
> -xfs_flush_device(
> +xfs_flush_inodes(
>  	xfs_inode_t	*ip)
>  {
>  	struct inode	*inode = VFS_I(ip);
>  
>  	igrab(inode);
> -	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_device_work);
> +	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inodes_work);
>  	delay(msecs_to_jiffies(500));
>  	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
>  }
> @@ -497,7 +504,7 @@ xfssyncd(
>  {
>  	struct xfs_mount	*mp = arg;
>  	long			timeleft;
> -	bhv_vfs_sync_work_t	*work, *n;
> +	xfs_sync_work_t		*work, *n;
>  	LIST_HEAD		(tmp);
>  
>  	set_freezable();
> diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
> index 04f058c..ec95e26 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.h
> +++ b/fs/xfs/linux-2.6/xfs_sync.h
> @@ -21,18 +21,19 @@
>  struct xfs_mount;
>  struct xfs_perag;
>  
> -typedef struct bhv_vfs_sync_work {
> +typedef struct xfs_sync_work {
>  	struct list_head	w_list;
>  	struct xfs_mount	*w_mount;
>  	void			*w_data;	/* syncer routine argument */
>  	void			(*w_syncer)(struct xfs_mount *, void *);
> -} bhv_vfs_sync_work_t;
> +} xfs_sync_work_t;
>  
>  #define SYNC_ATTR		0x0001	/* sync attributes */
>  #define SYNC_DELWRI		0x0002	/* look at delayed writes */
>  #define SYNC_WAIT		0x0004	/* wait for i/o to complete */
>  #define SYNC_BDFLUSH		0x0008	/* BDFLUSH is calling -- don't block */
>  #define SYNC_IOWAIT		0x0010  /* wait for all I/O to complete */
> +#define SYNC_TRYLOCK		0x0020  /* only try to lock inodes */
>  
>  int xfs_syncd_init(struct xfs_mount *mp);
>  void xfs_syncd_stop(struct xfs_mount *mp);
> @@ -44,7 +45,7 @@ int xfs_quiesce_data(struct xfs_mount *mp);
>  void xfs_quiesce_attr(struct xfs_mount *mp);
>  
>  void xfs_flush_inode(struct xfs_inode *ip);
> -void xfs_flush_device(struct xfs_inode *ip);
> +void xfs_flush_inodes(struct xfs_inode *ip);
>  
>  int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
>  int xfs_reclaim_inodes(struct xfs_mount *mp, int noblock, int mode);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 08ce723..8b97d82 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -361,7 +361,7 @@ xfs_flush_space(
>  		return 0;
>  	case 2:
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		xfs_flush_device(ip);
> +		xfs_flush_inodes(ip);
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		*fsynced = 3;
>  		return 0;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 1438dd4..6df3a31 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -318,7 +318,7 @@ typedef struct xfs_mount {
>  #endif
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>  	struct task_struct	*m_sync_task;	/* generalised sync thread */
> -	bhv_vfs_sync_work_t	m_sync_work;	/* work item for VFS_SYNC */
> +	xfs_sync_work_t		m_sync_work;	/* work item for VFS_SYNC */
>  	struct list_head	m_sync_list;	/* sync thread work item list */
>  	spinlock_t		m_sync_lock;	/* work item list lock */
>  	int			m_sync_seq;	/* sync thread generation no. */
> -- 
> 1.6.2
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
