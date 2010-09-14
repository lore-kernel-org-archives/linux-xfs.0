Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAuOK1121284 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 369451E6531E
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 03:57:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	3IDMuAhcpkktVA7B for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 03:57:12 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39287371-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:27:11 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTC7-0004P2-Lj
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:59 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTBv-0000QM-8z
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/18] xfs: use unhashed buffers for size checks
Date: Tue, 14 Sep 2010 20:56:11 +1000
Message-Id: <1284461777-1496-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When we are checking we can access the last block of each device, we
do not need to use cached buffers as they will be tossed away
immediately. Use uncached buffers for size checks so that all IO
prior to full in-memory structure initialisation does not use the
buffer cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c   |   11 +++++------
 fs/xfs/xfs_mount.c   |   39 ++++++++++++++++-----------------------
 fs/xfs/xfs_rtalloc.c |   29 +++++++++++++----------------
 3 files changed, 34 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 43b1d56..158d5ab 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -144,12 +144,11 @@ xfs_growfs_data_private(
 	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
 		return error;
 	dpct = pct - mp->m_sb.sb_imax_pct;
-	error = xfs_read_buf(mp, mp->m_ddev_targp,
-			XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
-			XFS_FSS_TO_BB(mp, 1), 0, &bp);
-	if (error)
-		return error;
-	ASSERT(bp);
+	bp = xfs_buf_read_uncached(mp, mp->m_ddev_targp,
+				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
+				BBTOB(XFS_FSS_TO_BB(mp, 1)));
+	if (!bp)
+		return EIO;
 	xfs_buf_relse(bp);
 
 	new = nb;	/* use new as a temporary here */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4d727d0..d1498a6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -979,42 +979,35 @@ xfs_check_sizes(xfs_mount_t *mp)
 {
 	xfs_buf_t	*bp;
 	xfs_daddr_t	d;
-	int		error;
 
 	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
-		cmn_err(CE_WARN, "XFS: size check 1 failed");
+		cmn_err(CE_WARN, "XFS: filesystem size mismatch detected");
 		return XFS_ERROR(EFBIG);
 	}
-	error = xfs_read_buf(mp, mp->m_ddev_targp,
-			     d - XFS_FSS_TO_BB(mp, 1),
-			     XFS_FSS_TO_BB(mp, 1), 0, &bp);
-	if (!error) {
-		xfs_buf_relse(bp);
-	} else {
-		cmn_err(CE_WARN, "XFS: size check 2 failed");
-		if (error == ENOSPC)
-			error = XFS_ERROR(EFBIG);
-		return error;
+	bp = xfs_buf_read_uncached(mp, mp->m_ddev_targp,
+					d - XFS_FSS_TO_BB(mp, 1),
+					BBTOB(XFS_FSS_TO_BB(mp, 1)));
+	if (!bp) {
+		cmn_err(CE_WARN, "XFS: last sector read failed");
+		return EIO;
 	}
+	xfs_buf_relse(bp);
 
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
 		d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
-			cmn_err(CE_WARN, "XFS: size check 3 failed");
+			cmn_err(CE_WARN, "XFS: log size mismatch detected");
 			return XFS_ERROR(EFBIG);
 		}
-		error = xfs_read_buf(mp, mp->m_logdev_targp,
-				     d - XFS_FSB_TO_BB(mp, 1),
-				     XFS_FSB_TO_BB(mp, 1), 0, &bp);
-		if (!error) {
-			xfs_buf_relse(bp);
-		} else {
-			cmn_err(CE_WARN, "XFS: size check 3 failed");
-			if (error == ENOSPC)
-				error = XFS_ERROR(EFBIG);
-			return error;
+		bp = xfs_buf_read_uncached(mp, mp->m_logdev_targp,
+					d - XFS_FSB_TO_BB(mp, 1),
+					XFS_FSB_TO_B(mp, 1));
+		if (!bp) {
+			cmn_err(CE_WARN, "XFS: log device read failed");
+			return EIO;
 		}
+		xfs_buf_relse(bp);
 	}
 	return 0;
 }
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 891260f..5c5a4c4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -39,6 +39,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_utils.h"
 #include "xfs_trace.h"
+#include "xfs_buf.h"
 
 
 /*
@@ -1883,13 +1884,13 @@ xfs_growfs_rt(
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
-	error = xfs_read_buf(mp, mp->m_rtdev_targp,
-			XFS_FSB_TO_BB(mp, nrblocks - 1),
-			XFS_FSB_TO_BB(mp, 1), 0, &bp);
-	if (error)
-		return error;
-	ASSERT(bp);
+	bp = xfs_buf_read_uncached(mp, mp->m_rtdev_targp,
+				XFS_FSB_TO_BB(mp, nrblocks - 1),
+				XFS_FSB_TO_B(mp, 1));
+	if (!bp)
+		return EIO;
 	xfs_buf_relse(bp);
+
 	/*
 	 * Calculate new parameters.  These are the final values to be reached.
 	 */
@@ -2215,7 +2216,6 @@ xfs_rtmount_init(
 {
 	xfs_buf_t	*bp;	/* buffer for last block of subvolume */
 	xfs_daddr_t	d;	/* address of last block of subvolume */
-	int		error;	/* error return value */
 	xfs_sb_t	*sbp;	/* filesystem superblock copy in mount */
 
 	sbp = &mp->m_sb;
@@ -2242,15 +2242,12 @@ xfs_rtmount_init(
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return XFS_ERROR(EFBIG);
 	}
-	error = xfs_read_buf(mp, mp->m_rtdev_targp,
-				d - XFS_FSB_TO_BB(mp, 1),
-				XFS_FSB_TO_BB(mp, 1), 0, &bp);
-	if (error) {
-		cmn_err(CE_WARN,
-	"XFS: realtime mount -- xfs_read_buf failed, returned %d", error);
-		if (error == ENOSPC)
-			return XFS_ERROR(EFBIG);
-		return error;
+	bp = xfs_buf_read_uncached(mp, mp->m_rtdev_targp,
+					d - XFS_FSB_TO_BB(mp, 1),
+					XFS_FSB_TO_B(mp, 1));
+	if (!bp) {
+		cmn_err(CE_WARN, "XFS: realtime device size check failed");
+		return EIO;
 	}
 	xfs_buf_relse(bp);
 	return 0;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
