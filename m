Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A3CC388F7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A410D2145D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507849AbgJVFPl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 01:15:41 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50591 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2444305AbgJVFPl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 01:15:41 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 98A7C588250
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 16:15:38 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-0034Kt-SP
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-009aoO-Ki
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] repair: parallelise phase 6
Date:   Thu, 22 Oct 2020 16:15:34 +1100
Message-Id: <20201022051537.2286402-5-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022051537.2286402-1-david@fromorbit.com>
References: <20201022051537.2286402-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=6KEnGoqAMqwac_kpMeoA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

A recent metadump provided to us caused repair to take hours in
phase6. It wasn't IO bound - it was fully CPU bound the entire time.
The only way to speed it up is to make phase 6 run multiple
concurrent processing threads.

The obvious way to do this is to spread the concurrency across AGs,
like the other phases, and while this works it is not optimal. When
a processing thread hits a really large directory, it essentially
sits CPU bound until that directory is processed. IF an AG has lots
of large directories, we end up with a really long single threaded
tail that limits concurrency.

Hence we also need to have concurrency /within/ the AG. This is
realtively easy, as the inode chunk records allow for a simple
concurrency mechanism within an AG. We can simply feed each chunk
record to a workqueue, and we get concurrency within the AG for
free. However, this allows prefetch to run way ahead of processing
and this blows out the buffer cache size and can cause OOM.

However, we can use the new workqueue depth limiting to limit the
number of inode chunks queued, and this then backs up the inode
prefetching to it's maximum queue depth. Hence we prevent having the
prefetch code queue the entire AG's inode chunks on the workqueue
blowing out memory by throttling the prefetch consumer.

This takes phase 6 from taking many, many hours down to:

Phase 6:        10/30 21:12:58  10/30 21:40:48  27 minutes, 50 seconds

And burning 20-30 cpus that entire time on my test rig.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 70d32089bb57..bf0719c186fb 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -6,6 +6,7 @@
 
 #include "libxfs.h"
 #include "threads.h"
+#include "threads.h"
 #include "prefetch.h"
 #include "avl.h"
 #include "globals.h"
@@ -3109,20 +3110,45 @@ check_for_orphaned_inodes(
 }
 
 static void
-traverse_function(
+do_dir_inode(
 	struct workqueue	*wq,
-	xfs_agnumber_t 		agno,
+	xfs_agnumber_t		agno,
 	void			*arg)
 {
-	ino_tree_node_t 	*irec;
+	struct ino_tree_node	*irec = arg;
 	int			i;
+
+	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
+		if (inode_isadir(irec, i))
+			process_dir_inode(wq->wq_ctx, agno, irec, i);
+	}
+}
+
+static void
+traverse_function(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct ino_tree_node	*irec;
 	prefetch_args_t		*pf_args = arg;
+	struct workqueue	lwq;
+	struct xfs_mount	*mp = wq->wq_ctx;
+
 
 	wait_for_inode_prefetch(pf_args);
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
 
+	/*
+	 * The more AGs we have in flight at once, the fewer processing threads
+	 * per AG. This means we don't overwhelm the machine with hundreds of
+	 * threads when we start acting on lots of AGs at once. We just want
+	 * enough that we can keep multiple CPUs busy across multiple AGs.
+	 */
+	workqueue_create_bound(&lwq, mp, ag_stride, 1000);
+
 	for (irec = findfirst_inode_rec(agno); irec; irec = next_ino_rec(irec)) {
 		if (irec->ino_isa_dir == 0)
 			continue;
@@ -3130,18 +3156,19 @@ traverse_function(
 		if (pf_args) {
 			sem_post(&pf_args->ra_count);
 #ifdef XR_PF_TRACE
+			{
+			int	i;
 			sem_getvalue(&pf_args->ra_count, &i);
 			pftrace(
 		"processing inode chunk %p in AG %d (sem count = %d)",
 				irec, agno, i);
+			}
 #endif
 		}
 
-		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
-			if (inode_isadir(irec, i))
-				process_dir_inode(wq->wq_ctx, agno, irec, i);
-		}
+		queue_work(&lwq, do_dir_inode, agno, irec);
 	}
+	destroy_work_queue(&lwq);
 	cleanup_inode_prefetch(pf_args);
 }
 
@@ -3169,7 +3196,7 @@ static void
 traverse_ags(
 	struct xfs_mount	*mp)
 {
-	do_inode_prefetch(mp, 0, traverse_function, false, true);
+	do_inode_prefetch(mp, ag_stride, traverse_function, false, true);
 }
 
 void
-- 
2.28.0

