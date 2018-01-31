Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57586 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752356AbeAaDHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jan 2018 22:07:06 -0500
Subject: [PATCH 05/29] xfs_scrub: figure out how many threads we're going to
 need
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 30 Jan 2018 19:07:03 -0800
Message-ID: <151736802334.32164.12902010477527372642.stgit@magnolia>
In-Reply-To: <151736799098.32164.15446216987522359103.stgit@magnolia>
References: <151736799098.32164.15446216987522359103.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create the plumbing to figure out how many threads we're going to want
to do all of our scrubbing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c    |   26 ++++++++++++++++++++++++++
 scrub/common.h    |    2 ++
 scrub/xfs_scrub.h |    3 +++
 3 files changed, 31 insertions(+)


diff --git a/scrub/common.c b/scrub/common.c
index 37ccd4a..05bb89b 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -168,3 +168,29 @@ auto_units(
 	*units = "";
 	return number;
 }
+
+/* How many threads to kick off? */
+unsigned int
+scrub_nproc(
+	struct scrub_ctx	*ctx)
+{
+	if (nr_threads)
+		return nr_threads;
+	return ctx->nr_io_threads;
+}
+
+/*
+ * How many threads to kick off for a workqueue?  If we only want one
+ * thread, save ourselves the overhead and just run it in the main thread.
+ */
+unsigned int
+scrub_nproc_workqueue(
+	struct scrub_ctx	*ctx)
+{
+	unsigned int		x;
+
+	x = scrub_nproc(ctx);
+	if (x == 1)
+		x = 0;
+	return x;
+}
diff --git a/scrub/common.h b/scrub/common.h
index e26e0e8..4779dbd 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -61,5 +61,7 @@ debug_tweak_on(
 double timeval_subtract(struct timeval *tv1, struct timeval *tv2);
 double auto_space_units(unsigned long long kilobytes, char **units);
 double auto_units(unsigned long long number, char **units);
+unsigned int scrub_nproc(struct scrub_ctx *ctx);
+unsigned int scrub_nproc_workqueue(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 51b8b7a..6d9f0c1 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -54,6 +54,9 @@ struct scrub_ctx {
 	/* How does the user want us to react to errors? */
 	enum error_action	error_action;
 
+	/* Number of threads for metadata scrubbing */
+	unsigned int		nr_io_threads;
+
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
 	unsigned long long	max_errors;

