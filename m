Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52366 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfDDRKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Apr 2019 13:10:30 -0400
Date: Thu, 4 Apr 2019 10:10:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 45/36] xfs_scrub: rename confusing structure
Message-ID: <20190404171023.GQ5147@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320200330.GI1183@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320200330.GI1183@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename xfs_verify_extent to media_verify_state so that the name more
accurately reflects what we're storing in the structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |   70 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/scrub/phase6.c b/scrub/phase6.c
index 5e2b9ee3..91e4443e 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -35,7 +35,7 @@
 
 /* Verify disk blocks with GETFSMAP */
 
-struct xfs_verify_extent {
+struct media_verify_state {
 	struct read_verify_pool	*rvp_data;
 	struct read_verify_pool	*rvp_log;
 	struct read_verify_pool	*rvp_realtime;
@@ -47,15 +47,15 @@ struct xfs_verify_extent {
 static struct read_verify_pool *
 xfs_dev_to_pool(
 	struct scrub_ctx		*ctx,
-	struct xfs_verify_extent	*ve,
+	struct media_verify_state	*vs,
 	dev_t				dev)
 {
 	if (dev == ctx->fsinfo.fs_datadev)
-		return ve->rvp_data;
+		return vs->rvp_data;
 	else if (dev == ctx->fsinfo.fs_logdev)
-		return ve->rvp_log;
+		return vs->rvp_log;
 	else if (dev == ctx->fsinfo.fs_rtdev)
-		return ve->rvp_realtime;
+		return vs->rvp_realtime;
 	abort();
 }
 
@@ -348,7 +348,7 @@ xfs_check_rmap_ioerr(
 {
 	struct fsmap			keys[2];
 	char				descr[DESCR_BUFSZ];
-	struct xfs_verify_extent	*ve = arg;
+	struct media_verify_state	*vs = arg;
 	struct bitmap			*tree;
 	dev_t				dev;
 	bool				moveon;
@@ -360,9 +360,9 @@ xfs_check_rmap_ioerr(
 	 * later rescanning.
 	 */
 	if (dev == ctx->fsinfo.fs_datadev)
-		tree = ve->d_bad;
+		tree = vs->d_bad;
 	else if (dev == ctx->fsinfo.fs_rtdev)
-		tree = ve->r_bad;
+		tree = vs->r_bad;
 	else
 		tree = NULL;
 	if (tree) {
@@ -395,10 +395,10 @@ xfs_check_rmap(
 	struct fsmap			*map,
 	void				*arg)
 {
-	struct xfs_verify_extent	*ve = arg;
+	struct media_verify_state	*vs = arg;
 	struct read_verify_pool		*rvp;
 
-	rvp = xfs_dev_to_pool(ctx, ve, map->fmr_device);
+	rvp = xfs_dev_to_pool(ctx, vs, map->fmr_device);
 
 	dbg_printf("rmap dev %d:%d phys %"PRIu64" owner %"PRId64
 			" offset %"PRIu64" len %"PRIu64" flags 0x%x\n",
@@ -425,7 +425,7 @@ xfs_check_rmap(
 	/* XXX: Filter out directory data blocks. */
 
 	/* Schedule the read verify command for (eventual) running. */
-	read_verify_schedule_io(rvp, map->fmr_physical, map->fmr_length, ve);
+	read_verify_schedule_io(rvp, map->fmr_physical, map->fmr_length, vs);
 
 out:
 	/* Is this the last extent?  Fire off the read. */
@@ -463,35 +463,35 @@ bool
 xfs_scan_blocks(
 	struct scrub_ctx		*ctx)
 {
-	struct xfs_verify_extent	ve = { NULL };
+	struct media_verify_state	vs = { NULL };
 	bool				moveon;
 
-	moveon = bitmap_init(&ve.d_bad);
+	moveon = bitmap_init(&vs.d_bad);
 	if (!moveon) {
 		str_errno(ctx, ctx->mntpoint);
 		goto out;
 	}
 
-	moveon = bitmap_init(&ve.r_bad);
+	moveon = bitmap_init(&vs.r_bad);
 	if (!moveon) {
 		str_errno(ctx, ctx->mntpoint);
 		goto out_dbad;
 	}
 
-	ve.rvp_data = read_verify_pool_init(ctx, ctx->datadev,
+	vs.rvp_data = read_verify_pool_init(ctx, ctx->datadev,
 			ctx->geo.blocksize, xfs_check_rmap_ioerr,
 			scrub_nproc(ctx));
-	if (!ve.rvp_data) {
+	if (!vs.rvp_data) {
 		moveon = false;
 		str_info(ctx, ctx->mntpoint,
 _("Could not create data device media verifier."));
 		goto out_rbad;
 	}
 	if (ctx->logdev) {
-		ve.rvp_log = read_verify_pool_init(ctx, ctx->logdev,
+		vs.rvp_log = read_verify_pool_init(ctx, ctx->logdev,
 				ctx->geo.blocksize, xfs_check_rmap_ioerr,
 				scrub_nproc(ctx));
-		if (!ve.rvp_log) {
+		if (!vs.rvp_log) {
 			moveon = false;
 			str_info(ctx, ctx->mntpoint,
 	_("Could not create log device media verifier."));
@@ -499,43 +499,43 @@ _("Could not create data device media verifier."));
 		}
 	}
 	if (ctx->rtdev) {
-		ve.rvp_realtime = read_verify_pool_init(ctx, ctx->rtdev,
+		vs.rvp_realtime = read_verify_pool_init(ctx, ctx->rtdev,
 				ctx->geo.blocksize, xfs_check_rmap_ioerr,
 				scrub_nproc(ctx));
-		if (!ve.rvp_realtime) {
+		if (!vs.rvp_realtime) {
 			moveon = false;
 			str_info(ctx, ctx->mntpoint,
 	_("Could not create realtime device media verifier."));
 			goto out_logpool;
 		}
 	}
-	moveon = xfs_scan_all_spacemaps(ctx, xfs_check_rmap, &ve);
+	moveon = xfs_scan_all_spacemaps(ctx, xfs_check_rmap, &vs);
 	if (!moveon)
 		goto out_rtpool;
-	ctx->bytes_checked += clean_pool(ve.rvp_data);
-	ctx->bytes_checked += clean_pool(ve.rvp_log);
-	ctx->bytes_checked += clean_pool(ve.rvp_realtime);
+	ctx->bytes_checked += clean_pool(vs.rvp_data);
+	ctx->bytes_checked += clean_pool(vs.rvp_log);
+	ctx->bytes_checked += clean_pool(vs.rvp_realtime);
 
 	/* Scan the whole dir tree to see what matches the bad extents. */
-	if (!bitmap_empty(ve.d_bad) || !bitmap_empty(ve.r_bad))
-		moveon = xfs_report_verify_errors(ctx, ve.d_bad, ve.r_bad);
+	if (!bitmap_empty(vs.d_bad) || !bitmap_empty(vs.r_bad))
+		moveon = xfs_report_verify_errors(ctx, vs.d_bad, vs.r_bad);
 
-	bitmap_free(&ve.r_bad);
-	bitmap_free(&ve.d_bad);
+	bitmap_free(&vs.r_bad);
+	bitmap_free(&vs.d_bad);
 	return moveon;
 
 out_rtpool:
-	if (ve.rvp_realtime)
-		read_verify_pool_destroy(ve.rvp_realtime);
+	if (vs.rvp_realtime)
+		read_verify_pool_destroy(vs.rvp_realtime);
 out_logpool:
-	if (ve.rvp_log)
-		read_verify_pool_destroy(ve.rvp_log);
+	if (vs.rvp_log)
+		read_verify_pool_destroy(vs.rvp_log);
 out_datapool:
-	read_verify_pool_destroy(ve.rvp_data);
+	read_verify_pool_destroy(vs.rvp_data);
 out_rbad:
-	bitmap_free(&ve.r_bad);
+	bitmap_free(&vs.r_bad);
 out_dbad:
-	bitmap_free(&ve.d_bad);
+	bitmap_free(&vs.d_bad);
 out:
 	return moveon;
 }
