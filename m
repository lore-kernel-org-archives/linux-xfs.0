Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7CEB17F6C
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:57:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EDEE7AC006
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:40 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yAE3gbdpBoUwnQiW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:37 -0800 (PST)
Subject: [PATCH 10/76] xfs: add extended owner field to extent allocation
	and freeing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:57:29 -0800
Message-ID: <20151219085729.12713.56343.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Extend the owner field to include both the owner type and some sort
of index within the owner.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c        |   11 +++++----
 fs/xfs/libxfs/xfs_alloc.h        |    4 ++-
 fs/xfs/libxfs/xfs_bmap.c         |   20 +++++++++-------
 fs/xfs/libxfs/xfs_bmap.h         |    5 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c   |    7 ++++-
 fs/xfs/libxfs/xfs_format.h       |   49 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c       |    8 ++++--
 fs/xfs/libxfs/xfs_ialloc_btree.c |    6 +++--
 fs/xfs/xfs_bmap_util.c           |    2 +-
 fs/xfs/xfs_fsops.c               |    5 +++-
 fs/xfs/xfs_log_recover.c         |    4 ++-
 fs/xfs/xfs_trans.h               |    2 +-
 fs/xfs/xfs_trans_extfree.c       |    4 ++-
 13 files changed, 97 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e3d25a6..1fc3d28 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1594,7 +1594,7 @@ xfs_free_ag_extent(
 	xfs_agnumber_t	agno,	/* allocation group number */
 	xfs_agblock_t	bno,	/* starting block number */
 	xfs_extlen_t	len,	/* length of extent */
-	uint64_t	owner,	/* extent owner */
+	struct xfs_owner_info	*oinfo,	/* extent owner */
 	int		isfl)	/* set if is freelist blocks - no sb acctg */
 {
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
@@ -2015,6 +2015,7 @@ xfs_alloc_fix_freelist(
 	 * back on the free list? Maybe we should only do this when space is
 	 * getting low or the AGFL is more than half full?
 	 */
+	XFS_RMAP_AG_OWNER(&targs.oinfo, XFS_RMAP_OWN_AG);
 	while (pag->pagf_flcount > need) {
 		struct xfs_buf	*bp;
 
@@ -2022,7 +2023,7 @@ xfs_alloc_fix_freelist(
 		if (error)
 			goto out_agbp_relse;
 		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
-					   XFS_RMAP_OWN_AG, 1);
+					   &targs.oinfo, 1);
 		if (error)
 			goto out_agbp_relse;
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
@@ -2032,7 +2033,7 @@ xfs_alloc_fix_freelist(
 	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
-	targs.owner = XFS_RMAP_OWN_AG;
+	XFS_RMAP_AG_OWNER(&targs.oinfo, XFS_RMAP_OWN_AG);
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
@@ -2686,7 +2687,7 @@ xfs_free_extent(
 	xfs_trans_t	*tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len,	/* length of extent */
-	uint64_t	owner)	/* extent owner */
+	struct xfs_owner_info	*oinfo)	/* extent owner */
 {
 	xfs_alloc_arg_t	args;
 	int		error;
@@ -2723,7 +2724,7 @@ xfs_free_extent(
 	}
 
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno,
-				   len, owner, 0);
+				   len, oinfo, 0);
 	if (!error)
 		xfs_extent_busy_insert(tp, args.agno, args.agbno, len, 0);
 error0:
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index ee86f44..6d0f328 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -123,7 +123,7 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
-	uint64_t	owner;		/* owner of blocks being allocated */
+	struct xfs_owner_info	oinfo;		/* owner of blocks being allocated */
 } xfs_alloc_arg_t;
 
 /*
@@ -212,7 +212,7 @@ xfs_free_extent(
 	struct xfs_trans *tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len,	/* length of extent */
-	uint64_t	owner);	/* extent owner */
+	struct xfs_owner_info	*oinfo);	/* extent owner */
 
 int					/* error */
 xfs_alloc_lookup_le(
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6944157..9183602 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -555,7 +555,7 @@ xfs_bmap_add_free(
 	struct xfs_bmap_free	*flist,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
 	xfs_filblks_t		len,		/* length of extent */
-	uint64_t		owner)		/* extent owner */
+	struct xfs_owner_info	*oinfo)		/* extent owner */
 {
 	xfs_bmap_free_item_t	*cur;		/* current (next) element */
 	xfs_bmap_free_item_t	*new;		/* new element */
@@ -576,12 +576,14 @@ xfs_bmap_add_free(
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
 	ASSERT(xfs_bmap_free_item_zone != NULL);
-	ASSERT(owner);
 
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
-	new->xbfi_owner = owner;
+	if (oinfo)
+		memcpy(&new->xbfi_oinfo, oinfo, sizeof(struct xfs_owner_info));
+	else
+		memset(&new->xbfi_oinfo, 0, sizeof(struct xfs_owner_info));
 	for (prev = NULL, cur = flist->xbf_first;
 	     cur != NULL;
 	     prev = cur, cur = cur->xbfi_next) {
@@ -661,6 +663,7 @@ xfs_bmap_btree_to_extents(
 	xfs_mount_t		*mp;	/* mount point structure */
 	__be64			*pp;	/* ptr to block address */
 	struct xfs_btree_block	*rblock;/* root btree block */
+	struct xfs_owner_info	oinfo;
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -684,7 +687,8 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1, ip->i_ino);
+	XFS_RMAP_INO_BMBT_OWNER(&oinfo, ip->i_ino, whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -765,7 +769,7 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
-	args.owner = ip->i_ino;
+	XFS_RMAP_INO_BMBT_OWNER(&args.oinfo, ip->i_ino, whichfork);
 	args.firstblock = *firstblock;
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
@@ -912,7 +916,7 @@ xfs_bmap_local_to_extents(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
-	args.owner = ip->i_ino;
+	XFS_RMAP_INO_OWNER(&args.oinfo, ip->i_ino, whichfork, 0);
 	args.firstblock = *firstblock;
 	/*
 	 * Allocate a block.  We know we need only one, since the
@@ -3696,7 +3700,6 @@ xfs_bmap_btalloc(
 	memset(&args, 0, sizeof(args));
 	args.tp = ap->tp;
 	args.mp = mp;
-	args.owner = ap->ip->i_ino;
 	args.fsbno = ap->blkno;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
@@ -4817,6 +4820,7 @@ xfs_bmap_del_extent(
 		nblks = 0;
 		do_fx = 0;
 	}
+
 	/*
 	 * Set flag value to use in switch statement.
 	 * Left-contig is 2, right-contig is 1.
@@ -5003,7 +5007,7 @@ xfs_bmap_del_extent(
 	 */
 	if (do_fx)
 		xfs_bmap_add_free(mp, flist, del->br_startblock,
-				  del->br_blockcount, ip->i_ino);
+				  del->br_blockcount, NULL);
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 1f8eb6e..e7cd789 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -66,7 +66,7 @@ typedef struct xfs_bmap_free_item
 {
 	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
 	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
-	uint64_t		xbfi_owner;	/* extent owner */
+	struct xfs_owner_info	xbfi_oinfo;	/* extent owner */
 	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
 } xfs_bmap_free_item_t;
 
@@ -193,7 +193,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
-			  xfs_fsblock_t bno, xfs_filblks_t len, uint64_t owner);
+			  xfs_fsblock_t bno, xfs_filblks_t len,
+			  struct xfs_owner_info *oinfo);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 			int *committed);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 45b994b..789eb48 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -446,7 +446,8 @@ xfs_bmbt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
-	args.owner = cur->bc_private.b.ip->i_ino;
+	XFS_RMAP_INO_BMBT_OWNER(&args.oinfo, cur->bc_private.b.ip->i_ino,
+			cur->bc_private.b.whichfork);
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
@@ -526,8 +527,10 @@ xfs_bmbt_free_block(
 	struct xfs_inode	*ip = cur->bc_private.b.ip;
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
 
-	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1, ip->i_ino);
+	XFS_RMAP_INO_BMBT_OWNER(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index cb30f8b..a751ee6 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1313,6 +1313,55 @@ typedef __be32 xfs_inobt_ptr_t;
 #define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
 
 /*
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
+XFS_RMAP_AG_OWNER(
+	struct xfs_owner_info	*oi,
+	uint64_t		owner)
+{
+	oi->oi_owner = owner;
+	oi->oi_offset = 0;
+	oi->oi_flags = 0;
+}
+
+static inline void
+XFS_RMAP_INO_BMBT_OWNER(
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
+XFS_RMAP_INO_OWNER(
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
  * Special owner types.
  *
  * Seeing as we only support up to 8EB, we have the upper bit of the owner field
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7609f8c..0b8f748 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -614,7 +614,7 @@ xfs_ialloc_ag_alloc(
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
-	args.owner = XFS_RMAP_OWN_INODES;
+	XFS_RMAP_AG_OWNER(&args.oinfo, XFS_RMAP_OWN_INODES);
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
@@ -1825,12 +1825,14 @@ xfs_difree_inode_chunk(
 	int		nextbit;
 	xfs_agblock_t	agbno;
 	int		contigblk;
+	struct xfs_owner_info	oinfo;
 	DECLARE_BITMAP(holemask, XFS_INOBT_HOLEMASK_BITS);
+	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_INODES);
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
 		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, sagbno),
-				  mp->m_ialloc_blks, XFS_RMAP_OWN_INODES);
+				  mp->m_ialloc_blks, &oinfo);
 		return;
 	}
 
@@ -1874,7 +1876,7 @@ xfs_difree_inode_chunk(
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, agbno),
-				  contigblk, XFS_RMAP_OWN_INODES);
+				  contigblk, &oinfo);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 445245f..bd8a1da 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -96,7 +96,7 @@ xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	args.owner = XFS_RMAP_OWN_INOBT;
+	XFS_RMAP_AG_OWNER(&args.oinfo, XFS_RMAP_OWN_INOBT);
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
@@ -128,9 +128,11 @@ xfs_inobt_free_block(
 {
 	xfs_fsblock_t		fsbno;
 	int			error;
+	struct xfs_owner_info	oinfo;
 
+	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_INOBT);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp));
-	error = xfs_free_extent(cur->bc_tp, fsbno, 1, XFS_RMAP_OWN_INOBT);
+	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &oinfo);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b447b09..0543779 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -152,7 +152,7 @@ xfs_bmap_finish(
 
 		error = xfs_trans_free_extent(*tp, efd, free->xbfi_startblock,
 					      free->xbfi_blockcount,
-					      free->xbfi_owner);
+					      &free->xbfi_oinfo);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5711700..b3d1665 100644
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
@@ -473,10 +475,11 @@ xfs_growfs_data_private(
 		 * XFS_RMAP_OWN_NULL is used here to tell the rmap btree that
 		 * this doesn't actually exist in the rmap btree.
 		 */
+		XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_NULL);
 		error = xfs_free_extent(tp,
 				XFS_AGB_TO_FSB(mp, agno,
 					be32_to_cpu(agf->agf_length) - new),
-				new, XFS_RMAP_OWN_NULL);
+				new, &oinfo);
 		if (error)
 			goto error0;
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b0a1f62..c3abf50 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3786,6 +3786,7 @@ xlog_recover_process_efi(
 	int			error = 0;
 	xfs_extent_t		*extp;
 	xfs_fsblock_t		startblock_fsb;
+	struct xfs_owner_info	oinfo;
 
 	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
 
@@ -3818,11 +3819,12 @@ xlog_recover_process_efi(
 		goto abort_error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
+	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_UNKNOWN);
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &(efip->efi_format.efi_extents[i]);
 		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
 					      extp->ext_len,
-					      XFS_RMAP_OWN_UNKNOWN);
+					      &oinfo);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index ee277fa..50fe77e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -222,7 +222,7 @@ struct xfs_efd_log_item	*xfs_trans_get_efd(xfs_trans_t *,
 				  uint);
 int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
-				      xfs_extlen_t, uint64_t);
+				      xfs_extlen_t, struct xfs_owner_info *);
 int		xfs_trans_commit(struct xfs_trans *);
 int		__xfs_trans_roll(struct xfs_trans **, struct xfs_inode *, int *);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 1b7d6d5..d1b8833 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -119,13 +119,13 @@ xfs_trans_free_extent(
 	struct xfs_efd_log_item	*efdp,
 	xfs_fsblock_t		start_block,
 	xfs_extlen_t		ext_len,
-	uint64_t		owner)
+	struct xfs_owner_info	*oinfo)
 {
 	uint			next_extent;
 	struct xfs_extent	*extp;
 	int			error;
 
-	error = xfs_free_extent(tp, start_block, ext_len, owner);
+	error = xfs_free_extent(tp, start_block, ext_len, oinfo);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
