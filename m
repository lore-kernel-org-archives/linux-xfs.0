Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7930C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35654217F4
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:02:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fv6tQ32B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfKFVC2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 16:02:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54778 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbfKFVC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 16:02:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6KxAPN175859;
        Wed, 6 Nov 2019 21:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Sqh7P33GCpABj5s4pZ/+9Rs0DHYU/O/00/BJdFy9J4k=;
 b=fv6tQ32BQKt+8MBPIdfPt7TwNwsNl3+00MUtADq4ym3nMTQTTHfDq7Z7R9Cdv2cghxLB
 ASdnLpGT7QyvCiciI4x25Lx03Lv52kTRIf65GwdzpXqMXK5bhjJ873mxswHWMPXjRD3J
 7Ljjjp4uO4BXVlEPvfZ/QgIGZvBllflf5gHiwdMf/zMD1U2KVkyfItK1pLyw8Snv3drB
 mgf8CK3tNFdiIK9koe+/y0zdqxMt8a5JDRjMPXD/AzJUw6mQSvKqA4Io8XKsuXjS6y0E
 sCX2R++IbQ7bH0dDaLqgtk+1y0L7strsuG4I5t0RTgwsZed1IWZhoIA0L9J+CZT6mQ6o 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w41w11ppr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:02:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Kw83j136842;
        Wed, 6 Nov 2019 21:02:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w41w80nyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:02:24 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6L2Mu0023236;
        Wed, 6 Nov 2019 21:02:24 GMT
Received: from localhost (/10.159.234.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 13:02:22 -0800
Date:   Wed, 6 Nov 2019 13:02:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 05/18] xfs_scrub: remove moveon from spacemap
Message-ID: <20191106210221.GQ4153244@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
 <157177025678.1461658.2280238130703744148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157177025678.1461658.2280238130703744148.stgit@magnolia>
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

Replace the moveon returns in the space map iteration code with a direct
integer return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: rebase without full-disk media scan
---
 scrub/phase6.c   |   34 +++++--------
 scrub/phase7.c   |   21 ++++----
 scrub/spacemap.c |  145 +++++++++++++++++++++++++++++-------------------------
 scrub/spacemap.h |   12 ++--
 4 files changed, 108 insertions(+), 104 deletions(-)

diff --git a/scrub/phase6.c b/scrub/phase6.c
index a0a71ce3..62629732 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -374,10 +374,9 @@ xfs_report_verify_dirent(
 }
 
 /* Use a fsmap to report metadata lost to a media error. */
-static bool
+static int
 report_ioerr_fsmap(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
 	struct fsmap		*map,
 	void			*arg)
 {
@@ -388,7 +387,7 @@ report_ioerr_fsmap(
 
 	/* Don't care about unwritten extents. */
 	if (map->fmr_flags & FMR_OF_PREALLOC)
-		return true;
+		return 0;
 
 	if (err_physical > map->fmr_physical)
 		err_off = err_physical - map->fmr_physical;
@@ -420,7 +419,7 @@ report_ioerr_fsmap(
 	 * to find the bad file's pathname.
 	 */
 
-	return true;
+	return 0;
 }
 
 /*
@@ -434,16 +433,11 @@ report_ioerr(
 	void				*arg)
 {
 	struct fsmap			keys[2];
-	char				descr[DESCR_BUFSZ];
 	struct disk_ioerr_report	*dioerr = arg;
 	dev_t				dev;
 
 	dev = xfs_disk_to_dev(dioerr->ctx, dioerr->disk);
 
-	snprintf(descr, DESCR_BUFSZ,
-_("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
-			major(dev), minor(dev), start, length);
-
 	/* Go figure out which blocks are bad from the fsmap. */
 	memset(keys, 0, sizeof(struct fsmap) * 2);
 	keys->fmr_device = dev;
@@ -453,9 +447,8 @@ _("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
 	(keys + 1)->fmr_owner = ULLONG_MAX;
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
-	xfs_iterate_fsmap(dioerr->ctx, descr, keys, report_ioerr_fsmap,
+	return scrub_iterate_fsmap(dioerr->ctx, keys, report_ioerr_fsmap,
 			&start);
-	return 0;
 }
 
 /* Report all the media errors found on a disk. */
@@ -511,10 +504,9 @@ report_all_media_errors(
 }
 
 /* Schedule a read-verify of a (data block) extent. */
-static bool
-xfs_check_rmap(
+static int
+check_rmap(
 	struct scrub_ctx		*ctx,
-	const char			*descr,
 	struct fsmap			*map,
 	void				*arg)
 {
@@ -544,7 +536,7 @@ xfs_check_rmap(
 	 */
 	if (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
 			      FMR_OF_EXTENT_MAP | FMR_OF_SPECIAL_OWNER))
-		return true;
+		return 0;
 
 	/* XXX: Filter out directory data blocks. */
 
@@ -552,11 +544,11 @@ xfs_check_rmap(
 	ret = read_verify_schedule_io(rvp, map->fmr_physical, map->fmr_length,
 			vs);
 	if (ret) {
-		str_liberror(ctx, ret, descr);
-		return false;
+		str_liberror(ctx, ret, _("scheduling media verify command"));
+		return ret;
 	}
 
-	return true;
+	return 0;
 }
 
 /* Wait for read/verify actions to finish, then return # bytes checked. */
@@ -669,9 +661,11 @@ xfs_scan_blocks(
 			goto out_logpool;
 		}
 	}
-	moveon = xfs_scan_all_spacemaps(ctx, xfs_check_rmap, &vs);
-	if (!moveon)
+	ret = scrub_scan_all_spacemaps(ctx, check_rmap, &vs);
+	if (ret) {
+		moveon = false;
 		goto out_rtpool;
+	}
 
 	ret = clean_pool(vs.rvp_data, &ctx->bytes_checked);
 	if (ret) {
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 6daf75b5..28689eac 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -27,10 +27,9 @@ struct summary_counts {
 };
 
 /* Record block usage. */
-static bool
-xfs_record_block_summary(
+static int
+count_block_summary(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
 	struct fsmap		*fsmap,
 	void			*arg)
 {
@@ -41,13 +40,13 @@ xfs_record_block_summary(
 	counts = ptvar_get((struct ptvar *)arg, &ret);
 	if (ret) {
 		str_liberror(ctx, ret, _("retrieving summary counts"));
-		return false;
+		return ret;
 	}
 	if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
-		return true;
+		return 0;
 	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
 	    fsmap->fmr_owner == XFS_FMR_OWN_FREE)
-		return true;
+		return 0;
 
 	len = fsmap->fmr_length;
 
@@ -62,14 +61,14 @@ xfs_record_block_summary(
 	} else {
 		/* Count datadev extents. */
 		if (counts->next_phys >= fsmap->fmr_physical + len)
-			return true;
+			return 0;
 		else if (counts->next_phys > fsmap->fmr_physical)
 			len = counts->next_phys - fsmap->fmr_physical;
 		counts->dbytes += len;
 		counts->next_phys = fsmap->fmr_physical + fsmap->fmr_length;
 	}
 
-	return true;
+	return 0;
 }
 
 /* Add all the summaries in the per-thread counter */
@@ -144,9 +143,11 @@ xfs_scan_summary(
 	}
 
 	/* Use fsmap to count blocks. */
-	moveon = xfs_scan_all_spacemaps(ctx, xfs_record_block_summary, ptvar);
-	if (!moveon)
+	error = scrub_scan_all_spacemaps(ctx, count_block_summary, ptvar);
+	if (error) {
+		moveon = false;
 		goto out_free;
+	}
 	error = ptvar_foreach(ptvar, xfs_add_summaries, &totalcount);
 	if (error) {
 		str_liberror(ctx, error, _("counting blocks"));
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 91e8badb..e56f090d 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -31,26 +31,25 @@
 
 #define FSMAP_NR	65536
 
-/* Iterate all the fs block mappings between the two keys. */
-bool
-xfs_iterate_fsmap(
+/*
+ * Iterate all the fs block mappings between the two keys.  Returns 0 or a
+ * positive error number.
+ */
+int
+scrub_iterate_fsmap(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
 	struct fsmap		*keys,
-	xfs_fsmap_iter_fn	fn,
+	scrub_fsmap_iter_fn	fn,
 	void			*arg)
 {
 	struct fsmap_head	*head;
 	struct fsmap		*p;
-	bool			moveon = true;
 	int			i;
 	int			error;
 
 	head = malloc(fsmap_sizeof(FSMAP_NR));
-	if (!head) {
-		str_errno(ctx, descr);
-		return false;
-	}
+	if (!head)
+		return errno;
 
 	memset(head, 0, sizeof(*head));
 	memcpy(head->fmh_keys, keys, sizeof(struct fsmap) * 2);
@@ -60,13 +59,11 @@ xfs_iterate_fsmap(
 		for (i = 0, p = head->fmh_recs;
 		     i < head->fmh_entries;
 		     i++, p++) {
-			moveon = fn(ctx, descr, p, arg);
-			if (!moveon)
+			error = fn(ctx, p, arg);
+			if (error)
 				goto out;
-			if (xfs_scrub_excessive_errors(ctx)) {
-				moveon = false;
+			if (xfs_scrub_excessive_errors(ctx))
 				goto out;
-			}
 		}
 
 		if (head->fmh_entries == 0)
@@ -76,45 +73,36 @@ xfs_iterate_fsmap(
 			break;
 		fsmap_advance(head);
 	}
-
-	if (error) {
-		str_errno(ctx, descr);
-		moveon = false;
-	}
+	if (error)
+		error = errno;
 out:
 	free(head);
-	return moveon;
+	return error;
 }
 
 /* GETFSMAP wrappers routines. */
-struct xfs_scan_blocks {
-	xfs_fsmap_iter_fn	fn;
+struct scan_blocks {
+	scrub_fsmap_iter_fn	fn;
 	void			*arg;
-	bool			moveon;
+	bool			aborted;
 };
 
 /* Iterate all the reverse mappings of an AG. */
 static void
-xfs_scan_ag_blocks(
+scan_ag_rmaps(
 	struct workqueue	*wq,
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	struct xfs_scan_blocks	*sbx = arg;
-	char			descr[DESCR_BUFSZ];
+	struct scan_blocks	*sbx = arg;
 	struct fsmap		keys[2];
 	off64_t			bperag;
-	bool			moveon;
+	int			ret;
 
 	bperag = (off64_t)ctx->mnt.fsgeom.agblocks *
 		 (off64_t)ctx->mnt.fsgeom.blocksize;
 
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u fsmap"),
-				major(ctx->fsinfo.fs_datadev),
-				minor(ctx->fsinfo.fs_datadev),
-				agno);
-
 	memset(keys, 0, sizeof(struct fsmap) * 2);
 	keys->fmr_device = ctx->fsinfo.fs_datadev;
 	keys->fmr_physical = agno * bperag;
@@ -124,25 +112,32 @@ xfs_scan_ag_blocks(
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
 
-	moveon = xfs_iterate_fsmap(ctx, descr, keys, sbx->fn, sbx->arg);
-	if (!moveon)
-		sbx->moveon = false;
+	if (sbx->aborted)
+		return;
+
+	ret = scrub_iterate_fsmap(ctx, keys, sbx->fn, sbx->arg);
+	if (ret) {
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u fsmap"),
+					major(ctx->fsinfo.fs_datadev),
+					minor(ctx->fsinfo.fs_datadev),
+					agno);
+		str_liberror(ctx, ret, descr);
+		sbx->aborted = true;
+	}
 }
 
 /* Iterate all the reverse mappings of a standalone device. */
 static void
-xfs_scan_dev_blocks(
+scan_dev_rmaps(
 	struct scrub_ctx	*ctx,
 	int			idx,
 	dev_t			dev,
-	struct xfs_scan_blocks	*sbx)
+	struct scan_blocks	*sbx)
 {
 	struct fsmap		keys[2];
-	char			descr[DESCR_BUFSZ];
-	bool			moveon;
-
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d fsmap"),
-			major(dev), minor(dev));
+	int			ret;
 
 	memset(keys, 0, sizeof(struct fsmap) * 2);
 	keys->fmr_device = dev;
@@ -152,79 +147,90 @@ xfs_scan_dev_blocks(
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
 
-	moveon = xfs_iterate_fsmap(ctx, descr, keys, sbx->fn, sbx->arg);
-	if (!moveon)
-		sbx->moveon = false;
+	if (sbx->aborted)
+		return;
+
+	ret = scrub_iterate_fsmap(ctx, keys, sbx->fn, sbx->arg);
+	if (ret) {
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, DESCR_BUFSZ, _("dev %d:%d fsmap"),
+				major(dev), minor(dev));
+		str_liberror(ctx, ret, descr);
+		sbx->aborted = true;
+	}
 }
 
 /* Iterate all the reverse mappings of the realtime device. */
 static void
-xfs_scan_rt_blocks(
+scan_rt_rmaps(
 	struct workqueue	*wq,
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	xfs_scan_dev_blocks(ctx, agno, ctx->fsinfo.fs_rtdev, arg);
+	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_rtdev, arg);
 }
 
 /* Iterate all the reverse mappings of the log device. */
 static void
-xfs_scan_log_blocks(
+scan_log_rmaps(
 	struct workqueue	*wq,
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	xfs_scan_dev_blocks(ctx, agno, ctx->fsinfo.fs_logdev, arg);
+	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_logdev, arg);
 }
 
-/* Scan all the blocks in a filesystem. */
-bool
-xfs_scan_all_spacemaps(
+/*
+ * Scan all the blocks in a filesystem.  If errors occur, this function will
+ * log them and return nonzero.
+ */
+int
+scrub_scan_all_spacemaps(
 	struct scrub_ctx	*ctx,
-	xfs_fsmap_iter_fn	fn,
+	scrub_fsmap_iter_fn	fn,
 	void			*arg)
 {
 	struct workqueue	wq;
-	struct xfs_scan_blocks	sbx;
+	struct scan_blocks	sbx = {
+		.fn		= fn,
+		.arg		= arg,
+	};
 	xfs_agnumber_t		agno;
 	int			ret;
 
-	sbx.moveon = true;
-	sbx.fn = fn;
-	sbx.arg = arg;
-
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating fsmap workqueue"));
-		return false;
+		return ret;
 	}
 	if (ctx->fsinfo.fs_rt) {
-		ret = workqueue_add(&wq, xfs_scan_rt_blocks,
+		ret = workqueue_add(&wq, scan_rt_rmaps,
 				ctx->mnt.fsgeom.agcount + 1, &sbx);
 		if (ret) {
-			sbx.moveon = false;
+			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing rtdev fsmap work"));
 			goto out;
 		}
 	}
 	if (ctx->fsinfo.fs_log) {
-		ret = workqueue_add(&wq, xfs_scan_log_blocks,
+		ret = workqueue_add(&wq, scan_log_rmaps,
 				ctx->mnt.fsgeom.agcount + 2, &sbx);
 		if (ret) {
-			sbx.moveon = false;
+			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing logdev fsmap work"));
 			goto out;
 		}
 	}
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, xfs_scan_ag_blocks, agno, &sbx);
+		ret = workqueue_add(&wq, scan_ag_rmaps, agno, &sbx);
 		if (ret) {
-			sbx.moveon = false;
+			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing per-AG fsmap work"));
 			break;
 		}
@@ -232,10 +238,13 @@ xfs_scan_all_spacemaps(
 out:
 	ret = workqueue_terminate(&wq);
 	if (ret) {
-		sbx.moveon = false;
+		sbx.aborted = true;
 		str_liberror(ctx, ret, _("finishing fsmap work"));
 	}
 	workqueue_destroy(&wq);
 
-	return sbx.moveon;
+	if (!ret && sbx.aborted)
+		ret = -1;
+
+	return ret;
 }
diff --git a/scrub/spacemap.h b/scrub/spacemap.h
index c29c43a5..8a6d1e36 100644
--- a/scrub/spacemap.h
+++ b/scrub/spacemap.h
@@ -7,15 +7,15 @@
 #define XFS_SCRUB_SPACEMAP_H_
 
 /*
- * Visit each space mapping in the filesystem.  Return true to continue
- * iteration or false to stop iterating and return to the caller.
+ * Visit each space mapping in the filesystem.  Return 0 to continue iteration
+ * or a positive error code to stop iterating and return to the caller.
  */
-typedef bool (*xfs_fsmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
+typedef int (*scrub_fsmap_iter_fn)(struct scrub_ctx *ctx,
 		struct fsmap *fsr, void *arg);
 
-bool xfs_iterate_fsmap(struct scrub_ctx *ctx, const char *descr,
-		struct fsmap *keys, xfs_fsmap_iter_fn fn, void *arg);
-bool xfs_scan_all_spacemaps(struct scrub_ctx *ctx, xfs_fsmap_iter_fn fn,
+int scrub_iterate_fsmap(struct scrub_ctx *ctx, struct fsmap *keys,
+		scrub_fsmap_iter_fn fn, void *arg);
+int scrub_scan_all_spacemaps(struct scrub_ctx *ctx, scrub_fsmap_iter_fn fn,
 		void *arg);
 
 #endif /* XFS_SCRUB_SPACEMAP_H_ */
