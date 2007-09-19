Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 08:47:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8JFlQv2001339
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 08:47:37 -0700
Message-ID: <46F07E79.8090605@sgi.com>
Date: Wed, 19 Sep 2007 11:42:17 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] kill unnessecary ioops indirection
References: <20070914162802.GE7110@lst.de> <46EF661C.4030500@sgi.com> <20070918192327.GA24369@lst.de>
In-Reply-To: <20070918192327.GA24369@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
>>> STATIC int				/* error (positive) */
>>> xfs_zero_last_block(
>>> -	struct inode	*ip,
>>> -	xfs_iocore_t	*io,
>>> +	struct inode	*inode,
>>> +	xfs_inode_t	*ip,
>> We don't really need to pass both the inode and xfs_inode
>> since it's easy to get one from the other.  It was a trivial
>> exercise to get the iocore from the inode too so it's not a
>> problem with this change but should be cleaned up.
> 
> Yeah, and when doing this change a lot more similar cleanups to
> get rid of xfs_inode and vnode fall out automatically.  I've
> incorporated those bits into the next version.
Smashing, thanks.

> 
>>> @@ -474,7 +474,8 @@ xfs_zero_eof(
>>> 	xfs_off_t	offset,		/* starting I/O offset */
>>> 	xfs_fsize_t	isize)		/* current inode size */
>>> {
>>> -	struct inode	*ip = vn_to_inode(vp);
>>> +	struct inode	*inode = vn_to_inode(vp);
>>> +	xfs_inode_t	*ip = XFS_I(inode);
>> Can we change the prototype for xfs_zero_eof() to take an inode
>> instead of the vp?  They are the same object and vn_to_inode()/
>> vn_from_inode() are just a waste of cycles.  Also kills another
>> stack variable.
> 
> I've changed to to an xfs_inode because that's what we want.
> inode is only needed all the way up in xfs_iozero once.
Oh that's even better, thanks.

> 
> vn_to_inode()/vn_from_inode() are no-ops nowdays, btw.
Yeah I know - that's why I'd like to get rid of them.  They make the
code ugly and give the impression we need to work with two different
objects.  There's lots of places where we declare an extra pointer on
the stack when we don't need to.  Anyway that's fodder for another
patch, this patch looks good now.

> 
>>> -	error = XFS_SWAP_EXTENTS(mp, &ip->i_iocore, &tip->i_iocore, sxp);
>>> +	error = xfs_swap_extents(ip, ip, sxp);
>> xfs_swap_extents(ip, tip, sxp);
> 
> Oops, fixed.  No idea why xfsqa didn't catch this.
> 
> 
> And here's the updated patch:
> 
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-09-16 13:51:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2007-09-18 16:44:27.000000000 +0200
> @@ -131,7 +131,7 @@ xfs_inval_cached_trace(
>   */
>  STATIC int
>  xfs_iozero(
> -	struct inode		*ip,	/* inode			*/
> +	struct xfs_inode	*ip,	/* inode			*/
>  	loff_t			pos,	/* offset in file		*/
>  	size_t			count)	/* size of data to zero		*/
>  {
> @@ -140,7 +140,7 @@ xfs_iozero(
>  	struct address_space	*mapping;
>  	int			status;
>  
> -	mapping = ip->i_mapping;
> +	mapping = ip->i_vnode->i_mapping;
>  	do {
>  		unsigned long index, offset;
>  
> @@ -400,20 +400,19 @@ xfs_splice_write(
>   */
>  STATIC int				/* error (positive) */
>  xfs_zero_last_block(
> -	struct inode	*ip,
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_fsize_t	offset,
>  	xfs_fsize_t	isize)
>  {
>  	xfs_fileoff_t	last_fsb;
> -	xfs_mount_t	*mp = io->io_mount;
> +	xfs_mount_t	*mp = ip->i_mount;
>  	int		nimaps;
>  	int		zero_offset;
>  	int		zero_len;
>  	int		error = 0;
>  	xfs_bmbt_irec_t	imap;
>  
> -	ASSERT(ismrlocked(io->io_lock, MR_UPDATE) != 0);
> +	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE) != 0);
>  
>  	zero_offset = XFS_B_FSB_OFFSET(mp, isize);
>  	if (zero_offset == 0) {
> @@ -426,7 +425,7 @@ xfs_zero_last_block(
>  
>  	last_fsb = XFS_B_TO_FSBT(mp, isize);
>  	nimaps = 1;
> -	error = XFS_BMAPI(mp, NULL, io, last_fsb, 1, 0, NULL, 0, &imap,
> +	error = xfs_bmapi(NULL, ip, last_fsb, 1, 0, NULL, 0, &imap,
>  			  &nimaps, NULL, NULL);
>  	if (error) {
>  		return error;
> @@ -444,14 +443,14 @@ xfs_zero_last_block(
>  	 * out sync.  We need to drop the ilock while we do this so we
>  	 * don't deadlock when the buffer cache calls back to us.
>  	 */
> -	XFS_IUNLOCK(mp, io, XFS_ILOCK_EXCL| XFS_EXTSIZE_RD);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL| XFS_EXTSIZE_RD);
>  
>  	zero_len = mp->m_sb.sb_blocksize - zero_offset;
>  	if (isize + zero_len > offset)
>  		zero_len = offset - isize;
>  	error = xfs_iozero(ip, isize, zero_len);
>  
> -	XFS_ILOCK(mp, io, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
> +	xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
>  	ASSERT(error >= 0);
>  	return error;
>  }
> @@ -469,12 +468,11 @@ xfs_zero_last_block(
>  
>  int					/* error (positive) */
>  xfs_zero_eof(
> -	bhv_vnode_t	*vp,
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_off_t	offset,		/* starting I/O offset */
>  	xfs_fsize_t	isize)		/* current inode size */
>  {
> -	struct inode	*ip = vn_to_inode(vp);
> +	xfs_iocore_t	*io = &ip->i_iocore;
>  	xfs_fileoff_t	start_zero_fsb;
>  	xfs_fileoff_t	end_zero_fsb;
>  	xfs_fileoff_t	zero_count_fsb;
> @@ -494,7 +492,7 @@ xfs_zero_eof(
>  	 * First handle zeroing the block on which isize resides.
>  	 * We only zero a part of that block so it is handled specially.
>  	 */
> -	error = xfs_zero_last_block(ip, io, offset, isize);
> +	error = xfs_zero_last_block(ip, offset, isize);
>  	if (error) {
>  		ASSERT(ismrlocked(io->io_lock, MR_UPDATE));
>  		ASSERT(ismrlocked(io->io_iolock, MR_UPDATE));
> @@ -525,7 +523,7 @@ xfs_zero_eof(
>  	while (start_zero_fsb <= end_zero_fsb) {
>  		nimaps = 1;
>  		zero_count_fsb = end_zero_fsb - start_zero_fsb + 1;
> -		error = XFS_BMAPI(mp, NULL, io, start_zero_fsb, zero_count_fsb,
> +		error = xfs_bmapi(NULL, ip, start_zero_fsb, zero_count_fsb,
>  				  0, NULL, 0, &imap, &nimaps, NULL, NULL);
>  		if (error) {
>  			ASSERT(ismrlocked(io->io_lock, MR_UPDATE));
> @@ -553,7 +551,7 @@ xfs_zero_eof(
>  		 * Drop the inode lock while we're doing the I/O.
>  		 * We'll still have the iolock to protect us.
>  		 */
> -		XFS_IUNLOCK(mp, io, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
>  
>  		zero_off = XFS_FSB_TO_B(mp, start_zero_fsb);
>  		zero_len = XFS_FSB_TO_B(mp, imap.br_blockcount);
> @@ -569,14 +567,13 @@ xfs_zero_eof(
>  		start_zero_fsb = imap.br_startoff + imap.br_blockcount;
>  		ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
>  
> -		XFS_ILOCK(mp, io, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
> +		xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
>  	}
>  
>  	return 0;
>  
>  out_lock:
> -
> -	XFS_ILOCK(mp, io, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
> +	xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
>  	ASSERT(error >= 0);
>  	return error;
>  }
> @@ -717,7 +714,7 @@ start:
>  	 */
>  
>  	if (pos > xip->i_size) {
> -		error = xfs_zero_eof(vp, io, pos, xip->i_size);
> +		error = xfs_zero_eof(xip, pos, xip->i_size);
>  		if (error) {
>  			xfs_iunlock(xip, XFS_ILOCK_EXCL);
>  			goto out_unlock_internal;
> @@ -762,7 +759,7 @@ retry:
>  
>  		if (need_i_mutex) {
>  			/* demote the lock now the cached pages are gone */
> -			XFS_ILOCK_DEMOTE(mp, io, XFS_IOLOCK_EXCL);
> +			xfs_ilock_demote(xip, XFS_IOLOCK_EXCL);
>  			mutex_unlock(&inode->i_mutex);
>  
>  			iolock = XFS_IOLOCK_SHARED;
> @@ -905,25 +902,6 @@ xfs_bdstrat_cb(struct xfs_buf *bp)
>  	}
>  }
>  
> -
> -int
> -xfs_bmap(
> -	xfs_inode_t	*ip,
> -	xfs_off_t	offset,
> -	ssize_t		count,
> -	int		flags,
> -	xfs_iomap_t	*iomapp,
> -	int		*niomaps)
> -{
> -	xfs_iocore_t	*io = &ip->i_iocore;
> -
> -	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
> -	ASSERT(((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) != 0) ==
> -	       ((ip->i_iocore.io_flags & XFS_IOCORE_RT) != 0));
> -
> -	return xfs_iomap(io, offset, count, flags, iomapp, niomaps);
> -}
> -
>  /*
>   * Wrapper around bdstrat so that we can stop data
>   * from going to disk in case we are shutting down the filesystem.
> Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c	2007-09-18 16:34:31.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iomap.c	2007-09-18 16:37:22.000000000 +0200
> @@ -53,11 +53,11 @@
>  void
>  xfs_iomap_enter_trace(
>  	int		tag,
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_off_t	offset,
>  	ssize_t		count)
>  {
> -	xfs_inode_t	*ip = XFS_IO_INODE(io);
> +	xfs_iocore_t	*io = &ip->i_iocore;
>  
>  	if (!ip->i_rwtrace)
>  		return;
> @@ -84,15 +84,13 @@ xfs_iomap_enter_trace(
>  void
>  xfs_iomap_map_trace(
>  	int		tag,
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_off_t	offset,
>  	ssize_t		count,
>  	xfs_iomap_t	*iomapp,
>  	xfs_bmbt_irec_t	*imapp,
>  	int		flags)
>  {
> -	xfs_inode_t	*ip = XFS_IO_INODE(io);
> -
>  	if (!ip->i_rwtrace)
>  		return;
>  
> @@ -126,7 +124,7 @@ xfs_iomap_map_trace(
>  
>  STATIC int
>  xfs_imap_to_bmap(
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_off_t	offset,
>  	xfs_bmbt_irec_t *imap,
>  	xfs_iomap_t	*iomapp,
> @@ -134,11 +132,10 @@ xfs_imap_to_bmap(
>  	int		iomaps,			/* Number of iomap entries */
>  	int		flags)
>  {
> -	xfs_mount_t	*mp;
> +	xfs_mount_t	*mp = ip->i_mount;
>  	int		pbm;
>  	xfs_fsblock_t	start_block;
>  
> -	mp = io->io_mount;
>  
>  	for (pbm = 0; imaps && pbm < iomaps; imaps--, iomapp++, imap++, pbm++) {
>  		iomapp->iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
> @@ -146,7 +143,7 @@ xfs_imap_to_bmap(
>  		iomapp->iomap_bsize = XFS_FSB_TO_B(mp, imap->br_blockcount);
>  		iomapp->iomap_flags = flags;
>  
> -		if (io->io_flags & XFS_IOCORE_RT) {
> +		if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
>  			iomapp->iomap_flags |= IOMAP_REALTIME;
>  			iomapp->iomap_target = mp->m_rtdev_targp;
>  		} else {
> @@ -160,7 +157,7 @@ xfs_imap_to_bmap(
>  			iomapp->iomap_bn = IOMAP_DADDR_NULL;
>  			iomapp->iomap_flags |= IOMAP_DELAY;
>  		} else {
> -			iomapp->iomap_bn = XFS_FSB_TO_DB_IO(io, start_block);
> +			iomapp->iomap_bn = XFS_FSB_TO_DB(ip, start_block);
>  			if (ISUNWRITTEN(imap))
>  				iomapp->iomap_flags |= IOMAP_UNWRITTEN;
>  		}
> @@ -172,14 +169,14 @@ xfs_imap_to_bmap(
>  
>  int
>  xfs_iomap(
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_off_t	offset,
>  	ssize_t		count,
>  	int		flags,
>  	xfs_iomap_t	*iomapp,
>  	int		*niomaps)
>  {
> -	xfs_mount_t	*mp = io->io_mount;
> +	xfs_mount_t	*mp = ip->i_mount;
>  	xfs_fileoff_t	offset_fsb, end_fsb;
>  	int		error = 0;
>  	int		lockmode = 0;
> @@ -188,32 +185,37 @@ xfs_iomap(
>  	int		bmapi_flags = 0;
>  	int		iomap_flags = 0;
>  
> +	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
> +	ASSERT(((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) != 0) ==
> +	       ((ip->i_iocore.io_flags & XFS_IOCORE_RT) != 0));
> +
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return XFS_ERROR(EIO);
>  
>  	switch (flags & (BMAPI_READ | BMAPI_WRITE | BMAPI_ALLOCATE)) {
>  	case BMAPI_READ:
> -		xfs_iomap_enter_trace(XFS_IOMAP_READ_ENTER, io, offset, count);
> -		lockmode = XFS_LCK_MAP_SHARED(mp, io);
> +		xfs_iomap_enter_trace(XFS_IOMAP_READ_ENTER, ip, offset, count);
> +		lockmode = xfs_ilock_map_shared(ip);
>  		bmapi_flags = XFS_BMAPI_ENTIRE;
>  		break;
>  	case BMAPI_WRITE:
> -		xfs_iomap_enter_trace(XFS_IOMAP_WRITE_ENTER, io, offset, count);
> +		xfs_iomap_enter_trace(XFS_IOMAP_WRITE_ENTER, ip, offset, count);
>  		lockmode = XFS_ILOCK_EXCL|XFS_EXTSIZE_WR;
>  		if (flags & BMAPI_IGNSTATE)
>  			bmapi_flags |= XFS_BMAPI_IGSTATE|XFS_BMAPI_ENTIRE;
> -		XFS_ILOCK(mp, io, lockmode);
> +		xfs_ilock(ip, lockmode);
>  		break;
>  	case BMAPI_ALLOCATE:
> -		xfs_iomap_enter_trace(XFS_IOMAP_ALLOC_ENTER, io, offset, count);
> +		xfs_iomap_enter_trace(XFS_IOMAP_ALLOC_ENTER, ip, offset, count);
>  		lockmode = XFS_ILOCK_SHARED|XFS_EXTSIZE_RD;
>  		bmapi_flags = XFS_BMAPI_ENTIRE;
> +
>  		/* Attempt non-blocking lock */
>  		if (flags & BMAPI_TRYLOCK) {
> -			if (!XFS_ILOCK_NOWAIT(mp, io, lockmode))
> +			if (!xfs_ilock_nowait(ip, lockmode))
>  				return XFS_ERROR(EAGAIN);
>  		} else {
> -			XFS_ILOCK(mp, io, lockmode);
> +			xfs_ilock(ip, lockmode);
>  		}
>  		break;
>  	default:
> @@ -226,7 +228,7 @@ xfs_iomap(
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
> -	error = XFS_BMAPI(mp, NULL, io, offset_fsb,
> +	error = xfs_bmapi(NULL, ip, offset_fsb,
>  			(xfs_filblks_t)(end_fsb - offset_fsb),
>  			bmapi_flags,  NULL, 0, &imap,
>  			&nimaps, NULL, NULL);
> @@ -240,42 +242,42 @@ xfs_iomap(
>  		if (nimaps &&
>  		    (imap.br_startblock != HOLESTARTBLOCK) &&
>  		    (imap.br_startblock != DELAYSTARTBLOCK)) {
> -			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, io,
> +			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, ip,
>  					offset, count, iomapp, &imap, flags);
>  			break;
>  		}
>  
>  		if (flags & (BMAPI_DIRECT|BMAPI_MMAP)) {
> -			error = XFS_IOMAP_WRITE_DIRECT(mp, io, offset,
> -					count, flags, &imap, &nimaps, nimaps);
> +			error = xfs_iomap_write_direct(ip, offset, count, flags,
> +						       &imap, &nimaps, nimaps);
>  		} else {
> -			error = XFS_IOMAP_WRITE_DELAY(mp, io, offset, count,
> -					flags, &imap, &nimaps);
> +			error = xfs_iomap_write_delay(ip, offset, count, flags,
> +						      &imap, &nimaps);
>  		}
>  		if (!error) {
> -			xfs_iomap_map_trace(XFS_IOMAP_ALLOC_MAP, io,
> +			xfs_iomap_map_trace(XFS_IOMAP_ALLOC_MAP, ip,
>  					offset, count, iomapp, &imap, flags);
>  		}
>  		iomap_flags = IOMAP_NEW;
>  		break;
>  	case BMAPI_ALLOCATE:
>  		/* If we found an extent, return it */
> -		XFS_IUNLOCK(mp, io, lockmode);
> +		xfs_iunlock(ip, lockmode);
>  		lockmode = 0;
>  
>  		if (nimaps && !ISNULLSTARTBLOCK(imap.br_startblock)) {
> -			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, io,
> +			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, ip,
>  					offset, count, iomapp, &imap, flags);
>  			break;
>  		}
>  
> -		error = XFS_IOMAP_WRITE_ALLOCATE(mp, io, offset, count,
> +		error = xfs_iomap_write_allocate(ip, offset, count,
>  						 &imap, &nimaps);
>  		break;
>  	}
>  
>  	if (nimaps) {
> -		*niomaps = xfs_imap_to_bmap(io, offset, &imap,
> +		*niomaps = xfs_imap_to_bmap(ip, offset, &imap,
>  					    iomapp, nimaps, *niomaps, iomap_flags);
>  	} else if (niomaps) {
>  		*niomaps = 0;
> @@ -283,14 +285,15 @@ xfs_iomap(
>  
>  out:
>  	if (lockmode)
> -		XFS_IUNLOCK(mp, io, lockmode);
> +		xfs_iunlock(ip, lockmode);
>  	return XFS_ERROR(error);
>  }
>  
> +
>  STATIC int
>  xfs_iomap_eof_align_last_fsb(
>  	xfs_mount_t	*mp,
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_fsize_t	isize,
>  	xfs_extlen_t	extsize,
>  	xfs_fileoff_t	*last_fsb)
> @@ -299,7 +302,7 @@ xfs_iomap_eof_align_last_fsb(
>  	xfs_extlen_t	align;
>  	int		eof, error;
>  
> -	if (io->io_flags & XFS_IOCORE_RT)
> +	if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
>  		;
>  	/*
>  	 * If mounted with the "-o swalloc" option, roundup the allocation
> @@ -330,7 +333,7 @@ xfs_iomap_eof_align_last_fsb(
>  	}
>  
>  	if (new_last_fsb) {
> -		error = XFS_BMAP_EOF(mp, io, new_last_fsb, XFS_DATA_FORK, &eof);
> +		error = xfs_bmap_eof(ip, new_last_fsb, XFS_DATA_FORK, &eof);
>  		if (error)
>  			return error;
>  		if (eof)
> @@ -435,7 +438,7 @@ xfs_iomap_write_direct(
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
>  	if ((offset + count) > isize) {
> -		error = xfs_iomap_eof_align_last_fsb(mp, io, isize, extsz,
> +		error = xfs_iomap_eof_align_last_fsb(mp, ip, isize, extsz,
>  							&last_fsb);
>  		if (error)
>  			goto error_out;
> @@ -502,7 +505,7 @@ xfs_iomap_write_direct(
>  	 */
>  	XFS_BMAP_INIT(&free_list, &firstfsb);
>  	nimaps = 1;
> -	error = XFS_BMAPI(mp, tp, io, offset_fsb, count_fsb, bmapi_flag,
> +	error = xfs_bmapi(tp, ip, offset_fsb, count_fsb, bmapi_flag,
>  		&firstfsb, 0, &imap, &nimaps, &free_list, NULL);
>  	if (error)
>  		goto error0;
> @@ -560,7 +563,7 @@ error_out:
>  STATIC int
>  xfs_iomap_eof_want_preallocate(
>  	xfs_mount_t	*mp,
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_fsize_t	isize,
>  	xfs_off_t	offset,
>  	size_t		count,
> @@ -587,7 +590,7 @@ xfs_iomap_eof_want_preallocate(
>  	while (count_fsb > 0) {
>  		imaps = nimaps;
>  		firstblock = NULLFSBLOCK;
> -		error = XFS_BMAPI(mp, NULL, io, start_fsb, count_fsb, 0,
> +		error = xfs_bmapi(NULL, ip, start_fsb, count_fsb, 0,
>  				  &firstblock, 0, imap, &imaps, NULL, NULL);
>  		if (error)
>  			return error;
> @@ -644,7 +647,7 @@ retry:
>  	if (io->io_new_size > isize)
>  		isize = io->io_new_size;
>  
> -	error = xfs_iomap_eof_want_preallocate(mp, io, isize, offset, count,
> +	error = xfs_iomap_eof_want_preallocate(mp, ip, isize, offset, count,
>  				ioflag, imap, XFS_WRITE_IMAPS, &prealloc);
>  	if (error)
>  		return error;
> @@ -658,7 +661,7 @@ retry:
>  	}
>  
>  	if (prealloc || extsz) {
> -		error = xfs_iomap_eof_align_last_fsb(mp, io, isize, extsz,
> +		error = xfs_iomap_eof_align_last_fsb(mp, ip, isize, extsz,
>  							&last_fsb);
>  		if (error)
>  			return error;
> @@ -666,7 +669,7 @@ retry:
>  
>  	nimaps = XFS_WRITE_IMAPS;
>  	firstblock = NULLFSBLOCK;
> -	error = XFS_BMAPI(mp, NULL, io, offset_fsb,
> +	error = xfs_bmapi(NULL, ip, offset_fsb,
>  			  (xfs_filblks_t)(last_fsb - offset_fsb),
>  			  XFS_BMAPI_DELAY | XFS_BMAPI_WRITE |
>  			  XFS_BMAPI_ENTIRE, &firstblock, 1, imap,
> @@ -680,7 +683,7 @@ retry:
>  	 */
>  	if (nimaps == 0) {
>  		xfs_iomap_enter_trace(XFS_IOMAP_WRITE_NOSPACE,
> -					io, offset, count);
> +					ip, offset, count);
>  		if (xfs_flush_space(ip, &fsynced, &ioflag))
>  			return XFS_ERROR(ENOSPC);
>  
> @@ -788,7 +791,7 @@ xfs_iomap_write_allocate(
>  			}
>  
>  			/* Go get the actual blocks */
> -			error = XFS_BMAPI(mp, tp, io, map_start_fsb, count_fsb,
> +			error = xfs_bmapi(tp, ip, map_start_fsb, count_fsb,
>  					XFS_BMAPI_WRITE, &first_block, 1,
>  					imap, &nimaps, &free_list, NULL);
>  			if (error)
> @@ -860,8 +863,7 @@ xfs_iomap_write_unwritten(
>  	int		committed;
>  	int		error;
>  
> -	xfs_iomap_enter_trace(XFS_IOMAP_UNWRITTEN,
> -				&ip->i_iocore, offset, count);
> +	xfs_iomap_enter_trace(XFS_IOMAP_UNWRITTEN, ip, offset, count);
>  
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
> @@ -895,7 +897,7 @@ xfs_iomap_write_unwritten(
>  		 */
>  		XFS_BMAP_INIT(&free_list, &firstfsb);
>  		nimaps = 1;
> -		error = XFS_BMAPI(mp, tp, io, offset_fsb, count_fsb,
> +		error = xfs_bmapi(tp, ip, offset_fsb, count_fsb,
>  				  XFS_BMAPI_WRITE|XFS_BMAPI_CONVERT, &firstfsb,
>  				  1, &imap, &nimaps, &free_list, NULL);
>  		if (error)
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-09-16 13:51:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-09-18 16:37:22.000000000 +0200
> @@ -248,8 +248,6 @@ EXPORT_SYMBOL(xfs_ilock_nowait);
>  EXPORT_SYMBOL(xfs_inode_lock_init);
>  EXPORT_SYMBOL(xfs_internal_inum);
>  EXPORT_SYMBOL(xfs_iocore_inode_init);
> -EXPORT_SYMBOL(xfs_iocore_xfs);
> -EXPORT_SYMBOL(xfs_iomap);
>  EXPORT_SYMBOL(xfs_iput);
>  EXPORT_SYMBOL(xfs_iput_new);
>  EXPORT_SYMBOL(xfs_iread);
> Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2007-09-16 13:51:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2007-09-18 16:37:38.000000000 +0200
> @@ -111,7 +111,7 @@ xfs_swapext(
>  		goto error0;
>  	}
>  
> -	error = XFS_SWAP_EXTENTS(mp, &ip->i_iocore, &tip->i_iocore, sxp);
> +	error = xfs_swap_extents(ip, tip, sxp);
>  
>   error0:
>  	if (fp != NULL)
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-09-16 13:51:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-09-18 16:43:12.000000000 +0200
> @@ -1709,7 +1709,7 @@ xfs_itruncate_finish(
>  		 * runs.
>  		 */
>  		XFS_BMAP_INIT(&free_list, &first_block);
> -		error = XFS_BUNMAPI(mp, ntp, &ip->i_iocore,
> +		error = xfs_bunmapi(ntp, ip,
>  				    first_unmap_block, unmap_len,
>  				    XFS_BMAPI_AFLAG(fork) |
>  				      (sync ? 0 : XFS_BMAPI_ASYNC),
> @@ -1842,8 +1842,6 @@ xfs_igrow_start(
>  	xfs_fsize_t	new_size,
>  	cred_t		*credp)
>  {
> -	int		error;
> -
>  	ASSERT(ismrlocked(&(ip->i_lock), MR_UPDATE) != 0);
>  	ASSERT(ismrlocked(&(ip->i_iolock), MR_UPDATE) != 0);
>  	ASSERT(new_size > ip->i_size);
> @@ -1853,9 +1851,7 @@ xfs_igrow_start(
>  	 * xfs_write_file() beyond the end of the file
>  	 * and any blocks between the old and new file sizes.
>  	 */
> -	error = xfs_zero_eof(XFS_ITOV(ip), &ip->i_iocore, new_size,
> -			     ip->i_size);
> -	return error;
> +	return xfs_zero_eof(ip, new_size, ip->i_size);
>  }
>  
>  /*
> Index: linux-2.6-xfs/fs/xfs/xfs_iocore.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iocore.c	2007-09-16 13:51:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iocore.c	2007-09-18 16:37:22.000000000 +0200
> @@ -47,46 +47,6 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_iomap.h"
>  
> -
> -STATIC xfs_fsize_t
> -xfs_size_fn(
> -	xfs_inode_t		*ip)
> -{
> -	return XFS_ISIZE(ip);
> -}
> -
> -STATIC int
> -xfs_ioinit(
> -	struct xfs_mount	*mp,
> -	struct xfs_mount_args	*mntargs,
> -	int			flags)
> -{
> -	return xfs_mountfs(mp, flags);
> -}
> -
> -xfs_ioops_t	xfs_iocore_xfs = {
> -	.xfs_ioinit		= (xfs_ioinit_t) xfs_ioinit,
> -	.xfs_bmapi_func		= (xfs_bmapi_t) xfs_bmapi,
> -	.xfs_bunmapi_func	= (xfs_bunmapi_t) xfs_bunmapi,
> -	.xfs_bmap_eof_func	= (xfs_bmap_eof_t) xfs_bmap_eof,
> -	.xfs_iomap_write_direct =
> -			(xfs_iomap_write_direct_t) xfs_iomap_write_direct,
> -	.xfs_iomap_write_delay =
> -			(xfs_iomap_write_delay_t) xfs_iomap_write_delay,
> -	.xfs_iomap_write_allocate =
> -			(xfs_iomap_write_allocate_t) xfs_iomap_write_allocate,
> -	.xfs_iomap_write_unwritten =
> -			(xfs_iomap_write_unwritten_t) xfs_iomap_write_unwritten,
> -	.xfs_ilock		= (xfs_lock_t) xfs_ilock,
> -	.xfs_lck_map_shared	= (xfs_lck_map_shared_t) xfs_ilock_map_shared,
> -	.xfs_ilock_demote	= (xfs_lock_demote_t) xfs_ilock_demote,
> -	.xfs_ilock_nowait	= (xfs_lock_nowait_t) xfs_ilock_nowait,
> -	.xfs_unlock		= (xfs_unlk_t) xfs_iunlock,
> -	.xfs_size_func		= (xfs_size_t) xfs_size_fn,
> -	.xfs_iodone		= (xfs_iodone_t) fs_noerr,
> -	.xfs_swap_extents_func	= (xfs_swap_extents_t) xfs_swap_extents,
> -};
> -
>  void
>  xfs_iocore_inode_reinit(
>  	xfs_inode_t	*ip)
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-09-18 16:34:38.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-09-18 16:36:30.000000000 +0200
> @@ -1307,7 +1307,6 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
>  #if defined(DEBUG) || defined(INDUCE_IO_ERROR)
>  	xfs_errortag_clearall(mp, 0);
>  #endif
> -	XFS_IODONE(mp);
>  	xfs_mount_free(mp);
>  	return 0;
>  }
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-09-16 13:51:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-09-18 16:37:22.000000000 +0200
> @@ -196,105 +196,6 @@ typedef struct xfs_qmops {
>  #define XFS_QM_QUOTACTL(mp, cmd, id, addr) \
>  	(*(mp)->m_qm_ops->xfs_quotactl)(mp, cmd, id, addr)
>  
> -
> -/*
> - * Prototypes and functions for I/O core modularization.
> - */
> -
> -typedef int		(*xfs_ioinit_t)(struct xfs_mount *,
> -				struct xfs_mount_args *, int);
> -typedef int		(*xfs_bmapi_t)(struct xfs_trans *, void *,
> -				xfs_fileoff_t, xfs_filblks_t, int,
> -				xfs_fsblock_t *, xfs_extlen_t,
> -				struct xfs_bmbt_irec *, int *,
> -				struct xfs_bmap_free *, struct xfs_extdelta *);
> -typedef int		(*xfs_bunmapi_t)(struct xfs_trans *,
> -				void *, xfs_fileoff_t,
> -				xfs_filblks_t, int, xfs_extnum_t,
> -				xfs_fsblock_t *, struct xfs_bmap_free *,
> -				struct xfs_extdelta *, int *);
> -typedef int		(*xfs_bmap_eof_t)(void *, xfs_fileoff_t, int, int *);
> -typedef int		(*xfs_iomap_write_direct_t)(
> -				void *, xfs_off_t, size_t, int,
> -				struct xfs_bmbt_irec *, int *, int);
> -typedef int		(*xfs_iomap_write_delay_t)(
> -				void *, xfs_off_t, size_t, int,
> -				struct xfs_bmbt_irec *, int *);
> -typedef int		(*xfs_iomap_write_allocate_t)(
> -				void *, xfs_off_t, size_t,
> -				struct xfs_bmbt_irec *, int *);
> -typedef int		(*xfs_iomap_write_unwritten_t)(
> -				void *, xfs_off_t, size_t);
> -typedef uint		(*xfs_lck_map_shared_t)(void *);
> -typedef void		(*xfs_lock_t)(void *, uint);
> -typedef void		(*xfs_lock_demote_t)(void *, uint);
> -typedef int		(*xfs_lock_nowait_t)(void *, uint);
> -typedef void		(*xfs_unlk_t)(void *, unsigned int);
> -typedef xfs_fsize_t	(*xfs_size_t)(void *);
> -typedef xfs_fsize_t	(*xfs_iodone_t)(struct xfs_mount *);
> -typedef int		(*xfs_swap_extents_t)(void *, void *,
> -				struct xfs_swapext*);
> -
> -typedef struct xfs_ioops {
> -	xfs_ioinit_t			xfs_ioinit;
> -	xfs_bmapi_t			xfs_bmapi_func;
> -	xfs_bunmapi_t			xfs_bunmapi_func;
> -	xfs_bmap_eof_t			xfs_bmap_eof_func;
> -	xfs_iomap_write_direct_t	xfs_iomap_write_direct;
> -	xfs_iomap_write_delay_t		xfs_iomap_write_delay;
> -	xfs_iomap_write_allocate_t	xfs_iomap_write_allocate;
> -	xfs_iomap_write_unwritten_t	xfs_iomap_write_unwritten;
> -	xfs_lock_t			xfs_ilock;
> -	xfs_lck_map_shared_t		xfs_lck_map_shared;
> -	xfs_lock_demote_t		xfs_ilock_demote;
> -	xfs_lock_nowait_t		xfs_ilock_nowait;
> -	xfs_unlk_t			xfs_unlock;
> -	xfs_size_t			xfs_size_func;
> -	xfs_iodone_t			xfs_iodone;
> -	xfs_swap_extents_t		xfs_swap_extents_func;
> -} xfs_ioops_t;
> -
> -#define XFS_IOINIT(mp, args, flags) \
> -	(*(mp)->m_io_ops.xfs_ioinit)(mp, args, flags)
> -#define XFS_BMAPI(mp, trans,io,bno,len,f,first,tot,mval,nmap,flist,delta) \
> -	(*(mp)->m_io_ops.xfs_bmapi_func) \
> -		(trans,(io)->io_obj,bno,len,f,first,tot,mval,nmap,flist,delta)
> -#define XFS_BUNMAPI(mp, trans,io,bno,len,f,nexts,first,flist,delta,done) \
> -	(*(mp)->m_io_ops.xfs_bunmapi_func) \
> -		(trans,(io)->io_obj,bno,len,f,nexts,first,flist,delta,done)
> -#define XFS_BMAP_EOF(mp, io, endoff, whichfork, eof) \
> -	(*(mp)->m_io_ops.xfs_bmap_eof_func) \
> -		((io)->io_obj, endoff, whichfork, eof)
> -#define XFS_IOMAP_WRITE_DIRECT(mp, io, offset, count, flags, mval, nmap, found)\
> -	(*(mp)->m_io_ops.xfs_iomap_write_direct) \
> -		((io)->io_obj, offset, count, flags, mval, nmap, found)
> -#define XFS_IOMAP_WRITE_DELAY(mp, io, offset, count, flags, mval, nmap) \
> -	(*(mp)->m_io_ops.xfs_iomap_write_delay) \
> -		((io)->io_obj, offset, count, flags, mval, nmap)
> -#define XFS_IOMAP_WRITE_ALLOCATE(mp, io, offset, count, mval, nmap) \
> -	(*(mp)->m_io_ops.xfs_iomap_write_allocate) \
> -		((io)->io_obj, offset, count, mval, nmap)
> -#define XFS_IOMAP_WRITE_UNWRITTEN(mp, io, offset, count) \
> -	(*(mp)->m_io_ops.xfs_iomap_write_unwritten) \
> -		((io)->io_obj, offset, count)
> -#define XFS_LCK_MAP_SHARED(mp, io) \
> -	(*(mp)->m_io_ops.xfs_lck_map_shared)((io)->io_obj)
> -#define XFS_ILOCK(mp, io, mode) \
> -	(*(mp)->m_io_ops.xfs_ilock)((io)->io_obj, mode)
> -#define XFS_ILOCK_NOWAIT(mp, io, mode) \
> -	(*(mp)->m_io_ops.xfs_ilock_nowait)((io)->io_obj, mode)
> -#define XFS_IUNLOCK(mp, io, mode) \
> -	(*(mp)->m_io_ops.xfs_unlock)((io)->io_obj, mode)
> -#define XFS_ILOCK_DEMOTE(mp, io, mode) \
> -	(*(mp)->m_io_ops.xfs_ilock_demote)((io)->io_obj, mode)
> -#define XFS_SIZE(mp, io) \
> -	(*(mp)->m_io_ops.xfs_size_func)((io)->io_obj)
> -#define XFS_IODONE(mp) \
> -	(*(mp)->m_io_ops.xfs_iodone)(mp)
> -#define XFS_SWAP_EXTENTS(mp, io, tio, sxp) \
> -	(*(mp)->m_io_ops.xfs_swap_extents_func) \
> -		((io)->io_obj, (tio)->io_obj, sxp)
> -
>  #ifdef HAVE_PERCPU_SB
>  
>  /*
> @@ -423,7 +324,6 @@ typedef struct xfs_mount {
>  						 * hash table */
>  	struct xfs_dmops	*m_dm_ops;	/* vector of DMI ops */
>  	struct xfs_qmops	*m_qm_ops;	/* vector of XQM ops */
> -	struct xfs_ioops	m_io_ops;	/* vector of I/O ops */
>  	atomic_t		m_active_trans;	/* number trans frozen */
>  #ifdef HAVE_PERCPU_SB
>  	xfs_icsb_cnts_t		*m_sb_cnts;	/* per-cpu superblock counters */
> @@ -646,7 +546,6 @@ extern int	xfs_qmops_get(struct xfs_moun
>  extern void	xfs_qmops_put(struct xfs_mount *);
>  
>  extern struct xfs_dmops xfs_dmcore_xfs;
> -extern struct xfs_ioops xfs_iocore_xfs;
>  
>  extern int	xfs_init(void);
>  extern void	xfs_cleanup(void);
> Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-09-16 13:51:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-09-18 16:36:30.000000000 +0200
> @@ -449,8 +449,6 @@ xfs_mount(
>  	if (error)
>  		return error;
>  
> -	mp->m_io_ops = xfs_iocore_xfs;
> -
>  	if (args->flags & XFSMNT_QUIET)
>  		flags |= XFS_MFSI_QUIET;
>  
> @@ -544,7 +542,7 @@ xfs_mount(
>  	if ((error = xfs_filestream_mount(mp)))
>  		goto error2;
>  
> -	error = XFS_IOINIT(mp, args, flags);
> +	error = xfs_mountfs(mp, flags);
>  	if (error)
>  		goto error2;
>  
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-09-16 13:51:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-09-18 16:37:22.000000000 +0200
> @@ -1187,7 +1187,7 @@ xfs_free_eofblocks(
>  
>  	nimaps = 1;
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	error = XFS_BMAPI(mp, NULL, &ip->i_iocore, end_fsb, map_len, 0,
> +	error = xfs_bmapi(NULL, ip, end_fsb, map_len, 0,
>  			  NULL, 0, &imap, &nimaps, NULL, NULL);
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
> @@ -3983,7 +3983,7 @@ retry:
>  		 * Issue the xfs_bmapi() call to allocate the blocks
>  		 */
>  		XFS_BMAP_INIT(&free_list, &firstfsb);
> -		error = XFS_BMAPI(mp, tp, &ip->i_iocore, startoffset_fsb,
> +		error = xfs_bmapi(tp, ip, startoffset_fsb,
>  				  allocatesize_fsb, bmapi_flag,
>  				  &firstfsb, 0, imapp, &nimaps,
>  				  &free_list, NULL);
> @@ -4065,7 +4065,7 @@ xfs_zero_remaining_bytes(
>  	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
>  		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  		nimap = 1;
> -		error = XFS_BMAPI(mp, NULL, &ip->i_iocore, offset_fsb, 1, 0,
> +		error = xfs_bmapi(NULL, ip, offset_fsb, 1, 0,
>  			NULL, 0, &imap, &nimap, NULL, NULL);
>  		if (error || nimap < 1)
>  			break;
> @@ -4200,7 +4200,7 @@ xfs_free_file_space(
>  	 */
>  	if (rt && !XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb)) {
>  		nimap = 1;
> -		error = XFS_BMAPI(mp, NULL, &ip->i_iocore, startoffset_fsb,
> +		error = xfs_bmapi(NULL, ip, startoffset_fsb,
>  			1, 0, NULL, 0, &imap, &nimap, NULL, NULL);
>  		if (error)
>  			goto out_unlock_iolock;
> @@ -4215,7 +4215,7 @@ xfs_free_file_space(
>  				startoffset_fsb += mp->m_sb.sb_rextsize - mod;
>  		}
>  		nimap = 1;
> -		error = XFS_BMAPI(mp, NULL, &ip->i_iocore, endoffset_fsb - 1,
> +		error = xfs_bmapi(NULL, ip, endoffset_fsb - 1,
>  			1, 0, NULL, 0, &imap, &nimap, NULL, NULL);
>  		if (error)
>  			goto out_unlock_iolock;
> @@ -4291,7 +4291,7 @@ xfs_free_file_space(
>  		 * issue the bunmapi() call to free the blocks
>  		 */
>  		XFS_BMAP_INIT(&free_list, &firstfsb);
> -		error = XFS_BUNMAPI(mp, tp, &ip->i_iocore, startoffset_fsb,
> +		error = xfs_bunmapi(tp, ip, startoffset_fsb,
>  				  endoffset_fsb - startoffset_fsb,
>  				  0, 2, &firstfsb, &free_list, NULL, &done);
>  		if (error) {
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-09-16 13:51:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-09-18 16:37:22.000000000 +0200
> @@ -317,7 +317,7 @@ xfs_map_blocks(
>  	xfs_inode_t		*ip = XFS_I(inode);
>  	int			error, nmaps = 1;
>  
> -	error = xfs_bmap(ip, offset, count,
> +	error = xfs_iomap(ip, offset, count,
>  				flags, mapp, &nmaps);
>  	if (!error && (flags & (BMAPI_WRITE|BMAPI_ALLOCATE)))
>  		xfs_iflags_set(ip, XFS_IMODIFIED);
> @@ -1342,7 +1342,7 @@ __xfs_get_blocks(
>  	offset = (xfs_off_t)iblock << inode->i_blkbits;
>  	ASSERT(bh_result->b_size >= (1 << inode->i_blkbits));
>  	size = bh_result->b_size;
> -	error = xfs_bmap(XFS_I(inode), offset, size,
> +	error = xfs_iomap(XFS_I(inode), offset, size,
>  			     create ? flags : BMAPI_READ, &iomap, &niomap);
>  	if (error)
>  		return -error;
> Index: linux-2.6-xfs/fs/xfs/xfs_iomap.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.h	2007-09-18 16:34:31.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iomap.h	2007-09-18 16:36:30.000000000 +0200
> @@ -71,11 +71,10 @@ typedef struct xfs_iomap {
>  	iomap_flags_t		iomap_flags;
>  } xfs_iomap_t;
>  
> -struct xfs_iocore;
>  struct xfs_inode;
>  struct xfs_bmbt_irec;
>  
> -extern int xfs_iomap(struct xfs_iocore *, xfs_off_t, ssize_t, int,
> +extern int xfs_iomap(struct xfs_inode *, xfs_off_t, ssize_t, int,
>  		     struct xfs_iomap *, int *);
>  extern int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
>  				  int, struct xfs_bmbt_irec *, int *, int);
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.h	2007-09-18 16:43:56.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h	2007-09-18 16:44:06.000000000 +0200
> @@ -72,7 +72,6 @@ extern int xfsbdstrat(struct xfs_mount *
>  extern int xfs_bdstrat_cb(struct xfs_buf *);
>  extern int xfs_dev_is_read_only(struct xfs_mount *, char *);
>  
> -extern int xfs_zero_eof(struct inode *, struct xfs_iocore *, xfs_off_t,
> -				xfs_fsize_t);
> +extern int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
>  
>  #endif	/* __XFS_LRW_H__ */
> 
