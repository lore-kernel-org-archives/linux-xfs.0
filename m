Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96IZqm6195433 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 13:35:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72C1914513A0
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 11:42:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5LDgAI4uyEkRqmB5 for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 11:42:40 -0700 (PDT)
Message-Id: <20111006183549.598050900@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 14:32:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] xfs: force the log if we encounter pinned buffers in
	.iop_pushbuf
References: <20111006183257.036884724@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-inode-ail-pushing-3
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
Cc: Stefan Priebe <s.priebe@profihost.ag>

We need to check for pinned buffers even in .iop_pushbuf given that inode
items flush into the same buffers that may be pinned directly due operations
on the unlinked inode list operating directly on buffers.  To do this add a
return value to .iop_pushbuf that tells the AIL push about this and use
the existing log force mechanisms to unpin it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Tested-by: Stefan Priebe <s.priebe@profihost.ag>

Index: xfs/fs/xfs/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-10-06 14:10:53.926919219 -0400
+++ xfs/fs/xfs/xfs_dquot_item.c	2011-10-06 14:15:40.642918500 -0400
@@ -183,13 +183,14 @@ xfs_qm_dqunpin_wait(
  * search the buffer cache can be a time consuming thing, and AIL lock is a
  * spinlock.
  */
-STATIC void
+STATIC bool
 xfs_qm_dquot_logitem_pushbuf(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 	struct xfs_dquot	*dqp = qlip->qli_dquot;
 	struct xfs_buf		*bp;
+	bool			ret = true;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
@@ -201,17 +202,20 @@ xfs_qm_dquot_logitem_pushbuf(
 	if (completion_done(&dqp->q_flush) ||
 	    !(lip->li_flags & XFS_LI_IN_AIL)) {
 		xfs_dqunlock(dqp);
-		return;
+		return true;
 	}
 
 	bp = xfs_incore(dqp->q_mount->m_ddev_targp, qlip->qli_format.qlf_blkno,
 			dqp->q_mount->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK);
 	xfs_dqunlock(dqp);
 	if (!bp)
-		return;
+		return true;
 	if (XFS_BUF_ISDELAYWRITE(bp))
 		xfs_buf_delwri_promote(bp);
+	if (xfs_buf_ispinned(bp))
+		ret = false;
 	xfs_buf_relse(bp);
+	return ret;
 }
 
 /*
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-10-06 14:10:53.934920468 -0400
+++ xfs/fs/xfs/xfs_buf_item.c	2011-10-06 14:15:40.642918500 -0400
@@ -629,7 +629,7 @@ xfs_buf_item_push(
  * the xfsbufd to get this buffer written. We have to unlock the buffer
  * to allow the xfsbufd to write it, too.
  */
-STATIC void
+STATIC bool
 xfs_buf_item_pushbuf(
 	struct xfs_log_item	*lip)
 {
@@ -643,6 +643,7 @@ xfs_buf_item_pushbuf(
 
 	xfs_buf_delwri_promote(bp);
 	xfs_buf_relse(bp);
+	return true;
 }
 
 STATIC void
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-10-06 14:10:53.946918636 -0400
+++ xfs/fs/xfs/xfs_inode_item.c	2011-10-06 14:15:40.646917968 -0400
@@ -706,13 +706,14 @@ xfs_inode_item_committed(
  * marked delayed write. If that's the case, we'll promote it and that will
  * allow the caller to write the buffer by triggering the xfsbufd to run.
  */
-STATIC void
+STATIC bool
 xfs_inode_item_pushbuf(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_buf		*bp;
+	bool			ret = true;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 
@@ -723,7 +724,7 @@ xfs_inode_item_pushbuf(
 	if (completion_done(&ip->i_flush) ||
 	    !(lip->li_flags & XFS_LI_IN_AIL)) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		return;
+		return true;
 	}
 
 	bp = xfs_incore(ip->i_mount->m_ddev_targp, iip->ili_format.ilf_blkno,
@@ -731,10 +732,13 @@ xfs_inode_item_pushbuf(
 
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	if (!bp)
-		return;
+		return true;
 	if (XFS_BUF_ISDELAYWRITE(bp))
 		xfs_buf_delwri_promote(bp);
+	if (xfs_buf_ispinned(bp))
+		ret = false;
 	xfs_buf_relse(bp);
+	return ret;
 }
 
 /*
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2011-10-06 14:10:53.954919795 -0400
+++ xfs/fs/xfs/xfs_trans.h	2011-10-06 14:15:40.646917968 -0400
@@ -350,7 +350,7 @@ typedef struct xfs_item_ops {
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
 	void (*iop_push)(xfs_log_item_t *);
-	void (*iop_pushbuf)(xfs_log_item_t *);
+	bool (*iop_pushbuf)(xfs_log_item_t *);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 } xfs_item_ops_t;
 
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-10-06 14:10:53.962919265 -0400
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-10-06 14:20:46.730936535 -0400
@@ -439,8 +439,13 @@ xfs_ail_worker(
 
 		case XFS_ITEM_PUSHBUF:
 			XFS_STATS_INC(xs_push_ail_pushbuf);
-			IOP_PUSHBUF(lip);
-			ailp->xa_last_pushed_lsn = lsn;
+
+			if (!IOP_PUSHBUF(lip)) {
+				stuck++;
+				ailp->xa_log_flush++;
+			} else {
+				ailp->xa_last_pushed_lsn = lsn;
+			}
 			push_xfsbufd = 1;
 			break;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
