Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA93CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8195C20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nnXEpgrb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732746AbfJVSry (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:47:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:47:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIib1o089371;
        Tue, 22 Oct 2019 18:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=D6xEk807+SjlMEisJZO/YFJjkpZfMylW/K+FVVvIkA0=;
 b=nnXEpgrb3mWePhXxT60ex1nk3K0g6p2F9PejPUCIClm3HpUpRWW6gs/lBahPo7VYXC5/
 Ad2hx0jCybGZ488M2wRo9DcMOyW5oiTTUKm4uk1Nf5HjqRdqoJrYB+28ruW7Nc9VU4Ll
 OneB3SIg0SzjpyRqn6k7i/FrbIFJgxLoMvZAh0JazqqHy4XtGY/zfWcp/IM0EhETySfT
 tuY7UO0WNgCgjyLBh/70nVzEQkXm4FLXvua9LKNJJm0HBNTCaAdgr+O8bHRR2D+6rVU1
 ohXjOQc/OPgVeTNJZ+V/N/TM/QrlHy1oNe0ZXkMar6tBHm4eKQciFDGDxN2U/dNxMDEz dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4qrk17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhNAk125168;
        Tue, 22 Oct 2019 18:47:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vsx239pvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:50 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIln6i025183;
        Tue, 22 Oct 2019 18:47:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:47:49 -0700
Subject: [PATCH 7/9] xfs_scrub: reduce fsmap activity for media errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:47:48 -0700
Message-ID: <157177006826.1459098.5710881975327343302.stgit@magnolia>
In-Reply-To: <157177002473.1459098.11320398367215468164.stgit@magnolia>
References: <157177002473.1459098.11320398367215468164.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Right now we rather foolishly query the fsmap data for every single
media error that we find.  This is a silly waste of time since we
have yet to combine adjacent bad blocks into bad extents, so move the
rmap query until after we've constructed the bad block bitmap data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/bitmap.c |    2 -
 scrub/phase6.c   |  167 +++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 114 insertions(+), 55 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 6a88ef48..c928d26f 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -314,7 +314,6 @@ bitmap_clear(
 }
 #endif
 
-#ifdef DEBUG
 /* Iterate the set regions of this bitmap. */
 int
 bitmap_iterate(
@@ -337,7 +336,6 @@ bitmap_iterate(
 
 	return error;
 }
-#endif
 
 /* Iterate the set regions of part of this bitmap. */
 int
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 71a1922d..fccd18e9 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -74,6 +74,27 @@ xfs_disk_to_dev(
 	abort();
 }
 
+/* Find the incore bad blocks bitmap for a given disk. */
+static struct bitmap *
+bitmap_for_disk(
+	struct scrub_ctx		*ctx,
+	struct disk			*disk,
+	struct media_verify_state	*vs)
+{
+	dev_t				dev = xfs_disk_to_dev(ctx, disk);
+
+	if (dev == ctx->fsinfo.fs_datadev)
+		return vs->d_bad;
+	else if (dev == ctx->fsinfo.fs_rtdev)
+		return vs->r_bad;
+	return NULL;
+}
+
+struct disk_ioerr_report {
+	struct scrub_ctx	*ctx;
+	struct disk		*disk;
+};
+
 struct owner_decode {
 	uint64_t		owner;
 	const char		*descr;
@@ -341,27 +362,9 @@ xfs_report_verify_dirent(
 	return moveon;
 }
 
-/* Given bad extent lists for the data & rtdev, find bad files. */
+/* Use a fsmap to report metadata lost to a media error. */
 static bool
-xfs_report_verify_errors(
-	struct scrub_ctx		*ctx,
-	struct media_verify_state	*vs)
-{
-	bool				moveon;
-
-	/* Scan the directory tree to get file paths. */
-	moveon = scan_fs_tree(ctx, xfs_report_verify_dir,
-			xfs_report_verify_dirent, vs);
-	if (!moveon)
-		return false;
-
-	/* Scan for unlinked files. */
-	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, vs);
-}
-
-/* Report an IO error resulting from read-verify based off getfsmap. */
-static bool
-xfs_check_rmap_error_report(
+report_ioerr_fsmap(
 	struct scrub_ctx	*ctx,
 	const char		*descr,
 	struct fsmap		*map,
@@ -410,44 +413,24 @@ xfs_check_rmap_error_report(
 }
 
 /*
- * Remember a read error for later, and see if rmap will tell us about the
- * owner ahead of time.
+ * For a range of bad blocks, visit each space mapping that overlaps the bad
+ * range so that we can report lost metadata.
  */
-static void
-xfs_check_rmap_ioerr(
-	struct scrub_ctx		*ctx,
-	struct disk			*disk,
+static int
+report_ioerr(
 	uint64_t			start,
 	uint64_t			length,
-	int				error,
 	void				*arg)
 {
 	struct fsmap			keys[2];
 	char				descr[DESCR_BUFSZ];
-	struct media_verify_state	*vs = arg;
-	struct bitmap			*tree;
+	struct disk_ioerr_report	*dioerr = arg;
 	dev_t				dev;
-	int				ret;
 
-	dev = xfs_disk_to_dev(ctx, disk);
+	dev = xfs_disk_to_dev(dioerr->ctx, dioerr->disk);
 
-	/*
-	 * If we don't have parent pointers, save the bad extent for
-	 * later rescanning.
-	 */
-	if (dev == ctx->fsinfo.fs_datadev)
-		tree = vs->d_bad;
-	else if (dev == ctx->fsinfo.fs_rtdev)
-		tree = vs->r_bad;
-	else
-		tree = NULL;
-	if (tree) {
-		ret = bitmap_set(tree, start, length);
-		if (ret)
-			str_liberror(ctx, ret, _("setting bad block bitmap"));
-	}
-
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
+	snprintf(descr, DESCR_BUFSZ,
+_("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
 			major(dev), minor(dev), start, length);
 
 	/* Go figure out which blocks are bad from the fsmap. */
@@ -459,8 +442,61 @@ xfs_check_rmap_ioerr(
 	(keys + 1)->fmr_owner = ULLONG_MAX;
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
-	xfs_iterate_fsmap(ctx, descr, keys, xfs_check_rmap_error_report,
+	xfs_iterate_fsmap(dioerr->ctx, descr, keys, report_ioerr_fsmap,
 			&start);
+	return 0;
+}
+
+/* Report all the media errors found on a disk. */
+static int
+report_disk_ioerrs(
+	struct scrub_ctx		*ctx,
+	struct disk			*disk,
+	struct media_verify_state	*vs)
+{
+	struct disk_ioerr_report	dioerr = {
+		.ctx			= ctx,
+		.disk			= disk,
+	};
+	struct bitmap			*tree;
+
+	if (!disk)
+		return 0;
+	tree = bitmap_for_disk(ctx, disk, vs);
+	if (!tree)
+		return 0;
+	return bitmap_iterate(tree, report_ioerr, &dioerr);
+}
+
+/* Given bad extent lists for the data & rtdev, find bad files. */
+static bool
+report_all_media_errors(
+	struct scrub_ctx		*ctx,
+	struct media_verify_state	*vs)
+{
+	bool				moveon;
+	int				ret;
+
+	ret = report_disk_ioerrs(ctx, ctx->datadev, vs);
+	if (ret) {
+		str_liberror(ctx, ret, _("walking datadev io errors"));
+		return false;
+	}
+
+	ret = report_disk_ioerrs(ctx, ctx->rtdev, vs);
+	if (ret) {
+		str_liberror(ctx, ret, _("walking rtdev io errors"));
+		return false;
+	}
+
+	/* Scan the directory tree to get file paths. */
+	moveon = scan_fs_tree(ctx, xfs_report_verify_dir,
+			xfs_report_verify_dirent, vs);
+	if (!moveon)
+		return false;
+
+	/* Scan for unlinked files. */
+	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, vs);
 }
 
 /* Schedule a read-verify of a (data block) extent. */
@@ -542,6 +578,31 @@ clean_pool(
 	return ret;
 }
 
+/* Remember a media error for later. */
+static void
+remember_ioerr(
+	struct scrub_ctx		*ctx,
+	struct disk			*disk,
+	uint64_t			start,
+	uint64_t			length,
+	int				error,
+	void				*arg)
+{
+	struct media_verify_state	*vs = arg;
+	struct bitmap			*tree;
+	int				ret;
+
+	tree = bitmap_for_disk(ctx, disk, vs);
+	if (!tree) {
+		str_liberror(ctx, ENOENT, _("finding bad block bitmap"));
+		return;
+	}
+
+	ret = bitmap_set(tree, start, length);
+	if (ret)
+		str_liberror(ctx, ret, _("setting bad block bitmap"));
+}
+
 /*
  * Read verify all the file data blocks in a filesystem.  Since XFS doesn't
  * do data checksums, we trust that the underlying storage will pass back
@@ -571,7 +632,7 @@ xfs_scan_blocks(
 	}
 
 	ret = read_verify_pool_alloc(ctx, ctx->datadev,
-			ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
+			ctx->mnt.fsgeom.blocksize, remember_ioerr,
 			scrub_nproc(ctx), &vs.rvp_data);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
@@ -579,7 +640,7 @@ xfs_scan_blocks(
 	}
 	if (ctx->logdev) {
 		ret = read_verify_pool_alloc(ctx, ctx->logdev,
-				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
+				ctx->mnt.fsgeom.blocksize, remember_ioerr,
 				scrub_nproc(ctx), &vs.rvp_log);
 		if (ret) {
 			str_liberror(ctx, ret,
@@ -589,7 +650,7 @@ xfs_scan_blocks(
 	}
 	if (ctx->rtdev) {
 		ret = read_verify_pool_alloc(ctx, ctx->rtdev,
-				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
+				ctx->mnt.fsgeom.blocksize, remember_ioerr,
 				scrub_nproc(ctx), &vs.rvp_realtime);
 		if (ret) {
 			str_liberror(ctx, ret,
@@ -621,7 +682,7 @@ xfs_scan_blocks(
 
 	/* Scan the whole dir tree to see what matches the bad extents. */
 	if (moveon && (!bitmap_empty(vs.d_bad) || !bitmap_empty(vs.r_bad)))
-		moveon = xfs_report_verify_errors(ctx, &vs);
+		moveon = report_all_media_errors(ctx, &vs);
 
 	bitmap_free(&vs.r_bad);
 	bitmap_free(&vs.d_bad);

