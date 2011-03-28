Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SL65Lq185395 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 16:06:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DAC01DEB003
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:09:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Gc3k8HSuGX1jz6v2 for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:09:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q4JgY-0001rE-KR
	for xfs@oss.sgi.com; Mon, 28 Mar 2011 21:09:14 +0000
Message-Id: <20110328210914.594997356@bombadil.infradead.org>
Date: Mon, 28 Mar 2011 17:06:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfs: optimize AGFL refills
References: <20110328210614.832613417@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-optimize-freelist-refills
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

While we need to make sure we do not reuse busy extents, there is no need
to force out busy extents when moving them between the AGFL and the
freespace btree as we still take care of that when doing the real allocation.

To avoid the log force when just moving extents from the different free
space tracking structures, move the busy search out of
xfs_alloc_get_freelist into the callers that need it, and move the busy
list insert from xfs_free_ag_extent which is used both by AGFL refills
and real allocation to xfs_free_extent, which is only used by the latter.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-27 23:52:29.004480044 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-03-28 13:42:50.682839138 +0200
@@ -1326,6 +1326,8 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
+			if (xfs_alloc_busy_search(args->mp, args->agno, fbno, 1))
+				xfs_trans_set_sync(args->tp);
 			if (args->userdata) {
 				xfs_buf_t	*bp;
 
@@ -1617,18 +1619,6 @@ xfs_free_ag_extent(
 
 	trace_xfs_free_extent(mp, agno, bno, len, isfl, haveleft, haveright);
 
-	/*
-	 * Since blocks move to the free list without the coordination
-	 * used in xfs_bmap_finish, we can't allow block to be available
-	 * for reallocation and non-transaction writing (user data)
-	 * until we know that the transaction that moved it to the free
-	 * list is permanently on disk.  We track the blocks by declaring
-	 * these blocks as "busy"; the busy list is maintained on a per-ag
-	 * basis and each transaction records which entries should be removed
-	 * when the iclog commits to disk.  If a busy block is allocated,
-	 * the iclog is pushed up to the LSN that freed the block.
-	 */
-	xfs_alloc_busy_insert(tp, agno, bno, len);
 	return 0;
 
  error0:
@@ -1923,21 +1913,6 @@ xfs_alloc_get_freelist(
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
 
-	/*
-	 * As blocks are freed, they are added to the per-ag busy list and
-	 * remain there until the freeing transaction is committed to disk.
-	 * Now that we have allocated blocks, this list must be searched to see
-	 * if a block is being reused.  If one is, then the freeing transaction
-	 * must be pushed to disk before this transaction.
-	 *
-	 * We do this by setting the current transaction to a sync transaction
-	 * which guarantees that the freeing transaction is on disk before this
-	 * transaction. This is done instead of a synchronous log force here so
-	 * that we don't sit and wait with the AGF locked in the transaction
-	 * during the log force.
-	 */
-	if (xfs_alloc_busy_search(mp, be32_to_cpu(agf->agf_seqno), bno, 1))
-		xfs_trans_set_sync(tp);
 	return 0;
 }
 
@@ -2407,6 +2382,8 @@ xfs_free_extent(
 		be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length));
 #endif
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
+	if (!error)
+		xfs_alloc_busy_insert(tp, args.agno, args.agbno, len);
 error0:
 	xfs_perag_put(args.pag);
 	return error;
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2011-03-27 23:52:29.008480632 +0200
+++ xfs/fs/xfs/xfs_alloc_btree.c	2011-03-28 13:42:49.462839006 +0200
@@ -94,6 +94,8 @@ xfs_allocbt_alloc_block(
 		*stat = 0;
 		return 0;
 	}
+	if (xfs_alloc_busy_search(cur->bc_mp, cur->bc_private.a.agno, bno, 1))
+		xfs_trans_set_sync(cur->bc_tp);
 
 	xfs_trans_agbtree_delta(cur->bc_tp, 1);
 	new->s = cpu_to_be32(bno);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
