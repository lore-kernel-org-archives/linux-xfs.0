Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 15:55:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PMtDdk024382
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:55:13 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68B8F4850A2
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:47 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id K7xkotzVxLSmRECr for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:47 -0700 (PDT)
Date: Fri, 26 Sep 2008 00:56:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/9] Add CRC checks to the AGF
Message-ID: <20080925225646.GI9822@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-agf-crc
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
--- linux-2.6-xfs.orig/fs/xfs/xfs_ag.h	2008-09-26 00:41:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ag.h	2008-09-26 00:41:54.000000000 +0200
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
 
Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2008-09-26 00:41:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2008-09-26 00:41:54.000000000 +0200
@@ -217,6 +217,8 @@ xfs_growfs_data_private(
 		tmpsize = agsize - XFS_PREALLOC_BLOCKS(mp);
 		agf->agf_freeblks = cpu_to_be32(tmpsize);
 		agf->agf_longest = cpu_to_be32(tmpsize);
+		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+		xfs_buf_set_io_callback(bp, xfs_agf_calc_crc);
 		error = xfs_bwrite(mp, bp);
 		if (error) {
 			goto error0;
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-09-26 00:34:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-09-26 00:41:54.000000000 +0200
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
@@ -2277,6 +2311,9 @@ xfs_read_agf(
 	}
 
 	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGF, XFS_AGF_REF);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xfs_buf_set_io_callback(*bpp, xfs_agf_calc_crc);
 	return 0;
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-26 00:41:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-26 00:42:17.000000000 +0200
@@ -1947,6 +1947,9 @@ xlog_recover_do_reg_buffer(
  	case XFS_AGI_MAGIC:
 		xfs_agi_calc_crc(bp);
 		break;
+	case XFS_AGF_MAGIC:
+		xfs_agf_calc_crc(bp);
+		break;
 	default:
 		break;
 	}

-- 
