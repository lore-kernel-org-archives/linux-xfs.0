Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 417EB29E40
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:08:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3102F8F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:08:27 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HzymBJGuXPt2hupA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:08:25 -0800 (PST)
Subject: [PATCH 31/53] xfs_repair: add inode bmbt block rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:08:22 -0800
Message-ID: <20151219090822.14255.58612.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
 repair/rmap.c |   32 ++++++++++++++++++++++++++++++++
 repair/rmap.h |    1 +
 repair/scan.c |   11 +++++++++++
 3 files changed, 44 insertions(+)


diff --git a/repair/rmap.c b/repair/rmap.c
index f3363f7..40bdae3 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -207,6 +207,38 @@ __add_raw_rmap(
 }
 
 /**
+ * add_bmbt_rmap() -- Add an observation about a bmbt block for later
+ *               btree reconstruction.
+ *
+ * @mp:	XFS mount object.
+ * @ino: The inode number associated with the extent mapping.
+ * @whichfork: Data or attribute fork?
+ * @fsbno: fsblock number of the bmbt block
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
+/**
  * add_ag_rmap() -- Add an reverse mapping for a per-AG fixed metadata object.
  *
  * @mp:	XFS mount object.
diff --git a/repair/rmap.h b/repair/rmap.h
index 51e916b..57d56a0 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -28,6 +28,7 @@ extern void free_rmaps(struct xfs_mount *);
 extern int add_rmap(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
 extern int add_ag_rmap(struct xfs_mount *, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
+extern int add_bmbt_rmap(struct xfs_mount *, xfs_ino_t, int, xfs_fsblock_t);
 extern int fold_raw_rmaps(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 #endif /* RMAP_H_ */
diff --git a/repair/scan.c b/repair/scan.c
index 1ade344..db9e131 100644
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
