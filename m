Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5FEC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EADC821D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FvH1nqZs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfIYVje (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48224 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbfIYVje (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdPix013249;
        Wed, 25 Sep 2019 21:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yKv/iiIKYs1QePsaBX8hPYXJl7HRgmJBNd/54IU9UVA=;
 b=FvH1nqZsluPZj7wyfeclAYrLbJpJ7RheXtik+F4Eu6BdG5x79pt/p8ZiiEjjT0fCcOtn
 1eVSvF0aVkUTyd4nTLqE/VnP41XPae+PHyid7mQjDh5imMUBGzMrNfKSb/wYE6iIuoQP
 MVoYz5N/mFR1Sc6oIDM0+t4s8PTgBuqI8FUa9xM35dGUdswErbd9oPerEEkaRShR7n5m
 mfbEjLXaN8NLJaa2jlzO+3lMAZ0LWxfKSJdkXw5CPeS0tt1RaCedJe02eLCH9wkthj9r
 N3BgcpKJTMhzh7xbEen0Z/fQpceoQdPoQC+v9QCuZkYog357g6/k+i8lNldR64qKaVuk ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btq7j9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdOt0033662;
        Wed, 25 Sep 2019 21:39:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuvk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:27 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLdDm5018886;
        Wed, 25 Sep 2019 21:39:13 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:39:13 -0700
Subject: [PATCH 11/18] xfs_scrub: remove moveon from phase 6 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:39:12 -0700
Message-ID: <156944755221.301514.3338654907589072498.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the phase 6 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |  173 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 92 insertions(+), 81 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 49650a21..9ee337f5 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -45,7 +45,7 @@ struct media_verify_state {
 
 /* Find the fd for a given device identifier. */
 static struct read_verify_pool *
-xfs_dev_to_pool(
+dev_to_pool(
 	struct scrub_ctx		*ctx,
 	struct media_verify_state	*vs,
 	dev_t				dev)
@@ -61,7 +61,7 @@ xfs_dev_to_pool(
 
 /* Find the device major/minor for a given file descriptor. */
 static dev_t
-xfs_disk_to_dev(
+disk_to_dev(
 	struct scrub_ctx	*ctx,
 	struct disk		*disk)
 {
@@ -95,7 +95,7 @@ static const struct owner_decode special_owners[] = {
 
 /* Decode a special owner. */
 static const char *
-xfs_decode_special_owner(
+decode_special_owner(
 	uint64_t			owner)
 {
 	const struct owner_decode	*od = special_owners;
@@ -213,8 +213,8 @@ _("media error in extended attribute data."));
 }
 
 /* Iterate the extent mappings of a file to report errors. */
-static bool
-xfs_report_verify_fd(
+static int
+report_fd_loss(
 	struct scrub_ctx		*ctx,
 	const char			*descr,
 	int				fd,
@@ -236,7 +236,7 @@ xfs_report_verify_fd(
 			report_data_loss, &br);
 	if (ret) {
 		str_liberror(ctx, ret, bmap_descr);
-		return false;
+		return ret;
 	}
 
 	/* attr fork */
@@ -245,23 +245,23 @@ xfs_report_verify_fd(
 			report_attr_loss, &br);
 	if (ret) {
 		str_liberror(ctx, ret, bmap_descr);
-		return false;
+		return ret;
 	}
-	return true;
+
+	return 0;
 }
 
 /* Report read verify errors in unlinked (but still open) files. */
 static int
-xfs_report_verify_inode(
+report_inode_loss(
 	struct scrub_ctx		*ctx,
 	struct xfs_handle		*handle,
 	struct xfs_bulkstat		*bstat,
 	void				*arg)
 {
 	char				descr[DESCR_BUFSZ];
-	bool				moveon;
 	int				fd;
-	int				error;
+	int				error, err2;
 
 	/* Ignore linked files and things we can't open. */
 	if (bstat->bs_nlink != 0)
@@ -285,26 +285,24 @@ _("Disappeared during read error reporting."));
 	}
 
 	/* Go find the badness. */
-	moveon = xfs_report_verify_fd(ctx, descr, fd, arg);
-	error = close(fd);
-	if (error)
+	error = report_fd_loss(ctx, descr, fd, arg);
+
+	err2 = close(fd);
+	if (err2)
 		str_errno(ctx, descr);
 
-	return moveon ? 0 : XFS_ITERATE_INODES_ABORT;
+	return error;
 }
 
 /* Scan a directory for matches in the read verify error list. */
 static int
-xfs_report_verify_dir(
+report_dir_loss(
 	struct scrub_ctx	*ctx,
 	const char		*path,
 	int			dir_fd,
 	void			*arg)
 {
-	bool			moveon;
-
-	moveon = xfs_report_verify_fd(ctx, path, dir_fd, arg);
-	return moveon ? 0 : -1;
+	return report_fd_loss(ctx, path, dir_fd, arg);
 }
 
 /*
@@ -312,7 +310,7 @@ xfs_report_verify_dir(
  * the read verify error list.
  */
 static int
-xfs_report_verify_dirent(
+report_dirent_loss(
 	struct scrub_ctx	*ctx,
 	const char		*path,
 	int			dir_fd,
@@ -320,9 +318,8 @@ xfs_report_verify_dirent(
 	struct stat		*sb,
 	void			*arg)
 {
-	bool			moveon;
 	int			fd;
-	int			error;
+	int			error, err2;
 
 	/* Ignore things we can't open. */
 	if (!S_ISREG(sb->st_mode) && !S_ISDIR(sb->st_mode))
@@ -347,15 +344,15 @@ xfs_report_verify_dirent(
 	}
 
 	/* Go find the badness. */
-	moveon = xfs_report_verify_fd(ctx, path, fd, arg);
-	if (moveon)
-		goto out;
+	error = report_fd_loss(ctx, path, fd, arg);
 
-out:
-	error = close(fd);
-	if (error)
+	err2 = close(fd);
+	if (err2)
 		str_errno(ctx, path);
-	return moveon ? 0 : -1;
+	if (!error && err2)
+		error = err2;
+
+	return error;
 }
 
 /* Report an IO error resulting from read-verify based off getfsmap. */
@@ -383,7 +380,7 @@ ioerr_fsmap_report(
 	if (map->fmr_flags & FMR_OF_SPECIAL_OWNER) {
 		snprintf(buf, DESCR_BUFSZ, _("disk offset %"PRIu64),
 				(uint64_t)map->fmr_physical + err_off);
-		type = xfs_decode_special_owner(map->fmr_owner);
+		type = decode_special_owner(map->fmr_owner);
 		str_error(ctx, buf, _("media error in %s."), type);
 	}
 
@@ -413,7 +410,7 @@ bitmap_for_disk(
 	struct disk			*disk,
 	struct media_verify_state	*vs)
 {
-	dev_t				dev = xfs_disk_to_dev(ctx, disk);
+	dev_t				dev = disk_to_dev(ctx, disk);
 
 	/*
 	 * If we don't have parent pointers, save the bad extent for
@@ -457,6 +454,7 @@ struct walk_ioerr {
 	struct disk		*disk;
 };
 
+/* For a given badblocks extent, walk the rmap data to tell us what was lost. */
 static int
 walk_ioerr(
 	uint64_t		start,
@@ -467,7 +465,7 @@ walk_ioerr(
 	struct fsmap		keys[2];
 	dev_t			dev;
 
-	dev = xfs_disk_to_dev(wioerr->ctx, wioerr->disk);
+	dev = disk_to_dev(wioerr->ctx, wioerr->disk);
 
 	/* Go figure out which blocks are bad from the fsmap. */
 	memset(keys, 0, sizeof(struct fsmap) * 2);
@@ -482,6 +480,7 @@ walk_ioerr(
 			&start);
 }
 
+/* Walk all badblocks extents to report what was lost. */
 static int
 walk_ioerrs(
 	struct scrub_ctx		*ctx,
@@ -503,8 +502,8 @@ walk_ioerrs(
 }
 
 /* Given bad extent lists for the data & rtdev, find bad files. */
-static bool
-xfs_report_verify_errors(
+static int
+report_loss(
 	struct scrub_ctx		*ctx,
 	struct media_verify_state	*vs)
 {
@@ -513,24 +512,22 @@ xfs_report_verify_errors(
 	ret = walk_ioerrs(ctx, ctx->datadev, vs);
 	if (ret) {
 		str_liberror(ctx, ret, _("walking datadev io errors"));
-		return false;
+		return ret;
 	}
 
 	ret = walk_ioerrs(ctx, ctx->rtdev, vs);
 	if (ret) {
 		str_liberror(ctx, ret, _("walking rtdev io errors"));
-		return false;
+		return ret;
 	}
 
 	/* Scan the directory tree to get file paths. */
-	ret = scan_fs_tree(ctx, xfs_report_verify_dir,
-			xfs_report_verify_dirent, vs);
+	ret = scan_fs_tree(ctx, report_dir_loss, report_dirent_loss, vs);
 	if (ret)
-		return false;
+		return ret;
 
 	/* Scan for unlinked files. */
-	ret = scrub_scan_all_inodes(ctx, xfs_report_verify_inode, vs);
-	return ret == 0;
+	return scrub_scan_all_inodes(ctx, report_inode_loss, vs);
 }
 
 /* Schedule a read-verify of a (data block) extent. */
@@ -544,7 +541,7 @@ check_rmap(
 	struct read_verify_pool		*rvp;
 	int				ret;
 
-	rvp = xfs_dev_to_pool(ctx, vs, map->fmr_device);
+	rvp = dev_to_pool(ctx, vs, map->fmr_device);
 
 	dbg_printf("rmap dev %d:%d phys %"PRIu64" owner %"PRId64
 			" offset %"PRIu64" len %"PRIu64" flags 0x%x\n",
@@ -622,7 +619,7 @@ verify_entire_disk(
 }
 
 /* Scan every part of every disk. */
-static bool
+static int
 verify_all_disks(
 	struct scrub_ctx		*ctx,
 	struct media_verify_state	*vs)
@@ -632,14 +629,14 @@ verify_all_disks(
 	ret = verify_entire_disk(vs->rvp_data, ctx->datadev, vs);
 	if (ret) {
 		str_liberror(ctx, ret, _("scheduling datadev verify"));
-		return false;
+		return ret;
 	}
 
 	if (ctx->logdev) {
 		ret = verify_entire_disk(vs->rvp_log, ctx->logdev, vs);
 		if (ret) {
 			str_liberror(ctx, ret, _("scheduling logdev verify"));
-			return false;
+			return ret;
 		}
 	}
 
@@ -647,11 +644,11 @@ verify_all_disks(
 		ret = verify_entire_disk(vs->rvp_realtime, ctx->rtdev, vs);
 		if (ret) {
 			str_liberror(ctx, ret, _("scheduling rtdev verify"));
-			return false;
+			return ret;
 		}
 	}
 
-	return true;
+	return 0;
 }
 
 /*
@@ -662,18 +659,17 @@ verify_all_disks(
  * scan the extent maps of the entire fs tree to figure (and the unlinked
  * inodes) out which files are now broken.
  */
-bool
-xfs_scan_blocks(
+int
+phase6_func(
 	struct scrub_ctx		*ctx)
 {
 	struct media_verify_state	vs = { NULL };
-	bool				moveon = false;
-	int				ret;
+	int				ret, ret2, ret3;
 
 	ret = bitmap_alloc(&vs.d_bad);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev badblock bitmap"));
-		goto out;
+		return ret;
 	}
 
 	ret = bitmap_alloc(&vs.r_bad);
@@ -711,40 +707,39 @@ xfs_scan_blocks(
 	}
 
 	if (scrub_data > 1)
-		moveon = verify_all_disks(ctx, &vs);
-	else {
+		ret = verify_all_disks(ctx, &vs);
+	else
 		ret = scrub_scan_all_spacemaps(ctx, check_rmap, &vs);
-		if (ret)
-			moveon = false;
-	}
-	if (!moveon)
+	if (ret)
 		goto out_rtpool;
 
 	ret = clean_pool(vs.rvp_data, &ctx->bytes_checked);
-	if (ret) {
+	if (ret)
 		str_liberror(ctx, ret, _("flushing datadev verify pool"));
-		moveon = false;
-	}
 
-	ret = clean_pool(vs.rvp_log, &ctx->bytes_checked);
-	if (ret) {
-		str_liberror(ctx, ret, _("flushing logdev verify pool"));
-		moveon = false;
-	}
+	ret2 = clean_pool(vs.rvp_log, &ctx->bytes_checked);
+	if (ret2)
+		str_liberror(ctx, ret2, _("flushing logdev verify pool"));
 
-	ret = clean_pool(vs.rvp_realtime, &ctx->bytes_checked);
-	if (ret) {
-		str_liberror(ctx, ret, _("flushing rtdev verify pool"));
-		moveon = false;
-	}
+	ret3 = clean_pool(vs.rvp_realtime, &ctx->bytes_checked);
+	if (ret3)
+		str_liberror(ctx, ret3, _("flushing rtdev verify pool"));
+
+	/*
+	 * If the verify flush didn't work or we found no bad blocks, we're
+	 * done!  No errors detected.
+	 */
+	if (ret || ret2 || ret3)
+		goto out_rbad;
+	if (bitmap_empty(vs.d_bad) && bitmap_empty(vs.r_bad))
+		goto out_rbad;
 
 	/* Scan the whole dir tree to see what matches the bad extents. */
-	if (moveon && (!bitmap_empty(vs.d_bad) || !bitmap_empty(vs.r_bad)))
-		moveon = xfs_report_verify_errors(ctx, &vs);
+	ret = report_loss(ctx, &vs);
 
 	bitmap_free(&vs.r_bad);
 	bitmap_free(&vs.d_bad);
-	return moveon;
+	return ret;
 
 out_rtpool:
 	if (vs.rvp_realtime) {
@@ -763,13 +758,19 @@ xfs_scan_blocks(
 	bitmap_free(&vs.r_bad);
 out_dbad:
 	bitmap_free(&vs.d_bad);
-out:
-	return moveon;
+	return ret;
 }
 
-/* Estimate how much work we're going to do. */
 bool
-xfs_estimate_verify_work(
+xfs_scan_blocks(
+	struct scrub_ctx		*ctx)
+{
+	return phase6_func(ctx) == 0;
+}
+
+/* Estimate how much work we're going to do. */
+int
+phase6_estimate(
 	struct scrub_ctx	*ctx,
 	uint64_t		*items,
 	unsigned int		*nr_threads,
@@ -787,7 +788,7 @@ xfs_estimate_verify_work(
 				&r_blocks, &r_bfree, &f_files, &f_free);
 	if (ret) {
 		str_liberror(ctx, ret, _("estimating verify work"));
-		return false;
+		return ret;
 	}
 
 	*items = cvt_off_fsb_to_b(&ctx->mnt, d_blocks + r_blocks);
@@ -795,5 +796,15 @@ xfs_estimate_verify_work(
 		*items -= cvt_off_fsb_to_b(&ctx->mnt, d_bfree + r_bfree);
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 20;
-	return true;
+	return 0;
+}
+
+bool
+xfs_estimate_verify_work(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	return phase6_estimate(ctx, items, nr_threads, rshift) == 0;
 }

