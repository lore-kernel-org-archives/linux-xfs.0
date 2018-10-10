Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56200 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 16/18] xfs_scrub: remove shadow var from run_scrub_phases()
Date: Wed, 10 Oct 2018 15:01:20 -0500
Message-Id: <1539201682-22198-17-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The local nr_threads shadows a global var of the same name.
Use a local variable to avoid confusion (even though estimate_work()
may simply fill in the value of the global...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 scrub/xfs_scrub.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 33b83a5..a789b6f 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -422,7 +422,6 @@ run_scrub_phases(
 	bool			moveon = true;
 	unsigned int		debug_phase = 0;
 	unsigned int		phase;
-	unsigned int		nr_threads;
 	int			rshift;
 
 	if (debug_tweak_on("XFS_SCRUB_PHASE"))
@@ -454,12 +453,14 @@ run_scrub_phases(
 		if (!moveon)
 			break;
 		if (sp->estimate_work) {
-			moveon = sp->estimate_work(ctx, &max_work, &nr_threads,
-					&rshift);
+			unsigned int		work_threads;
+
+			moveon = sp->estimate_work(ctx, &max_work,
+					&work_threads, &rshift);
 			if (!moveon)
 				break;
 			moveon = progress_init_phase(ctx, progress_fp, phase,
-					max_work, rshift, nr_threads);
+					max_work, rshift, work_threads);
 		} else {
 			moveon = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
 		}
-- 
1.8.3.1
