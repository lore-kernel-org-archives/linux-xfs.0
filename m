Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9947B7CA3
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:58:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A2F2304043
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:58:55 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4kp5rqoyqKAWSDsF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:58:50 -0700 (PDT)
Subject: [PATCH 24/47] xfs: add owner field to extent allocation and freeing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:58:43 -0700
Message-ID: <146907712344.25461.17026112310008595860.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

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

v2: When we're freeing extents from an EFI, we don't have the owner
information available (rmap updates have their own redo items).
xfs_free_extent therefore doesn't need to do an rmap update, but the
log replay code doesn't signal this correctly.  Fix it so that it
does.

[dchinner: de-shout the xfs_rmap_*_owner helpers]
[darrick: minor style fixes suggested by Christoph Hellwig]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_alloc.c        |   26 +++++++++------
 fs/xfs/libxfs/xfs_alloc.h        |    8 +++--
 fs/xfs/libxfs/xfs_bmap.c         |   25 +++++++++++---
 fs/xfs/libxfs/xfs_bmap.h         |    4 ++
 fs/xfs/libxfs/xfs_bmap_btree.c   |    7 +++-
 fs/xfs/libxfs/xfs_format.h       |   28 ++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c       |    8 +++--
 fs/xfs/libxfs/xfs_ialloc_btree.c |    8 ++++-
 fs/xfs/libxfs/xfs_rmap.h         |   67 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_extfree_item.c        |    6 +++
 fs/xfs/xfs_fsops.c               |   17 +++++++---
 fs/xfs/xfs_trans.h               |    2 +
 fs/xfs/xfs_trans_extfree.c       |    8 +++--
 13 files changed, 181 insertions(+), 33 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rmap.h


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 43c7e53..6335b8b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -36,6 +36,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_rmap.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -1589,14 +1590,15 @@ error0:
 /*
  * Free the extent starting at agno/bno for length.
  */
-STATIC int			/* error */
+STATIC int
 xfs_free_ag_extent(
-	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*agbp,	/* buffer for a.g. freelist header */
-	xfs_agnumber_t	agno,	/* allocation group number */
-	xfs_agblock_t	bno,	/* starting block number */
-	xfs_extlen_t	len,	/* length of extent */
-	int		isfl)	/* set if is freelist blocks - no sb acctg */
+	xfs_trans_t		*tp,
+	xfs_buf_t		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_owner_info	*oinfo,
+	int			isfl)
 {
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
 	xfs_btree_cur_t	*cnt_cur;	/* cursor for by-size btree */
@@ -2005,13 +2007,15 @@ xfs_alloc_fix_freelist(
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
@@ -2021,6 +2025,7 @@ xfs_alloc_fix_freelist(
 	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
+	xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
@@ -2709,7 +2714,8 @@ int				/* error */
 xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_fsblock_t		bno,	/* starting block number of extent */
-	xfs_extlen_t		len)	/* length of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	struct xfs_owner_info	*oinfo)	/* extent owner */
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*agbp;
@@ -2737,7 +2743,7 @@ xfs_free_extent(
 		agbno + len <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length),
 				err);
 
-	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, 0);
+	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, 0);
 	if (error)
 		goto err;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 20b54aa..8805342 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -123,6 +123,7 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
+	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 } xfs_alloc_arg_t;
 
 /*
@@ -208,9 +209,10 @@ xfs_alloc_vextent(
  */
 int				/* error */
 xfs_free_extent(
-	struct xfs_trans *tp,	/* transaction pointer */
-	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len);	/* length of extent */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_fsblock_t		bno,	/* starting block number of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	struct xfs_owner_info	*oinfo);/* extent owner */
 
 int				/* error */
 xfs_alloc_lookup_ge(
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8e14ff4..919069f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -46,6 +46,7 @@
 #include "xfs_symlink.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_filestream.h"
+#include "xfs_rmap.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -571,10 +572,11 @@ xfs_bmap_validate_ret(
  */
 void
 xfs_bmap_add_free(
-	struct xfs_mount	*mp,		/* mount point structure */
-	struct xfs_defer_ops	*dfops,		/* list of extents */
-	xfs_fsblock_t		bno,		/* fs block number of extent */
-	xfs_filblks_t		len)		/* length of extent */
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
+	struct xfs_owner_info		*oinfo)
 {
 	struct xfs_extent_free_item	*new;		/* new element */
 #ifdef DEBUG
@@ -593,9 +595,14 @@ xfs_bmap_add_free(
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
 	ASSERT(xfs_bmap_free_item_zone != NULL);
+
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xefi_startblock = bno;
 	new->xefi_blockcount = (xfs_extlen_t)len;
+	if (oinfo)
+		new->xefi_oinfo = *oinfo;
+	else
+		xfs_rmap_skip_owner_update(&new->xefi_oinfo);
 	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
 			XFS_FSB_TO_AGBNO(mp, bno), len);
 	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
@@ -628,6 +635,7 @@ xfs_bmap_btree_to_extents(
 	xfs_mount_t		*mp;	/* mount point structure */
 	__be64			*pp;	/* ptr to block address */
 	struct xfs_btree_block	*rblock;/* root btree block */
+	struct xfs_owner_info	oinfo;
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -651,7 +659,8 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1);
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -732,6 +741,7 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
 	args.firstblock = *firstblock;
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
@@ -878,6 +888,7 @@ xfs_bmap_local_to_extents(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
+	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
 	args.firstblock = *firstblock;
 	/*
 	 * Allocate a block.  We know we need only one, since the
@@ -3660,6 +3671,7 @@ xfs_bmap_btalloc(
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->blkno;
+	xfs_rmap_skip_owner_update(&args.oinfo);
 
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = MIN(ap->length, XFS_ALLOC_AG_MAX_USABLE(mp));
@@ -4839,6 +4851,7 @@ xfs_bmap_del_extent(
 		nblks = 0;
 		do_fx = 0;
 	}
+
 	/*
 	 * Set flag value to use in switch statement.
 	 * Left-contig is 2, right-contig is 1.
@@ -5026,7 +5039,7 @@ xfs_bmap_del_extent(
 	 */
 	if (do_fx)
 		xfs_bmap_add_free(mp, dfops, del->br_startblock,
-			del->br_blockcount);
+				del->br_blockcount, NULL);
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index dc01bb8..254034f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -67,6 +67,7 @@ struct xfs_extent_free_item
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
 	struct list_head	xefi_list;
+	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
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
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 0df5318..9e34ca4 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -35,6 +35,7 @@
 #include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_rmap.h"
 
 /*
  * Determine the extent state.
@@ -447,6 +448,8 @@ xfs_bmbt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
+			cur->bc_private.b.whichfork);
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
@@ -526,8 +529,10 @@ xfs_bmbt_free_block(
 	struct xfs_inode	*ip = cur->bc_private.b.ip;
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
 
-	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1);
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3dbed01..eecfedf 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1319,6 +1319,34 @@ typedef __be32 xfs_inobt_ptr_t;
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
index f0e1f71..51b4e0d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -40,6 +40,7 @@
 #include "xfs_icache.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_rmap.h"
 
 
 /*
@@ -615,6 +616,7 @@ xfs_ialloc_ag_alloc(
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
+	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INODES);
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
@@ -1825,12 +1827,14 @@ xfs_difree_inode_chunk(
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
 
@@ -1874,7 +1878,7 @@ xfs_difree_inode_chunk(
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, agbno),
-				  contigblk);
+				  contigblk, &oinfo);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index a48f448..c83691e 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -32,6 +32,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_trans.h"
+#include "xfs_rmap.h"
 
 
 STATIC int
@@ -96,6 +97,7 @@ xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
+	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INOBT);
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
@@ -125,8 +127,12 @@ xfs_inobt_free_block(
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
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
new file mode 100644
index 0000000..b30e7ad
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_RMAP_H__
+#define __XFS_RMAP_H__
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
+static inline void
+xfs_rmap_skip_owner_update(
+	struct xfs_owner_info	*oi)
+{
+	oi->oi_owner = XFS_RMAP_OWN_UNKNOWN;
+}
+
+#endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 042efae..d73b717 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -27,6 +27,8 @@
 #include "xfs_buf_item.h"
 #include "xfs_extfree_item.h"
 #include "xfs_log.h"
+#include "xfs_btree.h"
+#include "xfs_rmap.h"
 
 
 kmem_zone_t	*xfs_efi_zone;
@@ -501,6 +503,7 @@ xfs_efi_recover(
 	int			error = 0;
 	xfs_extent_t		*extp;
 	xfs_fsblock_t		startblock_fsb;
+	struct xfs_owner_info	oinfo;
 
 	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
 
@@ -532,10 +535,11 @@ xfs_efi_recover(
 		return error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
+	xfs_rmap_skip_owner_update(&oinfo);
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &(efip->efi_format.efi_extents[i]);
 		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
-					      extp->ext_len);
+					      extp->ext_len, &oinfo);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0a3b822..b625b61 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -41,6 +41,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_filestream.h"
+#include "xfs_rmap.h"
 
 /*
  * File system operations
@@ -436,6 +437,8 @@ xfs_growfs_data_private(
 	 * There are new blocks in the old last a.g.
 	 */
 	if (new) {
+		struct xfs_owner_info	oinfo;
+
 		/*
 		 * Change the agi length.
 		 */
@@ -463,14 +466,20 @@ xfs_growfs_data_private(
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
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 4a3721e..497c740 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -216,7 +216,7 @@ struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
 				  uint);
 int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
-				      xfs_extlen_t);
+				      xfs_extlen_t, struct xfs_owner_info *);
 int		xfs_trans_commit(struct xfs_trans *);
 int		__xfs_trans_roll(struct xfs_trans **, struct xfs_inode *, int *);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index b484902..3aca3a7 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -120,13 +120,14 @@ xfs_trans_free_extent(
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
@@ -213,7 +214,8 @@ xfs_extent_free_finish_item(
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
 	error = xfs_trans_free_extent(tp, done_item,
 			free->xefi_startblock,
-			free->xefi_blockcount);
+			free->xefi_blockcount,
+			&free->xefi_oinfo);
 	kmem_free(free);
 	return error;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
