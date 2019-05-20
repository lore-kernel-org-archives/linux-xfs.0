Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38744 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETXRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:17:46 -0400
Subject: [PATCH 09/12] xfs_scrub: fix background-mode sleep throttling
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 16:17:37 -0700
Message-ID: <155839425742.68606.18377767804648563349.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The comment preceding background_sleep() is wrong -- the function sleeps
100us, not 100ms, for every '-b' passed in after the first one.  This is
really not obvious from the magic numbers, so fix the comment and use
symbolic constants for easier reading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index c877c7c8..1cd2b7ba 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -253,21 +253,23 @@ scrub_nproc_workqueue(
 }
 
 /*
- * Sleep for 100ms * however many -b we got past the initial one.
+ * Sleep for 100us * however many -b we got past the initial one.
  * This is an (albeit clumsy) way to throttle scrub activity.
  */
+#define NSEC_PER_SEC	1000000000ULL
+#define NSEC_PER_USEC	1000ULL
 void
 background_sleep(void)
 {
-	unsigned long long	time;
+	unsigned long long	time_ns;
 	struct timespec		tv;
 
 	if (bg_mode < 2)
 		return;
 
-	time = 100000ULL * (bg_mode - 1);
-	tv.tv_sec = time / 1000000;
-	tv.tv_nsec = time % 1000000;
+	time_ns =  100 * NSEC_PER_USEC * (bg_mode - 1);
+	tv.tv_sec = time_ns / NSEC_PER_SEC;
+	tv.tv_nsec = time_ns % NSEC_PER_SEC;
 	nanosleep(&tv, NULL);
 }
 
