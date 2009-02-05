Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n154WL3X189630 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 22:32:21 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C37A91BB7E01
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 20:31:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id DjZsJ4BGVLfDKNB5 for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2009 20:31:41 -0800 (PST)
Date: Wed, 4 Feb 2009 23:31:25 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: spurious -ENOSPC on XFS
In-Reply-To: <20090204120852.GK24173@disturbed>
Message-ID: <Pine.LNX.4.64.0902042310240.27204@hs20-bc2-1.build.redhat.com>
References: <20090120232422.GF10158@disturbed>
	<20090122205913.GA30859@infradead.org>
	<20090122224347.GA18751@infradead.org>
	<Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
	<20090124071249.GF32390@disturbed>
	<Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
	<20090131235725.GA24173@disturbed>
	<Pine.LNX.4.64.0902021214310.15622@hs20-bc2-1.build.redhat.com>
	<20090203032740.GG24173@disturbed>
	<Pine.LNX.4.64.0902031459350.28433@hs20-bc2-1.build.redhat.com>
	<20090204120852.GK24173@disturbed>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> > ... and if you turn it into trylock, what are you going to do with the 
> > inode that is just being written to? You should definitely flush it, but 
> > trylock will skip it because it's already locked.
> 
> We've already flushed it directly. You disabled that code fearing
> deadlocks. I've made it synchronous (i.e. not handed off to
> xfssyncd) because the flush path requires us to hold the lock we are
> already holding....

This is not "fearing deadlocks". This was getting a real deadlock:

Jan 29 16:51:55 slunicko kernel: SysRq : Show Blocked State
Jan 29 16:51:55 slunicko kernel:   task                        PC stack   
pid father
Jan 29 16:51:55 slunicko kernel: xfssyncd      D 00000000004848e0     0 
13321
   2
Jan 29 16:51:55 slunicko kernel: Call Trace:
Jan 29 16:51:55 slunicko kernel:  [000000000060475c] io_schedule+0x20/0x44
Jan 29 16:51:55 slunicko kernel:  [00000000004848e0] sync_page+0x64/0x74
Jan 29 16:51:55 slunicko kernel:  [000000000060494c] 
__wait_on_bit_lock+0x5c/0x9c
Jan 29 16:51:55 slunicko kernel:  [0000000000484848] __lock_page+0x58/0x68
Jan 29 16:51:55 slunicko kernel:  [000000000048b3fc] 
write_cache_pages+0x170/0x38c
Jan 29 16:51:55 slunicko kernel:  [000000000048b64c] 
generic_writepages+0x34/0x48
Jan 29 16:51:55 slunicko kernel:  [00000000101d0d48] 
xfs_vm_writepages+0x3c/0x50 [xfs]
Jan 29 16:51:55 slunicko kernel:  [000000000048b6a4] 
do_writepages+0x44/0x7c
Jan 29 16:51:55 slunicko kernel:  [00000000004850f4] 
__filemap_fdatawrite_range+0x58/0x6c
Jan 29 16:51:55 slunicko kernel:  [0000000000485cc8] 
filemap_flush+0x20/0x34
Jan 29 16:51:55 slunicko kernel:  [00000000101dbc64] 
xfs_flush_inode_work+0x10/0x28 [xfs]
Jan 29 16:51:55 slunicko kernel:  [00000000101dbf2c] xfssyncd+0x110/0x174 
[xfs]
Jan 29 16:51:55 slunicko kernel:  [000000000046556c] kthread+0x54/0x88
Jan 29 16:51:55 slunicko kernel:  [000000000042b2a0] 
kernel_thread+0x3c/0x54
Jan 29 16:51:55 slunicko kernel:  [00000000004653b8] kthreadd+0xac/0x160
Jan 29 16:51:55 slunicko kernel: pdflush       D 00000000004848e0     0 
15226
   2
Jan 29 16:51:55 slunicko kernel: Call Trace:
Jan 29 16:51:55 slunicko kernel:  [000000000060475c] io_schedule+0x20/0x44
Jan 29 16:51:55 slunicko kernel:  [00000000004848e0] sync_page+0x64/0x74
Jan 29 16:51:55 slunicko kernel:  [000000000060494c] 
__wait_on_bit_lock+0x5c/0x9c
Jan 29 16:51:55 slunicko kernel:  [0000000000484848] __lock_page+0x58/0x68
Jan 29 16:51:55 slunicko kernel:  [000000000048b3fc] 
write_cache_pages+0x170/0x38c
Jan 29 16:51:55 slunicko kernel:  [000000000048b64c] 
generic_writepages+0x34/0x48
Jan 29 16:51:55 slunicko kernel:  [00000000101d0d48] 
xfs_vm_writepages+0x3c/0x50 [xfs]
Jan 29 16:51:55 slunicko kernel:  [000000000048b6a4] 
do_writepages+0x44/0x7c
Jan 29 16:51:55 slunicko kernel:  [00000000004ca350] 
__writeback_single_inode+0x168/0x2e4
Jan 29 16:51:55 slunicko kernel:  [00000000004ca90c] 
generic_sync_sb_inodes+0x204/0x3a0
Jan 29 16:51:55 slunicko kernel:  [00000000004caabc] 
sync_sb_inodes+0x14/0x24
Jan 29 16:51:55 slunicko kernel:  [00000000004cacd8] 
writeback_inodes+0x8c/0x100
Jan 29 16:51:55 slunicko kernel:  [000000000048c274] wb_kupdate+0xc4/0x15c
Jan 29 16:51:55 slunicko kernel:  [000000000048c8dc] pdflush+0xfc/0x1cc
Jan 29 16:51:55 slunicko kernel:  [000000000046556c] kthread+0x54/0x88
Jan 29 16:51:55 slunicko kernel:  [000000000042b2a0] 
kernel_thread+0x3c/0x54
Jan 29 16:51:55 slunicko kernel: dd            D 00000000006045c4     0 
16610  16597
Jan 29 16:51:55 slunicko kernel: Call Trace:
Jan 29 16:51:55 slunicko kernel:  [00000000006047d8] 
schedule_timeout+0x24/0xb8
Jan 29 16:51:55 slunicko kernel:  [00000000006045c4] 
wait_for_common+0xe4/0x14c
Jan 29 16:51:55 slunicko kernel:  [0000000000604700] 
wait_for_completion+0x1c/0x2c
Jan 29 16:51:55 slunicko kernel:  [00000000101dc7d8] 
xfs_flush_inode+0xb0/0xc0 [xfs]
Jan 29 16:51:55 slunicko kernel:  [00000000101b9b50] 
xfs_flush_space+0x54/0xd0 [xfs]
Jan 29 16:51:55 slunicko kernel:  [00000000101b9ec0] 
xfs_iomap_write_delay+0x1bc/0x228 [xfs]
Jan 29 16:51:55 slunicko kernel:  [00000000101ba4b8] xfs_iomap+0x1c4/0x2e0 
[xfs]Jan 29 16:51:55 slunicko kernel:  [00000000101d0f04] 
__xfs_get_blocks+0x74/0x240 [xfs]
Jan 29 16:51:55 slunicko kernel:  [00000000101d112c] 
xfs_get_blocks+0x24/0x38 [xfs]
Jan 29 16:51:55 slunicko kernel:  [00000000004d05f0] 
__block_prepare_write+0x184/0x41c
Jan 29 16:51:55 slunicko kernel:  [00000000004d095c] 
block_write_begin+0x84/0xe8
Jan 29 16:51:55 slunicko kernel:  [00000000101d047c] 
xfs_vm_write_begin+0x3c/0x50 [xfs]
Jan 29 16:51:55 slunicko kernel:  [0000000000485258] 
generic_file_buffered_write+0xe8/0x28c
Jan 29 16:51:55 slunicko kernel:  [00000000101d8ec4] xfs_write+0x40c/0x604 
[xfs]Jan 29 16:51:55 slunicko kernel:  [00000000101d4d3c] 
xfs_file_aio_write+0x74/0x84 [xfs]
Jan 29 16:51:55 slunicko kernel:  [00000000004ae70c] 
do_sync_write+0x8c/0xdc

This one was obtained on a machine with 4k filesystem blocks, 8k pages and 
dd bs=1 on a nearly full filesystem. Apparently it attempts to lock the 
page that is already locked when writing to it.

The deadlock happened when I modified it to use completions (instead of 
500ms wait) with the patch I already posted.

> > > > There seems to be more bugs with forgetting to flush delayed allocation 
> > > > --- you should flush delayed allocation after *every* failed allocate 
> > > > attempt, but the code flushes it only after failed delayed allocate 
> > > > attempt --- i.e. nondelayed allocators, such as xfs_iomap_write_direct 
> > > > (and maybe other places) will still return -ENOSPC without attempting to 
> > > > flush other inodes with delayed allocation.
> .....
> > > For metadata allocations (all over the place), we take a reservation
> > > first
> > 
> > And what if the reservation fails? Do you flush in this case?
> 
> Well, if you read the rest of the paragraph you'd have the answer
> to that question. I'll leave it quoted because it is relevant:
> 
> > > and so we could trigger a flush in certain circumstances if
> > > the reservation fails (to avoid recursion and transaction subsystem
> > > deadlocks). However, if you are not getting spurious enospc on
> > > creating inodes (as opposed to writing to them) then I see no
> > > immediate need for flushes there, either....
> 
> It is relevant because the test case Eric provided fails repeatedly
> in xfs_create() on a reservation rather than on a data write, and
> without a flush there no further data writes will occur to flush out
> the blocks.
> 
> So a flush there is needed, too.
> 
> > > > @@ -415,6 +419,7 @@ xfs_syncd_queue_work(
> > > >   * has failed with ENOSPC and we are in the process of scratching our
> > > >   * heads, looking about for more room...
> > > >   */
> > > > +#if 0
> > > >  STATIC void
> > > >  xfs_flush_inode_work(
> > > >  	struct xfs_mount *mp,
> > > > @@ -424,16 +429,20 @@ xfs_flush_inode_work(
> > > >  	filemap_flush(inode->i_mapping);
> > > >  	iput(inode);
> > > >  }
> > > > +#endif
> > > >  
> > > >  void
> > > >  xfs_flush_inode(
> > > >  	xfs_inode_t	*ip)
> > > >  {
> > > > +#if 0
> > > >  	struct inode	*inode = VFS_I(ip);
> > > > +	DECLARE_COMPLETION_ONSTACK(completion);
> > > >  
> > > >  	igrab(inode);
> > > > -	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work);
> > > > -	delay(msecs_to_jiffies(500));
> > > > +	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work, &completion);
> > > > +	wait_for_completion(&completion);
> > > > +#endif
> > > 
> > > Why did you turn off the initial inode flush?
> > 
> > Because it recurses into Linux VFS layer and deadlocks.
> 
> Not at all. It calls into the writeback code (not the VFS)
> which does not take any locks except page locks before it
> calls back into ->writepages....

See the backtrace above.

> I've attached the WIP patch I have right now (based on yours) that
> allows the test case to pass. It will need a bit of cleanup before
> it is ready for prime-time, but is passes xfsqa here including the
> ENOSPC stress tests.  Can you see if it fixes your test case and
> whether it deadlocks?

I can try it, but that filemap_fdatawrite is still wrong. I tried to call 
filemap_fdatawrite myself with my patch and got the deadlock.

You just can't do it that you hold a page lock and call an generic kernel 
function that takes other page locks. Even if you hacked it somehow to be 
working now, over the long term it is unmaintainable.

Mikulas

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> 
> Use xfs_sync_inodes and not sync_blockdev. XFS keeps it's dirty
> metadata in different address spaces to the block device, so
> sync_blockdev does nothing.
> 
> Change that 500ms delay to a wait for completion, so that the
> behavior is not dependent on magic timeout values.
> 
> Add a trylock option to xfs_sync_inodes() so that it won't
> deadlock if we are already holding an inode lock.
> 
> Add xfs_flush_device() to inode allocation failure in the create
> path as that is the other place that typically falls over due to
> outstanding delayed allocation extents.
> 
> Based on work from Mikulas Patocka <mpatocka@redhat.com>.
> 
> ---
>  fs/xfs/linux-2.6/xfs_fs_subr.c |   14 ++++----
>  fs/xfs/linux-2.6/xfs_sync.c    |   66 +++++++++++++++++++--------------------
>  fs/xfs/linux-2.6/xfs_sync.h    |    6 ++-
>  fs/xfs/xfs_mount.h             |    2 +-
>  fs/xfs/xfs_vnodeops.c          |    6 ++++
>  5 files changed, 50 insertions(+), 44 deletions(-)
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
> index a608e72..fddb9de 100644
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
> @@ -128,12 +122,23 @@ xfs_sync_inodes_ag(
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
> +							XFS_B_ASYNC, FI_NONE);
> +				}
> +			}
> +			if (VN_CACHED(inode) && (flags & SYNC_IOWAIT)) {
>  				xfs_ioend_wait(ip);
> +			}
>  		}
>  		xfs_ilock(ip, XFS_ILOCK_SHARED);
>  
> @@ -388,7 +393,7 @@ xfs_quiesce_attr(
>  }
>  
>  /*
> - * Enqueue a work item to be picked up by the vfs xfssyncd thread.
> + * Enqueue a work item to be picked up by the xfssyncd thread.
>   * Doing this has two advantages:
>   * - It saves on stack space, which is tight in certain situations
>   * - It can be used (with care) as a mechanism to avoid deadlocks.
> @@ -398,15 +403,17 @@ STATIC void
>  xfs_syncd_queue_work(
>  	struct xfs_mount *mp,
>  	void		*data,
> -	void		(*syncer)(struct xfs_mount *, void *))
> +	void		(*syncer)(struct xfs_mount *, void *),
> +	struct completion *completion)
>  {
> -	struct bhv_vfs_sync_work *work;
> +	struct xfs_sync_work *work;
>  
> -	work = kmem_alloc(sizeof(struct bhv_vfs_sync_work), KM_SLEEP);
> +	work = kmem_zalloc(sizeof(struct xfs_sync_work), KM_SLEEP);
>  	INIT_LIST_HEAD(&work->w_list);
>  	work->w_syncer = syncer;
>  	work->w_data = data;
>  	work->w_mount = mp;
> +	work->w_completion = completion;
>  	spin_lock(&mp->m_sync_lock);
>  	list_add_tail(&work->w_list, &mp->m_sync_list);
>  	spin_unlock(&mp->m_sync_lock);
> @@ -419,25 +426,11 @@ xfs_syncd_queue_work(
>   * has failed with ENOSPC and we are in the process of scratching our
>   * heads, looking about for more room...
>   */
> -STATIC void
> -xfs_flush_inode_work(
> -	struct xfs_mount *mp,
> -	void		*arg)
> -{
> -	struct inode	*inode = arg;
> -	filemap_flush(inode->i_mapping);
> -	iput(inode);
> -}
> -
>  void
>  xfs_flush_inode(
>  	xfs_inode_t	*ip)
>  {
> -	struct inode	*inode = VFS_I(ip);
> -
> -	igrab(inode);
> -	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work);
> -	delay(msecs_to_jiffies(500));
> +	xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
>  }
>  
>  /*
> @@ -450,7 +443,8 @@ xfs_flush_device_work(
>  	void		*arg)
>  {
>  	struct inode	*inode = arg;
> -	sync_blockdev(mp->m_super->s_bdev);
> +	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_TRYLOCK);
> +	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_TRYLOCK | SYNC_IOWAIT);
>  	iput(inode);
>  }
>  
> @@ -459,10 +453,11 @@ xfs_flush_device(
>  	xfs_inode_t	*ip)
>  {
>  	struct inode	*inode = VFS_I(ip);
> +	DECLARE_COMPLETION_ONSTACK(completion);
>  
>  	igrab(inode);
> -	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_device_work);
> -	delay(msecs_to_jiffies(500));
> +	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_device_work, &completion);
> +	wait_for_completion(&completion);
>  	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
>  }
>  
> @@ -497,7 +492,7 @@ xfssyncd(
>  {
>  	struct xfs_mount	*mp = arg;
>  	long			timeleft;
> -	bhv_vfs_sync_work_t	*work, *n;
> +	xfs_sync_work_t		*work, *n;
>  	LIST_HEAD		(tmp);
>  
>  	set_freezable();
> @@ -530,6 +525,8 @@ xfssyncd(
>  		list_for_each_entry_safe(work, n, &tmp, w_list) {
>  			(*work->w_syncer)(mp, work->w_data);
>  			list_del(&work->w_list);
> +			if (work->w_completion)
> +				complete(work->w_completion);
>  			if (work == &mp->m_sync_work)
>  				continue;
>  			kmem_free(work);
> @@ -545,6 +542,7 @@ xfs_syncd_init(
>  {
>  	mp->m_sync_work.w_syncer = xfs_sync_worker;
>  	mp->m_sync_work.w_mount = mp;
> +	mp->m_sync_work.w_completion = NULL;
>  	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd");
>  	if (IS_ERR(mp->m_sync_task))
>  		return -PTR_ERR(mp->m_sync_task);
> diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
> index 5f6de1e..de87a7f 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.h
> +++ b/fs/xfs/linux-2.6/xfs_sync.h
> @@ -20,18 +20,20 @@
>  
>  struct xfs_mount;
>  
> -typedef struct bhv_vfs_sync_work {
> +typedef struct xfs_sync_work {
>  	struct list_head	w_list;
>  	struct xfs_mount	*w_mount;
>  	void			*w_data;	/* syncer routine argument */
>  	void			(*w_syncer)(struct xfs_mount *, void *);
> -} bhv_vfs_sync_work_t;
> +	struct completion	*w_completion;
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
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index f5e9937..775a2ac 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -322,7 +322,7 @@ typedef struct xfs_mount {
>  #endif
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>  	struct task_struct	*m_sync_task;	/* generalised sync thread */
> -	bhv_vfs_sync_work_t	m_sync_work;	/* work item for VFS_SYNC */
> +	xfs_sync_work_t		m_sync_work;	/* work item for VFS_SYNC */
>  	struct list_head	m_sync_list;	/* sync thread work item list */
>  	spinlock_t		m_sync_lock;	/* work item list lock */
>  	int			m_sync_seq;	/* sync thread generation no. */
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 0e55c5d..e1099e7 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -1449,6 +1449,12 @@ xfs_create(
>  	error = xfs_trans_reserve(tp, resblks, XFS_CREATE_LOG_RES(mp), 0,
>  			XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
>  	if (error == ENOSPC) {
> +		/* flush delalloc blocks and retry */
> +		xfs_flush_device(dp);
> +		error = xfs_trans_reserve(tp, resblks, XFS_CREATE_LOG_RES(mp), 0,
> +			XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
> +	}
> +	if (error == ENOSPC) {
>  		resblks = 0;
>  		error = xfs_trans_reserve(tp, 0, XFS_CREATE_LOG_RES(mp), 0,
>  				XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
