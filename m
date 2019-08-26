Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8507DC3A5A4
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F1402189D
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HBBjBVko"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfHZVbv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:31:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51422 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbfHZVbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:31:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLEi8C161895;
        Mon, 26 Aug 2019 21:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=whXtwiVfPJmrXSGOpxhivXZSN922kZCMEoZ5TS35APE=;
 b=HBBjBVko1LkCVmN0rEFwwoOkHRiqM9KWyyNOa66exzVWaoJIHKMAxKa6STZO56JWFxFz
 QsYjDJP2o+1gdjBTf9nKWJ9I7R2daS++EGWFgJr3KNqJuDJwuY7oiRfyUAVe8iBvyh9v
 ilk27LTRIlt0k3a7RBQZClmSa7+Dl9A2/pZzT8TO8KtKiE+/PeVDacx28DLiubexhUWu
 mgii4KNQBW7n38DahtvW9UENclMr9Jy59U0/FraKWKKxQYo2BoGl6EjncR5ElEtohlKQ
 MVjXSq3jta1lGSG8X2WNC+6nF7imbJf06qADHwrV2yBG5W7TCfawFCQaYtLM6YZ8BwqO Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2umq5t82e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIw5g185531;
        Mon, 26 Aug 2019 21:31:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2umj2xw01q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLVlpL008881;
        Mon, 26 Aug 2019 21:31:47 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:31:47 -0700
Subject: [PATCH 06/11] xfs_scrub: reduce fsmap activity for media errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:31:46 -0700
Message-ID: <156685510636.2843133.11157951829193779296.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
 libfrog/bitmap.c |   15 +++--
 scrub/phase6.c   |  148 ++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 112 insertions(+), 51 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index cc5d99f1..c3aa2545 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -317,7 +317,6 @@ bitmap_clear(
 }
 #endif
 
-#ifdef DEBUG
 /* Iterate the set regions of this bitmap. */
 int
 bitmap_iterate(
@@ -327,20 +326,22 @@ bitmap_iterate(
 {
 	struct avl64node	*node;
 	struct bitmap_node	*ext;
-	int			error = 0;
+	int			ret;
+
+	ret = pthread_mutex_lock(&bmap->bt_lock);
+	if (ret)
+		return ret;
 
-	pthread_mutex_lock(&bmap->bt_lock);
 	avl_for_each(bmap->bt_tree, node) {
 		ext = container_of(node, struct bitmap_node, btn_node);
-		error = fn(ext->btn_start, ext->btn_length, arg);
-		if (error)
+		ret = fn(ext->btn_start, ext->btn_length, arg);
+		if (ret)
 			break;
 	}
 	pthread_mutex_unlock(&bmap->bt_lock);
 
-	return error;
+	return ret;
 }
-#endif
 
 /* Iterate the set regions of part of this bitmap. */
 int
diff --git a/scrub/phase6.c b/scrub/phase6.c
index f5b57185..33ed75cc 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -341,27 +341,9 @@ xfs_report_verify_dirent(
 	return moveon;
 }
 
-/* Given bad extent lists for the data & rtdev, find bad files. */
-static bool
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
 /* Report an IO error resulting from read-verify based off getfsmap. */
 static bool
-xfs_check_rmap_error_report(
+ioerr_fsmap_report(
 	struct scrub_ctx	*ctx,
 	const char		*descr,
 	struct fsmap		*map,
@@ -409,12 +391,31 @@ xfs_check_rmap_error_report(
 	return true;
 }
 
+static struct bitmap *
+bitmap_for_disk(
+	struct scrub_ctx		*ctx,
+	struct disk			*disk,
+	struct media_verify_state	*vs)
+{
+	dev_t				dev = xfs_disk_to_dev(ctx, disk);
+
+	/*
+	 * If we don't have parent pointers, save the bad extent for
+	 * later rescanning.
+	 */
+	if (dev == ctx->fsinfo.fs_datadev)
+		return vs->d_bad;
+	else if (dev == ctx->fsinfo.fs_rtdev)
+		return vs->r_bad;
+	return NULL;
+}
+
 /*
  * Remember a read error for later, and see if rmap will tell us about the
  * owner ahead of time.
  */
 static void
-xfs_check_rmap_ioerr(
+remember_ioerr(
 	struct scrub_ctx		*ctx,
 	struct disk			*disk,
 	uint64_t			start,
@@ -422,32 +423,39 @@ xfs_check_rmap_ioerr(
 	int				error,
 	void				*arg)
 {
-	struct fsmap			keys[2];
-	char				descr[DESCR_BUFSZ];
 	struct media_verify_state	*vs = arg;
 	struct bitmap			*tree;
-	dev_t				dev;
 	int				ret;
 
-	dev = xfs_disk_to_dev(ctx, disk);
+	tree = bitmap_for_disk(ctx, disk, vs);
+	if (!tree)
+		return;
 
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
+	ret = bitmap_set(tree, start, length);
+	if (ret)
+		str_liberror(ctx, ret, _("setting bad block bitmap"));
+}
+
+struct walk_ioerr {
+	struct scrub_ctx	*ctx;
+	struct disk		*disk;
+};
+
+static int
+walk_ioerr(
+	uint64_t		start,
+	uint64_t		length,
+	void			*arg)
+{
+	struct walk_ioerr	*wioerr = arg;
+	struct fsmap		keys[2];
+	char			descr[DESCR_BUFSZ];
+	dev_t			dev;
+
+	dev = xfs_disk_to_dev(wioerr->ctx, wioerr->disk);
 
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
+	snprintf(descr, DESCR_BUFSZ,
+_("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
 			major(dev), minor(dev), start, length);
 
 	/* Go figure out which blocks are bad from the fsmap. */
@@ -459,8 +467,60 @@ xfs_check_rmap_ioerr(
 	(keys + 1)->fmr_owner = ULLONG_MAX;
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
-	xfs_iterate_fsmap(ctx, descr, keys, xfs_check_rmap_error_report,
+	xfs_iterate_fsmap(wioerr->ctx, descr, keys, ioerr_fsmap_report,
 			&start);
+	return 0;
+}
+
+static int
+walk_ioerrs(
+	struct scrub_ctx		*ctx,
+	struct disk			*disk,
+	struct media_verify_state	*vs)
+{
+	struct walk_ioerr		wioerr = {
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
+	return bitmap_iterate(tree, walk_ioerr, &wioerr);
+}
+
+/* Given bad extent lists for the data & rtdev, find bad files. */
+static bool
+xfs_report_verify_errors(
+	struct scrub_ctx		*ctx,
+	struct media_verify_state	*vs)
+{
+	bool				moveon;
+	int				ret;
+
+	ret = walk_ioerrs(ctx, ctx->datadev, vs);
+	if (ret) {
+		str_liberror(ctx, ret, _("walking datadev io errors"));
+		return false;
+	}
+
+	ret = walk_ioerrs(ctx, ctx->rtdev, vs);
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
@@ -571,7 +631,7 @@ xfs_scan_blocks(
 	}
 
 	ret = read_verify_pool_alloc(ctx, ctx->datadev,
-			ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
+			ctx->mnt.fsgeom.blocksize, remember_ioerr,
 			scrub_nproc(ctx), &vs.rvp_data);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
@@ -579,7 +639,7 @@ xfs_scan_blocks(
 	}
 	if (ctx->logdev) {
 		ret = read_verify_pool_alloc(ctx, ctx->logdev,
-				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
+				ctx->mnt.fsgeom.blocksize, remember_ioerr,
 				scrub_nproc(ctx), &vs.rvp_log);
 		if (ret) {
 			str_liberror(ctx, ret,
@@ -589,7 +649,7 @@ xfs_scan_blocks(
 	}
 	if (ctx->rtdev) {
 		ret = read_verify_pool_alloc(ctx, ctx->rtdev,
-				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
+				ctx->mnt.fsgeom.blocksize, remember_ioerr,
 				scrub_nproc(ctx), &vs.rvp_realtime);
 		if (ret) {
 			str_liberror(ctx, ret,

