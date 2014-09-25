Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73BFD7FB2
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4455B304059
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	u4NZLGkSNQAomsXw for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006nJ-WC
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:24 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007h3-V6
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/11] xfs: check xfs_buf_read_uncached returns correctly
Date: Thu, 25 Sep 2014 22:34:20 +1000
Message-Id: <1411648461-29003-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1411648461-29003-1-git-send-email-david@fromorbit.com>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_buf.c     | 18 ++++++++++++----
 fs/xfs/xfs_buf.h     |  6 +++---
 fs/xfs/xfs_fsops.c   | 11 +++-------
 fs/xfs/xfs_mount.c   | 58 +++++++++++++++++++++++++---------------------------
 fs/xfs/xfs_rtalloc.c | 30 +++++++++++----------------
 5 files changed, 60 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d1d3fe6..0ac54a0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -688,29 +688,39 @@ xfs_buf_readahead_map(
  * Read an uncached buffer from disk. Allocates and returns a locked
  * buffer containing the disk contents or nothing.
  */
-struct xfs_buf *
+int
 xfs_buf_read_uncached(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		daddr,
 	size_t			numblks,
 	int			flags,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
 
+	*bpp = NULL;
+
 	bp = xfs_buf_get_uncached(target, numblks, flags);
 	if (!bp)
-		return NULL;
+		return ENOMEM;
 
 	/* set up the buffer for a read IO */
 	ASSERT(bp->b_map_count == 1);
-	bp->b_bn = daddr;
+	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
 	bp->b_maps[0].bm_bn = daddr;
 	bp->b_flags |= XBF_READ;
 	bp->b_ops = ops;
 
 	xfs_buf_submit_wait(bp);
-	return bp;
+	if (bp->b_error) {
+		int	error = bp->b_error;
+		xfs_buf_relse(bp);
+		return error;
+	}
+
+	*bpp = bp;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 0acfc30..82002c0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -269,9 +269,9 @@ int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
 
 struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 				int flags);
-struct xfs_buf *xfs_buf_read_uncached(struct xfs_buftarg *target,
-				xfs_daddr_t daddr, size_t numblks, int flags,
-				const struct xfs_buf_ops *ops);
+int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
+			  size_t numblks, int flags, struct xfs_buf **bpp,
+			  const struct xfs_buf_ops *ops);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 126b4b3..ece69c2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -172,16 +172,11 @@ xfs_growfs_data_private(
 	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
 		return error;
 	dpct = pct - mp->m_sb.sb_imax_pct;
-	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
+	error = xfs_buf_read_uncached(mp->m_ddev_targp,
 				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
-				XFS_FSS_TO_BB(mp, 1), 0, NULL);
-	if (!bp)
-		return -EIO;
-	if (bp->b_error) {
-		error = bp->b_error;
-		xfs_buf_relse(bp);
+				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
 		return error;
-	}
 	xfs_buf_relse(bp);
 
 	new = nb;	/* use new as a temporary here */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 78a2799..2adf6ce 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -300,21 +300,15 @@ xfs_readsb(
 	 * access to the superblock.
 	 */
 reread:
-	bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-				   BTOBB(sector_size), 0, buf_ops);
-	if (!bp) {
-		if (loud)
-			xfs_warn(mp, "SB buffer read failed");
-		return -EIO;
-	}
-	if (bp->b_error) {
-		error = bp->b_error;
+	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
+				   BTOBB(sector_size), 0, &bp, buf_ops);
+	if (error) {
 		if (loud)
 			xfs_warn(mp, "SB validate failed with error %d.", error);
 		/* bad CRC means corrupted metadata */
 		if (error == -EFSBADCRC)
 			error = -EFSCORRUPTED;
-		goto release_buf;
+		return error;
 	}
 
 	/*
@@ -366,7 +360,8 @@ reread:
 	return 0;
 
 release_buf:
-	xfs_buf_relse(bp);
+	if (bp)
+		xfs_buf_relse(bp);
 	return error;
 }
 
@@ -544,40 +539,43 @@ xfs_set_inoalignment(xfs_mount_t *mp)
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
 		xfs_warn(mp, "filesystem size mismatch detected");
 		return -EFBIG;
 	}
-	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
+	error = xfs_buf_read_uncached(mp->m_ddev_targp,
 					d - XFS_FSS_TO_BB(mp, 1),
-					XFS_FSS_TO_BB(mp, 1), 0, NULL);
-	if (!bp) {
+					XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
 		xfs_warn(mp, "last sector read failed");
-		return -EIO;
+		return error;
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
+	error = xfs_buf_read_uncached(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0, NULL);
-		if (!bp) {
-			xfs_warn(mp, "log device read failed");
-			return -EIO;
-		}
-		xfs_buf_relse(bp);
+					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
+		xfs_warn(mp, "log device read failed");
+		return error;
 	}
+	xfs_buf_relse(bp);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d45aebe..e1175ea 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -921,16 +921,11 @@ xfs_growfs_rt(
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
-	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, nrblocks - 1),
-				XFS_FSB_TO_BB(mp, 1), 0, NULL);
-	if (!bp)
-		return -EIO;
-	if (bp->b_error) {
-		error = bp->b_error;
-		xfs_buf_relse(bp);
+				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
 		return error;
-	}
 	xfs_buf_relse(bp);
 
 	/*
@@ -1184,11 +1179,12 @@ xfs_rtallocate_extent(
  */
 int				/* error */
 xfs_rtmount_init(
-	xfs_mount_t	*mp)	/* file system mount structure */
+	struct xfs_mount	*mp)	/* file system mount structure */
 {
-	xfs_buf_t	*bp;	/* buffer for last block of subvolume */
-	xfs_daddr_t	d;	/* address of last block of subvolume */
-	xfs_sb_t	*sbp;	/* filesystem superblock copy in mount */
+	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
+	struct xfs_sb		*sbp;	/* filesystem superblock copy in mount */
+	xfs_daddr_t		d;	/* address of last block of subvolume */
+	int			error;
 
 	sbp = &mp->m_sb;
 	if (sbp->sb_rblocks == 0)
@@ -1214,14 +1210,12 @@ xfs_rtmount_init(
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return -EFBIG;
 	}
-	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0, NULL);
-	if (!bp || bp->b_error) {
+					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
 		xfs_warn(mp, "realtime device size check failed");
-		if (bp)
-			xfs_buf_relse(bp);
-		return -EIO;
+		return error;
 	}
 	xfs_buf_relse(bp);
 	return 0;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
