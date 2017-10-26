Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:65339 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932386AbdJZIdg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:36 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003Cl-Kw
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005MU-Jd
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/14] xfs: rework secondary superblock updates in growfs
Date: Thu, 26 Oct 2017 19:33:15 +1100
Message-Id: <20171026083322.20428-8-david@fromorbit.com>
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
References: <20171026083322.20428-1-david@fromorbit.com>
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
information in the struct xfs_sb in teh buffer, so there's no point
reading it from disk. Just allocate an uncached buffer, zero it in
memory, stamp the new superblock structure in it and write it out.
If we fail to write it out, then we'll leave the existing sb (old or
new w/ inprogress) on disk for reapir to deal with later.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 92 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 55 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a4da710521f5..34c9fc257c2f 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -274,6 +274,25 @@ xfs_rmaproot_init(
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
@@ -410,6 +429,10 @@ xfs_grow_ag_headers(
 
 {
 	struct xfs_aghdr_grow_data aghdr_data[] = {
+		/* SB */
+		{ XFS_AG_DADDR(mp, id->agno, XFS_SB_DADDR),
+		  XFS_FSS_TO_BB(mp, 1), &xfs_sb_buf_ops,
+		  &xfs_sbblock_init, 0, 0, true },
 		/* AGF */
 		{ XFS_AG_DADDR(mp, id->agno, XFS_AGF_DADDR(mp)),
 		  XFS_FSS_TO_BB(mp, 1), &xfs_agf_buf_ops,
@@ -702,43 +725,27 @@ xfs_growfs_imaxpct(
 
 /*
  * After a grow operation, we need to update all the secondary superblocks
- * to match the new state of the primary. Read/init the superblocks and update
- * them appropriately.
+ * to match the new state of the primary. Because we are completely overwriting
+ * all the existing fields in the secondary superblock buffers, there is no need
+ * to read them in from disk. Just get a new uncached buffer, stamp it and
+ * write it.
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
 
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
 		 * continue.  xfs_repair chooses the "best" superblock based
@@ -746,25 +753,38 @@ xfs_growfs_update_superblocks(
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
 		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
-
-		error = xfs_bwrite(bp);
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
@@ -779,7 +799,6 @@ xfs_growfs_data(
 	struct xfs_mount	*mp,
 	struct xfs_growfs_data	*in)
 {
-	xfs_agnumber_t		oagcount;
 	int			error = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -794,7 +813,6 @@ xfs_growfs_data(
 			goto out_error;
 	}
 
-	oagcount = mp->m_sb.sb_agcount;
 	error = xfs_growfs_data_private(mp, in);
 	if (error)
 		goto out_error;
@@ -812,7 +830,7 @@ xfs_growfs_data(
 	/*
 	 * Update secondary superblocks now the physical grow has completed
 	 */
-	error = xfs_growfs_update_superblocks(mp, oagcount);
+	error = xfs_growfs_update_superblocks(mp);
 
 out_error:
 	/*
-- 
2.15.0.rc0

