Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:33536 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbdCAADG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 19:03:06 -0500
Date: Tue, 28 Feb 2017 15:09:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/12] xfs: implement failure-atomic writes
Message-ID: <20170228230940.GB26319@birch.djwong.org>
References: <20170228145737.19016-1-hch@lst.de>
 <20170228145737.19016-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170228145737.19016-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Feb 28, 2017 at 06:57:32AM -0800, Christoph Hellwig wrote:
> If O_ATOMIC is specified in the open flags this will cause XFS to
> allocate new extents in the COW for even if overwriting existing data,

"COW fork"                    ^^^^^^^

The previous patch's commit message also has that quirk.

> and not remap them into the data fork until ->fsync is called,
> at which point the whole range will be atomically remapped into the
> data fork.  This allows applications to ѕafely overwrite data instead
> of having to do double writes.

By the way, the copy on write code remembers the extents it has
allocated for CoW staging in the refcount btree so that it can free them
after a crash, which means that O_ATOMIC requires reflink to be enabled.
There doesn't seem to be any explicit checking that reflink is even
enabled, which will probably just lead to weird crashes on a pre-reflink
xfs.

FWIW I didn't see any checking anywhere (vfs or xfs) that the filesystem
can actually support O_ATOMIC.  If the FS doesn't support atomic writes,
shouldn't the kernel send EINVAL or something back to userspace?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c    | 18 +++++++++-----
>  fs/xfs/xfs_aops.h    |  4 ++-
>  fs/xfs/xfs_file.c    | 17 +++++++++++++
>  fs/xfs/xfs_iomap.c   | 18 ++++++++------
>  fs/xfs/xfs_reflink.c | 69 ++++++++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_reflink.h |  5 ++--
>  6 files changed, 91 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c78b585b3d84..1c5efbb05b47 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -292,6 +292,7 @@ xfs_end_io(
>  	if (unlikely(error)) {
>  		switch (ioend->io_type) {
>  		case XFS_IO_COW:
> +		case XFS_IO_ATOMIC:

So we cancel the CoW staging blocks if the write was atomic and failed.

Later in the !error case we remap the blocks if it was a cow write, but
leave the mapping in memory if the write was atomic.  That is consistent
with the commit message, good.

At the start of xfs_reflink.c is a long block comment describing how the
copy on write mechanism works.  Since O_ATOMIC is a variant on CoW (it's
basically CoW with remapping deferred until fsync), please update the
comment so that the comments capture the details of how atomic writes
work.

(IOWs: Dave asked me to leave the big comment, so I'm going to try to
keep it fairly up to date.)

>  			xfs_reflink_cancel_cow_range(ip, offset, size, 0);
>  			break;
>  		}
> @@ -327,7 +328,9 @@ xfs_end_bio(
>  	struct xfs_ioend	*ioend = bio->bi_private;
>  	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
>  
> -	if (ioend->io_type == XFS_IO_UNWRITTEN || ioend->io_type == XFS_IO_COW)
> +	if (ioend->io_type == XFS_IO_UNWRITTEN ||
> +	    ioend->io_type == XFS_IO_COW ||
> +	    ioend->io_type == XFS_IO_ATOMIC)
>  		queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
>  	else if (ioend->io_append_trans)
>  		queue_work(mp->m_data_workqueue, &ioend->io_work);
> @@ -354,6 +357,7 @@ xfs_map_blocks(
>  		return -EIO;
>  
>  	ASSERT(type != XFS_IO_COW);
> +	ASSERT(type != XFS_IO_ATOMIC);
>  	if (type == XFS_IO_UNWRITTEN)
>  		bmapi_flags |= XFS_BMAPI_IGSTATE;
>  
> @@ -768,7 +772,8 @@ xfs_map_cow(
>  	struct xfs_writepage_ctx *wpc,
>  	struct inode		*inode,
>  	loff_t			offset,
> -	unsigned int		*new_type)
> +	unsigned int		*new_type,
> +	bool			atomic)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_bmbt_irec	imap;
> @@ -778,10 +783,10 @@ xfs_map_cow(
>  	/*
>  	 * If we already have a valid COW mapping keep using it.
>  	 */
> -	if (wpc->io_type == XFS_IO_COW) {
> +	if (wpc->io_type == XFS_IO_COW || wpc->io_type == XFS_IO_ATOMIC) {
>  		wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap, offset);
>  		if (wpc->imap_valid) {
> -			*new_type = XFS_IO_COW;
> +			*new_type = wpc->io_type;
>  			return 0;
>  		}
>  	}
> @@ -807,7 +812,7 @@ xfs_map_cow(
>  			return error;
>  	}
>  
> -	wpc->io_type = *new_type = XFS_IO_COW;
> +	wpc->io_type = *new_type = atomic ? XFS_IO_ATOMIC : XFS_IO_COW;
>  	wpc->imap_valid = true;
>  	wpc->imap = imap;
>  	return 0;
> @@ -886,7 +891,8 @@ xfs_writepage_map(
>  		}
>  
>  		if (XFS_I(inode)->i_cowfp) {
> -			error = xfs_map_cow(wpc, inode, offset, &new_type);
> +			error = xfs_map_cow(wpc, inode, offset, &new_type,
> +					buffer_atomic(bh));
>  			if (error)
>  				goto out;
>  		}
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index cc174ec6c2fd..798e653e68b6 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -29,6 +29,7 @@ enum {
>  	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
>  	XFS_IO_OVERWRITE,	/* covers already allocated extent */
>  	XFS_IO_COW,		/* covers copy-on-write extent */
> +	XFS_IO_ATOMIC,		/* atomic write */
>  };
>  
>  #define XFS_IO_TYPES \
> @@ -36,7 +37,8 @@ enum {
>  	{ XFS_IO_DELALLOC,		"delalloc" }, \
>  	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
>  	{ XFS_IO_OVERWRITE,		"overwrite" }, \
> -	{ XFS_IO_COW,			"CoW" }
> +	{ XFS_IO_COW,			"CoW" }, \
> +	{ XFS_IO_ATOMIC,		"atomic" }
>  
>  /*
>   * Structure for buffered I/O completions.
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 086440e79b86..a7d8324b59c5 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -160,6 +160,12 @@ xfs_file_fsync(
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		xfs_blkdev_issue_flush(mp->m_ddev_targp);
>  
> +	if (file->f_flags & O_ATOMIC) {
> +		error = xfs_reflink_end_cow(ip, start, end - start + 1);
> +		if (error)
> +			return error;
> +	}

I suppose it goes without saying that userspace will have to coordinate
its O_ATOMIC writes to the file.  What if this happens?

Process A			Process B

Open atomic file		Open atomic file
Dirty some pages		Dirty some other pages
fsync
Successful fsync return
Dirty more pages
				Dirty more of some other pages
<system crash>

When we come back up, the file contents will reflect everything A wrote
up to fsync, and (since fsync flushed everything) everything B wrote in
"dirty some other pages", even though it hadn't reached fsync.  Won't
this be surprising to B since it expected that disk mappings don't get
updated until it fsyncs?

Practically speaking, I wonder how often this will come up in the real
world, but it does seem to be a potential downside.  Per *file tracking
sounds like a bigger bookkeeping nightmare.

> +
>  	/*
>  	 * All metadata updates are logged, which means that we just have to
>  	 * flush the log up to the latest LSN that touched the inode. If we have
> @@ -457,6 +463,9 @@ xfs_dio_write_end_io(
>  	}
>  	spin_unlock(&ip->i_flags_lock);
>  
> +	if (iocb->ki_filp->f_flags & O_ATOMIC)
> +		return 0;
> +
>  	if (flags & IOMAP_DIO_COW) {
>  		error = xfs_reflink_end_cow(ip, offset, size);
>  		if (error)
> @@ -529,6 +538,12 @@ xfs_file_dio_aio_write(
>  		unaligned_io = 1;
>  
>  		/*
> +		 * We need filesystem block alignment to provide atomic commits.
> +		 */
> +		if (file->f_flags & O_ATOMIC)
> +			return -EINVAL;
> +
> +		/*
>  		 * We can't properly handle unaligned direct I/O to reflink
>  		 * files yet, as we can't unshare a partial block.
>  		 */
> @@ -892,6 +907,8 @@ xfs_file_open(
>  		return -EFBIG;
>  	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
>  		return -EIO;
> +	if (file->f_flags & O_ATOMIC)
> +		printk_ratelimited("O_ATOMIC!\n");

Per above,

if (file->f_flags & O_ATOMIC) {
	if (!xfs_sb_version_hasreflink(...))
		return -EPROTONOSUPPORT;
	printk_ratelimited("EXPERIMENTAL atomic writes feature in use!\n");
}

>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 5d68b4279016..b686a6bd2db4 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -559,13 +559,14 @@ xfs_file_iomap_begin_delay(
>  
>  	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got);
>  	if (!eof && got.br_startoff <= offset_fsb) {
> -		if (xfs_is_reflink_inode(ip)) {
> +		if ((flags & IOMAP_ATOMIC) || xfs_is_reflink_inode(ip)) {
>  			bool		shared;
>  
>  			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
>  					maxbytes_fsb);
>  			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
> -			error = xfs_reflink_reserve_cow(ip, &got, &shared);
> +			error = xfs_reflink_reserve_cow(ip, &got, &shared,
> +					(flags & IOMAP_ATOMIC));
>  			if (error)
>  				goto out_unlock;
>  		}
> @@ -951,7 +952,7 @@ static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
>  	 */
>  	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO)))
>  		return true;
> -	if ((flags & IOMAP_DIRECT) && (flags & IOMAP_WRITE))
> +	if ((flags & (IOMAP_DIRECT | IOMAP_ATOMIC)) && (flags & IOMAP_WRITE))
>  		return true;
>  	return false;
>  }
> @@ -976,7 +977,8 @@ xfs_file_iomap_begin(
>  		return -EIO;
>  
>  	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
> -			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
> +	    ((flags & IOMAP_ATOMIC) ||
> +	     (!IS_DAX(inode) && !xfs_get_extsz_hint(ip)))) {
>  		/* Reserve delalloc blocks for regular writeback. */
>  		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
>  				iomap);
> @@ -1008,15 +1010,17 @@ xfs_file_iomap_begin(
>  			goto out_unlock;
>  	}
>  
> -	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> +	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) &&
> +	    ((flags & IOMAP_ATOMIC) || xfs_is_reflink_inode(ip))) {
>  		if (flags & IOMAP_DIRECT) {
>  			/* may drop and re-acquire the ilock */
>  			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
> -					&lockmode);
> +					&lockmode, flags & IOMAP_ATOMIC);
>  			if (error)
>  				goto out_unlock;
>  		} else {
> -			error = xfs_reflink_reserve_cow(ip, &imap, &shared);
> +			error = xfs_reflink_reserve_cow(ip, &imap, &shared,
> +					false);
>  			if (error)
>  				goto out_unlock;
>  		}
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 4225b5e67b17..4702dd800ab8 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -264,9 +264,9 @@ int
>  xfs_reflink_reserve_cow(
>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*imap,
> -	bool			*shared)
> +	bool			*shared,
> +	bool			always_cow)
>  {
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	struct xfs_bmbt_irec	got;
>  	int			error = 0;
>  	bool			eof = false, trimmed;
> @@ -280,26 +280,30 @@ xfs_reflink_reserve_cow(
>  	 * extent list is generally faster than going out to the shared extent
>  	 * tree.
>  	 */
> -
> -	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &idx, &got))
> +	if (!ip->i_cowfp) {
> +		ASSERT(always_cow);
> +		xfs_ifork_init_cow(ip);
>  		eof = true;
> -	if (!eof && got.br_startoff <= imap->br_startoff) {
> -		trace_xfs_reflink_cow_found(ip, imap);
> -		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
> +	} else {
> +		if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, imap->br_startoff,
> +				&idx, &got))
> +			eof = true;
> +		if (!eof && got.br_startoff <= imap->br_startoff) {
> +			trace_xfs_reflink_cow_found(ip, imap);
> +			xfs_trim_extent(imap, got.br_startoff,
> +					got.br_blockcount);
> +
> +			*shared = true;
> +			return 0;
> +		}
>  
> -		*shared = true;
> -		return 0;
> +		/* Trim the mapping to the nearest shared extent boundary. */
> +		error = xfs_reflink_trim_around_shared(ip, imap, shared,
> +				&trimmed);
> +		if (error || !*shared)
> +			return error;
>  	}
>  
> -	/* Trim the mapping to the nearest shared extent boundary. */
> -	error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
> -	if (error)
> -		return error;
> -
> -	/* Not shared?  Just report the (potentially capped) extent. */
> -	if (!*shared)
> -		return 0;
> -
>  	/*
>  	 * Fork all the shared blocks from our write offset until the end of
>  	 * the extent.
> @@ -383,7 +387,8 @@ xfs_reflink_allocate_cow(
>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*imap,
>  	bool			*shared,
> -	uint			*lockmode)
> +	uint			*lockmode,
> +	bool			always_cow)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> @@ -399,15 +404,19 @@ xfs_reflink_allocate_cow(
>  	xfs_extnum_t		idx;
>  
>  retry:
> -	ASSERT(xfs_is_reflink_inode(ip));
> +	ASSERT(always_cow | xfs_is_reflink_inode(ip));
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  
> +	if (!ip->i_cowfp) {
> +		ASSERT(always_cow);
> +		xfs_ifork_init_cow(ip);
> +
>  	/*
>  	 * Even if the extent is not shared we might have a preallocation for
>  	 * it in the COW fork.  If so use it.
>  	 */
> -	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &idx, &got) &&
> -	    got.br_startoff <= offset_fsb) {
> +	} else if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &idx,
> +			&got) && got.br_startoff <= offset_fsb) {
>  		*shared = true;
>  
>  		/* If we have a real allocation in the COW fork we're done. */
> @@ -418,7 +427,7 @@ xfs_reflink_allocate_cow(
>  		}
>  
>  		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
> -	} else {
> +	} else if (!always_cow) {
>  		error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
>  		if (error || !*shared)
>  			goto out;
> @@ -684,6 +693,7 @@ xfs_reflink_end_cow(
>  	xfs_fileoff_t			offset_fsb;
>  	xfs_fileoff_t			end_fsb;
>  	xfs_fsblock_t			firstfsb;
> +	xfs_off_t			new_size;
>  	struct xfs_defer_ops		dfops;
>  	int				error;
>  	unsigned int			resblks;
> @@ -693,7 +703,7 @@ xfs_reflink_end_cow(
>  	trace_xfs_reflink_end_cow(ip, offset, count);
>  
>  	/* No COW extents?  That's easy! */
> -	if (ifp->if_bytes == 0)
> +	if (!ifp || ifp->if_bytes == 0)
>  		return 0;
>  
>  	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
> @@ -776,6 +786,17 @@ xfs_reflink_end_cow(
>  			break;
>  	}
>  
> +	/*
> +	 * Update the on-disk inode size if we completed an operation outside
> +	 * of the inode size.  This can only happen for atomic writes, and not
> +	 * for actual reflinked files.
> +	 */
> +	new_size = xfs_new_eof(ip, offset + count);
> +	if (new_size) {
> +		ip->i_d.di_size = new_size;
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	}
> +
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (error)
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 9416279b3c89..0360e2c0f3a5 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -27,9 +27,10 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
>  
>  extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
> -		struct xfs_bmbt_irec *imap, bool *shared);
> +		struct xfs_bmbt_irec *imap, bool *shared, bool always_cow);
>  extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
> -		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode);
> +		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode,
> +		bool always_cow);

manpages/xfstests needed, but the rest of this looks more or less sane.

--D

>  extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t count);
>  extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
