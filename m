Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403835AbfFLGu4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:50:56 -0400
Subject: [PATCH 11/14] xfs: refactor iwalk code to handle walking inobt
 records
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:48:42 -0700
Message-ID: <156032212280.3774243.2412398404922269104.stgit@magnolia>
In-Reply-To: <156032205136.3774243.15725828509940520561.stgit@magnolia>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_iwalk_ag_start and xfs_iwalk_ag so that the bits that are
particular to bulkstat (trimming the start irec, starting inode
readahead, and skipping empty groups) can be controlled via flags in the
iwag structure.

This enables us to add a new function to walk all inobt records which
will be used for the new INUMBERS implementation in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_iwalk.h |   12 ++++++++
 2 files changed, 84 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 8c4d7e59f86a..def37347a362 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -62,7 +62,18 @@ struct xfs_iwalk_ag {
 
 	/* Inode walk function and data pointer. */
 	xfs_iwalk_fn			iwalk_fn;
+	xfs_inobt_walk_fn		inobt_walk_fn;
 	void				*data;
+
+	/*
+	 * Make it look like the inodes up to startino are free so that
+	 * bulkstat can start its inode iteration at the correct place without
+	 * needing to special case everywhere.
+	 */
+	unsigned int			trim_start:1;
+
+	/* Skip empty inobt records? */
+	unsigned int			skip_empty:1;
 };
 
 /*
@@ -170,6 +181,16 @@ xfs_iwalk_ag_recs(
 
 		trace_xfs_iwalk_ag_rec(mp, agno, irec);
 
+		if (iwag->inobt_walk_fn) {
+			error = iwag->inobt_walk_fn(mp, tp, agno, irec,
+					iwag->data);
+			if (error)
+				return error;
+		}
+
+		if (!iwag->iwalk_fn)
+			continue;
+
 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
 			/* Skip if this inode is free */
 			if (XFS_INOBT_MASK(j) & irec->ir_free)
@@ -279,7 +300,8 @@ xfs_iwalk_ag_start(
 	 * If agino fell in the middle of the inode record, make it look like
 	 * the inodes up to agino are free so that we don't return them again.
 	 */
-	xfs_iwalk_adjust_start(agino, irec);
+	if (iwag->trim_start)
+		xfs_iwalk_adjust_start(agino, irec);
 
 	/*
 	 * set_prefetch is supposed to give us a large enough inobt record
@@ -372,7 +394,7 @@ xfs_iwalk_ag(
 			break;
 
 		/* No allocated inodes in this chunk; skip it. */
-		if (irec->ir_freecount == irec->ir_count) {
+		if (iwag->skip_empty && irec->ir_freecount == irec->ir_count) {
 			error = xfs_btree_increment(cur, 0, &has_more);
 			if (error)
 				break;
@@ -383,7 +405,8 @@ xfs_iwalk_ag(
 		 * Start readahead for this inode chunk in anticipation of
 		 * walking the inodes.
 		 */
-		xfs_iwalk_ichunk_ra(mp, agno, irec);
+		if (iwag->iwalk_fn)
+			xfs_iwalk_ichunk_ra(mp, agno, irec);
 
 		/*
 		 * If there's space in the buffer for more records, increment
@@ -481,6 +504,8 @@ xfs_iwalk(
 		.iwalk_fn	= iwalk_fn,
 		.data		= data,
 		.startino	= startino,
+		.trim_start	= 1,
+		.skip_empty	= 1,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
@@ -502,3 +527,47 @@ xfs_iwalk(
 	xfs_iwalk_free(&iwag);
 	return error;
 }
+
+/*
+ * Walk all inode btree records in the filesystem starting from @startino.  The
+ * @inobt_walk_fn will be called for each btree record, being passed the incore
+ * record and @data.  @max_prefetch controls how many inobt records we try to
+ * cache ahead of time.
+ */
+int
+xfs_inobt_walk(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		startino,
+	xfs_inobt_walk_fn	inobt_walk_fn,
+	unsigned int		max_prefetch,
+	void			*data)
+{
+	struct xfs_iwalk_ag	iwag = {
+		.mp		= mp,
+		.tp		= tp,
+		.inobt_walk_fn	= inobt_walk_fn,
+		.data		= data,
+		.startino	= startino,
+	};
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
+	int			error;
+
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	/* Translate inumbers record count to inode count. */
+	xfs_iwalk_set_prefetch(&iwag, max_prefetch * XFS_INODES_PER_CHUNK);
+	error = xfs_iwalk_alloc(&iwag);
+	if (error)
+		return error;
+
+	for (; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_iwalk_ag(&iwag);
+		if (error)
+			break;
+		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+	}
+
+	xfs_iwalk_free(&iwag);
+	return error;
+}
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 9e762e31dadc..97c1120d4237 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -16,4 +16,16 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
 
+/* Walk all inode btree records in the filesystem starting from @startino. */
+typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
+				 xfs_agnumber_t agno,
+				 const struct xfs_inobt_rec_incore *irec,
+				 void *data);
+/* Return value (for xfs_inobt_walk_fn) that aborts the walk immediately. */
+#define XFS_INOBT_WALK_ABORT	(XFS_IWALK_ABORT)
+
+int xfs_inobt_walk(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_ino_t startino, xfs_inobt_walk_fn inobt_walk_fn,
+		unsigned int max_prefetch, void *data);
+
 #endif /* __XFS_IWALK_H__ */
