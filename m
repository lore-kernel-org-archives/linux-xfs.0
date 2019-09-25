Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FD0C4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC67321D81
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RFgkqtgl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfIYVfU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:35:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbfIYVfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:35:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYVN9010209;
        Wed, 25 Sep 2019 21:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=PseadaLSKThl+8+EgSmYMkxbXL2zMSjWi2BxBTfnWa8=;
 b=RFgkqtglUjlkEsP/c2mplmhBIvF5do5jFai/3kGE9qeB4rU30u/iZHEHLSs9GYiNTgjS
 LiVOH57GBG3D6PKdS8o+FhxVMrqdgY1/5W+zvYF234Ufv/+zHZ0dz08Y2iUuNjzhYlIA
 OjjnnEBZT9IJnP5AZd7i/bFfxmrFOSGf90Vb3eR9nnaz8aXHhvkF6zyXli7Jsv//8h0b
 eycv6fe8PulgLenKFhtBPLubQWGujVuR4gOmQ3MrEKIhQocwN8bh+25dXWqPkPrGfaGU
 Ag4XbsbRM6qdjkKx2JOPcPPsPgVXtIYAkD5IGVMkD1pzIFxCQe46mENIfb2HLzOG+6Qe lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btq7ht1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYQT4023789;
        Wed, 25 Sep 2019 21:35:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuq06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:17 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLZHRX020415;
        Wed, 25 Sep 2019 21:35:17 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:35:15 -0700
Subject: [PATCH 03/11] xfs_scrub: fix read-verify pool error communication
 problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:35:06 -0700
Message-ID: <156944730671.298887.2973023413045363254.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix all the places in the read-verify pool functions either we fail to
check for runtime errors or fail to communicate them properly to
callers.  Then fix all the callers to report the error messages instead
of hiding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c      |   89 ++++++++++++++++++++++++++++++++++++---------------
 scrub/read_verify.c |   87 ++++++++++++++++++++++----------------------------
 scrub/read_verify.h |   16 +++++----
 3 files changed, 109 insertions(+), 83 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 4c81ee7b..f6274a49 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -387,6 +387,7 @@ xfs_check_rmap(
 {
 	struct media_verify_state	*vs = arg;
 	struct read_verify_pool		*rvp;
+	int				ret;
 
 	rvp = xfs_dev_to_pool(ctx, vs, map->fmr_device);
 
@@ -415,28 +416,48 @@ xfs_check_rmap(
 	/* XXX: Filter out directory data blocks. */
 
 	/* Schedule the read verify command for (eventual) running. */
-	read_verify_schedule_io(rvp, map->fmr_physical, map->fmr_length, vs);
+	ret = read_verify_schedule_io(rvp, map->fmr_physical, map->fmr_length,
+			vs);
+	if (ret) {
+		str_liberror(ctx, ret, descr);
+		return false;
+	}
 
 out:
 	/* Is this the last extent?  Fire off the read. */
-	if (map->fmr_flags & FMR_OF_LAST)
-		read_verify_force_io(rvp);
+	if (map->fmr_flags & FMR_OF_LAST) {
+		ret = read_verify_force_io(rvp);
+		if (ret) {
+			str_liberror(ctx, ret, descr);
+			return false;
+		}
+	}
 
 	return true;
 }
 
 /* Wait for read/verify actions to finish, then return # bytes checked. */
-static uint64_t
+static int
 clean_pool(
-	struct read_verify_pool	*rvp)
+	struct read_verify_pool	*rvp,
+	unsigned long long	*bytes_checked)
 {
-	uint64_t		ret;
+	uint64_t		pool_checked;
+	int			ret;
 
 	if (!rvp)
 		return 0;
 
-	read_verify_pool_flush(rvp);
-	ret = read_verify_bytes(rvp);
+	ret = read_verify_pool_flush(rvp);
+	if (ret)
+		goto out_destroy;
+
+	ret = read_verify_bytes(rvp, &pool_checked);
+	if (ret)
+		goto out_destroy;
+
+	*bytes_checked += pool_checked;
+out_destroy:
 	read_verify_pool_destroy(rvp);
 	return ret;
 }
@@ -469,43 +490,57 @@ xfs_scan_blocks(
 		goto out_dbad;
 	}
 
-	vs.rvp_data = read_verify_pool_init(ctx, ctx->datadev,
+	ret = read_verify_pool_alloc(ctx, ctx->datadev,
 			ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
-			scrub_nproc(ctx));
-	if (!vs.rvp_data) {
-		str_info(ctx, ctx->mntpoint,
-_("Could not create data device media verifier."));
+			scrub_nproc(ctx), &vs.rvp_data);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating datadev media verifier"));
 		goto out_rbad;
 	}
 	if (ctx->logdev) {
-		vs.rvp_log = read_verify_pool_init(ctx, ctx->logdev,
+		ret = read_verify_pool_alloc(ctx, ctx->logdev,
 				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
-				scrub_nproc(ctx));
-		if (!vs.rvp_log) {
-			str_info(ctx, ctx->mntpoint,
-	_("Could not create log device media verifier."));
+				scrub_nproc(ctx), &vs.rvp_log);
+		if (ret) {
+			str_liberror(ctx, ret,
+					_("creating logdev media verifier"));
 			goto out_datapool;
 		}
 	}
 	if (ctx->rtdev) {
-		vs.rvp_realtime = read_verify_pool_init(ctx, ctx->rtdev,
+		ret = read_verify_pool_alloc(ctx, ctx->rtdev,
 				ctx->mnt.fsgeom.blocksize, xfs_check_rmap_ioerr,
-				scrub_nproc(ctx));
-		if (!vs.rvp_realtime) {
-			str_info(ctx, ctx->mntpoint,
-	_("Could not create realtime device media verifier."));
+				scrub_nproc(ctx), &vs.rvp_realtime);
+		if (ret) {
+			str_liberror(ctx, ret,
+					_("creating rtdev media verifier"));
 			goto out_logpool;
 		}
 	}
 	moveon = xfs_scan_all_spacemaps(ctx, xfs_check_rmap, &vs);
 	if (!moveon)
 		goto out_rtpool;
-	ctx->bytes_checked += clean_pool(vs.rvp_data);
-	ctx->bytes_checked += clean_pool(vs.rvp_log);
-	ctx->bytes_checked += clean_pool(vs.rvp_realtime);
+
+	ret = clean_pool(vs.rvp_data, &ctx->bytes_checked);
+	if (ret) {
+		str_liberror(ctx, ret, _("flushing datadev verify pool"));
+		moveon = false;
+	}
+
+	ret = clean_pool(vs.rvp_log, &ctx->bytes_checked);
+	if (ret) {
+		str_liberror(ctx, ret, _("flushing logdev verify pool"));
+		moveon = false;
+	}
+
+	ret = clean_pool(vs.rvp_realtime, &ctx->bytes_checked);
+	if (ret) {
+		str_liberror(ctx, ret, _("flushing rtdev verify pool"));
+		moveon = false;
+	}
 
 	/* Scan the whole dir tree to see what matches the bad extents. */
-	if (!bitmap_empty(vs.d_bad) || !bitmap_empty(vs.r_bad))
+	if (moveon && (!bitmap_empty(vs.d_bad) || !bitmap_empty(vs.r_bad)))
 		moveon = xfs_report_verify_errors(ctx, &vs);
 
 	bitmap_free(&vs.r_bad);
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 301e9b48..8f80dcaf 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -65,37 +65,37 @@ struct read_verify_pool {
  * @submitter_threads is the number of threads that may be sending verify
  * requests at any given time.
  */
-struct read_verify_pool *
-read_verify_pool_init(
+int
+read_verify_pool_alloc(
 	struct scrub_ctx		*ctx,
 	struct disk			*disk,
 	size_t				miniosz,
 	read_verify_ioerr_fn_t		ioerr_fn,
-	unsigned int			submitter_threads)
+	unsigned int			submitter_threads,
+	struct read_verify_pool		**prvp)
 {
 	struct read_verify_pool		*rvp;
-	bool				ret;
-	int				error;
+	int				ret;
 
 	rvp = calloc(1, sizeof(struct read_verify_pool));
 	if (!rvp)
-		return NULL;
+		return errno;
 
-	error = posix_memalign((void **)&rvp->readbuf, page_size,
+	ret = posix_memalign((void **)&rvp->readbuf, page_size,
 			RVP_IO_MAX_SIZE);
-	if (error || !rvp->readbuf)
+	if (ret)
 		goto out_free;
-	error = ptcounter_alloc(nproc, &rvp->verified_bytes);
-	if (error)
+	ret = ptcounter_alloc(nproc, &rvp->verified_bytes);
+	if (ret)
 		goto out_buf;
 	rvp->miniosz = miniosz;
 	rvp->ctx = ctx;
 	rvp->disk = disk;
 	rvp->ioerr_fn = ioerr_fn;
-	rvp->errors_seen = false;
-	error = ptvar_alloc(submitter_threads, sizeof(struct read_verify),
+	rvp->errors_seen = 0;
+	ret = ptvar_alloc(submitter_threads, sizeof(struct read_verify),
 			&rvp->rvstate);
-	if (error)
+	if (ret)
 		goto out_counter;
 	/* Run in the main thread if we only want one thread. */
 	if (nproc == 1)
@@ -104,7 +104,8 @@ read_verify_pool_init(
 			disk_heads(disk));
 	if (ret)
 		goto out_rvstate;
-	return rvp;
+	*prvp = rvp;
+	return 0;
 
 out_rvstate:
 	ptvar_free(rvp->rvstate);
@@ -114,7 +115,7 @@ read_verify_pool_init(
 	free(rvp->readbuf);
 out_free:
 	free(rvp);
-	return NULL;
+	return ret;
 }
 
 /* Abort all verification work. */
@@ -128,11 +129,11 @@ read_verify_pool_abort(
 }
 
 /* Finish up any read verification work. */
-void
+int
 read_verify_pool_flush(
 	struct read_verify_pool		*rvp)
 {
-	workqueue_terminate(&rvp->wq);
+	return workqueue_terminate(&rvp->wq);
 }
 
 /* Finish up any read verification work and tear it down. */
@@ -187,15 +188,12 @@ read_verify(
 
 	free(rv);
 	ret = ptcounter_add(rvp->verified_bytes, verified);
-	if (ret) {
-		str_liberror(rvp->ctx, ret,
-				_("updating bytes verified counter"));
-		rvp->errors_seen = true;
-	}
+	if (ret)
+		rvp->errors_seen = ret;
 }
 
 /* Queue a read verify request. */
-static bool
+static int
 read_verify_queue(
 	struct read_verify_pool		*rvp,
 	struct read_verify		*rv)
@@ -208,34 +206,33 @@ read_verify_queue(
 
 	/* Worker thread saw a runtime error, don't queue more. */
 	if (rvp->errors_seen)
-		return false;
+		return rvp->errors_seen;
 
 	/* Otherwise clone the request and queue the copy. */
 	tmp = malloc(sizeof(struct read_verify));
 	if (!tmp) {
-		str_errno(rvp->ctx, _("allocating read-verify request"));
-		rvp->errors_seen = true;
-		return false;
+		rvp->errors_seen = errno;
+		return errno;
 	}
 
 	memcpy(tmp, rv, sizeof(*tmp));
 
 	ret = workqueue_add(&rvp->wq, read_verify, 0, tmp);
 	if (ret) {
-		str_liberror(rvp->ctx, ret, _("queueing read-verify work"));
 		free(tmp);
-		rvp->errors_seen = true;
-		return false;
+		rvp->errors_seen = ret;
+		return ret;
 	}
+
 	rv->io_length = 0;
-	return true;
+	return 0;
 }
 
 /*
  * Issue an IO request.  We'll batch subsequent requests if they're
  * within 64k of each other
  */
-bool
+int
 read_verify_schedule_io(
 	struct read_verify_pool		*rvp,
 	uint64_t			start,
@@ -250,7 +247,7 @@ read_verify_schedule_io(
 	assert(rvp->readbuf);
 	rv = ptvar_get(rvp->rvstate, &ret);
 	if (ret)
-		return false;
+		return ret;
 	req_end = start + length;
 	rv_end = rv->io_start + rv->io_length;
 
@@ -277,38 +274,32 @@ read_verify_schedule_io(
 		rv->io_end_arg = end_arg;
 	}
 
-	return true;
+	return 0;
 }
 
 /* Force any stashed IOs into the verifier. */
-bool
+int
 read_verify_force_io(
 	struct read_verify_pool		*rvp)
 {
 	struct read_verify		*rv;
-	bool				moveon;
 	int				ret;
 
 	assert(rvp->readbuf);
 	rv = ptvar_get(rvp->rvstate, &ret);
 	if (ret)
-		return false;
+		return ret;
 	if (rv->io_length == 0)
-		return true;
+		return 0;
 
-	moveon = read_verify_queue(rvp, rv);
-	if (moveon)
-		rv->io_length = 0;
-	return moveon;
+	return read_verify_queue(rvp, rv);
 }
 
 /* How many bytes has this process verified? */
-uint64_t
+int
 read_verify_bytes(
-	struct read_verify_pool		*rvp)
+	struct read_verify_pool		*rvp,
+	uint64_t			*bytes_checked)
 {
-	uint64_t			ret;
-
-	ptcounter_value(rvp->verified_bytes, &ret);
-	return ret;
+	return ptcounter_value(rvp->verified_bytes, bytes_checked);
 }
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index f0ed8902..650c46d4 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -15,17 +15,17 @@ typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
 		struct disk *disk, uint64_t start, uint64_t length,
 		int error, void *arg);
 
-struct read_verify_pool *read_verify_pool_init(struct scrub_ctx *ctx,
-		struct disk *disk, size_t miniosz,
-		read_verify_ioerr_fn_t ioerr_fn,
-		unsigned int submitter_threads);
+int read_verify_pool_alloc(struct scrub_ctx *ctx, struct disk *disk,
+		size_t miniosz, read_verify_ioerr_fn_t ioerr_fn,
+		unsigned int submitter_threads,
+		struct read_verify_pool **prvp);
 void read_verify_pool_abort(struct read_verify_pool *rvp);
-void read_verify_pool_flush(struct read_verify_pool *rvp);
+int read_verify_pool_flush(struct read_verify_pool *rvp);
 void read_verify_pool_destroy(struct read_verify_pool *rvp);
 
-bool read_verify_schedule_io(struct read_verify_pool *rvp, uint64_t start,
+int read_verify_schedule_io(struct read_verify_pool *rvp, uint64_t start,
 		uint64_t length, void *end_arg);
-bool read_verify_force_io(struct read_verify_pool *rvp);
-uint64_t read_verify_bytes(struct read_verify_pool *rvp);
+int read_verify_force_io(struct read_verify_pool *rvp);
+int read_verify_bytes(struct read_verify_pool *rvp, uint64_t *bytes);
 
 #endif /* XFS_SCRUB_READ_VERIFY_H_ */

