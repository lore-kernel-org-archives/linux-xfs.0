Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 16:15:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3JNF8fB028708
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 16:15:10 -0700
Date: Fri, 20 Apr 2007 09:15:00 +1000
From: David Chinner <dgc@sgi.com>
Subject: review [1 of 3]: lazy superblock counters - core kernel
Message-ID: <20070419231459.GX48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Introduce lazy superblock accounting.

When we have a couple of hundred transactions on the fly at once,
they all typically modify the on disk superblock in some way.
create/unclink/mkdir/rmdir modify inode counts, allocation/freeing
modify free block counts.

When these counts are modified in a transaction, the must eventually
lock the superblock buffer and apply the mods.  The buffer then
remains locked until the transaction is committed into the incore
log buffer. The result of this is that with enough transactions on
the fly the incore superblock buffer becomes a bottleneck.

The result of contention on the incore superblock buffer is that
transaction rates fall - the more pressure that is put on the
superblock buffer, the slower things go.

Some of you might remember the dbench test teh Samba folks
did a couple of years back that showed these sorts of results:

http://samba.org/~tridge/xattr_results/noxattr.png

Here are some numbers from Irix XFS from 2 years ago when I did
this work originally (the first major piece of work I did on
XFS!):

Loads      rate MB/s          CPU (%)      csw/s
          stock   lazy    stock  lazy   stock lazy
-----    ------ ------    ----- -----   ----- ----
    1     82.93  75.07     87.8  88.9     701  692
    2     94.98  88.11    183.8 184.7     299  287
    3    110.66 101.62    278.6 279.2     431  353
    4    120.75 113.75    365.5 367.7     599  492
    8    101.12 114.00    274.4 369.7    1989  545
   15     96.44 116.57    255.9 370.5    1874  453
   30     95.52 116.22    246.8 370.6    1831  465
   50     93.35  94.63    238.7 272.9    2195  744
   75     92.43 110.67    235.7 369.4    2599 2689
  100     89.95 113.07    236.5 367.2    2847 1940
  125     84.47 112.72    214.8 369.8    2786 2316
  150     83.38 109.36    215.0 366.4    2902 3567
  175     87.56 109.25    223.5 363.3    3088 3141
  200     86.03 104.97    234.7 346.3    3282 3470
  250     72.82 106.10    246.7 342.3    3374 4470
  300     62.21 100.86    249.7 319.4    3649 5175
  400     40.48 110.38    193.7 327.2    3885 6251
  500     58.53 119.91    162.4 304.0    3682 6098
  750     51.44 124.05    159.0 240.2    3592 6217
  1000    65.18 144.17    179.6 219.1    4732 6345

As you can see, perfromance starts to drop off under pretty low
numbers of concurrent processes on a normal filesystem, but with
lazy superblock accounting the performance does not drop off - we
get a change of behaviour instead and we start contending on
different, more parallelised objects (e.g. AGF and AGI buffers) and
hence we don't hit a single point of contention that limits us.

[ FWIW, Nathan addressed the xattr performance problems shown by
these dbench tests with attr2. ]

It should also be noted that this modification does not improve
peak performance - it provides graceful behaviour in overload
conditions more than anything else.

The key to removing the contention is to not require the superblock
fields in question to be locked. We do that by not marking the
superblock dirty in the transaction. IOWs, we modify the incore
superblock but do not modify the cached superblock buffer. In short,
we do not log superblock modifications to critical fields in the
superblock on every transaction. In fact we only do it just before
we write the superblock to disk every sync period or just before
unmount.

This creates an interesting problem - if we don't log or write out
the fileds in every transaction, then how do the values get
recovered after a crash? the answer is simple - we keep enough
duplicate, logged information in other structures that we can
reconstruct the correct count  after log recovery has been
performed.

It is the AGF and AGI structures that contain the duplicate
information; after recovery, we walk every AGI and AGF and sum their
individual counters to get the correct value, and we do a
transaction into the log to correct them. An optimisation of this is
that if we have a clean unmount record, we know the value in the
superblock is correct, so we can avoid the summation walk under
normal conditions and so mount/recovery times do not change under
normal operation.

One wrinkle that was discovered during development was that the
blocks used in the freespace btrees are never accounted for in the
AGF counters. This was once a valid optimisation to make; when the
filesystem is full, the free space btrees are empty and consume no
space. Hence when it matters, the "accounting" is correct.  But that
means the when we do the AGF summations, we would not have a correct
count and xfs_check would complain.  Hence a new counter was added
to track the number of blocks used by the free space btrees. This is
an *on-disk format change*.

As a result of this change, superblock counters are a mkfs option
and at the moment on linux there is no way to convert an old
filesystem. This is possible - xfs_db can be used to twiddle the
right bits and then xfs_repair will do the format conversion
for you. Similarly, you can convert backwards as well. At some point
we'll add functionality to xfs_admin to do the bit twiddling
easily....

This first patch is the core kernel code from the original port
Nathan did from the Irix a long while ago.  The second patch is a
recent fix needed to work with the per-cpu incore superblock
counters, and the third patch is all the userspace tool changes
needed also derived.

[nathans - the first and thid patches are pretty much unchanged from
when you last saw them. ]

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.c	2006-04-03 08:50:16.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.c	2006-04-11 16:07:46.511510919 +1000
@@ -439,6 +439,14 @@ undo_blocks:
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
@@ -446,13 +454,19 @@ xfs_trans_mod_sb(
 	uint		field,
 	long		delta)
 {
+	uint32_t	flags = (XFS_TRANS_DIRTY|XFS_TRANS_SB_DIRTY);
+	xfs_mount_t	*mp = tp->t_mountp;
 
 	switch (field) {
 	case XFS_TRANS_SB_ICOUNT:
 		tp->t_icount_delta += delta;
+		if (XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_IFREE:
 		tp->t_ifree_delta += delta;
+		if (XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_FDBLOCKS:
 		/*
@@ -465,6 +479,8 @@ xfs_trans_mod_sb(
 			ASSERT(tp->t_blk_res_used <= tp->t_blk_res);
 		}
 		tp->t_fdblocks_delta += delta;
+		if (XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_RES_FDBLOCKS:
 		/*
@@ -474,6 +490,8 @@ xfs_trans_mod_sb(
 		 */
 		ASSERT(delta < 0);
 		tp->t_res_fdblocks_delta += delta;
+		if (XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_FREXTENTS:
 		/*
@@ -556,18 +574,23 @@ xfs_trans_apply_sb_deltas(
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
+	if (!XFS_SB_VERSION_LAZYSBCOUNT(&(tp->t_mountp->m_sb))) {
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
@@ -639,6 +662,7 @@ xfs_trans_unreserve_and_mod_sb(
 {
 	xfs_mod_sb_t	msb[14];	/* If you add cases, add entries */
 	xfs_mod_sb_t	*msbp;
+	xfs_mount_t	*mp = tp->t_mountp;
 	/* REFERENCED */
 	int		error;
 	int		rsvd;
@@ -671,8 +695,15 @@ xfs_trans_unreserve_and_mod_sb(
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
+	if (XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb) ||
+	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 		if (tp->t_icount_delta != 0) {
 			msbp->msb_field = XFS_SBS_ICOUNT;
 			msbp->msb_delta = (int)tp->t_icount_delta;
@@ -688,6 +719,9 @@ xfs_trans_unreserve_and_mod_sb(
 			msbp->msb_delta = (int)tp->t_fdblocks_delta;
 			msbp++;
 		}
+	}
+
+	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
 		if (tp->t_frextents_delta != 0) {
 			msbp->msb_field = XFS_SBS_FREXTENTS;
 			msbp->msb_delta = (int)tp->t_frextents_delta;
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.c	2006-04-03 08:50:15.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.c	2006-04-11 16:07:46.688244167 +1000
@@ -1449,7 +1449,8 @@ xfs_alloc_ag_vextent_small(
 	else if (args->minlen == 1 && args->alignment == 1 && !args->isfl &&
 		 (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount)
 		  > args->minleft)) {
-		if ((error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno)))
+		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
+		if (error)
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
 			if (args->userdata) {
@@ -1912,7 +1913,7 @@ xfs_alloc_fix_freelist(
 	while (be32_to_cpu(agf->agf_flcount) > need) {
 		xfs_buf_t	*bp;
 
-		if ((error = xfs_alloc_get_freelist(tp, agbp, &bno)))
+		if ((error = xfs_alloc_get_freelist(tp, agbp, &bno, 0)))
 			return error;
 		if ((error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1)))
 			return error;
@@ -1956,7 +1957,7 @@ xfs_alloc_fix_freelist(
 		 */
 		for (bno = targs.agbno; bno < targs.agbno + targs.len; bno++) {
 			if ((error = xfs_alloc_put_freelist(tp, agbp, agflbp,
-					bno)))
+					bno, 0)))
 				return error;
 		}
 	}
@@ -1972,13 +1973,15 @@ int				/* error */
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
@@ -2013,8 +2016,16 @@ xfs_alloc_get_freelist(
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
@@ -2052,6 +2063,7 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_flcount),
 		offsetof(xfs_agf_t, agf_freeblks),
 		offsetof(xfs_agf_t, agf_longest),
+		offsetof(xfs_agf_t, agf_btreeblks),
 		sizeof(xfs_agf_t)
 	};
 
@@ -2087,12 +2099,14 @@ xfs_alloc_put_freelist(
 	xfs_trans_t		*tp,	/* transaction pointer */
 	xfs_buf_t		*agbp,	/* buffer for a.g. freelist header */
 	xfs_buf_t		*agflbp,/* buffer for a.g. free block array */
-	xfs_agblock_t		bno)	/* block being freed */
+	xfs_agblock_t		bno,	/* block being freed */
+	int			btreeblk) /* block came from a AGF btree */
 {
 	xfs_agf_t		*agf;	/* a.g. freespace structure */
 	xfs_agfl_t		*agfl;	/* a.g. free block array */
 	xfs_agblock_t		*blockp;/* pointer to array entry */
 	int			error;
+	int			logflags;
 #ifdef XFS_ALLOC_TRACE
 	static char		fname[] = "xfs_alloc_put_freelist";
 #endif
@@ -2113,11 +2127,22 @@ xfs_alloc_put_freelist(
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
 	INT_SET(*blockp, ARCH_CONVERT, bno);
-	TRACE_MODAGF(NULL, agf, XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
-	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
+	TRACE_MODAGF(NULL, agf, logflags);
+	xfs_alloc_log_agf(tp, agbp, logflags);
 	xfs_trans_log_buf(tp, agflbp,
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl +
@@ -2177,6 +2202,7 @@ xfs_alloc_read_agf(
 	pag = &mp->m_perag[agno];
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
+		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
 		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
 		pag->pagf_levels[XFS_BTNUM_BNOi] =
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2006-04-03 08:50:16.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2006-04-11 16:07:46.694102727 +1000
@@ -125,6 +125,7 @@ xfs_ialloc_ag_alloc(
 	int		blks_per_cluster;  /* fs blocks per inode cluster */
 	xfs_btree_cur_t	*cur;		/* inode btree cursor */
 	xfs_daddr_t	d;		/* disk addr of buffer */
+	xfs_agnumber_t	agno;
 	int		error;
 	xfs_buf_t	*fbuf;		/* new free inodes' buffer */
 	xfs_dinode_t	*free;		/* new free inode structure */
@@ -303,15 +304,15 @@ xfs_ialloc_ag_alloc(
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
@@ -1384,6 +1385,7 @@ xfs_ialloc_read_agi(
 	pag = &mp->m_perag[agno];
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
+		pag->pagi_count = be32_to_cpu(agi->agi_count);
 		pag->pagi_init = 1;
 	} else {
 		/*
@@ -1407,3 +1409,22 @@ xfs_ialloc_read_agi(
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
+	if ((error = xfs_ialloc_read_agi(mp, tp, agno, &bp)))
+		return error;
+	if (bp)
+		xfs_trans_brelse(tp, bp);
+	return 0;
+}
Index: 2.6.x-xfs-new/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ag.h	2006-04-03 08:50:15.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ag.h	2006-04-11 16:07:46.704843422 +1000
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
 } xfs_perag_t;
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_sb.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_sb.h	2006-03-20 11:41:02.814713148 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_sb.h	2006-04-11 16:07:46.712654836 +1000
@@ -78,7 +78,7 @@ struct xfs_mount;
  */
 #define XFS_SB_VERSION2_REALFBITS	0x00ffffff	/* Mask: features */
 #define XFS_SB_VERSION2_RESERVED1BIT	0x00000001
-#define XFS_SB_VERSION2_RESERVED2BIT	0x00000002
+#define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_SASHFBITS	0xff000000	/* Mask: features that
@@ -86,7 +86,8 @@ struct xfs_mount;
 							   PROM and SASH */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
-	(XFS_SB_VERSION2_ATTR2BIT)
+	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
+	 XFS_SB_VERSION2_ATTR2BIT)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -188,6 +189,9 @@ typedef enum {
 #define XFS_SB_SHARED_VN	XFS_SB_MVAL(SHARED_VN)
 #define XFS_SB_UNIT		XFS_SB_MVAL(UNIT)
 #define XFS_SB_WIDTH		XFS_SB_MVAL(WIDTH)
+#define XFS_SB_ICOUNT		XFS_SB_MVAL(ICOUNT)
+#define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
+#define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
@@ -195,7 +199,7 @@ typedef enum {
 	(XFS_SB_UUID | XFS_SB_ROOTINO | XFS_SB_RBMINO | XFS_SB_RSUMINO | \
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
-	 XFS_SB_FEATURES2)
+	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2)
 
 
 /*
@@ -427,6 +431,13 @@ static inline int xfs_sb_version_hasmore
  *	 ((sbp)->sb_features2 & XFS_SB_VERSION2_FUNBIT)
  */
 
+#define XFS_SB_VERSION_LAZYSBCOUNT(sbp)	xfs_sb_version_haslazysbcount(sbp)
+static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_HASMOREBITS(sbp) &&	\
+		((sbp)->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
+}
+
 #define XFS_SB_VERSION_HASATTR2(sbp)	xfs_sb_version_hasattr2(sbp)
 static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
 {
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2006-04-11 10:05:35.457757222 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2006-04-11 16:07:46.796627539 +1000
@@ -635,6 +635,60 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
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
+	return 0;
+}
+
 /*
  * xfs_mountfs
  *
@@ -1051,6 +1105,28 @@ xfs_mountfs(
 	}
 
 	/*
+	 * Now recovery has completed, we can initialise incore
+	 * superblock counters from the per-ag data. These may not
+	 * be correct if the filesystem was not cleanly unmounted,
+	 * so we need to wait for recovery to finish before doing this.
+	 *
+	 * If the filesystem was cleanly unmounted, then we can trust
+	 * the values in the superblock to be correct and we don't need
+	 * to do anything here.
+	 *
+	 * If we are currently making the filesystem, the initialisation
+	 * will fail as the perag data is in an undefined state.
+	 */
+	if (XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb) &&
+	    !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
+	     !mp->m_sb.sb_inprogress) {
+		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
+		if (error) {
+			goto error4;
+		}
+	}
+
+	/*
 	 * Complete the quota initialisation, post-log-replay component.
 	 */
 	if ((error = XFS_QM_MOUNT(mp, quotamount, quotaflags, mfsi_flags)))
@@ -1160,27 +1236,102 @@ xfs_unmountfs_wait(xfs_mount_t *mp)
 	xfs_wait_buftarg(mp->m_ddev_targp);
 }
 
+/*
+ * xfs_log_sbcount
+ *
+ * Called either periodically to keep the on disk superblock values
+ * roughly up to date or from unmount to make sure the values are
+ * correct on a clean unmount.
+ */
+int
+xfs_log_sbcount(
+	xfs_mount_t	*mp,
+	uint		flags)	/* 0 = no log force,
+				   non-zero = log force flags */
+{
+	xfs_trans_t	*tp;
+	int		error;
+
+	if (flags & XFS_LOG_SYNC)
+		xfs_icsb_sync_counters(mp);
+	else
+		xfs_icsb_sync_counters_lazy(mp);
+
+	/*
+	 * we don't need to write the superblock if we are updating the
+	 * counters on every modification.
+	 */
+	if (!XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb))
+		return 0;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT);
+	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
+				XFS_DEFAULT_LOG_COUNT);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	/*
+	 * modify the superblock and commit the transaction
+	 * to disk - flags will be set to indicate if and how
+	 * we need to force the log.
+	 */
+	xfs_mod_sb(tp, (XFS_SB_IFREE |
+			XFS_SB_ICOUNT |
+			XFS_SB_FDBLOCKS));
+
+	(void)xfs_trans_commit(tp, 0, NULL);
+
+	if (flags) {
+		xfs_log_force(mp, (xfs_lsn_t)0, flags);
+	}
+
+	return 0;
+}
+
 int
 xfs_unmountfs_writesb(xfs_mount_t *mp)
 {
 	xfs_buf_t	*sbp;
 	xfs_sb_t	*sb;
 	int		error = 0;
+	int		s;
 
 	/*
 	 * skip superblock write if fs is read-only, or
 	 * if we are doing a forced umount.
 	 */
-	sbp = xfs_getsb(mp, 0);
 	if (!(XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY ||
 		XFS_FORCED_SHUTDOWN(mp))) {
+		/*
+		 * Write into superblock the fields that we haven't
+		 * been logging - allocated/free inode and free block
+		 * counts - from the incore superblock.
+ 		 */
+		error = xfs_log_sbcount(mp, (XFS_LOG_FORCE|XFS_LOG_SYNC));
 
-		xfs_icsb_sync_counters(mp);
+		sbp = xfs_getsb(mp, 0);
+ 		sb = XFS_BUF_TO_SBP(sbp);
+		if (error) {
+			/*
+			 * Hmmm - failed to get log reservations so just
+			 * do the mod without a transaction. Whine about
+			 * it, too.
+			 */
+			ASSERT(XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb));
+			xfs_fs_cmn_err(CE_NOTE, mp,
+				"Unmounting, non-transactional sb update");
+			s = XFS_SB_LOCK(mp);
+			INT_SET(sb->sb_icount, ARCH_CONVERT, mp->m_sb.sb_icount);
+			INT_SET(sb->sb_ifree, ARCH_CONVERT, mp->m_sb.sb_ifree);
+			INT_SET(sb->sb_fdblocks, ARCH_CONVERT, mp->m_sb.sb_fdblocks);
+			XFS_SB_UNLOCK(mp, s);
+		}
 
 		/*
 		 * mark shared-readonly if desired
 		 */
-		sb = XFS_BUF_TO_SBP(sbp);
 		if (mp->m_mk_sharedro) {
 			if (!(sb->sb_flags & XFS_SBF_READONLY))
 				sb->sb_flags |= XFS_SBF_READONLY;
@@ -1189,6 +1340,7 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 			xfs_fs_cmn_err(CE_NOTE, mp,
 				"Unmounting, marking shared read-only");
 		}
+
 		XFS_BUF_UNDONE(sbp);
 		XFS_BUF_UNREAD(sbp);
 		XFS_BUF_UNDELAYWRITE(sbp);
@@ -1203,8 +1355,8 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 					  mp, sbp, XFS_BUF_ADDR(sbp));
 		if (error && mp->m_mk_sharedro)
 			xfs_fs_cmn_err(CE_ALERT, mp, "Superblock write error detected while unmounting.  Filesystem may not be marked shared readonly");
+		xfs_buf_relse(sbp);
 	}
-	xfs_buf_relse(sbp);
 	return error;
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2006-04-11 10:05:35.439205062 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2006-04-11 16:07:46.804438954 +1000
@@ -1524,12 +1524,19 @@ xfs_syncsub(
 	 * If this is the periodic sync, then kick some entries out of
 	 * the reference cache.  This ensures that idle entries are
 	 * eventually kicked out of the cache.
+	 *
+	 * We also update the disk superblock with incore counter
+	 * values if we are using non-persistent counters so that
+	 * they don't get too far out of sync if we crash or get a
+	 * forced shutdown. We don't want to force this to disk,
+	 * just get a transaction into the iclogs....
 	 */
 	if (flags & SYNC_REFCACHE) {
 		if (flags & SYNC_WAIT)
 			xfs_refcache_purge_mp(mp);
 		else
 			xfs_refcache_purge_some(mp);
+		xfs_log_sbcount(mp, 0);
 	}
 
 	/*
Index: 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_recover.c	2006-04-03 08:50:16.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c	2006-04-11 16:07:46.823967489 +1000
@@ -929,6 +929,14 @@ xlog_find_tail(
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
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc_btree.c	2006-03-20 11:41:02.853770346 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc_btree.c	2006-04-11 16:07:46.987030762 +1000
@@ -226,7 +226,7 @@ xfs_alloc_delrec(
 			 * Put this buffer/block on the ag's freelist.
 			 */
 			if ((error = xfs_alloc_put_freelist(cur->bc_tp,
-					cur->bc_private.a.agbp, NULL, bno)))
+					cur->bc_private.a.agbp, NULL, bno, 1)))
 				return error;
 			/*
 			 * Since blocks move to the free list without the
@@ -551,7 +551,7 @@ xfs_alloc_delrec(
 	 * Free the deleting block by putting it on the freelist.
 	 */
 	if ((error = xfs_alloc_put_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-			NULL, rbno)))
+			NULL, rbno, 1)))
 		return error;
 	/*
 	 * Since blocks move to the free list without the coordination
@@ -1317,7 +1317,7 @@ xfs_alloc_newroot(
 	 * Get a buffer from the freelist blocks, for the new root.
 	 */
 	if ((error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-			&nbno)))
+			&nbno, 1)))
 		return error;
 	/*
 	 * None available, we fail.
@@ -1601,7 +1601,7 @@ xfs_alloc_split(
 	 * If we can't do it, we're toast.  Give up.
 	 */
 	if ((error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-			&rbno)))
+			&rbno, 1)))
 		return error;
 	if (rbno == NULLAGBLOCK) {
 		*stat = 0;
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.h	2006-04-03 08:50:15.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.h	2006-04-11 16:07:47.092484854 +1000
@@ -114,7 +114,8 @@ int				/* error */
 xfs_alloc_get_freelist(
 	struct xfs_trans *tp,	/* transaction pointer */
 	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
-	xfs_agblock_t	*bnop);	/* block address retrieved from freelist */
+	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
+	int		btreeblk); /* destination is a AGF btree */
 
 /*
  * Log the given fields from the agf structure.
@@ -143,7 +144,8 @@ xfs_alloc_put_freelist(
 	struct xfs_trans *tp,	/* transaction pointer */
 	struct xfs_buf	*agbp,	/* buffer for a.g. freelist header */
 	struct xfs_buf	*agflbp,/* buffer for a.g. free block array */
-	xfs_agblock_t	bno);	/* block being freed */
+	xfs_agblock_t	bno,	/* block being freed */
+	int		btreeblk); /* owner was a AGF btree */
 
 /*
  * Read in the allocation group header (free/alloc section).
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.h	2006-04-03 08:50:16.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.h	2006-04-11 16:07:47.096390561 +1000
@@ -98,7 +98,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_GROWFSRT_ZERO		38
 #define	XFS_TRANS_GROWFSRT_FREE		39
 #define	XFS_TRANS_SWAPEXT		40
-#define	XFS_TRANS_TYPE_MAX		40
+#define	XFS_TRANS_SB_COUNT		41
+#define	XFS_TRANS_TYPE_MAX		41
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.h	2006-03-20 11:41:02.857676066 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.h	2006-04-11 16:07:47.097366988 +1000
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
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2006-04-11 10:05:35.450922216 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2006-04-11 16:07:47.110060536 +1000
@@ -6482,6 +6482,8 @@ xfsidbg_print_trans_type(unsigned int t_
 	case XFS_TRANS_GROWFSRT_ALLOC:	kdb_printf("GROWFSRT_ALLOC");	break;
 	case XFS_TRANS_GROWFSRT_ZERO:	kdb_printf("GROWFSRT_ZERO");	break;
 	case XFS_TRANS_GROWFSRT_FREE:	kdb_printf("GROWFSRT_FREE");	break;
+	case XFS_TRANS_SWAPEXT:		kdb_printf("SWAPEXT");		break;
+	case XFS_TRANS_SB_COUNT:	kdb_printf("SB_COUNT");		break;
 	default:			kdb_printf("unknown(0x%x)", t_type); break;
 	}
 }
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2006-04-03 08:50:16.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2006-04-11 16:07:47.112989816 +1000
@@ -415,7 +415,7 @@ typedef struct xfs_mount {
 						   for space allocations */
 #define	XFS_MOUNT_INO64		(1ULL << 1)
 			     /* (1ULL << 2)	-- currently unused */
-			     /* (1ULL << 3)	-- currently unused */
+#define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
 						   disk errors in metadata */
@@ -492,6 +492,8 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 
 #define XFS_MAXIOFFSET(mp)	((mp)->m_maxioffset)
 
+#define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
+				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
 #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
 #define xfs_force_shutdown(m,f)	\
 	VFS_FORCE_SHUTDOWN((XFS_MTOVFS(m)), f, __FILE__, __LINE__)
@@ -570,6 +572,7 @@ typedef struct xfs_mod_sb {
 
 extern xfs_mount_t *xfs_mount_init(void);
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
+extern int	xfs_log_sbcount(xfs_mount_t *, uint);
 extern void	xfs_mount_free(xfs_mount_t *mp, int remove_bhv);
 extern int	xfs_mountfs(struct vfs *, xfs_mount_t *mp, int);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
Index: 2.6.x-xfs-new/fs/xfs/xfs_fsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fsops.c	2006-04-03 08:50:16.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fsops.c	2006-04-11 16:07:47.114942670 +1000
@@ -96,6 +96,8 @@ xfs_fs_geometry(
 				XFS_FSOP_GEOM_FLAGS_DIRV2 : 0) |
 			(XFS_SB_VERSION_HASSECTOR(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_SECTOR : 0) |
+			(XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
 			(XFS_SB_VERSION_HASATTR2(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0);
 		geo->logsectsize = XFS_SB_VERSION_HASSECTOR(&mp->m_sb) ?
Index: 2.6.x-xfs-new/fs/xfs/xfs_fs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fs.h	2006-03-20 11:41:02.868416796 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_fs.h	2006-04-11 16:07:47.126659791 +1000
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
 #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
 #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
+#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
 
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2006-04-03 08:50:15.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2006-04-11 16:07:47.182316118 +1000
@@ -557,7 +557,7 @@ xfs_flush_device(
 	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
 }
 
-#define SYNCD_FLAGS	(SYNC_FSDATA|SYNC_BDFLUSH|SYNC_ATTR)
+#define SYNCD_FLAGS	(SYNC_FSDATA|SYNC_BDFLUSH|SYNC_ATTR|SYNC_REFCACHE)
 STATIC void
 vfs_sync_worker(
 	vfs_t		*vfsp,
