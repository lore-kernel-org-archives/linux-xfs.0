Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0882129E15
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 22:17:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A4AA304032
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:17:13 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gj0GOILLEc8fMnIx for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 20:17:08 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ad94T-0004A8-13
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:33 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ad94G-0007uN-Fd
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/16] xfs: add owner field to extent allocation and freeing
Date: Tue,  8 Mar 2016 15:16:07 +1100
Message-Id: <1457410578-30233-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1457410578-30233-1-git-send-email-david@fromorbit.com>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: "Darrick J. Wong" <darrick.wong@oracle.com>

For the rmap btree to work, we have to fed the extent owner
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

Extend the owner field to include both the owner type and some sort
of index within the owner.  The index field will be used to support
reverse mappings when reflink is enabled.

This is based upon a patch originally from Dave Chinner. It has been
extended to add more owner information with the intent of helping
recovery operations when things go wrong (e.g. offset of user data
block in a file).

[dchinner: de-shout the xfs_rmap_*_owner helpers]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_alloc.c        | 12 ++++++--
 fs/xfs/libxfs/xfs_alloc.h        |  4 ++-
 fs/xfs/libxfs/xfs_bmap.c         | 17 +++++++++--
 fs/xfs/libxfs/xfs_bmap.h         |  4 ++-
 fs/xfs/libxfs/xfs_bmap_btree.c   |  6 +++-
 fs/xfs/libxfs/xfs_format.h       | 65 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c       |  7 +++--
 fs/xfs/libxfs/xfs_ialloc_btree.c |  7 ++++-
 fs/xfs/xfs_bmap_util.c           |  3 +-
 fs/xfs/xfs_fsops.c               | 16 +++++++---
 fs/xfs/xfs_log_recover.c         |  5 +++-
 fs/xfs/xfs_trans.h               |  2 +-
 fs/xfs/xfs_trans_extfree.c       |  5 ++--
 13 files changed, 132 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 19b7521..0222e03 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1595,6 +1595,7 @@ xfs_free_ag_extent(
 	xfs_agnumber_t	agno,	/* allocation group number */
 	xfs_agblock_t	bno,	/* starting block number */
 	xfs_extlen_t	len,	/* length of extent */
+	struct xfs_owner_info	*oinfo,	/* extent owner */
 	int		isfl)	/* set if is freelist blocks - no sb acctg */
 {
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
@@ -2015,13 +2016,15 @@ xfs_alloc_fix_freelist(
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
@@ -2031,6 +2034,7 @@ xfs_alloc_fix_freelist(
 	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
+	xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
@@ -2684,7 +2688,8 @@ int				/* error */
 xfs_free_extent(
 	xfs_trans_t	*tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len)	/* length of extent */
+	xfs_extlen_t	len,	/* length of extent */
+	struct xfs_owner_info	*oinfo)	/* extent owner */
 {
 	xfs_alloc_arg_t	args;
 	int		error;
@@ -2720,7 +2725,8 @@ xfs_free_extent(
 		goto error0;
 	}
 
-	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
+	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno,
+				   len, oinfo, 0);
 	if (!error)
 		xfs_extent_busy_insert(tp, args.agno, args.agbno, len, 0);
 error0:
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d260916..6d0f328 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -123,6 +123,7 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
+	struct xfs_owner_info	oinfo;		/* owner of blocks being allocated */
 } xfs_alloc_arg_t;
 
 /*
@@ -210,7 +211,8 @@ int				/* error */
 xfs_free_extent(
 	struct xfs_trans *tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len);	/* length of extent */
+	xfs_extlen_t	len,	/* length of extent */
+	struct xfs_owner_info	*oinfo);	/* extent owner */
 
 int					/* error */
 xfs_alloc_lookup_le(
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7aef8d8..59d4fd1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -576,7 +576,8 @@ xfs_bmap_add_free(
 	struct xfs_mount	*mp,		/* mount point structure */
 	struct xfs_bmap_free	*flist,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
-	xfs_filblks_t		len)		/* length of extent */
+	xfs_filblks_t		len,		/* length of extent */
+	struct xfs_owner_info	*oinfo)		/* extent owner */
 {
 	xfs_bmap_free_item_t	*cur;		/* current (next) element */
 	xfs_bmap_free_item_t	*new;		/* new element */
@@ -597,9 +598,14 @@ xfs_bmap_add_free(
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
 	for (prev = NULL, cur = flist->xbf_first;
 	     cur != NULL;
 	     prev = cur, cur = cur->xbfi_next) {
@@ -679,6 +685,7 @@ xfs_bmap_btree_to_extents(
 	xfs_mount_t		*mp;	/* mount point structure */
 	__be64			*pp;	/* ptr to block address */
 	struct xfs_btree_block	*rblock;/* root btree block */
+	struct xfs_owner_info	oinfo;
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -702,7 +709,8 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1);
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -783,6 +791,7 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
 	args.firstblock = *firstblock;
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
@@ -929,6 +938,7 @@ xfs_bmap_local_to_extents(
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
@@ -5017,7 +5028,7 @@ xfs_bmap_del_extent(
 	 */
 	if (do_fx)
 		xfs_bmap_add_free(mp, flist, del->br_startblock,
-			del->br_blockcount);
+				  del->br_blockcount, NULL);
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e081c76..06dbe08 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -66,6 +66,7 @@ typedef struct xfs_bmap_free_item
 {
 	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
 	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
+	struct xfs_owner_info	xbfi_oinfo;	/* extent owner */
 	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
 } xfs_bmap_free_item_t;
 
@@ -192,7 +193,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
-			  xfs_fsblock_t bno, xfs_filblks_t len);
+			  xfs_fsblock_t bno, xfs_filblks_t len,
+			  struct xfs_owner_info *oinfo);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 			struct xfs_inode *ip);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index db0c71e..e247b02 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -446,6 +446,8 @@ xfs_bmbt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
+			cur->bc_private.b.whichfork);
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
@@ -525,8 +527,10 @@ xfs_bmbt_free_block(
 	struct xfs_inode	*ip = cur->bc_private.b.ip;
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
 
-	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1);
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ebe0eec..232c145 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1319,6 +1319,71 @@ typedef __be32 xfs_inobt_ptr_t;
  */
 #define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
 
+/*
+ * Ownership info for an extent.  This is used to create reverse-mapping
+ * entries.
+ */
+#define XFS_RMAP_INO_ATTR_FORK	(1)
+#define XFS_RMAP_BMBT_BLOCK	(2)
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
+	oi->oi_flags = XFS_RMAP_BMBT_BLOCK;
+	if (whichfork == XFS_ATTR_FORK)
+		oi->oi_flags |= XFS_RMAP_INO_ATTR_FORK;
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
+		oi->oi_flags |= XFS_RMAP_INO_ATTR_FORK;
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e3c0af7..aa3d10e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -614,6 +614,7 @@ xfs_ialloc_ag_alloc(
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
+	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INODES);
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
@@ -1824,12 +1825,14 @@ xfs_difree_inode_chunk(
 	int		nextbit;
 	xfs_agblock_t	agbno;
 	int		contigblk;
+	struct xfs_owner_info	oinfo;
 	DECLARE_BITMAP(holemask, XFS_INOBT_HOLEMASK_BITS);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
 		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, sagbno),
-				  mp->m_ialloc_blks);
+				  mp->m_ialloc_blks, &oinfo);
 		return;
 	}
 
@@ -1873,7 +1876,7 @@ xfs_difree_inode_chunk(
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, agbno),
-				  contigblk);
+				  contigblk, &oinfo);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 89c21d7..1a7b016 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -96,6 +96,7 @@ xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
+	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INOBT);
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
@@ -125,8 +126,12 @@ xfs_inobt_free_block(
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
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a32c1dc..834639d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -149,7 +149,8 @@ xfs_bmap_finish(
 		next = free->xbfi_next;
 
 		error = xfs_trans_free_extent(*tp, efd, free->xbfi_startblock,
-					      free->xbfi_blockcount);
+					      free->xbfi_blockcount,
+					      &free->xbfi_oinfo);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 32e24ec..b4ab22c 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -439,6 +439,8 @@ xfs_growfs_data_private(
 	 * There are new blocks in the old last a.g.
 	 */
 	if (new) {
+		struct xfs_owner_info	oinfo;
+
 		/*
 		 * Change the agi length.
 		 */
@@ -466,14 +468,20 @@ xfs_growfs_data_private(
 		       be32_to_cpu(agi->agi_length));
 
 		xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
+
 		/*
 		 * Free the new space.
+		 *
+		 * XFS_RMAP_OWN_NULL is used here to tell the rmap btree that
+		 * this doesn't actually exist in the rmap btree.
 		 */
-		error = xfs_free_extent(tp, XFS_AGB_TO_FSB(mp, agno,
-			be32_to_cpu(agf->agf_length) - new), new);
-		if (error) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_NULL);
+		error = xfs_free_extent(tp,
+				XFS_AGB_TO_FSB(mp, agno,
+					be32_to_cpu(agf->agf_length) - new),
+				new, &oinfo);
+		if (error)
 			goto error0;
-		}
 	}
 
 	/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 396565f..7c9bc7c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4179,6 +4179,7 @@ xlog_recover_process_efi(
 	int			error = 0;
 	xfs_extent_t		*extp;
 	xfs_fsblock_t		startblock_fsb;
+	struct xfs_owner_info	oinfo;
 
 	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
 
@@ -4211,10 +4212,12 @@ xlog_recover_process_efi(
 		goto abort_error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_UNKNOWN);
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &(efip->efi_format.efi_extents[i]);
 		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
-					      extp->ext_len);
+					      extp->ext_len,
+					      &oinfo);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index e7c49cf..d49dfef 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -221,7 +221,7 @@ struct xfs_efd_log_item	*xfs_trans_get_efd(xfs_trans_t *,
 				  uint);
 int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
-				      xfs_extlen_t);
+				      xfs_extlen_t, struct xfs_owner_info *);
 int		xfs_trans_commit(struct xfs_trans *);
 int		__xfs_trans_roll(struct xfs_trans **, struct xfs_inode *, int *);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index a96ae54..d1b8833 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -118,13 +118,14 @@ xfs_trans_free_extent(
 	struct xfs_trans	*tp,
 	struct xfs_efd_log_item	*efdp,
 	xfs_fsblock_t		start_block,
-	xfs_extlen_t		ext_len)
+	xfs_extlen_t		ext_len,
+	struct xfs_owner_info	*oinfo)
 {
 	uint			next_extent;
 	struct xfs_extent	*extp;
 	int			error;
 
-	error = xfs_free_extent(tp, start_block, ext_len);
+	error = xfs_free_extent(tp, start_block, ext_len, oinfo);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
