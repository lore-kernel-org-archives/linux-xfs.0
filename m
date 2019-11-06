Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3771C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E78121929
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i2opqFQg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfKFVDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 16:03:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58308 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbfKFVDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 16:03:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6KxQwl164426;
        Wed, 6 Nov 2019 21:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VSC/UJ33u0Bo8vuv0dibA4mabr9xcADZ8DTE8C+TIxA=;
 b=i2opqFQg+zPKl/VlvRSf8ruSmSbR5A6j5DPhhTpdmFR8FI9Kbis/CD/1wExTVjruchOk
 82YZ+EwhqpVUl2lD+OsBu20VcDgsmU/mDjYHCUmXDhhrDfiKdTWCKXptqcW+bz9nguKM
 kDf1eqVzHRCr2KM8G8x6V0D81VXC6NpsJH6S/gR0WTeyqLgy5o6viCrOLqmmyYyzfCXv
 AueglP5+qV2QPyp6qUoPu/JwpYr80nWC0JJX07YZm3nRzp4DGz4S0l5EuywphE7hb2ag
 TYCypcHDpStlDpxhKKfkrL1sv0Hir7JyzZmYHrm5ySHj+sLOqehEinMiJyGIY/Jmrp4u Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w41w0spfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:03:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Kw80e191242;
        Wed, 6 Nov 2019 21:03:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w41wd7kj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:03:27 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6L3Qxg025060;
        Wed, 6 Nov 2019 21:03:26 GMT
Received: from localhost (/10.159.234.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 13:03:25 -0800
Date:   Wed, 6 Nov 2019 13:03:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 18/18] xfs_scrub: remove moveon from main program
Message-ID: <20191106210324.GS4153244@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
 <157177034195.1461658.13733200864081311796.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157177034195.1461658.13733200864081311796.stgit@magnolia>
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

Replace the moveon returns in xfs_scrub.c to e with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: rebase without full-disk media scan
---
 scrub/phase1.c    |    7 ----
 scrub/phase2.c    |   17 ---------
 scrub/phase3.c    |   17 ---------
 scrub/phase4.c    |   17 ---------
 scrub/phase5.c    |   15 ++++++--
 scrub/phase6.c    |   17 ---------
 scrub/phase7.c    |    7 ----
 scrub/xfs_scrub.c |   95 +++++++++++++++++++++++++----------------------------
 scrub/xfs_scrub.h |   33 +++++++++---------
 9 files changed, 73 insertions(+), 152 deletions(-)

diff --git a/scrub/phase1.c b/scrub/phase1.c
index 75ae3b00..e0382b04 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -206,10 +206,3 @@ _("Unable to find realtime device path."));
 	ctx->scrub_setup_succeeded = true;
 	return 0;
 }
-
-bool
-xfs_setup_fs(
-	struct scrub_ctx		*ctx)
-{
-	return phase1_func(ctx) == 0;
-}
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 81b2b3dc..45e0d712 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -179,13 +179,6 @@ phase2_func(
 	return ret;
 }
 
-bool
-xfs_scan_metadata(
-	struct scrub_ctx	*ctx)
-{
-	return phase2_func(ctx) == 0;
-}
-
 /* Estimate how much work we're going to do. */
 int
 phase2_estimate(
@@ -199,13 +192,3 @@ phase2_estimate(
 	*rshift = 0;
 	return 0;
 }
-
-bool
-xfs_estimate_metadata_work(
-	struct scrub_ctx	*ctx,
-	uint64_t		*items,
-	unsigned int		*nr_threads,
-	int			*rshift)
-{
-	return phase2_estimate(ctx, items, nr_threads, rshift) == 0;
-}
diff --git a/scrub/phase3.c b/scrub/phase3.c
index eed8f46f..223f1caf 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -194,13 +194,6 @@ phase3_func(
 	return err;
 }
 
-bool
-xfs_scan_inodes(
-	struct scrub_ctx	*ctx)
-{
-	return phase3_func(ctx) == 0;
-}
-
 /* Estimate how much work we're going to do. */
 int
 phase3_estimate(
@@ -214,13 +207,3 @@ phase3_estimate(
 	*rshift = 0;
 	return 0;
 }
-
-bool
-xfs_estimate_inodes_work(
-	struct scrub_ctx	*ctx,
-	uint64_t		*items,
-	unsigned int		*nr_threads,
-	int			*rshift)
-{
-	return phase3_estimate(ctx, items, nr_threads, rshift) == 0;
-}
diff --git a/scrub/phase4.c b/scrub/phase4.c
index f9dcf9c8..1c1de906 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -126,13 +126,6 @@ phase4_func(
 	return repair_everything(ctx);
 }
 
-bool
-xfs_repair_fs(
-	struct scrub_ctx	*ctx)
-{
-	return phase4_func(ctx) == 0;
-}
-
 /* Estimate how much work we're going to do. */
 int
 phase4_estimate(
@@ -152,13 +145,3 @@ phase4_estimate(
 	*rshift = 0;
 	return 0;
 }
-
-bool
-xfs_estimate_repair_work(
-	struct scrub_ctx	*ctx,
-	uint64_t		*items,
-	unsigned int		*nr_threads,
-	int			*rshift)
-{
-	return phase4_estimate(ctx, items, nr_threads, rshift) == 0;
-}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 2641a7fb..540b840d 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -406,9 +406,16 @@ _("Filesystem has errors, skipping connectivity checks."));
 	return 0;
 }
 
-bool
-xfs_scan_connections(
-	struct scrub_ctx	*ctx)
+/* Estimate how much work we're going to do. */
+int
+phase5_estimate(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
 {
-	return phase5_func(ctx) == 0;
+	*items = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
+	*nr_threads = scrub_nproc(ctx);
+	*rshift = 0;
+	return 0;
 }
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 020b303d..88c719b3 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -707,13 +707,6 @@ phase6_func(
 	return ret;
 }
 
-bool
-xfs_scan_blocks(
-	struct scrub_ctx		*ctx)
-{
-	return phase6_func(ctx) == 0;
-}
-
 /* Estimate how much work we're going to do. */
 int
 phase6_estimate(
@@ -743,13 +736,3 @@ phase6_estimate(
 	*rshift = 20;
 	return 0;
 }
-
-bool
-xfs_estimate_verify_work(
-	struct scrub_ctx	*ctx,
-	uint64_t		*items,
-	unsigned int		*nr_threads,
-	int			*rshift)
-{
-	return phase6_estimate(ctx, items, nr_threads, rshift) == 0;
-}
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 68912f03..191f2e4f 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -270,10 +270,3 @@ _("%.1f%s data counted; %.1f%s data verified.\n"),
 	ptvar_free(ptvar);
 	return error;
 }
-
-bool
-xfs_scan_summary(
-	struct scrub_ctx	*ctx)
-{
-	return phase7_func(ctx) == 0;
-}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 5030a7fa..a792768c 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -245,14 +245,14 @@ struct phase_rusage {
 #define REPAIR_DUMMY_FN		((void *)2)
 struct phase_ops {
 	char		*descr;
-	bool		(*fn)(struct scrub_ctx *);
-	bool		(*estimate_work)(struct scrub_ctx *, uint64_t *,
-					 unsigned int *, int *);
+	int		(*fn)(struct scrub_ctx *ctx);
+	int		(*estimate_work)(struct scrub_ctx *ctx, uint64_t *items,
+					 unsigned int *threads, int *rshift);
 	bool		must_run;
 };
 
 /* Start tracking resource usage for a phase. */
-static bool
+static int
 phase_start(
 	struct phase_rusage	*pi,
 	unsigned int		phase,
@@ -264,14 +264,14 @@ phase_start(
 	error = scrub_getrusage(&pi->ruse);
 	if (error) {
 		perror(_("getrusage"));
-		return false;
+		return error;
 	}
 	pi->brk_start = sbrk(0);
 
 	error = gettimeofday(&pi->time, NULL);
 	if (error) {
 		perror(_("gettimeofday"));
-		return false;
+		return error;
 	}
 
 	pi->descr = descr;
@@ -279,11 +279,11 @@ phase_start(
 		fprintf(stdout, _("Phase %u: %s\n"), phase, descr);
 		fflush(stdout);
 	}
-	return true;
+	return error;
 }
 
 /* Report usage stats. */
-static bool
+static int
 phase_end(
 	struct phase_rusage	*pi,
 	unsigned int		phase)
@@ -303,19 +303,19 @@ phase_end(
 	int			error;
 
 	if (!display_rusage)
-		return true;
+		return 0;
 
 	error = gettimeofday(&time_now, NULL);
 	if (error) {
 		perror(_("gettimeofday"));
-		return false;
+		return error;
 	}
 	dt = timeval_subtract(&time_now, &pi->time);
 
 	error = scrub_getrusage(&ruse_now);
 	if (error) {
 		perror(_("getrusage"));
-		return false;
+		return error;
 	}
 
 	if (phase)
@@ -366,7 +366,7 @@ _("%sI/O rate: %.1f%s/s in, %.1f%s/s out, %.1f%s/s tot\n"),
 	}
 	fflush(stdout);
 
-	return true;
+	return 0;
 }
 
 /* Run all the phases of the scrubber. */
@@ -379,37 +379,37 @@ run_scrub_phases(
 	{
 		{
 			.descr = _("Find filesystem geometry."),
-			.fn = xfs_setup_fs,
+			.fn = phase1_func,
 			.must_run = true,
 		},
 		{
 			.descr = _("Check internal metadata."),
-			.fn = xfs_scan_metadata,
-			.estimate_work = xfs_estimate_metadata_work,
+			.fn = phase2_func,
+			.estimate_work = phase2_estimate,
 		},
 		{
 			.descr = _("Scan all inodes."),
-			.fn = xfs_scan_inodes,
-			.estimate_work = xfs_estimate_inodes_work,
+			.fn = phase3_func,
+			.estimate_work = phase3_estimate,
 		},
 		{
 			.descr = _("Defer filesystem repairs."),
 			.fn = REPAIR_DUMMY_FN,
-			.estimate_work = xfs_estimate_repair_work,
+			.estimate_work = phase4_estimate,
 		},
 		{
 			.descr = _("Check directory tree."),
-			.fn = xfs_scan_connections,
-			.estimate_work = xfs_estimate_inodes_work,
+			.fn = phase5_func,
+			.estimate_work = phase5_estimate,
 		},
 		{
 			.descr = _("Verify data file integrity."),
 			.fn = DATASCAN_DUMMY_FN,
-			.estimate_work = xfs_estimate_verify_work,
+			.estimate_work = phase6_estimate,
 		},
 		{
 			.descr = _("Check summary counters."),
-			.fn = xfs_scan_summary,
+			.fn = phase7_func,
 			.must_run = true,
 		},
 		{
@@ -419,7 +419,6 @@ run_scrub_phases(
 	struct phase_rusage	pi;
 	struct phase_ops	*sp;
 	uint64_t		max_work;
-	bool			moveon = true;
 	unsigned int		debug_phase = 0;
 	unsigned int		phase;
 	int			rshift;
@@ -432,11 +431,11 @@ run_scrub_phases(
 	for (phase = 1, sp = phases; sp->fn; sp++, phase++) {
 		/* Turn on certain phases if user said to. */
 		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
-			sp->fn = xfs_scan_blocks;
+			sp->fn = phase6_func;
 		} else if (sp->fn == REPAIR_DUMMY_FN &&
 			   ctx->mode == SCRUB_MODE_REPAIR) {
 			sp->descr = _("Repair filesystem.");
-			sp->fn = xfs_repair_fs;
+			sp->fn = phase4_func;
 			sp->must_run = true;
 		}
 
@@ -450,15 +449,15 @@ run_scrub_phases(
 			continue;
 
 		/* Run this phase. */
-		moveon = phase_start(&pi, phase, sp->descr);
-		if (!moveon)
+		ret = phase_start(&pi, phase, sp->descr);
+		if (ret)
 			break;
 		if (sp->estimate_work) {
 			unsigned int		work_threads;
 
-			moveon = sp->estimate_work(ctx, &max_work,
+			ret = sp->estimate_work(ctx, &max_work,
 					&work_threads, &rshift);
-			if (!moveon)
+			if (ret)
 				break;
 
 			/*
@@ -469,23 +468,19 @@ run_scrub_phases(
 			work_threads++;
 			ret = progress_init_phase(ctx, progress_fp, phase,
 					max_work, rshift, work_threads);
-			if (ret) {
-				moveon = false;
+			if (ret)
 				break;
-			}
-			moveon = descr_init_phase(ctx, work_threads) == 0;
+			ret = descr_init_phase(ctx, work_threads);
 		} else {
 			ret = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
-			if (ret) {
-				moveon = false;
+			if (ret)
 				break;
-			}
-			moveon = descr_init_phase(ctx, 1) == 0;
+			ret = descr_init_phase(ctx, 1);
 		}
-		if (!moveon)
+		if (ret)
 			break;
-		moveon = sp->fn(ctx);
-		if (!moveon) {
+		ret = sp->fn(ctx);
+		if (ret) {
 			str_info(ctx, ctx->mntpoint,
 _("Scrub aborted after phase %d."),
 					phase);
@@ -493,17 +488,18 @@ _("Scrub aborted after phase %d."),
 		}
 		progress_end_phase();
 		descr_end_phase();
-		moveon = phase_end(&pi, phase);
-		if (!moveon)
+		ret = phase_end(&pi, phase);
+		if (ret)
 			break;
 
 		/* Too many errors? */
-		moveon = !xfs_scrub_excessive_errors(ctx);
-		if (!moveon)
+		if (xfs_scrub_excessive_errors(ctx)) {
+			ret = ECANCELED;
 			break;
+		}
 	}
 
-	return moveon;
+	return ret;
 }
 
 static void
@@ -596,7 +592,6 @@ main(
 	char			*mtab = NULL;
 	FILE			*progress_fp = NULL;
 	struct fs_path		*fsp;
-	bool			moveon = true;
 	int			c;
 	int			fd;
 	int			ret = SCRUB_RET_SUCCESS;
@@ -711,8 +706,8 @@ main(
 		is_service = true;
 
 	/* Initialize overall phase stats. */
-	moveon = phase_start(&all_pi, 0, NULL);
-	if (!moveon)
+	error = phase_start(&all_pi, 0, NULL);
+	if (error)
 		return SCRUB_RET_OPERROR;
 
 	/* Find the mount record for the passed-in argument. */
@@ -759,8 +754,8 @@ main(
 		ctx.mode = SCRUB_MODE_REPAIR;
 
 	/* Scrub a filesystem. */
-	moveon = run_scrub_phases(&ctx, progress_fp);
-	if (!moveon && ctx.runtime_errors == 0)
+	error = run_scrub_phases(&ctx, progress_fp);
+	if (error && ctx.runtime_errors == 0)
 		ctx.runtime_errors++;
 
 	/*
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 10683416..f6712d36 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -88,24 +88,25 @@ struct scrub_ctx {
 /* Phase helper functions */
 void xfs_shutdown_fs(struct scrub_ctx *ctx);
 int scrub_cleanup(struct scrub_ctx *ctx);
-bool xfs_setup_fs(struct scrub_ctx *ctx);
-bool xfs_scan_metadata(struct scrub_ctx *ctx);
-bool xfs_scan_inodes(struct scrub_ctx *ctx);
-bool xfs_scan_connections(struct scrub_ctx *ctx);
-bool xfs_scan_blocks(struct scrub_ctx *ctx);
-bool xfs_scan_summary(struct scrub_ctx *ctx);
-bool xfs_repair_fs(struct scrub_ctx *ctx);
+int phase1_func(struct scrub_ctx *ctx);
+int phase2_func(struct scrub_ctx *ctx);
+int phase3_func(struct scrub_ctx *ctx);
+int phase4_func(struct scrub_ctx *ctx);
+int phase5_func(struct scrub_ctx *ctx);
+int phase6_func(struct scrub_ctx *ctx);
+int phase7_func(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
-uint64_t xfs_estimate_inodes(struct scrub_ctx *ctx);
 unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
-bool xfs_estimate_metadata_work(struct scrub_ctx *ctx, uint64_t *items,
-				unsigned int *nr_threads, int *rshift);
-bool xfs_estimate_inodes_work(struct scrub_ctx *ctx, uint64_t *items,
-			      unsigned int *nr_threads, int *rshift);
-bool xfs_estimate_repair_work(struct scrub_ctx *ctx, uint64_t *items,
-			      unsigned int *nr_threads, int *rshift);
-bool xfs_estimate_verify_work(struct scrub_ctx *ctx, uint64_t *items,
-			      unsigned int *nr_threads, int *rshift);
+int phase2_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
+int phase3_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
+int phase4_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
+int phase5_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
+int phase6_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */
