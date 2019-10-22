Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F71CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878F7218AE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l9GHHcjH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfJVStj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:49:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52314 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732322AbfJVStj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:49:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiVfH091157;
        Tue, 22 Oct 2019 18:49:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SRobo3OzZL9LiSaBqeEdxL3/VEJbZB6PNQjFvr9IVgU=;
 b=l9GHHcjHyjPp72OMBELjIJq97VjQNes1SqhoTW3olE1VB4o2b3bOmYLxDbp0/4yRGfox
 QHdF5LKMEISZnNFsqy4mOVRwHzlSi4db9UWZrcrBNYwtpgDWrLPkVsNI9sFeE7AMrEdH
 Lig20jcvb4p04CkFckZ3R44ocSWr9HXyQeAEubr/58BXvfggo7jMPLcaZCJzCHVnSbh3
 kcCYn7euo/DxL05tTua5ScIPzyoarggInERyhWxOGStXWdH2VQM6p6RPTB0yju/QjPnF
 6D3FCJnX8NccXvJaddlwd1PV0DwSjcXfa3dd1I6K9Z8p274OrgZy0SBWXt+4SDvSu7up Vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqteprrcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiMAt070462;
        Tue, 22 Oct 2019 18:49:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vsx2rkkng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:36 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MInZQN026912;
        Tue, 22 Oct 2019 18:49:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 18:49:35 +0000
Subject: [PATCH 7/7] xfs_scrub: create a new category for unfixable errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:49:34 -0700
Message-ID: <157177017442.1460394.7425325906254151917.stgit@magnolia>
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

There's nothing that xfs_scrub (or XFS) can do about media errors for
data file blocks -- the data are gone.  Create a new category for these
unfixable errors so that we don't advise the user to take further action
that won't fix the problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c    |    8 +++++++-
 scrub/common.h    |    3 +++
 scrub/phase4.c    |    5 ++++-
 scrub/phase5.c    |    2 +-
 scrub/phase6.c    |    2 +-
 scrub/xfs_scrub.c |   17 +++++++++++++----
 scrub/xfs_scrub.h |    1 +
 7 files changed, 30 insertions(+), 8 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index 261c6bb2..e72ae540 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -43,7 +43,7 @@ xfs_scrub_excessive_errors(
 		return false;
 
 	pthread_mutex_lock(&ctx->lock);
-	errors_seen = ctx->corruptions_found;
+	errors_seen = ctx->corruptions_found + ctx->unfixable_errors;
 	pthread_mutex_unlock(&ctx->lock);
 
 	return errors_seen >= ctx->max_errors;
@@ -61,6 +61,10 @@ static struct {
 		.string = "Corruption",
 		.loglevel = LOG_ERR,
 	},
+	[S_UNFIXABLE] = {
+		.string = "Unfixable Error",
+		.loglevel = LOG_ERR,
+	},
 	[S_WARN]   = {
 		.string = "Warning",
 		.loglevel = LOG_WARNING,
@@ -136,6 +140,8 @@ __str_out(
 		ctx->runtime_errors++;
 	else if (level == S_CORRUPT)
 		ctx->corruptions_found++;
+	else if (level == S_UNFIXABLE)
+		ctx->unfixable_errors++;
 	else if (level == S_WARN)
 		ctx->warnings_found++;
 	else if (level == S_REPAIR)
diff --git a/scrub/common.h b/scrub/common.h
index b1f2ea2c..cfd9f186 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -18,6 +18,7 @@ bool xfs_scrub_excessive_errors(struct scrub_ctx *ctx);
 enum error_level {
 	S_ERROR	= 0,
 	S_CORRUPT,
+	S_UNFIXABLE,
 	S_WARN,
 	S_INFO,
 	S_REPAIR,
@@ -43,6 +44,8 @@ void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
 	__str_out(ctx, str, S_REPAIR,	0,	__FILE__, __LINE__, __VA_ARGS__)
 #define record_preen(ctx, str, ...) \
 	__str_out(ctx, str, S_PREEN,	0,	__FILE__, __LINE__, __VA_ARGS__)
+#define str_unfixable_error(ctx, str, ...) \
+	__str_out(ctx, str, S_UNFIXABLE, 0,	__FILE__, __LINE__, __VA_ARGS__)
 
 #define dbg_printf(fmt, ...) \
 	do {if (debug > 1) {printf(fmt, __VA_ARGS__);}} while (0)
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 1cf3f6b7..a276bc32 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -99,7 +99,10 @@ xfs_process_action_items(
 	workqueue_destroy(&wq);
 
 	pthread_mutex_lock(&ctx->lock);
-	if (moveon && ctx->corruptions_found == 0 && want_fstrim) {
+	if (moveon &&
+	    ctx->corruptions_found == 0 &&
+	    ctx->unfixable_errors == 0 &&
+	    want_fstrim) {
 		fstrim(ctx);
 		progress_add(1);
 	}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index dc0ee5e8..e0c4a3df 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -336,7 +336,7 @@ xfs_scan_connections(
 	bool			moveon = true;
 	bool			ret;
 
-	if (ctx->corruptions_found) {
+	if (ctx->corruptions_found || ctx->unfixable_errors) {
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem has errors, skipping connectivity checks."));
 		return true;
diff --git a/scrub/phase6.c b/scrub/phase6.c
index bb159641..aae6b7d8 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -161,7 +161,7 @@ report_badfile(
 	bad_length = min(start + length,
 			 br->bmap->bm_physical + br->bmap->bm_length) - start;
 
-	str_error(br->ctx, br->descr,
+	str_unfixable_error(br->ctx, br->descr,
 _("media error at data offset %llu length %llu."),
 			br->bmap->bm_offset + bad_offset, bad_length);
 	return 0;
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 222daae1..963d0d70 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -511,15 +511,24 @@ static void
 report_outcome(
 	struct scrub_ctx	*ctx)
 {
-	unsigned long long	total_errors;
+	unsigned long long	actionable_errors;
 
-	total_errors = ctx->corruptions_found + ctx->runtime_errors;
+	actionable_errors = ctx->corruptions_found + ctx->runtime_errors;
 
-	if (total_errors == 0 && ctx->warnings_found == 0) {
+	if (actionable_errors == 0 &&
+	    ctx->unfixable_errors == 0 &&
+	    ctx->warnings_found == 0) {
 		log_info(ctx, _("No problems found."));
 		return;
 	}
 
+	if (ctx->unfixable_errors) {
+		fprintf(stderr, _("%s: unfixable errors found: %llu\n"),
+				ctx->mntpoint, ctx->unfixable_errors);
+		log_err(ctx, _("unfixable errors found: %llu"),
+				ctx->unfixable_errors);
+	}
+
 	if (ctx->corruptions_found > 0) {
 		fprintf(stderr, _("%s: corruptions found: %llu\n"),
 				ctx->mntpoint, ctx->corruptions_found);
@@ -545,7 +554,7 @@ report_outcome(
 	 * setting up the scrub and we actually saw corruptions.  Warnings
 	 * are not corruptions.
 	 */
-	if (ctx->scrub_setup_succeeded && total_errors > 0) {
+	if (ctx->scrub_setup_succeeded && actionable_errors > 0) {
 		char		*msg;
 
 		if (ctx->mode == SCRUB_MODE_DRY_RUN)
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 5abc41fd..61831c92 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -74,6 +74,7 @@ struct scrub_ctx {
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	corruptions_found;
+	unsigned long long	unfixable_errors;
 	unsigned long long	warnings_found;
 	unsigned long long	inodes_checked;
 	unsigned long long	bytes_checked;

