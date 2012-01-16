Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GIW3Am107385 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 12:32:03 -0600
Date: Mon, 16 Jan 2012 12:32:01 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 08/11] xfs: remove the i_size field in struct xfs_inode
Message-ID: <20120116183201.GA16581@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200132.134835340@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200132.134835340@bombadil.infradead.org>
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

On Sun, Dec 18, 2011 at 03:00:11PM -0500, Christoph Hellwig wrote:
> There is no fundamental need to keep an in-memory inode size copy in the XFS
> inode.  We already have the on-disk value in the dinode, and the separate
> in-memory copy that we need for regular files only in the XFS inode.
> 
> Remove the xfs_inode i_size field and change the XFS_ISIZE macro to use the
> VFS inode i_size field for regular fields.  Switch code that was directly
> accessing the i_size field in the xfs_inode to XFS_ISIZE, or in cases where
> we are limited to regular files direct access of the VFS inode i_size field.
> 
> This also allows dropping some fairly complicated code in the write path
> which dealt with keeping the xfs_inode i_size uptodate with the VFS i_size
> that is getting updated inside ->write_end.
> 
> Note that we do not bother resetting the VFS i_size when truncating a file
> that gets freed to zero as there is point in doing so because the VFS inode
> is no longer in use at this point.  Just relax the assert in xfs_ifree to
> only check the on-disk size instead.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good to me too.  The only suggestion I had was that in some
of these places where we call XFS_ISIZE or i_size_read twice in a row,
it might be nicer to read them into a local variable and use that.
Dave's comments were very helpful.

Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_aops.c        |    2 +-
>  fs/xfs/xfs_bmap.c        |   15 ++++++---------
>  fs/xfs/xfs_file.c        |   45 +++++++++++----------------------------------
>  fs/xfs/xfs_fs_subr.c     |    2 +-
>  fs/xfs/xfs_iget.c        |    1 -
>  fs/xfs/xfs_inode.c       |    8 ++------
>  fs/xfs/xfs_inode.h       |   16 ++++++++++++----
>  fs/xfs/xfs_iomap.c       |   12 ++++++------
>  fs/xfs/xfs_iops.c        |    3 +--
>  fs/xfs/xfs_qm_syscalls.c |    1 -
>  fs/xfs/xfs_trace.h       |    2 +-
>  fs/xfs/xfs_vnodeops.c    |   31 +++++++++++++++----------------
>  12 files changed, 56 insertions(+), 82 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_aops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_aops.c	2011-12-02 19:39:30.743827732 +0100
> +++ xfs/fs/xfs/xfs_aops.c	2011-12-07 11:18:04.305981907 +0100
> @@ -111,7 +111,7 @@ xfs_ioend_new_eof(
>  	xfs_fsize_t		bsize;
>  
>  	bsize = ioend->io_offset + ioend->io_size;
> -	isize = MAX(ip->i_size, ip->i_new_size);
> +	isize = MAX(i_size_read(VFS_I(ip)), ip->i_new_size);
>  	isize = MIN(isize, bsize);
>  	return isize > ip->i_d.di_size ? isize : 0;
>  }
> Index: xfs/fs/xfs/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_file.c	2011-12-02 19:39:30.753827732 +0100
> +++ xfs/fs/xfs/xfs_file.c	2011-12-07 11:18:04.305981907 +0100
> @@ -327,7 +327,7 @@ xfs_file_aio_read(
>  				mp->m_rtdev_targp : mp->m_ddev_targp;
>  		if ((iocb->ki_pos & target->bt_smask) ||
>  		    (size & target->bt_smask)) {
> -			if (iocb->ki_pos == ip->i_size)
> +			if (iocb->ki_pos == i_size_read(inode))
>  				return 0;
>  			return -XFS_ERROR(EINVAL);
>  		}
> @@ -412,30 +412,6 @@ xfs_file_splice_read(
>  	return ret;
>  }
>  
> -STATIC void
> -xfs_aio_write_isize_update(
> -	struct inode	*inode,
> -	loff_t		*ppos,
> -	ssize_t		bytes_written)
> -{
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	xfs_fsize_t		isize = i_size_read(inode);
> -
> -	if (bytes_written > 0)
> -		XFS_STATS_ADD(xs_write_bytes, bytes_written);
> -
> -	if (unlikely(bytes_written < 0 && bytes_written != -EFAULT &&
> -					*ppos > isize))
> -		*ppos = isize;
> -
> -	if (*ppos > ip->i_size) {
> -		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
> -		if (*ppos > ip->i_size)
> -			ip->i_size = *ppos;
> -		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
> -	}
> -}
> -
>  /*
>   * If this was a direct or synchronous I/O that failed (such as ENOSPC) then
>   * part of the I/O may have been written to disk before the error occurred.  In
> @@ -451,8 +427,8 @@ xfs_aio_write_newsize_update(
>  		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
>  		if (new_size == ip->i_new_size)
>  			ip->i_new_size = 0;
> -		if (ip->i_d.di_size > ip->i_size)
> -			ip->i_d.di_size = ip->i_size;
> +		if (ip->i_d.di_size > i_size_read(VFS_I(ip)))
> +			ip->i_d.di_size = i_size_read(VFS_I(ip));
>  		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
>  }
> @@ -492,15 +468,16 @@ xfs_file_splice_write(
>  	new_size = *ppos + count;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (new_size > ip->i_size)
> +	if (new_size > i_size_read(inode))
>  		ip->i_new_size = new_size;
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
>  	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
>  
>  	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
> +	if (ret > 0)
> +		XFS_STATS_ADD(xs_write_bytes, ret);
>  
> -	xfs_aio_write_isize_update(inode, ppos, ret);
>  	xfs_aio_write_newsize_update(ip, new_size);
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  	return ret;
> @@ -728,14 +705,14 @@ restart:
>  	 * values are still valid.
>  	 */
>  	if ((ip->i_new_size && *pos > ip->i_new_size) ||
> -	    (!ip->i_new_size && *pos > ip->i_size)) {
> +	    (!ip->i_new_size && *pos > i_size_read(inode))) {
>  		if (*iolock == XFS_IOLOCK_SHARED) {
>  			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
>  			*iolock = XFS_IOLOCK_EXCL;
>  			xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
>  			goto restart;
>  		}
> -		error = -xfs_zero_eof(ip, *pos, ip->i_size);
> +		error = -xfs_zero_eof(ip, *pos, i_size_read(inode));
>  	}
>  
>  	/*
> @@ -744,7 +721,7 @@ restart:
>  	 * ip->i_new_size if this IO ends beyond any other in-flight writes.
>  	 */
>  	new_size = *pos + *count;
> -	if (new_size > ip->i_size) {
> +	if (new_size > i_size_read(inode)) {
>  		if (new_size > ip->i_new_size)
>  			ip->i_new_size = new_size;
>  		*new_sizep = new_size;
> @@ -957,11 +934,11 @@ xfs_file_aio_write(
>  		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
>  						ocount, &new_size, &iolock);
>  
> -	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
> -
>  	if (ret <= 0)
>  		goto out_unlock;
>  
> +	XFS_STATS_ADD(xs_write_bytes, ret);
> +
>  	/* Handle various SYNC-type writes */
>  	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
>  		loff_t end = pos + ret - 1;
> Index: xfs/fs/xfs/xfs_fs_subr.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_fs_subr.c	2011-12-02 19:39:30.763827732 +0100
> +++ xfs/fs/xfs/xfs_fs_subr.c	2011-12-07 11:18:04.305981907 +0100
> @@ -90,7 +90,7 @@ xfs_wait_on_pages(
>  
>  	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
>  		return -filemap_fdatawait_range(mapping, first,
> -					last == -1 ? ip->i_size - 1 : last);
> +					last == -1 ? XFS_ISIZE(ip) - 1 : last);
>  	}
>  	return 0;
>  }
> Index: xfs/fs/xfs/xfs_iops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iops.c	2011-12-07 11:15:33.600131684 +0100
> +++ xfs/fs/xfs/xfs_iops.c	2011-12-07 11:18:04.309315222 +0100
> @@ -778,7 +778,7 @@ xfs_setattr_size(
>  		lock_flags |= XFS_IOLOCK_EXCL;
>  	xfs_ilock(ip, lock_flags);
>  
> -	oldsize = ip->i_size;
> +	oldsize = inode->i_size;
>  	newsize = iattr->ia_size;
>  
>  	/*
> @@ -897,7 +897,6 @@ xfs_setattr_size(
>  	 * they get written to.
>  	 */
>  	ip->i_d.di_size = newsize;
> -	ip->i_size = newsize;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	if (newsize <= oldsize) {
> Index: xfs/fs/xfs/xfs_trace.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trace.h	2011-12-07 11:17:02.346317572 +0100
> +++ xfs/fs/xfs/xfs_trace.h	2011-12-07 11:18:04.309315222 +0100
> @@ -1038,7 +1038,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
> -		__entry->isize = ip->i_size;
> +		__entry->isize = VFS_I(ip)->i_size;
>  		__entry->disize = ip->i_d.di_size;
>  		__entry->new_size = ip->i_new_size;
>  		__entry->offset = offset;
> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2011-12-07 11:17:02.339650941 +0100
> +++ xfs/fs/xfs/xfs_bmap.c	2011-12-07 11:18:04.312648538 +0100
> @@ -3997,11 +3997,8 @@ xfs_bmap_one_block(
>  	xfs_bmbt_irec_t	s;		/* internal version of extent */
>  
>  #ifndef DEBUG
> -	if (whichfork == XFS_DATA_FORK) {
> -		return S_ISREG(ip->i_d.di_mode) ?
> -			(ip->i_size == ip->i_mount->m_sb.sb_blocksize) :
> -			(ip->i_d.di_size == ip->i_mount->m_sb.sb_blocksize);
> -	}
> +	if (whichfork == XFS_DATA_FORK)
> +		return XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize;
>  #endif	/* !DEBUG */
>  	if (XFS_IFORK_NEXTENTS(ip, whichfork) != 1)
>  		return 0;
> @@ -4013,7 +4010,7 @@ xfs_bmap_one_block(
>  	xfs_bmbt_get_all(ep, &s);
>  	rval = s.br_startoff == 0 && s.br_blockcount == 1;
>  	if (rval && whichfork == XFS_DATA_FORK)
> -		ASSERT(ip->i_size == ip->i_mount->m_sb.sb_blocksize);
> +		ASSERT(XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize);
>  	return rval;
>  }
>  
> @@ -5425,7 +5422,7 @@ xfs_getbmapx_fix_eof_hole(
>  	if (startblock == HOLESTARTBLOCK) {
>  		mp = ip->i_mount;
>  		out->bmv_block = -1;
> -		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, ip->i_size));
> +		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, XFS_ISIZE(ip)));
>  		fixlen -= out->bmv_offset;
>  		if (prealloced && out->bmv_offset + out->bmv_length == end) {
>  			/* Came to hole at EOF. Trim it. */
> @@ -5513,7 +5510,7 @@ xfs_getbmap(
>  			fixlen = XFS_MAXIOFFSET(mp);
>  		} else {
>  			prealloced = 0;
> -			fixlen = ip->i_size;
> +			fixlen = XFS_ISIZE(ip);
>  		}
>  	}
>  
> @@ -5542,7 +5539,7 @@ xfs_getbmap(
>  
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
> -		if (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size) {
> +		if (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size) {
>  			error = xfs_flush_pages(ip, 0, -1, 0, FI_REMAPF);
>  			if (error)
>  				goto out_unlock_iolock;
> Index: xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iget.c	2011-12-07 11:17:37.032796326 +0100
> +++ xfs/fs/xfs/xfs_iget.c	2011-12-07 11:18:04.312648538 +0100
> @@ -94,7 +94,6 @@ xfs_inode_alloc(
>  	ip->i_update_core = 0;
>  	ip->i_delayed_blks = 0;
>  	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
> -	ip->i_size = 0;
>  	ip->i_new_size = 0;
>  
>  	return ip;
> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2011-12-07 11:17:50.642722594 +0100
> +++ xfs/fs/xfs/xfs_inode.c	2011-12-07 11:18:04.315981854 +0100
> @@ -347,7 +347,6 @@ xfs_iformat(
>  			return XFS_ERROR(EFSCORRUPTED);
>  		}
>  		ip->i_d.di_size = 0;
> -		ip->i_size = 0;
>  		ip->i_df.if_u2.if_rdev = xfs_dinode_get_rdev(dip);
>  		break;
>  
> @@ -853,7 +852,6 @@ xfs_iread(
>  	}
>  
>  	ip->i_delayed_blks = 0;
> -	ip->i_size = ip->i_d.di_size;
>  
>  	/*
>  	 * Mark the buffer containing the inode as something to keep
> @@ -1043,7 +1041,6 @@ xfs_ialloc(
>  	}
>  
>  	ip->i_d.di_size = 0;
> -	ip->i_size = 0;
>  	ip->i_d.di_nextents = 0;
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
> @@ -1198,7 +1195,7 @@ xfs_itruncate_extents(
>  	int			done = 0;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> -	ASSERT(new_size <= ip->i_size);
> +	ASSERT(new_size <= XFS_ISIZE(ip));
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	ASSERT(ip->i_itemp != NULL);
>  	ASSERT(ip->i_itemp->ili_lock_flags == 0);
> @@ -1712,8 +1709,7 @@ xfs_ifree(
>  	ASSERT(ip->i_d.di_nlink == 0);
>  	ASSERT(ip->i_d.di_nextents == 0);
>  	ASSERT(ip->i_d.di_anextents == 0);
> -	ASSERT((ip->i_d.di_size == 0 && ip->i_size == 0) ||
> -	       (!S_ISREG(ip->i_d.di_mode)));
> +	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(ip->i_d.di_mode));
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
>  	/*
> Index: xfs/fs/xfs/xfs_iomap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iomap.c	2011-12-07 11:15:53.693356164 +0100
> +++ xfs/fs/xfs/xfs_iomap.c	2011-12-07 11:18:04.315981854 +0100
> @@ -74,7 +74,7 @@ xfs_iomap_eof_align_last_fsb(
>  		else if (mp->m_dalign)
>  			align = mp->m_dalign;
>  
> -		if (align && ip->i_size >= XFS_FSB_TO_B(mp, align))
> +		if (align && XFS_ISIZE(ip) >= XFS_FSB_TO_B(mp, align))
>  			new_last_fsb = roundup_64(*last_fsb, align);
>  	}
>  
> @@ -154,7 +154,7 @@ xfs_iomap_write_direct(
>  
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
> -	if ((offset + count) > ip->i_size) {
> +	if ((offset + count) > XFS_ISIZE(ip)) {
>  		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
>  		if (error)
>  			goto error_out;
> @@ -211,7 +211,7 @@ xfs_iomap_write_direct(
>  	xfs_trans_ijoin(tp, ip, 0);
>  
>  	bmapi_flag = 0;
> -	if (offset < ip->i_size || extsz)
> +	if (offset < XFS_ISIZE(ip) || extsz)
>  		bmapi_flag |= XFS_BMAPI_PREALLOC;
>  
>  	/*
> @@ -286,7 +286,7 @@ xfs_iomap_eof_want_preallocate(
>  	int		found_delalloc = 0;
>  
>  	*prealloc = 0;
> -	if ((offset + count) <= ip->i_size)
> +	if (offset + count <= XFS_ISIZE(ip))
>  		return 0;
>  
>  	/*
> @@ -340,7 +340,7 @@ xfs_iomap_prealloc_size(
>  		 * if we pass in alloc_blocks = 0. Hence the "+ 1" to
>  		 * ensure we always pass in a non-zero value.
>  		 */
> -		alloc_blocks = XFS_B_TO_FSB(mp, ip->i_size) + 1;
> +		alloc_blocks = XFS_B_TO_FSB(mp, XFS_ISIZE(ip)) + 1;
>  		alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
>  					rounddown_pow_of_two(alloc_blocks));
>  
> @@ -564,7 +564,7 @@ xfs_iomap_write_allocate(
>  			 * back....
>  			 */
>  			nimaps = 1;
> -			end_fsb = XFS_B_TO_FSB(mp, ip->i_size);
> +			end_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
>  			error = xfs_bmap_last_offset(NULL, ip, &last_block,
>  							XFS_DATA_FORK);
>  			if (error)
> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-12-07 11:15:33.603464999 +0100
> +++ xfs/fs/xfs/xfs_vnodeops.c	2011-12-07 11:18:04.315981854 +0100
> @@ -175,7 +175,7 @@ xfs_free_eofblocks(
>  	 * Figure out if there are any blocks beyond the end
>  	 * of the file.  If not, then there is nothing to do.
>  	 */
> -	end_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)ip->i_size));
> +	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
>  	last_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
>  	if (last_fsb <= end_fsb)
>  		return 0;
> @@ -233,7 +233,7 @@ xfs_free_eofblocks(
>  		 * may be full of holes (ie NULL files bug).
>  		 */
>  		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK,
> -					      ip->i_size);
> +					      XFS_ISIZE(ip));
>  		if (error) {
>  			/*
>  			 * If we get an error at this point we simply don't
> @@ -547,8 +547,8 @@ xfs_release(
>  		return 0;
>  
>  	if ((S_ISREG(ip->i_d.di_mode) &&
> -	     ((ip->i_size > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
> -	       ip->i_delayed_blks > 0)) &&
> +	     (VFS_I(ip)->i_size > 0 ||
> +	      (VN_CACHED(VFS_I(ip)) > 0 || ip->i_delayed_blks > 0)) &&
>  	     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
>  	    (!(ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
>  
> @@ -625,7 +625,7 @@ xfs_inactive(
>  	 * only one with a reference to the inode.
>  	 */
>  	truncate = ((ip->i_d.di_nlink == 0) &&
> -	    ((ip->i_d.di_size != 0) || (ip->i_size != 0) ||
> +	    ((ip->i_d.di_size != 0) || XFS_ISIZE(ip) != 0 ||
>  	     (ip->i_d.di_nextents > 0) || (ip->i_delayed_blks > 0)) &&
>  	    S_ISREG(ip->i_d.di_mode));
>  
> @@ -639,12 +639,12 @@ xfs_inactive(
>  
>  	if (ip->i_d.di_nlink != 0) {
>  		if ((S_ISREG(ip->i_d.di_mode) &&
> -                     ((ip->i_size > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
> -                       ip->i_delayed_blks > 0)) &&
> -		      (ip->i_df.if_flags & XFS_IFEXTENTS) &&
> -		     (!(ip->i_d.di_flags &
> +		    (VFS_I(ip)->i_size > 0 ||
> +		     (VN_CACHED(VFS_I(ip)) > 0 || ip->i_delayed_blks > 0)) &&
> +		    (ip->i_df.if_flags & XFS_IFEXTENTS) &&
> +		    (!(ip->i_d.di_flags &
>  				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
> -		      (ip->i_delayed_blks != 0)))) {
> +		     ip->i_delayed_blks != 0))) {
>  			error = xfs_free_eofblocks(mp, ip, 0);
>  			if (error)
>  				return VN_INACTIVE_CACHE;
> @@ -678,7 +678,6 @@ xfs_inactive(
>  		xfs_trans_ijoin(tp, ip, 0);
>  
>  		ip->i_d.di_size = 0;
> -		ip->i_size = 0;
>  		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
> @@ -1974,11 +1973,11 @@ xfs_zero_remaining_bytes(
>  	 * since nothing can read beyond eof.  The space will
>  	 * be zeroed when the file is extended anyway.
>  	 */
> -	if (startoff >= ip->i_size)
> +	if (startoff >= XFS_ISIZE(ip))
>  		return 0;
>  
> -	if (endoff > ip->i_size)
> -		endoff = ip->i_size;
> +	if (endoff > XFS_ISIZE(ip))
> +		endoff = XFS_ISIZE(ip);
>  
>  	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
>  					mp->m_rtdev_targp : mp->m_ddev_targp,
> @@ -2273,7 +2272,7 @@ xfs_change_file_space(
>  		bf->l_start += offset;
>  		break;
>  	case 2: /*SEEK_END*/
> -		bf->l_start += ip->i_size;
> +		bf->l_start += XFS_ISIZE(ip);
>  		break;
>  	default:
>  		return XFS_ERROR(EINVAL);
> @@ -2290,7 +2289,7 @@ xfs_change_file_space(
>  	bf->l_whence = 0;
>  
>  	startoffset = bf->l_start;
> -	fsize = ip->i_size;
> +	fsize = XFS_ISIZE(ip);
>  
>  	/*
>  	 * XFS_IOC_RESVSP and XFS_IOC_UNRESVSP will reserve or unreserve
> Index: xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.h	2011-12-07 11:17:50.642722594 +0100
> +++ xfs/fs/xfs/xfs_inode.h	2011-12-07 11:18:04.319315170 +0100
> @@ -246,16 +246,12 @@ typedef struct xfs_inode {
>  
>  	xfs_icdinode_t		i_d;		/* most of ondisk inode */
>  
> -	xfs_fsize_t		i_size;		/* in-memory size */
>  	xfs_fsize_t		i_new_size;	/* size when write completes */
>  
>  	/* VFS inode */
>  	struct inode		i_vnode;	/* embedded VFS inode */
>  } xfs_inode_t;
>  
> -#define XFS_ISIZE(ip)	S_ISREG((ip)->i_d.di_mode) ? \
> -				(ip)->i_size : (ip)->i_d.di_size;
> -
>  /* Convert from vfs inode to xfs inode */
>  static inline struct xfs_inode *XFS_I(struct inode *inode)
>  {
> @@ -269,6 +265,18 @@ static inline struct inode *VFS_I(struct
>  }
>  
>  /*
> + * For regular files we only update the on-disk filesize when actually
> + * writing data back to disk.  Until then only the copy in the VFS inode
> + * is uptodate.
> + */
> +static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
> +{
> +	if (S_ISREG(ip->i_d.di_mode))
> +		return i_size_read(VFS_I(ip));
> +	return ip->i_d.di_size;
> +}
> +
> +/*
>   * i_flags helper functions
>   */
>  static inline void
> Index: xfs/fs/xfs/xfs_qm_syscalls.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm_syscalls.c	2011-12-07 11:15:33.600131684 +0100
> +++ xfs/fs/xfs/xfs_qm_syscalls.c	2011-12-07 11:18:04.319315170 +0100
> @@ -265,7 +265,6 @@ xfs_qm_scall_trunc_qfile(
>  	xfs_trans_ijoin(tp, ip, 0);
>  
>  	ip->i_d.di_size = 0;
> -	ip->i_size = 0;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
