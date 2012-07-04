Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64EuIqK221632 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 09:56:18 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JmbG7peDf2mkMnQY (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 07:56:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SmR05-0002mH-0W
	for xfs@oss.sgi.com; Wed, 04 Jul 2012 14:56:17 +0000
Message-Id: <20120704145616.894941902@bombadil.infradead.org>
Date: Wed, 04 Jul 2012 10:54:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/7] xfs: merge xfs_ialloc_ag_select into xfs_dialloc
References: <20120704145444.863203951@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dialloc-factor-ag_selection-2
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

Both function contain the same basic loop over all AGs.  Merge the two
by creating three passes in the loop instead of duplicating the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ialloc.c |  179 +++++++++++++++-------------------------------------
 1 file changed, 55 insertions(+), 124 deletions(-)

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2012-07-02 12:25:24.365774992 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2012-07-02 12:26:14.325774734 +0200
@@ -439,114 +439,6 @@ xfs_ialloc_next_ag(
 }
 
 /*
- * Select an allocation group to look for a free inode in, based on the parent
- * inode and then mode.  Return the allocation group buffer.
- */
-STATIC xfs_agnumber_t
-xfs_ialloc_ag_select(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_ino_t	parent,		/* parent directory inode number */
-	umode_t		mode,		/* bits set to indicate file type */
-	int		okalloc)	/* ok to allocate more space */
-{
-	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
-	xfs_agnumber_t	agno;		/* current ag number */
-	int		flags;		/* alloc buffer locking flags */
-	xfs_extlen_t	ineed;		/* blocks needed for inode allocation */
-	xfs_extlen_t	longest = 0;	/* longest extent available */
-	xfs_mount_t	*mp;		/* mount point structure */
-	int		needspace;	/* file mode implies space allocated */
-	xfs_perag_t	*pag;		/* per allocation group data */
-	xfs_agnumber_t	pagno;		/* parent (starting) ag number */
-	int		error;
-
-	/*
-	 * Files of these types need at least one block if length > 0
-	 * (and they won't fit in the inode, but that's hard to figure out).
-	 */
-	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
-	mp = tp->t_mountp;
-	agcount = mp->m_maxagi;
-	if (S_ISDIR(mode))
-		pagno = xfs_ialloc_next_ag(mp);
-	else {
-		pagno = XFS_INO_TO_AGNO(mp, parent);
-		if (pagno >= agcount)
-			pagno = 0;
-	}
-
-	ASSERT(pagno < agcount);
-
-	/*
-	 * Loop through allocation groups, looking for one with a little
-	 * free space in it.  Note we don't look for free inodes, exactly.
-	 * Instead, we include whether there is a need to allocate inodes
-	 * to mean that blocks must be allocated for them,
-	 * if none are currently free.
-	 */
-	agno = pagno;
-	flags = XFS_ALLOC_FLAG_TRYLOCK;
-	for (;;) {
-		pag = xfs_perag_get(mp, agno);
-		if (!pag->pagi_inodeok) {
-			xfs_ialloc_next_ag(mp);
-			goto nextag;
-		}
-
-		if (!pag->pagi_init) {
-			error = xfs_ialloc_pagi_init(mp, tp, agno);
-			if (error)
-				goto nextag;
-		}
-
-		if (pag->pagi_freecount) {
-			xfs_perag_put(pag);
-			return agno;
-		}
-
-		if (!okalloc)
-			goto nextag;
-
-		if (!pag->pagf_init) {
-			error = xfs_alloc_pagf_init(mp, tp, agno, flags);
-			if (error)
-				goto nextag;
-		}
-
-		/*
-		 * Is there enough free space for the file plus a block of
-		 * inodes? (if we need to allocate some)?
-		 */
-		ineed = XFS_IALLOC_BLOCKS(mp);
-		longest = pag->pagf_longest;
-		if (!longest)
-			longest = pag->pagf_flcount > 0;
-
-		if (pag->pagf_freeblks >= needspace + ineed &&
-		    longest >= ineed) {
-			xfs_perag_put(pag);
-			return agno;
-		}
-nextag:
-		xfs_perag_put(pag);
-		/*
-		 * No point in iterating over the rest, if we're shutting
-		 * down.
-		 */
-		if (XFS_FORCED_SHUTDOWN(mp))
-			return NULLAGNUMBER;
-		agno++;
-		if (agno >= agcount)
-			agno = 0;
-		if (agno == pagno) {
-			if (flags == 0)
-				return NULLAGNUMBER;
-			flags = 0;
-		}
-	}
-}
-
-/*
  * Try to retrieve the next record to the left/right from the current one.
  */
 STATIC int
@@ -901,10 +793,10 @@ xfs_dialloc(
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error;
-	int			ialloced;
 	int			noroom = 0;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
+	int			pass;
 
 	if (*IO_agbp) {
 		/*
@@ -917,16 +809,6 @@ xfs_dialloc(
 	}
 
 	/*
-	 * We do not have an agbp, so select an initial allocation
-	 * group for inode allocation.
-	 */
-	start_agno = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
-	if (start_agno == NULLAGNUMBER) {
-		*inop = NULLFSINO;
-		return 0;
-	}
-
-	/*
 	 * If we have already hit the ceiling of inode blocks then clear
 	 * okalloc so we scan all available agi structures for a free
 	 * inode.
@@ -938,12 +820,31 @@ xfs_dialloc(
 	}
 
 	/*
-	 * Loop until we find an allocation group that either has free inodes
-	 * or in which we can allocate some inodes.  Iterate through the
-	 * allocation groups upward, wrapping at the end.
+	 * For directories start with a new allocation groups, for other file
+	 * types aim to find an inode close to the parent.
 	 */
+	if (S_ISDIR(mode)) {
+		start_agno = xfs_ialloc_next_ag(mp);
+		ASSERT(start_agno < mp->m_maxagi);
+	} else {
+		start_agno = XFS_INO_TO_AGNO(mp, parent);
+		if (start_agno >= mp->m_maxagi)
+			start_agno = 0;
+	}
+
+	/*
+	 * Loop through allocation groups, looking for one with a little
+	 * free space in it.  Note we don't look for free inodes, exactly.
+	 * Instead, we include whether there is a need to allocate inodes
+	 * to mean that blocks must be allocated for them, if none are
+	 * currently free.
+	 */
+	*inop = NULLFSINO;
 	agno = start_agno;
+	pass = 0;
 	for (;;) {
+		int			ialloced;
+
 		pag = xfs_perag_get(mp, agno);
 		if (!pag->pagi_inodeok) {
 			xfs_ialloc_next_ag(mp);
@@ -980,6 +881,33 @@ xfs_dialloc(
 			goto nextag;
 		}
 
+		if (!pag->pagf_init) {
+			int flags = pass ? 0 : XFS_ALLOC_FLAG_TRYLOCK;
+
+			error = xfs_alloc_pagf_init(mp, tp, agno, flags);
+			if (error)
+				goto out_error;
+		}
+
+		if (pass < 2) {
+			/*
+			 * Is there enough free space for the file plus a block
+			 * of inodes?
+			 */
+			xfs_extlen_t	longest = pag->pagf_longest;
+			int		needspace =
+				S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
+
+			if (!longest)
+				longest = pag->pagf_flcount > 0;
+
+			if (pag->pagf_freeblks <
+			    XFS_IALLOC_BLOCKS(mp) + needspace)
+				goto nextag;
+			if (longest < XFS_IALLOC_BLOCKS(mp))
+				goto nextag;
+		}
+
 		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
 		if (error) {
 			xfs_trans_brelse(tp, agbp);
@@ -1012,8 +940,11 @@ nextag:
 		if (++agno == mp->m_sb.sb_agcount)
 			agno = 0;
 		if (agno == start_agno) {
-			*inop = NULLFSINO;
-			return noroom ? ENOSPC : 0;
+			if (pass == 2) {
+				*inop = NULLFSINO;
+				return noroom ? ENOSPC : 0;
+			}
+			pass++;
 		}
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
