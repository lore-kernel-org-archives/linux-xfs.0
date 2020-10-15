Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B65C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBCFF22260
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:56:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e95icCsg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbgJOR4V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 13:56:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54782 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgJOR4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 13:56:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FHsiQT098975;
        Thu, 15 Oct 2020 17:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=K6w3l4yd+xaeUgharTDyz8aX9mM2O0YMNARSoVys6RI=;
 b=e95icCsgm6g6N6Rnwl37e6D+ZY1s2FgsQPab4fK1pODCaSF5Q6WCZzYED+M0GnHOp81X
 jXqT/kNzga9LpP16q3SF5xcsw8wdXGZAvEVVgB6idZjK1bnop9tP1/OGPoPVWtdYEeWl
 RwnKi8vvhm3C10cjqpDdTxP3A00DT9IYocWdygEwwMGwrR5f80SvEdnDH4sZIHcycaOg
 eMvk+Yefmllj2eugxjXqlwYMJfLU1iBCDWZmoC3gx159LoRKKxs+5WwSvTRLjQ+V36Yh
 vyklf/lt1tIZUH6UoAqd7H17IDryW2ocr9dVnRB9Zv5itlWFv4BJygS3S1PWF9AxbD4g Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 346g8gkahk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 17:56:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FHseXE140240;
        Thu, 15 Oct 2020 17:56:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 343pw0q55f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 17:56:13 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09FHuCu0000382;
        Thu, 15 Oct 2020 17:56:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 10:56:12 -0700
Date:   Thu, 15 Oct 2020 10:56:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/27] libxfs: use PSI information to detect memory
 pressure
Message-ID: <20201015175611.GY9832@magnolia>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-24-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015072155.1631135-24-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=5 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 suspectscore=5
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 06:21:51PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The buffer cache needs to have a reliable trigger for shrinking
> the cache. Modern kernels track and report memory pressure events to
> the userspace via the Pressure Stall Interface (PSI). Create a PSI
> memory pressure monitoring thread to listen for memory pressure
> events and use that to drive buffer cache shrinking interfaces.
> 
> Add the shrinker framework that will allow us to implement LRU
> reclaim of buffers when memory pressure occues.  We also create a
> low memory detection and reclaim wait mechanism to allow use to
> throttle back new allocations while we are shrinking the buffer
> cache.
> 
> We also include malloc heap trimming callouts so that once the
> shrinker frees the memory, we trim the malloc heap to release the
> freed memory back to the system.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/buftarg.c     | 142 ++++++++++++++++++++++++++++++++++++++++++-
>  libxfs/xfs_buftarg.h |   9 +++
>  2 files changed, 150 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
> index 42806e433715..6c7142d41eb1 100644
> --- a/libxfs/buftarg.c
> +++ b/libxfs/buftarg.c
> @@ -62,6 +62,128 @@ xfs_buftarg_setsize_early(
>  	return xfs_buftarg_setsize(btp, bsize);
>  }
>  
> +/*
> + * Scan a chunk of the buffer cache and drop LRU reference counts. If the
> + * count goes to zero, dispose of the buffer.
> + */
> +static void
> +xfs_buftarg_shrink(
> +	struct xfs_buftarg	*btc)
> +{
> +	/*
> +	 * Make the fact we are in memory reclaim externally visible. This
> +	 * allows buffer cache allocation throttling while we are trying to
> +	 * free memory.
> +	 */
> +	atomic_inc_return(&btc->bt_low_mem);
> +
> +	fprintf(stderr, "Got memory pressure event. Shrinking caches!\n");
> +
> +	/*
> +	 * Now we've free a bunch of memory, trim the heap down to release the
> +	 * freed memory back to the kernel and reduce the pressure we are
> +	 * placing on the system.
> +	 */
> +	malloc_trim(0);
> +
> +	/*
> +	 * Done, wake anyone waiting on memory reclaim to complete.
> +	 */
> +	atomic_dec_return(&btc->bt_low_mem);
> +	complete(&btc->bt_low_mem_wait);
> +}
> +
> +static void *
> +xfs_buftarg_shrinker(
> +	void			*args)
> +{
> +	struct xfs_buftarg	*btp = args;
> +	struct pollfd		 fds = {
> +		.fd = btp->bt_psi_fd,
> +		.events = POLLPRI,
> +	};
> +
> +	rcu_register_thread();
> +	while (!btp->bt_exiting) {
> +		int	n;
> +
> +		n = poll(&fds, 1, 100);
> +		if (n == 0)
> +			continue;	/* timeout */
> +		if (n < 0) {
> +			perror("poll(PSI)");
> +			break;
> +		}
> +		if (fds.revents & POLLERR) {
> +			fprintf(stderr,
> +				"poll(psi) POLLERR: event source dead?\n");
> +			break;
> +		}
> +		if (!(fds.revents & POLLPRI)) {
> +			fprintf(stderr,
> +				"poll(psi): unknown event.  Ignoring.\n");
> +			continue;
> +		}
> +
> +		/* run the shrinker here */
> +		xfs_buftarg_shrink(btp);
> +
> +	}
> +	rcu_unregister_thread();
> +	return NULL;
> +}
> +
> +/*
> + * This only picks up on global memory pressure. Maybe in future we can detect
> + * whether we are running inside a container and use the PSI information for the
> + * container.
> + *
> + * We want relatively early notification of memory pressure stalls because
> + * xfs_repair will consume lots of memory. Hence set a low trigger threshold for
> + * reclaim to run - a partial stall of 5ms over a 1s sample period will trigger

The trigger string looks like it's configuring for a partial stall of
10ms over a 1s sample period?

> + * reclaim algorithms.
> + */
> +static int
> +xfs_buftarg_mempressue_init(

xfs_buftarg_mempressure_init() ?

> +	struct xfs_buftarg	*btp)
> +{
> +	const char		*fname = "/proc/pressure/memory";
> +	const char		*trigger = "some 10000 1000000";
> +	int			error;
> +
> +	btp->bt_psi_fd = open(fname, O_RDWR | O_NONBLOCK);
> +	if (btp->bt_psi_fd < 0) {
> +		perror("open(PSI)");
> +		return -errno;
> +	}
> +	if (write(btp->bt_psi_fd, trigger, strlen(trigger) + 1) !=
> +						strlen(trigger) + 1) {
> +		perror("write(PSI)");
> +		error = -errno;
> +		goto out_close;
> +	}
> +
> +	atomic_set(&btp->bt_low_mem, 0);
> +	init_completion(&btp->bt_low_mem_wait);
> +
> +	/*
> +	 * Now create the monitoring reclaim thread. This will run until the
> +	 * buftarg is torn down.
> +	 */
> +	error = pthread_create(&btp->bt_psi_tid, NULL,
> +				xfs_buftarg_shrinker, btp);
> +	if (error)
> +		goto out_close;
> +
> +	return 0;
> +
> +out_close:
> +	close(btp->bt_psi_fd);
> +	btp->bt_psi_fd = -1;
> +	return error;
> +}
> +
> +
>  struct xfs_buftarg *
>  xfs_buftarg_alloc(
>  	struct xfs_mount	*mp,
> @@ -74,6 +196,8 @@ xfs_buftarg_alloc(
>  	btp->bt_mount = mp;
>  	btp->bt_fd = libxfs_device_to_fd(bdev);
>  	btp->bt_bdev = bdev;
> +	btp->bt_psi_fd = -1;
> +	btp->bt_exiting = false;
>  
>  	if (xfs_buftarg_setsize_early(btp))
>  		goto error_free;
> @@ -84,8 +208,13 @@ xfs_buftarg_alloc(
>  	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
>  		goto error_lru;
>  
> +	if (xfs_buftarg_mempressue_init(btp))

So what happens if PSI isn't enabled or procfs isn't mounted yet?
xfs_repair just ... fails?  That seems disappointing, particularly if
the admin is trying to fix a dead root fs from the initramfs premount
shell and /proc isn't set up yet.

Hmm, looks like Debian actually /does/ set up procfs nowadays.  Still,
if we're going to add a hard requirement on CONFIG_PSI=y and
CONFIG_PSI_DEFAULT_DISABLED=n, we need to advertise this kind of loudly.

(Personally, I thought that if there's no pressure stall information,
we'd just fall back to not having a shrinker and daring the system to
OOM us like it does now...)

--D

> +		goto error_pcp;
> +
>  	return btp;
>  
> +error_pcp:
> +	percpu_counter_destroy(&btp->bt_io_count);
>  error_lru:
>  	list_lru_destroy(&btp->bt_lru);
>  error_free:
> @@ -97,6 +226,12 @@ void
>  xfs_buftarg_free(
>  	struct xfs_buftarg	*btp)
>  {
> +	btp->bt_exiting = true;
> +	if (btp->bt_psi_tid)
> +		pthread_join(btp->bt_psi_tid, NULL);
> +	if (btp->bt_psi_fd >= 0)
> +		close(btp->bt_psi_fd);
> +
>  	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
>  	percpu_counter_destroy(&btp->bt_io_count);
>  	platform_flush_device(btp->bt_fd, btp->bt_bdev);
> @@ -121,10 +256,15 @@ xfs_buf_allocate_memory(
>  	struct xfs_buf		*bp,
>  	uint			flags)
>  {
> +	struct xfs_buftarg	*btp = bp->b_target;
>  	size_t			size;
>  
> +	/* Throttle allocation while dealing with low memory events */
> +	while (atomic_read(&btp->bt_low_mem))
> +		wait_for_completion(&btp->bt_low_mem_wait);
> +
>  	size = BBTOB(bp->b_length);
> -	bp->b_addr = memalign(bp->b_target->bt_meta_sectorsize, size);
> +	bp->b_addr = memalign(btp->bt_meta_sectorsize, size);
>  	if (!bp->b_addr)
>  		return -ENOMEM;
>  	return 0;
> diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
> index 798980fdafeb..d2ce47e22545 100644
> --- a/libxfs/xfs_buftarg.h
> +++ b/libxfs/xfs_buftarg.h
> @@ -41,7 +41,16 @@ struct xfs_buftarg {
>  
>  	uint32_t		bt_io_count;
>  	unsigned int		flags;
> +
> +	/*
> +	 * Memory pressure (PSI) and cache reclaim infrastructure
> +	 */
>  	struct list_lru		bt_lru;
> +	int			bt_psi_fd;
> +	pthread_t		bt_psi_tid;
> +	bool			bt_exiting;
> +	bool			bt_low_mem;
> +	struct completion	bt_low_mem_wait;
>  };
>  
>  /* We purged a dirty buffer and lost a write. */
> -- 
> 2.28.0
> 
