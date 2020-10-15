Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE36C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DEAE20760
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:28:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h2FihWiS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgJOS2N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:28:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgJOS2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 14:28:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FI9rUx109409;
        Thu, 15 Oct 2020 18:28:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Q8ypZoktARVYGtnSAxxzOMhQCFw2LQ9eH1FdPW5zkWo=;
 b=h2FihWiSddfu8cMK9Z3X5DclHw0+tktahu9x5GQ6tiL/cM5ZfgSzGqR8g0vKpPn3U5SU
 UeggXVBfGhyAOuiNKRWsZ5x30qJ1KhTpcG0wssAiH2fdUEYmA9VDl3/hNT5Clx378x7Y
 Gmz30FXt3QGP9naIEG0GsbcFst+JlIuZHe4exQzEaEOfnW2Mr0UZNuYpSjJ+Yjdt2ZcJ
 RCiiO+ompkjS9VHScZCe5suANz6ygxY/9Fa2Lj481P+GeGfIJSgnFVe72D+GNt59gmv0
 l1zb50s34wSMHQ7J9ZlqG7vsXpMQrZjA30EU2f6lp8xsqEXAwlim3d0iWOSUHI76BcNl 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 343vaemnak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:28:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FIBlqw175622;
        Thu, 15 Oct 2020 18:26:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 343phreev6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 18:26:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09FIQ89c004966;
        Thu, 15 Oct 2020 18:26:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 11:26:08 -0700
Date:   Thu, 15 Oct 2020 11:26:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/27] libxfs: convert sync IO buftarg engine to AIO
Message-ID: <20201015182607.GA9832@magnolia>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-28-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015072155.1631135-28-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=59
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=59 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150122
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 06:21:55PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Simple per-ag thread based completion engine. Will have issues with
> large AG counts.

Hm, I missed how any of this is per-AG... all I saw was an aio control
context that's attached to the buftarg.

> XXX: should this be combined with the struct btcache?
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/atomic.h           |   7 +-
>  include/builddefs.in       |   2 +-
>  include/platform_defs.h.in |   1 +
>  libxfs/buftarg.c           | 202 +++++++++++++++++++++++++++++++------
>  libxfs/xfs_buf.h           |   6 ++
>  libxfs/xfs_buftarg.h       |   7 ++
>  6 files changed, 191 insertions(+), 34 deletions(-)
> 
> diff --git a/include/atomic.h b/include/atomic.h
> index 5860d7897ae5..8727fc4ddae9 100644
> --- a/include/atomic.h
> +++ b/include/atomic.h
> @@ -27,8 +27,11 @@ typedef	int64_t	atomic64_t;
>  #define atomic_inc_return(a)	uatomic_add_return(a, 1)
>  #define atomic_dec_return(a)	uatomic_sub_return(a, 1)
>  
> -#define atomic_inc(a)		atomic_inc_return(a)
> -#define atomic_dec(a)		atomic_inc_return(a)
> +#define atomic_add(a, v)	uatomic_add(a, v)
> +#define atomic_sub(a, v)	uatomic_sub(a, v)
> +
> +#define atomic_inc(a)		uatomic_inc(a)
> +#define atomic_dec(a)		uatomic_dec(a)

Does this belong in the liburcu patch?

>  
>  #define atomic_dec_and_test(a)	(atomic_dec_return(a) == 0)
>  
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 78eddf4a9852..c20a48f6258c 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -29,7 +29,7 @@ LIBEDITLINE = @libeditline@
>  LIBBLKID = @libblkid@
>  LIBDEVMAPPER = @libdevmapper@
>  LIBINIH = @libinih@
> -LIBXFS = $(TOPDIR)/libxfs/libxfs.la
> +LIBXFS = $(TOPDIR)/libxfs/libxfs.la -laio

This needs all the autoconf magic to complain if libaio isn't installed,
right?

>  LIBFROG = $(TOPDIR)/libfrog/libfrog.la
>  LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
>  LIBXLOG = $(TOPDIR)/libxlog/libxlog.la
> diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
> index 8af43f3b8d8a..7c30a43eb951 100644
> --- a/include/platform_defs.h.in
> +++ b/include/platform_defs.h.in
> @@ -24,6 +24,7 @@
>  #include <stdbool.h>
>  #include <libgen.h>
>  #include <urcu.h>
> +#include <libaio.h>
>  
>  typedef struct filldir		filldir_t;
>  
> diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
> index df968c66c205..e1e5f41b423c 100644
> --- a/libxfs/buftarg.c
> +++ b/libxfs/buftarg.c
> @@ -259,11 +259,16 @@ xfs_buftarg_alloc(
>  	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
>  		goto error_lru;
>  
> -	if (xfs_buftarg_mempressue_init(btp))
> +	if (xfs_buftarg_aio_init(&btp->bt_aio))
>  		goto error_pcp;
>  
> +	if (xfs_buftarg_mempressue_init(btp))
> +		goto error_aio;
> +
>  	return btp;
>  
> +error_aio:
> +	xfs_buftarg_aio_destroy(btp->bt_aio);
>  error_pcp:
>  	percpu_counter_destroy(&btp->bt_io_count);
>  error_lru:
> @@ -286,6 +291,7 @@ xfs_buftarg_free(
>  	if (btp->bt_psi_fd >= 0)
>  		close(btp->bt_psi_fd);
>  
> +	xfs_buftarg_aio_destroy(btp->bt_aio);
>  	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
>  	percpu_counter_destroy(&btp->bt_io_count);
>  	platform_flush_device(btp->bt_fd, btp->bt_bdev);
> @@ -329,39 +335,132 @@ xfs_buf_allocate_memory(
>   */
>  
>  /*
> - * XXX: this will be replaced by an AIO submission engine in future. In the mean
> - * time, just complete the IO synchronously so all the machinery still works.
> + * AIO context for dispatch and completion.
> + *
> + * Run completion polling in a separate thread, the poll timeout will stop it
> + * from spinning in tight loops when there is nothing to do.
>   */
> -static int
> -submit_io(
> -	struct xfs_buf *bp,
> -	int		fd,
> -	void		*buf,
> -	xfs_daddr_t	blkno,
> -	int		size,
> -	bool		write)
> +#define MAX_AIO_EVENTS 1024
> +struct xfs_btaio {
> +	io_context_t	ctxp;
> +	int		aio_fd;
> +	int		aio_in_flight;
> +	pthread_t	completion_tid;
> +	bool		done;
> +};
> +
> +static void
> +xfs_buf_aio_ioend(
> +	struct io_event		*ev)
>  {
> -	int		ret;
> +	struct xfs_buf		*bp = (struct xfs_buf *)ev->data;
>  
> -	if (!write)
> -		ret = pread(fd, buf, size, BBTOB(blkno));
> -	else
> -		ret = pwrite(fd, buf, size, BBTOB(blkno));
> -	if (ret < 0)
> -		ret = -errno;
> -	else if (ret != size)
> -		ret = -EIO;
> -	else
> -		ret = 0;
>  	/*
> -	 * This is a bit of a hack until we get AIO that runs completions.
> -	 * Success is treated as a completion here, but IO errors are handled as
> -	 * a submission error and are handled by the caller. AIO will clean this
> -	 * up.
> +	 * don't overwrite existing errors - otherwise we can lose errors on
> +	 * buffers that require multiple bios to complete.
> +	 *
> +	 * We check that the returned length was the same as specified for this
> +	 * IO. Note that this onyl works for read and write - if we start
> +	 * using readv/writev for discontiguous buffers then this needs more
> +	 * work.

Interesting RFC, though I gather discontig buffers don't work yet?
Or hmm maybe there's something funny going on with
xfs_buftarg_submit_io_map?  You didn't post a git branch link, so it's
hard(er) to just rummage around on my own. :/

This seems like a reasonable restructuring to allow asynchronous io.
It's sort of a pity that this isn't modular enough to allow multiple IO
engines (synchronous system calls and io_uring come to mine) but that
can come later.

Urp, I'll go reply to the cover letter now.

--D

>  	 */
> -	if (!ret)
> +	if (ev->res < 0 || ev->res != ev->obj->u.c.nbytes) {
> +		int error = ev->res < 0 ? (int)ev->res : -EIO;
> +
> +		cmpxchg(&bp->b_io_error, 0, error);
> +	}
> +
> +	if (atomic_dec_and_test(&bp->b_io_remaining))
>  		xfs_buf_ioend(bp);
> -	return ret;
> +}
> +
> +static void
> +get_io_completions(
> +	struct xfs_btaio	*aio,
> +	int			threshold)
> +{
> +	struct io_event		ioevents[MAX_AIO_EVENTS];
> +	struct timespec		tout = {
> +		.tv_nsec = 100*1000*1000,	/* 100ms */
> +	};
> +	int			i, r;
> +
> +	/* gather up some completions */
> +	r = io_getevents(aio->ctxp, 1, MAX_AIO_EVENTS, ioevents, &tout);
> +	if (r < 0)  {
> +		fprintf(stderr, "FAIL! io_getevents returned %d\n", r);
> +		if (r == -EINTR)
> +			return;
> +		exit(1);
> +	}
> +	if (r == 0) {
> +		/* timeout, return to caller to check for what to do next */
> +		return;
> +	}
> +
> +	atomic_sub(&aio->aio_in_flight, r);
> +	for (i = 0; i < r; ++i)
> +		xfs_buf_aio_ioend(&ioevents[i]);
> +}
> +
> +static void *
> +aio_completion_thread(
> +	void			*arg)
> +{
> +	struct xfs_btaio	*aio = arg;
> +
> +	while (!aio->done) {
> +		get_io_completions(aio, 1);
> +	}
> +	return NULL;
> +}
> +
> +static int
> +submit_aio(
> +	struct xfs_buf		*bp,
> +	void			*buf,
> +	xfs_daddr_t		blkno,
> +	int			size)
> +{
> +	struct xfs_btaio	*aio = bp->b_target->bt_aio;
> +	int			r;
> +
> +	if (!aio->aio_fd)
> +		aio->aio_fd = bp->b_target->bt_fd;
> +
> +	/*
> +	 * Reserve and bound the number of in flight IOs to keep the number of
> +	 * pending IOs overrunning the tail of the event loop. This also serves
> +	 * to throttle incoming IOs without burning CPU by spinning.
> +	 */
> +	while (!atomic_add_unless(&aio->aio_in_flight, 1, MAX_AIO_EVENTS - 1))
> +		get_io_completions(aio, 1);
> +
> +	if (bp->b_flags & XBF_WRITE)
> +		io_prep_pwrite(&bp->b_iocb, aio->aio_fd, buf, size, BBTOB(blkno));
> +	else
> +		io_prep_pread(&bp->b_iocb, aio->aio_fd, buf, size, BBTOB(blkno));
> +
> +	bp->b_iocb.data = bp;
> +	do {
> +		struct iocb		*iocb;
> +
> +		iocb = &bp->b_iocb;
> +		r = io_submit(aio->ctxp, 1, &iocb);
> +		if (r == 1)
> +			return 0;	/* successful submission */
> +		fprintf(stderr, "io_submit returned %d\n", r);
> +		if (r != -EAGAIN)
> +			break;
> +		/* On EAGAIN, reap some completions and try again. */
> +		get_io_completions(aio, 1);
> +	} while (1);
> +
> +	if (bp->b_flags & LIBXFS_B_EXIT)
> +		exit(1);
> +
> +	atomic_dec(&aio->aio_in_flight);
> +	return r;
>  }
>  
>  static void
> @@ -373,7 +472,6 @@ xfs_buftarg_submit_io_map(
>  {
>  	int		size;
>  	int		offset;
> -	bool		rw = (bp->b_flags & XBF_WRITE);
>  	int		error;
>  
>  	offset = *buf_offset;
> @@ -388,8 +486,7 @@ xfs_buftarg_submit_io_map(
>  
>  	atomic_inc(&bp->b_io_remaining);
>  
> -	error = submit_io(bp, bp->b_target->bt_fd, bp->b_addr + offset,
> -			  bp->b_maps[map].bm_bn, size, rw);
> +	error = submit_aio(bp, bp->b_addr + offset, bp->b_maps[map].bm_bn, size);
>  	if (error) {
>  		/*
>  		 * This is guaranteed not to be the last io reference count
> @@ -474,6 +571,49 @@ xfs_buftarg_submit_io(
>  	}
>  }
>  
> +int
> +xfs_buftarg_aio_init(
> +	struct xfs_btaio	**aiop)
> +{
> +	struct xfs_btaio	*aio;
> +	int			r;
> +
> +	aio = calloc(1, sizeof(*aio));
> +	if (!aio)
> +		return -ENOMEM;
> +
> +	r = io_setup(MAX_AIO_EVENTS, &aio->ctxp);
> +	if (r) {
> +		printf("FAIL! io_setup returned %d\n", r);
> +		goto free_aio;
> +	}
> +
> +	r = pthread_create(&aio->completion_tid, NULL, aio_completion_thread,
> +			aio);
> +	if (r) {
> +		printf("FAIL! aio thread create returned %d\n", r);
> +		goto free_aio;
> +	}
> +
> +	*aiop = aio;
> +	return 0;
> +
> +free_aio:
> +	free(aio);
> +	return r;
> +}
> +
> +void
> +xfs_buftarg_aio_destroy(
> +	struct xfs_btaio	*aio)
> +{
> +	if (!aio)
> +		return;
> +
> +	aio->done = true;
> +	pthread_join(aio->completion_tid, NULL);
> +	free(aio);
> +}
>  /*
>   * Return a buffer associated to external memory via xfs_buf_associate_memory()
>   * back to it's empty state.
> diff --git a/libxfs/xfs_buf.h b/libxfs/xfs_buf.h
> index 4b6dff885165..29fbaaab4abb 100644
> --- a/libxfs/xfs_buf.h
> +++ b/libxfs/xfs_buf.h
> @@ -81,6 +81,12 @@ struct xfs_buf {
>  	struct completion	b_iowait;
>  	struct semaphore	b_sema;
>  	xfs_buf_iodone_t	b_iodone;
> +
> +	/*
> +	 * XXX: AIO needs as many iocbs as we have maps for discontig
> +	 * buffers to work correctly.
> +	 */
> +	struct iocb		b_iocb;
>  };
>  
>  struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
> diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
> index 61c4a3164d23..62aa6f236537 100644
> --- a/libxfs/xfs_buftarg.h
> +++ b/libxfs/xfs_buftarg.h
> @@ -16,6 +16,7 @@ struct xfs_buf_ops;
>  struct xfs_buf;
>  struct xfs_buf_map;
>  struct xfs_mount;
> +struct xfs_btaio;
>  
>  /* this needs to die */
>  #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
> @@ -55,6 +56,9 @@ struct xfs_buftarg {
>  	bool			bt_exiting;
>  	bool			bt_low_mem;
>  	struct completion	bt_low_mem_wait;
> +
> +	/* AIO submission/completion structures */
> +	struct xfs_btaio	*bt_aio;
>  };
>  
>  /* We purged a dirty buffer and lost a write. */
> @@ -90,6 +94,9 @@ int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
>  void xfs_buftarg_submit_io(struct xfs_buf *bp);
>  void xfs_buf_mark_dirty(struct xfs_buf *bp);
>  
> +int xfs_buftarg_aio_init(struct xfs_btaio **aiop);
> +void xfs_buftarg_aio_destroy(struct xfs_btaio *aio);
> +
>  /*
>   * Cached buffer memory manangement
>   */
> -- 
> 2.28.0
> 
