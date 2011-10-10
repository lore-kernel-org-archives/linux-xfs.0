Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrS1X189840 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9FB416BAE60
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 10:00:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zydvcr4QyQRdpVm6 for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 10:00:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6U-0008EH-Vf
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:27 +0000
Message-Id: <20111010165326.928137613@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/11] xfs: remove XFS_BUF_SET_VTYPE and XFS_BUF_SET_VTYPE_REF
References: <20111010165242.656850411@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_BUF_SET_VTYPE
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-09-26 11:05:28.202868929 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-09-26 11:07:54.067868056 +0200
@@ -452,7 +452,7 @@ xfs_alloc_read_agfl(
 	if (error)
 		return error;
 	ASSERT(!xfs_buf_geterror(bp));
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGFL, XFS_AGFL_REF);
+	xfs_buf_set_ref(bp, XFS_AGFL_REF);
 	*bpp = bp;
 	return 0;
 }
@@ -2139,7 +2139,7 @@ xfs_read_agf(
 		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
-	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGF, XFS_AGF_REF);
+	xfs_buf_set_ref(*bpp, XFS_AGF_REF);
 	return 0;
 }
 
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2011-09-26 10:53:36.618367481 +0200
+++ xfs/fs/xfs/xfs_btree.c	2011-09-26 11:07:54.071914772 +0200
@@ -631,7 +631,7 @@ xfs_btree_read_bufl(
 	}
 	ASSERT(!xfs_buf_geterror(bp));
 	if (bp)
-		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
+		xfs_buf_set_ref(bp, refval);
 	*bpp = bp;
 	return 0;
 }
@@ -939,13 +939,13 @@ xfs_btree_set_refs(
 	switch (cur->bc_btnum) {
 	case XFS_BTNUM_BNO:
 	case XFS_BTNUM_CNT:
-		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, XFS_ALLOC_BTREE_REF);
+		xfs_buf_set_ref(bp, XFS_ALLOC_BTREE_REF);
 		break;
 	case XFS_BTNUM_INO:
-		XFS_BUF_SET_VTYPE_REF(bp, B_FS_INOMAP, XFS_INO_BTREE_REF);
+		xfs_buf_set_ref(bp, XFS_INO_BTREE_REF);
 		break;
 	case XFS_BTNUM_BMAP:
-		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, XFS_BMAP_BTREE_REF);
+		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
 		break;
 	default:
 		ASSERT(0);
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-09-26 11:05:34.114368266 +0200
+++ xfs/fs/xfs/xfs_buf.h	2011-09-26 11:07:54.071914772 +0200
@@ -278,15 +278,10 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_SIZE(bp)		((bp)->b_buffer_length)
 #define XFS_BUF_SET_SIZE(bp, cnt)	((bp)->b_buffer_length = (cnt))
 
-static inline void
-xfs_buf_set_ref(
-	struct xfs_buf	*bp,
-	int		lru_ref)
+static inline void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
 	atomic_set(&bp->b_lru_ref, lru_ref);
 }
-#define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	xfs_buf_set_ref(bp, ref)
-#define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
 
 static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 {
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-09-26 10:53:36.000000000 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2011-09-26 11:07:54.075868682 +0200
@@ -2053,13 +2053,10 @@ xfs_da_do_buf(
 		if (!bp)
 			continue;
 		if (caller == 1) {
-			if (whichfork == XFS_ATTR_FORK) {
-				XFS_BUF_SET_VTYPE_REF(bp, B_FS_ATTR_BTREE,
-						XFS_ATTR_BTREE_REF);
-			} else {
-				XFS_BUF_SET_VTYPE_REF(bp, B_FS_DIR_BTREE,
-						XFS_DIR_BTREE_REF);
-			}
+			if (whichfork == XFS_ATTR_FORK)
+				xfs_buf_set_ref(bp, XFS_ATTR_BTREE_REF);
+			else
+				xfs_buf_set_ref(bp, XFS_DIR_BTREE_REF);
 		}
 		if (bplist) {
 			bplist[nbplist++] = bp;
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-09-26 10:55:36.962581408 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-09-26 11:07:54.083927037 +0200
@@ -605,7 +605,7 @@ xfs_qm_dqread(
 	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
 
 	/* Mark the buf so that this will stay incore a little longer */
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_DQUOT, XFS_DQUOT_REF);
+	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
 
 	/*
 	 * We got the buffer with a xfs_trans_read_buf() (in dqtobp())
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2011-09-26 10:53:36.622367741 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2011-09-26 11:07:54.087885695 +0200
@@ -1505,7 +1505,7 @@ xfs_read_agi(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
-	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGI, XFS_AGI_REF);
+	xfs_buf_set_ref(*bpp, XFS_AGI_REF);
 
 	xfs_check_agi_unlinked(agi);
 	return 0;
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-09-26 10:55:36.954369070 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-09-26 11:07:54.095882086 +0200
@@ -190,12 +190,6 @@ xfs_imap_to_bp(
 	}
 
 	xfs_inobp_check(mp, bp);
-
-	/*
-	 * Mark the buffer as an inode buffer now that it looks good
-	 */
-	XFS_BUF_SET_VTYPE(bp, B_FS_INO);
-
 	*bpp = bp;
 	return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
