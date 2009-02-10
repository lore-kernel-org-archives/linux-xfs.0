Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUHKW073480 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7105010654D
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id snfn253nHJsVx479 for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:41 -0800 (PST)
Message-Id: <20090210202941.022397000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/13] xfs: add CRC checks to the AGI
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-agi-crc
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

Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2009-02-09 19:15:46.916949727 +0100
+++ xfs/fs/xfs/xfs_ag.h	2009-02-09 19:15:48.966944136 +0100
@@ -126,6 +126,8 @@ typedef struct xfs_agi {
 	 * still being referenced.
 	 */
 	__be32		agi_unlinked[XFS_AGI_UNLINKED_BUCKETS];
+	__be32		agi_crc;	/* crc of agi sector */
+	uuid_t		agi_uuid;	/* uuid of filesystem */
 } xfs_agi_t;
 
 #define	XFS_AGI_MAGICNUM	0x00000001
@@ -139,6 +141,9 @@ typedef struct xfs_agi {
 #define	XFS_AGI_NEWINO		0x00000100
 #define	XFS_AGI_DIRINO		0x00000200
 #define	XFS_AGI_UNLINKED	0x00000400
+/*
+ * XXX(hch): update for the CRC additions?  It's unused anyway..
+ */
 #define	XFS_AGI_NUM_BITS	11
 #define	XFS_AGI_ALL_BITS	((1 << XFS_AGI_NUM_BITS) - 1)
 
@@ -147,6 +152,7 @@ typedef struct xfs_agi {
 #define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
 #define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)XFS_BUF_PTR(bp))
 
+extern void xfs_agi_calc_crc(struct xfs_buf *bp);
 extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_agnumber_t agno, struct xfs_buf **bpp);
 
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2009-02-09 19:15:46.917943848 +0100
+++ xfs/fs/xfs/xfs_fsops.c	2009-02-09 19:15:48.966944136 +0100
@@ -245,6 +245,10 @@ xfs_growfs_data_private(
 		agi->agi_dirino = cpu_to_be32(NULLAGINO);
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 			agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
+			xfs_buf_set_io_callback(bp, xfs_agi_calc_crc);
+		}
 		error = xfs_bwrite(mp, bp);
 		if (error) {
 			goto error0;
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-02-09 19:05:48.022069819 +0100
+++ xfs/fs/xfs/xfs_ialloc.c	2009-02-09 19:15:48.968944600 +0100
@@ -40,6 +40,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
+#include "xfs_cksum.h"
 
 
 /*
@@ -1455,6 +1456,24 @@ xfs_check_agi_unlinked(
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
@@ -1464,6 +1483,7 @@ xfs_read_agi(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	struct xfs_buf		**bpp)	/* allocation group hdr buf */
 {
+	struct xfs_buf		*bp;
 	struct xfs_agi		*agi;	/* allocation group header */
 	int			agi_ok;	/* agi is consistent */
 	int			error;
@@ -1472,12 +1492,28 @@ xfs_read_agi(
 
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
@@ -1489,13 +1525,18 @@ xfs_read_agi(
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
 
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:46.924974841 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:48.970972860 +0100
@@ -1996,6 +1996,9 @@ xlog_recover_do_reg_buffer(
 	case XFS_AGF_MAGIC:
 		xfs_agf_calc_crc(bp);
 		break;
+ 	case XFS_AGI_MAGIC:
+		xfs_agi_calc_crc(bp);
+		break;
 	default:
 		break;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
