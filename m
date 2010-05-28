Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4SHmmKX234279 for <xfs@oss.sgi.com>; Fri, 28 May 2010 12:48:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12A66A7CD80
	for <xfs@oss.sgi.com>; Fri, 28 May 2010 10:53:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HBuQe2carESQXhlB for
	<xfs@oss.sgi.com>; Fri, 28 May 2010 10:53:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OI3i8-0002U1-LR
	for xfs@oss.sgi.com; Fri, 28 May 2010 17:51:08 +0000
Date: Fri, 28 May 2010 13:51:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove lazy per-AG initialization
Message-ID: <20100528175108.GA9421@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Historically XFS initializes the allocator / inode allocator per-AG
lazily, that is the first time this information is required.  For
filesystems that use lazy superblock counters (which is the default now)
we already have to walk all AGs to initialize the superblock counters
on an unclean shutdown.  This patch generalizes that code so that we
always initialize the per-AG data on mount, and also during growfs so
that we can remove all the special case code in the fastpath which
couldn't assume that the per-AG data is already initialized.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2010-05-27 20:59:43.299004538 +0200
+++ xfs/fs/xfs/xfs_ag.h	2010-05-27 21:20:35.514254155 +0200
@@ -200,8 +200,6 @@ typedef struct xfs_perag {
 	struct xfs_mount *pag_mount;	/* owner filesystem */
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
 	atomic_t	pag_ref;	/* perag reference count */
-	char		pagf_init;	/* this agf's entry is initialized */
-	char		pagi_init;	/* this agi's entry is initialized */
 	char		pagf_metadata;	/* the agf is preferred to be metadata */
 	char		pagi_inodeok;	/* The agi is ok for inodes */
 	__uint8_t	pagf_levels[XFS_BTNUM_AGF];
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-05-27 20:59:08.806004469 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2010-05-27 21:32:04.893005726 +0200
@@ -1777,18 +1777,6 @@ xfs_alloc_fix_freelist(
 
 	pag = args->pag;
 	tp = args->tp;
-	if (!pag->pagf_init) {
-		if ((error = xfs_alloc_read_agf(mp, tp, args->agno, flags,
-				&agbp)))
-			return error;
-		if (!pag->pagf_init) {
-			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
-			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
-			args->agbp = NULL;
-			return 0;
-		}
-	} else
-		agbp = NULL;
 
 	/*
 	 * If this is a metadata preferred pag and we are user data
@@ -1813,8 +1801,6 @@ xfs_alloc_fix_freelist(
 				longest ||
 		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
 			   need - args->total) < (int)args->minleft)) {
-			if (agbp)
-				xfs_trans_brelse(tp, agbp);
 			args->agbp = NULL;
 			return 0;
 		}
@@ -1824,17 +1810,16 @@ xfs_alloc_fix_freelist(
 	 * Get the a.g. freespace buffer.
 	 * Can fail if we're not blocking on locks, and it's held.
 	 */
+	error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
+	if (error)
+		return error;
 	if (agbp == NULL) {
-		if ((error = xfs_alloc_read_agf(mp, tp, args->agno, flags,
-				&agbp)))
-			return error;
-		if (agbp == NULL) {
-			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
-			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
-			args->agbp = NULL;
-			return 0;
-		}
+		ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
+		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
+		args->agbp = NULL;
+		return 0;
 	}
+
 	/*
 	 * Figure out how many blocks we should have in the freelist.
 	 */
@@ -2040,22 +2025,32 @@ xfs_alloc_log_agf(
 }
 
 /*
- * Interface for inode allocation to force the pag data to be initialized.
+ * Read in the AGF to initialise the per-AG data in the mount structure
  */
-int					/* error */
+int
 xfs_alloc_pagf_init(
-	xfs_mount_t		*mp,	/* file system mount structure */
-	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	int			flags)	/* XFS_ALLOC_FLAGS_... */
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
+	struct xfs_agf		*agf;
 	int			error;
 
-	if ((error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp)))
+	error = xfs_read_agf(mp, NULL, pag->pag_agno, 0, &bp);
+	if (error)
 		return error;
-	if (bp)
-		xfs_trans_brelse(tp, bp);
+
+	agf = XFS_BUF_TO_AGF(bp);
+	pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
+	pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
+	pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
+	pag->pagf_longest = be32_to_cpu(agf->agf_longest);
+	pag->pagf_levels[XFS_BTNUM_BNOi] =
+		be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+	pag->pagf_levels[XFS_BTNUM_CNTi] =
+		be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+
+	xfs_buf_relse(bp);
 	return 0;
 }
 
@@ -2179,8 +2174,6 @@ xfs_alloc_read_agf(
 	int			flags,	/* XFS_ALLOC_FLAG_... */
 	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
 {
-	struct xfs_agf		*agf;		/* ag freelist header */
-	struct xfs_perag	*pag;		/* per allocation group data */
 	int			error;
 
 	ASSERT(agno != NULLAGNUMBER);
@@ -2194,24 +2187,12 @@ xfs_alloc_read_agf(
 		return 0;
 	ASSERT(!XFS_BUF_GETERROR(*bpp));
 
-	agf = XFS_BUF_TO_AGF(*bpp);
-	pag = xfs_perag_get(mp, agno);
-	if (!pag->pagf_init) {
-		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
-		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
-		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
-		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
-		pag->pagf_levels[XFS_BTNUM_BNOi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
-		pag->pagf_levels[XFS_BTNUM_CNTi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
-		spin_lock_init(&pag->pagb_lock);
-		pag->pagb_count = 0;
-		pag->pagb_tree = RB_ROOT;
-		pag->pagf_init = 1;
-	}
 #ifdef DEBUG
-	else if (!XFS_FORCED_SHUTDOWN(mp)) {
+	if (!XFS_FORCED_SHUTDOWN(mp)) {
+		struct xfs_agf		*agf = XFS_BUF_TO_AGF(*bpp);
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, agno);
 		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
@@ -2220,9 +2201,10 @@ xfs_alloc_read_agf(
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
 		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+		xfs_perag_put(pag);
 	}
 #endif
-	xfs_perag_put(pag);
+
 	return 0;
 }
 
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2010-05-27 20:59:08.830004749 +0200
+++ xfs/fs/xfs/xfs_alloc.h	2010-05-27 21:20:35.517293965 +0200
@@ -158,14 +158,9 @@ xfs_alloc_log_agf(
 	int		fields);/* mask of fields to be logged (XFS_AGF_...) */
 
 /*
- * Interface for inode allocation to force the pag data to be initialized.
+ * Read in the AGF to initialise the per-AG data in the mount structure
  */
-int				/* error */
-xfs_alloc_pagf_init(
-	struct xfs_mount *mp,	/* file system mount structure */
-	struct xfs_trans *tp,	/* transaction pointer */
-	xfs_agnumber_t	agno,	/* allocation group number */
-	int		flags);	/* XFS_ALLOC_FLAGS_... */
+int xfs_alloc_pagf_init(struct xfs_mount *mp, struct xfs_perag *pag);
 
 /*
  * Put the block on the freelist for the allocation group.
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-05-27 20:59:39.199003911 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2010-05-27 21:20:35.522254016 +0200
@@ -2552,7 +2552,6 @@ xfs_bmap_btalloc_nullfb(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		ag, startag;
-	int			notinit = 0;
 	int			error;
 
 	if (ap->userdata && xfs_inode_is_filestream(ap->ip))
@@ -2572,25 +2571,14 @@ xfs_bmap_btalloc_nullfb(
 
 	pag = xfs_perag_get(mp, ag);
 	while (*blen < ap->alen) {
-		if (!pag->pagf_init) {
-			error = xfs_alloc_pagf_init(mp, args->tp, ag,
-						    XFS_ALLOC_FLAG_TRYLOCK);
-			if (error) {
-				xfs_perag_put(pag);
-				return error;
-			}
-		}
+		xfs_extlen_t		longest;
 
 		/*
 		 * See xfs_alloc_fix_freelist...
 		 */
-		if (pag->pagf_init) {
-			xfs_extlen_t	longest;
-			longest = xfs_alloc_longest_free_extent(mp, pag);
-			if (*blen < longest)
-				*blen = longest;
-		} else
-			notinit = 1;
+		longest = xfs_alloc_longest_free_extent(mp, pag);
+		if (*blen < longest)
+			*blen = longest;
 
 		if (xfs_inode_is_filestream(ap->ip)) {
 			if (*blen >= ap->alen)
@@ -2633,7 +2621,7 @@ xfs_bmap_btalloc_nullfb(
 	 * Since the above loop did a BUF_TRYLOCK, it is
 	 * possible that there is space for this request.
 	 */
-	if (notinit || *blen < ap->minlen)
+	if (*blen < ap->minlen)
 		args->minlen = ap->minlen;
 	/*
 	 * If the best seen length is less than the request
Index: xfs/fs/xfs/xfs_filestream.c
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.c	2010-05-27 20:59:08.838004330 +0200
+++ xfs/fs/xfs/xfs_filestream.c	2010-05-27 21:20:35.529005308 +0200
@@ -137,7 +137,7 @@ _xfs_filestream_pick_ag(
 	xfs_extlen_t	minlen)
 {
 	int		streams, max_streams;
-	int		err, trylock, nscan;
+	int		nscan;
 	xfs_extlen_t	longest, free, minfree, maxfree = 0;
 	xfs_agnumber_t	ag, max_ag = NULLAGNUMBER;
 	struct xfs_perag *pag;
@@ -148,25 +148,10 @@ _xfs_filestream_pick_ag(
 	ag = startag;
 	*agp = NULLAGNUMBER;
 
-	/* For the first pass, don't sleep trying to init the per-AG. */
-	trylock = XFS_ALLOC_FLAG_TRYLOCK;
-
 	for (nscan = 0; 1; nscan++) {
 		pag = xfs_perag_get(mp, ag);
 		TRACE_AG_SCAN(mp, ag, atomic_read(&pag->pagf_fstrms));
 
-		if (!pag->pagf_init) {
-			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
-			if (err && !trylock) {
-				xfs_perag_put(pag);
-				return err;
-			}
-		}
-
-		/* Might fail sometimes during the 1st pass with trylock set. */
-		if (!pag->pagf_init)
-			goto next_ag;
-
 		/* Keep track of the AG with the most free blocks. */
 		if (pag->pagf_freeblks > maxfree) {
 			maxfree = pag->pagf_freeblks;
@@ -211,12 +196,6 @@ next_ag:
 		if (ag != startag)
 			continue;
 
-		/* Allow sleeping in xfs_alloc_pagf_init() on the 2nd pass. */
-		if (trylock != 0) {
-			trylock = 0;
-			continue;
-		}
-
 		/* Finally, if lowspace wasn't set, set it for the 3rd pass. */
 		if (!(flags & XFS_PICK_LOWSPACE)) {
 			flags |= XFS_PICK_LOWSPACE;
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2010-05-27 20:59:08.855005028 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2010-05-27 21:32:03.104255552 +0200
@@ -448,16 +448,14 @@ xfs_ialloc_ag_select(
 	mode_t		mode,		/* bits set to indicate file type */
 	int		okalloc)	/* ok to allocate more space */
 {
-	xfs_buf_t	*agbp;		/* allocation group header buffer */
 	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
 	xfs_agnumber_t	agno;		/* current ag number */
 	int		flags;		/* alloc buffer locking flags */
-	xfs_extlen_t	ineed;		/* blocks needed for inode allocation */
-	xfs_extlen_t	longest = 0;	/* longest extent available */
 	xfs_mount_t	*mp;		/* mount point structure */
 	int		needspace;	/* file mode implies space allocated */
 	xfs_perag_t	*pag;		/* per allocation group data */
 	xfs_agnumber_t	pagno;		/* parent (starting) ag number */
+	xfs_buf_t	*agbp;
 
 	/*
 	 * Files of these types need at least one block if length > 0
@@ -485,51 +483,37 @@ xfs_ialloc_ag_select(
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
 	for (;;) {
 		pag = xfs_perag_get(mp, agno);
-		if (!pag->pagi_init) {
-			if (xfs_ialloc_read_agi(mp, tp, agno, &agbp)) {
-				agbp = NULL;
-				goto nextag;
-			}
-		} else
-			agbp = NULL;
 
 		if (!pag->pagi_inodeok) {
 			xfs_ialloc_next_ag(mp);
-			goto unlock_nextag;
+			goto nextag;
 		}
 
 		/*
 		 * Is there enough free space for the file plus a block
 		 * of inodes (if we need to allocate some)?
 		 */
-		ineed = pag->pagi_freecount ? 0 : XFS_IALLOC_BLOCKS(mp);
-		if (ineed && !pag->pagf_init) {
-			if (agbp == NULL &&
-			    xfs_ialloc_read_agi(mp, tp, agno, &agbp)) {
-				agbp = NULL;
+		if (!pag->pagi_freecount) {
+			xfs_extlen_t	ineed = XFS_IALLOC_BLOCKS(mp);
+			xfs_extlen_t	longest; /* longest extent available */
+
+			longest = pag->pagf_longest;
+			if (!longest)
+				longest = pag->pagf_flcount > 0;
+
+			if (pag->pagf_freeblks < needspace + ineed)
+				goto nextag;
+			if (longest < ineed)
+				goto nextag;
+			if (!okalloc)
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
+		if (xfs_ialloc_read_agi(mp, tp, agno, &agbp) == 0) {
+			xfs_perag_put(pag);
+			return agbp;
 		}
-unlock_nextag:
-		if (agbp)
-			xfs_trans_brelse(tp, agbp);
+
 nextag:
 		xfs_perag_put(pag);
 		/*
@@ -1504,48 +1488,44 @@ xfs_ialloc_read_agi(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	struct xfs_buf		**bpp)	/* allocation group hdr buf */
 {
-	struct xfs_agi		*agi;	/* allocation group header */
-	struct xfs_perag	*pag;	/* per allocation group data */
 	int			error;
 
 	error = xfs_read_agi(mp, tp, agno, bpp);
-	if (error)
-		return error;
-
-	agi = XFS_BUF_TO_AGI(*bpp);
-	pag = xfs_perag_get(mp, agno);
-	if (!pag->pagi_init) {
-		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
-		pag->pagi_count = be32_to_cpu(agi->agi_count);
-		pag->pagi_init = 1;
-	}
-
+#ifdef DEBUG
 	/*
-	 * It's possible for these to be out of sync if
-	 * we are in the middle of a forced shutdown.
+	 * It's possible for these to be out of sync if we are in the
+	 * middle of a forced shutdown.
 	 */
-	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		XFS_FORCED_SHUTDOWN(mp));
-	xfs_perag_put(pag);
-	return 0;
+	if (!error && !XFS_FORCED_SHUTDOWN(mp)) {
+		struct xfs_perag *pag = xfs_perag_get(mp, agno);
+		ASSERT(pag->pagi_freecount ==
+		        be32_to_cpu(XFS_BUF_TO_AGI(*bpp)->agi_freecount));
+		xfs_perag_put(pag);
+	}
+#endif
+	return error;
 }
 
 /*
- * Read in the agi to initialise the per-ag data in the mount structure
+ * Read in the AGI to initialise the per-AG data in the mount structure
  */
 int
 xfs_ialloc_pagi_init(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno)		/* allocation group number */
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag)
 {
-	xfs_buf_t	*bp = NULL;
-	int		error;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_agi		*agi;
+	int			error;
 
-	error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
+	error = xfs_read_agi(mp, NULL, pag->pag_agno, &bp);
 	if (error)
 		return error;
-	if (bp)
-		xfs_trans_brelse(tp, bp);
+
+	agi = XFS_BUF_TO_AGI(bp);
+	pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
+	pag->pagi_count = be32_to_cpu(agi->agi_count);
+
+	xfs_buf_relse(bp);
 	return 0;
 }
Index: xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.h	2010-05-27 20:59:08.872004190 +0200
+++ xfs/fs/xfs/xfs_ialloc.h	2010-05-27 21:20:35.540024375 +0200
@@ -140,14 +140,9 @@ xfs_ialloc_read_agi(
 	struct xfs_buf	**bpp);		/* allocation group hdr buf */
 
 /*
- * Read in the allocation group header to initialise the per-ag data
- * in the mount structure
+ * Read in the AGI to initialise the per-AG data in the mount structure
  */
-int
-xfs_ialloc_pagi_init(
-	struct xfs_mount *mp,		/* file system mount structure */
-	struct xfs_trans *tp,		/* transaction pointer */
-        xfs_agnumber_t  agno);		/* allocation group number */
+int xfs_ialloc_pagi_init(struct xfs_mount *, struct xfs_perag *);
 
 /*
  * Lookup a record by ino in the btree given by cur.
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-05-27 20:59:43.290004329 +0200
+++ xfs/fs/xfs/xfs_mount.c	2010-05-27 21:20:35.548256111 +0200
@@ -445,6 +445,7 @@ xfs_initialize_perag(
 		pag->pag_mount = mp;
 		rwlock_init(&pag->pag_ici_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+		spin_lock_init(&pag->pagb_lock);
 
 		if (radix_tree_preload(GFP_NOFS))
 			goto out_unwind;
@@ -777,50 +778,78 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
  * this information, write it into the in-core superblock structure.
  */
 STATIC int
-xfs_initialize_perag_data(xfs_mount_t *mp, xfs_agnumber_t agcount)
+xfs_initialize_perag_data(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agcount)
 {
-	xfs_agnumber_t	index;
-	xfs_perag_t	*pag;
-	xfs_sb_t	*sbp = &mp->m_sb;
-	uint64_t	ifree = 0;
-	uint64_t	ialloc = 0;
-	uint64_t	bfree = 0;
-	uint64_t	bfreelst = 0;
-	uint64_t	btree = 0;
-	int		error;
+	xfs_agnumber_t		index;
+	int			error;
 
 	for (index = 0; index < agcount; index++) {
-		/*
-		 * read the agf, then the agi. This gets us
-		 * all the information we need and populates the
-		 * per-ag structures for us.
-		 */
-		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
-		if (error)
-			return error;
+		struct xfs_perag	*pag;
 
-		error = xfs_ialloc_pagi_init(mp, NULL, index);
-		if (error)
-			return error;
 		pag = xfs_perag_get(mp, index);
-		ifree += pag->pagi_freecount;
-		ialloc += pag->pagi_count;
-		bfree += pag->pagf_freeblks;
-		bfreelst += pag->pagf_flcount;
-		btree += pag->pagf_btreeblks;
+		error = xfs_alloc_pagf_init(mp, pag);
+		if (!error)
+			error = xfs_ialloc_pagi_init(mp, pag);
 		xfs_perag_put(pag);
+
+		if (error)
+			return error;
 	}
+
 	/*
-	 * Overwrite incore superblock counters with just-read data
+	 * Now the log is mounted, we know if it was an unclean shutdown or
+	 * not. If it was, with the first phase of recovery has completed, we
+	 * have consistent AG blocks on disk. We have not recovered EFIs yet,
+	 * but they are recovered transactionally in the second recovery phase
+	 * later.
+	 *
+	 * Hence we can safely re-initialise incore superblock counters from
+	 * the per-ag data. These may not be correct if the filesystem was not
+	 * cleanly unmounted, so we need to wait for recovery to finish before
+	 * doing this.
+	 *
+	 * If the filesystem was cleanly unmounted, then we can trust the
+	 * values in the superblock to be correct and we don't need to do
+	 * anything here.
+	 *
+	 * If we are currently making the filesystem, the initialisation will
+	 * fail as the perag data is in an undefined state.
 	 */
-	spin_lock(&mp->m_sb_lock);
-	sbp->sb_ifree = ifree;
-	sbp->sb_icount = ialloc;
-	sbp->sb_fdblocks = bfree + bfreelst + btree;
-	spin_unlock(&mp->m_sb_lock);
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
+	    !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) && !mp->m_sb.sb_inprogress) {
+		struct xfs_sb	*sbp = &mp->m_sb;
+		uint64_t	ifree = 0;
+		uint64_t	ialloc = 0;
+		uint64_t	bfree = 0;
+		uint64_t	bfreelst = 0;
+		uint64_t	btree = 0;
 
-	/* Fixup the per-cpu counters as well. */
-	xfs_icsb_reinit_counters(mp);
+		for (index = 0; index < agcount; index++) {
+			struct xfs_perag	*pag;
+
+			pag = xfs_perag_get(mp, index);
+			ifree += pag->pagi_freecount;
+			ialloc += pag->pagi_count;
+			bfree += pag->pagf_freeblks;
+			bfreelst += pag->pagf_flcount;
+			btree += pag->pagf_btreeblks;
+			xfs_perag_put(pag);
+		}
+
+		/*
+		 * Overwrite incore superblock counters with just-read data
+		 */
+		spin_lock(&mp->m_sb_lock);
+		sbp->sb_ifree = ifree;
+		sbp->sb_icount = ialloc;
+		sbp->sb_fdblocks = bfree + bfreelst + btree;
+		spin_unlock(&mp->m_sb_lock);
+
+		/* Fixup the per-cpu counters as well. */
+		xfs_icsb_reinit_counters(mp);
+	}
 
 	return 0;
 }
@@ -1268,32 +1297,9 @@ xfs_mountfs(
 		goto out_free_perag;
 	}
 
-	/*
-	 * Now the log is mounted, we know if it was an unclean shutdown or
-	 * not. If it was, with the first phase of recovery has completed, we
-	 * have consistent AG blocks on disk. We have not recovered EFIs yet,
-	 * but they are recovered transactionally in the second recovery phase
-	 * later.
-	 *
-	 * Hence we can safely re-initialise incore superblock counters from
-	 * the per-ag data. These may not be correct if the filesystem was not
-	 * cleanly unmounted, so we need to wait for recovery to finish before
-	 * doing this.
-	 *
-	 * If the filesystem was cleanly unmounted, then we can trust the
-	 * values in the superblock to be correct and we don't need to do
-	 * anything here.
-	 *
-	 * If we are currently making the filesystem, the initialisation will
-	 * fail as the perag data is in an undefined state.
-	 */
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
-	    !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
-	     !mp->m_sb.sb_inprogress) {
-		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
-		if (error)
-			goto out_free_perag;
-	}
+	error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
+	if (error)
+		goto out_free_perag;
 
 	/*
 	 * Get and sanity-check the root inode.
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2010-05-27 21:25:26.804004050 +0200
+++ xfs/fs/xfs/xfs_fsops.c	2010-05-27 21:30:51.144009429 +0200
@@ -186,6 +186,8 @@ xfs_growfs_data_private(
 	 */
 	nfree = 0;
 	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
+		struct xfs_perag	*pag;
+
 		/*
 		 * AG freelist header block
 		 */
@@ -305,6 +307,15 @@ xfs_growfs_data_private(
 		if (error) {
 			goto error0;
 		}
+
+		pag = xfs_perag_get(mp, agno);
+		error = xfs_alloc_pagf_init(mp, pag);
+		if (!error)
+			error = xfs_ialloc_pagi_init(mp, pag);
+		xfs_perag_put(pag);
+
+		if (error)
+			goto error0;
 	}
 	xfs_trans_agblocks_delta(tp, nfree);
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
