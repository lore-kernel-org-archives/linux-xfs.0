Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA63ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2CF220B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MyE3jLZz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732691AbfJVSwO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:52:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731740AbfJVSwO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:52:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiG3b089177;
        Tue, 22 Oct 2019 18:52:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=54kqjOPuTmr6kIBL0mzmbjNn68JtOpXfhIjQnEVlMsk=;
 b=MyE3jLZzU/f5ivjnB1Fwmv0jXP7pzHImjChBGTQxJOwBetbLLyq8MO+bDyytozrPnm9E
 R0XW30fyslcmWEOT7geryHD0gI7Z+bVqT+FNN9YqchijN6huCNRiZr8KeJh7E/DECXHj
 hyXeWPbbNZDvo0t+inOsslCQspF5AMw+QW+2DIFGLidY+uvUXsLEdF6Rjyu/r8818H4q
 984CokIX54YnmULOPIWVBO7i0p1zy7v3/V1u55WOe75VxtFoUsOMbcc1KWgrWD9F++z3
 2B5JKW4BFMYdJL2LBjacLheSXaRIN1++Q89uQB/vrXHKlPzjeAL1+gHPyXwE/ccdyI6Q Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4qrksn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhkLn148043;
        Tue, 22 Oct 2019 18:52:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vsp401803-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:11 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIqAPi032038;
        Tue, 22 Oct 2019 18:52:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 18:52:10 +0000
Subject: [PATCH 16/18] xfs_scrub: remove moveon from phase 1 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:52:09 -0700
Message-ID: <157177032948.1461658.7286200913132387029.stgit@magnolia>
In-Reply-To: <157177022106.1461658.18024534947316119946.stgit@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
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

Replace the moveon returns in the phase 1 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase1.c    |   49 ++++++++++++++++++++++++++++---------------------
 scrub/xfs_scrub.c |    5 +++--
 scrub/xfs_scrub.h |    2 +-
 3 files changed, 32 insertions(+), 24 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 5538deae..75ae3b00 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -44,8 +44,8 @@ xfs_shutdown_fs(
 }
 
 /* Clean up the XFS-specific state data. */
-bool
-xfs_cleanup_fs(
+int
+scrub_cleanup(
 	struct scrub_ctx	*ctx)
 {
 	int			error;
@@ -65,15 +65,15 @@ xfs_cleanup_fs(
 		str_liberror(ctx, error, _("closing mountpoint fd"));
 	fs_table_destroy();
 
-	return true;
+	return error;
 }
 
 /*
  * Bind to the mountpoint, read the XFS geometry, bind to the block devices.
- * Anything we've already built will be cleaned up by xfs_cleanup_fs.
+ * Anything we've already built will be cleaned up by scrub_cleanup.
  */
-bool
-xfs_setup_fs(
+int
+phase1_func(
 	struct scrub_ctx		*ctx)
 {
 	int				error;
@@ -95,23 +95,23 @@ _("Must be root to run scrub."));
 _("Not an XFS filesystem."));
 		else
 			str_liberror(ctx, error, ctx->mntpoint);
-		return false;
+		return error;
 	}
 
 	error = fstat(ctx->mnt.fd, &ctx->mnt_sb);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
-		return false;
+		return error;
 	}
 	error = fstatvfs(ctx->mnt.fd, &ctx->mnt_sv);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
-		return false;
+		return error;
 	}
 	error = fstatfs(ctx->mnt.fd, &ctx->mnt_sf);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
-		return false;
+		return error;
 	}
 
 	/*
@@ -122,21 +122,21 @@ _("Not an XFS filesystem."));
 	error = syncfs(ctx->mnt.fd);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
-		return false;
+		return error;
 	}
 
 	error = action_lists_alloc(ctx->mnt.fsgeom.agcount,
 			&ctx->action_lists);
 	if (error) {
 		str_liberror(ctx, error, _("allocating action lists"));
-		return false;
+		return error;
 	}
 
 	error = path_to_fshandle(ctx->mntpoint, &ctx->fshandle,
 			&ctx->fshandle_len);
 	if (error) {
 		str_errno(ctx, _("getting fshandle"));
-		return false;
+		return error;
 	}
 
 	/* Do we have kernel-assisted metadata scrubbing? */
@@ -146,33 +146,33 @@ _("Not an XFS filesystem."));
 	    !xfs_can_scrub_parent(ctx)) {
 		str_error(ctx, ctx->mntpoint,
 _("Kernel metadata scrubbing facility is not available."));
-		return false;
+		return ECANCELED;
 	}
 
 	/* Do we need kernel-assisted metadata repair? */
 	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
 		str_error(ctx, ctx->mntpoint,
 _("Kernel metadata repair facility is not available.  Use -n to scrub."));
-		return false;
+		return ECANCELED;
 	}
 
 	/* Did we find the log and rt devices, if they're present? */
 	if (ctx->mnt.fsgeom.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
 		str_error(ctx, ctx->mntpoint,
 _("Unable to find log device path."));
-		return false;
+		return ECANCELED;
 	}
 	if (ctx->mnt.fsgeom.rtblocks && ctx->fsinfo.fs_rt == NULL) {
 		str_error(ctx, ctx->mntpoint,
 _("Unable to find realtime device path."));
-		return false;
+		return ECANCELED;
 	}
 
 	/* Open the raw devices. */
 	ctx->datadev = disk_open(ctx->fsinfo.fs_name);
 	if (error) {
 		str_errno(ctx, ctx->fsinfo.fs_name);
-		return false;
+		return error;
 	}
 
 	ctx->nr_io_threads = disk_heads(ctx->datadev);
@@ -186,14 +186,14 @@ _("Unable to find realtime device path."));
 		ctx->logdev = disk_open(ctx->fsinfo.fs_log);
 		if (error) {
 			str_errno(ctx, ctx->fsinfo.fs_name);
-			return false;
+			return error;
 		}
 	}
 	if (ctx->fsinfo.fs_rt) {
 		ctx->rtdev = disk_open(ctx->fsinfo.fs_rt);
 		if (error) {
 			str_errno(ctx, ctx->fsinfo.fs_name);
-			return false;
+			return error;
 		}
 	}
 
@@ -204,5 +204,12 @@ _("Unable to find realtime device path."));
 	 */
 	log_info(ctx, _("Invoking online scrub."), ctx);
 	ctx->scrub_setup_succeeded = true;
-	return true;
+	return 0;
+}
+
+bool
+xfs_setup_fs(
+	struct scrub_ctx		*ctx)
+{
+	return phase1_func(ctx) == 0;
 }
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index c0e60b92..3751e5af 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -602,6 +602,7 @@ main(
 	int			c;
 	int			fd;
 	int			ret = SCRUB_RET_SUCCESS;
+	int			error;
 
 	fprintf(stdout, "EXPERIMENTAL xfs_scrub program in use! Use at your own risk!\n");
 
@@ -776,8 +777,8 @@ main(
 		str_info(&ctx, ctx.mntpoint, _("Injecting error."));
 
 	/* Clean up scan data. */
-	moveon = xfs_cleanup_fs(&ctx);
-	if (!moveon && ctx.runtime_errors == 0)
+	error = scrub_cleanup(&ctx);
+	if (error && ctx.runtime_errors == 0)
 		ctx.runtime_errors++;
 
 out:
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 88537b0b..5e7f94f5 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -88,7 +88,7 @@ struct scrub_ctx {
 
 /* Phase helper functions */
 void xfs_shutdown_fs(struct scrub_ctx *ctx);
-bool xfs_cleanup_fs(struct scrub_ctx *ctx);
+int scrub_cleanup(struct scrub_ctx *ctx);
 bool xfs_setup_fs(struct scrub_ctx *ctx);
 bool xfs_scan_metadata(struct scrub_ctx *ctx);
 bool xfs_scan_inodes(struct scrub_ctx *ctx);

