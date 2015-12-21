Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 082FB29E09
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 15:37:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C1EDB304032
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 13:37:32 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	isJSGh06Bi5DqMBe for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 13:37:31 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aB88m-0000ht-DS
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aB88m-0002lO-Ci
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/9] repair: parallelise uncertin inode processing in phase 3
Date: Tue, 22 Dec 2015 08:37:05 +1100
Message-Id: <1450733829-9319-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1450733829-9319-1-git-send-email-david@fromorbit.com>
References: <1450733829-9319-1-git-send-email-david@fromorbit.com>
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

This can take a long time when there are millions of uncertain inodes in badly
broken filesystems. THe processing is per-ag, the data structures are all
per-ag, and the load is mostly CPU time spent checking CRCs on each
uncertaini inode. Parallelising reduced the runtime of this phase on a badly
broken filesytem from ~30 minutes to under 5 miniutes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase3.c     | 59 ++++++++++++++++++++++++++++++++++++++++++++---------
 repair/protos.h     |  2 +-
 repair/xfs_repair.c |  2 +-
 3 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/repair/phase3.c b/repair/phase3.c
index 76c9440..0890a27 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -28,6 +28,7 @@
 #include "dinode.h"
 #include "progress.h"
 #include "bmap.h"
+#include "threads.h"
 
 static void
 process_agi_unlinked(
@@ -87,10 +88,33 @@ process_ags(
 	do_inode_prefetch(mp, ag_stride, process_ag_func, false, false);
 }
 
+static void
+do_uncertain_aginodes(
+	work_queue_t	*wq,
+	xfs_agnumber_t	agno,
+	void		*arg)
+{
+	int		*count = arg;
+
+	*count = process_uncertain_aginodes(wq->mp, agno);
+
+#ifdef XR_INODE_TRACE
+	fprintf(stderr,
+		"\t\t phase 3 - ag %d process_uncertain_inodes returns %d\n",
+		*count, j);
+#endif
+
+	PROG_RPT_INC(prog_rpt_done[agno], 1);
+}
+
 void
-phase3(xfs_mount_t *mp)
+phase3(
+	struct xfs_mount *mp,
+	int		scan_threads)
 {
-	int 			i, j;
+	int			i, j;
+	int			*counts;
+	work_queue_t		wq;
 
 	do_log(_("Phase 3 - for each AG...\n"));
 	if (!no_modify)
@@ -129,20 +153,35 @@ phase3(xfs_mount_t *mp)
 	 */
 	do_log(_("        - process newly discovered inodes...\n"));
 	set_progress_msg(PROG_FMT_NEW_INODES, (__uint64_t) glob_agcount);
+
+	counts = calloc(sizeof(*counts), mp->m_sb.sb_agcount);
+	if (!counts) {
+		do_abort(_("no memory for uncertain inode counts\n"));
+		return;
+	}
+
 	do  {
 		/*
 		 * have to loop until no ag has any uncertain
 		 * inodes
 		 */
 		j = 0;
-		for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
-			j += process_uncertain_aginodes(mp, i);
-#ifdef XR_INODE_TRACE
-			fprintf(stderr,
-				"\t\t phase 3 - process_uncertain_inodes returns %d\n", j);
-#endif
-			PROG_RPT_INC(prog_rpt_done[i], 1);
-		}
+		memset(counts, 0, mp->m_sb.sb_agcount * sizeof(*counts));
+
+		create_work_queue(&wq, mp, scan_threads);
+
+		for (i = 0; i < mp->m_sb.sb_agcount; i++)
+			queue_work(&wq, do_uncertain_aginodes, i, &counts[i]);
+
+		destroy_work_queue(&wq);
+
+		/* tally up the counts */
+		for (i = 0; i < mp->m_sb.sb_agcount; i++)
+			j += counts[i];
+
 	} while (j != 0);
+
+	free(counts);
+
 	print_final_rpt();
 }
diff --git a/repair/protos.h b/repair/protos.h
index b113aca..0290420 100644
--- a/repair/protos.h
+++ b/repair/protos.h
@@ -46,7 +46,7 @@ void	thread_init(void);
 
 void	phase1(struct xfs_mount *);
 void	phase2(struct xfs_mount *, int);
-void	phase3(struct xfs_mount *);
+void	phase3(struct xfs_mount *, int);
 void	phase4(struct xfs_mount *);
 void	phase5(struct xfs_mount *);
 void	phase6(struct xfs_mount *);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index fcdb212..5d5f3aa 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -871,7 +871,7 @@ main(int argc, char **argv)
 	if (do_prefetch)
 		init_prefetch(mp);
 
-	phase3(mp);
+	phase3(mp, phase2_threads);
 	timestamp(PHASE_END, 3, NULL);
 
 	phase4(mp);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
