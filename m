Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 56CBD7CA6
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:40:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2ACEB304039
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 09:40:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XtoMUqgADzzrAlI1 for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2016 09:39:59 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 32D084A6
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:39:59 -0500 (CDT)
Subject: [PATCH 2/4] xfs: factor out secondary superblock updates
References: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <35aeba74-5045-a00e-bb62-e7bdcd32fae8@sandeen.net>
Date: Thu, 9 Jun 2016 11:39:58 -0500
MIME-Version: 1.0
In-Reply-To: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
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
To: xfs@oss.sgi.com

growfs rewrites all secondary supers, and relabel must
do so as well; factor out the code which does this for
use by both operations.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_fsops.c |  131 +++++++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_fsops.h |    2 +
 2 files changed, 80 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b4d7582..b49b4e4 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -140,6 +140,79 @@ xfs_growfs_get_hdr_buf(
 	return bp;
 }
 
+/*
+ * Copy the contents of the primary super to all backup supers.
+ * %agcount is current number of ags in the filesystem.
+ * %nagcount is used during growfs when we may have new secondaries.
+ * If %nagcount is 0 (no growfs), we use %agcount in its place.
+ */
+int
+xfs_update_secondary_supers(
+	xfs_mount_t		*mp,
+	xfs_agnumber_t		agcount,
+	xfs_agnumber_t		nagcount)
+{
+	int			error, saved_error;
+	xfs_agnumber_t		agno;
+	xfs_buf_t		*bp;
+
+	error = saved_error = 0;
+
+	if (nagcount == 0)
+		nagcount = agcount;
+
+	for (agno = 1; agno < nagcount; agno++) {
+		error = 0;
+		if (agno < agcount) {
+			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+				  XFS_FSS_TO_BB(mp, 1), 0, &bp,
+				  &xfs_sb_buf_ops);
+		} else {
+			/*
+			 * new secondary superblocks need to be zeroed, not read
+			 * from disk as the contents of the new area we are
+			 * growing into is completely unknown.
+			 */
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
+	return saved_error ? saved_error : error;
+}
+
 static int
 xfs_growfs_data_private(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
@@ -155,7 +228,7 @@ xfs_growfs_data_private(
 	xfs_buf_t		*bp;
 	int			bucket;
 	int			dpct;
-	int			error, saved_error = 0;
+	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_mod;
@@ -502,59 +575,11 @@ xfs_growfs_data_private(
 		mp->m_maxicount = 0;
 	xfs_set_low_space_thresholds(mp);
 
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
-	return saved_error ? saved_error : error;
+	/* Copy new geometry to all backup superblocks */
+	error = xfs_update_secondary_supers(mp, oagcount, nagcount);
+	return error;
 
- error0:
+error0:
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index f32713f..82e8dc7 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -19,6 +19,8 @@
 #define	__XFS_FSOPS_H__
 
 extern int xfs_fs_geometry(xfs_mount_t *mp, xfs_fsop_geom_t *geo, int nversion);
+extern int xfs_update_secondary_supers(xfs_mount_t *mp, xfs_agnumber_t aogcount,
+					xfs_agnumber_t nagcount);
 extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
 extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
 extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
-- 
1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
