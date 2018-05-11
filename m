Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:59646 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751028AbeEKWvP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 18:51:15 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fHGsX-0008Fv-SV
        for linux-xfs@vger.kernel.org; Sat, 12 May 2018 08:51:09 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fHGsX-0007D2-RD
        for linux-xfs@vger.kernel.org; Sat, 12 May 2018 08:51:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/10] xfs: rework secondary superblock updates in growfs
Date: Sat, 12 May 2018 08:51:05 +1000
Message-Id: <20180511225107.27171-9-david@fromorbit.com>
In-Reply-To: <20180511225107.27171-1-david@fromorbit.com>
References: <20180511225107.27171-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Right now we wait until we've committed changes to the primary
superblock before we initialise any of the new secondary
superblocks. This means that if we have any write errors for new
secondary superblocks we end up with garbage in place rather than
zeros or even an "in progress" superblock to indicate a grow
operation is being done.

To ensure we can write the secondary superblocks, initialise them
earlier in the same loop that initialises the AG headers. We stamp
the new secondary superblocks here with the old geometry, but set
the "sb_inprogress" field to indicate that updates are being done to
the superblock so they cannot be used.  This will result in the
secondary superblock fields being updated or triggering errors that
will abort the grow before we commit any permanent changes.

This also means we can change the update mechanism of the secondary
superblocks.  We know that we are going to wholly overwrite the
information in the struct xfs_sb in the buffer, so there's no point
reading it from disk. Just allocate an uncached buffer, zero it in
memory, stamp the new superblock structure in it and write it out.
If we fail to write it out, then we'll leave the existing sb (old or
new w/ inprogress) on disk for repair to deal with later.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 99 +++++++++++++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 69facd4aa7c1..28692b0e61ce 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -192,6 +192,25 @@ xfs_rmaproot_init(
 	}
 }
 
+/*
+ * Initialise new secondary superblocks with the pre-grow geometry, but mark
+ * them as "in progress" so we know they haven't yet been activated. This will
+ * get cleared when the update with the new geometry information is done after
+ * changes to the primary are committed. This isn't strictly necessary, but we
+ * get it for free with the delayed buffer write lists and it means we can tell
+ * if a grow operation didn't complete properly after the fact.
+ */
+static void
+xfs_sbblock_init(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct aghdr_init_data	*id)
+{
+	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
+
+	xfs_sb_to_disk(dsb, &mp->m_sb);
+	dsb->sb_inprogress = 1;
+}
 
 static void
 xfs_agfblock_init(
@@ -328,6 +347,10 @@ xfs_grow_ag_headers(
 
 {
 	struct xfs_aghdr_grow_data aghdr_data[] = {
+		/* SB */
+		{ XFS_AG_DADDR(mp, id->agno, XFS_SB_DADDR),
+		  XFS_FSS_TO_BB(mp, 1), &xfs_sb_buf_ops,
+		  &xfs_sbblock_init, 0, 0, true },
 		/* AGF */
 		{ XFS_AG_DADDR(mp, id->agno, XFS_AGF_DADDR(mp)),
 		  XFS_FSS_TO_BB(mp, 1), &xfs_agf_buf_ops,
@@ -634,43 +657,30 @@ xfs_growfs_imaxpct(
 
 /*
  * After a grow operation, we need to update all the secondary superblocks
- * to match the new state of the primary. Read/init the superblocks and update
- * them appropriately.
+ * to match the new state of the primary. Because we are completely overwriting
+ * all the existing fields in the secondary superblock buffers, there is no need
+ * to read them in from disk. Just get a new buffer, stamp it and write it.
+ *
+ * The sb buffers need to be cached here so that we serialise against scrub
+ * scanning secondary superblocks, but we don't want to keep it in memory once
+ * it is written so we mark it as a one-shot buffer.
  */
 static int
 xfs_growfs_update_superblocks(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		oagcount)
+	struct xfs_mount	*mp)
 {
-	struct xfs_buf		*bp;
 	xfs_agnumber_t		agno;
 	int			saved_error = 0;
 	int			error = 0;
+	LIST_HEAD		(buffer_list);
 
 	/* update secondary superblocks. */
 	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
-		error = 0;
-		/*
-		 * new secondary superblocks need to be zeroed, not read from
-		 * disk as the contents of the new area we are growing into is
-		 * completely unknown.
-		 */
-		if (agno < oagcount) {
-			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
-				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0, &bp,
-				  &xfs_sb_buf_ops);
-		} else {
-			bp = xfs_trans_get_buf(NULL, mp->m_ddev_targp,
-				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0);
-			if (bp) {
-				bp->b_ops = &xfs_sb_buf_ops;
-				xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-			} else
-				error = -ENOMEM;
-		}
+		struct xfs_buf		*bp;
 
+		bp = xfs_buf_get(mp->m_ddev_targp,
+				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+				 XFS_FSS_TO_BB(mp, 1), 0);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
 		 * continue.  xfs_repair chooses the "best" superblock based
@@ -678,25 +688,42 @@ xfs_growfs_update_superblocks(
 		 * superblocks un-updated than updated, and xfs_repair may
 		 * pick them over the properly-updated primary.
 		 */
-		if (error) {
+		if (!bp) {
 			xfs_warn(mp,
-		"error %d reading secondary superblock for ag %d",
-				error, agno);
-			saved_error = error;
+		"error allocating secondary superblock for ag %d",
+				agno);
+			if (!saved_error)
+				saved_error = -ENOMEM;
 			continue;
 		}
-		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
 
-		error = xfs_bwrite(bp);
+		bp->b_ops = &xfs_sb_buf_ops;
+		xfs_buf_oneshot(bp);
+		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
+		xfs_buf_delwri_queue(bp, &buffer_list);
 		xfs_buf_relse(bp);
+
+		/* don't hold too many buffers at once */
+		if (agno % 16)
+			continue;
+
+		error = xfs_buf_delwri_submit(&buffer_list);
 		if (error) {
 			xfs_warn(mp,
-		"write error %d updating secondary superblock for ag %d",
+		"write error %d updating a secondary superblock near ag %d",
 				error, agno);
-			saved_error = error;
+			if (!saved_error)
+				saved_error = error;
 			continue;
 		}
 	}
+	error = xfs_buf_delwri_submit(&buffer_list);
+	if (error) {
+		xfs_warn(mp,
+		"write error %d updating a secondary superblock near ag %d",
+			error, agno);
+	}
 
 	return saved_error ? saved_error : error;
 }
@@ -711,7 +738,6 @@ xfs_growfs_data(
 	struct xfs_mount	*mp,
 	struct xfs_growfs_data	*in)
 {
-	xfs_agnumber_t		oagcount;
 	int			error = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -726,7 +752,6 @@ xfs_growfs_data(
 			goto out_error;
 	}
 
-	oagcount = mp->m_sb.sb_agcount;
 	if (in->newblocks != mp->m_sb.sb_dblocks) {
 		error = xfs_growfs_data_private(mp, in);
 		if (error)
@@ -742,7 +767,7 @@ xfs_growfs_data(
 		mp->m_maxicount = 0;
 
 	/* Update secondary superblocks now the physical grow has completed */
-	error = xfs_growfs_update_superblocks(mp, oagcount);
+	error = xfs_growfs_update_superblocks(mp);
 
 out_error:
 	/*
-- 
2.17.0

