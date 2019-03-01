Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42144 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfCAX1f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:27:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOAfU122685
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:34 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qtupetejw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:27:33 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRWZI031935
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:33 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRW3e020212
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:32 GMT
Subject: [PATCH 07/23] xfs_scrub: use datadev parallelization estimates for
 thread count
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:27:31 -0800
Message-ID: <155148285165.16677.5573180437389379617.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During phases 2-5, xfs_scrub should estimate the level of
parallelization possible on the data device to determine the number of
threads spawned to scrub filesystem metadata, not just blindly using the
number of CPUs.  This avoids flooding non-rotational storage with random
reads, which totally destroys performance and makes scrub runtimes
higher.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase1.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 2113014b..6b472147 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -109,13 +109,6 @@ _("Must be root to run scrub."));
 		return false;
 	}
 
-	ctx->nr_io_threads = nproc;
-	if (verbose) {
-		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
-				ctx->mntpoint, scrub_nproc(ctx));
-		fflush(stdout);
-	}
-
 	if (!platform_test_xfs_fd(ctx->mnt_fd)) {
 		str_info(ctx, ctx->mntpoint,
 _("Does not appear to be an XFS filesystem!"));
@@ -193,6 +186,13 @@ _("Unable to find realtime device path."));
 		return false;
 	}
 
+	ctx->nr_io_threads = disk_heads(ctx->datadev);
+	if (verbose) {
+		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
+				ctx->mntpoint, scrub_nproc(ctx));
+		fflush(stdout);
+	}
+
 	if (ctx->fsinfo.fs_log) {
 		ctx->logdev = disk_open(ctx->fsinfo.fs_log);
 		if (error) {
