Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 18:28:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3O1SEfB026569
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 18:28:16 -0700
Date: Tue, 24 Apr 2007 11:28:08 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review [1 of 3]: lazy superblock counters - core kernel
Message-ID: <20070424012808.GD48531920@melbourne.sgi.com>
References: <20070419231459.GX48531920@melbourne.sgi.com> <20070423220010.GA18325@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423220010.GA18325@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 23, 2007 at 11:00:10PM +0100, Christoph Hellwig wrote:
> > +		 * Write into superblock the fields that we haven't
> > +		 * been logging - allocated/free inode and free block
> > +		 * counts - from the incore superblock.
> > + 		 */
> > +		error = xfs_log_sbcount(mp, (XFS_LOG_FORCE|XFS_LOG_SYNC));
> >  
> > -		xfs_icsb_sync_counters(mp);
> > +		sbp = xfs_getsb(mp, 0);
> > + 		sb = XFS_BUF_TO_SBP(sbp);
> > +		if (error) {
> > +			/*
> > +			 * Hmmm - failed to get log reservations so just
> > +			 * do the mod without a transaction. Whine about
> > +			 * it, too.
> > +			 */
> > +			ASSERT(XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb));
> > +			xfs_fs_cmn_err(CE_NOTE, mp,
> > +				"Unmounting, non-transactional sb update");
> > +			s = XFS_SB_LOCK(mp);
> > +			INT_SET(sb->sb_icount, ARCH_CONVERT, mp->m_sb.sb_icount);
> > +			INT_SET(sb->sb_ifree, ARCH_CONVERT, mp->m_sb.sb_ifree);
> > +			INT_SET(sb->sb_fdblocks, ARCH_CONVERT, mp->m_sb.sb_fdblocks);
> > +			XFS_SB_UNLOCK(mp, s);
> 
> This is really quite nasty.  Should we at least force a cache flush here?

Ok, so the patch I sent out was an older version that had a very similar
name to the current patch in my series (xfs-lazy-sb vs xfs_lazy_sb).
This code doesn't exist in the version I should have sent out.

The latest version, plus the changes suggested here and with the
second patch folded back into it is attached.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/linux-2.4/xfs_super.c |    5 -
 fs/xfs/linux-2.4/xfs_vfs.h   |    1 
 fs/xfs/linux-2.6/xfs_vfs.h   |    1 
 fs/xfs/xfs_ag.h              |    8 +-
 fs/xfs/xfs_alloc.c           |   48 ++++++++++---
 fs/xfs/xfs_alloc.h           |    6 +
 fs/xfs/xfs_alloc_btree.c     |   20 +++--
 fs/xfs/xfs_fs.h              |    1 
 fs/xfs/xfs_fsops.c           |    2 
 fs/xfs/xfs_ialloc.c          |   28 ++++++-
 fs/xfs/xfs_ialloc.h          |   10 ++
 fs/xfs/xfs_log.c             |    4 -
 fs/xfs/xfs_log_recover.c     |    8 ++
 fs/xfs/xfs_mount.c           |  154 +++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.h           |   10 +-
 fs/xfs/xfs_sb.h              |   16 +++-
 fs/xfs/xfs_trans.c           |   58 ++++++++++++----
 fs/xfs/xfs_trans.h           |    3 
 fs/xfs/xfs_vfsops.c          |   11 +++
 fs/xfs/xfsidbg.c             |    1 
 20 files changed, 340 insertions(+), 55 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ag.h	2007-04-24 09:53:43.718660132 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ag.h	2007-04-24 09:55:36.295884906 +1000
@@ -68,6 +68,7 @@ typedef struct xfs_agf {
 	__be32		agf_flcount;	/* count of blocks in freelist */
 	__be32		agf_freeblks;	/* total free blocks */
 	__be32		agf_longest;	/* longest free space */
+	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
 } xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
@@ -81,7 +82,8 @@ typedef struct xfs_agf {
 #define	XFS_AGF_FLCOUNT		0x00000100
 #define	XFS_AGF_FREEBLKS	0x00000200
 #define	XFS_AGF_LONGEST		0x00000400
-#define	XFS_AGF_NUM_BITS	11
+#define	XFS_AGF_BTREEBLKS	0x00000800
+#define	XFS_AGF_NUM_BITS	12
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 /* disk block (xfs_daddr_t) in the AG */
@@ -186,11 +188,13 @@ typedef struct xfs_perag
 	__uint32_t	pagf_flcount;	/* count of blocks in freelist */
 	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
 	xfs_extlen_t	pagf_longest;	/* longest free space */
+	__uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
 	xfs_agino_t	pagi_freecount;	/* number of free inodes */
+	xfs_agino_t	pagi_count;	/* number of allocated inodes */
+	int		pagb_count;	/* pagb slots in use */
 #ifdef __KERNEL__
 	lock_t		pagb_lock;	/* lock for pagb_list */
 #endif
-	int		pagb_count;	/* pagb slots in use */
 	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
 
 	/*
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.c	2007-04-24 09:53:43.718660132 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.c	2007-04-24 09:55:36.299884381 +1000
@@ -1447,7 +1447,8 @@ xfs_alloc_ag_vextent_small(
 	else if (args->minlen == 1 && args->alignment == 1 && !args->isfl &&
 		 (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount)
 		  > args->minleft)) {
-		if ((error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno)))
+		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
+		if (error)
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
 			if (args->userdata) {
@@ -1923,7 +1924,8 @@ xfs_alloc_fix_freelist(
 	while (be32_to_cpu(agf->agf_flcount) > need) {
 		xfs_buf_t	*bp;
 
-		if ((error = xfs_alloc_get_freelist(tp, agbp, &bno)))
+		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
+		if (error)
 			return error;
 		if ((error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1)))
 			return error;
@@ -1973,8 +1975,9 @@ xfs_alloc_fix_freelist(
 		 * Put each allocated block on the list.
 		 */
 		for (bno = targs.agbno; bno < targs.agbno + targs.len; bno++) {
-			if ((error = xfs_alloc_put_freelist(tp, agbp, agflbp,
-					bno)))
+			error = xfs_alloc_put_freelist(tp, agbp,
+							agflbp, bno, 0);
+			if (error)
 				return error;
 		}
 	}
@@ -1991,13 +1994,15 @@ int				/* error */
 xfs_alloc_get_freelist(
 	xfs_trans_t	*tp,	/* transaction pointer */
 	xfs_buf_t	*agbp,	/* buffer containing the agf structure */
-	xfs_agblock_t	*bnop)	/* block address retrieved from freelist */
+	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
+	int		btreeblk) /* destination is a AGF btree */
 {
 	xfs_agf_t	*agf;	/* a.g. freespace structure */
 	xfs_agfl_t	*agfl;	/* a.g. freelist structure */
 	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	int		error;
+	int		logflags;
 #ifdef XFS_ALLOC_TRACE
 	static char	fname[] = "xfs_alloc_get_freelist";
 #endif
@@ -2032,8 +2037,16 @@ xfs_alloc_get_freelist(
 	be32_add(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
 	pag->pagf_flcount--;
-	TRACE_MODAGF(NULL, agf, XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT);
-	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT);
+
+	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
+	if (btreeblk) {
+		be32_add(&agf->agf_btreeblks, 1);
+		pag->pagf_btreeblks++;
+		logflags |= XFS_AGF_BTREEBLKS;
+	}
+
+	TRACE_MODAGF(NULL, agf, logflags);
+	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
 
 	/*
@@ -2071,6 +2084,7 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_flcount),
 		offsetof(xfs_agf_t, agf_freeblks),
 		offsetof(xfs_agf_t, agf_longest),
+		offsetof(xfs_agf_t, agf_btreeblks),
 		sizeof(xfs_agf_t)
 	};
 
@@ -2106,12 +2120,14 @@ xfs_alloc_put_freelist(
 	xfs_trans_t		*tp,	/* transaction pointer */
 	xfs_buf_t		*agbp,	/* buffer for a.g. freelist header */
 	xfs_buf_t		*agflbp,/* buffer for a.g. free block array */
-	xfs_agblock_t		bno)	/* block being freed */
+	xfs_agblock_t		bno,	/* block being freed */
+	int			btreeblk) /* block came from a AGF btree */
 {
 	xfs_agf_t		*agf;	/* a.g. freespace structure */
 	xfs_agfl_t		*agfl;	/* a.g. free block array */
 	__be32			*blockp;/* pointer to array entry */
 	int			error;
+	int			logflags;
 #ifdef XFS_ALLOC_TRACE
 	static char		fname[] = "xfs_alloc_put_freelist";
 #endif
@@ -2132,11 +2148,22 @@ xfs_alloc_put_freelist(
 	be32_add(&agf->agf_flcount, 1);
 	xfs_trans_agflist_delta(tp, 1);
 	pag->pagf_flcount++;
+
+	logflags = XFS_AGF_FLLAST | XFS_AGF_FLCOUNT;
+	if (btreeblk) {
+		be32_add(&agf->agf_btreeblks, -1);
+		pag->pagf_btreeblks--;
+		logflags |= XFS_AGF_BTREEBLKS;
+	}
+
+	TRACE_MODAGF(NULL, agf, logflags);
+	xfs_alloc_log_agf(tp, agbp, logflags);
+
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp));
 	blockp = &agfl->agfl_bno[be32_to_cpu(agf->agf_fllast)];
 	*blockp = cpu_to_be32(bno);
-	TRACE_MODAGF(NULL, agf, XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
-	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
+	TRACE_MODAGF(NULL, agf, logflags);
+	xfs_alloc_log_agf(tp, agbp, logflags);
 	xfs_trans_log_buf(tp, agflbp,
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl +
@@ -2196,6 +2223,7 @@ xfs_alloc_read_agf(
 	pag = &mp->m_perag[agno];
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
+		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
 		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
 		pag->pagf_levels[XFS_BTNUM_BNOi] =
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.h	2007-04-24 09:53:43.718660132 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.h	2007-04-24 09:55:36.299884381 +1000
@@ -136,7 +136,8 @@ int				/* error */
 xfs_alloc_get_freelist(
 	struct xfs_trans *tp,	/* transaction pointer */
 	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
-	xfs_agblock_t	*bnop);	/* block address retrieved from freelist */
+	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
+	int		btreeblk); /* destination is a AGF btree */
 
 /*
  * Log the given fields from the agf structure.
@@ -165,7 +166,8 @@ xfs_alloc_put_freelist(
 	struct xfs_trans *tp,	/* transaction pointer */
 	struct xfs_buf	*agbp,	/* buffer for a.g. freelist header */
 	struct xfs_buf	*agflbp,/* buffer for a.g. free block array */
-	xfs_agblock_t	bno);	/* block being freed */
+	xfs_agblock_t	bno,	/* block being freed */
+	int		btreeblk); /* owner was a AGF btree */
 
 /*
  * Read in the allocation group header (free/alloc section).
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc_btree.c	2007-04-24 09:53:43.718660132 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc_btree.c	2007-04-24 09:55:36.303883856 +1000
@@ -226,8 +226,9 @@ xfs_alloc_delrec(
 			/*
 			 * Put this buffer/block on the ag's freelist.
 			 */
-			if ((error = xfs_alloc_put_freelist(cur->bc_tp,
-					cur->bc_private.a.agbp, NULL, bno)))
+			error = xfs_alloc_put_freelist(cur->bc_tp,
+					cur->bc_private.a.agbp, NULL, bno, 1);
+			if (error)
 				return error;
 			/*
 			 * Since blocks move to the free list without the
@@ -549,8 +550,9 @@ xfs_alloc_delrec(
 	/*
 	 * Free the deleting block by putting it on the freelist.
 	 */
-	if ((error = xfs_alloc_put_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-			NULL, rbno)))
+	error = xfs_alloc_put_freelist(cur->bc_tp,
+					 cur->bc_private.a.agbp, NULL, rbno, 1);
+	if (error)
 		return error;
 	/*
 	 * Since blocks move to the free list without the coordination
@@ -1320,8 +1322,9 @@ xfs_alloc_newroot(
 	/*
 	 * Get a buffer from the freelist blocks, for the new root.
 	 */
-	if ((error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-			&nbno)))
+	error = xfs_alloc_get_freelist(cur->bc_tp,
+					cur->bc_private.a.agbp, &nbno, 1);
+	if (error)
 		return error;
 	/*
 	 * None available, we fail.
@@ -1604,8 +1607,9 @@ xfs_alloc_split(
 	 * Allocate the new block from the freelist.
 	 * If we can't do it, we're toast.  Give up.
 	 */
-	if ((error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-			&rbno)))
+	error = xfs_alloc_get_freelist(cur->bc_tp,
+					 cur->bc_private.a.agbp, &rbno, 1);
+	if (error)
 		return error;
 	if (rbno == NULLAGBLOCK) {
 		*stat = 0;
Index: 2.6.x-xfs-new/fs/xfs/xfs_fs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fs.h	2007-04-24 09:53:43.718660132 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fs.h	2007-04-24 09:55:36.303883856 +1000
@@ -238,6 +238,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
 #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
 #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
+#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
 
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_fsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fsops.c	2007-04-24 09:53:43.718660132 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fsops.c	2007-04-24 09:55:36.303883856 +1000
@@ -94,6 +94,8 @@ xfs_fs_geometry(
 				XFS_FSOP_GEOM_FLAGS_DIRV2 : 0) |
 			(XFS_SB_VERSION_HASSECTOR(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_SECTOR : 0) |
+			(xfs_sb_version_haslazysbcount(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
 			(XFS_SB_VERSION_HASATTR2(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0);
 		geo->logsectsize = XFS_SB_VERSION_HASSECTOR(&mp->m_sb) ?
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2007-04-24 09:53:43.718660132 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2007-04-24 09:55:36.307883331 +1000
@@ -123,6 +123,7 @@ xfs_ialloc_ag_alloc(
 	int		blks_per_cluster;  /* fs blocks per inode cluster */
 	xfs_btree_cur_t	*cur;		/* inode btree cursor */
 	xfs_daddr_t	d;		/* disk addr of buffer */
+	xfs_agnumber_t	agno;
 	int		error;
 	xfs_buf_t	*fbuf;		/* new free inodes' buffer */
 	xfs_dinode_t	*free;		/* new free inode structure */
@@ -302,15 +303,15 @@ xfs_ialloc_ag_alloc(
 	}
 	be32_add(&agi->agi_count, newlen);
 	be32_add(&agi->agi_freecount, newlen);
+	agno = be32_to_cpu(agi->agi_seqno);
 	down_read(&args.mp->m_peraglock);
-	args.mp->m_perag[be32_to_cpu(agi->agi_seqno)].pagi_freecount += newlen;
+	args.mp->m_perag[agno].pagi_freecount += newlen;
 	up_read(&args.mp->m_peraglock);
 	agi->agi_newino = cpu_to_be32(newino);
 	/*
 	 * Insert records describing the new inode chunk into the btree.
 	 */
-	cur = xfs_btree_init_cursor(args.mp, tp, agbp,
-			be32_to_cpu(agi->agi_seqno),
+	cur = xfs_btree_init_cursor(args.mp, tp, agbp, agno,
 			XFS_BTNUM_INO, (xfs_inode_t *)0, 0);
 	for (thisino = newino;
 	     thisino < newino + newlen;
@@ -1460,6 +1461,7 @@ xfs_ialloc_read_agi(
 	pag = &mp->m_perag[agno];
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
+		pag->pagi_count = be32_to_cpu(agi->agi_count);
 		pag->pagi_init = 1;
 	} else {
 		/*
@@ -1483,3 +1485,23 @@ xfs_ialloc_read_agi(
 	*bpp = bp;
 	return 0;
 }
+
+/*
+ * Read in the agi to initialise the per-ag data in the mount structure
+ */
+int
+xfs_ialloc_pagi_init(
+	xfs_mount_t	*mp,		/* file system mount structure */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_agnumber_t	agno)		/* allocation group number */
+{
+	xfs_buf_t	*bp = NULL;
+	int		error;
+
+	error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
+	if (error)
+		return error;
+	if (bp)
+		xfs_trans_brelse(tp, bp);
+	return 0;
+}
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.h	2007-04-24 09:53:43.718660132 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.h	2007-04-24 09:55:36.307883331 +1000
@@ -149,6 +149,16 @@ xfs_ialloc_read_agi(
 	xfs_agnumber_t	agno,		/* allocation group number */
 	struct xfs_buf	**bpp);		/* allocation group hdr buf */
 
+/*
+ * Read in the allocation group header to initialise the per-ag data
+ * in the mount structure
+ */
+int
+xfs_ialloc_pagi_init(
+	struct xfs_mount *mp,		/* file system mount structure */
+	struct xfs_trans *tp,		/* transaction pointer */
+        xfs_agnumber_t  agno);		/* allocation group number */
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_IALLOC_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-04-24 09:53:43.730658557 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-04-24 09:55:36.311882807 +1000
@@ -827,10 +827,8 @@ xfs_log_need_covered(xfs_mount_t *mp)
 	SPLDECL(s);
 	int		needed = 0;
 	xlog_t		*log = mp->m_log;
-	bhv_vfs_t	*vfsp = XFS_MTOVFS(mp);
 
-	if (vfs_test_for_freeze(vfsp) || XFS_FORCED_SHUTDOWN(mp) ||
-	    (vfsp->vfs_flag & VFS_RDONLY))
+	if (!xfs_fs_writable(mp))
 		return 0;
 
 	s = LOG_LOCK(log);
Index: 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_recover.c	2007-04-24 09:53:43.730658557 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c	2007-04-24 09:55:36.311882807 +1000
@@ -927,6 +927,14 @@ xlog_find_tail(
 			ASSIGN_ANY_LSN_HOST(log->l_last_sync_lsn, log->l_curr_cycle,
 					after_umount_blk);
 			*tail_blk = after_umount_blk;
+
+			/*
+			 * Note that the unmount was clean. If the unmount
+			 * was not clean, we need to know this to rebuild the
+			 * superblock counters from the perag headers if we
+			 * have a filesystem using non-persistent counters.
+			 */
+			log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
 		}
 	}
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-04-24 09:53:43.730658557 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-04-24 11:13:53.568072816 +1000
@@ -625,6 +625,64 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 					sbp->sb_inopblock);
 	mp->m_ialloc_blks = mp->m_ialloc_inos >> sbp->sb_inopblog;
 }
+
+/*
+ * xfs_initialize_perag_data
+ *
+ * Read in each per-ag structure so we can count up the number of
+ * allocated inodes, free inodes and used filesystem blocks as this
+ * information is no longer persistent in the superblock. Once we have
+ * this information, write it into the in-core superblock structure.
+ */
+STATIC int
+xfs_initialize_perag_data(xfs_mount_t *mp, xfs_agnumber_t agcount)
+{
+	xfs_agnumber_t	index;
+	xfs_perag_t	*pag;
+	xfs_sb_t	*sbp = &mp->m_sb;
+	uint64_t	ifree = 0;
+	uint64_t	ialloc = 0;
+	uint64_t	bfree = 0;
+	uint64_t	bfreelst = 0;
+	uint64_t	btree = 0;
+	int		error;
+	int		s;
+
+	for (index = 0; index < agcount; index++) {
+		/*
+		 * read the agf, then the agi. This gets us
+		 * all the inforamtion we need and populates the
+		 * per-ag structures for us.
+		 */
+		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
+		if (error)
+			return error;
+
+		error = xfs_ialloc_pagi_init(mp, NULL, index);
+		if (error)
+			return error;
+		pag = &mp->m_perag[index];
+		ifree += pag->pagi_freecount;
+		ialloc += pag->pagi_count;
+		bfree += pag->pagf_freeblks;
+		bfreelst += pag->pagf_flcount;
+		btree += pag->pagf_btreeblks;
+	}
+	/*
+	 * Overwrite incore superblock counters with just-read data
+	 */
+	s = XFS_SB_LOCK(mp);
+	sbp->sb_ifree = ifree;
+	sbp->sb_icount = ialloc;
+	sbp->sb_fdblocks = bfree + bfreelst + btree;
+	XFS_SB_UNLOCK(mp, s);
+
+	/* Fixup the per-cpu counters as well. */
+	xfs_icsb_reinit_counters(mp);
+
+	return 0;
+}
+
 /*
  * xfs_mountfs
  *
@@ -968,6 +1026,34 @@ xfs_mountfs(
 	}
 
 	/*
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
+	 */
+
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
+	    !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
+	     !mp->m_sb.sb_inprogress) {
+		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
+		if (error) {
+			goto error2;
+		}
+	}
+	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
 	 */
@@ -1030,6 +1116,7 @@ xfs_mountfs(
 		goto error4;
 	}
 
+
 	/*
 	 * Complete the quota initialisation, post-log-replay component.
 	 */
@@ -1091,10 +1178,9 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
 		xfs_binval(mp->m_rtdev_targp);
 	}
 
+	xfs_log_sbcount(mp, 1);
 	xfs_unmountfs_writesb(mp);
-
 	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
-
 	xfs_log_unmount(mp);			/* Done! No more fs ops. */
 
 	xfs_freesb(mp);
@@ -1141,6 +1227,62 @@ xfs_unmountfs_wait(xfs_mount_t *mp)
 }
 
 int
+xfs_fs_writable(xfs_mount_t *mp)
+{
+	bhv_vfs_t	*vfsp = XFS_MTOVFS(mp);
+
+	return !(vfs_test_for_freeze(vfsp) || XFS_FORCED_SHUTDOWN(mp) ||
+		(vfsp->vfs_flag & VFS_RDONLY));
+}
+
+/*
+ * xfs_log_sbcount
+ *
+ * Called either periodically to keep the on disk superblock values
+ * roughly up to date or from unmount to make sure the values are
+ * correct on a clean unmount.
+ *
+ * Note this code can be called during the process of freezing, so
+ * we may need to use the transaction allocator which does not not
+ * block when the transaction subsystem is in its frozen state.
+ */
+int
+xfs_log_sbcount(
+	xfs_mount_t	*mp,
+	uint		sync)
+{
+	xfs_trans_t	*tp;
+	int		error;
+
+	if (!xfs_fs_writable(mp))
+		return 0;
+
+	xfs_icsb_sync_counters(mp);
+
+	/*
+	 * we don't need to do this if we are updating the superblock
+	 * counters on every modification.
+	 */
+	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
+		return 0;
+
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT);
+	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
+					XFS_DEFAULT_LOG_COUNT);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_mod_sb(tp, XFS_SB_IFREE | XFS_SB_ICOUNT | XFS_SB_FDBLOCKS);
+	if (sync)
+		xfs_trans_set_sync(tp);
+	xfs_trans_commit(tp, 0);
+
+	return 0;
+}
+
+int
 xfs_unmountfs_writesb(xfs_mount_t *mp)
 {
 	xfs_buf_t	*sbp;
@@ -1151,16 +1293,15 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 	 * skip superblock write if fs is read-only, or
 	 * if we are doing a forced umount.
 	 */
-	sbp = xfs_getsb(mp, 0);
 	if (!(XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY ||
 		XFS_FORCED_SHUTDOWN(mp))) {
 
-		xfs_icsb_sync_counters(mp);
+		sbp = xfs_getsb(mp, 0);
+ 		sb = XFS_BUF_TO_SBP(sbp);
 
 		/*
 		 * mark shared-readonly if desired
 		 */
-		sb = XFS_BUF_TO_SBP(sbp);
 		if (mp->m_mk_sharedro) {
 			if (!(sb->sb_flags & XFS_SBF_READONLY))
 				sb->sb_flags |= XFS_SBF_READONLY;
@@ -1169,6 +1310,7 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 			xfs_fs_cmn_err(CE_NOTE, mp,
 				"Unmounting, marking shared read-only");
 		}
+
 		XFS_BUF_UNDONE(sbp);
 		XFS_BUF_UNREAD(sbp);
 		XFS_BUF_UNDELAYWRITE(sbp);
@@ -1183,8 +1325,8 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 					  mp, sbp, XFS_BUF_ADDR(sbp));
 		if (error && mp->m_mk_sharedro)
 			xfs_fs_cmn_err(CE_ALERT, mp, "Superblock write error detected while unmounting.  Filesystem may not be marked shared readonly");
+		xfs_buf_relse(sbp);
 	}
-	xfs_buf_relse(sbp);
 	return error;
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2007-04-24 09:53:43.730658557 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2007-04-24 09:55:36.315882282 +1000
@@ -441,12 +441,12 @@ typedef struct xfs_mount {
 /*
  * Flags for m_flags.
  */
-#define	XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
+#define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
-#define	XFS_MOUNT_INO64		(1ULL << 1)
+#define XFS_MOUNT_INO64		(1ULL << 1)
 			     /* (1ULL << 2)	-- currently unused */
-			     /* (1ULL << 3)	-- currently unused */
+#define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
 						   disk errors in metadata */
@@ -523,6 +523,8 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 
 #define XFS_MAXIOFFSET(mp)	((mp)->m_maxioffset)
 
+#define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
+				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
 #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
 #define xfs_force_shutdown(m,f)	\
 	bhv_vfs_force_shutdown((XFS_MTOVFS(m)), f, __FILE__, __LINE__)
@@ -614,6 +616,7 @@ typedef struct xfs_mod_sb {
 
 extern xfs_mount_t *xfs_mount_init(void);
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
+extern int	xfs_log_sbcount(xfs_mount_t *, uint);
 extern void	xfs_mount_free(xfs_mount_t *mp, int remove_bhv);
 extern int	xfs_mountfs(struct bhv_vfs *, xfs_mount_t *mp, int);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
@@ -630,6 +633,7 @@ extern int	xfs_mod_incore_sb_batch(xfs_m
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
+extern int	xfs_fs_writable(xfs_mount_t *);
 extern void	xfs_do_force_shutdown(bhv_desc_t *, int, char *, int);
 extern int	xfs_syncsub(xfs_mount_t *, int, int *);
 extern int	xfs_sync_inodes(xfs_mount_t *, int, int *);
Index: 2.6.x-xfs-new/fs/xfs/xfs_sb.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_sb.h	2007-04-24 09:53:43.730658557 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_sb.h	2007-04-24 09:55:36.315882282 +1000
@@ -74,12 +74,13 @@ struct xfs_mount;
  */
 #define XFS_SB_VERSION2_REALFBITS	0x00ffffff	/* Mask: features */
 #define XFS_SB_VERSION2_RESERVED1BIT	0x00000001
-#define XFS_SB_VERSION2_RESERVED2BIT	0x00000002
+#define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
-	(XFS_SB_VERSION2_ATTR2BIT)
+	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
+	 XFS_SB_VERSION2_ATTR2BIT)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -181,6 +182,9 @@ typedef enum {
 #define XFS_SB_SHARED_VN	XFS_SB_MVAL(SHARED_VN)
 #define XFS_SB_UNIT		XFS_SB_MVAL(UNIT)
 #define XFS_SB_WIDTH		XFS_SB_MVAL(WIDTH)
+#define XFS_SB_ICOUNT		XFS_SB_MVAL(ICOUNT)
+#define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
+#define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
@@ -188,7 +192,7 @@ typedef enum {
 	(XFS_SB_UUID | XFS_SB_ROOTINO | XFS_SB_RBMINO | XFS_SB_RSUMINO | \
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
-	 XFS_SB_FEATURES2)
+	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2)
 
 
 /*
@@ -414,6 +418,12 @@ static inline int xfs_sb_version_hasmore
  *	 ((sbp)->sb_features2 & XFS_SB_VERSION2_FUNBIT)
  */
 
+static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_HASMOREBITS(sbp) &&	\
+		((sbp)->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
+}
+
 #define XFS_SB_VERSION_HASATTR2(sbp)	xfs_sb_version_hasattr2(sbp)
 static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
 {
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.c	2007-04-24 09:53:43.730658557 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.c	2007-04-24 09:55:36.315882282 +1000
@@ -427,6 +427,14 @@ undo_blocks:
  *
  * Mark the transaction structure to indicate that the superblock
  * needs to be updated before committing.
+ *
+ * Because we may not be keeping track of allocated/free inodes and
+ * used filesystem blocks in the superblock, we do not mark the
+ * superblock dirty in this transaction if we modify these fields.
+ * We still need to update the transaction deltas so that they get
+ * applied to the incore superblock, but we don't want them to
+ * cause the superblock to get locked and logged if these are the
+ * only fields in the superblock that the transaction modifies.
  */
 void
 xfs_trans_mod_sb(
@@ -434,13 +442,19 @@ xfs_trans_mod_sb(
 	uint		field,
 	int64_t		delta)
 {
+	uint32_t	flags = (XFS_TRANS_DIRTY|XFS_TRANS_SB_DIRTY);
+	xfs_mount_t	*mp = tp->t_mountp;
 
 	switch (field) {
 	case XFS_TRANS_SB_ICOUNT:
 		tp->t_icount_delta += delta;
+		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_IFREE:
 		tp->t_ifree_delta += delta;
+		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_FDBLOCKS:
 		/*
@@ -453,6 +467,8 @@ xfs_trans_mod_sb(
 			ASSERT(tp->t_blk_res_used <= tp->t_blk_res);
 		}
 		tp->t_fdblocks_delta += delta;
+		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_RES_FDBLOCKS:
 		/*
@@ -462,6 +478,8 @@ xfs_trans_mod_sb(
 		 */
 		ASSERT(delta < 0);
 		tp->t_res_fdblocks_delta += delta;
+		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_FREXTENTS:
 		/*
@@ -544,18 +562,23 @@ xfs_trans_apply_sb_deltas(
 	       (tp->t_ag_freeblks_delta + tp->t_ag_flist_delta +
 		tp->t_ag_btree_delta));
 
-	if (tp->t_icount_delta != 0) {
-		INT_MOD(sbp->sb_icount, ARCH_CONVERT, tp->t_icount_delta);
-	}
-	if (tp->t_ifree_delta != 0) {
-		INT_MOD(sbp->sb_ifree, ARCH_CONVERT, tp->t_ifree_delta);
-	}
+	/*
+	 * Only update the superblock counters if we are logging them
+	 */
+	if (!xfs_sb_version_haslazysbcount(&(tp->t_mountp->m_sb))) {
+		if (tp->t_icount_delta != 0) {
+			INT_MOD(sbp->sb_icount, ARCH_CONVERT, tp->t_icount_delta);
+		}
+		if (tp->t_ifree_delta != 0) {
+			INT_MOD(sbp->sb_ifree, ARCH_CONVERT, tp->t_ifree_delta);
+		}
 
-	if (tp->t_fdblocks_delta != 0) {
-		INT_MOD(sbp->sb_fdblocks, ARCH_CONVERT, tp->t_fdblocks_delta);
-	}
-	if (tp->t_res_fdblocks_delta != 0) {
-		INT_MOD(sbp->sb_fdblocks, ARCH_CONVERT, tp->t_res_fdblocks_delta);
+		if (tp->t_fdblocks_delta != 0) {
+			INT_MOD(sbp->sb_fdblocks, ARCH_CONVERT, tp->t_fdblocks_delta);
+		}
+		if (tp->t_res_fdblocks_delta != 0) {
+			INT_MOD(sbp->sb_fdblocks, ARCH_CONVERT, tp->t_res_fdblocks_delta);
+		}
 	}
 
 	if (tp->t_frextents_delta != 0) {
@@ -627,6 +650,7 @@ xfs_trans_unreserve_and_mod_sb(
 {
 	xfs_mod_sb_t	msb[14];	/* If you add cases, add entries */
 	xfs_mod_sb_t	*msbp;
+	xfs_mount_t	*mp = tp->t_mountp;
 	/* REFERENCED */
 	int		error;
 	int		rsvd;
@@ -659,8 +683,15 @@ xfs_trans_unreserve_and_mod_sb(
 	 * The t_res_fdblocks_delta and t_res_frextents_delta fields are
 	 * explicitly NOT applied to the in-core superblock.
 	 * The idea is that that has already been done.
+	 *
+	 * If we are not logging superblock counters, then the inode
+	 * allocated/free and used block counts are not updated in the
+	 * on disk superblock. In this case, XFS_TRANS_SB_DIRTY will
+	 * not be set when the transaction is updated but we still need
+	 * to update the incore superblock with the changes.
 	 */
-	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 		if (tp->t_icount_delta != 0) {
 			msbp->msb_field = XFS_SBS_ICOUNT;
 			msbp->msb_delta = tp->t_icount_delta;
@@ -676,6 +707,9 @@ xfs_trans_unreserve_and_mod_sb(
 			msbp->msb_delta = tp->t_fdblocks_delta;
 			msbp++;
 		}
+	}
+
+	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
 		if (tp->t_frextents_delta != 0) {
 			msbp->msb_field = XFS_SBS_FREXTENTS;
 			msbp->msb_delta = tp->t_frextents_delta;
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.h	2007-04-24 09:53:43.734658033 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.h	2007-04-24 09:55:36.319881757 +1000
@@ -94,7 +94,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_GROWFSRT_ZERO		38
 #define	XFS_TRANS_GROWFSRT_FREE		39
 #define	XFS_TRANS_SWAPEXT		40
-#define	XFS_TRANS_TYPE_MAX		40
+#define	XFS_TRANS_SB_COUNT		41
+#define	XFS_TRANS_TYPE_MAX		41
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-04-24 09:53:43.734658033 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-04-24 11:14:01.962980516 +1000
@@ -684,6 +684,7 @@ xfs_mntupdate(
 	} else if (!(vfsp->vfs_flag & VFS_RDONLY)) {	/* rw -> ro */
 		bhv_vfs_sync(vfsp, SYNC_FSDATA|SYNC_BDFLUSH|SYNC_ATTR, NULL);
 		xfs_quiesce_fs(mp);
+		xfs_log_sbcount(mp, 1);
 		xfs_log_unmount_write(mp);
 		xfs_unmountfs_writesb(mp);
 		vfsp->vfs_flag |= VFS_RDONLY;
@@ -1535,6 +1536,15 @@ xfs_syncsub(
 	}
 
 	/*
+	 * If asked, update the disk superblock with incore counter values if we
+	 * are using non-persistent counters so that they don't get too far out
+	 * of sync if we crash or get a forced shutdown. We don't want to force
+	 * this to disk, just get a transaction into the iclogs....
+	 */
+	if (flags & SYNC_SUPER)
+		xfs_log_sbcount(mp, 0);
+
+	/*
 	 * Now check to see if the log needs a "dummy" transaction.
 	 */
 
@@ -2000,6 +2010,7 @@ xfs_freeze(
 	ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
 
 	/* Push the superblock and write an unmount record */
+	xfs_log_sbcount(mp, 1);
 	xfs_log_unmount_write(mp);
 	xfs_unmountfs_writesb(mp);
 	xfs_fs_log_dummy(mp);
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-04-24 09:53:43.866640708 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-04-24 09:55:36.323881232 +1000
@@ -6042,6 +6042,7 @@ xfsidbg_print_trans_type(unsigned int t_
 	case XFS_TRANS_GROWFSRT_ZERO:	kdb_printf("GROWFSRT_ZERO");	break;
 	case XFS_TRANS_GROWFSRT_FREE:	kdb_printf("GROWFSRT_FREE");	break;
   	case XFS_TRANS_SWAPEXT:		kdb_printf("SWAPEXT");		break;
+	case XFS_TRANS_SB_COUNT:	kdb_printf("SB_COUNT");		break;
  	case XFS_TRANS_DUMMY1:		kdb_printf("DUMMY1");		break;
  	case XFS_TRANS_DUMMY2:		kdb_printf("DUMMY2");		break;
  	case XLOG_UNMOUNT_REC_TYPE:	kdb_printf("UNMOUNT");		break;
Index: 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.4/xfs_super.c	2007-04-24 11:13:22.564106903 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_super.c	2007-04-24 11:14:01.894989362 +1000
@@ -504,7 +504,8 @@ vfs_sync_worker(
 {
 	if (!(vfsp->vfs_flag & VFS_RDONLY))
 		bhv_vfs_sync(vfsp, SYNC_FSDATA | SYNC_BDFLUSH | \
-				   SYNC_ATTR | SYNC_REFCACHE, NULL);
+				   SYNC_ATTR | SYNC_REFCACHE | SYNC_SUPER,
+				   NULL);
 }
 
 STATIC int
@@ -680,7 +681,7 @@ struct super_block *freeze_bdev(struct b
 		wmb();
 
 		/* Flush any remaining inodes into buffers */
-		bhv_vfs_sync(vfsp, SYNC_ATTR | SYNC_WAIT, NULL);
+		bhv_vfs_sync(vfsp, SYNC_SUPER | SYNC_ATTR | SYNC_WAIT, NULL);
 
 		 /* Push all buffers out to disk */
 		sync_buffers(sb->s_dev, 1);
Index: 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_vfs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.4/xfs_vfs.h	2007-04-24 11:13:22.556107943 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_vfs.h	2007-04-24 11:14:01.918986240 +1000
@@ -93,6 +93,7 @@ typedef enum {
 #define SYNC_REFCACHE		0x0040  /* prune some of the nfs ref cache */
 #define SYNC_REMOUNT		0x0080  /* remount readonly, no dummy LRs */
 #define SYNC_IOWAIT		0x0100  /* wait for all I/O to complete */
+#define SYNC_SUPER		0x0200  /* flush superblock to disk */
 
 #define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
 #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-04-24 11:13:22.540110025 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h	2007-04-24 11:14:01.946982597 +1000
@@ -92,6 +92,7 @@ typedef enum {
 #define SYNC_REFCACHE		0x0040  /* prune some of the nfs ref cache */
 #define SYNC_REMOUNT		0x0080  /* remount readonly, no dummy LRs */
 #define SYNC_IOWAIT		0x0100  /* wait for all I/O to complete */
+#define SYNC_SUPER		0x0200  /* flush superblock to disk */
 
 #define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
 #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
