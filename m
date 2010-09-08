Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88FCTv7042702 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 10:12:30 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D46C58301
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 08:13:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	f4pMkW9NZaXGQsGy for <xfs@oss.sgi.com>;
	Wed, 08 Sep 2010 08:13:12 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38385293-1927428
	for <xfs@oss.sgi.com>; Thu, 09 Sep 2010 00:43:11 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OtMKj-0003zB-Iw
	for xfs@oss.sgi.com; Thu, 09 Sep 2010 01:13:09 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OtMKc-0007TQ-Cn
	for xfs@oss.sgi.com; Thu, 09 Sep 2010 01:13:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: use unhashed buffers for size checks
Date: Thu,  9 Sep 2010 01:12:56 +1000
Message-Id: <1283958778-28610-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1283958778-28610-1-git-send-email-david@fromorbit.com>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
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
do not need to use hashed buffers as they will be tossed away
immediately. Use unhashed buffers for size checks so that all IO
prior to full in-memory structure initialisation does not use the
buffer cache hashes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   36 ++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_buf.h |    4 +++
 fs/xfs/xfs_fsops.c         |   11 +++----
 fs/xfs/xfs_mount.c         |   65 ++++++++++++++-----------------------------
 fs/xfs/xfs_rtalloc.c       |   29 +++++++++-----------
 5 files changed, 79 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 860a23c..59df94c 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -638,6 +638,42 @@ xfs_buf_readahead(
 	xfs_buf_read(target, ioff, isize, flags);
 }
 
+/*
+ * Read an uncached buffer from disk. Allocates and returns a locked
+ * buffer containing the disk contents or nothing.
+ */
+struct xfs_buf *
+xfs_buf_read_uncached(
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		daddr,
+	size_t			length)
+{
+	xfs_buf_t	*bp;
+	int		error;
+
+	bp = xfs_buf_get_noaddr(length, target);
+	if (!bp || XFS_BUF_ISERROR(bp))
+		goto fail;
+
+	/* set up the buffer for a read IO */
+	xfs_buf_lock(bp);
+	XFS_BUF_SET_ADDR(bp, daddr);
+	XFS_BUF_READ(bp);
+	XFS_BUF_BUSY(bp);
+
+	xfsbdstrat(mp, bp);
+	error = xfs_iowait(bp);
+	if (error || XFS_BUF_ISERROR(bp))
+		goto fail;
+
+	return bp;
+fail:
+	if (bp)
+		xfs_buf_relse(bp);
+	return NULL;
+}
+
 xfs_buf_t *
 xfs_buf_get_empty(
 	size_t			len,
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 72215d8..802dc5e 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -217,6 +217,10 @@ extern void xfs_buf_hold(xfs_buf_t *);
 extern void xfs_buf_readahead(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
 
+struct xfs_buf * xfs_buf_read_uncached(struct xfs_mount *mp,
+				struct xfs_buftarg *target,
+				xfs_daddr_t daddr, size_t length);
+
 /* Releasing Buffers */
 extern void xfs_buf_free(xfs_buf_t *);
 extern void xfs_buf_rele(xfs_buf_t *);
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
index b2009e3..2c8dd69 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -653,26 +653,11 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
 
 reread:
-	bp = xfs_buf_get_noaddr(sector_size, mp->m_ddev_targp);
-
-	if (!bp || XFS_BUF_ISERROR(bp)) {
-		xfs_fs_mount_cmn_err(flags, "SB buffer alloc failed");
-		error = bp ? XFS_BUF_GETERROR(bp) : ENOMEM;
-		goto fail;
-	}
-
-	/* set up the buffer for a read IO */
-	xfs_buf_lock(bp);
-	XFS_BUF_SET_ADDR(bp, XFS_SB_DADDR);
-        XFS_BUF_READ(bp);
-        XFS_BUF_BUSY(bp);
-
-	xfsbdstrat(mp, bp);
-	error = xfs_iowait(bp);
-	if (error || XFS_BUF_ISERROR(bp)) {
+	bp = xfs_buf_read_uncached(mp, mp->m_ddev_targp,
+					XFS_SB_DADDR, sector_size);
+	if (!bp) {
 		xfs_fs_mount_cmn_err(flags, "SB read failed");
-		error = error ? error : XFS_BUF_GETERROR(bp);
-		goto fail;
+		return EIO;
 	}
 
 	/*
@@ -720,8 +705,7 @@ reread:
 	return 0;
 
 fail:
-	if (bp)
-		xfs_buf_relse(bp);
+	xfs_buf_relse(bp);
 	return error;
 }
 
@@ -994,42 +978,35 @@ xfs_check_sizes(xfs_mount_t *mp)
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
