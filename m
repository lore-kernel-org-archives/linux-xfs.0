Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3GIOX8171757 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 10:18:24 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: cleanup data end I/O handlers
Date: Tue, 3 Nov 2009 10:18:34 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE62@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091030091147.GB23188@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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

Christoph Hellwig wrote:
> Currently we have various different end I/O handler for read vs the different
> types of write I/O.  But they are all very similar so we could just use one
> with a few conditionals and reduce code size a lot.

When I was looking at the last patch I had the same
thought, so I'm glad you did this.

The patch is good--here are a few thoughts so you
can correct me if I'm misunderstanding something...

I note that you now call xfs_setfilesize() in the
IOMAP_UNWRITTEN case even if there was an I/O error
indicated, which is different from current code.
But that's OK because xfs_setfilesize() checks for
that condition, so the result is the same.

I also note that you no longer init the work queue
at the end of a non-extending direct I/O write.
But that too is OK, because it looks like the only
reason it was initialized there was so that the
work function pointer would change, for the benefit
of xfs_finish_ioend().  But you changed that to
make use of the io_type, which is a better way of
doing it anyway.

In summary...  Looks good, I like it.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-10-30 10:05:46.680256053 +0100
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-10-30 10:08:54.235024030 +0100
> @@ -235,71 +235,36 @@ xfs_setfilesize(
>  }
> 
>  /*
> - * Buffered IO write completion for delayed allocate extents.
> + * IO write completion.
>   */
>  STATIC void
> -xfs_end_bio_delalloc(
> -	struct work_struct	*work)
> -{
> -	xfs_ioend_t		*ioend =
> -		container_of(work, xfs_ioend_t, io_work);
> -
> -	xfs_setfilesize(ioend);
> -	xfs_destroy_ioend(ioend);
> -}
> -
> -/*
> - * Buffered IO write completion for regular, written extents.
> - */
> -STATIC void
> -xfs_end_bio_written(
> -	struct work_struct	*work)
> -{
> -	xfs_ioend_t		*ioend =
> -		container_of(work, xfs_ioend_t, io_work);
> -
> -	xfs_setfilesize(ioend);
> -	xfs_destroy_ioend(ioend);
> -}
> -
> -/*
> - * IO write completion for unwritten extents.
> - *
> - * Issue transactions to convert a buffer range from unwritten
> - * to written extents.
> - */
> -STATIC void
> -xfs_end_bio_unwritten(
> +xfs_end_io(
>  	struct work_struct	*work)
>  {
>  	xfs_ioend_t		*ioend =
>  		container_of(work, xfs_ioend_t, io_work);
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> -	xfs_off_t		offset = ioend->io_offset;
> -	size_t			size = ioend->io_size;
> 
> -	if (likely(!ioend->io_error)) {
> -		if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
> -			int error;
> -			error = xfs_iomap_write_unwritten(ip, offset, size);
> -			if (error)
> -				ioend->io_error = error;
> -		}
> -		xfs_setfilesize(ioend);
> +	/*
> +	 * For unwritten extents we need to issue transactions to convert a
> +	 * range to normal written extens after the data I/O has finished.
> +	 */
> +	if (ioend->io_type == IOMAP_UNWRITTEN &&
> +	    likely(!ioend->io_error && !XFS_FORCED_SHUTDOWN(ip->i_mount))) {
> +		int error;
> +
> +		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
> +						 ioend->io_size);
> +		if (error)
> +			ioend->io_error = error;
>  	}
> -	xfs_destroy_ioend(ioend);
> -}
> -
> -/*
> - * IO read completion for regular, written extents.
> - */
> -STATIC void
> -xfs_end_bio_read(
> -	struct work_struct	*work)
> -{
> -	xfs_ioend_t		*ioend =
> -		container_of(work, xfs_ioend_t, io_work);
> 
> +	/*
> +	 * We might have to update the on-disk file size after extending
> +	 * writes.
> +	 */
> +	if (ioend->io_type != IOMAP_READ)
> +		xfs_setfilesize(ioend);
>  	xfs_destroy_ioend(ioend);
>  }
> 
> @@ -314,10 +279,10 @@ xfs_finish_ioend(
>  	int		wait)
>  {
>  	if (atomic_dec_and_test(&ioend->io_remaining)) {
> -		struct workqueue_struct *wq = xfsdatad_workqueue;
> -		if (ioend->io_work.func == xfs_end_bio_unwritten)
> -			wq = xfsconvertd_workqueue;
> +		struct workqueue_struct *wq;
> 
> +		wq = (ioend->io_type == IOMAP_UNWRITTEN) ?
> +			xfsconvertd_workqueue : xfsdatad_workqueue;
>  		queue_work(wq, &ioend->io_work);
>  		if (wait)
>  			flush_workqueue(wq);
> @@ -355,15 +320,7 @@ xfs_alloc_ioend(
>  	ioend->io_offset = 0;
>  	ioend->io_size = 0;
> 
> -	if (type == IOMAP_UNWRITTEN)
> -		INIT_WORK(&ioend->io_work, xfs_end_bio_unwritten);
> -	else if (type == IOMAP_DELAY)
> -		INIT_WORK(&ioend->io_work, xfs_end_bio_delalloc);
> -	else if (type == IOMAP_READ)
> -		INIT_WORK(&ioend->io_work, xfs_end_bio_read);
> -	else
> -		INIT_WORK(&ioend->io_work, xfs_end_bio_written);
> -
> +	INIT_WORK(&ioend->io_work, xfs_end_io);
>  	return ioend;
>  }
> 
> @@ -1538,7 +1495,7 @@ xfs_end_io_direct(
>  		 * didn't map an unwritten extent so switch it's completion
>  		 * handler.
>  		 */
> -		INIT_WORK(&ioend->io_work, xfs_end_bio_written);
> +		ioend->io_type = IOMAP_NEW;
>  		xfs_finish_ioend(ioend, 0);
>  	}
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
