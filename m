Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14ECA7CD1
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:57:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE6C38F8035
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PqXABBsT50hKr7J9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:52 -0700 (PDT)
Subject: [PATCH 15/47] xfs: rework xfs_bmap_free callers to use xfs_defer_ops
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:57:43 -0700
Message-ID: <146907706357.25461.14102482091596438964.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Restructure everything that used xfs_bmap_free to use xfs_defer_ops
instead.  For now we'll just remove the old symbols and play some
cpp magic to make it work; in the next patch we'll actually rename
everything.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c       |    1 
 fs/xfs/libxfs/xfs_attr.c        |    1 
 fs/xfs/libxfs/xfs_attr_remote.c |    1 
 fs/xfs/libxfs/xfs_bmap.c        |   55 +++++------------------
 fs/xfs/libxfs/xfs_bmap.h        |   32 --------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |    5 +-
 fs/xfs/libxfs/xfs_btree.c       |    1 
 fs/xfs/libxfs/xfs_defer.h       |    7 +++
 fs/xfs/libxfs/xfs_dir2.c        |    1 
 fs/xfs/libxfs/xfs_ialloc.c      |    1 
 fs/xfs/libxfs/xfs_inode_buf.c   |    1 
 fs/xfs/libxfs/xfs_sb.c          |    1 
 fs/xfs/xfs_bmap_util.c          |   92 +--------------------------------------
 fs/xfs/xfs_bmap_util.h          |    2 -
 fs/xfs/xfs_dquot.c              |    1 
 fs/xfs/xfs_filestream.c         |    3 +
 fs/xfs/xfs_fsops.c              |    1 
 fs/xfs/xfs_inode.c              |    1 
 fs/xfs/xfs_iomap.c              |    1 
 fs/xfs/xfs_log_recover.c        |    1 
 fs/xfs/xfs_mount.c              |    1 
 fs/xfs/xfs_rtalloc.c            |    1 
 fs/xfs/xfs_symlink.c            |    1 
 fs/xfs/xfs_trace.c              |    1 
 24 files changed, 42 insertions(+), 171 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 88c26b8..5993f87 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_alloc_btree.h"
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4e126f4..79d3a30 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr_sf.h"
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a572532..93a9ce1 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -24,6 +24,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c5981f4..e090d34 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
@@ -595,41 +596,7 @@ xfs_bmap_add_free(
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
-	list_add(&new->xbfi_list, &flist->xbf_flist);
-	flist->xbf_count++;
-}
-
-/*
- * Remove the entry "free" from the free item list.  Prev points to the
- * previous entry, unless "free" is the head of the list.
- */
-void
-xfs_bmap_del_free(
-	struct xfs_bmap_free		*flist,	/* free item list header */
-	struct xfs_bmap_free_item	*free)	/* list item to be freed */
-{
-	list_del(&free->xbfi_list);
-	flist->xbf_count--;
-	kmem_zone_free(xfs_bmap_free_item_zone, free);
-}
-
-/*
- * Free up any items left in the list.
- */
-void
-xfs_bmap_cancel(
-	struct xfs_bmap_free		*flist)	/* list of bmap_free_items */
-{
-	struct xfs_bmap_free_item	*free;	/* free list item */
-
-	if (flist->xbf_count == 0)
-		return;
-	while (!list_empty(&flist->xbf_flist)) {
-		free = list_first_entry(&flist->xbf_flist,
-				struct xfs_bmap_free_item, xbfi_list);
-		xfs_bmap_del_free(flist, free);
-	}
-	ASSERT(flist->xbf_count == 0);
+	xfs_defer_add(flist, XFS_DEFER_OPS_TYPE_FREE, &new->xbfi_list);
 }
 
 /*
@@ -767,7 +734,7 @@ xfs_bmap_extents_to_btree(
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
-	} else if (flist->xbf_low) {
+	} else if (flist->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = *firstblock;
 	} else {
@@ -788,7 +755,7 @@ xfs_bmap_extents_to_btree(
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(*firstblock == NULLFSBLOCK ||
 	       args.agno == XFS_FSB_TO_AGNO(mp, *firstblock) ||
-	       (flist->xbf_low &&
+	       (flist->dop_low &&
 		args.agno > XFS_FSB_TO_AGNO(mp, *firstblock)));
 	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
@@ -3708,7 +3675,7 @@ xfs_bmap_btalloc(
 			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
 		if (error)
 			return error;
-	} else if (ap->flist->xbf_low) {
+	} else if (ap->flist->dop_low) {
 		if (xfs_inode_is_filestream(ap->ip))
 			args.type = XFS_ALLOCTYPE_FIRST_AG;
 		else
@@ -3741,7 +3708,7 @@ xfs_bmap_btalloc(
 	 * is >= the stripe unit and the allocation offset is
 	 * at the end of file.
 	 */
-	if (!ap->flist->xbf_low && ap->aeof) {
+	if (!ap->flist->dop_low && ap->aeof) {
 		if (!ap->offset) {
 			args.alignment = stripe_align;
 			atype = args.type;
@@ -3834,7 +3801,7 @@ xfs_bmap_btalloc(
 		args.minleft = 0;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
-		ap->flist->xbf_low = 1;
+		ap->flist->dop_low = true;
 	}
 	if (args.fsbno != NULLFSBLOCK) {
 		/*
@@ -3844,7 +3811,7 @@ xfs_bmap_btalloc(
 		ASSERT(*ap->firstblock == NULLFSBLOCK ||
 		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) ==
 		       XFS_FSB_TO_AGNO(mp, args.fsbno) ||
-		       (ap->flist->xbf_low &&
+		       (ap->flist->dop_low &&
 			XFS_FSB_TO_AGNO(mp, *ap->firstblock) <
 			XFS_FSB_TO_AGNO(mp, args.fsbno)));
 
@@ -3852,7 +3819,7 @@ xfs_bmap_btalloc(
 		if (*ap->firstblock == NULLFSBLOCK)
 			*ap->firstblock = args.fsbno;
 		ASSERT(nullfb || fb_agno == args.agno ||
-		       (ap->flist->xbf_low && fb_agno < args.agno));
+		       (ap->flist->dop_low && fb_agno < args.agno));
 		ap->length = args.len;
 		ap->ip->i_d.di_nblocks += args.len;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
@@ -4319,7 +4286,7 @@ xfs_bmapi_allocate(
 	if (error)
 		return error;
 
-	if (bma->flist->xbf_low)
+	if (bma->flist->dop_low)
 		bma->minleft = 0;
 	if (bma->cur)
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
@@ -4684,7 +4651,7 @@ error0:
 			       XFS_FSB_TO_AGNO(mp, *firstblock) ==
 			       XFS_FSB_TO_AGNO(mp,
 				       bma.cur->bc_private.b.firstblock) ||
-			       (flist->xbf_low &&
+			       (flist->dop_low &&
 				XFS_FSB_TO_AGNO(mp, *firstblock) <
 				XFS_FSB_TO_AGNO(mp,
 					bma.cur->bc_private.b.firstblock)));
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f1f3ae6..891b728 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -69,27 +69,6 @@ struct xfs_bmap_free_item
 	struct list_head	xbfi_list;
 };
 
-/*
- * Header for free extent list.
- *
- * xbf_low is used by the allocator to activate the lowspace algorithm -
- * when free space is running low the extent allocator may choose to
- * allocate an extent from an AG without leaving sufficient space for
- * a btree split when inserting the new extent.  In this case the allocator
- * will enable the lowspace algorithm which is supposed to allow further
- * allocations (such as btree splits and newroots) to allocate from
- * sequential AGs.  In order to avoid locking AGs out of order the lowspace
- * algorithm will start searching for free space from AG 0.  If the correct
- * transaction reservations have been made then this algorithm will eventually
- * find all the space it needs.
- */
-typedef	struct xfs_bmap_free
-{
-	struct list_head	xbf_flist;	/* list of to-be-free extents */
-	int			xbf_count;	/* count of items on list */
-	int			xbf_low;	/* alloc in low mode */
-} xfs_bmap_free_t;
-
 #define	XFS_BMAP_MAX_NMAP	4
 
 /*
@@ -139,14 +118,6 @@ static inline int xfs_bmapi_aflag(int w)
 #define	DELAYSTARTBLOCK		((xfs_fsblock_t)-1LL)
 #define	HOLESTARTBLOCK		((xfs_fsblock_t)-2LL)
 
-static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
-{
-	INIT_LIST_HEAD(&flp->xbf_flist);
-	flp->xbf_count = 0;
-	flp->xbf_low = 0;
-	*fbp = NULLFSBLOCK;
-}
-
 /*
  * Flags for xfs_bmap_add_extent*.
  */
@@ -195,9 +166,6 @@ int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
 			  xfs_fsblock_t bno, xfs_filblks_t len);
-void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
-int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
-			struct xfs_inode *ip);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 4f1a98e..1b7ba73 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
@@ -462,7 +463,7 @@ xfs_bmbt_alloc_block(
 		 * block allocation here and corrupt the filesystem.
 		 */
 		args.minleft = args.tp->t_blk_res;
-	} else if (cur->bc_private.b.flist->xbf_low) {
+	} else if (cur->bc_private.b.flist->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -490,7 +491,7 @@ xfs_bmbt_alloc_block(
 		error = xfs_alloc_vextent(&args);
 		if (error)
 			goto error0;
-		cur->bc_private.b.flist->xbf_low = 1;
+		cur->bc_private.b.flist->dop_low = true;
 	}
 	if (args.fsbno == NULLFSBLOCK) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6e716f4..5c4d221 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index b9b5a92..8d25086 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -93,4 +93,11 @@ struct xfs_defer_op_type {
 
 void xfs_defer_init_op_type(const struct xfs_defer_op_type *type);
 
+/* XXX: compatibility shims, will go away in the next patch */
+#define xfs_bmap_finish		xfs_defer_finish
+#define xfs_bmap_cancel		xfs_defer_cancel
+#define xfs_bmap_init		xfs_defer_init
+#define xfs_bmap_free		xfs_defer_ops
+typedef struct xfs_defer_ops	xfs_bmap_free_t;
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index af0f9d1..945c0345 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -21,6 +21,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4b1e408..c654310 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 9d9559e..4b9769e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -22,6 +22,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_error.h"
 #include "xfs_cksum.h"
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 12ca867..2194e5d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 998c3e6..d3c3d46 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -25,6 +25,7 @@
 #include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
@@ -79,95 +80,6 @@ xfs_zero_extent(
 		GFP_NOFS, true);
 }
 
-/* Sort bmap items by AG. */
-static int
-xfs_bmap_free_list_cmp(
-	void			*priv,
-	struct list_head	*a,
-	struct list_head	*b)
-{
-	struct xfs_mount	*mp = priv;
-	struct xfs_bmap_free_item	*ra;
-	struct xfs_bmap_free_item	*rb;
-
-	ra = container_of(a, struct xfs_bmap_free_item, xbfi_list);
-	rb = container_of(b, struct xfs_bmap_free_item, xbfi_list);
-	return  XFS_FSB_TO_AGNO(mp, ra->xbfi_startblock) -
-		XFS_FSB_TO_AGNO(mp, rb->xbfi_startblock);
-}
-
-/*
- * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
- * caller.  Frees all the extents that need freeing, which must be done
- * last due to locking considerations.  We never free any extents in
- * the first transaction.
- *
- * If an inode *ip is provided, rejoin it to the transaction if
- * the transaction was committed.
- */
-int						/* error */
-xfs_bmap_finish(
-	struct xfs_trans		**tp,	/* transaction pointer addr */
-	struct xfs_bmap_free		*flist,	/* i/o: list extents to free */
-	struct xfs_inode		*ip)
-{
-	struct xfs_efd_log_item		*efd;	/* extent free data */
-	struct xfs_efi_log_item		*efi;	/* extent free intention */
-	int				error;	/* error return value */
-	int				committed;/* xact committed or not */
-	struct xfs_bmap_free_item	*free;	/* free extent item */
-
-	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
-	if (flist->xbf_count == 0)
-		return 0;
-
-	list_sort((*tp)->t_mountp, &flist->xbf_flist, xfs_bmap_free_list_cmp);
-
-	efi = xfs_trans_get_efi(*tp, flist->xbf_count);
-	list_for_each_entry(free, &flist->xbf_flist, xbfi_list)
-		xfs_trans_log_efi_extent(*tp, efi, free->xbfi_startblock,
-			free->xbfi_blockcount);
-
-	error = __xfs_trans_roll(tp, ip, &committed);
-	if (error) {
-		/*
-		 * If the transaction was committed, drop the EFD reference
-		 * since we're bailing out of here. The other reference is
-		 * dropped when the EFI hits the AIL.
-		 *
-		 * If the transaction was not committed, the EFI is freed by the
-		 * EFI item unlock handler on abort. Also, we have a new
-		 * transaction so we should return committed=1 even though we're
-		 * returning an error.
-		 */
-		if (committed) {
-			xfs_efi_release(efi);
-			xfs_force_shutdown((*tp)->t_mountp,
-					   SHUTDOWN_META_IO_ERROR);
-		}
-		return error;
-	}
-
-	/*
-	 * Get an EFD and free each extent in the list, logging to the EFD in
-	 * the process. The remaining bmap free list is cleaned up by the caller
-	 * on error.
-	 */
-	efd = xfs_trans_get_efd(*tp, efi, flist->xbf_count);
-	while (!list_empty(&flist->xbf_flist)) {
-		free = list_first_entry(&flist->xbf_flist,
-				struct xfs_bmap_free_item, xbfi_list);
-		error = xfs_trans_free_extent(*tp, efd, free->xbfi_startblock,
-					      free->xbfi_blockcount);
-		if (error)
-			return error;
-
-		xfs_bmap_del_free(flist, free);
-	}
-
-	return 0;
-}
-
 int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -815,7 +727,7 @@ xfs_bmap_punch_delalloc_range(
 		if (error)
 			break;
 
-		ASSERT(!flist.xbf_count && list_empty(&flist.xbf_flist));
+		ASSERT(!xfs_defer_has_unfinished_work(&flist));
 next_block:
 		start_fsb++;
 		remaining--;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index f200714..51aadde 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -40,8 +40,6 @@ int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
 		xfs_bmap_format_t formatter, void *arg);
 
 /* functions in xfs_bmap.c that are only needed by xfs_bmap_util.c */
-void	xfs_bmap_del_free(struct xfs_bmap_free *flist,
-			  struct xfs_bmap_free_item *free);
 int	xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
 			       struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
 			       int rt, int eof, int delay, int convert,
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e064665..be17f0a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index a51353a..3e990fb 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -22,6 +22,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
@@ -385,7 +386,7 @@ xfs_filestream_new_ag(
 	}
 
 	flags = (ap->userdata ? XFS_PICK_USERDATA : 0) |
-	        (ap->flist->xbf_low ? XFS_PICK_LOWSPACE : 0);
+	        (ap->flist->dop_low ? XFS_PICK_LOWSPACE : 0);
 
 	err = xfs_filestream_pick_ag(pip, startag, agp, flags, minlen);
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7191c38..4c191d2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8825bcf..d2389bb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -25,6 +25,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 620fc91..023a4b4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -23,6 +23,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8359978..080b54b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 970c19b..5f3ba88 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3938b37..627f7e6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 08a46c6..20af47b 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -26,6 +26,7 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_defer.h"
 #include "xfs_dir2.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 3971527..7f17ae6 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -24,6 +24,7 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_da_format.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_da_btree.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
