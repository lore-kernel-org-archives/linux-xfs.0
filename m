Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C7CC821B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:37:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30422304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id fuGfpuKC3iJS7zdD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:18 -0700 (PDT)
Subject: [PATCH 061/145] xfs_repair: add inode bmbt block rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:37:09 -0700
Message-ID: <146612742957.16048.6189985332126150626.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Record BMBT blocks in the raw rmap list.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/rmap.c |   26 ++++++++++++++++++++++++++
 repair/rmap.h |    1 +
 repair/scan.c |   11 +++++++++++
 3 files changed, 38 insertions(+)


diff --git a/repair/rmap.c b/repair/rmap.c
index 1851742..e30e99b 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -230,6 +230,32 @@ __add_raw_rmap(
 }
 
 /*
+ * Add a reverse mapping for an inode fork's block mapping btree block.
+ */
+int
+add_bmbt_rmap(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	int			whichfork,
+	xfs_fsblock_t		fsbno)
+{
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+
+	if (!needs_rmap_work(mp))
+		return 0;
+
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	ASSERT(agno != NULLAGNUMBER);
+	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(agbno + 1 <= mp->m_sb.sb_agblocks);
+
+	return __add_raw_rmap(mp, agno, agbno, 1, ino,
+			whichfork == XFS_ATTR_FORK, true);
+}
+
+/*
  * Add a reverse mapping for a per-AG fixed metadata extent.
  */
 int
diff --git a/repair/rmap.h b/repair/rmap.h
index ca92623..6a3a0a4 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -30,6 +30,7 @@ extern void free_rmaps(struct xfs_mount *);
 extern int add_rmap(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
 extern int add_ag_rmap(struct xfs_mount *, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
+extern int add_bmbt_rmap(struct xfs_mount *, xfs_ino_t, int, xfs_fsblock_t);
 extern int fold_raw_rmaps(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern bool mergeable_rmaps(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
diff --git a/repair/scan.c b/repair/scan.c
index eb23685..6157d71 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -29,6 +29,7 @@
 #include "bmap.h"
 #include "progress.h"
 #include "threads.h"
+#include "rmap.h"
 
 static xfs_mount_t	*mp = NULL;
 
@@ -197,6 +198,7 @@ scan_bmapbt(
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			state;
+	int			error;
 
 	/*
 	 * unlike the ag freeblock btrees, if anything looks wrong
@@ -378,6 +380,15 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 	(*tot)++;
 	numrecs = be16_to_cpu(block->bb_numrecs);
 
+	/* Record BMBT blocks in the reverse-mapping data. */
+	if (check_dups && collect_rmaps) {
+		error = add_bmbt_rmap(mp, ino, whichfork, bno);
+		if (error)
+			do_error(
+_("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
+				ino, bno);
+	}
+
 	if (level == 0) {
 		if (numrecs > mp->m_bmap_dmxr[0] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[0])) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
