Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0L9NVJf260882 for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 03:23:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1B4A27C9E7
	for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 01:25:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id z64L8pm8hf1kChZ9 for
	<xfs@oss.sgi.com>; Fri, 21 Jan 2011 01:25:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PgDFf-0002Dw-7w
	for xfs@oss.sgi.com; Fri, 21 Jan 2011 09:25:51 +0000
Message-Id: <20110121092551.185804716@bombadil.infradead.org>
Date: Fri, 21 Jan 2011 04:22:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/6] xfs: optimize xfs_alloc_fix_freelist
References: <20110121092227.115815324@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-avoid-sync-transaction-for-freelist-refill
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

If we shorten the freelist in xfs_alloc_fix_freelist there is no need
to wait for busy blocks as they will be marked busy again when we call
xfs_free_ag_extent.  Avoid this by not marking blocks coming from the
freelist as busy in xfs_free_ag_extent, and not marking transactions
with busy extents as synchronous in xfs_alloc_get_freelist.  Unlike
xfs_free_ag_extent which already has the isfl argument,
xfs_alloc_get_freelist needs to be told about the usage of the blocks
it returns.  For this we extend the btreeblk flag to a type argument
which specifies in detail what the block is going to be used for.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-01-17 22:18:20.421254585 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2011-01-17 22:30:54.006256540 +0100
@@ -1395,7 +1395,8 @@ xfs_alloc_ag_vextent_small(
 	else if (args->minlen == 1 && args->alignment == 1 && !args->isfl &&
 		 (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount)
 		  > args->minleft)) {
-		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
+		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno,
+					       XFS_FREELIST_ALLOC);
 		if (error)
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
@@ -1683,25 +1684,20 @@ xfs_free_ag_extent(
 	if (error)
 		goto error0;
 
-	if (!isfl)
+	if (!isfl) {
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (long)len);
+
+		/*
+		 * Mark the extent busy unless it comes from the freelist,
+		 * in which case it has already been marked busy.
+		 */
+		xfs_alloc_busy_insert(tp, agno, bno, len);
+	}
+
 	XFS_STATS_INC(xs_freex);
 	XFS_STATS_ADD(xs_freeb, len);
 
 	trace_xfs_free_extent(mp, agno, bno, len, isfl, haveleft, haveright);
-
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
@@ -1873,11 +1869,14 @@ xfs_alloc_fix_freelist(
 	while (be32_to_cpu(agf->agf_flcount) > need) {
 		xfs_buf_t	*bp;
 
-		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
+		error = xfs_alloc_get_freelist(tp, agbp, &bno,
+					       XFS_FREELIST_BALANCE);
 		if (error)
 			return error;
-		if ((error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1)))
+		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1);
+		if (error)
 			return error;
+
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
 		xfs_trans_binval(tp, bp);
 	}
@@ -1944,18 +1943,18 @@ xfs_alloc_get_freelist(
 	xfs_trans_t	*tp,	/* transaction pointer */
 	xfs_buf_t	*agbp,	/* buffer containing the agf structure */
 	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
-	int		btreeblk) /* destination is a AGF btree */
+	int		type)	/* where does the allocation go to? */
 {
-	xfs_agf_t	*agf;	/* a.g. freespace structure */
+	xfs_mount_t	*mp = tp->t_mountp;
+	xfs_agf_t	*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t	agno = be32_to_cpu(agf->agf_seqno);
 	xfs_agfl_t	*agfl;	/* a.g. freelist structure */
 	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	int		error;
 	int		logflags;
-	xfs_mount_t	*mp;	/* mount structure */
 	xfs_perag_t	*pag;	/* per allocation group data */
 
-	agf = XFS_BUF_TO_AGF(agbp);
 	/*
 	 * Freelist is empty, give up.
 	 */
@@ -1963,14 +1962,15 @@ xfs_alloc_get_freelist(
 		*bnop = NULLAGBLOCK;
 		return 0;
 	}
+
 	/*
 	 * Read the array of free blocks.
 	 */
-	mp = tp->t_mountp;
-	if ((error = xfs_alloc_read_agfl(mp, tp,
-			be32_to_cpu(agf->agf_seqno), &agflbp)))
+	error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
+	if (error)
 		return error;
 	agfl = XFS_BUF_TO_AGFL(agflbp);
+
 	/*
 	 * Get the block number and update the data structures.
 	 */
@@ -1980,14 +1980,14 @@ xfs_alloc_get_freelist(
 	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
 		agf->agf_flfirst = 0;
 
-	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
+	pag = xfs_perag_get(mp, agno);
 	be32_add_cpu(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
 	pag->pagf_flcount--;
 	xfs_perag_put(pag);
 
 	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
-	if (btreeblk) {
+	if (type == XFS_FREELIST_BTREE) {
 		be32_add_cpu(&agf->agf_btreeblks, 1);
 		pag->pagf_btreeblks++;
 		logflags |= XFS_AGF_BTREEBLKS;
@@ -2009,8 +2009,11 @@ xfs_alloc_get_freelist(
 	 * that we don't sit and wait with the AGF locked in the transaction
 	 * during the log force.
 	 */
-	if (xfs_alloc_busy_search(mp, be32_to_cpu(agf->agf_seqno), bno, 1))
-		xfs_trans_set_sync(tp);
+	if (type != XFS_FREELIST_BALANCE) {
+		if (xfs_alloc_busy_search(mp, agno, bno, 1))
+			xfs_trans_set_sync(tp);
+	}
+
 	return 0;
 }
 
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-01-17 22:23:05.168004061 +0100
+++ xfs/fs/xfs/xfs_alloc.h	2011-01-17 22:30:06.456005528 +0100
@@ -140,6 +140,13 @@ xfs_alloc_compute_maxlevels(
 	struct xfs_mount	*mp);	/* file system mount structure */
 
 /*
+ * Destination of blocks allocated by xfs_alloc_get_freelist.
+ */
+#define XFS_FREELIST_ALLOC	0
+#define XFS_FREELIST_BTREE	1
+#define XFS_FREELIST_BALANCE	2
+
+/*
  * Get a block from the freelist.
  * Returns with the buffer for the block gotten.
  */
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2011-01-17 22:23:05.155004271 +0100
+++ xfs/fs/xfs/xfs_alloc_btree.c	2011-01-17 22:24:35.867255145 +0100
@@ -83,7 +83,7 @@ xfs_allocbt_alloc_block(
 
 	/* Allocate the new block from the freelist. If we can't, give up.  */
 	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-				       &bno, 1);
+				       &bno, XFS_FREELIST_BTREE);
 	if (error) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
