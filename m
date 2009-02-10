Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUlU8073600 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E2B1105D76
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MfZB9CyjGYlutcXF for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:11 -0800 (PST)
Message-Id: <20090210202940.652258000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/13] xfs: add CRC checks to the AGF
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-agf-crc
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
--- xfs.orig/fs/xfs/xfs_ag.h	2009-02-09 19:05:48.120069296 +0100
+++ xfs/fs/xfs/xfs_ag.h	2009-02-09 19:15:46.916949727 +0100
@@ -69,6 +69,8 @@ typedef struct xfs_agf {
 	__be32		agf_freeblks;	/* total free blocks */
 	__be32		agf_longest;	/* longest free space */
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
+	__be32		agf_crc;	/* crc of agf sector */
+	uuid_t		agf_uuid;	/* uuid of filesystem */
 } xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
@@ -91,6 +93,7 @@ typedef struct xfs_agf {
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
 #define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)XFS_BUF_PTR(bp))
 
+extern void xfs_agf_calc_crc(struct xfs_buf *bp);
 extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2009-02-09 19:15:42.860069581 +0100
+++ xfs/fs/xfs/xfs_fsops.c	2009-02-09 19:15:46.917943848 +0100
@@ -217,6 +217,10 @@ xfs_growfs_data_private(
 		tmpsize = agsize - XFS_PREALLOC_BLOCKS(mp);
 		agf->agf_freeblks = cpu_to_be32(tmpsize);
 		agf->agf_longest = cpu_to_be32(tmpsize);
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+			xfs_buf_set_io_callback(bp, xfs_agf_calc_crc);
+		}
 		error = xfs_bwrite(mp, bp);
 		if (error) {
 			goto error0;
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2009-02-09 19:05:48.190069960 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2009-02-09 19:15:46.920944300 +0100
@@ -38,6 +38,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
+#include "xfs_cksum.h"
 
 
 #define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
@@ -2230,6 +2231,23 @@ xfs_alloc_put_freelist(
 }
 
 /*
+ * Calculate CRC on AGF and stuff it into the structure.
+ *
+ * We CRC the entire AGF sector, not just the bits we use so that changes
+ * in structure size as features are included do not invalidate CRCs.
+ *
+ * We get called here just before the AGF is written to disk. We should
+ * also do some validity checking here.
+ */
+void
+xfs_agf_calc_crc(
+	struct xfs_buf		*bp)
+{
+	xfs_update_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp),
+			 offsetof(struct xfs_agf, agf_crc));
+}
+
+/*
  * Read in the allocation group header (free/alloc section).
  */
 int					/* error */
@@ -2258,6 +2276,22 @@ xfs_read_agf(
 	agf = XFS_BUF_TO_AGF(*bpp);
 
 	/*
+	 * Validate the CRC of the AGF block only if the block is clean (i.e.
+	 * it just came from disk) and we have CRCs enabled.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !(XFS_BUF_ISWRITE(*bpp) || XFS_BUF_ISDELAYWRITE(*bpp))) {
+		if (!xfs_verify_cksum(XFS_BUF_PTR(*bpp), XFS_BUF_SIZE(*bpp),
+				      offsetof(struct xfs_agf, agf_crc)) ||
+		    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid)) {
+			XFS_CORRUPTION_ERROR("xfs_read_agf crc",
+					XFS_ERRLEVEL_LOW, mp, agf);
+			xfs_trans_brelse(tp, *bpp);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+	}
+
+	/*
 	 * Validate the magic number of the agf block.
 	 */
 	agf_ok =
@@ -2280,6 +2314,9 @@ xfs_read_agf(
 	}
 
 	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGF, XFS_AGF_REF);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xfs_buf_set_io_callback(*bpp, xfs_agf_calc_crc);
 	return 0;
 }
 
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:45.196071052 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:46.924974841 +0100
@@ -1993,6 +1993,9 @@ xlog_recover_do_reg_buffer(
 	case XFS_SB_MAGIC:
 		xfs_sb_calc_crc(bp);
 		break;
+	case XFS_AGF_MAGIC:
+		xfs_agf_calc_crc(bp);
+		break;
 	default:
 		break;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
