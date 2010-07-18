Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6IKaSM7163644 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 15:36:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB6B4BD867B
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:46:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3wOvSfWLfwQmHAPG for
	<xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:46:00 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Oaady-0003xd-U7
	for xfs@oss.sgi.com; Sun, 18 Jul 2010 20:39:26 +0000
Message-Id: <20100718203926.789965169@bombadil.infradead.org>
Date: Sun, 18 Jul 2010 16:38:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/6] xfs: clean up xfs_bmap_get_bp
References: <20100718203848.927859114@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_bmap_get_bp
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

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-06-03 13:33:14.087004121 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2010-06-03 13:36:46.510005447 +0200
@@ -5648,41 +5648,34 @@ xfs_bmap_eof(
 }
 
 #ifdef DEBUG
-STATIC
-xfs_buf_t *
+STATIC struct xfs_buf *
 xfs_bmap_get_bp(
-	xfs_btree_cur_t         *cur,
+	struct xfs_btree_cur	*cur,
 	xfs_fsblock_t		bno)
 {
-	int i;
-	xfs_buf_t *bp;
+	struct xfs_log_item_desc *lidp;
+	int			i;
 
 	if (!cur)
-		return(NULL);
+		return NULL;
 
-	bp = NULL;
-	for(i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
-		bp = cur->bc_bufs[i];
-		if (!bp) break;
-		if (XFS_BUF_ADDR(bp) == bno)
-			break;	/* Found it */
+	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
+		if (!cur->bc_bufs[i])
+			break;
+		if (XFS_BUF_ADDR(cur->bc_bufs[i]) == bno)
+			return cur->bc_bufs[i];
 	}
-	if (i == XFS_BTREE_MAXLEVELS)
-		bp = NULL;
 
-	if (!bp) { /* Chase down all the log items to see if the bp is there */
-		struct xfs_log_item_desc *lidp;
+	/* Chase down all the log items to see if the bp is there */
+	list_for_each_entry(lidp, &cur->bc_tp->t_items, lid_trans) {
 		struct xfs_buf_log_item	*bip;
-
-		list_for_each_entry(lidp, &cur->bc_tp->t_items, lid_trans) {
-			bip = (struct xfs_buf_log_item *)lidp->lid_item;
-			if (bip->bli_item.li_type == XFS_LI_BUF &&
-			    XFS_BUF_ADDR(bip->bli_buf) == bno)
-				return bip->bli_buf;
-		}
+		bip = (struct xfs_buf_log_item *)lidp->lid_item;
+		if (bip->bli_item.li_type == XFS_LI_BUF &&
+		    XFS_BUF_ADDR(bip->bli_buf) == bno)
+			return bip->bli_buf;
 	}
 
-	return bp;
+	return NULL;
 }
 
 STATIC void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
