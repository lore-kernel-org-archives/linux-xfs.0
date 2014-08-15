Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CA6E7F47
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 01:39:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DB59C8F8052
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 23:39:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NlDlE2l2t1H5LwXg for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 23:39:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XIBAL-0001ZX-Dv
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XIBAL-0001Ut-Cp
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] xfs: check xfs_buf_read_uncached returns correctly
Date: Fri, 15 Aug 2014 16:39:07 +1000
Message-Id: <1408084747-4540-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1408084747-4540-1-git-send-email-david@fromorbit.com>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
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

xfs_buf_read_uncached() has two failure modes. If can either return
NULL or bp->b_error != 0 depending on the type of failure, and not
all callers check for both. Fix it up.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 55 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d0ef01e..10a365a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -304,13 +304,8 @@ xfs_readsb(
 reread:
 	bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
 				   BTOBB(sector_size), 0, buf_ops);
-	if (!bp) {
-		if (loud)
-			xfs_warn(mp, "SB buffer read failed");
-		return -EIO;
-	}
-	if (bp->b_error) {
-		error = bp->b_error;
+	if (!bp || bp->b_error) {
+		error = bp ? bp->b_error : -ENOMEM;
 		if (loud)
 			xfs_warn(mp, "SB validate failed with error %d.", error);
 		/* bad CRC means corrupted metadata */
@@ -368,7 +363,8 @@ reread:
 	return 0;
 
 release_buf:
-	xfs_buf_relse(bp);
+	if (bp)
+		xfs_buf_relse(bp);
 	return error;
 }
 
@@ -546,10 +542,12 @@ xfs_set_inoalignment(xfs_mount_t *mp)
  * Check that the data (and log if separate) is an ok size.
  */
 STATIC int
-xfs_check_sizes(xfs_mount_t *mp)
+xfs_check_sizes(
+	struct xfs_mount *mp)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_daddr_t	d;
+	int		error;
 
 	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
@@ -559,28 +557,37 @@ xfs_check_sizes(xfs_mount_t *mp)
 	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
 					d - XFS_FSS_TO_BB(mp, 1),
 					XFS_FSS_TO_BB(mp, 1), 0, NULL);
-	if (!bp) {
+	if (!bp || bp->b_error) {
 		xfs_warn(mp, "last sector read failed");
-		return -EIO;
+		goto out_fail;
 	}
 	xfs_buf_relse(bp);
 
-	if (mp->m_logdev_targp != mp->m_ddev_targp) {
-		d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
-			xfs_warn(mp, "log size mismatch detected");
-			return -EFBIG;
-		}
-		bp = xfs_buf_read_uncached(mp->m_logdev_targp,
+	if (mp->m_logdev_targp == mp->m_ddev_targp)
+		return 0;
+
+	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
+		xfs_warn(mp, "log size mismatch detected");
+		return -EFBIG;
+	}
+	bp = xfs_buf_read_uncached(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
 					XFS_FSB_TO_BB(mp, 1), 0, NULL);
-		if (!bp) {
-			xfs_warn(mp, "log device read failed");
-			return -EIO;
-		}
-		xfs_buf_relse(bp);
+	if (!bp || bp->b_error) {
+		xfs_warn(mp, "log device read failed");
+		goto out_fail;
 	}
+	xfs_buf_relse(bp);
 	return 0;
+
+out_fail:
+	if (!bp)
+		return -EIO;
+	error = bp->b_error;
+	xfs_buf_relse(bp);
+	return error;
+
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
