Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 13:42:08 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6FKg0bm030683
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 13:42:02 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6FKg1NK017134
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 22:42:01 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6FKg1p4017132
	for xfs@oss.sgi.com; Sun, 15 Jul 2007 22:42:01 +0200
Date: Sun, 15 Jul 2007 22:42:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] split ondisk vs incore versions of xfs_bmbt_rec_t
Message-ID: <20070715204201.GB17069@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

currently xfs_bmbt_rec_t is used both for ondisk extents aswell as
host-endian ones.  This patch adds a new xfs_bmbt_rec_host_t for the
native endian ones and cleans up the fallout.  The haven been various
endiness issues in the tracing / debug printf code that are fixed
by this patch.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2007-07-15 18:22:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2007-07-15 18:23:12.000000000 +0200
@@ -1712,7 +1712,6 @@ xfs_qm_get_rtblks(
 	xfs_extnum_t	idx;			/* extent record index */
 	xfs_ifork_t	*ifp;			/* inode fork pointer */
 	xfs_extnum_t	nextents;		/* number of extent entries */
-	xfs_bmbt_rec_t	*ep;			/* pointer to an extent entry */
 	int		error;
 
 	ASSERT(XFS_IS_REALTIME_INODE(ip));
@@ -1723,10 +1722,8 @@ xfs_qm_get_rtblks(
 	}
 	rtblks = 0;
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-	for (idx = 0; idx < nextents; idx++) {
-		ep = xfs_iext_get_ext(ifp, idx);
-		rtblks += xfs_bmbt_get_blockcount(ep);
-	}
+	for (idx = 0; idx < nextents; idx++)
+		rtblks += xfs_bmbt_get_blockcount(xfs_iext_get_ext(ifp, idx));
 	*O_rtblks = (xfs_qcnt_t)rtblks;
 	return 0;
 }
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2007-07-15 18:22:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2007-07-15 18:43:41.000000000 +0200
@@ -248,7 +248,7 @@ xfs_bmap_local_to_extents(
  * Else, *lastxp will be set to the index of the found
  * entry; *gotp will contain the entry.
  */
-STATIC xfs_bmbt_rec_t *			/* pointer to found extent entry */
+STATIC xfs_bmbt_rec_host_t *		/* pointer to found extent entry */
 xfs_bmap_search_extents(
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_fileoff_t	bno,		/* block number searched for */
@@ -273,21 +273,6 @@ xfs_bmap_isaeof(
 
 #ifdef XFS_BMAP_TRACE
 /*
- * Add a bmap trace buffer entry.  Base routine for the others.
- */
-STATIC void
-xfs_bmap_trace_addentry(
-	int		opcode,		/* operation */
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry(ies) */
-	xfs_extnum_t	cnt,		/* count of entries, 1 or 2 */
-	xfs_bmbt_rec_t	*r1,		/* first record */
-	xfs_bmbt_rec_t	*r2,		/* second record or null */
-	int		whichfork);	/* data or attr fork */
-
-/*
  * Add bmap trace entry prior to a call to xfs_iext_remove.
  */
 STATIC void
@@ -714,7 +699,7 @@ xfs_bmap_add_extent_delay_real(
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
 	int			diff;	/* temp value */
-	xfs_bmbt_rec_t		*ep;	/* extent entry for idx */
+	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
 	int			error;	/* error return value */
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
@@ -1270,7 +1255,7 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_extdelta_t		*delta) /* Change made to incore extents */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
-	xfs_bmbt_rec_t		*ep;	/* extent entry for idx */
+	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
 	int			error;	/* error return value */
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
@@ -1823,7 +1808,7 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			rsvd)		/* OK to allocate reserved blocks */
 {
-	xfs_bmbt_rec_t		*ep;	/* extent record for idx */
+	xfs_bmbt_rec_host_t	*ep;	/* extent record for idx */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
 	xfs_filblks_t		newlen=0;	/* new indirect size */
@@ -2012,7 +1997,7 @@ xfs_bmap_add_extent_hole_real(
 	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork) /* data or attr fork */
 {
-	xfs_bmbt_rec_t		*ep;	/* pointer to extent entry ins. point */
+	xfs_bmbt_rec_host_t	*ep;	/* pointer to extent entry ins. point */
 	int			error;	/* error return value */
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
@@ -3070,7 +3055,7 @@ xfs_bmap_del_extent(
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
 	int			delay;	/* current block is delayed allocated */
 	int			do_fx;	/* free extent at end of routine */
-	xfs_bmbt_rec_t		*ep;	/* current extent entry pointer */
+	xfs_bmbt_rec_host_t	*ep;	/* current extent entry pointer */
 	int			error;	/* error return value */
 	int			flags;	/* inode logging flags */
 	xfs_bmbt_irec_t		got;	/* current extent entry */
@@ -3418,7 +3403,7 @@ xfs_bmap_extents_to_btree(
 	xfs_bmbt_rec_t		*arp;		/* child record pointer */
 	xfs_bmbt_block_t	*block;		/* btree root block */
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
-	xfs_bmbt_rec_t		*ep;		/* extent record pointer */
+	xfs_bmbt_rec_host_t	*ep;		/* extent record pointer */
 	int			error;		/* error return value */
 	xfs_extnum_t		i, cnt;		/* extent record index */
 	xfs_ifork_t		*ifp;		/* inode fork pointer */
@@ -3590,7 +3575,7 @@ xfs_bmap_local_to_extents(
 	if (ifp->if_bytes) {
 		xfs_alloc_arg_t	args;	/* allocation arguments */
 		xfs_buf_t	*bp;	/* buffer for extent block */
-		xfs_bmbt_rec_t	*ep;	/* extent record pointer */
+		xfs_bmbt_rec_host_t *ep;/* extent record pointer */
 
 		args.tp = tp;
 		args.mp = ip->i_mount;
@@ -3655,7 +3640,7 @@ done:
  * entry (null if none).  Else, *lastxp will be set to the index
  * of the found entry; *gotp will contain the entry.
  */
-xfs_bmbt_rec_t *			/* pointer to found extent entry */
+xfs_bmbt_rec_host_t *			/* pointer to found extent entry */
 xfs_bmap_search_multi_extents(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_fileoff_t	bno,		/* block number searched for */
@@ -3664,7 +3649,7 @@ xfs_bmap_search_multi_extents(
 	xfs_bmbt_irec_t	*gotp,		/* out: extent entry found */
 	xfs_bmbt_irec_t	*prevp)		/* out: previous extent entry found */
 {
-	xfs_bmbt_rec_t	*ep;		/* extent record pointer */
+	xfs_bmbt_rec_host_t *ep;		/* extent record pointer */
 	xfs_extnum_t	lastx;		/* last extent index */
 
 	/*
@@ -3706,7 +3691,7 @@ xfs_bmap_search_multi_extents(
  * Else, *lastxp will be set to the index of the found
  * entry; *gotp will contain the entry.
  */
-STATIC xfs_bmbt_rec_t *                 /* pointer to found extent entry */
+STATIC xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
 xfs_bmap_search_extents(
 	xfs_inode_t     *ip,            /* incore inode pointer */
 	xfs_fileoff_t   bno,            /* block number searched for */
@@ -3717,7 +3702,7 @@ xfs_bmap_search_extents(
 	xfs_bmbt_irec_t *prevp)         /* out: previous extent entry found */
 {
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
-	xfs_bmbt_rec_t  *ep;            /* extent record pointer */
+	xfs_bmbt_rec_host_t  *ep;            /* extent record pointer */
 
 	XFS_STATS_INC(xs_look_exlist);
 	ifp = XFS_IFORK_PTR(ip, fork);
@@ -3757,11 +3742,11 @@ xfs_bmap_trace_addentry(
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry(ies) */
 	xfs_extnum_t	cnt,		/* count of entries, 1 or 2 */
-	xfs_bmbt_rec_t	*r1,		/* first record */
-	xfs_bmbt_rec_t	*r2,		/* second record or null */
+	xfs_bmbt_rec_host_t *r1,	/* first record */
+	xfs_bmbt_rec_host_t *r2,	/* second record or null */
 	int		whichfork)	/* data or attr fork */
 {
-	xfs_bmbt_rec_t	tr2;
+	xfs_bmbt_rec_host_t tr2;
 
 	ASSERT(cnt == 1 || cnt == 2);
 	ASSERT(r1 != NULL);
@@ -3842,8 +3827,8 @@ xfs_bmap_trace_insert(
 	xfs_bmbt_irec_t	*r2,		/* inserted record 2 or null */
 	int		whichfork)	/* data or attr fork */
 {
-	xfs_bmbt_rec_t	tr1;		/* compressed record 1 */
-	xfs_bmbt_rec_t	tr2;		/* compressed record 2 if needed */
+	xfs_bmbt_rec_host_t tr1;	/* compressed record 1 */
+	xfs_bmbt_rec_host_t tr2;	/* compressed record 2 if needed */
 
 	xfs_bmbt_set_all(&tr1, r1);
 	if (cnt == 2) {
@@ -4316,7 +4301,6 @@ xfs_bmap_first_unused(
 	xfs_fileoff_t	*first_unused,		/* unused block */
 	int		whichfork)		/* data or attr fork */
 {
-	xfs_bmbt_rec_t	*ep;			/* pointer to an extent entry */
 	int		error;			/* error return value */
 	int		idx;			/* extent record index */
 	xfs_ifork_t	*ifp;			/* inode fork pointer */
@@ -4340,7 +4324,7 @@ xfs_bmap_first_unused(
 	lowest = *first_unused;
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	for (idx = 0, lastaddr = 0, max = lowest; idx < nextents; idx++) {
-		ep = xfs_iext_get_ext(ifp, idx);
+		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, idx);
 		off = xfs_bmbt_get_startoff(ep);
 		/*
 		 * See if the hole before this extent will work.
@@ -4371,7 +4355,7 @@ xfs_bmap_last_before(
 {
 	xfs_fileoff_t	bno;			/* input file offset */
 	int		eof;			/* hit end of file */
-	xfs_bmbt_rec_t	*ep;			/* pointer to last extent */
+	xfs_bmbt_rec_host_t *ep;		/* pointer to last extent */
 	int		error;			/* error return value */
 	xfs_bmbt_irec_t	got;			/* current extent value */
 	xfs_ifork_t	*ifp;			/* inode fork pointer */
@@ -4417,7 +4401,7 @@ xfs_bmap_last_offset(
 	xfs_fileoff_t	*last_block,		/* last block */
 	int		whichfork)		/* data or attr fork */
 {
-	xfs_bmbt_rec_t	*ep;			/* pointer to last extent */
+	xfs_bmbt_rec_host_t *ep;		/* pointer to last extent */
 	int		error;			/* error return value */
 	xfs_ifork_t	*ifp;			/* inode fork pointer */
 	xfs_extnum_t	nextents;		/* number of extent entries */
@@ -4454,7 +4438,7 @@ xfs_bmap_one_block(
 	xfs_inode_t	*ip,		/* incore inode */
 	int		whichfork)	/* data or attr fork */
 {
-	xfs_bmbt_rec_t	*ep;		/* ptr to fork's extent */
+	xfs_bmbt_rec_host_t *ep;	/* ptr to fork's extent */
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
 	int		rval;		/* return value */
 	xfs_bmbt_irec_t	s;		/* internal version of extent */
@@ -4549,7 +4533,7 @@ xfs_bmap_read_extents(
 	 * Loop over all leaf nodes.  Copy information to the extent records.
 	 */
 	for (;;) {
-		xfs_bmbt_rec_t	*frp, *trp;
+		xfs_bmbt_rec_t	*frp;
 		xfs_fsblock_t	nextbno;
 		xfs_extnum_t	num_recs;
 		xfs_extnum_t	start;
@@ -4581,7 +4565,7 @@ xfs_bmap_read_extents(
 		frp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, 1);
 		start = i;
 		for (j = 0; j < num_recs; j++, i++, frp++) {
-			trp = xfs_iext_get_ext(ifp, i);
+			xfs_bmbt_rec_host_t *trp = xfs_iext_get_ext(ifp, i);
 			trp->l0 = INT_GET(frp->l0, ARCH_CONVERT);
 			trp->l1 = INT_GET(frp->l1, ARCH_CONVERT);
 		}
@@ -4631,7 +4615,7 @@ xfs_bmap_trace_exlist(
 	xfs_extnum_t	cnt,		/* count of entries in the list */
 	int		whichfork)	/* data or attr fork */
 {
-	xfs_bmbt_rec_t	*ep;		/* current extent record */
+	xfs_bmbt_rec_host_t *ep;	/* current extent record */
 	xfs_extnum_t	idx;		/* extent record index */
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
 	xfs_bmbt_irec_t	s;		/* file extent record */
@@ -4727,7 +4711,7 @@ xfs_bmapi(
 	xfs_btree_cur_t	*cur;		/* bmap btree cursor */
 	xfs_fileoff_t	end;		/* end of mapped file region */
 	int		eof;		/* we've hit the end of extents */
-	xfs_bmbt_rec_t	*ep;		/* extent record pointer */
+	xfs_bmbt_rec_host_t *ep;	/* extent record pointer */
 	int		error;		/* error return */
 	xfs_bmbt_irec_t	got;		/* current file extent record */
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
@@ -5378,7 +5362,7 @@ xfs_bunmapi(
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
 	xfs_bmbt_irec_t		del;		/* extent being deleted */
 	int			eof;		/* is deleting at eof */
-	xfs_bmbt_rec_t		*ep;		/* extent record pointer */
+	xfs_bmbt_rec_host_t	*ep;		/* extent record pointer */
 	int			error;		/* error return value */
 	xfs_extnum_t		extno;		/* extent number in list */
 	xfs_bmbt_irec_t		got;		/* current extent record */
@@ -5974,7 +5958,7 @@ xfs_bmap_isaeof(
 {
 	int		error;		/* error return value */
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
-	xfs_bmbt_rec_t	*lastrec;	/* extent record pointer */
+	xfs_bmbt_rec_host_t *lastrec;	/* extent record pointer */
 	xfs_extnum_t	nextents;	/* number of file extents */
 	xfs_bmbt_irec_t	s;		/* expanded extent record */
 
@@ -6018,7 +6002,7 @@ xfs_bmap_eof(
 	xfs_fsblock_t	blockcount;	/* extent block count */
 	int		error;		/* error return value */
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
-	xfs_bmbt_rec_t	*lastrec;	/* extent record pointer */
+	xfs_bmbt_rec_host_t *lastrec;	/* extent record pointer */
 	xfs_extnum_t	nextents;	/* number of file extents */
 	xfs_fileoff_t	startoff;	/* extent starting file offset */
 
@@ -6465,10 +6449,9 @@ xfs_bmap_count_leaves(
 	int			*count)
 {
 	int		b;
-	xfs_bmbt_rec_t	*frp;
 
 	for (b = 0; b < numrecs; b++) {
-		frp = xfs_iext_get_ext(ifp, idx + b);
+		xfs_bmbt_rec_host_t *frp = xfs_iext_get_ext(ifp, idx + b);
 		*count += xfs_bmbt_get_blockcount(frp);
 	}
 	return 0;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.h	2007-07-15 18:22:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.h	2007-07-15 18:23:12.000000000 +0200
@@ -378,7 +378,7 @@ xfs_check_nostate_extents(
  * entry (null if none).  Else, *lastxp will be set to the index
  * of the found entry; *gotp will contain the entry.
  */
-xfs_bmbt_rec_t *
+xfs_bmbt_rec_host_t *
 xfs_bmap_search_multi_extents(struct xfs_ifork *, xfs_fileoff_t, int *,
 			xfs_extnum_t *, xfs_bmbt_irec_t *, xfs_bmbt_irec_t *);
 
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2007-07-15 18:23:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2007-07-15 18:43:49.000000000 +0200
@@ -260,13 +260,14 @@ xfs_bmbt_trace_cursor(
 	char		*s,
 	int		line)
 {
-	xfs_bmbt_rec_t	r;
+	xfs_bmbt_rec_host_t	r;
 
 	xfs_bmbt_set_all(&r, &cur->bc_rec.b);
 	xfs_bmbt_trace_enter(func, cur, s, XFS_BMBT_KTRACE_CUR, line,
 		(cur->bc_nlevels << 24) | (cur->bc_private.b.flags << 16) |
 		cur->bc_private.b.allocated,
-		INT_GET(r.l0, ARCH_CONVERT) >> 32, (int)INT_GET(r.l0, ARCH_CONVERT), INT_GET(r.l1, ARCH_CONVERT) >> 32, (int)INT_GET(r.l1, ARCH_CONVERT),
+		r.l0 >> 32, (int)r.l0,
+		r.l1 >> 32, (int)r.l1,
 		(unsigned long)cur->bc_bufs[0], (unsigned long)cur->bc_bufs[1],
 		(unsigned long)cur->bc_bufs[2], (unsigned long)cur->bc_bufs[3],
 		(cur->bc_ptrs[0] << 16) | cur->bc_ptrs[1],
@@ -1826,7 +1827,7 @@ __xfs_bmbt_get_all(
 
 void
 xfs_bmbt_get_all(
-	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_rec_host_t *r,
 	xfs_bmbt_irec_t *s)
 {
 	__xfs_bmbt_get_all(r->l0, r->l1, s);
@@ -1862,7 +1863,7 @@ xfs_bmbt_get_block(
  */
 xfs_filblks_t
 xfs_bmbt_get_blockcount(
-	xfs_bmbt_rec_t	*r)
+	xfs_bmbt_rec_host_t	*r)
 {
 	return (xfs_filblks_t)(r->l1 & XFS_MASK64LO(21));
 }
@@ -1872,7 +1873,7 @@ xfs_bmbt_get_blockcount(
  */
 xfs_fsblock_t
 xfs_bmbt_get_startblock(
-	xfs_bmbt_rec_t	*r)
+	xfs_bmbt_rec_host_t	*r)
 {
 #if XFS_BIG_BLKNOS
 	return (((xfs_fsblock_t)r->l0 & XFS_MASK64LO(9)) << 43) |
@@ -1896,7 +1897,7 @@ xfs_bmbt_get_startblock(
  */
 xfs_fileoff_t
 xfs_bmbt_get_startoff(
-	xfs_bmbt_rec_t	*r)
+	xfs_bmbt_rec_host_t	*r)
 {
 	return ((xfs_fileoff_t)r->l0 &
 		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
@@ -1904,7 +1905,7 @@ xfs_bmbt_get_startoff(
 
 xfs_exntst_t
 xfs_bmbt_get_state(
-	xfs_bmbt_rec_t	*r)
+	xfs_bmbt_rec_host_t	*r)
 {
 	int	ext_flag;
 
@@ -2294,7 +2295,7 @@ xfs_bmbt_newroot(
  */
 void
 xfs_bmbt_set_all(
-	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_rec_host_t *r,
 	xfs_bmbt_irec_t	*s)
 {
 	int	extent_flag;
@@ -2336,7 +2337,7 @@ xfs_bmbt_set_all(
  */
 void
 xfs_bmbt_set_allf(
-	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_rec_host_t *r,
 	xfs_fileoff_t	o,
 	xfs_fsblock_t	b,
 	xfs_filblks_t	c,
@@ -2468,7 +2469,7 @@ xfs_bmbt_disk_set_allf(
  */
 void
 xfs_bmbt_set_blockcount(
-	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_rec_host_t *r,
 	xfs_filblks_t	v)
 {
 	ASSERT((v & XFS_MASK64HI(43)) == 0);
@@ -2481,7 +2482,7 @@ xfs_bmbt_set_blockcount(
  */
 void
 xfs_bmbt_set_startblock(
-	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_rec_host_t *r,
 	xfs_fsblock_t	v)
 {
 #if XFS_BIG_BLKNOS
@@ -2509,7 +2510,7 @@ xfs_bmbt_set_startblock(
  */
 void
 xfs_bmbt_set_startoff(
-	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_rec_host_t *r,
 	xfs_fileoff_t	v)
 {
 	ASSERT((v & XFS_MASK64HI(9)) == 0);
@@ -2523,7 +2524,7 @@ xfs_bmbt_set_startoff(
  */
 void
 xfs_bmbt_set_state(
-	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_rec_host_t *r,
 	xfs_exntst_t	v)
 {
 	ASSERT(v == XFS_EXT_NORM || v == XFS_EXT_UNWRITTEN);
@@ -2624,10 +2625,8 @@ xfs_check_nostate_extents(
 	xfs_extnum_t		idx,
 	xfs_extnum_t		num)
 {
-	xfs_bmbt_rec_t		*ep;
-
 	for (; num > 0; num--, idx++) {
-		ep = xfs_iext_get_ext(ifp, idx);
+		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, idx);
 		if ((ep->l0 >>
 		     (64 - BMBT_EXNTFLAG_BITLEN)) != 0) {
 			ASSERT(0);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2007-07-15 18:22:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2007-07-15 18:43:43.000000000 +0200
@@ -89,6 +89,10 @@ typedef struct xfs_bmbt_rec_64
 typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
 typedef xfs_bmbt_rec_64_t xfs_bmbt_rec_t, xfs_bmdr_rec_t;
 
+typedef struct xfs_bmbt_rec_host {
+	__uint64_t		l0, l1;
+} xfs_bmbt_rec_host_t;
+
 /*
  * Values and macros for delayed-allocation startblock fields.
  */
@@ -281,13 +285,13 @@ extern ktrace_t	*xfs_bmbt_trace_buf;
 extern void xfs_bmdr_to_bmbt(xfs_bmdr_block_t *, int, xfs_bmbt_block_t *, int);
 extern int xfs_bmbt_decrement(struct xfs_btree_cur *, int, int *);
 extern int xfs_bmbt_delete(struct xfs_btree_cur *, int *);
-extern void xfs_bmbt_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
+extern void xfs_bmbt_get_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
 extern xfs_bmbt_block_t *xfs_bmbt_get_block(struct xfs_btree_cur *cur,
 						int, struct xfs_buf **bpp);
-extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_t *r);
-extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_t *r);
-extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_t *r);
-extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_t *r);
+extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_host_t *r);
+extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
+extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
+extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_host_t *r);
 
 #ifndef XFS_NATIVE_HOST
 extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
@@ -315,13 +319,13 @@ extern int xfs_bmbt_lookup_ge(struct xfs
  */
 extern int xfs_bmbt_newroot(struct xfs_btree_cur *cur, int *lflags, int *stat);
 
-extern void xfs_bmbt_set_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
-extern void xfs_bmbt_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
+extern void xfs_bmbt_set_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
+extern void xfs_bmbt_set_allf(xfs_bmbt_rec_host_t *r, xfs_fileoff_t o,
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
-extern void xfs_bmbt_set_blockcount(xfs_bmbt_rec_t *r, xfs_filblks_t v);
-extern void xfs_bmbt_set_startblock(xfs_bmbt_rec_t *r, xfs_fsblock_t v);
-extern void xfs_bmbt_set_startoff(xfs_bmbt_rec_t *r, xfs_fileoff_t v);
-extern void xfs_bmbt_set_state(xfs_bmbt_rec_t *r, xfs_exntst_t v);
+extern void xfs_bmbt_set_blockcount(xfs_bmbt_rec_host_t *r, xfs_filblks_t v);
+extern void xfs_bmbt_set_startblock(xfs_bmbt_rec_host_t *r, xfs_fsblock_t v);
+extern void xfs_bmbt_set_startoff(xfs_bmbt_rec_host_t *r, xfs_fileoff_t v);
+extern void xfs_bmbt_set_state(xfs_bmbt_rec_host_t *r, xfs_exntst_t v);
 
 #ifndef XFS_NATIVE_HOST
 extern void xfs_bmbt_disk_set_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-07-15 18:22:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-07-15 18:43:41.000000000 +0200
@@ -67,7 +67,6 @@ STATIC int xfs_iformat_local(xfs_inode_t
 STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
 STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
 
-
 #ifdef DEBUG
 /*
  * Make sure that the extents in the given memory buffer
@@ -77,28 +76,23 @@ STATIC void
 xfs_validate_extents(
 	xfs_ifork_t		*ifp,
 	int			nrecs,
-	int			disk,
 	xfs_exntfmt_t		fmt)
 {
-	xfs_bmbt_rec_t		*ep;
 	xfs_bmbt_irec_t		irec;
-	xfs_bmbt_rec_t		rec;
+	xfs_bmbt_rec_host_t	rec;
 	int			i;
 
 	for (i = 0; i < nrecs; i++) {
-		ep = xfs_iext_get_ext(ifp, i);
-		rec.l0 = get_unaligned((__uint64_t*)&ep->l0);
-		rec.l1 = get_unaligned((__uint64_t*)&ep->l1);
-		if (disk)
-			xfs_bmbt_disk_get_all(&rec, &irec);
-		else
-			xfs_bmbt_get_all(&rec, &irec);
+		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
+		rec.l0 = get_unaligned(&ep->l0);
+		rec.l1 = get_unaligned(&ep->l1);
+		xfs_bmbt_get_all(&rec, &irec);
 		if (fmt == XFS_EXTFMT_NOSTATE)
 			ASSERT(irec.br_state == XFS_EXT_NORM);
 	}
 }
 #else /* DEBUG */
-#define xfs_validate_extents(ifp, nrecs, disk, fmt)
+#define xfs_validate_extents(ifp, nrecs, fmt)
 #endif /* DEBUG */
 
 /*
@@ -602,7 +596,7 @@ xfs_iformat_extents(
 	xfs_dinode_t	*dip,
 	int		whichfork)
 {
-	xfs_bmbt_rec_t	*ep, *dp;
+	xfs_bmbt_rec_t	*dp;
 	xfs_ifork_t	*ifp;
 	int		nex;
 	int		size;
@@ -637,9 +631,9 @@ xfs_iformat_extents(
 	ifp->if_bytes = size;
 	if (size) {
 		dp = (xfs_bmbt_rec_t *) XFS_DFORK_PTR(dip, whichfork);
-		xfs_validate_extents(ifp, nex, 1, XFS_EXTFMT_INODE(ip));
+		xfs_validate_extents(ifp, nex, XFS_EXTFMT_INODE(ip));
 		for (i = 0; i < nex; i++, dp++) {
-			ep = xfs_iext_get_ext(ifp, i);
+			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
 			ep->l0 = INT_GET(get_unaligned((__uint64_t*)&dp->l0),
 								ARCH_CONVERT);
 			ep->l1 = INT_GET(get_unaligned((__uint64_t*)&dp->l1),
@@ -1048,7 +1042,7 @@ xfs_iread_extents(
 		ifp->if_flags &= ~XFS_IFEXTENTS;
 		return error;
 	}
-	xfs_validate_extents(ifp, nextents, 0, XFS_EXTFMT_INODE(ip));
+	xfs_validate_extents(ifp, nextents, XFS_EXTFMT_INODE(ip));
 	return 0;
 }
 
@@ -2887,12 +2881,10 @@ xfs_iunpin_wait(
 int
 xfs_iextents_copy(
 	xfs_inode_t		*ip,
-	xfs_bmbt_rec_t		*buffer,
+	xfs_bmbt_rec_t		*dp,
 	int			whichfork)
 {
 	int			copied;
-	xfs_bmbt_rec_t		*dest_ep;
-	xfs_bmbt_rec_t		*ep;
 	int			i;
 	xfs_ifork_t		*ifp;
 	int			nrecs;
@@ -2912,10 +2904,9 @@ xfs_iextents_copy(
 	 * the delayed ones.  There must be at least one
 	 * non-delayed extent.
 	 */
-	dest_ep = buffer;
 	copied = 0;
 	for (i = 0; i < nrecs; i++) {
-		ep = xfs_iext_get_ext(ifp, i);
+		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
 		start_block = xfs_bmbt_get_startblock(ep);
 		if (ISNULLSTARTBLOCK(start_block)) {
 			/*
@@ -2926,14 +2917,14 @@ xfs_iextents_copy(
 
 		/* Translate to on disk format */
 		put_unaligned(INT_GET(ep->l0, ARCH_CONVERT),
-			      (__uint64_t*)&dest_ep->l0);
+			      (__uint64_t*)&dp->l0);
 		put_unaligned(INT_GET(ep->l1, ARCH_CONVERT),
-			      (__uint64_t*)&dest_ep->l1);
-		dest_ep++;
+			      (__uint64_t*)&dp->l1);
+		dp++;
 		copied++;
 	}
 	ASSERT(copied != 0);
-	xfs_validate_extents(ifp, copied, 1, XFS_EXTFMT_INODE(ip));
+	xfs_validate_extents(ifp, copied, XFS_EXTFMT_INODE(ip));
 
 	return (copied * (uint)sizeof(xfs_bmbt_rec_t));
 }
@@ -3711,7 +3702,7 @@ xfs_ilock_trace(xfs_inode_t *ip, int loc
 /*
  * Return a pointer to the extent record at file index idx.
  */
-xfs_bmbt_rec_t *
+xfs_bmbt_rec_host_t *
 xfs_iext_get_ext(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_extnum_t	idx)		/* index of target extent */
@@ -3744,15 +3735,12 @@ xfs_iext_insert(
 	xfs_extnum_t	count,		/* number of inserted items */
 	xfs_bmbt_irec_t	*new)		/* items to insert */
 {
-	xfs_bmbt_rec_t	*ep;		/* extent record pointer */
 	xfs_extnum_t	i;		/* extent record index */
 
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 	xfs_iext_add(ifp, idx, count);
-	for (i = idx; i < idx + count; i++, new++) {
-		ep = xfs_iext_get_ext(ifp, i);
-		xfs_bmbt_set_all(ep, new);
-	}
+	for (i = idx; i < idx + count; i++, new++)
+		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, i), new);
 }
 
 /*
@@ -4203,7 +4191,7 @@ xfs_iext_realloc_direct(
 			rnew_size = xfs_iroundup(new_size);
 		}
 		if (rnew_size != ifp->if_real_bytes) {
-			ifp->if_u1.if_extents = (xfs_bmbt_rec_t *)
+			ifp->if_u1.if_extents =
 				kmem_realloc(ifp->if_u1.if_extents,
 						rnew_size,
 						ifp->if_real_bytes,
@@ -4266,8 +4254,7 @@ xfs_iext_inline_to_direct(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* number of extents in file */
 {
-	ifp->if_u1.if_extents = (xfs_bmbt_rec_t *)
-		kmem_alloc(new_size, KM_SLEEP);
+	ifp->if_u1.if_extents = kmem_alloc(new_size, KM_SLEEP);
 	memset(ifp->if_u1.if_extents, 0, new_size);
 	if (ifp->if_bytes) {
 		memcpy(ifp->if_u1.if_extents, ifp->if_u2.if_inline_ext,
@@ -4310,7 +4297,7 @@ void
 xfs_iext_indirect_to_direct(
 	 xfs_ifork_t	*ifp)		/* inode fork pointer */
 {
-	xfs_bmbt_rec_t	*ep;		/* extent record pointer */
+	xfs_bmbt_rec_host_t *ep;	/* extent record pointer */
 	xfs_extnum_t	nextents;	/* number of extents in file */
 	int		size;		/* size of file extents */
 
@@ -4362,15 +4349,15 @@ xfs_iext_destroy(
 /*
  * Return a pointer to the extent record for file system block bno.
  */
-xfs_bmbt_rec_t *			/* pointer to found extent record */
+xfs_bmbt_rec_host_t *			/* pointer to found extent record */
 xfs_iext_bno_to_ext(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_fileoff_t	bno,		/* block number to search for */
 	xfs_extnum_t	*idxp)		/* index of target extent */
 {
-	xfs_bmbt_rec_t	*base;		/* pointer to first extent */
+	xfs_bmbt_rec_host_t *base;	/* pointer to first extent */
 	xfs_filblks_t	blockcount = 0;	/* number of blocks in extent */
-	xfs_bmbt_rec_t	*ep = NULL;	/* pointer to target extent */
+	xfs_bmbt_rec_host_t *ep = NULL;	/* pointer to target extent */
 	xfs_ext_irec_t	*erp = NULL;	/* indirection array pointer */
 	int		high;		/* upper boundary in search */
 	xfs_extnum_t	idx = 0;	/* index of target extent */
@@ -4545,8 +4532,7 @@ xfs_iext_irec_init(
 		kmem_alloc(sizeof(xfs_ext_irec_t), KM_SLEEP);
 
 	if (nextents == 0) {
-		ifp->if_u1.if_extents = (xfs_bmbt_rec_t *)
-			kmem_alloc(XFS_IEXT_BUFSZ, KM_SLEEP);
+		ifp->if_u1.if_extents = kmem_alloc(XFS_IEXT_BUFSZ, KM_SLEEP);
 	} else if (!ifp->if_real_bytes) {
 		xfs_iext_inline_to_direct(ifp, XFS_IEXT_BUFSZ);
 	} else if (ifp->if_real_bytes < XFS_IEXT_BUFSZ) {
@@ -4594,8 +4580,7 @@ xfs_iext_irec_new(
 
 	/* Initialize new extent record */
 	erp = ifp->if_u1.if_ext_irec;
-	erp[erp_idx].er_extbuf = (xfs_bmbt_rec_t *)
-		kmem_alloc(XFS_IEXT_BUFSZ, KM_SLEEP);
+	erp[erp_idx].er_extbuf = kmem_alloc(XFS_IEXT_BUFSZ, KM_SLEEP);
 	ifp->if_real_bytes = nlists * XFS_IEXT_BUFSZ;
 	memset(erp[erp_idx].er_extbuf, 0, XFS_IEXT_BUFSZ);
 	erp[erp_idx].er_extcount = 0;
@@ -4727,7 +4712,7 @@ void
 xfs_iext_irec_compact_full(
 	xfs_ifork_t	*ifp)			/* inode fork pointer */
 {
-	xfs_bmbt_rec_t	*ep, *ep_next;		/* extent record pointers */
+	xfs_bmbt_rec_host_t *ep, *ep_next;	/* extent record pointers */
 	xfs_ext_irec_t	*erp, *erp_next;	/* extent irec pointers */
 	int		erp_idx = 0;		/* extent irec index */
 	int		ext_avail;		/* empty entries in ex list */
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-07-15 18:22:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-07-15 18:40:17.000000000 +0200
@@ -44,7 +44,7 @@
  * it is possible that a third level of indirection may be required.
  */
 typedef struct xfs_ext_irec {
-	xfs_bmbt_rec_t	*er_extbuf;	/* block of extent records */
+	xfs_bmbt_rec_host_t *er_extbuf;	/* block of extent records */
 	xfs_extnum_t	er_extoff;	/* extent offset in file */
 	xfs_extnum_t	er_extcount;	/* number of extents in page/block */
 } xfs_ext_irec_t;
@@ -65,12 +65,12 @@ typedef struct xfs_ifork {
 	unsigned char		if_ext_max;	/* max # of extent records */
 	xfs_extnum_t		if_lastex;	/* last if_extents used */
 	union {
-		xfs_bmbt_rec_t	*if_extents;	/* linear map file exts */
+		xfs_bmbt_rec_host_t *if_extents;/* linear map file exts */
 		xfs_ext_irec_t	*if_ext_irec;	/* irec map file exts */
 		char		*if_data;	/* inline file data */
 	} if_u1;
 	union {
-		xfs_bmbt_rec_t	if_inline_ext[XFS_INLINE_EXTS];
+		xfs_bmbt_rec_host_t if_inline_ext[XFS_INLINE_EXTS];
 						/* very small file extents */
 		char		if_inline_data[XFS_INLINE_DATA];
 						/* very small file data */
@@ -549,7 +549,7 @@ xfs_inode_t	*xfs_vtoi(struct bhv_vnode *
 
 void		xfs_synchronize_atime(xfs_inode_t *);
 
-xfs_bmbt_rec_t	*xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
+xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
 				xfs_bmbt_irec_t *);
 void		xfs_iext_add(xfs_ifork_t *, xfs_extnum_t, int);
@@ -564,7 +564,7 @@ void		xfs_iext_indirect_to_direct(xfs_if
 void		xfs_iext_direct_to_inline(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_inline_to_direct(xfs_ifork_t *, int);
 void		xfs_iext_destroy(xfs_ifork_t *);
-xfs_bmbt_rec_t	*xfs_iext_bno_to_ext(xfs_ifork_t *, xfs_fileoff_t, int *);
+xfs_bmbt_rec_host_t *xfs_iext_bno_to_ext(xfs_ifork_t *, xfs_fileoff_t, int *);
 xfs_ext_irec_t	*xfs_iext_bno_to_irec(xfs_ifork_t *, xfs_fileoff_t, int *);
 xfs_ext_irec_t	*xfs_iext_idx_to_irec(xfs_ifork_t *, xfs_extnum_t *, int *, int);
 void		xfs_iext_irec_init(xfs_ifork_t *);
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-07-15 18:44:25.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-07-15 18:57:42.000000000 +0200
@@ -127,7 +127,7 @@ static void	xfsidbg_xattrleaf(xfs_attr_l
 static void	xfsidbg_xattrsf(xfs_attr_shortform_t *);
 static void	xfsidbg_xbirec(xfs_bmbt_irec_t *r);
 static void	xfsidbg_xbmalla(xfs_bmalloca_t *);
-static void	xfsidbg_xbrec(xfs_bmbt_rec_64_t *);
+static void	xfsidbg_xbrec(xfs_bmbt_rec_host_t *);
 static void	xfsidbg_xbroot(xfs_inode_t *);
 static void	xfsidbg_xbroota(xfs_inode_t *);
 static void	xfsidbg_xbtcur(xfs_btree_cur_t *);
@@ -901,7 +901,7 @@ static int	kdbm_xfs_xbrec(
 	if (diag)
 		return diag;
 
-	xfsidbg_xbrec((xfs_bmbt_rec_64_t *) addr);
+	xfsidbg_xbrec((xfs_bmbt_rec_host_t *) addr);
 	return 0;
 }
 
@@ -3103,7 +3103,7 @@ xfs_bmbt_trace_entry(
 	ktrace_entry_t	  *ktep)
 {
 	int			line;
-	xfs_bmbt_rec_32_t	r;
+	xfs_bmbt_rec_host_t	r;
 	xfs_bmbt_irec_t		s;
 	int			type;
 	int			whichfork;
@@ -3181,11 +3181,12 @@ xfs_bmbt_trace_entry(
 			((long)ktep->val[5] >> 24) & 0xff,
 			((long)ktep->val[5] >> 16) & 0xff,
 			(long)ktep->val[5] & 0xffff);
-		r.l0 = (xfs_bmbt_rec_base_t)(unsigned long)ktep->val[6];
-		r.l1 = (xfs_bmbt_rec_base_t)(unsigned long)ktep->val[7];
-		r.l2 = (xfs_bmbt_rec_base_t)(unsigned long)ktep->val[8];
-		r.l3 = (xfs_bmbt_rec_base_t)(unsigned long)ktep->val[9];
-		xfsidbg_xbrec((xfs_bmbt_rec_64_t *)&r);
+		r.l0 = (unsigned long long)(unsigned long)ktep->val[6] << 32 |
+			(unsigned long)ktep->val[7];
+		r.l1 = (unsigned long long)(unsigned long)ktep->val[8] << 32 |
+			(unsigned long)ktep->val[9];
+
+		xfsidbg_xbrec(&r);
 		qprintf(" bufs 0x%p 0x%p 0x%p 0x%p ",
 			(xfs_buf_t *)ktep->val[10],
 			(xfs_buf_t *)ktep->val[11],
@@ -4870,11 +4871,11 @@ xfsidbg_xbmstrace(xfs_inode_t *ip)
  * Print xfs bmap record
  */
 static void
-xfsidbg_xbrec(xfs_bmbt_rec_64_t *r)
+xfsidbg_xbrec(xfs_bmbt_rec_host_t *r)
 {
 	xfs_bmbt_irec_t	irec;
 
-	xfs_bmbt_get_all((xfs_bmbt_rec_t *)r, &irec);
+	xfs_bmbt_get_all(r, &irec);
 	kdb_printf("startoff %Ld startblock %Lx blockcount %Ld flag %d\n",
 		irec.br_startoff, (__uint64_t)irec.br_startblock,
 		irec.br_blockcount, irec.br_state);
