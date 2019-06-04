Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38352 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbfFDFyQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 01:54:16 -0400
Date: Tue, 4 Jun 2019 15:54:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/20] xfs: use bios directly to write log buffers
Message-ID: <20190604055408.GP29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:38PM +0200, Christoph Hellwig wrote:
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

Overall a good cleanup, comments inline.

FWIW, what does ic_sema protect?  It looks to me like it just
replaces the xfs_buf_lock(), and the only reason we were using that
is to allow unmount to wait for iclogbuf IO completion. Can we just
use a completion for this now?

> ---
>  fs/xfs/xfs_log.c      | 220 ++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_priv.h |  15 +--
>  2 files changed, 112 insertions(+), 123 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 358a19789402..1d4480ea1725 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1239,32 +1239,32 @@ xlog_space_left(
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
> +
> +	if (is_vmalloc_addr(iclog->ic_data))
> +		invalidate_kernel_vmap_range(iclog->ic_data, iclog->ic_io_size);

Do we need to invalidate here for write only operation?  It's only
when we are bringing new data into memory we have to invalidate the
range, right?  e.g. xfs_buf_bio_end_io() only does invalidation on
read IO. 

> @@ -1475,30 +1473,6 @@ xlog_alloc_log(
>  
>  	xlog_get_iclog_buffer_size(mp, log);
>  
> -	/*
> -	 * Use a NULL block for the extra log buffer used during splits so that
> -	 * it will trigger errors if we ever try to do IO on it without first
> -	 * having set it up properly.
> -	 */
> -	error = -ENOMEM;
> -	bp = xfs_buf_alloc(log->l_targ, XFS_BUF_DADDR_NULL,
> -			   BTOBB(log->l_iclog_size), XBF_NO_IOACCT);
> -	if (!bp)
> -		goto out_free_log;
> -
> -	/*
> -	 * The iclogbuf buffer locks are held over IO but we are not going to do
> -	 * IO yet.  Hence unlock the buffer so that the log IO path can grab it
> -	 * when appropriately.
> -	 */
> -	ASSERT(xfs_buf_islocked(bp));
> -	xfs_buf_unlock(bp);
> -
> -	/* use high priority wq for log I/O completion */
> -	bp->b_ioend_wq = mp->m_log_workqueue;
> -	bp->b_iodone = xlog_iodone;
> -	log->l_xbuf = bp;
> -
>  	spin_lock_init(&log->l_icloglock);
>  	init_waitqueue_head(&log->l_flush_wait);
>  
> @@ -1512,7 +1486,9 @@ xlog_alloc_log(
>  	 */
>  	ASSERT(log->l_iclog_size >= 4096);
>  	for (i=0; i < log->l_iclog_bufs; i++) {

Fix the whitespace while you are touching this code?

> -		*iclogp = kmem_zalloc(sizeof(xlog_in_core_t), KM_MAYFAIL);
> +		*iclogp = kmem_zalloc(struct_size(*iclogp, ic_bvec,
> +				howmany(log->l_iclog_size, PAGE_SIZE)),
> +				KM_MAYFAIL);

That's a bit of a mess - hard to read. It's times like this that I
think generic helpers make the code worse rather than bettter.
Perhaps some slightly different indenting to indicate that the
howmany() function is actually a parameter of the struct_size()
macro?

		*iclogp = kmem_zalloc(struct_size(*iclogp, ic_bvec,
					howmany(log->l_iclog_size, PAGE_SIZE)),
				      KM_MAYFAIL);

> +static void
> +xlog_bio_end_io(
> +	struct bio		*bio)
> +{
> +	struct xlog_in_core	*iclog = bio->bi_private;
> +
> +	queue_work(iclog->ic_log->l_mp->m_log_workqueue,
> +		   &iclog->ic_end_io_work);
> +}

Can we just put a pointer to the wq in the iclog? It only needs to
be set up at init time, then this only needs to be

	queue_work(iclog->ic_wq, &iclog->ic_end_io_work);

> +
> +static void
> +xlog_map_iclog_data(
> +	struct bio		*bio,
> +	void			*data,
> +	size_t			count)
> +{
> +	do {
> +		struct page	*page = kmem_to_page(data);
> +		unsigned int	off = offset_in_page(data);
> +		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
> +
> +		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
> +
> +		data += len;
> +		count -= len;
> +	} while (count);
> +}

Aren't we're always going to be mapping the same pages to the same
bio at the same offsets. The only thing that changes is the length
of the bio and the sector it is addressed to. It seems kind of odd
to have an inline data buffer, bio and biovec all pre-allocated, but
then have to map them into exactly the same state for every IO we do
with them...

> @@ -1786,11 +1772,10 @@ xlog_write_iclog(
>  	 * tearing down the iclogbufs.  Hence we need to hold the buffer lock
>  	 * across the log IO to archieve that.
>  	 */
> -	xfs_buf_lock(bp);
> +	down(&iclog->ic_sema);
>  	if (unlikely(iclog->ic_state & XLOG_STATE_IOERROR)) {
> -		xfs_buf_ioerror(bp, -EIO);
> -		xfs_buf_stale(bp);
> -		xfs_buf_ioend(bp);
> +		xlog_state_done_syncing(iclog, XFS_LI_ABORTED);
> +		up(&iclog->ic_sema);

Hmmm - this open codes the end io error completion. Might be wroth a
comment indicating that this needs to be kept in sync with the io
completion processing?

> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b5f82cb36202..062ee9c13039 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -179,7 +179,6 @@ typedef struct xlog_ticket {
>   *	the iclog.
>   * - ic_forcewait is used to implement synchronous forcing of the iclog to disk.
>   * - ic_next is the pointer to the next iclog in the ring.
> - * - ic_bp is a pointer to the buffer used to write this incore log to disk.
>   * - ic_log is a pointer back to the global log structure.
>   * - ic_callback is a linked list of callback function/argument pairs to be
>   *	called after an iclog finishes writing.
> @@ -206,11 +205,10 @@ typedef struct xlog_in_core {
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

Can we get a couple of comments here describing the difference
between ic_size, ic_io_size and log->l_iclog_size so I don't have to
go read all the code to find out what they are again in 6 months
time?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
