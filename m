Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D8007F3F
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 11:13:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19CF230404E
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 09:13:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id t0sHg7Vz2nQwiy0f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 09:13:27 -0700 (PDT)
Date: Fri, 15 Aug 2014 12:13:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] xfs: introduce xfs_buf_submit[_wait]
Message-ID: <20140815161319.GF4096@laptop.bfoster>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408084747-4540-9-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 15, 2014 at 04:39:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is a lot of cookie-cutter code that looks like:
> 
> 	if (shutdown)
> 		handle buffer error
> 	xfs_buf_iorequest(bp)
> 	error = xfs_buf_iowait(bp)
> 	if (error)
> 		handle buffer error
> 
> spread through XFS. There's significant complexity now in
> xfs_buf_iorequest() to specifically handle this sort of synchronous
> IO pattern, but there's all sorts of nasty surprises in different
> error handling code dependent on who owns the buffer references and
> the locks.
> 
> Pull this pattern into a single helper, where we can hide all the
> synchronous IO warts and hence make the error handling for all the
> callers much saner. This removes the need for a special extra
> reference to protect IO completion processing, as we can now hold a
> single reference across dispatch and waiting, simplifying the sync
> IO smeantics and error handling.
> 
> In doing this, also rename xfs_buf_iorequest to xfs_buf_submit and
> make it explicitly handle on asynchronous IO. This forces all users
> to be switched specifically to one interface or the other and
> removes any ambiguity between how the interfaces are to be used. It
> also means that xfs_buf_iowait() goes away.
> 
> For the special case of delwri buffer submission and waiting, we
> don't need to issue IO synchronously at all. The second pass to cal
> xfs_buf_iowait() can now just block on xfs_buf_lock() - the buffer
> will be unlocked when the async IO is complete. This formalises a
> sane the method of waiting for async IO - take an extra reference,
> submit the IO, call xfs_buf_lock() when you want to wait for IO
> completion. i.e.:
> 
> 	bp = xfs_buf_find();
> 	xfs_buf_hold(bp);
> 	bp->b_flags |= XBF_ASYNC;
> 	xfs_buf_iosubmit(bp);
> 	xfs_buf_lock(bp)
> 	error = bp->b_error;
> 	....
> 	xfs_buf_relse(bp);
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c   |  14 +---
>  fs/xfs/xfs_buf.c         | 186 ++++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_buf.h         |   4 +-
>  fs/xfs/xfs_buf_item.c    |   4 +-
>  fs/xfs/xfs_log.c         |   2 +-
>  fs/xfs/xfs_log_recover.c |  22 ++----
>  fs/xfs/xfs_trans_buf.c   |  17 ++---
>  7 files changed, 122 insertions(+), 127 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2f1e30d..c53cc03 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1157,12 +1157,7 @@ xfs_zero_remaining_bytes(
>  		XFS_BUF_READ(bp);
>  		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
>  
> -		if (XFS_FORCED_SHUTDOWN(mp)) {
> -			error = -EIO;
> -			break;
> -		}
> -		xfs_buf_iorequest(bp);
> -		error = xfs_buf_iowait(bp);
> +		error = xfs_buf_submit_wait(bp);
>  		if (error) {
>  			xfs_buf_ioerror_alert(bp,
>  					"xfs_zero_remaining_bytes(read)");
> @@ -1175,12 +1170,7 @@ xfs_zero_remaining_bytes(
>  		XFS_BUF_UNREAD(bp);
>  		XFS_BUF_WRITE(bp);
>  
> -		if (XFS_FORCED_SHUTDOWN(mp)) {
> -			error = -EIO;
> -			break;
> -		}
> -		xfs_buf_iorequest(bp);
> -		error = xfs_buf_iowait(bp);
> +		error = xfs_buf_submit_wait(bp);
>  		if (error) {
>  			xfs_buf_ioerror_alert(bp,
>  					"xfs_zero_remaining_bytes(write)");
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 352e9219..a2599f9 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -623,10 +623,11 @@ _xfs_buf_read(
>  	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
>  	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
>  
> -	xfs_buf_iorequest(bp);
> -	if (flags & XBF_ASYNC)
> +	if (flags & XBF_ASYNC) {
> +		xfs_buf_submit(bp);
>  		return 0;
> -	return xfs_buf_iowait(bp);
> +	}
> +	return xfs_buf_submit_wait(bp);
>  }
>  
>  xfs_buf_t *
> @@ -708,12 +709,7 @@ xfs_buf_read_uncached(
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = ops;
>  
> -	if (XFS_FORCED_SHUTDOWN(target->bt_mount)) {
> -		xfs_buf_relse(bp);
> -		return NULL;
> -	}
> -	xfs_buf_iorequest(bp);
> -	xfs_buf_iowait(bp);
> +	xfs_buf_submit_wait(bp);
>  	return bp;
>  }
>  
> @@ -1027,10 +1023,8 @@ xfs_buf_ioend(
>  		(*(bp->b_iodone))(bp);
>  	else if (bp->b_flags & XBF_ASYNC)
>  		xfs_buf_relse(bp);
> -	else {
> +	else
>  		complete(&bp->b_iowait);
> -		xfs_buf_rele(bp);
> -	}
>  }
>  
>  static void
> @@ -1083,21 +1077,7 @@ xfs_bwrite(
>  	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
>  			 XBF_WRITE_FAIL | XBF_DONE);
>  
> -	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> -		trace_xfs_bdstrat_shut(bp, _RET_IP_);
> -
> -		xfs_buf_ioerror(bp, -EIO);
> -		xfs_buf_stale(bp);
> -
> -		/* sync IO, xfs_buf_ioend is going to remove a ref here */
> -		xfs_buf_hold(bp);
> -		xfs_buf_ioend(bp);
> -		return -EIO;
> -	}
> -
> -	xfs_buf_iorequest(bp);
> -
> -	error = xfs_buf_iowait(bp);
> +	error = xfs_buf_submit_wait(bp);
>  	if (error) {
>  		xfs_force_shutdown(bp->b_target->bt_mount,
>  				   SHUTDOWN_META_IO_ERROR);
> @@ -1206,7 +1186,7 @@ next_chunk:
>  	} else {
>  		/*
>  		 * This is guaranteed not to be the last io reference count
> -		 * because the caller (xfs_buf_iorequest) holds a count itself.
> +		 * because the caller (xfs_buf_submit) holds a count itself.
>  		 */
>  		atomic_dec(&bp->b_io_remaining);
>  		xfs_buf_ioerror(bp, -EIO);
> @@ -1296,13 +1276,29 @@ _xfs_buf_ioapply(
>  	blk_finish_plug(&plug);
>  }
>  
> +/*
> + * Asynchronous IO submission path. This transfers the buffer lock ownership and
> + * the current reference to the IO. It is not safe to reference the buffer after
> + * a call to this function unless the caller holds an additional reference
> + * itself.
> + */
>  void
> -xfs_buf_iorequest(
> -	xfs_buf_t		*bp)
> +xfs_buf_submit(
> +	struct xfs_buf	*bp)
>  {
>  	trace_xfs_buf_iorequest(bp, _RET_IP_);
>  
>  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
> +	ASSERT(bp->b_flags & XBF_ASYNC);
> +
> +	/* on shutdown we stale and complete the buffer immediately */
> +	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> +		xfs_buf_ioerror(bp, -EIO);
> +		bp->b_flags &= ~XBF_DONE;
> +		xfs_buf_stale(bp);
> +		xfs_buf_ioend(bp);
> +		return;
> +	}
>  
>  	if (bp->b_flags & XBF_WRITE)
>  		xfs_buf_wait_unpin(bp);
> @@ -1311,25 +1307,10 @@ xfs_buf_iorequest(
>  	bp->b_io_error = 0;
>  

I know this is from the previous patch, but I wonder if it's cleaner to
reset b_io_error when the error is transferred to b_error. That seems
slightly more future proof at least.

>  	/*
> -	 * Take references to the buffer. For XBF_ASYNC buffers, holding a
> -	 * reference for as long as submission takes is all that is necessary
> -	 * here. The IO inherits the lock and hold count from the submitter,
> -	 * and these are release during IO completion processing. Taking a hold
> -	 * over submission ensures that the buffer is not freed until we have
> -	 * completed all processing, regardless of when IO errors occur or are
> -	 * reported.
> -	 *
> -	 * However, for synchronous IO, the IO does not inherit the submitters
> -	 * reference count, nor the buffer lock. Hence we need to take an extra
> -	 * reference to the buffer for the for the IO context so that we can
> -	 * guarantee the buffer is not freed until all IO completion processing
> -	 * is done. Otherwise the caller can drop their reference while the IO
> -	 * is still in progress and hence trigger a use-after-free situation.
> +	 * Take an extra reference so that we don't have to guess when it's no
> +	 * longer safe to reference the buffer that was passed to us.
>  	 */

Assuming my understanding is correct:

/*
 * The caller's reference is released by buffer I/O completion.  Technically
 * this should not occur until we release the last b_io_remaining reference.
 * Take a direct reference across the I/O submission anyways to be sure it's
 * safe to access the buffer until we release it.
 */

>  	xfs_buf_hold(bp);
> -	if (!(bp->b_flags & XBF_ASYNC))
> -		xfs_buf_hold(bp);
> -
>  
>  	/*
>  	 * Set the count to 1 initially, this will stop an I/O completion
> @@ -1340,14 +1321,13 @@ xfs_buf_iorequest(
>  	_xfs_buf_ioapply(bp);
>  
>  	/*
> -	 * If _xfs_buf_ioapply failed or we are doing synchronous IO that
> -	 * completes extremely quickly, we can get back here with only the IO
> +	 * If _xfs_buf_ioapply failed, 
> +	 * we can get back here with only the IO
>  	 * reference we took above.  _xfs_buf_ioend will drop it to zero, so
>  	 * we'd better run completion processing synchronously so that the we
> -	 * don't return to the caller with completion still pending. In the
> -	 * error case, this allows the caller to check b_error safely without
> -	 * waiting, and in the synchronous IO case it avoids unnecessary context
> -	 * switches an latency for high-peformance devices.
> +	 * don't return to the caller with completion still pending.
> +	 * this allows the caller to check b_error safely without
> +	 * waiting
>  	 */
>  	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
>  		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> @@ -1357,25 +1337,70 @@ xfs_buf_iorequest(
>  	}
>  
>  	xfs_buf_rele(bp);
> +	/* Note: it is not safe to reference bp now we've dropped our ref */
>  }
>  
>  /*
> - * Waits for I/O to complete on the buffer supplied.  It returns immediately if
> - * no I/O is pending or there is already a pending error on the buffer, in which
> - * case nothing will ever complete.  It returns the I/O error code, if any, or
> - * 0 if there was no error.
> + * Synchronous buffer IO submission path, read or write.
>   */
>  int
> -xfs_buf_iowait(
> -	xfs_buf_t		*bp)
> +xfs_buf_submit_wait(
> +	struct xfs_buf	*bp)
>  {
> -	trace_xfs_buf_iowait(bp, _RET_IP_);
> +	int		error;
> +
> +	trace_xfs_buf_iorequest(bp, _RET_IP_);
>  
> -	if (!bp->b_error)
> -		wait_for_completion(&bp->b_iowait);
> +	ASSERT(!(bp->b_flags & (_XBF_DELWRI_Q | XBF_ASYNC)));
> +
> +	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> +		xfs_buf_ioerror(bp, -EIO);
> +		xfs_buf_stale(bp);
> +		bp->b_flags &= ~XBF_DONE;
> +		return -EIO;
> +	}
>  
> +	if (bp->b_flags & XBF_WRITE)
> +		xfs_buf_wait_unpin(bp);
> +
> +	/* clear the internal error state to avoid spurious errors */
> +	bp->b_io_error = 0;
> +
> +	/*
> +	 * For synchronous IO, the IO does not inherit the submitters reference
> +	 * count, nor the buffer lock. Hence we cannot release the reference we
> +	 * are about to take until we've waited for all IO completion to occur,
> +	 * including any xfs_buf_ioend_async() work that may be pending.
> +	 */
> +	xfs_buf_hold(bp);
> +

Harmless, but why is this necessary? The caller should have the
reference, the I/O completion won't release it and we wait on b_iowait
before we return. Isn't the caller's reference sufficient?

> +	/*
> +	 * Set the count to 1 initially, this will stop an I/O completion
> +	 * callout which happens before we have started all the I/O from calling
> +	 * xfs_buf_ioend too early.
> +	 */
> +	atomic_set(&bp->b_io_remaining, 1);
> +	_xfs_buf_ioapply(bp);
> +
> +	/*
> +	 * make sure we run completion synchronously if it raced with us and is
> +	 * already complete.
> +	 */
> +	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
> +		xfs_buf_ioend(bp);
> +
> +	/* wait for completion before gathering the error from the buffer */
> +	trace_xfs_buf_iowait(bp, _RET_IP_);
> +	wait_for_completion(&bp->b_iowait);
>  	trace_xfs_buf_iowait_done(bp, _RET_IP_);
> -	return bp->b_error;
> +	error = bp->b_error;
> +
> +	/*
> +	 * all done now, we can release the hold that keeps the buffer
> +	 * referenced for the entire IO.
> +	 */
> +	xfs_buf_rele(bp);
> +	return error;
>  }
>  
>  xfs_caddr_t
> @@ -1769,29 +1794,19 @@ __xfs_buf_delwri_submit(
>  	blk_start_plug(&plug);
>  	list_for_each_entry_safe(bp, n, io_list, b_list) {
>  		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
> -		bp->b_flags |= XBF_WRITE;
> +		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
>  
> -		if (!wait) {
> -			bp->b_flags |= XBF_ASYNC;
> +		/*
> +		 * we do all Io submission async. This means if we need to wait
> +		 * for IO completion we need to take an extra reference so the
> +		 * buffer is still valid on the other side.
> +		 */
> +		if (!wait)
>  			list_del_init(&bp->b_list);
> -		}
> -
> -		if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> -			trace_xfs_bdstrat_shut(bp, _RET_IP_);
> -
> -			xfs_buf_ioerror(bp, -EIO);
> -			xfs_buf_stale(bp);
> +		else
> +			xfs_buf_hold(bp);
>  
> -			/*
> -			 * if sync IO, xfs_buf_ioend is going to remove a
> -			 * ref here. We need to add that so we can collect
> -			 * all the buffer errors in the wait loop.
> -			 */
> -			if (wait)
> -				xfs_buf_hold(bp);
> -			xfs_buf_ioend(bp);
> -		} else
> -			xfs_buf_iorequest(bp);
> +		xfs_buf_submit(bp);
>  	}
>  	blk_finish_plug(&plug);
>  
> @@ -1838,7 +1853,10 @@ xfs_buf_delwri_submit(
>  		bp = list_first_entry(&io_list, struct xfs_buf, b_list);
>  
>  		list_del_init(&bp->b_list);
> -		error2 = xfs_buf_iowait(bp);
> +
> +		/* locking the buffer will wait for async IO completion. */
> +		xfs_buf_lock(bp);
> +		error2 = bp->b_error;

Interesting delwri cleanup overall. The lock here works for
synchronization (blocking), but it doesn't look safe for error
processing. Once the buffer lock is dropped, who says b_error is from
our write (and not a subsequent, for example) and thus this caller's
responsibility to handle the error? I suspect this is a reason the lock
is typically held across a sync I/O, so the error is valid after the
I/O.

Also, it looks like blocking on async I/O as such opens up the
possibility of blocking indefinitely on failing writes if the right
combination of delwri and b_iodone handler is used (see
xfs_buf_iodone_callbacks()). I'm not sure if that's a real problem
today, though.

>  		xfs_buf_relse(bp);
>  		if (!error)
>  			error = error2;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d8f57f6..0acfc30 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -290,8 +290,8 @@ extern int xfs_bwrite(struct xfs_buf *bp);
>  extern void xfs_buf_ioend(struct xfs_buf *bp);
>  extern void xfs_buf_ioerror(xfs_buf_t *, int);
>  extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
> -extern void xfs_buf_iorequest(xfs_buf_t *);
> -extern int xfs_buf_iowait(xfs_buf_t *);
> +extern void xfs_buf_submit(struct xfs_buf *bp);
> +extern int xfs_buf_submit_wait(struct xfs_buf *bp);
>  extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
>  				xfs_buf_rw_t);
>  #define xfs_buf_zero(bp, off, len) \
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 4fd41b5..cbea909 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1081,7 +1081,7 @@ xfs_buf_iodone_callbacks(
>  	 * a way to shut the filesystem down if the writes keep failing.
>  	 *
>  	 * In practice we'll shut the filesystem down soon as non-transient
> -	 * erorrs tend to affect the whole device and a failing log write
> +	 * errors tend to affect the whole device and a failing log write
>  	 * will make us give up.  But we really ought to do better here.
>  	 */
>  	if (XFS_BUF_ISASYNC(bp)) {
> @@ -1094,7 +1094,7 @@ xfs_buf_iodone_callbacks(
>  		if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
>  			bp->b_flags |= XBF_WRITE | XBF_ASYNC |
>  				       XBF_DONE | XBF_WRITE_FAIL;
> -			xfs_buf_iorequest(bp);
> +			xfs_buf_submit(bp);
>  		} else {
>  			xfs_buf_relse(bp);
>  		}
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e4665db..c4d7f79 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1699,7 +1699,7 @@ xlog_bdstrat(
>  		return 0;
>  	}
>  
> -	xfs_buf_iorequest(bp);
> +	xfs_buf_submit(bp);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4ba19bf..1e14452 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -193,12 +193,8 @@ xlog_bread_noalign(
>  	bp->b_io_length = nbblks;
>  	bp->b_error = 0;
>  
> -	if (XFS_FORCED_SHUTDOWN(log->l_mp))
> -		return -EIO;
> -
> -	xfs_buf_iorequest(bp);
> -	error = xfs_buf_iowait(bp);
> -	if (error)
> +	error = xfs_buf_submit_wait(bp);
> +	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp))
>  		xfs_buf_ioerror_alert(bp, __func__);
>  	return error;
>  }
> @@ -4427,16 +4423,12 @@ xlog_do_recover(
>  	XFS_BUF_UNASYNC(bp);
>  	bp->b_ops = &xfs_sb_buf_ops;
>  
> -	if (XFS_FORCED_SHUTDOWN(log->l_mp)) {
> -		xfs_buf_relse(bp);
> -		return -EIO;
> -	}
> -
> -	xfs_buf_iorequest(bp);
> -	error = xfs_buf_iowait(bp);
> +	error = xfs_buf_submit_wait(bp);
>  	if (error) {
> -		xfs_buf_ioerror_alert(bp, __func__);
> -		ASSERT(0);
> +		if (XFS_FORCED_SHUTDOWN(log->l_mp)) {

Should this be !XFS_FORCED_SHUTDOWN()?

Brian

> +			xfs_buf_ioerror_alert(bp, __func__);
> +			ASSERT(0);
> +		}
>  		xfs_buf_relse(bp);
>  		return error;
>  	}
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 9c3e610..4bdf02c 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -286,18 +286,13 @@ xfs_trans_read_buf_map(
>  			bp->b_flags |= XBF_READ;
>  			bp->b_ops = ops;
>  
> -			if (XFS_FORCED_SHUTDOWN(mp)) {
> -				trace_xfs_bdstrat_shut(bp, _RET_IP_);
> -				error = -EIO;
> -				goto out_stale;
> -			}
> -
> -			xfs_buf_iorequest(bp);
> -			error = xfs_buf_iowait(bp);
> +			error = xfs_buf_submit_wait(bp);
>  			if (error) {
> -				xfs_buf_ioerror_alert(bp, __func__);
> -				goto out_do_shutdown;
> -
> +				if (!XFS_FORCED_SHUTDOWN(mp)) {
> +					xfs_buf_ioerror_alert(bp, __func__);
> +					goto out_do_shutdown;
> +				}
> +				goto out_stale;
>  			}
>  		}
>  
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
