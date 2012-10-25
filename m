Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9P6Wp3c102358 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 01:32:51 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ChyDKBDVKB8yqjAI for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 23:34:34 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TRH1Q-00009z-59
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:28 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TRH1G-00053i-1F
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/25] xfs: verify superblocks as they are read from disk
Date: Thu, 25 Oct 2012 17:33:54 +1100
Message-Id: <1351146854-19343-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1351146854-19343-1-git-send-email-david@fromorbit.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
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

Add a superblock verify callback function and pass it into the
buffer read functions. Remove the now redundant verification code
that is currently in use.

Adding verification shows that secondary superblocks never have
their "sb_inprogress" flag cleared by mkfs.xfs, so when validating
the secondary superblocks during a grow operation we have to avoid
checking this field. Even if we fix mkfs, we will still have to
ignore this field for verification purposes unless a version of mkfs
that does not have this bug was used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c       |    4 +-
 fs/xfs/xfs_log_recover.c |    5 ++-
 fs/xfs/xfs_mount.c       |   98 +++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_mount.h       |    3 +-
 4 files changed, 69 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index dee14eb..302b99c 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -413,7 +413,8 @@ xfs_growfs_data_private(
 		if (agno < oagcount) {
 			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+				  XFS_FSS_TO_BB(mp, 1), 0, &bp,
+				  xfs_sb_read_verify);
 		} else {
 			bp = xfs_trans_get_buf(NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
@@ -431,6 +432,7 @@ xfs_growfs_data_private(
 			break;
 		}
 		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
+
 		/*
 		 * If we get an error writing out the alternate superblocks,
 		 * just issue a warning and continue.  The real work is
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 757688a..4cf7ae8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3692,13 +3692,14 @@ xlog_do_recover(
 
 	/*
 	 * Now that we've finished replaying all buffer and inode
-	 * updates, re-read in the superblock.
+	 * updates, re-read in the superblock and reverify it.
 	 */
 	bp = xfs_getsb(log->l_mp, 0);
 	XFS_BUF_UNDONE(bp);
 	ASSERT(!(XFS_BUF_ISWRITE(bp)));
 	XFS_BUF_READ(bp);
 	XFS_BUF_UNASYNC(bp);
+	bp->b_iodone = xfs_sb_read_verify;
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
 	if (error) {
@@ -3710,7 +3711,7 @@ xlog_do_recover(
 
 	/* Convert superblock from on-disk format */
 	sbp = &log->l_mp->m_sb;
-	xfs_sb_from_disk(log->l_mp, XFS_BUF_TO_SBP(bp));
+	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
 	ASSERT(sbp->sb_magicnum == XFS_SB_MAGIC);
 	ASSERT(xfs_sb_good_version(sbp));
 	xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index dc51e32..8699e5e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -304,9 +304,8 @@ STATIC int
 xfs_mount_validate_sb(
 	xfs_mount_t	*mp,
 	xfs_sb_t	*sbp,
-	int		flags)
+	bool		check_inprogress)
 {
-	int		loud = !(flags & XFS_MFSI_QUIET);
 
 	/*
 	 * If the log device and data device have the
@@ -316,21 +315,18 @@ xfs_mount_validate_sb(
 	 * a volume filesystem in a non-volume manner.
 	 */
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
-		if (loud)
-			xfs_warn(mp, "bad magic number");
+		xfs_warn(mp, "bad magic number");
 		return XFS_ERROR(EWRONGFS);
 	}
 
 	if (!xfs_sb_good_version(sbp)) {
-		if (loud)
-			xfs_warn(mp, "bad version");
+		xfs_warn(mp, "bad version");
 		return XFS_ERROR(EWRONGFS);
 	}
 
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
-		if (loud)
-			xfs_warn(mp,
+		xfs_warn(mp,
 		"filesystem is marked as having an external log; "
 		"specify logdev on the mount command line.");
 		return XFS_ERROR(EINVAL);
@@ -338,8 +334,7 @@ xfs_mount_validate_sb(
 
 	if (unlikely(
 	    sbp->sb_logstart != 0 && mp->m_logdev_targp != mp->m_ddev_targp)) {
-		if (loud)
-			xfs_warn(mp,
+		xfs_warn(mp,
 		"filesystem is marked as having an internal log; "
 		"do not specify logdev on the mount command line.");
 		return XFS_ERROR(EINVAL);
@@ -373,8 +368,7 @@ xfs_mount_validate_sb(
 	    sbp->sb_dblocks == 0					||
 	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
 	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp))) {
-		if (loud)
-			XFS_CORRUPTION_ERROR("SB sanity check failed",
+		XFS_CORRUPTION_ERROR("SB sanity check failed",
 				XFS_ERRLEVEL_LOW, mp, sbp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
@@ -383,12 +377,10 @@ xfs_mount_validate_sb(
 	 * Until this is fixed only page-sized or smaller data blocks work.
 	 */
 	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
-		if (loud) {
-			xfs_warn(mp,
+		xfs_warn(mp,
 		"File system with blocksize %d bytes. "
 		"Only pagesize (%ld) or less will currently work.",
 				sbp->sb_blocksize, PAGE_SIZE);
-		}
 		return XFS_ERROR(ENOSYS);
 	}
 
@@ -402,23 +394,20 @@ xfs_mount_validate_sb(
 	case 2048:
 		break;
 	default:
-		if (loud)
-			xfs_warn(mp, "inode size of %d bytes not supported",
+		xfs_warn(mp, "inode size of %d bytes not supported",
 				sbp->sb_inodesize);
 		return XFS_ERROR(ENOSYS);
 	}
 
 	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
 	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
-		if (loud)
-			xfs_warn(mp,
+		xfs_warn(mp,
 		"file system too large to be mounted on this system.");
 		return XFS_ERROR(EFBIG);
 	}
 
-	if (unlikely(sbp->sb_inprogress)) {
-		if (loud)
-			xfs_warn(mp, "file system busy");
+	if (check_inprogress && sbp->sb_inprogress) {
+		xfs_warn(mp, "Offline file system operation in progress!");
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
@@ -426,9 +415,7 @@ xfs_mount_validate_sb(
 	 * Version 1 directory format has never worked on Linux.
 	 */
 	if (unlikely(!xfs_sb_version_hasdirv2(sbp))) {
-		if (loud)
-			xfs_warn(mp,
-				"file system using version 1 directory format");
+		xfs_warn(mp, "file system using version 1 directory format");
 		return XFS_ERROR(ENOSYS);
 	}
 
@@ -521,11 +508,9 @@ out_unwind:
 
 void
 xfs_sb_from_disk(
-	struct xfs_mount	*mp,
+	struct xfs_sb	*to,
 	xfs_dsb_t	*from)
 {
-	struct xfs_sb *to = &mp->m_sb;
-
 	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
 	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
 	to->sb_dblocks = be64_to_cpu(from->sb_dblocks);
@@ -627,6 +612,50 @@ xfs_sb_to_disk(
 	}
 }
 
+void
+xfs_sb_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_sb	sb;
+	int		error;
+
+	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
+
+	/*
+	 * Only check the in progress field for the primary superblock as
+	 * mkfs.xfs doesn't clear it from secondary superblocks.
+	 */
+	error = xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR);
+	if (error)
+		xfs_buf_ioerror(bp, error);
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
+/*
+ * We may be probed for a filesystem match, so we may not want to emit
+ * messages when the superblock buffer is not actually an XFS superblock.
+ * If we find an XFS superblock, the run a normal, noisy mount because we are
+ * really going to mount it and want to know about errors.
+ */
+void
+xfs_sb_quiet_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_sb	sb;
+
+	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
+
+	if (sb.sb_magicnum == XFS_SB_MAGIC) {
+		/* XFS filesystem, verify noisily! */
+		xfs_sb_read_verify(bp);
+		return;
+	}
+	/* quietly fail */
+	xfs_buf_ioerror(bp, EFSCORRUPTED);
+}
+
 /*
  * xfs_readsb
  *
@@ -652,7 +681,9 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 
 reread:
 	bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-					BTOBB(sector_size), 0, NULL);
+				   BTOBB(sector_size), 0,
+				   loud ? xfs_sb_read_verify
+				        : xfs_sb_quiet_read_verify);
 	if (!bp) {
 		if (loud)
 			xfs_warn(mp, "SB buffer read failed");
@@ -667,15 +698,8 @@ reread:
 
 	/*
 	 * Initialize the mount structure from the superblock.
-	 * But first do some basic consistency checking.
 	 */
-	xfs_sb_from_disk(mp, XFS_BUF_TO_SBP(bp));
-	error = xfs_mount_validate_sb(mp, &(mp->m_sb), flags);
-	if (error) {
-		if (loud)
-			xfs_warn(mp, "SB validate failed");
-		goto release_buf;
-	}
+	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
 
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a631ca3..82b8fda 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -382,10 +382,11 @@ extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
 #endif	/* __KERNEL__ */
 
+extern void	xfs_sb_read_verify(struct xfs_buf *);
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
 extern int	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t,
 					xfs_agnumber_t *);
-extern void	xfs_sb_from_disk(struct xfs_mount *, struct xfs_dsb *);
+extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 
 #endif	/* __XFS_MOUNT_H__ */
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
