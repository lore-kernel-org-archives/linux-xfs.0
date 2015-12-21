Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 51A2F29DF5
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 15:37:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3FE518F8033
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 13:37:33 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	C5ZJx4QQpBFgyl08 for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 13:37:30 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aB88m-0000hs-D7
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aB88m-0002lJ-CM
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/9] repair: parallelise phase 7
Date: Tue, 22 Dec 2015 08:37:04 +1100
Message-Id: <1450733829-9319-5-git-send-email-david@fromorbit.com>
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

It operates on a single AG at a time, sequentially, doing inode updates. All the
data structures accessed and modified are per AG, as are the modification to
on-disk structures. Hence we can run this phase concurrently across multiple
AGs.

This is important for large, broken filesystem repairs, where there can be
millions of inodes that need link counts updated. Once such repair image takes
more than 45 minutes to run phase 7 as a single threaded operation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase7.c     | 77 ++++++++++++++++++++++++++++++++++-------------------
 repair/progress.c   |  4 +--
 repair/protos.h     |  2 +-
 repair/xfs_repair.c |  2 +-
 4 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/repair/phase7.c b/repair/phase7.c
index b1e3a55..91dad02 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -26,6 +26,7 @@
 #include "dinode.h"
 #include "versions.h"
 #include "progress.h"
+#include "threads.h"
 
 /* dinoc is a pointer to the IN-CORE dinode core */
 static void
@@ -108,45 +109,67 @@ update_inode_nlinks(
 	IRELE(ip);
 }
 
-void
-phase7(xfs_mount_t *mp)
+/*
+ * for each ag, look at each inode 1 at a time. If the number of
+ * links is bad, reset it, log the inode core, commit the transaction
+ */
+static void
+do_link_updates(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
 {
 	ino_tree_node_t		*irec;
-	int			i;
 	int			j;
 	__uint32_t		nrefs;
 
+	irec = findfirst_inode_rec(agno);
+
+	while (irec != NULL)  {
+		for (j = 0; j < XFS_INODES_PER_CHUNK; j++)  {
+			ASSERT(is_inode_confirmed(irec, j));
+
+			if (is_inode_free(irec, j))
+				continue;
+
+			ASSERT(no_modify || is_inode_reached(irec, j));
+
+			nrefs = num_inode_references(irec, j);
+			ASSERT(no_modify || nrefs > 0);
+
+			if (get_inode_disk_nlinks(irec, j) != nrefs)
+				update_inode_nlinks(wq->mp,
+					XFS_AGINO_TO_INO(wq->mp, agno,
+						irec->ino_startnum + j),
+					nrefs);
+		}
+		irec = next_ino_rec(irec);
+	}
+
+	PROG_RPT_INC(prog_rpt_done[agno], 1);
+}
+
+void
+phase7(
+	struct xfs_mount	*mp,
+	int			scan_threads)
+{
+	struct work_queue	wq;
+	int			agno;
+
 	if (!no_modify)
 		do_log(_("Phase 7 - verify and correct link counts...\n"));
 	else
 		do_log(_("Phase 7 - verify link counts...\n"));
 
-	/*
-	 * for each ag, look at each inode 1 at a time. If the number of
-	 * links is bad, reset it, log the inode core, commit the transaction
-	 */
-	for (i = 0; i < glob_agcount; i++)  {
-		irec = findfirst_inode_rec(i);
-
-		while (irec != NULL)  {
-			for (j = 0; j < XFS_INODES_PER_CHUNK; j++)  {
-				ASSERT(is_inode_confirmed(irec, j));
+	set_progress_msg(PROGRESS_FMT_CORR_LINK, (__uint64_t) glob_agcount);
 
-				if (is_inode_free(irec, j))
-					continue;
+	create_work_queue(&wq, mp, scan_threads);
 
-				ASSERT(no_modify || is_inode_reached(irec, j));
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
+		queue_work(&wq, do_link_updates, agno, NULL);
 
-				nrefs = num_inode_references(irec, j);
-				ASSERT(no_modify || nrefs > 0);
+	destroy_work_queue(&wq);
 
-				if (get_inode_disk_nlinks(irec, j) != nrefs)
-					update_inode_nlinks(mp,
-						XFS_AGINO_TO_INO(mp, i,
-							irec->ino_startnum + j),
-						nrefs);
-			}
-			irec = next_ino_rec(irec);
-		}
-	}
+	print_final_rpt();
 }
diff --git a/repair/progress.c b/repair/progress.c
index 418b803..2a09b23 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -75,9 +75,9 @@ progress_rpt_t progress_rpt_reports[] = {
 {FMT2, N_("moving disconnected inodes to lost+found"),		/* 12 */
 	&rpt_fmts[FMT2], &rpt_types[TYPE_INODE]},
 {FMT1, N_("verify and correct link counts"),			/* 13 */
-	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]},
+	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
 {FMT1, N_("verify link counts"),				/* 14 */
-	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]}
+	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]}
 };
 
 pthread_t	report_thread;
diff --git a/repair/protos.h b/repair/protos.h
index 9d5a2a6..b113aca 100644
--- a/repair/protos.h
+++ b/repair/protos.h
@@ -50,7 +50,7 @@ void	phase3(struct xfs_mount *);
 void	phase4(struct xfs_mount *);
 void	phase5(struct xfs_mount *);
 void	phase6(struct xfs_mount *);
-void	phase7(struct xfs_mount *);
+void	phase7(struct xfs_mount *, int);
 
 int	verify_set_agheader(struct xfs_mount *, struct xfs_buf *,
 		struct xfs_sb *, struct xfs_agf *, struct xfs_agi *,
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 3eaced4..fcdb212 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -893,7 +893,7 @@ main(int argc, char **argv)
 		phase6(mp);
 		timestamp(PHASE_END, 6, NULL);
 
-		phase7(mp);
+		phase7(mp, phase2_threads);
 		timestamp(PHASE_END, 7, NULL);
 	} else  {
 		do_warn(
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
