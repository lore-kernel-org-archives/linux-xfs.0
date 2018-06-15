Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966024AbeFOQcM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 12:32:12 -0400
Date: Fri, 15 Jun 2018 09:31:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] xfs: use sync buffer I/O for sync delwri queue
 submission
Message-ID: <20180615163138.GE8128@magnolia>
References: <20180613110516.65494-1-bfoster@redhat.com>
 <20180613110516.65494-3-bfoster@redhat.com>
 <20180615112820.GB3230@infradead.org>
 <20180615115334.GC2857@bfoster>
 <20180615121602.GA32099@infradead.org>
 <20180615123956.GD2857@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615123956.GD2857@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 08:39:56AM -0400, Brian Foster wrote:
> On Fri, Jun 15, 2018 at 05:16:02AM -0700, Christoph Hellwig wrote:
> > On Fri, Jun 15, 2018 at 07:53:35AM -0400, Brian Foster wrote:
> > > Not totally sure I follow... do you essentially mean to rename
> > > xfs_buf_submit_wait() -> xfs_buf_submit() and make the iowait
> > > conditional on !XBF_ASYNC and absence of some new "sync_nowait"
> > > parameter to the function? Could you clarify how you envision the
> > > updated xfs_buf_submit() function signature to look?
> > > 
> > > If I'm following correctly, that seems fairly reasonable at first
> > > thought. This is a separate patch though (refactoring the interface vs.
> > > refactoring the implementation to fix a bug).
> > 
> > Well.  I'd suggest something like the patch below for patch 1:
> > 
> 
> Ok, codewise I don't have much of a preference, but I don't think it's
> worth redoing the regression testing and lowmem testing and whatnot just
> to change how the guts are refactored here. What's the endgame? I came
> up with the following on top of patch 2. Compile tested only, and I can
> refold the _common() helper back into the caller and invert the
> nowait logic or whatnot..

Whatever you all decide, would you mind adding a comment to xfs_buf.c
describing how delwri buffers are supposed to work, particularly with
regard to what are the buffer states specific to delwri lists, and how
the wait list that gets passed around works?  I need to check my
assumptions about how this mechanism functions. :)

(AKA I looked at both versions, thought 'this delwri queue list stuff
looks rather clever...' and then promptly got distracted by mkfs-config
and other stuff. :/)

--D

> Brian
> 
> --- 8< ---
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 311ca301b7fd..89d8cedf2828 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -757,11 +757,7 @@ _xfs_buf_read(
>  	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
>  	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
>  
> -	if (flags & XBF_ASYNC) {
> -		xfs_buf_submit(bp);
> -		return 0;
> -	}
> -	return xfs_buf_submit_wait(bp);
> +	return xfs_buf_submit(bp);
>  }
>  
>  xfs_buf_t *
> @@ -846,7 +842,7 @@ xfs_buf_read_uncached(
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = ops;
>  
> -	xfs_buf_submit_wait(bp);
> +	xfs_buf_submit(bp);
>  	if (bp->b_error) {
>  		int	error = bp->b_error;
>  		xfs_buf_relse(bp);
> @@ -1249,7 +1245,7 @@ xfs_bwrite(
>  	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
>  			 XBF_WRITE_FAIL | XBF_DONE);
>  
> -	error = xfs_buf_submit_wait(bp);
> +	error = xfs_buf_submit(bp);
>  	if (error) {
>  		xfs_force_shutdown(bp->b_target->bt_mount,
>  				   SHUTDOWN_META_IO_ERROR);
> @@ -1459,7 +1455,7 @@ _xfs_buf_ioapply(
>   * itself.
>   */
>  static int
> -__xfs_buf_submit(
> +__xfs_buf_submit_common(
>  	struct xfs_buf	*bp)
>  {
>  	trace_xfs_buf_submit(bp, _RET_IP_);
> @@ -1505,32 +1501,6 @@ __xfs_buf_submit(
>  	return 0;
>  }
>  
> -void
> -xfs_buf_submit(
> -	struct xfs_buf	*bp)
> -{
> -	int		error;
> -
> -	ASSERT(bp->b_flags & XBF_ASYNC);
> -
> -	/*
> -	 * The caller's reference is released during I/O completion.
> -	 * This occurs some time after the last b_io_remaining reference is
> -	 * released, so after we drop our Io reference we have to have some
> -	 * other reference to ensure the buffer doesn't go away from underneath
> -	 * us. Take a direct reference to ensure we have safe access to the
> -	 * buffer until we are finished with it.
> -	 */
> -	xfs_buf_hold(bp);
> -
> -	error = __xfs_buf_submit(bp);
> -	if (error)
> -		xfs_buf_ioend(bp);
> -
> -	/* Note: it is not safe to reference bp now we've dropped our ref */
> -	xfs_buf_rele(bp);
> -}
> -
>  /*
>   * Wait for I/O completion of a sync buffer and return the I/O error code.
>   */
> @@ -1549,30 +1519,33 @@ xfs_buf_iowait(
>   * Synchronous buffer IO submission path, read or write.
>   */
>  int
> -xfs_buf_submit_wait(
> -	struct xfs_buf	*bp)
> +__xfs_buf_submit(
> +	struct xfs_buf	*bp,
> +	bool		sync_nowait)
>  {
>  	int		error;
>  
> -	ASSERT(!(bp->b_flags & XBF_ASYNC));
> -
>  	/*
> -	 * For synchronous IO, the IO does not inherit the submitters reference
> -	 * count, nor the buffer lock. Hence we cannot release the reference we
> -	 * are about to take until we've waited for all IO completion to occur,
> -	 * including any xfs_buf_ioend_async() work that may be pending.
> +	 * Grab a reference so the buffer does not go away underneath us. For
> +	 * async buffers, I/O completion drops the callers reference, which
> +	 * could occur before submission returns.
>  	 */
>  	xfs_buf_hold(bp);
>  
> -	error = __xfs_buf_submit(bp);
> -	if (error)
> +	error = __xfs_buf_submit_common(bp);
> +	if (error) {
> +		if (bp->b_flags & XBF_ASYNC)
> +			xfs_buf_ioend(bp);
>  		goto out;
> -	error = xfs_buf_iowait(bp);
> +	}
>  
> +	if (!(bp->b_flags & XBF_ASYNC) && !sync_nowait)
> +		error = xfs_buf_iowait(bp);
>  out:
>  	/*
> -	 * all done now, we can release the hold that keeps the buffer
> -	 * referenced for the entire IO.
> +	 * Release the hold that keeps the buffer referenced for the entire
> +	 * I/O. Note that if the buffer is async, it is not safe to reference
> +	 * after this release.
>  	 */
>  	xfs_buf_rele(bp);
>  	return error;
> @@ -1984,6 +1957,7 @@ xfs_buf_delwri_submit_buffers(
>  	LIST_HEAD		(submit_list);
>  	int			pinned = 0;
>  	struct blk_plug		plug;
> +	bool			nowait = false;
>  
>  	list_sort(NULL, buffer_list, xfs_buf_cmp);
>  
> @@ -2025,12 +1999,12 @@ xfs_buf_delwri_submit_buffers(
>  		if (wait_list) {
>  			bp->b_flags &= ~XBF_ASYNC;
>  			list_move_tail(&bp->b_list, wait_list);
> -			__xfs_buf_submit(bp);
> +			nowait = true;
>  		} else {
>  			bp->b_flags |= XBF_ASYNC;
>  			list_del_init(&bp->b_list);
> -			xfs_buf_submit(bp);
>  		}
> +		__xfs_buf_submit(bp, nowait);
>  	}
>  	blk_finish_plug(&plug);
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d24dbd4dac39..9bae5c201003 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -298,8 +298,13 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
>  		xfs_failaddr_t failaddr);
>  #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
>  extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
> -extern void xfs_buf_submit(struct xfs_buf *bp);
> -extern int xfs_buf_submit_wait(struct xfs_buf *bp);
> +
> +extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
> +static inline int xfs_buf_submit(struct xfs_buf *bp)
> +{
> +	return __xfs_buf_submit(bp, false);
> +}
> +
>  extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
>  				xfs_buf_rw_t);
>  #define xfs_buf_zero(bp, off, len) \
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b181b5f57a19..724a76d87564 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -196,7 +196,7 @@ xlog_bread_noalign(
>  	bp->b_io_length = nbblks;
>  	bp->b_error = 0;
>  
> -	error = xfs_buf_submit_wait(bp);
> +	error = xfs_buf_submit(bp);
>  	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp))
>  		xfs_buf_ioerror_alert(bp, __func__);
>  	return error;
> @@ -5707,7 +5707,7 @@ xlog_do_recover(
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = &xfs_sb_buf_ops;
>  
> -	error = xfs_buf_submit_wait(bp);
> +	error = xfs_buf_submit(bp);
>  	if (error) {
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_buf_ioerror_alert(bp, __func__);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
