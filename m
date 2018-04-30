Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36488 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753996AbeD3Pn4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 11:43:56 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 360BE4C1517
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 10:42:44 -0500 (CDT)
Subject: [PATCH 2/5] xfs: factor out secondary superblock updates
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <aecfedfa-6216-80d8-bbac-3dfad639f9c8@sandeen.net>
Date: Mon, 30 Apr 2018 10:43:55 -0500
MIME-Version: 1.0
In-Reply-To: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

growfs rewrites all secondary supers, and relabel should do so as well;
factor out the code which does this for use by both operations.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_fsops.c | 130 +++++++++++++++++++++++++++++++----------------------
 fs/xfs/xfs_fsops.h |   2 +
 2 files changed, 79 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5237927..8f2a73a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -71,6 +71,79 @@
 	return bp;
 }
 
+/*
+ * Copy the contents of the primary super to all backup supers.
+ * %agcount is currently existing AGs
+ * %new_ags is the number of new AGs to write out if we're growing the
+ * filesystem.
+ * We can't use mp->m_sb.sb_agcount here because growfs already updated it.
+ */
+int
+xfs_update_secondary_supers(
+	xfs_mount_t		*mp,
+	xfs_agnumber_t		agcount,
+	xfs_agnumber_t		new_ags)
+{
+	int			error, saved_error;
+	xfs_agnumber_t		agno;
+	xfs_buf_t		*bp;
+
+	error = saved_error = 0;
+
+	/* update secondary superblocks. */
+	for (agno = 1; agno < agcount + new_ags; agno++) {
+		error = 0;
+		/*
+		 * new secondary superblocks need to be zeroed, not read from
+		 * disk as the contents of the new area we are growing into is
+		 * completely unknown.
+		 */
+		if (agno < agcount) {
+			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+				  XFS_FSS_TO_BB(mp, 1), 0, &bp,
+				  &xfs_sb_buf_ops);
+		} else {
+			bp = xfs_trans_get_buf(NULL, mp->m_ddev_targp,
+				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+				  XFS_FSS_TO_BB(mp, 1), 0);
+			if (bp) {
+				bp->b_ops = &xfs_sb_buf_ops;
+				xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+			} else
+				error = -ENOMEM;
+		}
+
+		/*
+		 * If we get an error reading or writing alternate superblocks,
+		 * continue.  xfs_repair chooses the "best" superblock based
+		 * on most matches; if we break early, we'll leave more
+		 * superblocks un-updated than updated, and xfs_repair may
+		 * pick them over the properly-updated primary.
+		 */
+		if (error) {
+			xfs_warn(mp,
+		"error %d reading secondary superblock for ag %d",
+				error, agno);
+			saved_error = error;
+			continue;
+		}
+		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
+
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error) {
+			xfs_warn(mp,
+		"write error %d updating secondary superblock for ag %d",
+				error, agno);
+			saved_error = error;
+			continue;
+		}
+	}
+
+	return saved_error ? saved_error : error;
+}
+
 static int
 xfs_growfs_data_private(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
@@ -86,7 +159,7 @@
 	xfs_buf_t		*bp;
 	int			bucket;
 	int			dpct;
-	int			error, saved_error = 0;
+	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_mod;
@@ -557,59 +630,10 @@
 	if (error && error != -ENOSPC)
 		goto out;
 
-	/* update secondary superblocks. */
-	for (agno = 1; agno < nagcount; agno++) {
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
-
-		/*
-		 * If we get an error reading or writing alternate superblocks,
-		 * continue.  xfs_repair chooses the "best" superblock based
-		 * on most matches; if we break early, we'll leave more
-		 * superblocks un-updated than updated, and xfs_repair may
-		 * pick them over the properly-updated primary.
-		 */
-		if (error) {
-			xfs_warn(mp,
-		"error %d reading secondary superblock for ag %d",
-				error, agno);
-			saved_error = error;
-			continue;
-		}
-		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
-
-		error = xfs_bwrite(bp);
-		xfs_buf_relse(bp);
-		if (error) {
-			xfs_warn(mp,
-		"write error %d updating secondary superblock for ag %d",
-				error, agno);
-			saved_error = error;
-			continue;
-		}
-	}
-
+	/* Copy new geometry to all backup superblocks, old & new */
+	error = xfs_update_secondary_supers(mp, oagcount, nagcount - oagcount);
  out:
-	return saved_error ? saved_error : error;
+	return error;
 
  error0:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 20484ed..ffc5377 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_FSOPS_H__
 #define	__XFS_FSOPS_H__
 
+extern int xfs_update_secondary_supers(xfs_mount_t *mp, xfs_agnumber_t agcount,
+				xfs_agnumber_t new_ags);
 extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
 extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
 extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
-- 
1.8.3.1

