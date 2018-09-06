Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729388AbeIFSIA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Sep 2018 14:08:00 -0400
Date: Thu, 6 Sep 2018 09:32:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] mkfs: Use AIO for batched writeback
Message-ID: <20180906133224.GD3311@bfoster>
References: <20180905081932.27478-1-david@fromorbit.com>
 <20180905081932.27478-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180905081932.27478-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 05, 2018 at 06:19:32PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> What it says. 8EB filesystem can now be made in 15 minutes on
> storage that can do 100,000 IOPS. Before this patch mkfs topped out
> at about 13,000 IOPS.
> 
> Proof of concept proven.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/libxfs_io.h |   1 +
>  libxfs/rdwr.c      | 170 +++++++++++++++++++++++++++++++++++++++++++--
>  mkfs/Makefile      |   2 +-
>  mkfs/xfs_mkfs.c    |   2 +-
>  4 files changed, 169 insertions(+), 6 deletions(-)
> 
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index c69cc7cd7ec5..2b11d008998d 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -67,6 +67,7 @@ typedef struct xfs_buf {
>  	struct xfs_buf_map	__b_map;
>  	int			b_nmaps;
>  	struct list_head	b_list;
> +	int			b_io_count;
>  #ifdef XFS_BUF_TRACING
>  	struct list_head	b_lock_list;
>  	const char		*b_func;
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 7fbaae571abe..5336f6a1e1de 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -20,6 +20,9 @@
>  
>  #include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
>  
> +/* XXX: all the aio stuff is hacky and proof of concept only */
> +#include <libaio.h>
> +
>  /*
>   * Important design/architecture note:
>   *
> @@ -1236,6 +1239,151 @@ xfs_buf_cmp(
>  	return 0;
>  }
>  
> +/* hacky AIO stuff that'll handle a single delwri queue flush at a time */
> +#define MAX_AIO_EVENTS 1024
> +io_context_t ctxp;
> +struct iocb *iocbs[MAX_AIO_EVENTS];
> +struct io_event ioevents[MAX_AIO_EVENTS];
> +int aio_next;
> +int aio_flight;
> +
> +static void
> +init_aio_delwri(void)
> +{
> +	int i, r;
> +
> +	memset(&ctxp, 0, sizeof(ctxp));
> +	r = io_setup(MAX_AIO_EVENTS, &ctxp);
> +	if (r) {
> +		printf("FAIL! io_setup returned %d\n", r);
> +		exit(1);
> +	}
> +	for (i = 0; i < MAX_AIO_EVENTS; ++i) {
> +		iocbs[i] = calloc(1, sizeof(struct iocb));
> +		if (iocbs[i] == NULL) {
> +			printf("failed to allocate an iocb\n");
> +			exit(1);
> +		}
> +	}
> +}
> +
> +int
> +get_write_completions(
> +	int	threshold)
> +{
> +	int	error = 0;
> +	int	i, r;
> +
> +	while (aio_flight > threshold) {
> +		/* gather up some completions */
> +		r = io_getevents(ctxp, 1, MAX_AIO_EVENTS, ioevents, NULL);
> +		if (r < 0)  {
> +			printf("FAIL! io_getevents returned %d\n", r);
> +			exit(1);
> +		}
> +
> +		aio_flight -= r;
> +		for (i = 0; i < r; ++i) {
> +			struct xfs_buf *bp = ioevents[i].data;
> +			if (ioevents[i].res < 0)
> +				bp->b_error = ioevents[i].res;
> +			else if (ioevents[i].res != bp->b_bcount)
> +				bp->b_error = -EIO;
> +
> +			if (--bp->b_io_count == 0 && !bp->b_error) {
> +				bp->b_flags |= LIBXFS_B_UPTODATE;
> +				bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT |
> +						 LIBXFS_B_UNCHECKED);

I'd think we need these flags updates on the submission side
->b_io_count decrement as well, but I guess the single-threadedness of
the whole things dictates that I/O will only ever complete here.

Which begs the question.. why elevate ->b_io_count in the delwri submit
path at all? FWIW, I can see writing this consistently either way: take
the I/O ref and handle completion in both places, or rely on the fact
that completion occurs in one place and the flush only needs to know if
the buffer count is still elevated immediately after submission.

> +				libxfs_putbuf(bp);
> +			} else if (!error) {
> +				error = bp->b_error;
> +			}
> +		}
> +		/* wait for a short while */
> +		usleep(1000);
> +	}
> +	return error;
> +}
> +
> +static int
> +__aio_write(
> +	struct xfs_buf  *bp,
> +	void *buf,
> +	int len,
> +	off64_t offset)
> +{
> +	int	r, i;
> +	int	fd = libxfs_device_to_fd(bp->b_target->dev);
> +
> +	i = aio_next++ % MAX_AIO_EVENTS;
> +	aio_flight++;
> +	bp->b_io_count++;
> +
> +	io_prep_pwrite(iocbs[i], fd, buf, len, offset);
> +	iocbs[i]->data = bp;
> +	r = io_submit(ctxp, 1, &iocbs[i]);
> +	if (r != 1) {
> +		aio_flight--;

Probably need to decrement ->b_io_count here as well..?

Brian

> +		if (bp->b_flags & LIBXFS_B_EXIT)
> +			exit(1);
> +		return -EIO;
> +	}
> +	return 0;
> +
> +}
> +
> +static int
> +do_write(
> +	struct xfs_buf	*bp)
> +{
> +	/*
> +	 * we never write buffers that are marked stale. This indicates they
> +	 * contain data that has been invalidated, and even if the buffer is
> +	 * dirty it must *never* be written. Verifiers are wonderful for finding
> +	 * bugs like this. Make sure the error is obvious as to the cause.
> +	 */
> +	if (bp->b_flags & LIBXFS_B_STALE) {
> +		bp->b_error = -ESTALE;
> +		return bp->b_error;
> +	}
> +
> +	/*
> +	 * clear any pre-existing error status on the buffer. This can occur if
> +	 * the buffer is corrupt on disk and the repair process doesn't clear
> +	 * the error before fixing and writing it back.
> +	 */
> +	bp->b_error = 0;
> +	if (bp->b_ops) {
> +		bp->b_ops->verify_write(bp);
> +		if (bp->b_error) {
> +			fprintf(stderr,
> +	_("%s: write verifer failed on %s bno 0x%llx/0x%x\n"),
> +				__func__, bp->b_ops->name,
> +				(long long)bp->b_bn, bp->b_bcount);
> +			return bp->b_error;
> +		}
> +	}
> +
> +	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
> +		bp->b_error = __aio_write(bp, bp->b_addr, bp->b_bcount,
> +				    LIBXFS_BBTOOFF64(bp->b_bn));
> +	} else {
> +		int	i;
> +		void	*buf = bp->b_addr;
> +
> +		for (i = 0; i < bp->b_nmaps; i++) {
> +			off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
> +			int len = BBTOB(bp->b_maps[i].bm_len);
> +
> +			bp->b_error = __aio_write(bp, buf, len, offset);
> +			if (bp->b_error)
> +				break;	/* XXX: completion wait required! */
> +			buf += len;
> +		}
> +	}
> +	return bp->b_error;
> +}
> +
>  /* Processes entire list, but only returns the first error found */
>  int
>  libxfs_buf_delwri_flush(
> @@ -1243,21 +1391,35 @@ libxfs_buf_delwri_flush(
>  {
>  	struct xfs_buf		*bp;
>  	int			 error = 0;
> +	static bool		aio_init = false;
> +	int			ret;
> +
> +	if (!aio_init) {
> +		init_aio_delwri();
> +		aio_init = true;
> +	}
>  
>  	list_sort(NULL, delwri_list, xfs_buf_cmp);
>  	while (!list_empty(delwri_list)) {
>  		bp = list_first_entry(delwri_list, struct xfs_buf, b_list);
>  		list_del_init(&bp->b_list);
>  		bp->b_flags &= ~LIBXFS_B_DELWRI_Q;
> +		bp->b_io_count = 1;
>  		if (!bp->b_error && (bp->b_flags & LIBXFS_B_DIRTY)) {
> -			int ret;
> -			ret = libxfs_writebufr(bp);
> +			ret = do_write(bp);
>  			if (ret && !error)
>  				error = ret;
>  		}
> -		libxfs_putbuf(bp);
> +		if (--bp->b_io_count == 0)
> +			libxfs_putbuf(bp);
> +
> +		/* wait for some completions if we've dispatched lots */
> +		ret = get_write_completions(MAX_AIO_EVENTS / 5 * 4);
> +		if (ret && !error)
> +			error = ret;
>  	}
> -	return error;
> +	ret = get_write_completions(0);
> +	return error ? error : ret;
>  }
>  
>  
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 31482b08d559..e27f10f26b14 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -11,7 +11,7 @@ HFILES =
>  CFILES = proto.c xfs_mkfs.c
>  
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
> -	$(LIBUUID)
> +	$(LIBUUID) -laio
>  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
>  
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b751b1fcb4a3..82e041dd1b48 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4048,7 +4048,7 @@ main(
>  		initialise_ag_headers(&cfg, mp, sbp, agno, &freelist_size,
>  				      &delwri_list);
>  		initialise_ag_freespace(mp, agno, freelist_size, &delwri_list);
> -		if (agno && !(agno % 100))
> +		if (agno && !(agno % 1000))
>  			libxfs_buf_delwri_flush(&delwri_list);
>  	}
>  	libxfs_buf_delwri_flush(&delwri_list);
> -- 
> 2.17.0
> 
