Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C5iZKT072474 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 00:44:36 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VQnXiwjh4Vq7d9Sz for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 22:46:07 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TMY3H-0003Zz-Q7
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:51 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TMY37-00056E-M0
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/23] xfs: verify inode buffers as they are read from disk
Date: Fri, 12 Oct 2012 16:44:15 +1100
Message-Id: <1350020669-19504-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1350020669-19504-1-git-send-email-david@fromorbit.com>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
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

Add an inode buffer verify callback function and pass it into the
buffer read functions. Inodes are special in that the verbose checks
will be done when reading the inode, but we still need to sanity
check the buffer when that is first read. Always verify the magic
numbers in all inodes in the buffer, rather than jus ton debug
kernels.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c |  100 +++++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0b03578..5baf6cb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -382,6 +382,46 @@ xfs_inobp_check(
 }
 #endif
 
+static void
+xfs_inode_buf_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	int		i;
+	int		ni;
+
+	/*
+	 * Validate the magic number and version of every inode in the buffer
+	 */
+	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
+	for (i = 0; i < ni; i++) {
+		int		di_ok;
+		xfs_dinode_t	*dip;
+
+		dip = (struct xfs_dinode *)xfs_buf_offset(bp,
+					(i << mp->m_sb.sb_inodelog));
+		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
+			    XFS_DINODE_GOOD_VERSION(dip->di_version);
+		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
+						XFS_ERRTAG_ITOBP_INOTOBP,
+						XFS_RANDOM_ITOBP_INOTOBP))) {
+			xfs_buf_ioerror(bp, EFSCORRUPTED);
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
+					     mp, dip);
+#ifdef DEBUG
+			xfs_emerg(mp,
+				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
+				(unsigned long long)bp->b_bn, i,
+				be16_to_cpu(dip->di_magic));
+			ASSERT(0);
+#endif
+		}
+	}
+	xfs_inobp_check(mp, bp);
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
 /*
  * This routine is called to map an inode to the buffer containing the on-disk
  * version of the inode.  It returns a pointer to the buffer containing the
@@ -396,71 +436,33 @@ xfs_imap_to_bp(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_imap		*imap,
-	struct xfs_dinode	**dipp,
+	struct xfs_dinode       **dipp,
 	struct xfs_buf		**bpp,
 	uint			buf_flags,
 	uint			iget_flags)
 {
 	struct xfs_buf		*bp;
 	int			error;
-	int			i;
-	int			ni;
 
 	buf_flags |= XBF_UNMAPPED;
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-				   (int)imap->im_len, buf_flags, &bp, NULL);
+				   (int)imap->im_len, buf_flags, &bp,
+				   xfs_inode_buf_verify);
 	if (error) {
-		if (error != EAGAIN) {
-			xfs_warn(mp,
-				"%s: xfs_trans_read_buf() returned error %d.",
-				__func__, error);
-		} else {
+		if (error == EAGAIN) {
 			ASSERT(buf_flags & XBF_TRYLOCK);
+			return error;
 		}
-		return error;
-	}
 
-	/*
-	 * Validate the magic number and version of every inode in the buffer
-	 * (if DEBUG kernel) or the first inode in the buffer, otherwise.
-	 */
-#ifdef DEBUG
-	ni = BBTOB(imap->im_len) >> mp->m_sb.sb_inodelog;
-#else	/* usual case */
-	ni = 1;
-#endif
+		if (error == EFSCORRUPTED &&
+		    (iget_flags & XFS_IGET_UNTRUSTED))
+			return XFS_ERROR(EINVAL);
 
-	for (i = 0; i < ni; i++) {
-		int		di_ok;
-		xfs_dinode_t	*dip;
-
-		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
-					(i << mp->m_sb.sb_inodelog));
-		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_version);
-		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
-						XFS_ERRTAG_ITOBP_INOTOBP,
-						XFS_RANDOM_ITOBP_INOTOBP))) {
-			if (iget_flags & XFS_IGET_UNTRUSTED) {
-				xfs_trans_brelse(tp, bp);
-				return XFS_ERROR(EINVAL);
-			}
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
-					     mp, dip);
-#ifdef DEBUG
-			xfs_emerg(mp,
-				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
-				(unsigned long long)imap->im_blkno, i,
-				be16_to_cpu(dip->di_magic));
-			ASSERT(0);
-#endif
-			xfs_trans_brelse(tp, bp);
-			return XFS_ERROR(EFSCORRUPTED);
-		}
+		xfs_warn(mp, "%s: xfs_trans_read_buf() returned error %d.",
+			__func__, error);
+		return error;
 	}
 
-	xfs_inobp_check(mp, bp);
-
 	*bpp = bp;
 	*dipp = (struct xfs_dinode *)xfs_buf_offset(bp, imap->im_boffset);
 	return 0;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
