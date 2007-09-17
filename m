Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 04:13:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8HBDTuw029384
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2007 04:13:31 -0700
Message-ID: <46EE6149.8090706@sgi.com>
Date: Mon, 17 Sep 2007 21:13:13 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] kill xfs_iocore_t
References: <20070914162808.GF7110@lst.de>
In-Reply-To: <20070914162808.GF7110@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com



Christoph Hellwig wrote:
> xfs_iocore_t is a structure embedded in xfs_inode.  Except for one
> field it just duplicates fields already in xfs_inode, and there is
> nothing this abstraction buys us on XFS/Linux.  This patch removes
> it and shrinks source and binary size of xfs aswell as shrinking
> the size of xfs_inode by 60/44 bytes in debug/non-debug builds.

That's a nice saving; in-core inodes are ~ 20% smaller which really adds
up, especially on large systems caching millions of inodes.

Could splitting out the embedded xfs_icdinode_t into a separate data
structure somehow help too? AFAIK we have two xfs inode caches, so
maybe further memory optimization is feasible (out of my depth a bit
here).

Thanks
-- Mark

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/xfs/Makefile-linux-2.6
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/Makefile-linux-2.6	2007-09-12 13:12:59.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/Makefile-linux-2.6	2007-09-12 14:05:49.000000000 +0200
> @@ -60,7 +60,6 @@ xfs-y				+= xfs_alloc.o \
>  				   xfs_iget.o \
>  				   xfs_inode.o \
>  				   xfs_inode_item.o \
> -				   xfs_iocore.o \
>  				   xfs_iomap.o \
>  				   xfs_itable.o \
>  				   xfs_dfrag.o \
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-09-12 14:05:07.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-09-12 14:05:49.000000000 +0200
> @@ -187,7 +187,7 @@ xfs_dm_send_data_event(
>
>  	ip = xfs_vtoi(vp);
>  	do {
> -		dmstate = ip->i_iocore.io_dmstate;
> +		dmstate = ip->i_d.di_dmstate;
>  		if (locktype)
>  			xfs_rwunlock(ip, *locktype);
>
> @@ -201,7 +201,7 @@ xfs_dm_send_data_event(
>
>  		if (locktype)
>  			xfs_rwlock(ip, *locktype);
> -	} while (!error && (ip->i_iocore.io_dmstate != dmstate));
> +	} while (!error && (ip->i_d.di_dmstate != dmstate));
>
>  	return error;
>  }
> @@ -1017,7 +1017,6 @@ xfs_dm_f_set_eventlist(
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>
>  	ip->i_d.di_dmevmask = (eventset & max_mask) | (ip->i_d.di_dmevmask & ~max_mask);
> -	ip->i_iocore.io_dmevmask = ip->i_d.di_dmevmask;
>
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	VN_HOLD(vp);
> @@ -2597,7 +2596,7 @@ xfs_dm_punch_hole(
>  		error = -error;
>
>  	/* Let threads in send_data_event know we punched the file. */
> -	ip->i_iocore.io_dmstate++;
> +	ip->i_d.di_dmstate++;
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  	xfs_iflags_set(ip, XFS_IMODIFIED);
>
> @@ -2925,7 +2924,7 @@ xfs_dm_set_region(
>  		 * bit, then that's always okay.  Otherwise, it's busy.
>  		 */
>  		dm_eventset_t m1;
> -		m1 = ip->i_iocore.io_dmevmask & ((1 << DM_EVENT_WRITE) | (1 << DM_EVENT_TRUNCATE));
> +		m1 = ip->i_d.di_dmevmask & ((1 << DM_EVENT_WRITE) | (1 << DM_EVENT_TRUNCATE));
>  		if (m1 != new_mask) {
>  			return -EBUSY;
>  		}
> @@ -2942,7 +2941,6 @@ xfs_dm_set_region(
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>
>  	ip->i_d.di_dmevmask = (ip->i_d.di_dmevmask & ~mr_mask) | new_mask;
> -	ip->i_iocore.io_dmevmask = ip->i_d.di_dmevmask;
>
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	VN_HOLD(vp);
> @@ -3221,7 +3219,7 @@ xfs_dm_send_mmap_event(
>  	offset = 0; /* beginning of file, for now */
>  	length = 0; /* whole file, for now */
>
> -	filesize = ip->i_iocore.io_new_size;
> +	filesize = ip->i_new_size;
>  	if (filesize < ip->i_size) {
>  		filesize = ip->i_size;
>  	}
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-09-12 14:05:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-09-12 14:05:49.000000000 +0200
> @@ -163,7 +163,7 @@ xfs_destroy_ioend(
>  /*
>   * Update on-disk file size now that data has been written to disk.
>   * The current in-memory file size is i_size.  If a write is beyond
> - * eof io_new_size will be the intended file size until i_size is
> + * eof i_new_size will be the intended file size until i_size is
>   * updated.  If this write does not extend all the way to the valid
>   * file size then restrict this update to the end of the write.
>   */
> @@ -185,7 +185,7 @@ xfs_setfilesize(
>
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>
> -	isize = MAX(ip->i_size, ip->i_iocore.io_new_size);
> +	isize = MAX(ip->i_size, ip->i_new_size);
>  	isize = MIN(isize, bsize);
>
>  	if (ip->i_d.di_size < isize) {
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-09-12 14:05:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-09-12 14:05:49.000000000 +0200
> @@ -247,7 +247,6 @@ EXPORT_SYMBOL(xfs_ilock_map_shared);
>  EXPORT_SYMBOL(xfs_ilock_nowait);
>  EXPORT_SYMBOL(xfs_inode_lock_init);
>  EXPORT_SYMBOL(xfs_internal_inum);
> -EXPORT_SYMBOL(xfs_iocore_inode_init);
>  EXPORT_SYMBOL(xfs_iput);
>  EXPORT_SYMBOL(xfs_iput_new);
>  EXPORT_SYMBOL(xfs_iread);
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-09-12 14:05:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2007-09-12 14:06:32.000000000 +0200
> @@ -58,14 +58,12 @@
>  void
>  xfs_rw_enter_trace(
>  	int			tag,
> -	xfs_iocore_t		*io,
> +	xfs_inode_t		*ip,
>  	void			*data,
>  	size_t			segs,
>  	loff_t			offset,
>  	int			ioflags)
>  {
> -	xfs_inode_t	*ip = XFS_IO_INODE(io);
> -
>  	if (ip->i_rwtrace == NULL)
>  		return;
>  	ktrace_enter(ip->i_rwtrace,
> @@ -78,8 +76,8 @@ xfs_rw_enter_trace(
>  		(void *)((unsigned long)((offset >> 32) & 0xffffffff)),
>  		(void *)((unsigned long)(offset & 0xffffffff)),
>  		(void *)((unsigned long)ioflags),
> -		(void *)((unsigned long)((io->io_new_size >> 32) & 0xffffffff)),
> -		(void *)((unsigned long)(io->io_new_size & 0xffffffff)),
> +		(void *)((unsigned long)((ip->i_new_size >> 32) & 0xffffffff)),
> +		(void *)((unsigned long)(ip->i_new_size & 0xffffffff)),
>  		(void *)((unsigned long)current_pid()),
>  		(void *)NULL,
>  		(void *)NULL,
> @@ -89,13 +87,12 @@ xfs_rw_enter_trace(
>
>  void
>  xfs_inval_cached_trace(
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_off_t	offset,
>  	xfs_off_t	len,
>  	xfs_off_t	first,
>  	xfs_off_t	last)
>  {
> -	xfs_inode_t	*ip = XFS_IO_INODE(io);
>
>  	if (ip->i_rwtrace == NULL)
>  		return;
> @@ -267,7 +264,7 @@ xfs_read(
>  		}
>  	}
>
> -	xfs_rw_enter_trace(XFS_READ_ENTER, &ip->i_iocore,
> +	xfs_rw_enter_trace(XFS_READ_ENTER, ip,
>  				(void *)iovp, segs, *offset, ioflags);
>
>  	iocb->ki_pos = *offset;
> @@ -312,7 +309,7 @@ xfs_splice_read(
>  			return -error;
>  		}
>  	}
> -	xfs_rw_enter_trace(XFS_SPLICE_READ_ENTER, &ip->i_iocore,
> +	xfs_rw_enter_trace(XFS_SPLICE_READ_ENTER, ip,
>  			   pipe, count, *ppos, ioflags);
>  	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
>  	if (ret > 0)
> @@ -334,7 +331,6 @@ xfs_splice_write(
>  {
>  	bhv_vnode_t		*vp = XFS_ITOV(ip);
>  	xfs_mount_t		*mp = ip->i_mount;
> -	xfs_iocore_t		*io = &ip->i_iocore;
>  	ssize_t			ret;
>  	struct inode		*inode = outfilp->f_mapping->host;
>  	xfs_fsize_t		isize, new_size;
> @@ -361,10 +357,10 @@ xfs_splice_write(
>
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	if (new_size > ip->i_size)
> -		io->io_new_size = new_size;
> +		ip->i_new_size = new_size;
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>
> -	xfs_rw_enter_trace(XFS_SPLICE_WRITE_ENTER, &ip->i_iocore,
> +	xfs_rw_enter_trace(XFS_SPLICE_WRITE_ENTER, ip,
>  			   pipe, count, *ppos, ioflags);
>  	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
>  	if (ret > 0)
> @@ -381,9 +377,9 @@ xfs_splice_write(
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
>
> -	if (io->io_new_size) {
> +	if (ip->i_new_size) {
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		io->io_new_size = 0;
> +		ip->i_new_size = 0;
>  		if (ip->i_d.di_size > ip->i_size)
>  			ip->i_d.di_size = ip->i_size;
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -469,26 +465,24 @@ xfs_zero_last_block(
>
>  int					/* error (positive) */
>  xfs_zero_eof(
> -	bhv_vnode_t	*vp,
> -	xfs_iocore_t	*io,
> +	xfs_inode_t	*ip,
>  	xfs_off_t	offset,		/* starting I/O offset */
>  	xfs_fsize_t	isize)		/* current inode size */
>  {
> -	struct inode	*inode = vn_to_inode(vp);
> -	xfs_inode_t	*ip = XFS_I(inode);
> +	struct inode	*inode = XFS_ITOV(ip);
>  	xfs_fileoff_t	start_zero_fsb;
>  	xfs_fileoff_t	end_zero_fsb;
>  	xfs_fileoff_t	zero_count_fsb;
>  	xfs_fileoff_t	last_fsb;
>  	xfs_fileoff_t	zero_off;
>  	xfs_fsize_t	zero_len;
> -	xfs_mount_t	*mp = io->io_mount;
> +	xfs_mount_t	*mp = ip->i_mount;
>  	int		nimaps;
>  	int		error = 0;
>  	xfs_bmbt_irec_t	imap;
>
> -	ASSERT(ismrlocked(io->io_lock, MR_UPDATE));
> -	ASSERT(ismrlocked(io->io_iolock, MR_UPDATE));
> +	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
> +	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
>  	ASSERT(offset > isize);
>
>  	/*
> @@ -497,8 +491,8 @@ xfs_zero_eof(
>  	 */
>  	error = xfs_zero_last_block(inode, ip, offset, isize);
>  	if (error) {
> -		ASSERT(ismrlocked(io->io_lock, MR_UPDATE));
> -		ASSERT(ismrlocked(io->io_iolock, MR_UPDATE));
> +		ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
> +		ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
>  		return error;
>  	}
>
> @@ -529,8 +523,8 @@ xfs_zero_eof(
>  		error = xfs_bmapi(NULL, ip, start_zero_fsb, zero_count_fsb,
>  				  0, NULL, 0, &imap, &nimaps, NULL, NULL);
>  		if (error) {
> -			ASSERT(ismrlocked(io->io_lock, MR_UPDATE));
> -			ASSERT(ismrlocked(io->io_iolock, MR_UPDATE));
> +			ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
> +			ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
>  			return error;
>  		}
>  		ASSERT(nimaps > 0);
> @@ -598,7 +592,6 @@ xfs_write(
>  	xfs_mount_t		*mp;
>  	ssize_t			ret = 0, error = 0;
>  	xfs_fsize_t		isize, new_size;
> -	xfs_iocore_t		*io;
>  	int			iolock;
>  	int			eventsent = 0;
>  	bhv_vrwlock_t		locktype;
> @@ -618,8 +611,7 @@ xfs_write(
>  	if (count == 0)
>  		return 0;
>
> -	io = &xip->i_iocore;
> -	mp = io->io_mount;
> +	mp = xip->i_mount;
>
>  	xfs_wait_for_freeze(mp, SB_FREEZE_WRITE);
>
> @@ -699,7 +691,7 @@ start:
>
>  	new_size = pos + count;
>  	if (new_size > xip->i_size)
> -		io->io_new_size = new_size;
> +		xip->i_new_size = new_size;
>
>  	if (likely(!(ioflags & IO_INVIS))) {
>  		file_update_time(file);
> @@ -717,7 +709,7 @@ start:
>  	 */
>
>  	if (pos > xip->i_size) {
> -		error = xfs_zero_eof(vp, io, pos, xip->i_size);
> +		error = xfs_zero_eof(xip, pos, xip->i_size);
>  		if (error) {
>  			xfs_iunlock(xip, XFS_ILOCK_EXCL);
>  			goto out_unlock_internal;
> @@ -751,7 +743,7 @@ retry:
>  	if ((ioflags & IO_ISDIRECT)) {
>  		if (VN_CACHED(vp)) {
>  			WARN_ON(need_i_mutex == 0);
> -			xfs_inval_cached_trace(io, pos, -1,
> +			xfs_inval_cached_trace(xip, pos, -1,
>  					ctooff(offtoct(pos)), -1);
>  			error = xfs_flushinval_pages(xip,
>  					ctooff(offtoct(pos)),
> @@ -770,7 +762,7 @@ retry:
>  			need_i_mutex = 0;
>  		}
>
> - 		xfs_rw_enter_trace(XFS_DIOWR_ENTER, io, (void *)iovp, segs,
> + 		xfs_rw_enter_trace(XFS_DIOWR_ENTER, xip, (void *)iovp, segs,
>  				*offset, ioflags);
>  		ret = generic_file_direct_write(iocb, iovp,
>  				&segs, pos, offset, count, ocount);
> @@ -790,7 +782,7 @@ retry:
>  			goto relock;
>  		}
>  	} else {
> -		xfs_rw_enter_trace(XFS_WRITE_ENTER, io, (void *)iovp, segs,
> +		xfs_rw_enter_trace(XFS_WRITE_ENTER, xip, (void *)iovp, segs,
>  				*offset, ioflags);
>  		ret = generic_file_buffered_write(iocb, iovp, segs,
>  				pos, offset, count, ret);
> @@ -854,9 +846,9 @@ retry:
>  	}
>
>   out_unlock_internal:
> -	if (io->io_new_size) {
> +	if (xip->i_new_size) {
>  		xfs_ilock(xip, XFS_ILOCK_EXCL);
> -		io->io_new_size = 0;
> +		xip->i_new_size = 0;
>  		/*
>  		 * If this was a direct or synchronous I/O that failed (such
>  		 * as ENOSPC) then part of the I/O may have been written to
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.h	2007-09-12 13:56:20.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h	2007-09-12 14:05:49.000000000 +0200
> @@ -19,7 +19,6 @@
>  #define __XFS_LRW_H__
>
>  struct xfs_mount;
> -struct xfs_iocore;
>  struct xfs_inode;
>  struct xfs_bmbt_irec;
>  struct xfs_buf;
> @@ -59,20 +58,19 @@ struct xfs_iomap;
>  #define	XFS_IOMAP_UNWRITTEN	27
>  #define XFS_SPLICE_READ_ENTER	28
>  #define XFS_SPLICE_WRITE_ENTER	29
> -extern void xfs_rw_enter_trace(int, struct xfs_iocore *,
> +extern void xfs_rw_enter_trace(int, struct xfs_inode *,
>  				void *, size_t, loff_t, int);
> -extern void xfs_inval_cached_trace(struct xfs_iocore *,
> +extern void xfs_inval_cached_trace(struct xfs_inode *,
>  				xfs_off_t, xfs_off_t, xfs_off_t, xfs_off_t);
>  #else
> -#define xfs_rw_enter_trace(tag, io, data, size, offset, ioflags)
> -#define xfs_inval_cached_trace(io, offset, len, first, last)
> +#define xfs_rw_enter_trace(tag, ip, data, size, offset, ioflags)
> +#define xfs_inval_cached_trace(ip, offset, len, first, last)
>  #endif
>
>  extern int xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
>  extern int xfs_bdstrat_cb(struct xfs_buf *);
>  extern int xfs_dev_is_read_only(struct xfs_mount *, char *);
>
> -extern int xfs_zero_eof(struct inode *, struct xfs_iocore *, xfs_off_t,
> -				xfs_fsize_t);
> +extern int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
>
>  #endif	/* __XFS_LRW_H__ */
> Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2007-09-12 14:05:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2007-09-12 14:05:49.000000000 +0200
> @@ -199,7 +199,7 @@ xfs_swap_extents(
>  	}
>
>  	if (VN_CACHED(tvp) != 0) {
> -		xfs_inval_cached_trace(&tip->i_iocore, 0, -1, 0, -1);
> +		xfs_inval_cached_trace(tip, 0, -1, 0, -1);
>  		error = xfs_flushinval_pages(tip, 0, -1,
>  				FI_REMAPF_LOCKED);
>  		if (error)
> Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2007-09-12 13:56:15.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2007-09-12 14:05:49.000000000 +0200
> @@ -200,12 +200,9 @@ again:
>  		XFS_STATS_INC(xs_ig_found);
>
>  finish_inode:
> -		if (ip->i_d.di_mode == 0) {
> -			if (!(flags & XFS_IGET_CREATE)) {
> -				xfs_put_perag(mp, pag);
> -				return ENOENT;
> -			}
> -			xfs_iocore_inode_reinit(ip);
> +		if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
> +			xfs_put_perag(mp, pag);
> +			return ENOENT;
>  		}
>
>  		if (lock_flags != 0)
> @@ -237,7 +234,6 @@ finish_inode:
>  	_xfs_itrace_exit(ip, "xfs_iget.alloc", (inst_t *)__return_address);
>
>  	xfs_inode_lock_init(ip, vp);
> -	xfs_iocore_inode_init(ip);
>  	if (lock_flags)
>  		xfs_ilock(ip, lock_flags);
>
> @@ -333,9 +329,6 @@ finish_inode:
>  	ASSERT(ip->i_df.if_ext_max ==
>  	       XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t));
>
> -	ASSERT(((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) != 0) ==
> -	       ((ip->i_iocore.io_flags & XFS_IOCORE_RT) != 0));
> -
>  	xfs_iflags_set(ip, XFS_IMODIFIED);
>  	*ipp = ip;
>
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-09-12 14:05:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-09-12 14:05:49.000000000 +0200
> @@ -1220,10 +1220,8 @@ xfs_ialloc(
>  					ip->i_d.di_extsize = pip->i_d.di_extsize;
>  				}
>  			} else if ((mode & S_IFMT) == S_IFREG) {
> -				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) {
> +				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
>  					di_flags |= XFS_DIFLAG_REALTIME;
> -					ip->i_iocore.io_flags |= XFS_IOCORE_RT;
> -				}
>  				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
>  					di_flags |= XFS_DIFLAG_EXTSIZE;
>  					ip->i_d.di_extsize = pip->i_d.di_extsize;
> @@ -1842,8 +1840,6 @@ xfs_igrow_start(
>  	xfs_fsize_t	new_size,
>  	cred_t		*credp)
>  {
> -	int		error;
> -
>  	ASSERT(ismrlocked(&(ip->i_lock), MR_UPDATE) != 0);
>  	ASSERT(ismrlocked(&(ip->i_iolock), MR_UPDATE) != 0);
>  	ASSERT(new_size > ip->i_size);
> @@ -1853,9 +1849,7 @@ xfs_igrow_start(
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
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-09-12 13:56:16.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-09-12 14:05:49.000000000 +0200
> @@ -132,45 +132,6 @@ typedef struct dm_attrs_s {
>  	__uint16_t	da_pad;		/* DMIG extra padding */
>  } dm_attrs_t;
>
> -typedef struct xfs_iocore {
> -	void			*io_obj;	/* pointer to container
> -						 * inode or dcxvn structure */
> -	struct xfs_mount	*io_mount;	/* fs mount struct ptr */
> -#ifdef DEBUG
> -	mrlock_t		*io_lock;	/* inode IO lock */
> -	mrlock_t		*io_iolock;	/* inode IO lock */
> -#endif
> -
> -	/* I/O state */
> -	xfs_fsize_t		io_new_size;	/* sz when write completes */
> -
> -	/* Miscellaneous state. */
> -	unsigned int		io_flags;	/* IO related flags */
> -
> -	/* DMAPI state */
> -	dm_attrs_t		io_dmattrs;
> -
> -} xfs_iocore_t;
> -
> -#define        io_dmevmask     io_dmattrs.da_dmevmask
> -#define        io_dmstate      io_dmattrs.da_dmstate
> -
> -#define XFS_IO_INODE(io)	((xfs_inode_t *) ((io)->io_obj))
> -#define XFS_IO_DCXVN(io)	((dcxvn_t *) ((io)->io_obj))
> -
> -/*
> - * Flags in the flags field
> - */
> -
> -#define XFS_IOCORE_RT		0x1
> -
> -/*
> - * xfs_iocore prototypes
> - */
> -
> -extern void xfs_iocore_inode_init(struct xfs_inode *);
> -extern void xfs_iocore_inode_reinit(struct xfs_inode *);
> -
>  /*
>   * This is the xfs inode cluster structure.  This structure is used by
>   * xfs_iflush to find inodes that share a cluster and can be flushed to disk at
> @@ -283,9 +244,6 @@ typedef struct xfs_inode {
>  	struct xfs_inode	**i_refcache;	/* ptr to entry in ref cache */
>  	struct xfs_inode	*i_release;	/* inode to unref */
>  #endif
> -	/* I/O state */
> -	xfs_iocore_t		i_iocore;	/* I/O core */
> -
>  	/* Miscellaneous state. */
>  	unsigned short		i_flags;	/* see defined flags below */
>  	unsigned char		i_update_core;	/* timestamps/size is dirty */
> @@ -298,6 +256,7 @@ typedef struct xfs_inode {
>  	struct hlist_node	i_cnode;	/* cluster link node */
>
>  	xfs_fsize_t		i_size;		/* in-memory size */
> +	xfs_fsize_t		i_new_size;	/* size when write completes */
>  	atomic_t		i_iocount;	/* outstanding I/O count */
>  	/* Trace buffers per inode. */
>  #ifdef XFS_INODE_TRACE
> Index: linux-2.6-xfs/fs/xfs/xfs_iocore.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iocore.c	2007-09-12 14:05:43.000000000 +0200
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,79 +0,0 @@
> -/*
> - * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -#include "xfs.h"
> -#include "xfs_fs.h"
> -#include "xfs_types.h"
> -#include "xfs_bit.h"
> -#include "xfs_log.h"
> -#include "xfs_inum.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
> -#include "xfs_ag.h"
> -#include "xfs_dir2.h"
> -#include "xfs_dfrag.h"
> -#include "xfs_dmapi.h"
> -#include "xfs_mount.h"
> -#include "xfs_bmap_btree.h"
> -#include "xfs_alloc_btree.h"
> -#include "xfs_ialloc_btree.h"
> -#include "xfs_dir2_sf.h"
> -#include "xfs_attr_sf.h"
> -#include "xfs_dinode.h"
> -#include "xfs_inode.h"
> -#include "xfs_inode_item.h"
> -#include "xfs_itable.h"
> -#include "xfs_btree.h"
> -#include "xfs_alloc.h"
> -#include "xfs_ialloc.h"
> -#include "xfs_bmap.h"
> -#include "xfs_error.h"
> -#include "xfs_rw.h"
> -#include "xfs_quota.h"
> -#include "xfs_trans_space.h"
> -#include "xfs_iomap.h"
> -
> -void
> -xfs_iocore_inode_reinit(
> -	xfs_inode_t	*ip)
> -{
> -	xfs_iocore_t	*io = &ip->i_iocore;
> -
> -	io->io_flags = 0;
> -	if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
> -		io->io_flags |= XFS_IOCORE_RT;
> -	io->io_dmevmask = ip->i_d.di_dmevmask;
> -	io->io_dmstate = ip->i_d.di_dmstate;
> -}
> -
> -void
> -xfs_iocore_inode_init(
> -	xfs_inode_t	*ip)
> -{
> -	xfs_iocore_t	*io = &ip->i_iocore;
> -	xfs_mount_t	*mp = ip->i_mount;
> -
> -	io->io_mount = mp;
> -#ifdef DEBUG
> -	io->io_lock = &ip->i_lock;
> -	io->io_iolock = &ip->i_iolock;
> -#endif
> -
> -	io->io_obj = (void *)ip;
> -
> -	xfs_iocore_inode_reinit(ip);
> -}
> Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c	2007-09-12 14:05:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iomap.c	2007-09-12 14:05:49.000000000 +0200
> @@ -57,8 +57,6 @@ xfs_iomap_enter_trace(
>  	xfs_off_t	offset,
>  	ssize_t		count)
>  {
> -	xfs_iocore_t	*io = &ip->i_iocore;
> -
>  	if (!ip->i_rwtrace)
>  		return;
>
> @@ -70,8 +68,8 @@ xfs_iomap_enter_trace(
>  		(void *)((unsigned long)((offset >> 32) & 0xffffffff)),
>  		(void *)((unsigned long)(offset & 0xffffffff)),
>  		(void *)((unsigned long)count),
> -		(void *)((unsigned long)((io->io_new_size >> 32) & 0xffffffff)),
> -		(void *)((unsigned long)(io->io_new_size & 0xffffffff)),
> +		(void *)((unsigned long)((ip->i_new_size >> 32) & 0xffffffff)),
> +		(void *)((unsigned long)(ip->i_new_size & 0xffffffff)),
>  		(void *)((unsigned long)current_pid()),
>  		(void *)NULL,
>  		(void *)NULL,
> @@ -186,8 +184,6 @@ xfs_iomap(
>  	int		iomap_flags = 0;
>
>  	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
> -	ASSERT(((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) != 0) ==
> -	       ((ip->i_iocore.io_flags & XFS_IOCORE_RT) != 0));
>
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return XFS_ERROR(EIO);
> @@ -402,7 +398,6 @@ xfs_iomap_write_direct(
>  	int		found)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
> -	xfs_iocore_t	*io = &ip->i_iocore;
>  	xfs_fileoff_t	offset_fsb;
>  	xfs_fileoff_t	last_fsb;
>  	xfs_filblks_t	count_fsb, resaligned;
> @@ -432,8 +427,8 @@ xfs_iomap_write_direct(
>  	extsz = xfs_get_extsz_hint(ip);
>
>  	isize = ip->i_size;
> -	if (io->io_new_size > isize)
> -		isize = io->io_new_size;
> +	if (ip->i_new_size > isize)
> +		isize = ip->i_new_size;
>
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
> @@ -528,7 +523,8 @@ xfs_iomap_write_direct(
>  		goto error_out;
>  	}
>
> -	if (unlikely(!imap.br_startblock && !(io->io_flags & XFS_IOCORE_RT))) {
> +	if (unlikely(!imap.br_startblock &&
> +		     !(ip->i_d.di_flags & XFS_DIFLAG_REALTIME))) {
>  		error = xfs_cmn_err_fsblock_zero(ip, &imap);
>  		goto error_out;
>  	}
> @@ -616,7 +612,6 @@ xfs_iomap_write_delay(
>  	int		*nmaps)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
> -	xfs_iocore_t	*io = &ip->i_iocore;
>  	xfs_fileoff_t	offset_fsb;
>  	xfs_fileoff_t	last_fsb;
>  	xfs_off_t	aligned_offset;
> @@ -644,8 +639,8 @@ xfs_iomap_write_delay(
>
>  retry:
>  	isize = ip->i_size;
> -	if (io->io_new_size > isize)
> -		isize = io->io_new_size;
> +	if (ip->i_new_size > isize)
> +		isize = ip->i_new_size;
>
>  	error = xfs_iomap_eof_want_preallocate(mp, ip, isize, offset, count,
>  				ioflag, imap, XFS_WRITE_IMAPS, &prealloc);
> @@ -691,7 +686,8 @@ retry:
>  		goto retry;
>  	}
>
> -	if (unlikely(!imap[0].br_startblock && !(io->io_flags & XFS_IOCORE_RT)))
> +	if (unlikely(!imap[0].br_startblock &&
> +		     !(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)))
>  		return xfs_cmn_err_fsblock_zero(ip, &imap[0]);
>
>  	*ret_imap = imap[0];
> @@ -716,7 +712,6 @@ xfs_iomap_write_allocate(
>  	int		*retmap)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
> -	xfs_iocore_t    *io = &ip->i_iocore;
>  	xfs_fileoff_t	offset_fsb, last_block;
>  	xfs_fileoff_t	end_fsb, map_start_fsb;
>  	xfs_fsblock_t	first_block;
> @@ -814,7 +809,7 @@ xfs_iomap_write_allocate(
>  		 */
>  		for (i = 0; i < nimaps; i++) {
>  			if (unlikely(!imap[i].br_startblock &&
> -				     !(io->io_flags & XFS_IOCORE_RT)))
> +				     !(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)))
>  				return xfs_cmn_err_fsblock_zero(ip, &imap[i]);
>  			if ((offset_fsb >= imap[i].br_startoff) &&
>  			    (offset_fsb < (imap[i].br_startoff +
> @@ -850,7 +845,6 @@ xfs_iomap_write_unwritten(
>  	size_t		count)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
> -	xfs_iocore_t    *io = &ip->i_iocore;
>  	xfs_fileoff_t	offset_fsb;
>  	xfs_filblks_t	count_fsb;
>  	xfs_filblks_t	numblks_fsb;
> @@ -913,7 +907,7 @@ xfs_iomap_write_unwritten(
>  			return XFS_ERROR(error);
>
>  		if (unlikely(!imap.br_startblock &&
> -			     !(io->io_flags & XFS_IOCORE_RT)))
> +			     !(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)))
>  			return xfs_cmn_err_fsblock_zero(ip, &imap);
>
>  		if ((numblks_fsb = imap.br_blockcount) == 0) {
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-09-12 14:05:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-09-12 14:05:49.000000000 +0200
> @@ -56,7 +56,6 @@ struct cred;
>  struct log;
>  struct xfs_mount_args;
>  struct xfs_inode;
> -struct xfs_iocore;
>  struct xfs_bmbt_irec;
>  struct xfs_bmap_free;
>  struct xfs_extdelta;
> Index: linux-2.6-xfs/fs/xfs/xfs_rw.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_rw.h	2007-09-06 13:24:47.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_rw.h	2007-09-12 14:05:49.000000000 +0200
> @@ -36,14 +36,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
>  		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
>  		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
>  }
> -#define XFS_FSB_TO_DB_IO(io,fsb) xfs_fsb_to_db_io(io,fsb)
> -static inline xfs_daddr_t
> -xfs_fsb_to_db_io(struct xfs_iocore *io, xfs_fsblock_t fsb)
> -{
> -	return (((io)->io_flags & XFS_IOCORE_RT) ? \
> -		 XFS_FSB_TO_BB((io)->io_mount, (fsb)) : \
> -		 XFS_FSB_TO_DADDR((io)->io_mount, (fsb)));
> -}
>
>  /*
>   * Flags for xfs_free_eofblocks
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-09-12 14:05:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-09-12 14:05:49.000000000 +0200
> @@ -804,12 +804,8 @@ xfs_setattr(
>  				if (vap->va_xflags & XFS_XFLAG_EXTSZINHERIT)
>  					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
>  			} else if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
> -				if (vap->va_xflags & XFS_XFLAG_REALTIME) {
> +				if (vap->va_xflags & XFS_XFLAG_REALTIME)
>  					di_flags |= XFS_DIFLAG_REALTIME;
> -					ip->i_iocore.io_flags |= XFS_IOCORE_RT;
> -				} else {
> -					ip->i_iocore.io_flags &= ~XFS_IOCORE_RT;
> -				}
>  				if (vap->va_xflags & XFS_XFLAG_EXTSIZE)
>  					di_flags |= XFS_DIFLAG_EXTSIZE;
>  			}
> @@ -3640,8 +3636,8 @@ xfs_set_dmattrs(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>
> -	ip->i_iocore.io_dmevmask = ip->i_d.di_dmevmask = evmask;
> -	ip->i_iocore.io_dmstate  = ip->i_d.di_dmstate  = state;
> +	ip->i_d.di_dmevmask = evmask;
> +	ip->i_d.di_dmstate  = state;
>
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	IHOLD(ip);
> @@ -4179,7 +4175,7 @@ xfs_free_file_space(
>  	ioffset = offset & ~(rounding - 1);
>
>  	if (VN_CACHED(vp) != 0) {
> -		xfs_inval_cached_trace(&ip->i_iocore, ioffset, -1,
> +		xfs_inval_cached_trace(ip, ioffset, -1,
>  				ctooff(offtoct(ioffset)), -1);
>  		error = xfs_flushinval_pages(ip,
>  				ctooff(offtoct(ioffset)),
> Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-09-12 13:56:18.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-09-12 14:05:49.000000000 +0200
> @@ -164,7 +164,6 @@ static void	xfsidbg_xlog_tic(xlog_ticket
>  static void	xfsidbg_xlogitem(xfs_log_item_t *);
>  static void	xfsidbg_xmount(xfs_mount_t *);
>  static void	xfsidbg_xnode(xfs_inode_t *ip);
> -static void	xfsidbg_xcore(xfs_iocore_t *io);
>  static void	xfsidbg_xperag(xfs_mount_t *);
>  static void	xfsidbg_xqm_diskdq(xfs_disk_dquot_t *);
>  static void	xfsidbg_xqm_dqattached_inos(xfs_mount_t *);
> @@ -1472,25 +1471,6 @@ static int	kdbm_xfs_xnode(
>  	return 0;
>  }
>
> -static int	kdbm_xfs_xcore(
> -	int	argc,
> -	const char **argv)
> -{
> -	unsigned long addr;
> -	int nextarg = 1;
> -	long offset = 0;
> -	int diag;
> -
> -	if (argc != 1)
> -		return KDB_ARGCOUNT;
> -	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
> -	if (diag)
> -		return diag;
> -
> -	xfsidbg_xcore((xfs_iocore_t *) addr);
> -	return 0;
> -}
> -
>  static int	kdbm_xfs_xperag(
>  	int	argc,
>  	const char **argv)
> @@ -2552,8 +2532,6 @@ static struct xif xfsidbg_funcs[] = {
>  				"Dump XFS mount structure"},
>    {  "xnode",	kdbm_xfs_xnode,		"<xfs_inode_t>",
>  				"Dump XFS inode"},
> -  {  "xiocore",	kdbm_xfs_xcore,		"<xfs_iocore_t>",
> -				"Dump XFS iocore"},
>    {  "xperag",	kdbm_xfs_xperag,	"<xfs_mount_t>",
>  				"Dump XFS per-allocation group data"},
>    {  "xqinfo",  kdbm_xfs_xqm_qinfo,	"<xfs_mount_t>",
> @@ -6588,7 +6566,7 @@ xfsidbg_xnode(xfs_inode_t *ip)
>  		xfs_ipincount(ip));
>  	kdb_printf("udquotp 0x%p gdquotp 0x%p\n",
>  		ip->i_udquot, ip->i_gdquot);
> -	kdb_printf("new_size %Ld\n", ip->i_iocore.io_new_size);
> +	kdb_printf("new_size %Ld\n", ip->i_new_size);
>  	printflags((int)ip->i_flags, tab_flags, "flags");
>  	kdb_printf("\n");
>  	kdb_printf("update_core %d update size %d\n",
> @@ -6628,14 +6606,6 @@ xfsidbg_xnode(xfs_inode_t *ip)
>  	xfs_prdinode_incore(&ip->i_d);
>  }
>
> -static void
> -xfsidbg_xcore(xfs_iocore_t *io)
> -{
> -	kdb_printf("io_obj 0x%p io_flags 0x%x io_mount 0x%p\n",
> -			io->io_obj, io->io_flags, io->io_mount);
> -	kdb_printf("new_size %Lx\n", io->io_new_size);
> -}
> -
>  /*
>   * Print xfs per-ag data structures for filesystem.
>   */
>
>

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
