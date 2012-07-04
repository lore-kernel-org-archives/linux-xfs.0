Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64EuJWe221662 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 09:56:19 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	9LqBpXVwc7VcLREf (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 07:56:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SmR03-0002jh-Ab
	for xfs@oss.sgi.com; Wed, 04 Jul 2012 14:56:15 +0000
Message-Id: <20120704145615.197446803@bombadil.infradead.org>
Date: Wed, 04 Jul 2012 10:54:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] xfs: split xfs_dialloc
References: <20120704145444.863203951@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-split-xfs_dialloc
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

Move the actual allocation once we have selected an allocation group into a
separate helper, and make xfs_dialloc a wrapper around it.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ialloc.c |  349 +++++++++++++++++++++++++---------------------------
 1 file changed, 174 insertions(+), 175 deletions(-)

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2012-07-02 12:14:21.832445616 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2012-07-02 12:23:27.395775691 +0200
@@ -607,188 +607,35 @@ xfs_ialloc_get_rec(
 }
 
 /*
- * Visible inode allocation functions.
- */
-
-/*
- * Allocate an inode on disk.
- * Mode is used to tell whether the new inode will need space, and whether
- * it is a directory.
+ * Allocate an inode.
  *
- * The arguments IO_agbp and alloc_done are defined to work within
- * the constraint of one allocation per transaction.
- * xfs_dialloc() is designed to be called twice if it has to do an
- * allocation to make more free inodes.  On the first call,
- * IO_agbp should be set to NULL. If an inode is available,
- * i.e., xfs_dialloc() did not need to do an allocation, an inode
- * number is returned.  In this case, IO_agbp would be set to the
- * current ag_buf and alloc_done set to false.
- * If an allocation needed to be done, xfs_dialloc would return
- * the current ag_buf in IO_agbp and set alloc_done to true.
- * The caller should then commit the current transaction, allocate a new
- * transaction, and call xfs_dialloc() again, passing in the previous
- * value of IO_agbp.  IO_agbp should be held across the transactions.
- * Since the agbp is locked across the two calls, the second call is
- * guaranteed to have a free inode available.
- *
- * Once we successfully pick an inode its number is returned and the
- * on-disk data structures are updated.  The inode itself is not read
- * in, since doing so would break ordering constraints with xfs_reclaim.
+ * The caller selected an AG for us, and made sure that free inodes are
+ * available.
  */
-int
-xfs_dialloc(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_ino_t	parent,		/* parent inode (directory) */
-	umode_t		mode,		/* mode bits for new inode */
-	int		okalloc,	/* ok to allocate more space */
-	xfs_buf_t	**IO_agbp,	/* in/out ag header's buffer */
-	boolean_t	*alloc_done,	/* true if we needed to replenish
-					   inode freelist */
-	xfs_ino_t	*inop)		/* inode number allocated */
+STATIC int
+xfs_dialloc_ag(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_ino_t		parent,
+	xfs_ino_t		*inop)
 {
-	xfs_agnumber_t	agcount;	/* number of allocation groups */
-	xfs_buf_t	*agbp;		/* allocation group header's buffer */
-	xfs_agnumber_t	agno;		/* allocation group number */
-	xfs_agi_t	*agi;		/* allocation group header structure */
-	xfs_btree_cur_t	*cur;		/* inode allocation btree cursor */
-	int		error;		/* error return value */
-	int		i;		/* result code */
-	int		ialloced;	/* inode allocation status */
-	int		noroom = 0;	/* no space for inode blk allocation */
-	xfs_ino_t	ino;		/* fs-relative inode to be returned */
-	/* REFERENCED */
-	int		j;		/* result code */
-	xfs_mount_t	*mp;		/* file system mount structure */
-	int		offset;		/* index of inode in chunk */
-	xfs_agino_t	pagino;		/* parent's AG relative inode # */
-	xfs_agnumber_t	pagno;		/* parent's AG number */
-	xfs_inobt_rec_incore_t rec;	/* inode allocation record */
-	xfs_agnumber_t	tagno;		/* testing allocation group number */
-	xfs_btree_cur_t	*tcur;		/* temp cursor */
-	xfs_inobt_rec_incore_t trec;	/* temp inode allocation record */
-	struct xfs_perag *pag;
-
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
+	xfs_agnumber_t		pagno = XFS_INO_TO_AGNO(mp, parent);
+	xfs_agino_t		pagino = XFS_INO_TO_AGINO(mp, parent);
+	struct xfs_perag	*pag;
+	struct xfs_btree_cur	*cur, *tcur;
+	struct xfs_inobt_rec_incore rec, trec;
+	xfs_ino_t		ino;
+	int			error;
+	int			offset;
+	int			i, j;
 
-	if (*IO_agbp == NULL) {
-		/*
-		 * We do not have an agbp, so select an initial allocation
-		 * group for inode allocation.
-		 */
-		agbp = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
-		/*
-		 * Couldn't find an allocation group satisfying the
-		 * criteria, give up.
-		 */
-		if (!agbp) {
-			*inop = NULLFSINO;
-			return 0;
-		}
-		agi = XFS_BUF_TO_AGI(agbp);
-		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
-	} else {
-		/*
-		 * Continue where we left off before.  In this case, we
-		 * know that the allocation group has free inodes.
-		 */
-		agbp = *IO_agbp;
-		agi = XFS_BUF_TO_AGI(agbp);
-		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
-		ASSERT(be32_to_cpu(agi->agi_freecount) > 0);
-	}
-	mp = tp->t_mountp;
-	agcount = mp->m_sb.sb_agcount;
-	agno = be32_to_cpu(agi->agi_seqno);
-	tagno = agno;
-	pagno = XFS_INO_TO_AGNO(mp, parent);
-	pagino = XFS_INO_TO_AGINO(mp, parent);
-
-	/*
-	 * If we have already hit the ceiling of inode blocks then clear
-	 * okalloc so we scan all available agi structures for a free
-	 * inode.
-	 */
-
-	if (mp->m_maxicount &&
-	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
-		noroom = 1;
-		okalloc = 0;
-	}
-
-	/*
-	 * Loop until we find an allocation group that either has free inodes
-	 * or in which we can allocate some inodes.  Iterate through the
-	 * allocation groups upward, wrapping at the end.
-	 */
-	*alloc_done = B_FALSE;
-	while (!agi->agi_freecount) {
-		/*
-		 * Don't do anything if we're not supposed to allocate
-		 * any blocks, just go on to the next ag.
-		 */
-		if (okalloc) {
-			/*
-			 * Try to allocate some new inodes in the allocation
-			 * group.
-			 */
-			if ((error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced))) {
-				xfs_trans_brelse(tp, agbp);
-				if (error == ENOSPC) {
-					*inop = NULLFSINO;
-					return 0;
-				} else
-					return error;
-			}
-			if (ialloced) {
-				/*
-				 * We successfully allocated some inodes, return
-				 * the current context to the caller so that it
-				 * can commit the current transaction and call
-				 * us again where we left off.
-				 */
-				ASSERT(be32_to_cpu(agi->agi_freecount) > 0);
-				*alloc_done = B_TRUE;
-				*IO_agbp = agbp;
-				*inop = NULLFSINO;
-				return 0;
-			}
-		}
-		/*
-		 * If it failed, give up on this ag.
-		 */
-		xfs_trans_brelse(tp, agbp);
-		/*
-		 * Go on to the next ag: get its ag header.
-		 */
-nextag:
-		if (++tagno == agcount)
-			tagno = 0;
-		if (tagno == agno) {
-			*inop = NULLFSINO;
-			return noroom ? ENOSPC : 0;
-		}
-		pag = xfs_perag_get(mp, tagno);
-		if (pag->pagi_inodeok == 0) {
-			xfs_perag_put(pag);
-			goto nextag;
-		}
-		error = xfs_ialloc_read_agi(mp, tp, tagno, &agbp);
-		xfs_perag_put(pag);
-		if (error)
-			goto nextag;
-		agi = XFS_BUF_TO_AGI(agbp);
-		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
-	}
-	/*
-	 * Here with an allocation group that has a free inode.
-	 * Reset agno since we may have chosen a new ag in the
-	 * loop above.
-	 */
-	agno = tagno;
-	*IO_agbp = NULL;
 	pag = xfs_perag_get(mp, agno);
 
  restart_pagno:
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, be32_to_cpu(agi->agi_seqno));
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1021,6 +868,158 @@ error0:
 }
 
 /*
+ * Allocate an inode on disk.
+ *
+ * Mode is used to tell whether the new inode will need space, and whether it
+ * is a directory.
+ *
+ * This function is designed to be called twice if it has to do an allocation
+ * to make more free inodes.  On the first call, *IO_agbp should be set to NULL.
+ * If an inode is available without having to performn an allocation, an inode
+ * number is returned.  In this case, *IO_agbp would be NULL.  If an allocation
+ * needes to be done, xfs_dialloc would return the current AGI buffer in
+ * *IO_agbp.  The caller should then commit the current transaction, allocate a
+ * new transaction, and call xfs_dialloc() again, passing in the previous value
+ * of *IO_agbp.  IO_agbp should be held across the transactions. Since the AGI
+ * buffer is locked across the two calls, the second call is guaranteed to have
+ * a free inode available.
+ *
+ * Once we successfully pick an inode its number is returned and the on-disk
+ * data structures are updated.  The inode itself is not read in, since doing so
+ * would break ordering constraints with xfs_reclaim.
+ */
+int
+xfs_dialloc(
+	struct xfs_trans	*tp,
+	xfs_ino_t		parent,
+	umode_t			mode,
+	int			okalloc,
+	struct xfs_buf		**IO_agbp,
+	boolean_t		*alloc_done,
+	xfs_ino_t		*inop)
+{
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno;
+	struct xfs_agi		*agi;
+	int			error;
+	int			ialloced;
+	int			noroom = 0;
+	struct xfs_mount	*mp;
+	xfs_agnumber_t		tagno;
+	struct xfs_perag	*pag;
+
+	if (*IO_agbp == NULL) {
+		/*
+		 * We do not have an agbp, so select an initial allocation
+		 * group for inode allocation.
+		 */
+		agbp = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
+		/*
+		 * Couldn't find an allocation group satisfying the
+		 * criteria, give up.
+		 */
+		if (!agbp) {
+			*inop = NULLFSINO;
+			return 0;
+		}
+		agi = XFS_BUF_TO_AGI(agbp);
+		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
+	} else {
+		/*
+		 * Continue where we left off before.  In this case, we
+		 * know that the allocation group has free inodes.
+		 */
+		agbp = *IO_agbp;
+		agi = XFS_BUF_TO_AGI(agbp);
+		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
+		ASSERT(be32_to_cpu(agi->agi_freecount) > 0);
+	}
+	mp = tp->t_mountp;
+	agno = be32_to_cpu(agi->agi_seqno);
+	tagno = agno;
+
+	/*
+	 * If we have already hit the ceiling of inode blocks then clear
+	 * okalloc so we scan all available agi structures for a free
+	 * inode.
+	 */
+
+	if (mp->m_maxicount &&
+	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
+		noroom = 1;
+		okalloc = 0;
+	}
+
+	/*
+	 * Loop until we find an allocation group that either has free inodes
+	 * or in which we can allocate some inodes.  Iterate through the
+	 * allocation groups upward, wrapping at the end.
+	 */
+	*alloc_done = B_FALSE;
+	while (!agi->agi_freecount) {
+		/*
+		 * Don't do anything if we're not supposed to allocate
+		 * any blocks, just go on to the next ag.
+		 */
+		if (okalloc) {
+			/*
+			 * Try to allocate some new inodes in the allocation
+			 * group.
+			 */
+			if ((error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced))) {
+				xfs_trans_brelse(tp, agbp);
+				if (error == ENOSPC) {
+					*inop = NULLFSINO;
+					return 0;
+				} else
+					return error;
+			}
+			if (ialloced) {
+				/*
+				 * We successfully allocated some inodes, return
+				 * the current context to the caller so that it
+				 * can commit the current transaction and call
+				 * us again where we left off.
+				 */
+				ASSERT(be32_to_cpu(agi->agi_freecount) > 0);
+				*alloc_done = B_TRUE;
+				*IO_agbp = agbp;
+				*inop = NULLFSINO;
+				return 0;
+			}
+		}
+		/*
+		 * If it failed, give up on this ag.
+		 */
+		xfs_trans_brelse(tp, agbp);
+		/*
+		 * Go on to the next ag: get its ag header.
+		 */
+nextag:
+		if (++tagno == mp->m_sb.sb_agcount)
+			tagno = 0;
+		if (tagno == agno) {
+			*inop = NULLFSINO;
+			return noroom ? ENOSPC : 0;
+		}
+		pag = xfs_perag_get(mp, tagno);
+		if (pag->pagi_inodeok == 0) {
+			xfs_perag_put(pag);
+			goto nextag;
+		}
+		error = xfs_ialloc_read_agi(mp, tp, tagno, &agbp);
+		xfs_perag_put(pag);
+		if (error)
+			goto nextag;
+		agi = XFS_BUF_TO_AGI(agbp);
+		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
+	}
+
+	*IO_agbp = NULL;
+	return xfs_dialloc_ag(tp, agbp, parent, inop);
+}
+
+/*
  * Free disk inode.  Carefully avoids touching the incore inode, all
  * manipulations incore are the caller's responsibility.
  * The on-disk inode is not changed by this operation, only the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
