Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46711 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966646AbdKQVAo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:00:44 -0500
Subject: [PATCH 05/27] xfs_scrub: figure out how many threads we're going to
 need
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:00:39 -0800
Message-ID: <151095243964.4825.8021183555394772821.stgit@magnolia>
In-Reply-To: <151095240950.4825.6375172010231614655.stgit@magnolia>
References: <151095240950.4825.6375172010231614655.stgit@magnolia>
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
index 649b1c9..3df6126 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -222,3 +222,29 @@ auto_units(
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
index 70a3b9d..145a05c 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -59,5 +59,7 @@ debug_tweak_on(
 double timeval_subtract(struct timeval *tv1, struct timeval *tv2);
 double auto_space_units(unsigned long long kilobytes, char **units);
 double auto_units(unsigned long long number, char **units);
+unsigned int scrub_nproc(struct scrub_ctx *ctx);
+unsigned int scrub_nproc_workqueue(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 3bc2b63..8e2fa54 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -57,6 +57,9 @@ struct scrub_ctx {
 	/* How does the user want us to react to errors? */
 	enum error_action	error_action;
 
+	/* Number of threads for metadata scrubbing */
+	unsigned int		nr_io_threads;
+
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
 	unsigned long long	max_errors;

