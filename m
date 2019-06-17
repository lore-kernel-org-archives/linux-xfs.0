Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37686 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQX16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 19:27:58 -0400
Date: Mon, 17 Jun 2019 16:27:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/24] xfs: use bios directly to write log buffers
Message-ID: <20190617232751.GP3773859@magnolia>
References: <20190605191511.32695-1-hch@lst.de>
 <20190605191511.32695-17-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605191511.32695-17-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 09:15:03PM +0200, Christoph Hellwig wrote:
> Currently the XFS logging code uses the xfs_buf structure and
> associated APIs to write the log buffers to disk.  This requires
> various special cases in the log code and is generally not very
> optimal.
> 
> Instead of using a buffer just allocate a kmem_alloc_larger region for
> each log buffer, and use a bio and bio_vec array embedded in the iclog
> structure to write the buffer to disk.  This also allows for using
> the bio split and chaining case to deal with the case of a log
> buffer wrapping around the end of the log.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 231 ++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_priv.h |  18 ++--
>  2 files changed, 119 insertions(+), 130 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 452d03898fd0..0a8a43d77385 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1239,32 +1239,30 @@ xlog_space_left(
>  }
>  
>  
> -/*
> - * Log function which is called when an io completes.
> - *
> - * The log manager needs its own routine, in order to control what
> - * happens with the buffer after the write completes.
> - */
>  static void
> -xlog_iodone(xfs_buf_t *bp)
> +xlog_ioend_work(
> +	struct work_struct	*work)
>  {
> -	struct xlog_in_core	*iclog = bp->b_log_item;
> -	struct xlog		*l = iclog->ic_log;
> +	struct xlog_in_core     *iclog =
> +		container_of(work, struct xlog_in_core, ic_end_io_work);
> +	struct xlog		*log = iclog->ic_log;
>  	int			aborted = 0;
> +	int			error;
>  
>  #ifdef DEBUG
>  	/* treat writes with injected CRC errors as failed */
>  	if (iclog->ic_fail_crc)
> -		bp->b_error = -EIO;
> +		error = -EIO;
> +	else
>  #endif
> +		error = blk_status_to_errno(iclog->ic_bio.bi_status);

Ugh, I don't really like this awkwardly split else/#endif construction
here.  Can we simply do:

error = blk_status_to_errno(iclog->ic_bio.bi_status);

#ifdef DEBUG
if (iclog->ic_fail_crc)
	error = -EIO;
#endif

instead?

>  
>  	/*
>  	 * Race to shutdown the filesystem if we see an error.
>  	 */
> -	if (XFS_TEST_ERROR(bp->b_error, l->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
> -		xfs_buf_ioerror_alert(bp, __func__);
> -		xfs_buf_stale(bp);
> -		xfs_force_shutdown(l->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +	if (XFS_TEST_ERROR(error, log->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
> +		xfs_alert(log->l_mp, "log I/O error %d", error);
> +		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  		/*
>  		 * This flag will be propagated to the trans-committed
>  		 * callback routines to let them know that the log-commit

<snip>

> @@ -1747,21 +1731,52 @@ xlog_write_iclog(
>  	 * tearing down the iclogbufs.  Hence we need to hold the buffer lock
>  	 * across the log IO to archieve that.
>  	 */
> -	xfs_buf_lock(bp);
> +	down(&iclog->ic_sema);
>  	if (unlikely(iclog->ic_state & XLOG_STATE_IOERROR)) {
> -		xfs_buf_ioerror(bp, -EIO);
> -		xfs_buf_stale(bp);
> -		xfs_buf_ioend(bp);
>  		/*
>  		 * It would seem logical to return EIO here, but we rely on
>  		 * the log state machine to propagate I/O errors instead of
> -		 * doing it here. Similarly, IO completion will unlock the
> -		 * buffer, so we don't do it here.
> +		 * doing it here.  We kick of the state machine and unlock
> +		 * the buffer manually, the code needs to be kept in sync
> +		 * with the I/O completion path.
>  		 */
> +		xlog_state_done_syncing(iclog, XFS_LI_ABORTED);
> +		up(&iclog->ic_sema);
>  		return;
>  	}
>  
> -	xfs_buf_submit(bp);
> +	iclog->ic_io_size = count;
> +
> +	bio_init(&iclog->ic_bio, iclog->ic_bvec, howmany(count, PAGE_SIZE));
> +	bio_set_dev(&iclog->ic_bio, log->l_targ->bt_bdev);
> +	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
> +	iclog->ic_bio.bi_end_io = xlog_bio_end_io;
> +	iclog->ic_bio.bi_private = iclog;
> +	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_FUA;
> +	if (need_flush)
> +		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> +
> +	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, iclog->ic_io_size);

/me is surprised you got all the way through that without making a
convenience variable, but I guess none of the lines overflow.

--D

> +	if (is_vmalloc_addr(iclog->ic_data))
> +		flush_kernel_vmap_range(iclog->ic_data, iclog->ic_io_size);
> +
> +	/*
> +	 * If this log buffer would straddle the end of the log we will have
> +	 * to split it up into two bios, so that we can continue at the start.
> +	 */
> +	if (bno + BTOBB(count) > log->l_logBBsize) {
> +		struct bio *split;
> +
> +		split = bio_split(&iclog->ic_bio, log->l_logBBsize - bno,
> +				  GFP_NOIO, &fs_bio_set);
> +		bio_chain(split, &iclog->ic_bio);
> +		submit_bio(split);
> +
> +		/* restart at logical offset zero for the remainder */
> +		iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart;
> +	}
> +
> +	submit_bio(&iclog->ic_bio);
>  }
>  
>  /*
> @@ -1769,7 +1784,7 @@ xlog_write_iclog(
>   * written to the start of the log. Watch out for the header magic
>   * number case, though.
>   */
> -static unsigned int
> +static void
>  xlog_split_iclog(
>  	struct xlog		*log,
>  	void			*data,
> @@ -1786,8 +1801,6 @@ xlog_split_iclog(
>  			cycle++;
>  		put_unaligned_be32(cycle, data + i);
>  	}
> -
> -	return split_offset;
>  }
>  
>  static int
> @@ -1854,9 +1867,8 @@ xlog_sync(
>  	unsigned int		count;		/* byte count of bwrite */
>  	unsigned int		roundoff;       /* roundoff to BB or stripe */
>  	uint64_t		bno;
> -	unsigned int		split = 0;
>  	unsigned int		size;
> -	bool			need_flush = true;
> +	bool			need_flush = true, split = false;
>  
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
>  
> @@ -1881,8 +1893,10 @@ xlog_sync(
>  	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
>  
>  	/* Do we need to split this write into 2 parts? */
> -	if (bno + BTOBB(count) > log->l_logBBsize)
> -		split = xlog_split_iclog(log, &iclog->ic_header, bno, count);
> +	if (bno + BTOBB(count) > log->l_logBBsize) {
> +		xlog_split_iclog(log, &iclog->ic_header, bno, count);
> +		split = true;
> +	}
>  
>  	/* calculcate the checksum */
>  	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
> @@ -1917,18 +1931,8 @@ xlog_sync(
>  		need_flush = false;
>  	}
>  
> -	iclog->ic_bp->b_io_length = BTOBB(split ? split : count);
> -	iclog->ic_bwritecnt = split ? 2 : 1;
> -
>  	xlog_verify_iclog(log, iclog, count);
> -	xlog_write_iclog(log, iclog, iclog->ic_bp, bno, need_flush);
> -
> -	if (split) {
> -		xfs_buf_associate_memory(iclog->ic_log->l_xbuf,
> -				(char *)&iclog->ic_header + split,
> -				count - split);
> -		xlog_write_iclog(log, iclog, iclog->ic_log->l_xbuf, 0, false);
> -	}
> +	xlog_write_iclog(log, iclog, bno, count, need_flush);
>  }
>  
>  /*
> @@ -1949,25 +1953,15 @@ xlog_dealloc_log(
>  	 */
>  	iclog = log->l_iclog;
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
> -		xfs_buf_lock(iclog->ic_bp);
> -		xfs_buf_unlock(iclog->ic_bp);
> +		down(&iclog->ic_sema);
> +		up(&iclog->ic_sema);
>  		iclog = iclog->ic_next;
>  	}
>  
> -	/*
> -	 * Always need to ensure that the extra buffer does not point to memory
> -	 * owned by another log buffer before we free it. Also, cycle the lock
> -	 * first to ensure we've completed IO on it.
> -	 */
> -	xfs_buf_lock(log->l_xbuf);
> -	xfs_buf_unlock(log->l_xbuf);
> -	xfs_buf_set_empty(log->l_xbuf, BTOBB(log->l_iclog_size));
> -	xfs_buf_free(log->l_xbuf);
> -
>  	iclog = log->l_iclog;
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
> -		xfs_buf_free(iclog->ic_bp);
>  		next_iclog = iclog->ic_next;
> +		kmem_free(iclog->ic_data);
>  		kmem_free(iclog);
>  		iclog = next_iclog;
>  	}
> @@ -2885,8 +2879,6 @@ xlog_state_done_syncing(
>  	ASSERT(iclog->ic_state == XLOG_STATE_SYNCING ||
>  	       iclog->ic_state == XLOG_STATE_IOERROR);
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
> -	ASSERT(iclog->ic_bwritecnt == 1 || iclog->ic_bwritecnt == 2);
> -
>  
>  	/*
>  	 * If we got an error, either on the first buffer, or in the case of
> @@ -2894,13 +2886,8 @@ xlog_state_done_syncing(
>  	 * and none should ever be attempted to be written to disk
>  	 * again.
>  	 */
> -	if (iclog->ic_state != XLOG_STATE_IOERROR) {
> -		if (--iclog->ic_bwritecnt == 1) {
> -			spin_unlock(&log->l_icloglock);
> -			return;
> -		}
> +	if (iclog->ic_state != XLOG_STATE_IOERROR)
>  		iclog->ic_state = XLOG_STATE_DONE_SYNC;
> -	}
>  
>  	/*
>  	 * Someone could be sleeping prior to writing out the next
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index ac4bca257609..b9c90abb09a2 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -178,11 +178,12 @@ typedef struct xlog_ticket {
>   *	the iclog.
>   * - ic_forcewait is used to implement synchronous forcing of the iclog to disk.
>   * - ic_next is the pointer to the next iclog in the ring.
> - * - ic_bp is a pointer to the buffer used to write this incore log to disk.
>   * - ic_log is a pointer back to the global log structure.
>   * - ic_callback is a linked list of callback function/argument pairs to be
>   *	called after an iclog finishes writing.
> - * - ic_size is the full size of the header plus data.
> + * - ic_size is the full size of the log buffer, minus the cycle headers.
> + * - ic_io_size is the size of the currently pending log buffer write, which
> + *	might be smaller than ic_size
>   * - ic_offset is the current number of bytes written to in this iclog.
>   * - ic_refcnt is bumped when someone is writing to the log.
>   * - ic_state is the state of the iclog.
> @@ -205,11 +206,10 @@ typedef struct xlog_in_core {
>  	wait_queue_head_t	ic_write_wait;
>  	struct xlog_in_core	*ic_next;
>  	struct xlog_in_core	*ic_prev;
> -	struct xfs_buf		*ic_bp;
>  	struct xlog		*ic_log;
> -	int			ic_size;
> -	int			ic_offset;
> -	int			ic_bwritecnt;
> +	u32			ic_size;
> +	u32			ic_io_size;
> +	u32			ic_offset;
>  	unsigned short		ic_state;
>  	char			*ic_datap;	/* pointer to iclog data */
>  
> @@ -225,6 +225,10 @@ typedef struct xlog_in_core {
>  #ifdef DEBUG
>  	bool			ic_fail_crc : 1;
>  #endif
> +	struct semaphore	ic_sema;
> +	struct work_struct	ic_end_io_work;
> +	struct bio		ic_bio;
> +	struct bio_vec		ic_bvec[];
>  } xlog_in_core_t;
>  
>  /*
> @@ -352,8 +356,6 @@ struct xlog {
>  	struct xfs_mount	*l_mp;	        /* mount point */
>  	struct xfs_ail		*l_ailp;	/* AIL log is working with */
>  	struct xfs_cil		*l_cilp;	/* CIL log is working with */
> -	struct xfs_buf		*l_xbuf;        /* extra buffer for log
> -						 * wrapping */
>  	struct xfs_buftarg	*l_targ;        /* buftarg of log */
>  	struct delayed_work	l_work;		/* background flush work */
>  	uint			l_flags;
> -- 
> 2.20.1
> 
