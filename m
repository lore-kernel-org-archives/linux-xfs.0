Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55Emcto093249 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 09:48:38 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZcKH4fnQKxg2Veyo (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 07:48:37 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Sbv3k-00051F-HA
	for xfs@oss.sgi.com; Tue, 05 Jun 2012 14:48:36 +0000
Message-Id: <20120605144836.472805881@bombadil.infradead.org>
Date: Tue, 05 Jun 2012 10:46:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] xfs: do not read the AGI buffer in xfs_dialloc until
	nessecary
References: <20120605144647.051012936@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dialloc-cleanup-ag-loop-2
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

Refactor the AG selection loop in xfs_dialloc to operate on the in-memory
perag data as much as possible.  We only read the AGI buffer once we have
selected an AG to allocate inodes now instead of for every AG considered.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ialloc.c |  127 ++++++++++++++++++++++++++++------------------------
 1 file changed, 69 insertions(+), 58 deletions(-)

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2012-06-04 12:54:53.000000000 -0400
+++ xfs/fs/xfs/xfs_ialloc.c	2012-06-04 12:58:07.104263361 -0400
@@ -900,11 +900,10 @@ xfs_dialloc(
 	xfs_mount_t	*mp = tp->t_mountp;
 	xfs_buf_t	*agbp;		/* allocation group header's buffer */
 	xfs_agnumber_t	agno;		/* allocation group number */
-	xfs_agi_t	*agi;		/* allocation group header structure */
 	int		error;		/* error return value */
 	int		ialloced;	/* inode allocation status */
 	int		noroom = 0;	/* no space for inode blk allocation */
-	xfs_agnumber_t	tagno;		/* testing allocation group number */
+	xfs_agnumber_t	start_agno;	/* starting allocation group number */
 	struct xfs_perag *pag;
 
 	if (*IO_agbp) {
@@ -921,25 +920,17 @@ xfs_dialloc(
 	 * We do not have an agbp, so select an initial allocation
 	 * group for inode allocation.
 	 */
-	agno = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
-	if (agno == NULLAGNUMBER) {
+	start_agno = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
+	if (start_agno == NULLAGNUMBER) {
 		*inop = NULLFSINO;
 		return 0;
 	}
 
-	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
-	if (error)
-		return XFS_ERROR(error);
-	agi = XFS_BUF_TO_AGI(agbp);
-
-	tagno = agno;
-
 	/*
 	 * If we have already hit the ceiling of inode blocks then clear
 	 * okalloc so we scan all available agi structures for a free
 	 * inode.
 	 */
-
 	if (mp->m_maxicount &&
 	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
 		noroom = 1;
@@ -951,67 +942,87 @@ xfs_dialloc(
 	 * or in which we can allocate some inodes.  Iterate through the
 	 * allocation groups upward, wrapping at the end.
 	 */
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
-				*IO_agbp = agbp;
-				*inop = NULLFSINO;
-				return 0;
-			}
+	agno = start_agno;
+	for (;;) {
+		pag = xfs_perag_get(mp, agno);
+		if (!pag->pagi_inodeok) {
+			xfs_ialloc_next_ag(mp);
+			goto nextag;
+		}
+
+		if (!pag->pagi_init) {
+			error = xfs_ialloc_pagi_init(mp, tp, agno);
+			if (error)
+				goto out_error;
 		}
+
 		/*
-		 * If it failed, give up on this ag.
+		 * Do a first racy fast path check if this AG is usable.
 		 */
-		xfs_trans_brelse(tp, agbp);
+		if (!pag->pagi_freecount && !okalloc)
+			goto nextag;
+
+		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+		if (error)
+			goto out_error;
+
 		/*
-		 * Go on to the next ag: get its ag header.
+		 * Once the AGI has been read in we have to recheck
+		 * pagi_freecount with the AGI buffer lock held.
 		 */
-nextag:
-		if (++tagno == mp->m_sb.sb_agcount)
-			tagno = 0;
-		if (tagno == agno) {
+		if (pag->pagi_freecount) {
+			xfs_perag_put(pag);
+			goto out_alloc;
+		}
+
+		if (!okalloc) {
+			xfs_trans_brelse(tp, agbp);
+			goto nextag;
+		}
+
+		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
+		if (error) {
+			xfs_trans_brelse(tp, agbp);
+
+			if (error != ENOSPC)
+				goto out_error;
+
+			xfs_perag_put(pag);
 			*inop = NULLFSINO;
-			return noroom ? ENOSPC : 0;
+			return 0;
 		}
-		pag = xfs_perag_get(mp, tagno);
-		if (pag->pagi_inodeok == 0) {
+
+		if (ialloced) {
+			/*
+			 * We successfully allocated some inodes, return
+			 * the current context to the caller so that it
+			 * can commit the current transaction and call
+			 * us again where we left off.
+			 */
+			ASSERT(pag->pagi_freecount > 0);
 			xfs_perag_put(pag);
-			goto nextag;
+
+			*IO_agbp = agbp;
+			*inop = NULLFSINO;
+			return 0;
 		}
-		error = xfs_ialloc_read_agi(mp, tp, tagno, &agbp);
+
+nextag:
 		xfs_perag_put(pag);
-		if (error)
-			goto nextag;
-		agi = XFS_BUF_TO_AGI(agbp);
-		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
+		if (++agno == mp->m_sb.sb_agcount)
+			agno = 0;
+		if (agno == start_agno) {
+			*inop = NULLFSINO;
+			return noroom ? ENOSPC : 0;
+		}
 	}
 
 out_alloc:
 	*IO_agbp = NULL;
 	return xfs_dialloc_ag(tp, agbp, parent, inop);
+out_error:
+	xfs_perag_put(pag);
+	return XFS_ERROR(error);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
