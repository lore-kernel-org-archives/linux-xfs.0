Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55Eoq136125 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:14 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sQjn7dlAVbMDq8Cm for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:59 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbz-0003Kc-Ia
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbz-0003jb-Fu
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 100/102] xfs: don't defer metadata allocation to the workqueue
Date: Thu, 23 Aug 2012 15:02:58 +1000
Message-Id: <1345698180-13612-101-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: aa292847b9fc6e187547110de833a7d3131bbddf

Almost all metadata allocations come from shallow stack usage
situations. Avoid the overhead of switching the allocation to a
workqueue as we are not in danger of running out of stack when
making these allocations. Metadata allocations are already marked
through the args that are passed down, so this is trivial to do.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reported-by: Mel Gorman <mgorman@suse.de>
Tested-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_alloc.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index de5a353..5d830cf 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2441,13 +2441,22 @@ xfs_alloc_vextent_worker(
 	current_restore_flags_nested(&pflags, PF_FSTRANS);
 }
 
-
-int				/* error */
+/*
+ * Data allocation requests often come in with little stack to work on. Push
+ * them off to a worker thread so there is lots of stack to use. Metadata
+ * requests, OTOH, are generally from low stack usage paths, so avoid the
+ * context switch overhead here.
+ */
+int
 xfs_alloc_vextent(
-	xfs_alloc_arg_t	*args)	/* allocation argument structure */
+	struct xfs_alloc_arg	*args)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 
+	if (!args->userdata)
+		return __xfs_alloc_vextent(args);
+
+
 	args->done = &done;
 	INIT_WORK_ONSTACK(&args->work, xfs_alloc_vextent_worker);
 	queue_work(xfs_alloc_wq, &args->work);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
