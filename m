Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55EmdZk093258 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 09:48:39 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ECLBWuG5ftvEk6sg (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 07:48:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Sbv3k-00050j-An
	for xfs@oss.sgi.com; Tue, 05 Jun 2012 14:48:36 +0000
Message-Id: <20120605144836.296927585@bombadil.infradead.org>
Date: Tue, 05 Jun 2012 10:46:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/7] xfs: refactor xfs_ialloc_ag_select
References: <20120605144647.051012936@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_ialloc_ag_select
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

Loop over the in-core perag structures and prefer using pagi_freecount over
going out to the AGI buffer where possible.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ialloc.c |   96 ++++++++++++++++++++++++----------------------------
 1 file changed, 46 insertions(+), 50 deletions(-)

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2012-06-04 12:49:31.000000000 -0400
+++ xfs/fs/xfs/xfs_ialloc.c	2012-06-04 12:54:53.000258389 -0400
@@ -442,14 +442,13 @@ xfs_ialloc_next_ag(
  * Select an allocation group to look for a free inode in, based on the parent
  * inode and then mode.  Return the allocation group buffer.
  */
-STATIC xfs_buf_t *			/* allocation group buffer */
+STATIC xfs_agnumber_t
 xfs_ialloc_ag_select(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_ino_t	parent,		/* parent directory inode number */
 	umode_t		mode,		/* bits set to indicate file type */
 	int		okalloc)	/* ok to allocate more space */
 {
-	xfs_buf_t	*agbp;		/* allocation group header buffer */
 	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
 	xfs_agnumber_t	agno;		/* current ag number */
 	int		flags;		/* alloc buffer locking flags */
@@ -459,6 +458,7 @@ xfs_ialloc_ag_select(
 	int		needspace;	/* file mode implies space allocated */
 	xfs_perag_t	*pag;		/* per allocation group data */
 	xfs_agnumber_t	pagno;		/* parent (starting) ag number */
+	int		error;
 
 	/*
 	 * Files of these types need at least one block if length > 0
@@ -474,7 +474,9 @@ xfs_ialloc_ag_select(
 		if (pagno >= agcount)
 			pagno = 0;
 	}
+
 	ASSERT(pagno < agcount);
+
 	/*
 	 * Loop through allocation groups, looking for one with a little
 	 * free space in it.  Note we don't look for free inodes, exactly.
@@ -486,51 +488,45 @@ xfs_ialloc_ag_select(
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
 	for (;;) {
 		pag = xfs_perag_get(mp, agno);
+		if (!pag->pagi_inodeok) {
+			xfs_ialloc_next_ag(mp);
+			goto nextag;
+		}
+
 		if (!pag->pagi_init) {
-			if (xfs_ialloc_read_agi(mp, tp, agno, &agbp)) {
-				agbp = NULL;
+			error = xfs_ialloc_pagi_init(mp, tp, agno);
+			if (error)
 				goto nextag;
-			}
-		} else
-			agbp = NULL;
+		}
 
-		if (!pag->pagi_inodeok) {
-			xfs_ialloc_next_ag(mp);
-			goto unlock_nextag;
+		if (pag->pagi_freecount) {
+			xfs_perag_put(pag);
+			return agno;
 		}
 
-		/*
-		 * Is there enough free space for the file plus a block
-		 * of inodes (if we need to allocate some)?
-		 */
-		ineed = pag->pagi_freecount ? 0 : XFS_IALLOC_BLOCKS(mp);
-		if (ineed && !pag->pagf_init) {
-			if (agbp == NULL &&
-			    xfs_ialloc_read_agi(mp, tp, agno, &agbp)) {
-				agbp = NULL;
+		if (!okalloc)
+			goto nextag;
+
+		if (!pag->pagf_init) {
+			error = xfs_alloc_pagf_init(mp, tp, agno, flags);
+			if (error)
 				goto nextag;
-			}
-			(void)xfs_alloc_pagf_init(mp, tp, agno, flags);
 		}
-		if (!ineed || pag->pagf_init) {
-			if (ineed && !(longest = pag->pagf_longest))
-				longest = pag->pagf_flcount > 0;
-			if (!ineed ||
-			    (pag->pagf_freeblks >= needspace + ineed &&
-			     longest >= ineed &&
-			     okalloc)) {
-				if (agbp == NULL &&
-				    xfs_ialloc_read_agi(mp, tp, agno, &agbp)) {
-					agbp = NULL;
-					goto nextag;
-				}
-				xfs_perag_put(pag);
-				return agbp;
-			}
+
+		/*
+		 * Is there enough free space for the file plus a block of
+		 * inodes? (if we need to allocate some)?
+		 */
+		ineed = XFS_IALLOC_BLOCKS(mp);
+		longest = pag->pagf_longest;
+		if (!longest)
+			longest = pag->pagf_flcount > 0;
+
+		if (pag->pagf_freeblks >= needspace + ineed &&
+		    longest >= ineed) {
+			xfs_perag_put(pag);
+			return agno;
 		}
-unlock_nextag:
-		if (agbp)
-			xfs_trans_brelse(tp, agbp);
 nextag:
 		xfs_perag_put(pag);
 		/*
@@ -538,13 +534,13 @@ nextag:
 		 * down.
 		 */
 		if (XFS_FORCED_SHUTDOWN(mp))
-			return NULL;
+			return NULLAGNUMBER;
 		agno++;
 		if (agno >= agcount)
 			agno = 0;
 		if (agno == pagno) {
 			if (flags == 0)
-				return NULL;
+				return NULLAGNUMBER;
 			flags = 0;
 		}
 	}
@@ -901,13 +897,13 @@ xfs_dialloc(
 	xfs_buf_t	**IO_agbp,	/* in/out ag header's buffer */
 	xfs_ino_t	*inop)		/* inode number allocated */
 {
+	xfs_mount_t	*mp = tp->t_mountp;
 	xfs_buf_t	*agbp;		/* allocation group header's buffer */
 	xfs_agnumber_t	agno;		/* allocation group number */
 	xfs_agi_t	*agi;		/* allocation group header structure */
 	int		error;		/* error return value */
 	int		ialloced;	/* inode allocation status */
 	int		noroom = 0;	/* no space for inode blk allocation */
-	xfs_mount_t	*mp;		/* file system mount structure */
 	xfs_agnumber_t	tagno;		/* testing allocation group number */
 	struct xfs_perag *pag;
 
@@ -925,20 +921,17 @@ xfs_dialloc(
 	 * We do not have an agbp, so select an initial allocation
 	 * group for inode allocation.
 	 */
-	agbp = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
-
-	/*
-	 * Couldn't find an allocation group satisfying the
-	 * criteria, give up.
-	 */
-	if (!agbp) {
+	agno = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
+	if (agno == NULLAGNUMBER) {
 		*inop = NULLFSINO;
 		return 0;
 	}
+
+	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	if (error)
+		return XFS_ERROR(error);
 	agi = XFS_BUF_TO_AGI(agbp);
 
-	mp = tp->t_mountp;
-	agno = be32_to_cpu(agi->agi_seqno);
 	tagno = agno;
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
