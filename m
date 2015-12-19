Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9C747F6C
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:57:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 59BA5AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:34 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id M3uM7USiO3RX4NIA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:30 -0800 (PST)
Subject: [PATCH 09/76] xfs: add owner field to extent allocation and freeing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:57:22 -0800
Message-ID: <20151219085722.12713.52401.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

>From : Dave Chinner <dchinner@redhat.com>

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

While touching the xfs_bmap_add_free() function, re-order the
parameters to put the struct xfs_mount first.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c        |   11 ++++++++---
 fs/xfs/libxfs/xfs_alloc.h        |    4 +++-
 fs/xfs/libxfs/xfs_bmap.c         |   17 ++++++++++++-----
 fs/xfs/libxfs/xfs_bmap.h         |    5 +++--
 fs/xfs/libxfs/xfs_bmap_btree.c   |    3 ++-
 fs/xfs/libxfs/xfs_format.h       |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c       |   10 +++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c |    3 ++-
 fs/xfs/xfs_bmap_util.c           |    3 ++-
 fs/xfs/xfs_fsops.c               |   13 +++++++++----
 fs/xfs/xfs_log_recover.c         |    3 ++-
 fs/xfs/xfs_trans.h               |    2 +-
 fs/xfs/xfs_trans_extfree.c       |    5 +++--
 13 files changed, 68 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 24032ef..e3d25a6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1594,6 +1594,7 @@ xfs_free_ag_extent(
 	xfs_agnumber_t	agno,	/* allocation group number */
 	xfs_agblock_t	bno,	/* starting block number */
 	xfs_extlen_t	len,	/* length of extent */
+	uint64_t	owner,	/* extent owner */
 	int		isfl)	/* set if is freelist blocks - no sb acctg */
 {
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
@@ -2020,7 +2021,8 @@ xfs_alloc_fix_freelist(
 		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;
-		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1);
+		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
+					   XFS_RMAP_OWN_AG, 1);
 		if (error)
 			goto out_agbp_relse;
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
@@ -2030,6 +2032,7 @@ xfs_alloc_fix_freelist(
 	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
+	targs.owner = XFS_RMAP_OWN_AG;
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
@@ -2682,7 +2685,8 @@ int				/* error */
 xfs_free_extent(
 	xfs_trans_t	*tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len)	/* length of extent */
+	xfs_extlen_t	len,	/* length of extent */
+	uint64_t	owner)	/* extent owner */
 {
 	xfs_alloc_arg_t	args;
 	int		error;
@@ -2718,7 +2722,8 @@ xfs_free_extent(
 		goto error0;
 	}
 
-	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
+	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno,
+				   len, owner, 0);
 	if (!error)
 		xfs_extent_busy_insert(tp, args.agno, args.agbno, len, 0);
 error0:
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d260916..ee86f44 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -123,6 +123,7 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
+	uint64_t	owner;		/* owner of blocks being allocated */
 } xfs_alloc_arg_t;
 
 /*
@@ -210,7 +211,8 @@ int				/* error */
 xfs_free_extent(
 	struct xfs_trans *tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len);	/* length of extent */
+	xfs_extlen_t	len,	/* length of extent */
+	uint64_t	owner);	/* extent owner */
 
 int					/* error */
 xfs_alloc_lookup_le(
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 817c994..6944157 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -551,10 +551,11 @@ xfs_bmap_validate_ret(
  */
 void
 xfs_bmap_add_free(
+	struct xfs_mount	*mp,		/* mount point structure */
+	struct xfs_bmap_free	*flist,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
 	xfs_filblks_t		len,		/* length of extent */
-	xfs_bmap_free_t		*flist,		/* list of extents */
-	xfs_mount_t		*mp)		/* mount point structure */
+	uint64_t		owner)		/* extent owner */
 {
 	xfs_bmap_free_item_t	*cur;		/* current (next) element */
 	xfs_bmap_free_item_t	*new;		/* new element */
@@ -575,9 +576,12 @@ xfs_bmap_add_free(
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
 	ASSERT(xfs_bmap_free_item_zone != NULL);
+	ASSERT(owner);
+
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
+	new->xbfi_owner = owner;
 	for (prev = NULL, cur = flist->xbf_first;
 	     cur != NULL;
 	     prev = cur, cur = cur->xbfi_next) {
@@ -680,7 +684,7 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(cbno, 1, cur->bc_private.b.flist, mp);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1, ip->i_ino);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -761,6 +765,7 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
+	args.owner = ip->i_ino;
 	args.firstblock = *firstblock;
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
@@ -907,6 +912,7 @@ xfs_bmap_local_to_extents(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
+	args.owner = ip->i_ino;
 	args.firstblock = *firstblock;
 	/*
 	 * Allocate a block.  We know we need only one, since the
@@ -3690,6 +3696,7 @@ xfs_bmap_btalloc(
 	memset(&args, 0, sizeof(args));
 	args.tp = ap->tp;
 	args.mp = mp;
+	args.owner = ap->ip->i_ino;
 	args.fsbno = ap->blkno;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
@@ -4995,8 +5002,8 @@ xfs_bmap_del_extent(
 	 * If we need to, add to list of extents to delete.
 	 */
 	if (do_fx)
-		xfs_bmap_add_free(del->br_startblock, del->br_blockcount, flist,
-			mp);
+		xfs_bmap_add_free(mp, flist, del->br_startblock,
+				  del->br_blockcount, ip->i_ino);
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index a160f8a..1f8eb6e 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -66,6 +66,7 @@ typedef struct xfs_bmap_free_item
 {
 	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
 	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
+	uint64_t		xbfi_owner;	/* extent owner */
 	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
 } xfs_bmap_free_item_t;
 
@@ -191,8 +192,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
-void	xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
-		struct xfs_bmap_free *flist, struct xfs_mount *mp);
+void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
+			  xfs_fsblock_t bno, xfs_filblks_t len, uint64_t owner);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 			int *committed);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3d947d6..45b994b 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -446,6 +446,7 @@ xfs_bmbt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
+	args.owner = cur->bc_private.b.ip->i_ino;
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
@@ -526,7 +527,7 @@ xfs_bmbt_free_block(
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 
-	xfs_bmap_add_free(fsbno, 1, cur->bc_private.b.flist, mp);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1, ip->i_ino);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 28635ea..cb30f8b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1312,6 +1312,22 @@ typedef __be32 xfs_inobt_ptr_t;
  */
 #define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
 
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
index 70c1db9..7609f8c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -614,6 +614,7 @@ xfs_ialloc_ag_alloc(
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
+	args.owner = XFS_RMAP_OWN_INODES;
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
@@ -1828,9 +1829,8 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
-				  XFS_AGINO_TO_AGBNO(mp, rec->ir_startino)),
-				  mp->m_ialloc_blks, flist, mp);
+		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, sagbno),
+				  mp->m_ialloc_blks, XFS_RMAP_OWN_INODES);
 		return;
 	}
 
@@ -1873,8 +1873,8 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				  flist, mp);
+		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, agbno),
+				  contigblk, XFS_RMAP_OWN_INODES);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index f39b285..445245f 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -96,6 +96,7 @@ xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
+	args.owner = XFS_RMAP_OWN_INOBT;
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
@@ -129,7 +130,7 @@ xfs_inobt_free_block(
 	int			error;
 
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp));
-	error = xfs_free_extent(cur->bc_tp, fsbno, 1);
+	error = xfs_free_extent(cur->bc_tp, fsbno, 1, XFS_RMAP_OWN_INOBT);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dbae649..b447b09 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -151,7 +151,8 @@ xfs_bmap_finish(
 		next = free->xbfi_next;
 
 		error = xfs_trans_free_extent(*tp, efd, free->xbfi_startblock,
-					      free->xbfi_blockcount);
+					      free->xbfi_blockcount,
+					      free->xbfi_owner);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 32e24ec..5711700 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -466,14 +466,19 @@ xfs_growfs_data_private(
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
+		error = xfs_free_extent(tp,
+				XFS_AGB_TO_FSB(mp, agno,
+					be32_to_cpu(agf->agf_length) - new),
+				new, XFS_RMAP_OWN_NULL);
+		if (error)
 			goto error0;
-		}
 	}
 
 	/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c5ecaac..b0a1f62 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3821,7 +3821,8 @@ xlog_recover_process_efi(
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &(efip->efi_format.efi_extents[i]);
 		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
-					      extp->ext_len);
+					      extp->ext_len,
+					      XFS_RMAP_OWN_UNKNOWN);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 4643070..ee277fa 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -222,7 +222,7 @@ struct xfs_efd_log_item	*xfs_trans_get_efd(xfs_trans_t *,
 				  uint);
 int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
-				      xfs_extlen_t);
+				      xfs_extlen_t, uint64_t);
 int		xfs_trans_commit(struct xfs_trans *);
 int		__xfs_trans_roll(struct xfs_trans **, struct xfs_inode *, int *);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index a96ae54..1b7d6d5 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -118,13 +118,14 @@ xfs_trans_free_extent(
 	struct xfs_trans	*tp,
 	struct xfs_efd_log_item	*efdp,
 	xfs_fsblock_t		start_block,
-	xfs_extlen_t		ext_len)
+	xfs_extlen_t		ext_len,
+	uint64_t		owner)
 {
 	uint			next_extent;
 	struct xfs_extent	*extp;
 	int			error;
 
-	error = xfs_free_extent(tp, start_block, ext_len);
+	error = xfs_free_extent(tp, start_block, ext_len, owner);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
