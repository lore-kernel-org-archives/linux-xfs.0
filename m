Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6BLesFv240985 for <xfs@oss.sgi.com>; Wed, 11 Jul 2012 16:40:54 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vEDY33OZyvvOs9Pn for <xfs@oss.sgi.com>;
	Wed, 11 Jul 2012 14:40:52 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: don't defer metadata allocation to the workqueue
Date: Thu, 12 Jul 2012 07:40:43 +1000
Message-Id: <1342042843-1773-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1342042843-1773-1-git-send-email-david@fromorbit.com>
References: <1342042843-1773-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

Almost all metadata allocations come from shallow stack usage
situations. Avoid the overhead of switching the allocation to a
workqueue as we are not in danger of running out of stack when
making these allocations. Metadata allocations are already marked
through the args that are passed down, so this is trivial to do.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reported-by: Mel Gorman <mgorman@suse.de>
Tested-by: Mel Gorman <mgorman@suse.de>
---
 fs/xfs/xfs_alloc.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index f654f51..4f33c32 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2434,13 +2434,22 @@ xfs_alloc_vextent_worker(
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
