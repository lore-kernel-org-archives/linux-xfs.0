Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1ABC35265
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA002224D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgJOHWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:15 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33398 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729324AbgJOHWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:14 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C50733AAFE9
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-000hwC-7I
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qMS-Vy
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 23/27] libxfs: use PSI information to detect memory pressure
Date:   Thu, 15 Oct 2020 18:21:51 +1100
Message-Id: <20201015072155.1631135-24-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=b7aKuU4CZm3oD1x1e8oA:9
        a=Aj25W7a1c1s4-jA-:21 a=cxFZG_LvAqqorLtZ:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The buffer cache needs to have a reliable trigger for shrinking
the cache. Modern kernels track and report memory pressure events to
the userspace via the Pressure Stall Interface (PSI). Create a PSI
memory pressure monitoring thread to listen for memory pressure
events and use that to drive buffer cache shrinking interfaces.

Add the shrinker framework that will allow us to implement LRU
reclaim of buffers when memory pressure occues.  We also create a
low memory detection and reclaim wait mechanism to allow use to
throttle back new allocations while we are shrinking the buffer
cache.

We also include malloc heap trimming callouts so that once the
shrinker frees the memory, we trim the malloc heap to release the
freed memory back to the system.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/buftarg.c     | 142 ++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_buftarg.h |   9 +++
 2 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
index 42806e433715..6c7142d41eb1 100644
--- a/libxfs/buftarg.c
+++ b/libxfs/buftarg.c
@@ -62,6 +62,128 @@ xfs_buftarg_setsize_early(
 	return xfs_buftarg_setsize(btp, bsize);
 }
 
+/*
+ * Scan a chunk of the buffer cache and drop LRU reference counts. If the
+ * count goes to zero, dispose of the buffer.
+ */
+static void
+xfs_buftarg_shrink(
+	struct xfs_buftarg	*btc)
+{
+	/*
+	 * Make the fact we are in memory reclaim externally visible. This
+	 * allows buffer cache allocation throttling while we are trying to
+	 * free memory.
+	 */
+	atomic_inc_return(&btc->bt_low_mem);
+
+	fprintf(stderr, "Got memory pressure event. Shrinking caches!\n");
+
+	/*
+	 * Now we've free a bunch of memory, trim the heap down to release the
+	 * freed memory back to the kernel and reduce the pressure we are
+	 * placing on the system.
+	 */
+	malloc_trim(0);
+
+	/*
+	 * Done, wake anyone waiting on memory reclaim to complete.
+	 */
+	atomic_dec_return(&btc->bt_low_mem);
+	complete(&btc->bt_low_mem_wait);
+}
+
+static void *
+xfs_buftarg_shrinker(
+	void			*args)
+{
+	struct xfs_buftarg	*btp = args;
+	struct pollfd		 fds = {
+		.fd = btp->bt_psi_fd,
+		.events = POLLPRI,
+	};
+
+	rcu_register_thread();
+	while (!btp->bt_exiting) {
+		int	n;
+
+		n = poll(&fds, 1, 100);
+		if (n == 0)
+			continue;	/* timeout */
+		if (n < 0) {
+			perror("poll(PSI)");
+			break;
+		}
+		if (fds.revents & POLLERR) {
+			fprintf(stderr,
+				"poll(psi) POLLERR: event source dead?\n");
+			break;
+		}
+		if (!(fds.revents & POLLPRI)) {
+			fprintf(stderr,
+				"poll(psi): unknown event.  Ignoring.\n");
+			continue;
+		}
+
+		/* run the shrinker here */
+		xfs_buftarg_shrink(btp);
+
+	}
+	rcu_unregister_thread();
+	return NULL;
+}
+
+/*
+ * This only picks up on global memory pressure. Maybe in future we can detect
+ * whether we are running inside a container and use the PSI information for the
+ * container.
+ *
+ * We want relatively early notification of memory pressure stalls because
+ * xfs_repair will consume lots of memory. Hence set a low trigger threshold for
+ * reclaim to run - a partial stall of 5ms over a 1s sample period will trigger
+ * reclaim algorithms.
+ */
+static int
+xfs_buftarg_mempressue_init(
+	struct xfs_buftarg	*btp)
+{
+	const char		*fname = "/proc/pressure/memory";
+	const char		*trigger = "some 10000 1000000";
+	int			error;
+
+	btp->bt_psi_fd = open(fname, O_RDWR | O_NONBLOCK);
+	if (btp->bt_psi_fd < 0) {
+		perror("open(PSI)");
+		return -errno;
+	}
+	if (write(btp->bt_psi_fd, trigger, strlen(trigger) + 1) !=
+						strlen(trigger) + 1) {
+		perror("write(PSI)");
+		error = -errno;
+		goto out_close;
+	}
+
+	atomic_set(&btp->bt_low_mem, 0);
+	init_completion(&btp->bt_low_mem_wait);
+
+	/*
+	 * Now create the monitoring reclaim thread. This will run until the
+	 * buftarg is torn down.
+	 */
+	error = pthread_create(&btp->bt_psi_tid, NULL,
+				xfs_buftarg_shrinker, btp);
+	if (error)
+		goto out_close;
+
+	return 0;
+
+out_close:
+	close(btp->bt_psi_fd);
+	btp->bt_psi_fd = -1;
+	return error;
+}
+
+
 struct xfs_buftarg *
 xfs_buftarg_alloc(
 	struct xfs_mount	*mp,
@@ -74,6 +196,8 @@ xfs_buftarg_alloc(
 	btp->bt_mount = mp;
 	btp->bt_fd = libxfs_device_to_fd(bdev);
 	btp->bt_bdev = bdev;
+	btp->bt_psi_fd = -1;
+	btp->bt_exiting = false;
 
 	if (xfs_buftarg_setsize_early(btp))
 		goto error_free;
@@ -84,8 +208,13 @@ xfs_buftarg_alloc(
 	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
 		goto error_lru;
 
+	if (xfs_buftarg_mempressue_init(btp))
+		goto error_pcp;
+
 	return btp;
 
+error_pcp:
+	percpu_counter_destroy(&btp->bt_io_count);
 error_lru:
 	list_lru_destroy(&btp->bt_lru);
 error_free:
@@ -97,6 +226,12 @@ void
 xfs_buftarg_free(
 	struct xfs_buftarg	*btp)
 {
+	btp->bt_exiting = true;
+	if (btp->bt_psi_tid)
+		pthread_join(btp->bt_psi_tid, NULL);
+	if (btp->bt_psi_fd >= 0)
+		close(btp->bt_psi_fd);
+
 	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
 	percpu_counter_destroy(&btp->bt_io_count);
 	platform_flush_device(btp->bt_fd, btp->bt_bdev);
@@ -121,10 +256,15 @@ xfs_buf_allocate_memory(
 	struct xfs_buf		*bp,
 	uint			flags)
 {
+	struct xfs_buftarg	*btp = bp->b_target;
 	size_t			size;
 
+	/* Throttle allocation while dealing with low memory events */
+	while (atomic_read(&btp->bt_low_mem))
+		wait_for_completion(&btp->bt_low_mem_wait);
+
 	size = BBTOB(bp->b_length);
-	bp->b_addr = memalign(bp->b_target->bt_meta_sectorsize, size);
+	bp->b_addr = memalign(btp->bt_meta_sectorsize, size);
 	if (!bp->b_addr)
 		return -ENOMEM;
 	return 0;
diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
index 798980fdafeb..d2ce47e22545 100644
--- a/libxfs/xfs_buftarg.h
+++ b/libxfs/xfs_buftarg.h
@@ -41,7 +41,16 @@ struct xfs_buftarg {
 
 	uint32_t		bt_io_count;
 	unsigned int		flags;
+
+	/*
+	 * Memory pressure (PSI) and cache reclaim infrastructure
+	 */
 	struct list_lru		bt_lru;
+	int			bt_psi_fd;
+	pthread_t		bt_psi_tid;
+	bool			bt_exiting;
+	bool			bt_low_mem;
+	struct completion	bt_low_mem_wait;
 };
 
 /* We purged a dirty buffer and lost a write. */
-- 
2.28.0

