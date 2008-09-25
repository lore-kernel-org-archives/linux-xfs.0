Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 15:55:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PMt9hM024351
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:55:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC7B71045167
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:43 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id SzrdFUG1PudGY8Dl for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:43 -0700 (PDT)
Date: Fri, 26 Sep 2008 00:56:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/9] Add CRC checks to the AGI
Message-ID: <20080925225642.GH9822@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-agi-crc
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <dgc@sgi.com>

From: Dave Chinner <dgc@sgi.com>

[hch: minor adaptions]


Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_ag.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ag.h	2008-09-26 00:34:27.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ag.h	2008-09-26 00:39:17.000000000 +0200
@@ -123,6 +123,8 @@ typedef struct xfs_agi {
 	 * still being referenced.
 	 */
 	__be32		agi_unlinked[XFS_AGI_UNLINKED_BUCKETS];
+	__be32		agi_crc;	/* crc of agi sector */
+	uuid_t		agi_uuid;	/* uuid of filesystem */
 } xfs_agi_t;
 
 #define	XFS_AGI_MAGICNUM	0x00000001
@@ -136,6 +138,9 @@ typedef struct xfs_agi {
 #define	XFS_AGI_NEWINO		0x00000100
 #define	XFS_AGI_DIRINO		0x00000200
 #define	XFS_AGI_UNLINKED	0x00000400
+/*
+ * XXX(hch): update for the CRC additions?  It's unused anyway..
+ */
 #define	XFS_AGI_NUM_BITS	11
 #define	XFS_AGI_ALL_BITS	((1 << XFS_AGI_NUM_BITS) - 1)
 
@@ -144,6 +149,7 @@ typedef struct xfs_agi {
 #define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
 #define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)XFS_BUF_PTR(bp))
 
+extern void xfs_agi_calc_crc(struct xfs_buf *bp);
 extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_agnumber_t agno, struct xfs_buf **bpp);
 
Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2008-09-26 00:34:27.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2008-09-26 00:39:17.000000000 +0200
@@ -239,8 +239,10 @@ xfs_growfs_data_private(
 		agi->agi_freecount = 0;
 		agi->agi_newino = cpu_to_be32(NULLAGINO);
 		agi->agi_dirino = cpu_to_be32(NULLAGINO);
+		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 			agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+		xfs_buf_set_io_callback(bp, xfs_agi_calc_crc);
 		error = xfs_bwrite(mp, bp);
 		if (error) {
 			goto error0;
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-09-26 00:34:27.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-09-26 00:39:17.000000000 +0200
@@ -40,6 +40,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
+#include "xfs_cksum.h"
 
 /*
  * Log specified fields for the inode given by bp and off.
@@ -1477,6 +1478,24 @@ xfs_check_agi_unlinked(
 #endif
 
 /*
+ * Calculate CRC on AGI and stuff it into the structure.
+ *
+ * We CRC the entire AGI sector, not just the bits we use so that changes
+ * in structure size as features are included do not invalidate CRCs.
+ *
+ * We get called here just before the AGI is written to disk. We should
+ * also do some validity checking here.
+ */
+void
+xfs_agi_calc_crc(
+	xfs_buf_t	*bp)
+{
+	xfs_update_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp),
+			 offsetof(struct xfs_agi, agi_crc));
+
+}
+
+/*
  * Read in the allocation group header (inode allocation section)
  */
 int
@@ -1486,6 +1505,7 @@ xfs_read_agi(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	struct xfs_buf		**bpp)	/* allocation group hdr buf */
 {
+	struct xfs_buf		*bp;
 	struct xfs_agi		*agi;	/* allocation group header */
 	int			agi_ok;	/* agi is consistent */
 	int			error;
@@ -1494,12 +1514,28 @@ xfs_read_agi(
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, bpp);
+			XFS_FSS_TO_BB(mp, 1), 0, &bp);
 	if (error)
 		return error;
 
-	ASSERT(*bpp && !XFS_BUF_GETERROR(*bpp));
-	agi = XFS_BUF_TO_AGI(*bpp);
+	ASSERT(bp && !XFS_BUF_GETERROR(bp));
+	agi = XFS_BUF_TO_AGI(bp);
+
+	/*
+	 * Validate the CRC of the AGI block only if the block is clean (i.e.
+	 * it just came from disk) and we have CRCs enabled.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !(XFS_BUF_ISWRITE(bp) || XFS_BUF_ISDELAYWRITE(bp))) {
+		if (!xfs_verify_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp),
+				      offsetof(struct xfs_agi, agi_crc)) ||
+		    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_uuid)) {
+			XFS_CORRUPTION_ERROR("xfs_read_agi crc",
+					XFS_ERRLEVEL_LOW, mp, agi);
+			xfs_trans_brelse(tp, bp);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+	}
 
 	/*
 	 * Validate the magic number of the agi block.
@@ -1511,13 +1547,18 @@ xfs_read_agi(
 			XFS_RANDOM_IALLOC_READ_AGI))) {
 		XFS_CORRUPTION_ERROR("xfs_read_agi", XFS_ERRLEVEL_LOW,
 				     mp, agi);
-		xfs_trans_brelse(tp, *bpp);
+		xfs_trans_brelse(tp, bp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
-	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGI, XFS_AGI_REF);
+	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGI, XFS_AGI_REF);
 
 	xfs_check_agi_unlinked(agi);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xfs_buf_set_io_callback(bp, xfs_agi_calc_crc);
+
+	*bpp = bp;
 	return 0;
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-26 00:38:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-26 00:39:40.000000000 +0200
@@ -1944,6 +1944,9 @@ xlog_recover_do_reg_buffer(
 	case XFS_SB_MAGIC:
 		xfs_sb_calc_crc(bp);
 		break;
+ 	case XFS_AGI_MAGIC:
+		xfs_agi_calc_crc(bp);
+		break;
 	default:
 		break;
 	}

-- 
