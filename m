Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30997C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E75A520663
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iL63fWjf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732234AbfKFVC7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 16:02:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55398 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732364AbfKFVC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 16:02:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6KxAh2175886;
        Wed, 6 Nov 2019 21:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Bx0sBus1CG+Da0R+i3KqLs5Ge5ag4aUJSiOxbc4lbnY=;
 b=iL63fWjf+4xZ5UWn4P/9JHUnNtuDoGYggS79kq8cUYYHIvxEbbPDpiqvHVjLEn9+xqe3
 KJOoOQ1h87zduGcOc+FbDxQ9yTBrehBbP3ysEZ65PY1ZKVxKF+kP9OPwrkfzDdK9ybdF
 ULxgxE7A4ULDEs7cJnsuXFqbPS56hLPNr2J20DBgYf1iu5SQiCioSCTGlUHeotMa/Iio
 h634l0gvcvb9QgMpP7p0V07CUHz+M6/mYpv6KqqPnXOmUDfT/tla3BNZkexf4oygw7F6
 ufcfDwIO58NbFh3iryvucnBt7EhdgBysK2PjiQ2RHl2wY+JTrf6JXM2xITmcg1FW0EfK Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w11pt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:02:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Kvmar079763;
        Wed, 6 Nov 2019 21:02:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w41wef513-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:02:55 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6L2tgh006872;
        Wed, 6 Nov 2019 21:02:55 GMT
Received: from localhost (/10.159.234.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 13:02:55 -0800
Date:   Wed, 6 Nov 2019 13:02:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 11/18] xfs_scrub: remove moveon from phase 6 functions
Message-ID: <20191106210254.GR4153244@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
 <157177029785.1461658.16369630986861245070.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157177029785.1461658.16369630986861245070.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the phase 6 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: rebase without full-disk media scan
---
 scrub/phase6.c |  154 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 82 insertions(+), 72 deletions(-)

diff --git a/scrub/phase6.c b/scrub/phase6.c
index 62629732..020b303d 100644
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
@@ -81,7 +81,7 @@ bitmap_for_disk(
 	struct disk			*disk,
 	struct media_verify_state	*vs)
 {
-	dev_t				dev = xfs_disk_to_dev(ctx, disk);
+	dev_t				dev = disk_to_dev(ctx, disk);
 
 	if (dev == ctx->fsinfo.fs_datadev)
 		return vs->d_bad;
@@ -116,7 +116,7 @@ static const struct owner_decode special_owners[] = {
 
 /* Decode a special owner. */
 static const char *
-xfs_decode_special_owner(
+decode_special_owner(
 	uint64_t			owner)
 {
 	const struct owner_decode	*od = special_owners;
@@ -232,8 +232,8 @@ _("media error in extended attribute data."));
 }
 
 /* Iterate the extent mappings of a file to report errors. */
-static bool
-xfs_report_verify_fd(
+static int
+report_fd_loss(
 	struct scrub_ctx		*ctx,
 	const char			*descr,
 	int				fd,
@@ -252,7 +252,7 @@ xfs_report_verify_fd(
 			report_data_loss, &br);
 	if (ret) {
 		str_liberror(ctx, ret, descr);
-		return false;
+		return ret;
 	}
 
 	/* attr fork */
@@ -260,23 +260,23 @@ xfs_report_verify_fd(
 			report_attr_loss, &br);
 	if (ret) {
 		str_liberror(ctx, ret, descr);
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
@@ -300,26 +300,24 @@ _("Disappeared during read error reporting."));
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
@@ -327,7 +325,7 @@ xfs_report_verify_dir(
  * the read verify error list.
  */
 static int
-xfs_report_verify_dirent(
+report_dirent_loss(
 	struct scrub_ctx	*ctx,
 	const char		*path,
 	int			dir_fd,
@@ -335,9 +333,8 @@ xfs_report_verify_dirent(
 	struct stat		*sb,
 	void			*arg)
 {
-	bool			moveon;
 	int			fd;
-	int			error;
+	int			error, err2;
 
 	/* Ignore things we can't open. */
 	if (!S_ISREG(sb->st_mode) && !S_ISDIR(sb->st_mode))
@@ -362,15 +359,15 @@ xfs_report_verify_dirent(
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
 
 /* Use a fsmap to report metadata lost to a media error. */
@@ -398,7 +395,7 @@ report_ioerr_fsmap(
 	if (map->fmr_flags & FMR_OF_SPECIAL_OWNER) {
 		snprintf(buf, DESCR_BUFSZ, _("disk offset %"PRIu64),
 				(uint64_t)map->fmr_physical + err_off);
-		type = xfs_decode_special_owner(map->fmr_owner);
+		type = decode_special_owner(map->fmr_owner);
 		str_corrupt(ctx, buf, _("media error in %s."), type);
 	}
 
@@ -436,7 +433,7 @@ report_ioerr(
 	struct disk_ioerr_report	*dioerr = arg;
 	dev_t				dev;
 
-	dev = xfs_disk_to_dev(dioerr->ctx, dioerr->disk);
+	dev = disk_to_dev(dioerr->ctx, dioerr->disk);
 
 	/* Go figure out which blocks are bad from the fsmap. */
 	memset(keys, 0, sizeof(struct fsmap) * 2);
@@ -473,7 +470,7 @@ report_disk_ioerrs(
 }
 
 /* Given bad extent lists for the data & rtdev, find bad files. */
-static bool
+static int
 report_all_media_errors(
 	struct scrub_ctx		*ctx,
 	struct media_verify_state	*vs)
@@ -483,24 +480,22 @@ report_all_media_errors(
 	ret = report_disk_ioerrs(ctx, ctx->datadev, vs);
 	if (ret) {
 		str_liberror(ctx, ret, _("walking datadev io errors"));
-		return false;
+		return ret;
 	}
 
 	ret = report_disk_ioerrs(ctx, ctx->rtdev, vs);
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
@@ -514,7 +509,7 @@ check_rmap(
 	struct read_verify_pool		*rvp;
 	int				ret;
 
-	rvp = xfs_dev_to_pool(ctx, vs, map->fmr_device);
+	rvp = dev_to_pool(ctx, vs, map->fmr_device);
 
 	dbg_printf("rmap dev %d:%d phys %"PRIu64" owner %"PRId64
 			" offset %"PRIu64" len %"PRIu64" flags 0x%x\n",
@@ -614,18 +609,17 @@ remember_ioerr(
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
@@ -662,36 +656,36 @@ xfs_scan_blocks(
 		}
 	}
 	ret = scrub_scan_all_spacemaps(ctx, check_rmap, &vs);
-	if (ret) {
-		moveon = false;
+	if (ret)
 		goto out_rtpool;
-	}
 
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
-		moveon = report_all_media_errors(ctx, &vs);
+	ret = report_all_media_errors(ctx, &vs);
 
 	bitmap_free(&vs.r_bad);
 	bitmap_free(&vs.d_bad);
-	return moveon;
+	return ret;
 
 out_rtpool:
 	if (vs.rvp_realtime) {
@@ -710,13 +704,19 @@ xfs_scan_blocks(
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
@@ -734,12 +734,22 @@ xfs_estimate_verify_work(
 				&r_blocks, &r_bfree, &f_files, &f_free);
 	if (ret) {
 		str_liberror(ctx, ret, _("estimating verify work"));
-		return false;
+		return ret;
 	}
 
 	*items = cvt_off_fsb_to_b(&ctx->mnt,
 			(d_blocks - d_bfree) + (r_blocks - r_bfree));
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
