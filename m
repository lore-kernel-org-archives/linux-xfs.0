Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3BA2B806B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:34:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C5218F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:09 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gozjZ8XFkhJXPAwI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:07 -0700 (PDT)
Subject: [PATCH 031/145] xfs: add owner field to extent allocation and freeing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:33:59 -0700
Message-ID: <146612723948.16048.17689566761161440372.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

For the rmap btree to work, we have to feed the extent owner
information to the the allocation and freeing functions. This
information is what will end up in the rmap btree that tracks
allocated extents. While we technically don't need the owner
information when freeing extents, passing it allows us to validate
that the extent we are removing from the rmap btree actually
belonged to the owner we expected it to belong to.

We also define a special set of owner values for internal metadata
that would otherwise have no owner. This allows us to tell the
difference between metadata owned by different per-ag btrees, as
well as static fs metadata (e.g. AG headers) and internal journal
blocks.

There are also a couple of special cases we need to take care of -
during EFI recovery, we don't actually know who the original owner
was, so we need to pass a wildcard to indicate that we aren't
checking the owner for validity. We also need special handling in
growfs, as we "free" the space in the last AG when extending it, but
because it's new space it has no actual owner...

While touching the xfs_bmap_add_free() function, re-order the
parameters to put the struct xfs_mount first.

Extend the owner field to include both the owner type and some sort
of index within the owner.  The index field will be used to support
reverse mappings when reflink is enabled.

This is based upon a patch originally from Dave Chinner. It has been
extended to add more owner information with the intent of helping
recovery operations when things go wrong (e.g. offset of user data
block in a file).

[dchinner: de-shout the xfs_rmap_*_owner helpers]
[darrick: minor style fixes suggested by Christoph Hellwig]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/defer_item.c       |    2 +
 libxfs/xfs_alloc.c        |   11 ++++++--
 libxfs/xfs_alloc.h        |    4 ++-
 libxfs/xfs_bmap.c         |   17 ++++++++++--
 libxfs/xfs_bmap.h         |    4 ++-
 libxfs/xfs_bmap_btree.c   |    6 +++-
 libxfs/xfs_format.h       |   65 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ialloc.c       |    7 +++--
 libxfs/xfs_ialloc_btree.c |    7 ++++-
 9 files changed, 110 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 72c28f8..777875c 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -92,7 +92,7 @@ xfs_bmap_free_finish_item(
 
 	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
 	error = xfs_free_extent(tp, free->xbfi_startblock,
-			free->xbfi_blockcount);
+			free->xbfi_blockcount, &free->xbfi_oinfo);
 	kmem_free(free);
 	return error;
 }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 738275f..e3442a3 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1592,6 +1592,7 @@ xfs_free_ag_extent(
 	xfs_agnumber_t	agno,	/* allocation group number */
 	xfs_agblock_t	bno,	/* starting block number */
 	xfs_extlen_t	len,	/* length of extent */
+	struct xfs_owner_info	*oinfo,	/* extent owner */
 	int		isfl)	/* set if is freelist blocks - no sb acctg */
 {
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
@@ -2001,13 +2002,15 @@ xfs_alloc_fix_freelist(
 	 * back on the free list? Maybe we should only do this when space is
 	 * getting low or the AGFL is more than half full?
 	 */
+	xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
 	while (pag->pagf_flcount > need) {
 		struct xfs_buf	*bp;
 
 		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;
-		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1);
+		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
+					   &targs.oinfo, 1);
 		if (error)
 			goto out_agbp_relse;
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
@@ -2017,6 +2020,7 @@ xfs_alloc_fix_freelist(
 	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
+	xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
@@ -2707,7 +2711,8 @@ int				/* error */
 xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_fsblock_t		bno,	/* starting block number of extent */
-	xfs_extlen_t		len)	/* length of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	struct xfs_owner_info	*oinfo)	/* extent owner */
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*agbp;
@@ -2735,7 +2740,7 @@ xfs_free_extent(
 			agbno + len <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length),
 			err);
 
-	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, 0);
+	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, 0);
 	if (error)
 		goto err;
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 20b54aa..0721a48 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -123,6 +123,7 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
+	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 } xfs_alloc_arg_t;
 
 /*
@@ -210,7 +211,8 @@ int				/* error */
 xfs_free_extent(
 	struct xfs_trans *tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len);	/* length of extent */
+	xfs_extlen_t	len,	/* length of extent */
+	struct xfs_owner_info	*oinfo);	/* extent owner */
 
 int				/* error */
 xfs_alloc_lookup_ge(
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 33e181c..de1c759 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -566,7 +566,8 @@ xfs_bmap_add_free(
 	struct xfs_mount	*mp,		/* mount point structure */
 	struct xfs_defer_ops	*dfops,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
-	xfs_filblks_t		len)		/* length of extent */
+	xfs_filblks_t		len,		/* length of extent */
+	struct xfs_owner_info	*oinfo)		/* extent owner */
 {
 	struct xfs_bmap_free_item	*new;		/* new element */
 #ifdef DEBUG
@@ -585,9 +586,14 @@ xfs_bmap_add_free(
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
 	ASSERT(xfs_bmap_free_item_zone != NULL);
+
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
+	if (oinfo)
+		memcpy(&new->xbfi_oinfo, oinfo, sizeof(struct xfs_owner_info));
+	else
+		memset(&new->xbfi_oinfo, 0, sizeof(struct xfs_owner_info));
 	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
 			XFS_FSB_TO_AGBNO(mp, bno), len);
 	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xbfi_list);
@@ -620,6 +626,7 @@ xfs_bmap_btree_to_extents(
 	xfs_mount_t		*mp;	/* mount point structure */
 	__be64			*pp;	/* ptr to block address */
 	struct xfs_btree_block	*rblock;/* root btree block */
+	struct xfs_owner_info	oinfo;
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -643,7 +650,8 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1);
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -724,6 +732,7 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
 	args.firstblock = *firstblock;
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
@@ -870,6 +879,7 @@ xfs_bmap_local_to_extents(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
+	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
 	args.firstblock = *firstblock;
 	/*
 	 * Allocate a block.  We know we need only one, since the
@@ -4831,6 +4841,7 @@ xfs_bmap_del_extent(
 		nblks = 0;
 		do_fx = 0;
 	}
+
 	/*
 	 * Set flag value to use in switch statement.
 	 * Left-contig is 2, right-contig is 1.
@@ -5018,7 +5029,7 @@ xfs_bmap_del_extent(
 	 */
 	if (do_fx)
 		xfs_bmap_add_free(mp, dfops, del->br_startblock,
-			del->br_blockcount);
+				  del->br_blockcount, NULL);
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 6854e61..41f7ef2 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -67,6 +67,7 @@ struct xfs_bmap_free_item
 	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
 	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
 	struct list_head	xbfi_list;
+	struct xfs_owner_info	xbfi_oinfo;	/* extent owner */
 };
 
 #define	XFS_BMAP_MAX_NMAP	4
@@ -165,7 +166,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
-			  xfs_fsblock_t bno, xfs_filblks_t len);
+			  xfs_fsblock_t bno, xfs_filblks_t len,
+			  struct xfs_owner_info *oinfo);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index d290769..404e321 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -444,6 +444,8 @@ xfs_bmbt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
+			cur->bc_private.b.whichfork);
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
@@ -523,8 +525,10 @@ xfs_bmbt_free_block(
 	struct xfs_inode	*ip = cur->bc_private.b.ip;
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
 
-	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1);
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 12048fa..1b63315 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1318,6 +1318,71 @@ typedef __be32 xfs_inobt_ptr_t;
  */
 #define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
 
+/*
+ * Ownership info for an extent.  This is used to create reverse-mapping
+ * entries.
+ */
+#define XFS_OWNER_INFO_ATTR_FORK	(1 << 0)
+#define XFS_OWNER_INFO_BMBT_BLOCK	(1 << 1)
+struct xfs_owner_info {
+	uint64_t		oi_owner;
+	xfs_fileoff_t		oi_offset;
+	unsigned int		oi_flags;
+};
+
+static inline void
+xfs_rmap_ag_owner(
+	struct xfs_owner_info	*oi,
+	uint64_t		owner)
+{
+	oi->oi_owner = owner;
+	oi->oi_offset = 0;
+	oi->oi_flags = 0;
+}
+
+static inline void
+xfs_rmap_ino_bmbt_owner(
+	struct xfs_owner_info	*oi,
+	xfs_ino_t		ino,
+	int			whichfork)
+{
+	oi->oi_owner = ino;
+	oi->oi_offset = 0;
+	oi->oi_flags = XFS_OWNER_INFO_BMBT_BLOCK;
+	if (whichfork == XFS_ATTR_FORK)
+		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+}
+
+static inline void
+xfs_rmap_ino_owner(
+	struct xfs_owner_info	*oi,
+	xfs_ino_t		ino,
+	int			whichfork,
+	xfs_fileoff_t		offset)
+{
+	oi->oi_owner = ino;
+	oi->oi_offset = offset;
+	oi->oi_flags = 0;
+	if (whichfork == XFS_ATTR_FORK)
+		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+}
+
+/*
+ * Special owner types.
+ *
+ * Seeing as we only support up to 8EB, we have the upper bit of the owner field
+ * to tell us we have a special owner value. We use these for static metadata
+ * allocated at mkfs/growfs time, as well as for freespace management metadata.
+ */
+#define XFS_RMAP_OWN_NULL	(-1ULL)	/* No owner, for growfs */
+#define XFS_RMAP_OWN_UNKNOWN	(-2ULL)	/* Unknown owner, for EFI recovery */
+#define XFS_RMAP_OWN_FS		(-3ULL)	/* static fs metadata */
+#define XFS_RMAP_OWN_LOG	(-4ULL)	/* static fs metadata */
+#define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
+#define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
+#define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
+#define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
+
 #define	XFS_RMAP_BLOCK(mp) \
 	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
 	 XFS_FIBT_BLOCK(mp) + 1 : \
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 1545338..8c2344c 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -609,6 +609,7 @@ xfs_ialloc_ag_alloc(
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
+	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INODES);
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
@@ -1819,12 +1820,14 @@ xfs_difree_inode_chunk(
 	int		nextbit;
 	xfs_agblock_t	agbno;
 	int		contigblk;
+	struct xfs_owner_info	oinfo;
 	DECLARE_BITMAP(holemask, XFS_INOBT_HOLEMASK_BITS);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
 		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, sagbno),
-				  mp->m_ialloc_blks);
+				  mp->m_ialloc_blks, &oinfo);
 		return;
 	}
 
@@ -1868,7 +1871,7 @@ xfs_difree_inode_chunk(
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, agbno),
-				  contigblk);
+				  contigblk, &oinfo);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index cd61419..d79ddfe 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -95,6 +95,7 @@ xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
+	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INOBT);
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
@@ -124,8 +125,12 @@ xfs_inobt_free_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
+	struct xfs_owner_info	oinfo;
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	return xfs_free_extent(cur->bc_tp,
-			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1);
+			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
+			&oinfo);
 }
 
 STATIC int

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
