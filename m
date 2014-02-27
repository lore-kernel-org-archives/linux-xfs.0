Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FE157F56
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:51:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 629088F8039
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:51:39 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AMl4EmNMVR9LFQ8e for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:51:36 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WIxcb-0007bv-Bz
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WIxcb-0007sR-Ay
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/10] repair: factor out threading setup code
Date: Thu, 27 Feb 2014 20:51:13 +1100
Message-Id: <1393494675-30194-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1393494675-30194-1-git-send-email-david@fromorbit.com>
References: <1393494675-30194-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The same code is repeated in different places to set up
multithreaded prefetching. This can all be factored into a single
implementation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dinode.h   | 15 ++++++------
 repair/phase3.c   | 40 +++----------------------------
 repair/phase4.c   | 48 +++----------------------------------
 repair/phase6.c   | 22 ++++-------------
 repair/prefetch.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/prefetch.h | 10 ++++++++
 6 files changed, 98 insertions(+), 108 deletions(-)

diff --git a/repair/dinode.h b/repair/dinode.h
index 7521521..5ee51ca 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -18,9 +18,8 @@
 #ifndef _XR_DINODE_H
 #define _XR_DINODE_H
 
-#include "prefetch.h"
-
 struct blkmap;
+struct prefetch_args;
 
 int
 verify_agbno(xfs_mount_t	*mp,
@@ -103,12 +102,12 @@ int
 process_uncertain_aginodes(xfs_mount_t		*mp,
 				xfs_agnumber_t	agno);
 void
-process_aginodes(xfs_mount_t	*mp,
-		prefetch_args_t	*pf_args,
-		xfs_agnumber_t	agno,
-		int		check_dirs,
-		int		check_dups,
-		int		extra_attr_check);
+process_aginodes(xfs_mount_t		*mp,
+		struct prefetch_args	*pf_args,
+		xfs_agnumber_t		agno,
+		int			check_dirs,
+		int			check_dups,
+		int			extra_attr_check);
 
 void
 check_uncertain_aginodes(xfs_mount_t	*mp,
diff --git a/repair/phase3.c b/repair/phase3.c
index 3e43938..213d368 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -17,6 +17,8 @@
  */
 
 #include <libxfs.h>
+#include "threads.h"
+#include "prefetch.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
@@ -24,9 +26,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "dinode.h"
-#include "threads.h"
 #include "progress.h"
-#include "prefetch.h"
 
 static void
 process_agi_unlinked(
@@ -82,41 +82,7 @@ static void
 process_ags(
 	xfs_mount_t		*mp)
 {
-	int 			i, j;
-	xfs_agnumber_t 		agno;
-	work_queue_t		*queues;
-	prefetch_args_t		*pf_args[2];
-
-	queues = malloc(thread_count * sizeof(work_queue_t));
-
-	if (ag_stride) {
-		/*
-		 * create one worker thread for each segment of the volume
-		 */
-		for (i = 0, agno = 0; i < thread_count; i++) {
-			create_work_queue(&queues[i], mp, 1);
-			pf_args[0] = NULL;
-			for (j = 0; j < ag_stride && agno < mp->m_sb.sb_agcount;
-					j++, agno++) {
-				pf_args[0] = start_inode_prefetch(agno, 0, pf_args[0]);
-				queue_work(&queues[i], process_ag_func, agno, pf_args[0]);
-			}
-		}
-		/*
-		 * wait for workers to complete
-		 */
-		for (i = 0; i < thread_count; i++)
-			destroy_work_queue(&queues[i]);
-	} else {
-		queues[0].mp = mp;
-		pf_args[0] = start_inode_prefetch(0, 0, NULL);
-		for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-			pf_args[(~i) & 1] = start_inode_prefetch(i + 1, 0,
-					pf_args[i & 1]);
-			process_ag_func(&queues[0], i, pf_args[i & 1]);
-		}
-	}
-	free(queues);
+	do_inode_prefetch(mp, ag_stride, process_ag_func, false, false);
 }
 
 void
diff --git a/repair/phase4.c b/repair/phase4.c
index a822aaa..189eeb9 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -17,6 +17,8 @@
  */
 
 #include <libxfs.h>
+#include "threads.h"
+#include "prefetch.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
@@ -27,9 +29,7 @@
 #include "bmap.h"
 #include "versions.h"
 #include "dir2.h"
-#include "threads.h"
 #include "progress.h"
-#include "prefetch.h"
 
 
 /*
@@ -150,49 +150,7 @@ static void
 process_ags(
 	xfs_mount_t		*mp)
 {
-	int 			i, j;
-	xfs_agnumber_t 		agno;
-	work_queue_t		*queues;
-	prefetch_args_t		*pf_args[2];
-
-	queues = malloc(thread_count * sizeof(work_queue_t));
-
-	if (!libxfs_bcache_overflowed()) {
-		queues[0].mp = mp;
-		create_work_queue(&queues[0], mp, libxfs_nproc());
-		for (i = 0; i < mp->m_sb.sb_agcount; i++)
-			queue_work(&queues[0], process_ag_func, i, NULL);
-		destroy_work_queue(&queues[0]);
-	} else {
-		if (ag_stride) {
-			/*
-			 * create one worker thread for each segment of the volume
-			 */
-			for (i = 0, agno = 0; i < thread_count; i++) {
-				create_work_queue(&queues[i], mp, 1);
-				pf_args[0] = NULL;
-				for (j = 0; j < ag_stride && agno < mp->m_sb.sb_agcount;
-						j++, agno++) {
-					pf_args[0] = start_inode_prefetch(agno, 0, pf_args[0]);
-					queue_work(&queues[i], process_ag_func, agno, pf_args[0]);
-				}
-			}
-			/*
-			 * wait for workers to complete
-			 */
-			for (i = 0; i < thread_count; i++)
-				destroy_work_queue(&queues[i]);
-		} else {
-			queues[0].mp = mp;
-			pf_args[0] = start_inode_prefetch(0, 0, NULL);
-			for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-				pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
-						0, pf_args[i & 1]);
-				process_ag_func(&queues[0], i, pf_args[i & 1]);
-			}
-		}
-	}
-	free(queues);
+	do_inode_prefetch(mp, ag_stride, process_ag_func, true, false);
 }
 
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 63359d1..446f3ee 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -17,6 +17,8 @@
  */
 
 #include <libxfs.h>
+#include "threads.h"
+#include "prefetch.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
@@ -25,9 +27,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "dinode.h"
-#include "prefetch.h"
 #include "progress.h"
-#include "threads.h"
 #include "versions.h"
 
 static struct cred		zerocr;
@@ -3039,23 +3039,9 @@ update_missing_dotdot_entries(
 
 static void
 traverse_ags(
-	xfs_mount_t 		*mp)
+	struct xfs_mount	*mp)
 {
-	int			i;
-	work_queue_t		queue;
-	prefetch_args_t		*pf_args[2];
-
-	/*
-	 * we always do prefetch for phase 6 as it will fill in the gaps
-	 * not read during phase 3 prefetch.
-	 */
-	queue.mp = mp;
-	pf_args[0] = start_inode_prefetch(0, 1, NULL);
-	for (i = 0; i < glob_agcount; i++) {
-		pf_args[(~i) & 1] = start_inode_prefetch(i + 1, 1,
-				pf_args[i & 1]);
-		traverse_function(&queue, i, pf_args[i & 1]);
-	}
+	do_inode_prefetch(mp, 0, traverse_function, false, true);
 }
 
 void
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 946e822..aee6342 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -866,6 +866,77 @@ start_inode_prefetch(
 	return args;
 }
 
+/*
+ * Do inode prefetch in the most optimal way for the context under which repair
+ * has been run.
+ */
+void
+do_inode_prefetch(
+	struct xfs_mount	*mp,
+	int			stride,
+	void			(*func)(struct work_queue *,
+					xfs_agnumber_t, void *),
+	bool			check_cache,
+	bool			dirs_only)
+{
+	int			i, j;
+	xfs_agnumber_t		agno;
+	struct work_queue	queue;
+	struct work_queue	*queues;
+	struct prefetch_args	*pf_args[2];
+
+	/*
+	 * If the previous phases of repair have not overflowed the buffer
+	 * cache, then we don't need to re-read any of the metadata in the
+	 * filesystem - it's all in the cache. In that case, run a thread per
+	 * CPU to maximise parallelism of the queue to be processed.
+	 */
+	if (check_cache && !libxfs_bcache_overflowed()) {
+		queue.mp = mp;
+		create_work_queue(&queue, mp, libxfs_nproc());
+		for (i = 0; i < mp->m_sb.sb_agcount; i++)
+			queue_work(&queue, func, i, NULL);
+		destroy_work_queue(&queue);
+		return;
+	}
+
+	/*
+	 * single threaded behaviour - single prefetch thread, processed
+	 * directly after each AG is queued.
+	 */
+	if (!stride) {
+		queue.mp = mp;
+		pf_args[0] = start_inode_prefetch(0, dirs_only, NULL);
+		for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+			pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
+					dirs_only, pf_args[i & 1]);
+			func(&queue, i, pf_args[i & 1]);
+		}
+		return;
+	}
+
+	/*
+	 * create one worker thread for each segment of the volume
+	 */
+	queues = malloc(thread_count * sizeof(work_queue_t));
+	for (i = 0, agno = 0; i < thread_count; i++) {
+		create_work_queue(&queues[i], mp, 1);
+		pf_args[0] = NULL;
+		for (j = 0; j < stride && agno < mp->m_sb.sb_agcount;
+				j++, agno++) {
+			pf_args[0] = start_inode_prefetch(agno, dirs_only,
+							  pf_args[0]);
+			queue_work(&queues[i], func, agno, pf_args[0]);
+		}
+	}
+	/*
+	 * wait for workers to complete
+	 */
+	for (i = 0; i < thread_count; i++)
+		destroy_work_queue(&queues[i]);
+	free(queues);
+}
+
 void
 wait_for_inode_prefetch(
 	prefetch_args_t		*args)
diff --git a/repair/prefetch.h b/repair/prefetch.h
index 44a406c..b837752 100644
--- a/repair/prefetch.h
+++ b/repair/prefetch.h
@@ -4,6 +4,7 @@
 #include <semaphore.h>
 #include "incore.h"
 
+struct work_queue;
 
 extern int 	do_prefetch;
 
@@ -41,6 +42,15 @@ start_inode_prefetch(
 	prefetch_args_t		*prev_args);
 
 void
+do_inode_prefetch(
+	struct xfs_mount	*mp,
+	int			stride,
+	void			(*func)(struct work_queue *,
+					xfs_agnumber_t, void *),
+	bool			check_cache,
+	bool			dirs_only);
+
+void
 wait_for_inode_prefetch(
 	prefetch_args_t		*args);
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
