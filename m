Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 15:55:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PMt69V024332
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:55:06 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 665F048509F
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:40 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Afve6AJx4SGbuFwX for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:40 -0700 (PDT)
Date: Fri, 26 Sep 2008 00:56:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/9] Add CRC checks to the superblock.
Message-ID: <20080925225639.GG9822@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-sb-crc
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <dgc@sgi.com>

From: Dave Chinner <dgc@sgi.com>

[hch: minor adaptions]


Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-09-26 00:34:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-09-26 00:37:32.000000000 +0200
@@ -44,6 +44,7 @@
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
 #include "xfs_utils.h"
+#include "xfs_cksum.h"
 
 STATIC int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 STATIC int	xfs_uuid_mount(xfs_mount_t *);
@@ -119,6 +120,8 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
     { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_crc),	 0 },
+    { offsetof(xfs_sb_t, sb_pad),	 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 
@@ -409,6 +412,7 @@ xfs_sb_from_disk(
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
 	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+	to->sb_crc = be32_to_cpu(from->sb_crc);
 }
 
 /*
@@ -465,6 +469,24 @@ xfs_sb_to_disk(
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
@@ -475,6 +497,7 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	unsigned int	sector_size;
 	unsigned int	extra_flags;
 	xfs_buf_t	*bp;
+	xfs_sb_t	*sbp = &mp->m_sb;
 	int		error;
 
 	ASSERT(mp->m_sb_bp == NULL);
@@ -504,7 +527,25 @@ xfs_readsb(xfs_mount_t *mp, int flags)
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
@@ -513,10 +554,10 @@ xfs_readsb(xfs_mount_t *mp, int flags)
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
@@ -525,10 +566,10 @@ xfs_readsb(xfs_mount_t *mp, int flags)
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
@@ -544,11 +585,13 @@ xfs_readsb(xfs_mount_t *mp, int flags)
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
Index: linux-2.6-xfs/fs/xfs/xfs_sb.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_sb.h	2008-09-26 00:34:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_sb.h	2008-09-26 00:37:32.000000000 +0200
@@ -159,7 +159,10 @@ typedef struct xfs_sb {
 	 */
 	__uint32_t	sb_bad_features2;
 
+	__uint32_t	sb_crc;		/* superblock crc */
+
 	/* must be padded to 64 bit alignment */
+	__uint32_t	sb_pad;
 } xfs_sb_t;
 
 /*
@@ -227,9 +230,12 @@ typedef struct xfs_dsb {
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
@@ -248,7 +254,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_CRC, XFS_SBS_PAD,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -274,6 +280,8 @@ typedef enum {
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
+#define XFS_SB_CRC		XFS_SB_MVAL(CRC)
+#define XFS_SB_PAD		XFS_SB_MVAL(PAD)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
Index: linux-2.6-xfs/fs/xfs/xfs_trans.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_trans.c	2008-09-26 00:34:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_trans.c	2008-09-26 00:37:32.000000000 +0200
@@ -44,6 +44,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_trans_space.h"
 #include "xfs_inode_item.h"
+#include "xfs_cksum.h"
 
 
 STATIC void	xfs_trans_apply_sb_deltas(xfs_trans_t *);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-09-26 00:34:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-09-26 00:37:32.000000000 +0200
@@ -506,6 +506,7 @@ typedef struct xfs_mod_sb {
 #define	XFS_MOUNT_ILOCK(mp)	mutex_lock(&((mp)->m_ilock))
 #define	XFS_MOUNT_IUNLOCK(mp)	mutex_unlock(&((mp)->m_ilock))
 
+extern void	xfs_sb_calc_crc(struct xfs_buf	*);
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
 extern int	xfs_mountfs(xfs_mount_t *mp);
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-26 00:35:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-26 00:38:00.000000000 +0200
@@ -1941,6 +1941,9 @@ xlog_recover_do_reg_buffer(
 	case XFS_BMAP_CRC_MAGIC:
 		xfs_btree_lblock_calc_crc(bp);
 		break;
+	case XFS_SB_MAGIC:
+		xfs_sb_calc_crc(bp);
+		break;
 	default:
 		break;
 	}

-- 
