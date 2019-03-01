Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35062 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfCAX1z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:27:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOAtQ124230
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:52 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qtxtsa548-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:27:52 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRqSx009750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:52 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRq2R021059
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:52 GMT
Subject: [PATCH 09/23] xfs_scrub: one read/verify pool per disk
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:27:50 -0800
Message-ID: <155148287091.16677.17102964491448677196.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Simplify the read/verify pool code further by creating one pool per
disk.  This enables us to tailor the concurrency levels of each disk to
that specific disk so that if we have a mixed hdd/ssd environment we
don't flood the hdd with a lot of requests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c      |  110 ++++++++++++++++++++++++++++++++++++---------------
 scrub/read_verify.c |   29 ++++++-------
 scrub/read_verify.h |   10 +++--
 3 files changed, 98 insertions(+), 51 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index fe121769..ccb795ab 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -33,18 +33,29 @@
  * and report the paths of the now corrupt files.
  */
 
+/* Verify disk blocks with GETFSMAP */
+
+struct xfs_verify_extent {
+	struct read_verify_pool	*rvp_data;
+	struct read_verify_pool	*rvp_log;
+	struct read_verify_pool	*rvp_realtime;
+	struct bitmap		*d_bad;		/* bytes */
+	struct bitmap		*r_bad;		/* bytes */
+};
+
 /* Find the fd for a given device identifier. */
-static struct disk *
-xfs_dev_to_disk(
-	struct scrub_ctx	*ctx,
-	dev_t			dev)
+static struct read_verify_pool *
+xfs_dev_to_pool(
+	struct scrub_ctx		*ctx,
+	struct xfs_verify_extent	*ve,
+	dev_t				dev)
 {
 	if (dev == ctx->fsinfo.fs_datadev)
-		return ctx->datadev;
+		return ve->rvp_data;
 	else if (dev == ctx->fsinfo.fs_logdev)
-		return ctx->logdev;
+		return ve->rvp_log;
 	else if (dev == ctx->fsinfo.fs_rtdev)
-		return ctx->rtdev;
+		return ve->rvp_realtime;
 	abort();
 }
 
@@ -285,14 +296,6 @@ xfs_report_verify_errors(
 	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, &vei);
 }
 
-/* Verify disk blocks with GETFSMAP */
-
-struct xfs_verify_extent {
-	struct read_verify_pool	*readverify;
-	struct bitmap		*d_bad;		/* bytes */
-	struct bitmap		*r_bad;		/* bytes */
-};
-
 /* Report an IO error resulting from read-verify based off getfsmap. */
 static bool
 xfs_check_rmap_error_report(
@@ -393,7 +396,9 @@ xfs_check_rmap(
 	void				*arg)
 {
 	struct xfs_verify_extent	*ve = arg;
-	struct disk			*disk;
+	struct read_verify_pool		*rvp;
+
+	rvp = xfs_dev_to_pool(ctx, ve, map->fmr_device);
 
 	dbg_printf("rmap dev %d:%d phys %"PRIu64" owner %"PRId64
 			" offset %"PRIu64" len %"PRIu64" flags 0x%x\n",
@@ -420,19 +425,32 @@ xfs_check_rmap(
 	/* XXX: Filter out directory data blocks. */
 
 	/* Schedule the read verify command for (eventual) running. */
-	disk = xfs_dev_to_disk(ctx, map->fmr_device);
-
-	read_verify_schedule_io(ve->readverify, disk, map->fmr_physical,
-			map->fmr_length, ve);
+	read_verify_schedule_io(rvp, map->fmr_physical, map->fmr_length, ve);
 
 out:
 	/* Is this the last extent?  Fire off the read. */
 	if (map->fmr_flags & FMR_OF_LAST)
-		read_verify_force_io(ve->readverify);
+		read_verify_force_io(rvp);
 
 	return true;
 }
 
+/* Wait for read/verify actions to finish, then return # bytes checked. */
+static uint64_t
+clean_pool(
+	struct read_verify_pool	*rvp)
+{
+	uint64_t		ret;
+
+	if (!rvp)
+		return 0;
+
+	read_verify_pool_flush(rvp);
+	ret += read_verify_bytes(rvp);
+	read_verify_pool_destroy(rvp);
+	return ret;
+}
+
 /*
  * Read verify all the file data blocks in a filesystem.  Since XFS doesn't
  * do data checksums, we trust that the underlying storage will pass back
@@ -445,7 +463,7 @@ bool
 xfs_scan_blocks(
 	struct scrub_ctx		*ctx)
 {
-	struct xfs_verify_extent	ve;
+	struct xfs_verify_extent	ve = { NULL };
 	bool				moveon;
 
 	moveon = bitmap_init(&ve.d_bad);
@@ -460,21 +478,43 @@ xfs_scan_blocks(
 		goto out_dbad;
 	}
 
-	ve.readverify = read_verify_pool_init(ctx, ctx->geo.blocksize,
-			xfs_check_rmap_ioerr, disk_heads(ctx->datadev),
+	ve.rvp_data = read_verify_pool_init(ctx, ctx->datadev,
+			ctx->geo.blocksize, xfs_check_rmap_ioerr,
 			scrub_nproc(ctx));
-	if (!ve.readverify) {
+	if (!ve.rvp_data) {
 		moveon = false;
 		str_info(ctx, ctx->mntpoint,
-_("Could not create media verifier."));
+_("Could not create data device media verifier."));
 		goto out_rbad;
 	}
+	if (ctx->logdev) {
+		ve.rvp_log = read_verify_pool_init(ctx, ctx->logdev,
+				ctx->geo.blocksize, xfs_check_rmap_ioerr,
+				scrub_nproc(ctx));
+		if (!ve.rvp_log) {
+			moveon = false;
+			str_info(ctx, ctx->mntpoint,
+	_("Could not create log device media verifier."));
+			goto out_datapool;
+		}
+	}
+	if (ctx->rtdev) {
+		ve.rvp_realtime = read_verify_pool_init(ctx, ctx->rtdev,
+				ctx->geo.blocksize, xfs_check_rmap_ioerr,
+				scrub_nproc(ctx));
+		if (!ve.rvp_realtime) {
+			moveon = false;
+			str_info(ctx, ctx->mntpoint,
+	_("Could not create realtime device media verifier."));
+			goto out_logpool;
+		}
+	}
 	moveon = xfs_scan_all_spacemaps(ctx, xfs_check_rmap, &ve);
 	if (!moveon)
-		goto out_pool;
-	read_verify_pool_flush(ve.readverify);
-	ctx->bytes_checked += read_verify_bytes(ve.readverify);
-	read_verify_pool_destroy(ve.readverify);
+		goto out_rtpool;
+	ctx->bytes_checked += clean_pool(ve.rvp_data);
+	ctx->bytes_checked += clean_pool(ve.rvp_log);
+	ctx->bytes_checked += clean_pool(ve.rvp_realtime);
 
 	/* Scan the whole dir tree to see what matches the bad extents. */
 	if (!bitmap_empty(ve.d_bad) || !bitmap_empty(ve.r_bad))
@@ -484,8 +524,14 @@ _("Could not create media verifier."));
 	bitmap_free(&ve.d_bad);
 	return moveon;
 
-out_pool:
-	read_verify_pool_destroy(ve.readverify);
+out_rtpool:
+	if (ve.rvp_realtime)
+		read_verify_pool_destroy(ve.rvp_realtime);
+out_logpool:
+	if (ve.rvp_log)
+		read_verify_pool_destroy(ve.rvp_log);
+out_datapool:
+	read_verify_pool_destroy(ve.rvp_data);
 out_rbad:
 	bitmap_free(&ve.r_bad);
 out_dbad:
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index b5774736..4a9b91f2 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -50,6 +50,7 @@ struct read_verify_pool {
 	void			*readbuf;	/* read buffer */
 	struct ptcounter	*verified_bytes;
 	struct ptvar		*rvstate;	/* combines read requests */
+	struct disk		*disk;		/* which disk? */
 	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
 	size_t			miniosz;	/* minimum io size, bytes */
 };
@@ -57,19 +58,18 @@ struct read_verify_pool {
 /*
  * Create a thread pool to run read verifiers.
  *
+ * @disk is the disk we want to verify.
  * @miniosz is the minimum size of an IO to expect (in bytes).
  * @ioerr_fn will be called when IO errors occur.
- * @nproc is the maximum number of verify requests that may be sent to a disk
- * at any given time.
  * @submitter_threads is the number of threads that may be sending verify
  * requests at any given time.
  */
 struct read_verify_pool *
 read_verify_pool_init(
 	struct scrub_ctx		*ctx,
+	struct disk			*disk,
 	size_t				miniosz,
 	read_verify_ioerr_fn_t		ioerr_fn,
-	unsigned int			nproc,
 	unsigned int			submitter_threads)
 {
 	struct read_verify_pool		*rvp;
@@ -89,6 +89,7 @@ read_verify_pool_init(
 		goto out_buf;
 	rvp->miniosz = miniosz;
 	rvp->ctx = ctx;
+	rvp->disk = disk;
 	rvp->ioerr_fn = ioerr_fn;
 	rvp->rvstate = ptvar_init(submitter_threads,
 			sizeof(struct read_verify));
@@ -97,7 +98,8 @@ read_verify_pool_init(
 	/* Run in the main thread if we only want one thread. */
 	if (nproc == 1)
 		nproc = 0;
-	ret = workqueue_create(&rvp->wq, (struct xfs_mount *)rvp, nproc);
+	ret = workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
+			disk_heads(disk));
 	if (ret)
 		goto out_rvstate;
 	return rvp;
@@ -150,17 +152,16 @@ read_verify(
 	rvp = (struct read_verify_pool *)wq->wq_ctx;
 	while (rv->io_length > 0) {
 		len = min(rv->io_length, RVP_IO_MAX_SIZE);
-		dbg_printf("diskverify %d %"PRIu64" %zu\n", rv->io_disk->d_fd,
-				rv->io_start, len);
-		sz = disk_read_verify(rv->io_disk, rvp->readbuf,
+		dbg_printf("diskverify %d %"PRIu64" %zu\n", rvp->disk->d_fd,
 				rv->io_start, len);
+		sz = disk_read_verify(rvp->disk, rvp->readbuf, rv->io_start,
+				len);
 		if (sz < 0) {
 			dbg_printf("IOERR %d %"PRIu64" %zu\n",
-					rv->io_disk->d_fd,
-					rv->io_start, len);
+					rvp->disk->d_fd, rv->io_start, len);
 			/* IO error, so try the next logical block. */
 			len = rvp->miniosz;
-			rvp->ioerr_fn(rvp->ctx, rv->io_disk, rv->io_start, len,
+			rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start, len,
 					errno, rv->io_end_arg);
 		}
 
@@ -184,11 +185,11 @@ read_verify_queue(
 	bool				ret;
 
 	dbg_printf("verify fd %d start %"PRIu64" len %"PRIu64"\n",
-			rv->io_disk->d_fd, rv->io_start, rv->io_length);
+			rvp->disk->d_fd, rv->io_start, rv->io_length);
 
 	tmp = malloc(sizeof(struct read_verify));
 	if (!tmp) {
-		rvp->ioerr_fn(rvp->ctx, rv->io_disk, rv->io_start,
+		rvp->ioerr_fn(rvp->ctx, rvp->disk, rv->io_start,
 				rv->io_length, errno, rv->io_end_arg);
 		return true;
 	}
@@ -212,7 +213,6 @@ _("Could not queue read-verify work."));
 bool
 read_verify_schedule_io(
 	struct read_verify_pool		*rvp,
-	struct disk			*disk,
 	uint64_t			start,
 	uint64_t			length,
 	void				*end_arg)
@@ -231,7 +231,7 @@ read_verify_schedule_io(
 	 * reporting is the same, and the two extents are close,
 	 * we can combine them.
 	 */
-	if (rv->io_length > 0 && disk == rv->io_disk &&
+	if (rv->io_length > 0 &&
 	    end_arg == rv->io_end_arg &&
 	    ((start >= rv->io_start && start <= rv_end + RVP_IO_BATCH_LOCALITY) ||
 	     (rv->io_start >= start &&
@@ -244,7 +244,6 @@ read_verify_schedule_io(
 			return read_verify_queue(rvp, rv);
 
 		/* Stash the new IO. */
-		rv->io_disk = disk;
 		rv->io_start = start;
 		rv->io_length = length;
 		rv->io_end_arg = end_arg;
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index 1e7fd83f..5fabe5e0 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -8,6 +8,7 @@
 
 struct scrub_ctx;
 struct read_verify_pool;
+struct disk;
 
 /* Function called when an IO error happens. */
 typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
@@ -15,13 +16,14 @@ typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
 		int error, void *arg);
 
 struct read_verify_pool *read_verify_pool_init(struct scrub_ctx *ctx,
-		size_t miniosz, read_verify_ioerr_fn_t ioerr_fn,
-		unsigned int nproc, unsigned int submitter_threads);
+		struct disk *disk, size_t miniosz,
+		read_verify_ioerr_fn_t ioerr_fn,
+		unsigned int submitter_threads);
 void read_verify_pool_flush(struct read_verify_pool *rvp);
 void read_verify_pool_destroy(struct read_verify_pool *rvp);
 
-bool read_verify_schedule_io(struct read_verify_pool *rvp, struct disk *disk,
-		uint64_t start, uint64_t length, void *end_arg);
+bool read_verify_schedule_io(struct read_verify_pool *rvp, uint64_t start,
+		uint64_t length, void *end_arg);
 bool read_verify_force_io(struct read_verify_pool *rvp);
 uint64_t read_verify_bytes(struct read_verify_pool *rvp);
 
