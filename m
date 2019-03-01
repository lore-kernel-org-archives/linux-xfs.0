Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42480 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfCAX1x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:27:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOD7C122734
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:52 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qtupeteks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:27:52 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRkri009532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:46 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NRj7M007753
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:46 GMT
Subject: [PATCH 08/23] xfs_scrub: don't expose internal pool state
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:27:37 -0800
Message-ID: <155148285771.16677.2023619487236682038.stgit@magnolia>
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

In xfs_scrub, the read/verify pool tries to coalesce the media
verification requests into a smaller number of large IOs.  There's no
need to force callers to keep track of this internal state, so just move
all that into read_verify.c.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c      |   23 +++++++----------------
 scrub/read_verify.c |   40 ++++++++++++++++++++++++++++++++++------
 scrub/read_verify.h |   16 ++++------------
 3 files changed, 45 insertions(+), 34 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index ead48d77..fe121769 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -9,7 +9,6 @@
 #include <sys/statvfs.h>
 #include "handle.h"
 #include "path.h"
-#include "ptvar.h"
 #include "workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
@@ -290,7 +289,6 @@ xfs_report_verify_errors(
 
 struct xfs_verify_extent {
 	struct read_verify_pool	*readverify;
-	struct ptvar		*rvstate;
 	struct bitmap		*d_bad;		/* bytes */
 	struct bitmap		*r_bad;		/* bytes */
 };
@@ -424,13 +422,13 @@ xfs_check_rmap(
 	/* Schedule the read verify command for (eventual) running. */
 	disk = xfs_dev_to_disk(ctx, map->fmr_device);
 
-	read_verify_schedule_io(ve->readverify, ptvar_get(ve->rvstate), disk,
-			map->fmr_physical, map->fmr_length, ve);
+	read_verify_schedule_io(ve->readverify, disk, map->fmr_physical,
+			map->fmr_length, ve);
 
 out:
 	/* Is this the last extent?  Fire off the read. */
 	if (map->fmr_flags & FMR_OF_LAST)
-		read_verify_force_io(ve->readverify, ptvar_get(ve->rvstate));
+		read_verify_force_io(ve->readverify);
 
 	return true;
 }
@@ -450,16 +448,10 @@ xfs_scan_blocks(
 	struct xfs_verify_extent	ve;
 	bool				moveon;
 
-	ve.rvstate = ptvar_init(scrub_nproc(ctx), sizeof(struct read_verify));
-	if (!ve.rvstate) {
-		str_errno(ctx, ctx->mntpoint);
-		return false;
-	}
-
 	moveon = bitmap_init(&ve.d_bad);
 	if (!moveon) {
 		str_errno(ctx, ctx->mntpoint);
-		goto out_ve;
+		goto out;
 	}
 
 	moveon = bitmap_init(&ve.r_bad);
@@ -469,7 +461,8 @@ xfs_scan_blocks(
 	}
 
 	ve.readverify = read_verify_pool_init(ctx, ctx->geo.blocksize,
-			xfs_check_rmap_ioerr, disk_heads(ctx->datadev));
+			xfs_check_rmap_ioerr, disk_heads(ctx->datadev),
+			scrub_nproc(ctx));
 	if (!ve.readverify) {
 		moveon = false;
 		str_info(ctx, ctx->mntpoint,
@@ -489,7 +482,6 @@ _("Could not create media verifier."));
 
 	bitmap_free(&ve.r_bad);
 	bitmap_free(&ve.d_bad);
-	ptvar_free(ve.rvstate);
 	return moveon;
 
 out_pool:
@@ -498,8 +490,7 @@ _("Could not create media verifier."));
 	bitmap_free(&ve.r_bad);
 out_dbad:
 	bitmap_free(&ve.d_bad);
-out_ve:
-	ptvar_free(ve.rvstate);
+out:
 	return moveon;
 }
 
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 75cb53ca..b5774736 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -7,6 +7,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
+#include "ptvar.h"
 #include "workqueue.h"
 #include "path.h"
 #include "xfs_scrub.h"
@@ -36,22 +37,40 @@
 /* Tolerate 64k holes in adjacent read verify requests. */
 #define RVP_IO_BATCH_LOCALITY	(65536)
 
+struct read_verify {
+	void			*io_end_arg;
+	struct disk		*io_disk;
+	uint64_t		io_start;	/* bytes */
+	uint64_t		io_length;	/* bytes */
+};
+
 struct read_verify_pool {
 	struct workqueue	wq;		/* thread pool */
 	struct scrub_ctx	*ctx;		/* scrub context */
 	void			*readbuf;	/* read buffer */
 	struct ptcounter	*verified_bytes;
+	struct ptvar		*rvstate;	/* combines read requests */
 	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
 	size_t			miniosz;	/* minimum io size, bytes */
 };
 
-/* Create a thread pool to run read verifiers. */
+/*
+ * Create a thread pool to run read verifiers.
+ *
+ * @miniosz is the minimum size of an IO to expect (in bytes).
+ * @ioerr_fn will be called when IO errors occur.
+ * @nproc is the maximum number of verify requests that may be sent to a disk
+ * at any given time.
+ * @submitter_threads is the number of threads that may be sending verify
+ * requests at any given time.
+ */
 struct read_verify_pool *
 read_verify_pool_init(
 	struct scrub_ctx		*ctx,
 	size_t				miniosz,
 	read_verify_ioerr_fn_t		ioerr_fn,
-	unsigned int			nproc)
+	unsigned int			nproc,
+	unsigned int			submitter_threads)
 {
 	struct read_verify_pool		*rvp;
 	bool				ret;
@@ -71,14 +90,20 @@ read_verify_pool_init(
 	rvp->miniosz = miniosz;
 	rvp->ctx = ctx;
 	rvp->ioerr_fn = ioerr_fn;
+	rvp->rvstate = ptvar_init(submitter_threads,
+			sizeof(struct read_verify));
+	if (rvp->rvstate == NULL)
+		goto out_counter;
 	/* Run in the main thread if we only want one thread. */
 	if (nproc == 1)
 		nproc = 0;
 	ret = workqueue_create(&rvp->wq, (struct xfs_mount *)rvp, nproc);
 	if (ret)
-		goto out_counter;
+		goto out_rvstate;
 	return rvp;
 
+out_rvstate:
+	ptvar_free(rvp->rvstate);
 out_counter:
 	ptcounter_free(rvp->verified_bytes);
 out_buf:
@@ -101,6 +126,7 @@ void
 read_verify_pool_destroy(
 	struct read_verify_pool		*rvp)
 {
+	ptvar_free(rvp->rvstate);
 	ptcounter_free(rvp->verified_bytes);
 	free(rvp->readbuf);
 	free(rvp);
@@ -186,16 +212,17 @@ _("Could not queue read-verify work."));
 bool
 read_verify_schedule_io(
 	struct read_verify_pool		*rvp,
-	struct read_verify		*rv,
 	struct disk			*disk,
 	uint64_t			start,
 	uint64_t			length,
 	void				*end_arg)
 {
+	struct read_verify		*rv;
 	uint64_t			req_end;
 	uint64_t			rv_end;
 
 	assert(rvp->readbuf);
+	rv = ptvar_get(rvp->rvstate);
 	req_end = start + length;
 	rv_end = rv->io_start + rv->io_length;
 
@@ -229,12 +256,13 @@ read_verify_schedule_io(
 /* Force any stashed IOs into the verifier. */
 bool
 read_verify_force_io(
-	struct read_verify_pool		*rvp,
-	struct read_verify		*rv)
+	struct read_verify_pool		*rvp)
 {
+	struct read_verify		*rv;
 	bool				moveon;
 
 	assert(rvp->readbuf);
+	rv = ptvar_get(rvp->rvstate);
 	if (rv->io_length == 0)
 		return true;
 
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index 38f1cd1a..1e7fd83f 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -16,21 +16,13 @@ typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
 
 struct read_verify_pool *read_verify_pool_init(struct scrub_ctx *ctx,
 		size_t miniosz, read_verify_ioerr_fn_t ioerr_fn,
-		unsigned int nproc);
+		unsigned int nproc, unsigned int submitter_threads);
 void read_verify_pool_flush(struct read_verify_pool *rvp);
 void read_verify_pool_destroy(struct read_verify_pool *rvp);
 
-struct read_verify {
-	void			*io_end_arg;
-	struct disk		*io_disk;
-	uint64_t		io_start;	/* bytes */
-	uint64_t		io_length;	/* bytes */
-};
-
-bool read_verify_schedule_io(struct read_verify_pool *rvp,
-		struct read_verify *rv, struct disk *disk, uint64_t start,
-		uint64_t length, void *end_arg);
-bool read_verify_force_io(struct read_verify_pool *rvp, struct read_verify *rv);
+bool read_verify_schedule_io(struct read_verify_pool *rvp, struct disk *disk,
+		uint64_t start, uint64_t length, void *end_arg);
+bool read_verify_force_io(struct read_verify_pool *rvp);
 uint64_t read_verify_bytes(struct read_verify_pool *rvp);
 
 #endif /* XFS_SCRUB_READ_VERIFY_H_ */
