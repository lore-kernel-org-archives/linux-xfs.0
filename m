Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoLTP153463 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FFF65CCC4
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YN3u3ST1QitzffOp for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:19 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xG-0002yQ-Ul
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:19 +0000
Message-Id: <20110710205018.915767211@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/11] xfs: kill the dead XFS_DABUF debug code
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_DABUF_DEBUG
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

Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-07-09 12:26:07.098444231 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2011-07-09 12:26:44.665108995 +0200
@@ -86,7 +86,7 @@ STATIC void xfs_da_node_unbalance(xfs_da
  */
 STATIC uint	xfs_da_node_lasthash(xfs_dabuf_t *bp, int *count);
 STATIC int	xfs_da_node_order(xfs_dabuf_t *node1_bp, xfs_dabuf_t *node2_bp);
-STATIC xfs_dabuf_t *xfs_da_buf_make(int nbuf, xfs_buf_t **bps, inst_t *ra);
+STATIC xfs_dabuf_t *xfs_da_buf_make(int nbuf, xfs_buf_t **bps);
 STATIC int	xfs_da_blk_unlink(xfs_da_state_t *state,
 				  xfs_da_state_blk_t *drop_blk,
 				  xfs_da_state_blk_t *save_blk);
@@ -1939,8 +1939,7 @@ xfs_da_do_buf(
 	xfs_daddr_t	*mappedbnop,
 	xfs_dabuf_t	**bpp,
 	int		whichfork,
-	int		caller,
-	inst_t		*ra)
+	int		caller)
 {
 	xfs_buf_t	*bp = NULL;
 	xfs_buf_t	**bplist;
@@ -2079,9 +2078,9 @@ xfs_da_do_buf(
 	 * Build a dabuf structure.
 	 */
 	if (bplist) {
-		rbp = xfs_da_buf_make(nbplist, bplist, ra);
+		rbp = xfs_da_buf_make(nbplist, bplist);
 	} else if (bp)
-		rbp = xfs_da_buf_make(1, &bp, ra);
+		rbp = xfs_da_buf_make(1, &bp);
 	else
 		rbp = NULL;
 	/*
@@ -2149,8 +2148,7 @@ xfs_da_get_buf(
 	xfs_dabuf_t	**bpp,
 	int		whichfork)
 {
-	return xfs_da_do_buf(trans, dp, bno, &mappedbno, bpp, whichfork, 0,
-						 (inst_t *)__return_address);
+	return xfs_da_do_buf(trans, dp, bno, &mappedbno, bpp, whichfork, 0);
 }
 
 /*
@@ -2165,8 +2163,7 @@ xfs_da_read_buf(
 	xfs_dabuf_t	**bpp,
 	int		whichfork)
 {
-	return xfs_da_do_buf(trans, dp, bno, &mappedbno, bpp, whichfork, 1,
-		(inst_t *)__return_address);
+	return xfs_da_do_buf(trans, dp, bno, &mappedbno, bpp, whichfork, 1);
 }
 
 /*
@@ -2182,8 +2179,7 @@ xfs_da_reada_buf(
 	xfs_daddr_t		rval;
 
 	rval = -1;
-	if (xfs_da_do_buf(trans, dp, bno, &rval, NULL, whichfork, 3,
-			(inst_t *)__return_address))
+	if (xfs_da_do_buf(trans, dp, bno, &rval, NULL, whichfork, 3))
 		return -1;
 	else
 		return rval;
@@ -2241,17 +2237,12 @@ xfs_da_state_free(xfs_da_state_t *state)
 	kmem_zone_free(xfs_da_state_zone, state);
 }
 
-#ifdef XFS_DABUF_DEBUG
-xfs_dabuf_t	*xfs_dabuf_global_list;
-static DEFINE_SPINLOCK(xfs_dabuf_global_lock);
-#endif
-
 /*
  * Create a dabuf.
  */
 /* ARGSUSED */
 STATIC xfs_dabuf_t *
-xfs_da_buf_make(int nbuf, xfs_buf_t **bps, inst_t *ra)
+xfs_da_buf_make(int nbuf, xfs_buf_t **bps)
 {
 	xfs_buf_t	*bp;
 	xfs_dabuf_t	*dabuf;
@@ -2263,11 +2254,6 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bp
 	else
 		dabuf = kmem_alloc(XFS_DA_BUF_SIZE(nbuf), KM_NOFS);
 	dabuf->dirty = 0;
-#ifdef XFS_DABUF_DEBUG
-	dabuf->ra = ra;
-	dabuf->target = XFS_BUF_TARGET(bps[0]);
-	dabuf->blkno = XFS_BUF_ADDR(bps[0]);
-#endif
 	if (nbuf == 1) {
 		dabuf->nbuf = 1;
 		bp = bps[0];
@@ -2287,23 +2273,6 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bp
 				XFS_BUF_COUNT(bp));
 		}
 	}
-#ifdef XFS_DABUF_DEBUG
-	{
-		xfs_dabuf_t	*p;
-
-		spin_lock(&xfs_dabuf_global_lock);
-		for (p = xfs_dabuf_global_list; p; p = p->next) {
-			ASSERT(p->blkno != dabuf->blkno ||
-			       p->target != dabuf->target);
-		}
-		dabuf->prev = NULL;
-		if (xfs_dabuf_global_list)
-			xfs_dabuf_global_list->prev = dabuf;
-		dabuf->next = xfs_dabuf_global_list;
-		xfs_dabuf_global_list = dabuf;
-		spin_unlock(&xfs_dabuf_global_lock);
-	}
-#endif
 	return dabuf;
 }
 
@@ -2339,25 +2308,12 @@ xfs_da_buf_done(xfs_dabuf_t *dabuf)
 	ASSERT(dabuf->nbuf && dabuf->data && dabuf->bbcount && dabuf->bps[0]);
 	if (dabuf->dirty)
 		xfs_da_buf_clean(dabuf);
-	if (dabuf->nbuf > 1)
+	if (dabuf->nbuf > 1) {
 		kmem_free(dabuf->data);
-#ifdef XFS_DABUF_DEBUG
-	{
-		spin_lock(&xfs_dabuf_global_lock);
-		if (dabuf->prev)
-			dabuf->prev->next = dabuf->next;
-		else
-			xfs_dabuf_global_list = dabuf->next;
-		if (dabuf->next)
-			dabuf->next->prev = dabuf->prev;
-		spin_unlock(&xfs_dabuf_global_lock);
-	}
-	memset(dabuf, 0, XFS_DA_BUF_SIZE(dabuf->nbuf));
-#endif
-	if (dabuf->nbuf == 1)
-		kmem_zone_free(xfs_dabuf_zone, dabuf);
-	else
 		kmem_free(dabuf);
+	} else {
+		kmem_zone_free(xfs_dabuf_zone, dabuf);
+	}
 }
 
 /*
Index: xfs/fs/xfs/xfs_da_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.h	2011-07-09 12:26:07.115110896 +0200
+++ xfs/fs/xfs/xfs_da_btree.h	2011-07-09 12:26:44.665108995 +0200
@@ -145,22 +145,11 @@ typedef struct xfs_dabuf {
 	short		dirty;		/* data needs to be copied back */
 	short		bbcount;	/* how large is data in bbs */
 	void		*data;		/* pointer for buffers' data */
-#ifdef XFS_DABUF_DEBUG
-	inst_t		*ra;		/* return address of caller to make */
-	struct xfs_dabuf *next;		/* next in global chain */
-	struct xfs_dabuf *prev;		/* previous in global chain */
-	struct xfs_buftarg *target;	/* device for buffer */
-	xfs_daddr_t	blkno;		/* daddr first in bps[0] */
-#endif
 	struct xfs_buf	*bps[1];	/* actually nbuf of these */
 } xfs_dabuf_t;
 #define	XFS_DA_BUF_SIZE(n)	\
 	(sizeof(xfs_dabuf_t) + sizeof(struct xfs_buf *) * ((n) - 1))
 
-#ifdef XFS_DABUF_DEBUG
-extern xfs_dabuf_t	*xfs_dabuf_global_list;
-#endif
-
 /*
  * Storage for holding state during Btree searches and split/join ops.
  *

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
