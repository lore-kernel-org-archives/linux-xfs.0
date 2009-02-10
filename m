Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKVFHV073676 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:31:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6830158F883
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Bh6JP8j9DWBYJCoX for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:39 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEj-0005q3-Mv
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:41 +0000
Message-Id: <20090210202941.616680000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/13] xfs: add CRC checks for quota blocks
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-crc
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

Use the reserved space in struct xfs_dqblk to store a UUID and a crc
for the quota blocks.

I'm pondering if we should just move the crc check into xfs_qm_dqcheck
where all the other validity checks are located.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2009-02-09 08:47:34.234069111 +0100
+++ xfs/fs/xfs/xfs_quota.h	2009-02-10 20:15:36.874947481 +0100
@@ -77,7 +77,13 @@ typedef struct	xfs_disk_dquot {
  */
 typedef struct xfs_dqblk {
 	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
-	char		  dd_fill[32];	/* filling for posterity */
+	char		  dd_fill[12];	/* filling for posterity */
+
+	/*
+	 * These two are only present one filesystems with the CRC bits set.
+	 */
+	__be32		  dd_crc;	/* checksum */
+	uuid_t		  dd_uuid;	/* location information */
 } xfs_dqblk_t;
 
 /*
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2009-02-10 19:55:01.982070089 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.c	2009-02-10 20:23:25.618944664 +0100
@@ -48,6 +48,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
+#include "xfs_cksum.h"
 
 
 /*
@@ -368,6 +369,40 @@ xfs_qm_adjust_dqtimers(
 	}
 }
 
+STATIC void
+xfs_dquot_calc_crc(
+	struct xfs_buf		*bp)
+{
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)XFS_BUF_PTR(bp);
+	int			i;
+
+	for (i = 0; i < XFS_QM_DQPERBLK(bp->b_mount); i++, d++) {
+		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
+				 offsetof(struct xfs_dqblk, dd_crc));
+	}
+}
+
+STATIC int
+xfs_dquot_verify_crc(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)XFS_BUF_PTR(bp);
+	int			i;
+
+	for (i = 0; i < XFS_QM_DQPERBLK(mp); i++, d++) {
+		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
+				 offsetof(struct xfs_dqblk, dd_crc))) {
+//		    !uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_uuid) ||
+			XFS_CORRUPTION_ERROR("xfs_qm_dqtobp crc",
+					XFS_ERRLEVEL_LOW, mp, d);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+	}
+
+	return 0;
+}
+
 /*
  * initialize a buffer full of dquots and log the whole thing
  */
@@ -476,6 +511,10 @@ xfs_qm_dqalloc(
 			       0);
 	if (!bp || (error = XFS_BUF_GETERROR(bp)))
 		goto error1;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xfs_buf_set_io_callback(bp, xfs_dquot_calc_crc);
+
 	/*
 	 * Make a chunk of dquots out of this buffer and log
 	 * the entire thing.
@@ -539,6 +578,7 @@ xfs_qm_dqtobp(
 	xfs_inode_t	*quotip;
 	xfs_mount_t	*mp;
 	xfs_disk_dquot_t *ddq;
+	struct xfs_dqblk *d;
 	xfs_dqid_t	id;
 	boolean_t	newdquot;
 	xfs_trans_t	*tp = (tpp ? *tpp : NULL);
@@ -622,6 +662,22 @@ xfs_qm_dqtobp(
 		}
 		if (error || !bp)
 			return XFS_ERROR(error);
+
+		/*
+		 * Validate the CRC of the AGF block only if the block is clean (i.e.
+		 * it just came from disk).
+		 */
+		if (xfs_sb_version_hascrc(&mp->m_sb) &&
+		    !(XFS_BUF_ISWRITE(bp) || XFS_BUF_ISDELAYWRITE(bp))) {
+			error = xfs_dquot_verify_crc(mp, bp);
+			if (error) {
+				xfs_trans_brelse(tp, bp);
+				return error;
+			}
+
+			xfs_buf_set_io_callback(bp, xfs_dquot_calc_crc);
+		}
+
 	}
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
@@ -629,7 +685,8 @@ xfs_qm_dqtobp(
 	/*
 	 * calculate the location of the dquot inside the buffer.
 	 */
-	ddq = (xfs_disk_dquot_t *)((char *)XFS_BUF_PTR(bp) + dqp->q_bufoffset);
+	d = (struct xfs_dqblk *)(XFS_BUF_PTR(bp) + dqp->q_bufoffset);
+	ddq = &d->dd_diskdq;
 
 	/*
 	 * A simple sanity check in case we got a corrupted dquot...
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2009-02-10 19:55:02.006069507 +0100
+++ xfs/fs/xfs/quota/xfs_qm.c	2009-02-10 19:58:48.005974236 +0100
@@ -1430,6 +1430,10 @@ xfs_qm_dqiter_bufs(
 		if (error)
 			break;
 
+		/*
+		 * XXX(hch): need to figure out if it makes sense to validate
+		 *	     the CRC here.
+		 */
 		xfs_qm_reset_dqcounts(mp, bp, firstid, type);
 		xfs_bdwrite(mp, bp);
 		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
