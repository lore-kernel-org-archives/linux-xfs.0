Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF18C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0613021872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:32:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WDDpHBRl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfHZVcW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:32:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbfHZVcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:32:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDrlJ001023;
        Mon, 26 Aug 2019 21:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zq1+yaKl/PDatoP88GAhJJ03OVlYBl5I5wvVoPv+S5c=;
 b=WDDpHBRlr6VrdgZrdBzBTipe8+EWHy9EwEf3lpsdG+sIW8YypMzbT0ZTMyv9XSH5uN0+
 OSWIm2tte3qf0Ny/Wphu5ZW4G6T8x+I+vp9tbjkuC+Vb74ryZM/rMHs9wksD/0E7BDLM
 rol7ngeqomPjrWWyWxjguRlmv+lz3OJJNass1N7hY6VU7Eg83TqkUgClkVjFgB/8h99U
 roEdyq2rZbe2rfcKobIWPrichMor0YqmTmOYR+p/pIevetgYbs7UMXMNDvCv5ohI44kY
 pZAeL8hldUQOwSUKh5J0wHH96/9jzId/o3Rj4Vzbz98+BsigC3Mdk2VKTrUsncSm1rGn 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2umpxx05rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIRQV024992;
        Mon, 26 Aug 2019 21:32:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2umj1tkane-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:32:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLWIjL030371;
        Mon, 26 Aug 2019 21:32:18 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 21:32:18 +0000
Subject: [PATCH 11/11] xfs_scrub: create a new category for unfixable errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:32:17 -0700
Message-ID: <156685513738.2843133.13097768805699303210.stgit@magnolia>
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

There's nothing that xfs_scrub (or XFS) can do about media errors for
data file blocks -- the data are gone.  Create a new category for these
unfixable errors so that we don't advise the user to take further action
that won't fix the problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c    |    9 ++++++++-
 scrub/common.h    |    3 +++
 scrub/phase4.c    |    3 ++-
 scrub/phase5.c    |    2 +-
 scrub/phase6.c    |    2 +-
 scrub/xfs_scrub.c |   15 +++++++++++++--
 scrub/xfs_scrub.h |    1 +
 7 files changed, 29 insertions(+), 6 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index fdbbf294..1ca550dd 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -36,7 +36,8 @@ xfs_scrub_excessive_errors(
 	bool			ret;
 
 	pthread_mutex_lock(&ctx->lock);
-	ret = ctx->max_errors > 0 && ctx->errors_found >= ctx->max_errors;
+	ret = ctx->max_errors > 0 &&
+	      (ctx->unfixable_errors + ctx->errors_found) >= ctx->max_errors;
 	pthread_mutex_unlock(&ctx->lock);
 
 	return ret;
@@ -47,6 +48,10 @@ static struct {
 	int loglevel;
 } err_levels[] = {
 	[S_ERROR]  = { .string = "Error",	.loglevel = LOG_ERR },
+	[S_UNFIXABLE] = {
+		.string = "Unfixable error",
+		.loglevel = LOG_ERR
+	},
 	[S_WARN]   = { .string = "Warning",	.loglevel = LOG_WARNING },
 	[S_REPAIR] = { .string = "Repaired",	.loglevel = LOG_WARNING },
 	[S_INFO]   = { .string = "Info",	.loglevel = LOG_INFO },
@@ -108,6 +113,8 @@ __str_out(
 out_record:
 	if (error)      /* A syscall failed */
 		ctx->runtime_errors++;
+	else if (level == S_UNFIXABLE)
+		ctx->unfixable_errors++;
 	else if (level == S_ERROR)
 		ctx->errors_found++;
 	else if (level == S_WARN)
diff --git a/scrub/common.h b/scrub/common.h
index b34cb4a6..886e6c2e 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -17,6 +17,7 @@ bool xfs_scrub_excessive_errors(struct scrub_ctx *ctx);
 
 enum error_level {
 	S_ERROR	= 0,
+	S_UNFIXABLE,
 	S_WARN,
 	S_REPAIR,
 	S_INFO,
@@ -40,6 +41,8 @@ void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
 	__str_out(ctx, str, S_REPAIR,	0,	__FILE__, __LINE__, __VA_ARGS__)
 #define record_preen(ctx, str, ...) \
 	__str_out(ctx, str, S_PREEN,	0,	__FILE__, __LINE__, __VA_ARGS__)
+#define str_unfixable_error(ctx, str, ...) \
+	__str_out(ctx, str, S_UNFIXABLE, 0,	__FILE__, __LINE__, __VA_ARGS__)
 
 #define dbg_printf(fmt, ...) \
 	do {if (debug > 1) {printf(fmt, __VA_ARGS__);}} while (0)
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 79c8a6b8..a030b1de 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -99,7 +99,8 @@ xfs_process_action_items(
 	workqueue_destroy(&wq);
 
 	pthread_mutex_lock(&ctx->lock);
-	if (moveon && ctx->errors_found == 0 && want_fstrim) {
+	if (moveon && ctx->errors_found == 0 && ctx->unfixable_errors == 0 &&
+	    want_fstrim) {
 		fstrim(ctx);
 		progress_add(1);
 	}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 224081d5..d90b4028 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -336,7 +336,7 @@ xfs_scan_connections(
 	bool			moveon = true;
 	bool			ret;
 
-	if (ctx->errors_found) {
+	if (ctx->errors_found || ctx->unfixable_errors) {
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem has errors, skipping connectivity checks."));
 		return true;
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 33ed75cc..1e55fad8 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -140,7 +140,7 @@ report_badfile(
 	bad_length = min(start + length,
 			 br->bmap->bm_physical + br->bmap->bm_length) - start;
 
-	str_error(br->ctx, br->descr,
+	str_unfixable_error(br->ctx, br->descr,
 _("media error at data offset %llu length %llu."),
 			br->bmap->bm_offset + bad_offset, bad_length);
 	return 0;
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 99bf54f5..645b2c50 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -515,12 +515,16 @@ report_outcome(
 
 	total_errors = ctx->errors_found + ctx->runtime_errors;
 
-	if (total_errors == 0 && ctx->warnings_found == 0) {
+	if (total_errors == 0 &&
+	    ctx->unfixable_errors == 0 &&
+	    ctx->warnings_found == 0) {
 		log_info(ctx, _("No errors found."));
 		return;
 	}
 
-	if (total_errors == 0) {
+	if (total_errors == 0 && ctx->warnings_found == 0) {
+		/* nothing to report */
+	} else if (total_errors == 0) {
 		fprintf(stderr, _("%s: warnings found: %llu\n"), ctx->mntpoint,
 				ctx->warnings_found);
 		log_warn(ctx, _("warnings found: %llu"), ctx->warnings_found);
@@ -536,6 +540,13 @@ report_outcome(
 				total_errors, ctx->warnings_found);
 	}
 
+	if (ctx->unfixable_errors) {
+		fprintf(stderr, _("%s: unfixable errors found: %llu\n"),
+				ctx->mntpoint, ctx->unfixable_errors);
+		log_err(ctx, _("unfixable errors found: %llu"),
+				ctx->unfixable_errors);
+	}
+
 	/*
 	 * Don't advise the user to run repair unless we were successful in
 	 * setting up the scrub and we actually saw corruptions.  Warnings
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index bce56b1d..6984d24c 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -74,6 +74,7 @@ struct scrub_ctx {
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	errors_found;
+	unsigned long long	unfixable_errors;
 	unsigned long long	warnings_found;
 	unsigned long long	inodes_checked;
 	unsigned long long	bytes_checked;

