Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:28:58 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJSsVc031158
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:28:54 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 461151947CAD
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:04 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id ZryDhgEdnRjoO6oR for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:04 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJU5IF019145
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:30:05 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJU5XG019143
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:30:05 +0200
Date: Tue, 29 Jul 2008 21:30:05 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/21] split up xfs_btree_init_cursor
Message-ID: <20080729193005.GB19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-split-init-cursor
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_btree_init_cursor contains close to little shared code for the different
btrees and will get even more non-common code in the future.  Split it up
into one routine per btree type.

Because xfs_btree_dup_cursor needs to call the init routine for a generic
btree cursor add a new btree operation vector that contains a dup_cursor
method that initializes a new cursor based on an existing one.

The btree operations vector is based on an idea and code from Dave Chinner
and will be used for more operations later on.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-14 17:26:11.000000000 +0200
@@ -136,6 +136,11 @@ extern const __uint32_t	xfs_magics[];
 
 #define	XFS_BTREE_MAXLEVELS	8	/* max of all btrees */
 
+struct xfs_btree_ops {
+	/* cursor operations */
+	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
+};
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -144,6 +149,7 @@ typedef struct xfs_btree_cur
 {
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
+	const struct xfs_btree_ops *bc_ops;
 	union {
 		xfs_alloc_rec_incore_t	a;
 		xfs_bmbt_irec_t		b;
@@ -313,20 +319,6 @@ xfs_btree_get_bufs(
 	uint			lock);	/* lock flags for get_buf */
 
 /*
- * Allocate a new btree cursor.
- * The cursor is either for allocation (A) or bmap (B).
- */
-xfs_btree_cur_t *			/* new btree cursor */
-xfs_btree_init_cursor(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	struct xfs_buf		*agbp,	/* (A only) buffer for agf structure */
-	xfs_agnumber_t		agno,	/* (A only) allocation group number */
-	xfs_btnum_t		btnum,	/* btree identifier */
-	struct xfs_inode	*ip,	/* (B only) inode owning the btree */
-	int			whichfork); /* (B only) data/attr fork */
-
-/*
  * Check for the cursor referring to the last block at the given level.
  */
 int					/* 1=is last block, 0=not last block */
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-14 17:26:11.000000000 +0200
@@ -387,16 +387,17 @@ xfs_btree_dup_cursor(
 
 	tp = cur->bc_tp;
 	mp = cur->bc_mp;
+
 	/*
 	 * Allocate a new cursor like the old one.
 	 */
-	new = xfs_btree_init_cursor(mp, tp, cur->bc_private.a.agbp,
-		cur->bc_private.a.agno, cur->bc_btnum, cur->bc_private.b.ip,
-		cur->bc_private.b.whichfork);
+	new = cur->bc_ops->dup_cursor(cur);
+
 	/*
 	 * Copy the record currently in the cursor.
 	 */
 	new->bc_rec = cur->bc_rec;
+
 	/*
 	 * For each level current, re-get the buffer and copy the ptr value.
 	 */
@@ -416,15 +417,6 @@ xfs_btree_dup_cursor(
 		} else
 			new->bc_bufs[i] = NULL;
 	}
-	/*
-	 * For bmap btrees, copy the firstblock, flist, and flags values,
-	 * since init cursor doesn't get them.
-	 */
-	if (new->bc_btnum == XFS_BTNUM_BMAP) {
-		new->bc_private.b.firstblock = cur->bc_private.b.firstblock;
-		new->bc_private.b.flist = cur->bc_private.b.flist;
-		new->bc_private.b.flags = cur->bc_private.b.flags;
-	}
 	*ncur = new;
 	return 0;
 }
@@ -505,97 +497,6 @@ xfs_btree_get_bufs(
 }
 
 /*
- * Allocate a new btree cursor.
- * The cursor is either for allocation (A) or bmap (B) or inodes (I).
- */
-xfs_btree_cur_t *			/* new btree cursor */
-xfs_btree_init_cursor(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*agbp,		/* (A only) buffer for agf structure */
-					/* (I only) buffer for agi structure */
-	xfs_agnumber_t	agno,		/* (AI only) allocation group number */
-	xfs_btnum_t	btnum,		/* btree identifier */
-	xfs_inode_t	*ip,		/* (B only) inode owning the btree */
-	int		whichfork)	/* (B only) data or attr fork */
-{
-	xfs_agf_t	*agf;		/* (A) allocation group freespace */
-	xfs_agi_t	*agi;		/* (I) allocation group inodespace */
-	xfs_btree_cur_t	*cur;		/* return value */
-	xfs_ifork_t	*ifp;		/* (I) inode fork pointer */
-	int		nlevels=0;	/* number of levels in the btree */
-
-	ASSERT(xfs_btree_cur_zone != NULL);
-	/*
-	 * Allocate a new cursor.
-	 */
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
-	/*
-	 * Deduce the number of btree levels from the arguments.
-	 */
-	switch (btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		agf = XFS_BUF_TO_AGF(agbp);
-		nlevels = be32_to_cpu(agf->agf_levels[btnum]);
-		break;
-	case XFS_BTNUM_BMAP:
-		ifp = XFS_IFORK_PTR(ip, whichfork);
-		nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
-		break;
-	case XFS_BTNUM_INO:
-		agi = XFS_BUF_TO_AGI(agbp);
-		nlevels = be32_to_cpu(agi->agi_level);
-		break;
-	default:
-		ASSERT(0);
-	}
-	/*
-	 * Fill in the common fields.
-	 */
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_nlevels = nlevels;
-	cur->bc_btnum = btnum;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	/*
-	 * Fill in private fields.
-	 */
-	switch (btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		/*
-		 * Allocation btree fields.
-		 */
-		cur->bc_private.a.agbp = agbp;
-		cur->bc_private.a.agno = agno;
-		break;
-	case XFS_BTNUM_INO:
-		/*
-		 * Inode allocation btree fields.
-		 */
-		cur->bc_private.a.agbp = agbp;
-		cur->bc_private.a.agno = agno;
-		break;
-	case XFS_BTNUM_BMAP:
-		/*
-		 * Bmap btree fields.
-		 */
-		cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
-		cur->bc_private.b.ip = ip;
-		cur->bc_private.b.firstblock = NULLFSBLOCK;
-		cur->bc_private.b.flist = NULL;
-		cur->bc_private.b.allocated = 0;
-		cur->bc_private.b.flags = 0;
-		cur->bc_private.b.whichfork = whichfork;
-		break;
-	default:
-		ASSERT(0);
-	}
-	return cur;
-}
-
-/*
  * Check for the cursor referring to the last block at the given level.
  */
 int					/* 1=is last block, 0=not last block */
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-14 17:26:11.000000000 +0200
@@ -2608,3 +2608,62 @@ xfs_check_nostate_extents(
 	}
 	return 0;
 }
+
+
+STATIC struct xfs_btree_cur *
+xfs_bmbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_cur	*new;
+
+	new = xfs_bmbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+
+	/*
+	 * Copy the firstblock, flist, and flags values,
+	 * since init cursor doesn't get them.
+	 */
+	new->bc_private.b.firstblock = cur->bc_private.b.firstblock;
+	new->bc_private.b.flist = cur->bc_private.b.flist;
+	new->bc_private.b.flags = cur->bc_private.b.flags;
+
+	return new;
+}
+
+static const struct xfs_btree_ops xfs_bmbt_ops = {
+	.dup_cursor		= xfs_bmbt_dup_cursor,
+};
+
+/*
+ * Allocate a new bmap btree cursor.
+ */
+struct xfs_btree_cur *				/* new bmap btree cursor */
+xfs_bmbt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* inode owning the btree */
+	int			whichfork)	/* data or attr fork */
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_btree_cur	*cur;
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	cur->bc_btnum = XFS_BTNUM_BMAP;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+
+	cur->bc_ops = &xfs_bmbt_ops;
+
+	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
+	cur->bc_private.b.ip = ip;
+	cur->bc_private.b.firstblock = NULLFSBLOCK;
+	cur->bc_private.b.flist = NULL;
+	cur->bc_private.b.allocated = 0;
+	cur->bc_private.b.flags = 0;
+	cur->bc_private.b.whichfork = whichfork;
+
+	return cur;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-07-14 17:26:11.000000000 +0200
@@ -2076,3 +2076,44 @@ xfs_inobt_update(
 	}
 	return 0;
 }
+
+STATIC struct xfs_btree_cur *
+xfs_inobt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno);
+}
+
+static const struct xfs_btree_ops xfs_inobt_ops = {
+	.dup_cursor		= xfs_inobt_dup_cursor,
+};
+
+/*
+ * Allocate a new inode btree cursor.
+ */
+struct xfs_btree_cur *				/* new inode btree cursor */
+xfs_inobt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_buf		*agbp,		/* buffer for agi structure */
+	xfs_agnumber_t		agno)		/* allocation group number */
+{
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_btree_cur	*cur;
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_nlevels = be32_to_cpu(agi->agi_level);
+	cur->bc_btnum = XFS_BTNUM_INO;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+
+	cur->bc_ops = &xfs_inobt_ops;
+
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_private.a.agno = agno;
+
+	return cur;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-07-14 17:26:11.000000000 +0200
@@ -640,8 +640,8 @@ xfs_alloc_ag_vextent_exact(
 	/*
 	 * Allocate/initialize a cursor for the by-number freespace btree.
 	 */
-	bno_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO, NULL, 0);
+	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_BNO);
 	/*
 	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
 	 * Look for the closest free block <= bno, it must contain bno
@@ -696,8 +696,8 @@ xfs_alloc_ag_vextent_exact(
 	 * We are allocating agbno for rlen [agbno .. end]
 	 * Allocate/initialize a cursor for the by-size btree.
 	 */
-	cnt_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT, NULL, 0);
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_CNT);
 	ASSERT(args->agbno + args->len <=
 		be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
@@ -759,8 +759,8 @@ xfs_alloc_ag_vextent_near(
 	/*
 	 * Get a cursor for the by-size btree.
 	 */
-	cnt_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT, NULL, 0);
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_CNT);
 	ltlen = 0;
 	bno_cur_lt = bno_cur_gt = NULL;
 	/*
@@ -886,8 +886,8 @@ xfs_alloc_ag_vextent_near(
 		/*
 		 * Set up a cursor for the by-bno tree.
 		 */
-		bno_cur_lt = xfs_btree_init_cursor(args->mp, args->tp,
-			args->agbp, args->agno, XFS_BTNUM_BNO, NULL, 0);
+		bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp,
+			args->agbp, args->agno, XFS_BTNUM_BNO);
 		/*
 		 * Fix up the btree entries.
 		 */
@@ -914,8 +914,8 @@ xfs_alloc_ag_vextent_near(
 	/*
 	 * Allocate and initialize the cursor for the leftward search.
 	 */
-	bno_cur_lt = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO, NULL, 0);
+	bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_BNO);
 	/*
 	 * Lookup <= bno to find the leftward search's starting point.
 	 */
@@ -1267,8 +1267,8 @@ xfs_alloc_ag_vextent_size(
 	/*
 	 * Allocate and initialize a cursor for the by-size btree.
 	 */
-	cnt_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT, NULL, 0);
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_CNT);
 	bno_cur = NULL;
 	/*
 	 * Look for an entry >= maxlen+alignment-1 blocks.
@@ -1372,8 +1372,8 @@ xfs_alloc_ag_vextent_size(
 	/*
 	 * Allocate and initialize a cursor for the by-block tree.
 	 */
-	bno_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO, NULL, 0);
+	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_BNO);
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
 			rbno, rlen, XFSA_FIXUP_CNT_OK)))
 		goto error0;
@@ -1515,8 +1515,7 @@ xfs_free_ag_extent(
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
 	 */
-	bno_cur = xfs_btree_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO, NULL,
-		0);
+	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO);
 	cnt_cur = NULL;
 	/*
 	 * Look for a neighboring block on the left (lower block numbers)
@@ -1575,8 +1574,7 @@ xfs_free_ag_extent(
 	/*
 	 * Now allocate and initialize a cursor for the by-size tree.
 	 */
-	cnt_cur = xfs_btree_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_CNT, NULL,
-		0);
+	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_CNT);
 	/*
 	 * Have both left and right contiguous neighbors.
 	 * Merge all three into a single free block.
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-07-14 17:26:11.000000000 +0200
@@ -2209,3 +2209,48 @@ xfs_alloc_update(
 	}
 	return 0;
 }
+
+STATIC struct xfs_btree_cur *
+xfs_allocbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno,
+			cur->bc_btnum);
+}
+
+static const struct xfs_btree_ops xfs_allocbt_ops = {
+	.dup_cursor		= xfs_allocbt_dup_cursor,
+};
+
+/*
+ * Allocate a new allocation btree cursor.
+ */
+struct xfs_btree_cur *			/* new alloc btree cursor */
+xfs_allocbt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_buf		*agbp,		/* buffer for agf structure */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_btnum_t		btnum)		/* btree identifier */
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
+
+	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[btnum]);
+	cur->bc_btnum = btnum;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+
+	cur->bc_ops = &xfs_allocbt_ops;
+
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_private.a.agno = agno;
+
+	return cur;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-07-14 17:26:11.000000000 +0200
@@ -152,4 +152,9 @@ extern int xfs_alloc_lookup_le(struct xf
 extern int xfs_alloc_update(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 				xfs_extlen_t len);
 
+
+extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
+		struct xfs_trans *, struct xfs_buf *,
+		xfs_agnumber_t, xfs_btnum_t);
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-07-14 17:26:11.000000000 +0200
@@ -422,8 +422,7 @@ xfs_bmap_add_attrfork_btree(
 	if (ip->i_df.if_broot_bytes <= XFS_IFORK_DSIZE(ip))
 		*flags |= XFS_ILOG_DBROOT;
 	else {
-		cur = xfs_btree_init_cursor(mp, tp, NULL, 0, XFS_BTNUM_BMAP, ip,
-			XFS_DATA_FORK);
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
 		cur->bc_private.b.flist = flist;
 		cur->bc_private.b.firstblock = *firstblock;
 		if ((error = xfs_bmbt_lookup_ge(cur, 0, 0, 0, &stat)))
@@ -3441,8 +3440,7 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	mp = ip->i_mount;
-	cur = xfs_btree_init_cursor(mp, tp, NULL, 0, XFS_BTNUM_BMAP, ip,
-		whichfork);
+	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	cur->bc_private.b.firstblock = *firstblock;
 	cur->bc_private.b.flist = flist;
 	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
@@ -5029,8 +5027,7 @@ xfs_bmapi(
 				if (abno == NULLFSBLOCK)
 					break;
 				if ((ifp->if_flags & XFS_IFBROOT) && !cur) {
-					cur = xfs_btree_init_cursor(mp,
-						tp, NULL, 0, XFS_BTNUM_BMAP,
+					cur = xfs_bmbt_init_cursor(mp, tp,
 						ip, whichfork);
 					cur->bc_private.b.firstblock =
 						*firstblock;
@@ -5147,9 +5144,8 @@ xfs_bmapi(
 			 */
 			ASSERT(mval->br_blockcount <= len);
 			if ((ifp->if_flags & XFS_IFBROOT) && !cur) {
-				cur = xfs_btree_init_cursor(mp,
-					tp, NULL, 0, XFS_BTNUM_BMAP,
-					ip, whichfork);
+				cur = xfs_bmbt_init_cursor(mp,
+					tp, ip, whichfork);
 				cur->bc_private.b.firstblock =
 					*firstblock;
 				cur->bc_private.b.flist = flist;
@@ -5440,8 +5436,7 @@ xfs_bunmapi(
 	logflags = 0;
 	if (ifp->if_flags & XFS_IFBROOT) {
 		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
-		cur = xfs_btree_init_cursor(mp, tp, NULL, 0, XFS_BTNUM_BMAP, ip,
-			whichfork);
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstblock;
 		cur->bc_private.b.flist = flist;
 		cur->bc_private.b.flags = 0;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-07-14 17:26:11.000000000 +0200
@@ -24,6 +24,7 @@ struct xfs_btree_cur;
 struct xfs_btree_lblock;
 struct xfs_mount;
 struct xfs_inode;
+struct xfs_trans;
 
 /*
  * Bmap root header, on-disk form only.
@@ -300,6 +301,9 @@ extern void xfs_bmbt_to_bmdr(xfs_bmbt_bl
 extern int xfs_bmbt_update(struct xfs_btree_cur *, xfs_fileoff_t,
 				xfs_fsblock_t, xfs_filblks_t, xfs_exntst_t);
 
+extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
+		struct xfs_trans *, struct xfs_inode *, int);
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BMAP_BTREE_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-07-14 17:26:11.000000000 +0200
@@ -335,8 +335,7 @@ xfs_ialloc_ag_alloc(
 	/*
 	 * Insert records describing the new inode chunk into the btree.
 	 */
-	cur = xfs_btree_init_cursor(args.mp, tp, agbp, agno,
-			XFS_BTNUM_INO, (xfs_inode_t *)0, 0);
+	cur = xfs_inobt_init_cursor(args.mp, tp, agbp, agno);
 	for (thisino = newino;
 	     thisino < newino + newlen;
 	     thisino += XFS_INODES_PER_CHUNK) {
@@ -676,8 +675,7 @@ nextag:
 	 */
 	agno = tagno;
 	*IO_agbp = NULL;
-	cur = xfs_btree_init_cursor(mp, tp, agbp, be32_to_cpu(agi->agi_seqno),
-				    XFS_BTNUM_INO, (xfs_inode_t *)0, 0);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, be32_to_cpu(agi->agi_seqno));
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1022,8 +1020,7 @@ xfs_difree(
 	/*
 	 * Initialize the cursor.
 	 */
-	cur = xfs_btree_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO,
-		(xfs_inode_t *)0, 0);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
 #ifdef DEBUG
 	if (cur->bc_nlevels == 1) {
 		int freecount = 0;
@@ -1259,8 +1256,7 @@ xfs_dilocate(
 #endif /* DEBUG */
 			return error;
 		}
-		cur = xfs_btree_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO,
-			(xfs_inode_t *)0, 0);
+		cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
 		if ((error = xfs_inobt_lookup_le(cur, agino, 0, 0, &i))) {
 #ifdef DEBUG
 			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-07-14 17:26:11.000000000 +0200
@@ -175,4 +175,8 @@ extern int xfs_inobt_lookup_le(struct xf
 extern int xfs_inobt_update(struct xfs_btree_cur *cur, xfs_agino_t ino,
 				__int32_t fcnt, xfs_inofree_t free);
 
+
+extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
+		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-07-14 17:24:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-07-14 17:26:11.000000000 +0200
@@ -418,8 +418,7 @@ xfs_bulkstat(
 		/*
 		 * Allocate and initialize a btree cursor for ialloc btree.
 		 */
-		cur = xfs_btree_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_INO,
-						(xfs_inode_t *)0, 0);
+		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
 		irbp = irbuf;
 		irbufend = irbuf + nirbuf;
 		end_of_ag = 0;
@@ -844,8 +843,7 @@ xfs_inumbers(
 				agino = 0;
 				continue;
 			}
-			cur = xfs_btree_init_cursor(mp, NULL, agbp, agno,
-				XFS_BTNUM_INO, (xfs_inode_t *)0, 0);
+			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
 			error = xfs_inobt_lookup_ge(cur, agino, 0, 0, &tmp);
 			if (error) {
 				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);

-- 
