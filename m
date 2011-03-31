Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2VBQf0m137817 for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 06:26:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A53B21D534AE
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2PLHHAE6LtlE8jbA for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:53 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q5G4X-0006Rm-4T
	for xfs@oss.sgi.com; Thu, 31 Mar 2011 11:29:53 +0000
Message-Id: <20110331112953.077108253@bombadil.infradead.org>
Date: Thu, 31 Mar 2011 07:28:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: do not discard alloc btree blocks
References: <20110331112850.980290062@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dont-discard-allocbtblocks
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

Blocks for the allocation btree are allocated from and release to
the AGFL, and thus frequently reused.  Even worse we do not have
an easy way to avoid using an AGFL block when it is discarded due
to the simple FILO list of free blocks, and thus can frequently
stall on blocks that are currently undergoing a discard.

Add a flag to the busy extent tracking structure to skip the discard for
allocation btree blocks.  In normal operation these blocks are reused
frequently enough that there is no need to discard them anyway, but
if they spill over to the allocation btree as part of a balance we
"leak" blocks that we would otherwise discard.  We could fix this
by adding another flag and keeping these block in the rbtree even
after they aren't busy any more so that we could discard them when
they migrate out of the AGFL.  Given that this would cause significant
overhead I don't think it's worthwile for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2011-03-31 12:27:55.475651908 +0200
+++ xfs/fs/xfs/xfs_ag.h	2011-03-31 12:32:18.650592820 +0200
@@ -189,6 +189,7 @@ struct xfs_busy_extent {
 	xfs_extlen_t	length;
 	unsigned int	flags;
 #define XFS_ALLOC_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
+#define XFS_ALLOC_BUSY_SKIP_DISCARD	0x02	/* do not discard */
 };
 
 /*
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2011-03-31 12:22:56.000000000 +0200
+++ xfs/fs/xfs/xfs_alloc_btree.c	2011-03-31 12:32:18.650592820 +0200
@@ -120,7 +120,8 @@ xfs_allocbt_free_block(
 	if (error)
 		return error;
 
-	xfs_alloc_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
+	xfs_alloc_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
+			      XFS_ALLOC_BUSY_SKIP_DISCARD);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
 }
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-31 12:30:54.407636028 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-03-31 12:32:18.658593173 +0200
@@ -2458,7 +2458,7 @@ xfs_free_extent(
 #endif
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
 	if (!error)
-		xfs_alloc_busy_insert(tp, args.agno, args.agbno, len);
+		xfs_alloc_busy_insert(tp, args.agno, args.agbno, len, 0);
 error0:
 	xfs_perag_put(args.pag);
 	return error;
@@ -2469,7 +2469,8 @@ xfs_alloc_busy_insert(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
-	xfs_extlen_t		len)
+	xfs_extlen_t		len,
+	unsigned int		flags)
 {
 	struct xfs_busy_extent	*new;
 	struct xfs_busy_extent	*busyp;
@@ -2493,6 +2494,7 @@ xfs_alloc_busy_insert(
 	new->bno = bno;
 	new->length = len;
 	INIT_LIST_HEAD(&new->list);
+	new->flags = flags;
 
 	/* trace before insert to be able to see failed inserts */
 	trace_xfs_alloc_busy(tp->t_mountp, agno, bno, len);
@@ -2982,7 +2984,7 @@ xfs_alloc_busy_prepare_discard(
 
 	pag = xfs_perag_get(mp, busyp->agno);
 	spin_lock(&pag->pagb_lock);
-	if (!busyp->length)
+	if (!busyp->length || (busyp->flags & XFS_ALLOC_BUSY_SKIP_DISCARD))
 		ret = false;
 	busyp->flags = XFS_ALLOC_BUSY_DISCARDED;
 	spin_unlock(&pag->pagb_lock);
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-03-31 12:27:55.483617993 +0200
+++ xfs/fs/xfs/xfs_alloc.h	2011-03-31 12:32:19.222130801 +0200
@@ -137,7 +137,7 @@ xfs_alloc_longest_free_extent(struct xfs
 #ifdef __KERNEL__
 void
 xfs_alloc_busy_insert(struct xfs_trans *tp, xfs_agnumber_t agno,
-	xfs_agblock_t bno, xfs_extlen_t len);
+	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
 
 void
 xfs_alloc_busy_clear(struct xfs_mount *mp, struct xfs_busy_extent *busyp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
