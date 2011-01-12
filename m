Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0YQIV124098 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:34:26 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C49E71D26420
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	gn0luySehMtgHVjD for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:37 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52410144-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:36 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohM-0000Uc-Ab
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:24 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogu-0002GI-Sh
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/12] xfs: kill xfs_fs_mount_cmn_err() macro
Date: Wed, 12 Jan 2011 11:35:48 +1100
Message-Id: <1294792553-8378-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
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

The xfs_fs_mount_cmn_err() hide a simple check as to whether the
mount path should output an error or not. Remove the macro and open
code the check.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_error.h |    6 ----
 fs/xfs/xfs_mount.c |   72 +++++++++++++++++++++++++++++++---------------------
 2 files changed, 43 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 4c8b500..e836051 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -162,10 +162,4 @@ struct xfs_mount;
 
 extern void xfs_hex_dump(void *p, int length);
 
-#define xfs_fs_mount_cmn_err(f, fmt, args...) \
-	do { \
-		if (!(f & XFS_MFSI_QUIET)) 	\
-			cmn_err(CE_WARN, "XFS: " fmt, ## args); \
-	} while (0)
-
 #endif	/* __XFS_ERROR_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d447aef..1b43ad3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -311,6 +311,8 @@ xfs_mount_validate_sb(
 	xfs_sb_t	*sbp,
 	int		flags)
 {
+	int		loud = !(flags & XFS_MFSI_QUIET);
+
 	/*
 	 * If the log device and data device have the
 	 * same device number, the log is internal.
@@ -319,28 +321,32 @@ xfs_mount_validate_sb(
 	 * a volume filesystem in a non-volume manner.
 	 */
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
-		xfs_fs_mount_cmn_err(flags, "bad magic number");
+		if (loud)
+			xfs_warn(mp, "bad magic number");
 		return XFS_ERROR(EWRONGFS);
 	}
 
 	if (!xfs_sb_good_version(sbp)) {
-		xfs_fs_mount_cmn_err(flags, "bad version");
+		if (loud)
+			xfs_warn(mp, "bad version");
 		return XFS_ERROR(EWRONGFS);
 	}
 
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
-		xfs_fs_mount_cmn_err(flags,
-			"filesystem is marked as having an external log; "
-			"specify logdev on the\nmount command line.");
+		if (loud)
+			xfs_warn(mp,
+		"filesystem is marked as having an external log; "
+		"specify logdev on the mount command line.");
 		return XFS_ERROR(EINVAL);
 	}
 
 	if (unlikely(
 	    sbp->sb_logstart != 0 && mp->m_logdev_targp != mp->m_ddev_targp)) {
-		xfs_fs_mount_cmn_err(flags,
-			"filesystem is marked as having an internal log; "
-			"do not specify logdev on\nthe mount command line.");
+		if (loud)
+			xfs_warn(mp,
+		"filesystem is marked as having an internal log; "
+		"do not specify logdev on the mount command line.");
 		return XFS_ERROR(EINVAL);
 	}
 
@@ -369,7 +375,8 @@ xfs_mount_validate_sb(
 	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
 	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||
 	    (sbp->sb_imax_pct > 100 /* zero sb_imax_pct is valid */))) {
-		xfs_fs_mount_cmn_err(flags, "SB sanity check 1 failed");
+		if (loud)
+			xfs_warn(mp, "SB sanity check 1 failed");
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
@@ -382,7 +389,8 @@ xfs_mount_validate_sb(
 	     (xfs_drfsbno_t)sbp->sb_agcount * sbp->sb_agblocks ||
 	    sbp->sb_dblocks < (xfs_drfsbno_t)(sbp->sb_agcount - 1) *
 			      sbp->sb_agblocks + XFS_MIN_AG_BLOCKS)) {
-		xfs_fs_mount_cmn_err(flags, "SB sanity check 2 failed");
+		if (loud)
+			xfs_warn(mp, "SB sanity check 2 failed");
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
@@ -390,12 +398,12 @@ xfs_mount_validate_sb(
 	 * Until this is fixed only page-sized or smaller data blocks work.
 	 */
 	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
-		xfs_fs_mount_cmn_err(flags,
-			"file system with blocksize %d bytes",
-			sbp->sb_blocksize);
-		xfs_fs_mount_cmn_err(flags,
-			"only pagesize (%ld) or less will currently work.",
-			PAGE_SIZE);
+		if (loud) {
+			xfs_warn(mp,
+		"File system with blocksize %d bytes. "
+		"Only pagesize (%ld) or less will currently work.",
+				sbp->sb_blocksize, PAGE_SIZE);
+		}
 		return XFS_ERROR(ENOSYS);
 	}
 
@@ -409,21 +417,23 @@ xfs_mount_validate_sb(
 	case 2048:
 		break;
 	default:
-		xfs_fs_mount_cmn_err(flags,
-			"inode size of %d bytes not supported",
-			sbp->sb_inodesize);
+		if (loud)
+			xfs_warn(mp, "inode size of %d bytes not supported",
+				sbp->sb_inodesize);
 		return XFS_ERROR(ENOSYS);
 	}
 
 	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
 	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
-		xfs_fs_mount_cmn_err(flags,
-			"file system too large to be mounted on this system.");
+		if (loud)
+			xfs_warn(mp,
+		"file system too large to be mounted on this system.");
 		return XFS_ERROR(EFBIG);
 	}
 
 	if (unlikely(sbp->sb_inprogress)) {
-		xfs_fs_mount_cmn_err(flags, "file system busy");
+		if (loud)
+			xfs_warn(mp, "file system busy");
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
@@ -431,8 +441,9 @@ xfs_mount_validate_sb(
 	 * Version 1 directory format has never worked on Linux.
 	 */
 	if (unlikely(!xfs_sb_version_hasdirv2(sbp))) {
-		xfs_fs_mount_cmn_err(flags,
-			"file system using version 1 directory format");
+		if (loud)
+			xfs_warn(mp,
+				"file system using version 1 directory format");
 		return XFS_ERROR(ENOSYS);
 	}
 
@@ -673,6 +684,7 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	unsigned int	sector_size;
 	xfs_buf_t	*bp;
 	int		error;
+	int		loud = !(flags & XFS_MFSI_QUIET);
 
 	ASSERT(mp->m_sb_bp == NULL);
 	ASSERT(mp->m_ddev_targp != NULL);
@@ -688,7 +700,8 @@ reread:
 	bp = xfs_buf_read_uncached(mp, mp->m_ddev_targp,
 					XFS_SB_DADDR, sector_size, 0);
 	if (!bp) {
-		xfs_fs_mount_cmn_err(flags, "SB buffer read failed");
+		if (loud)
+			xfs_warn(mp, "SB buffer read failed");
 		return EIO;
 	}
 
@@ -699,7 +712,8 @@ reread:
 	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
 	error = xfs_mount_validate_sb(mp, &(mp->m_sb), flags);
 	if (error) {
-		xfs_fs_mount_cmn_err(flags, "SB validate failed");
+		if (loud)
+			xfs_warn(mp, "SB validate failed");
 		goto release_buf;
 	}
 
@@ -707,9 +721,9 @@ reread:
 	 * We must be able to do sector-sized and sector-aligned IO.
 	 */
 	if (sector_size > mp->m_sb.sb_sectsize) {
-		xfs_fs_mount_cmn_err(flags,
-			"device supports only %u byte sectors (not %u)",
-			sector_size, mp->m_sb.sb_sectsize);
+		if (loud)
+			xfs_warn(mp, "device supports %u byte sectors (not %u)",
+				sector_size, mp->m_sb.sb_sectsize);
 		error = ENOSYS;
 		goto release_buf;
 	}
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
