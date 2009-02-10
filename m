Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUlWi073599 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9F351295CD7
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id U4Od0nr0mBRaQcry for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:11 -0800 (PST)
Message-Id: <20090210202940.372253000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/13] xfs: add CRC checks to the superblock
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-sb-crc
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
Cc: Dave Chinner <dgc@sgi.com>

[hch: minor adaptions]


Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-02-09 19:15:40.377949194 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-02-09 19:15:45.187943691 +0100
@@ -44,6 +44,7 @@
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
 #include "xfs_utils.h"
+#include "xfs_cksum.h"
 
 STATIC int	xfs_uuid_mount(xfs_mount_t *);
 STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
@@ -118,6 +119,8 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
     { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_crc),	 0 },
+    { offsetof(xfs_sb_t, sb_pad),	 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 
@@ -408,6 +411,7 @@ xfs_sb_from_disk(
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
 	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+	to->sb_crc = be32_to_cpu(from->sb_crc);
 }
 
 /*
@@ -464,6 +468,24 @@ xfs_sb_to_disk(
 }
 
 /*
+ * Calculate the superblock CRC and stuff it in the buffer.
+ *
+ * We get called here just before the superblock is written
+ * to disk. We should also do some validity checking here.
+ *
+ * We CRC the entire superblock sector, not just the bits we use
+ * so that changes in structure size as features are included do
+ * not invalidate CRCs.
+ */
+void
+xfs_sb_calc_crc(
+	struct xfs_buf	*bp)
+{
+	xfs_update_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp),
+			 offsetof(struct xfs_sb, sb_crc));
+}
+
+/*
  * xfs_readsb
  *
  * Does the initial read of the superblock.
@@ -474,6 +496,7 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	unsigned int	sector_size;
 	unsigned int	extra_flags;
 	xfs_buf_t	*bp;
+	xfs_sb_t	*sbp = &mp->m_sb;
 	int		error;
 
 	ASSERT(mp->m_sb_bp == NULL);
@@ -503,7 +526,25 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	 */
 	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
 
-	error = xfs_mount_validate_sb(mp, &(mp->m_sb), flags);
+	/*
+	 * If the superblock has the CRC feature bit set or
+	 * the CRC field is non-null, check that the CRC is valid.
+	 * We check the CRC field is non-null because a single bit
+	 * error could clear the feature bit and unused parts of
+	 * the superblock are supposed to be zero. Hence a non-null
+	 * crc field indicates that we've potentially lost a feature
+	 * bit and we should check it anyway.
+	 */
+	if (xfs_sb_version_hascrc(sbp) || sbp->sb_crc != 0) {
+		if (!xfs_verify_cksum(XFS_BUF_PTR(bp), sbp->sb_sectsize,
+				      offsetof(struct xfs_sb, sb_crc))) {
+			xfs_fs_mount_cmn_err(flags, "SB CRC check failed");
+			error = EFSCORRUPTED;
+			goto fail;
+		}
+	}
+
+	error = xfs_mount_validate_sb(mp, sbp, flags);
 	if (error) {
 		xfs_fs_mount_cmn_err(flags, "SB validate failed");
 		goto fail;
@@ -512,10 +553,10 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
 	 */
-	if (sector_size > mp->m_sb.sb_sectsize) {
+	if (sector_size > sbp->sb_sectsize) {
 		xfs_fs_mount_cmn_err(flags,
 			"device supports only %u byte sectors (not %u)",
-			sector_size, mp->m_sb.sb_sectsize);
+			sector_size, sbp->sb_sectsize);
 		error = ENOSYS;
 		goto fail;
 	}
@@ -524,10 +565,10 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	 * If device sector size is smaller than the superblock size,
 	 * re-read the superblock so the buffer is correctly sized.
 	 */
-	if (sector_size < mp->m_sb.sb_sectsize) {
+	if (sector_size < sbp->sb_sectsize) {
 		XFS_BUF_UNMANAGE(bp);
 		xfs_buf_relse(bp);
-		sector_size = mp->m_sb.sb_sectsize;
+		sector_size = sbp->sb_sectsize;
 		bp = xfs_buf_read_flags(mp->m_ddev_targp, XFS_SB_DADDR,
 					BTOBB(sector_size), extra_flags);
 		if (!bp || XFS_BUF_ISERROR(bp)) {
@@ -543,11 +584,13 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	xfs_icsb_reinit_counters(mp);
 
 	mp->m_sb_bp = bp;
+	if (xfs_sb_version_hascrc(sbp))
+		xfs_buf_set_io_callback(bp, xfs_sb_calc_crc);
 	xfs_buf_relse(bp);
 	ASSERT(XFS_BUF_VALUSEMA(bp) > 0);
 	return 0;
 
- fail:
+fail:
 	if (bp) {
 		XFS_BUF_UNMANAGE(bp);
 		xfs_buf_relse(bp);
Index: xfs/fs/xfs/xfs_sb.h
===================================================================
--- xfs.orig/fs/xfs/xfs_sb.h	2009-02-09 19:15:40.363974092 +0100
+++ xfs/fs/xfs/xfs_sb.h	2009-02-09 19:15:45.192944467 +0100
@@ -160,7 +160,10 @@ typedef struct xfs_sb {
 	 */
 	__uint32_t	sb_bad_features2;
 
+	__uint32_t	sb_crc;		/* superblock crc */
+
 	/* must be padded to 64 bit alignment */
+	__uint32_t	sb_pad;
 } xfs_sb_t;
 
 /*
@@ -228,9 +231,12 @@ typedef struct xfs_dsb {
 	 * for features2 bits. Easiest just to mark it bad and not use
 	 * it for anything else.
 	 */
-	__be32	sb_bad_features2;
+	__be32		sb_bad_features2;
+
+	__be32		sb_crc;		/* superblock crc */
 
 	/* must be padded to 64 bit alignment */
+	__be32		sb_pad;
 } xfs_dsb_t;
 
 /*
@@ -249,7 +255,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_CRC, XFS_SBS_PAD,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -275,6 +281,8 @@ typedef enum {
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
+#define XFS_SB_CRC		XFS_SB_MVAL(CRC)
+#define XFS_SB_PAD		XFS_SB_MVAL(PAD)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2009-02-09 19:05:48.429078156 +0100
+++ xfs/fs/xfs/xfs_trans.c	2009-02-09 19:15:45.194049007 +0100
@@ -44,6 +44,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_trans_space.h"
 #include "xfs_inode_item.h"
+#include "xfs_cksum.h"
 
 
 STATIC void	xfs_trans_apply_sb_deltas(xfs_trans_t *);
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-02-09 19:15:35.584944583 +0100
+++ xfs/fs/xfs/xfs_mount.h	2009-02-09 19:15:45.194049007 +0100
@@ -521,6 +521,7 @@ extern struct xfs_dmops xfs_dmcore_xfs;
 
 #endif	/* __KERNEL__ */
 
+extern void	xfs_sb_calc_crc(struct xfs_buf	*);
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
 extern xfs_agnumber_t	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t);
 extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:42.873069001 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:45.196071052 +0100
@@ -1990,6 +1990,9 @@ xlog_recover_do_reg_buffer(
 	case XFS_BMAP_CRC_MAGIC:
 		xfs_btree_lblock_calc_crc(bp);
 		break;
+	case XFS_SB_MAGIC:
+		xfs_sb_calc_crc(bp);
+		break;
 	default:
 		break;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
