Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853A2C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A2AB20872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:36:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pN+ARriq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfIYVgu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:36:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60992 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfIYVgt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:36:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYjoD055357;
        Wed, 25 Sep 2019 21:36:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IkB5ZAQXVS+mOofugMVus4E7J0bEVDmxenzrMbuqRI8=;
 b=pN+ARriq/vKi8hxMYtEKk4j17OqeZlx9wJIrijOYYA17fMMtlz0Z8DPkyxxQFGgm9Hkm
 qVN6UCjT4RXR4H5QlkhF1OExdNlhHAfwWkfP9/3Syy/NLKO6xEKHYAIuH16bgCTD/Tqz
 27xHBeFQ+RtoKm3syeFrmwrW9rx2MaEcIaGExL98IvrLzrbkTQjGvPBJbIAzgOkTVlfE
 fVZE0kbt+JqP5q1PFsl+HJf5kVa3tFPET8z4IoD4IPLghroxGK+fuXg/Z0JNFJmXks6M
 mKnLIAGR/k7RWnfdudhxhvyg9z9yfbZ+6gfDJZ3IFmC+U10WByIMSk93OGBCo2BgMwLA ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgr7f3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYR5v011352;
        Wed, 25 Sep 2019 21:36:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2v829w52aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:36:46 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLajaf021204;
        Wed, 25 Sep 2019 21:36:45 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:36:45 -0700
Subject: [PATCH 06/11] xfs_scrub: reduce fsmap activity for media errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:36:44 -0700
Message-ID: <156944740409.300131.11774965759850122284.stgit@magnolia>
In-Reply-To: <156944736739.300131.5717633994765951730.stgit@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
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
 libfrog/bitmap.c |   10 +---
 scrub/phase6.c   |  148 ++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 108 insertions(+), 50 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 6a88ef48..5daa1081 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -314,7 +314,6 @@ bitmap_clear(
 }
 #endif
 
-#ifdef DEBUG
 /* Iterate the set regions of this bitmap. */
 int
 bitmap_iterate(
@@ -324,20 +323,19 @@ bitmap_iterate(
 {
 	struct avl64node	*node;
 	struct bitmap_node	*ext;
-	int			error = 0;
+	int			ret;
 
 	pthread_mutex_lock(&bmap->bt_lock);
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
index ec821373..378ea0fb 100644
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

