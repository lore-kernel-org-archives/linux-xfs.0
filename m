Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC6DCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E9720B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o8JVB5bn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbfJVStV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:49:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730186AbfJVStV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:49:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiBOE089151;
        Tue, 22 Oct 2019 18:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ToUKOdZC5rvGZLOQ0EhckWPTigJbzwJ0PlbaQ7rkIvI=;
 b=o8JVB5bn06ElyeovNrw1UknP9pFKHkO1LPeUF042wKFMWCphmdxN1w7vdFsdI+VSWFz6
 WdIiq5VSAHt/DshoQ8HHIYGbR5EQQHZ55YibYjRPvc9/rz8KubRyDFVJCJnEJzi5Vqil
 /01tZzs9sXOxZ9HdR5FlV0UUREHj9hjtp+eDrwzrXjX00ncrrbIsDje1eQtrxHLz1Pan
 irzAsdi1kI4dZYQ8SOBkquOaYq1vftD9FVckZq9IGbGQgOM9/19sa8uYe3wzJwx+bezy
 X19y+PhR3oOQSpgw2qBYTXnBVNe6xKNgFCLAbOiRSU+zcQUxU/AQVnALzfE0VP8672KN 6A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4qrkbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhOl3125188;
        Tue, 22 Oct 2019 18:49:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vsx239sae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:18 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MInF3d030361;
        Tue, 22 Oct 2019 18:49:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 18:49:15 +0000
Subject: [PATCH 4/7] xfs_scrub: explicitly track corruptions, not just errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:49:14 -0700
Message-ID: <157177015466.1460394.15245131277018622381.stgit@magnolia>
In-Reply-To: <157177012894.1460394.4672572733673534420.stgit@magnolia>
References: <157177012894.1460394.4672572733673534420.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename the @errors_found variable to @corruptions_found to make it
more explicit that we're tracking fs corruption issues.  Add a new
str_corrupt() function to handle communications that fall under this new
corruption classification.  str_error() now exists to log runtime errors
that do not have an associated errno code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c    |   12 ++++++++----
 scrub/common.h    |    3 +++
 scrub/phase4.c    |    2 +-
 scrub/phase5.c    |    2 +-
 scrub/phase6.c    |    6 +++---
 scrub/scrub.c     |    6 +++---
 scrub/xfs_scrub.c |   20 ++++++++++++++------
 scrub/xfs_scrub.h |    2 +-
 8 files changed, 34 insertions(+), 19 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index 90fbad64..b1c6abd1 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -36,7 +36,7 @@ xfs_scrub_excessive_errors(
 	bool			ret;
 
 	pthread_mutex_lock(&ctx->lock);
-	ret = ctx->max_errors > 0 && ctx->errors_found >= ctx->max_errors;
+	ret = ctx->max_errors > 0 && ctx->corruptions_found >= ctx->max_errors;
 	pthread_mutex_unlock(&ctx->lock);
 
 	return ret;
@@ -50,6 +50,10 @@ static struct {
 		.string = "Error",
 		.loglevel = LOG_ERR,
 	},
+	[S_CORRUPT] = {
+		.string = "Corruption",
+		.loglevel = LOG_ERR,
+	},
 	[S_WARN]   = {
 		.string = "Warning",
 		.loglevel = LOG_WARNING,
@@ -121,10 +125,10 @@ __str_out(
 		fflush(stream);
 
 out_record:
-	if (error)      /* A syscall failed */
+	if (error || level == S_ERROR)      /* A syscall failed */
 		ctx->runtime_errors++;
-	else if (level == S_ERROR)
-		ctx->errors_found++;
+	else if (level == S_CORRUPT)
+		ctx->corruptions_found++;
 	else if (level == S_WARN)
 		ctx->warnings_found++;
 	else if (level == S_REPAIR)
diff --git a/scrub/common.h b/scrub/common.h
index ef4cf439..b1f2ea2c 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -17,6 +17,7 @@ bool xfs_scrub_excessive_errors(struct scrub_ctx *ctx);
 
 enum error_level {
 	S_ERROR	= 0,
+	S_CORRUPT,
 	S_WARN,
 	S_INFO,
 	S_REPAIR,
@@ -30,6 +31,8 @@ void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
 	__str_out(ctx, str, S_ERROR,	errno,	__FILE__, __LINE__, NULL)
 #define str_liberror(ctx, error, str) \
 	__str_out(ctx, str, S_ERROR,	error,	__FILE__, __LINE__, NULL)
+#define str_corrupt(ctx, str, ...) \
+	__str_out(ctx, str, S_CORRUPT,	0,	__FILE__, __LINE__, __VA_ARGS__)
 #define str_error(ctx, str, ...) \
 	__str_out(ctx, str, S_ERROR,	0,	__FILE__, __LINE__, __VA_ARGS__)
 #define str_warn(ctx, str, ...) \
diff --git a/scrub/phase4.c b/scrub/phase4.c
index eb30c189..1cf3f6b7 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -99,7 +99,7 @@ xfs_process_action_items(
 	workqueue_destroy(&wq);
 
 	pthread_mutex_lock(&ctx->lock);
-	if (moveon && ctx->errors_found == 0 && want_fstrim) {
+	if (moveon && ctx->corruptions_found == 0 && want_fstrim) {
 		fstrim(ctx);
 		progress_add(1);
 	}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 27941907..dc0ee5e8 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -336,7 +336,7 @@ xfs_scan_connections(
 	bool			moveon = true;
 	bool			ret;
 
-	if (ctx->errors_found) {
+	if (ctx->corruptions_found) {
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem has errors, skipping connectivity checks."));
 		return true;
diff --git a/scrub/phase6.c b/scrub/phase6.c
index fccd18e9..bb159641 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -233,7 +233,7 @@ _("found unexpected realtime attr fork extent."));
 	}
 
 	if (bitmap_test(bmp, bmap->bm_physical, bmap->bm_length))
-		str_error(ctx, descr,
+		str_corrupt(ctx, descr,
 _("media error in extended attribute data."));
 
 	return true;
@@ -389,7 +389,7 @@ report_ioerr_fsmap(
 		snprintf(buf, DESCR_BUFSZ, _("disk offset %"PRIu64),
 				(uint64_t)map->fmr_physical + err_off);
 		type = xfs_decode_special_owner(map->fmr_owner);
-		str_error(ctx, buf, _("media error in %s."), type);
+		str_corrupt(ctx, buf, _("media error in %s."), type);
 	}
 
 	/* Report extent maps */
@@ -400,7 +400,7 @@ report_ioerr_fsmap(
 				map->fmr_owner, 0, " %s",
 				attr ? _("extended attribute") :
 				       _("file data"));
-		str_error(ctx, buf, _("media error in extent map"));
+		str_corrupt(ctx, buf, _("media error in extent map"));
 	}
 
 	/*
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 0293ce30..75a64efa 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -188,7 +188,7 @@ _("Kernel bug!  errno=%d"), code);
 	 */
 	if (is_corrupt(meta) || xref_disagrees(meta)) {
 		if (ctx->mode < SCRUB_MODE_REPAIR) {
-			str_error(ctx, buf,
+			str_corrupt(ctx, buf,
 _("Repairs are required."));
 			return CHECK_DONE;
 		}
@@ -727,7 +727,7 @@ _("Filesystem is shut down, aborting."));
 			/* fall through */
 		case EINVAL:
 			/* Kernel doesn't know how to repair this? */
-			str_error(ctx, buf,
+			str_corrupt(ctx, buf,
 _("Don't know how to fix; offline repair required."));
 			return CHECK_DONE;
 		case EROFS:
@@ -768,7 +768,7 @@ _("Read-only filesystem; cannot make changes."));
 		 */
 		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
 			return CHECK_RETRY;
-		str_error(ctx, buf,
+		str_corrupt(ctx, buf,
 _("Repair unsuccessful; offline repair required."));
 	} else {
 		/* Clean operation, no corruption detected. */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index c7305694..222daae1 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -513,17 +513,25 @@ report_outcome(
 {
 	unsigned long long	total_errors;
 
-	total_errors = ctx->errors_found + ctx->runtime_errors;
+	total_errors = ctx->corruptions_found + ctx->runtime_errors;
 
 	if (total_errors == 0 && ctx->warnings_found == 0) {
 		log_info(ctx, _("No problems found."));
 		return;
 	}
 
-	if (total_errors > 0) {
-		fprintf(stderr, _("%s: errors found: %llu\n"), ctx->mntpoint,
-				total_errors);
-		log_err(ctx, _("errors found: %llu"), total_errors);
+	if (ctx->corruptions_found > 0) {
+		fprintf(stderr, _("%s: corruptions found: %llu\n"),
+				ctx->mntpoint, ctx->corruptions_found);
+		log_err(ctx, _("corruptions found: %llu"),
+				ctx->corruptions_found);
+	}
+
+	if (ctx->runtime_errors > 0) {
+		fprintf(stderr, _("%s: operational errors found: %llu\n"),
+				ctx->mntpoint, ctx->runtime_errors);
+		log_err(ctx, _("operational errors found: %llu"),
+				ctx->runtime_errors);
 	}
 
 	if (ctx->warnings_found > 0) {
@@ -745,7 +753,7 @@ main(
 	report_modifications(&ctx);
 	report_outcome(&ctx);
 
-	if (ctx.errors_found) {
+	if (ctx.corruptions_found) {
 		if (ctx.error_action == ERRORS_SHUTDOWN)
 			xfs_shutdown_fs(&ctx);
 		ret |= SCRUB_RET_CORRUPT;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 37d78f61..5abc41fd 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -73,7 +73,7 @@ struct scrub_ctx {
 	struct xfs_action_list	*action_lists;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
-	unsigned long long	errors_found;
+	unsigned long long	corruptions_found;
 	unsigned long long	warnings_found;
 	unsigned long long	inodes_checked;
 	unsigned long long	bytes_checked;

