Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B273180D7
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:33:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 75DA78F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:15 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Vqf31AyYTskyz6r1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:12 -0700 (PDT)
Subject: [PATCH 023/145] xfs: rework xfs_bmap_free callers to use xfs_defer_ops
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:33:08 -0700
Message-ID: <146612718828.16048.16763151461118598547.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Rework everything that used xfs_bmap_free to use xfs_defer_ops
instead.  For now we'll just remove the old symbols and play some
cpp magic to make it work; in the next patch we'll actually rename
everything.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h         |    5 +++-
 libxfs/libxfs_api_defs.h |    2 --
 libxfs/util.c            |   25 +--------------------
 libxfs/xfs_alloc.c       |    1 +
 libxfs/xfs_attr.c        |    1 +
 libxfs/xfs_attr_remote.c |    1 +
 libxfs/xfs_bmap.c        |   55 +++++++++-------------------------------------
 libxfs/xfs_bmap.h        |   32 ---------------------------
 libxfs/xfs_bmap_btree.c  |    5 +++-
 libxfs/xfs_btree.c       |    1 +
 libxfs/xfs_defer.h       |    7 ++++++
 libxfs/xfs_dir2.c        |    1 +
 libxfs/xfs_ialloc.c      |    1 +
 libxfs/xfs_inode_buf.c   |    1 +
 libxfs/xfs_sb.c          |    1 +
 15 files changed, 34 insertions(+), 105 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index a34a3a9..71e758b 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -60,6 +60,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
@@ -163,7 +164,9 @@ extern unsigned int	libxfs_log2_roundup(unsigned int i);
 
 extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
 				xfs_off_t, int, int);
-extern int	libxfs_bmap_finish(xfs_trans_t **, xfs_bmap_free_t *, struct xfs_inode *);
+#define libxfs_bmap_finish	xfs_defer_finish
+#define libxfs_bmap_cancel	xfs_defer_cancel
+#define xfs_bmap_free_t		struct xfs_defer_ops
 
 extern void 	libxfs_fs_repair_cmn_err(int, struct xfs_mount *, char *, ...);
 extern void	libxfs_fs_cmn_err(int, struct xfs_mount *, char *, ...);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 611a849..84b86bc 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -63,10 +63,8 @@
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 
 #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
-#define xfs_bmap_cancel			libxfs_bmap_cancel
 #define xfs_bmap_last_offset		libxfs_bmap_last_offset
 #define xfs_bmap_search_extents		libxfs_bmap_search_extents
-#define xfs_bmap_finish			libxfs_bmap_finish
 #define xfs_bmapi_write			libxfs_bmapi_write
 #define xfs_bmapi_read			libxfs_bmapi_read
 #define xfs_bunmapi			libxfs_bunmapi
diff --git a/libxfs/util.c b/libxfs/util.c
index f37b396..ab007b0 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -25,6 +25,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
@@ -474,30 +475,6 @@ libxfs_mod_incore_sb(
 	}
 }
 
-int
-libxfs_bmap_finish(
-	struct xfs_trans	**tp,
-	struct xfs_bmap_free	*flist,
-	struct xfs_inode	*ip)
-{
-	struct xfs_bmap_free_item	*free;	/* free extent list item */
-	int			error;
-
-	if (flist->xbf_count == 0)
-		return 0;
-
-	while (!list_empty(&flist->xbf_flist)) {
-		free = list_first_entry(&flist->xbf_flist,
-				struct xfs_bmap_free_item, xbfi_list);
-		error = xfs_free_extent(*tp, free->xbfi_startblock,
-					free->xbfi_blockcount);
-		if (error)
-			return error;
-		xfs_bmap_del_free(flist, free);
-	}
-	return 0;
-}
-
 /*
  * This routine allocates disk space for the given file.
  * Originally derived from xfs_alloc_file_space().
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 7276419..8454816 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_alloc_btree.h"
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0b05654..ee370dc 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr_sf.h"
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 79d663e..ed4cc94 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -24,6 +24,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 65de5ad..a2d8268 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
@@ -587,41 +588,7 @@ xfs_bmap_add_free(
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
@@ -759,7 +726,7 @@ xfs_bmap_extents_to_btree(
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
-	} else if (flist->xbf_low) {
+	} else if (flist->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = *firstblock;
 	} else {
@@ -780,7 +747,7 @@ xfs_bmap_extents_to_btree(
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(*firstblock == NULLFSBLOCK ||
 	       args.agno == XFS_FSB_TO_AGNO(mp, *firstblock) ||
-	       (flist->xbf_low &&
+	       (flist->dop_low &&
 		args.agno > XFS_FSB_TO_AGNO(mp, *firstblock)));
 	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
@@ -3700,7 +3667,7 @@ xfs_bmap_btalloc(
 			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
 		if (error)
 			return error;
-	} else if (ap->flist->xbf_low) {
+	} else if (ap->flist->dop_low) {
 		if (xfs_inode_is_filestream(ap->ip))
 			args.type = XFS_ALLOCTYPE_FIRST_AG;
 		else
@@ -3733,7 +3700,7 @@ xfs_bmap_btalloc(
 	 * is >= the stripe unit and the allocation offset is
 	 * at the end of file.
 	 */
-	if (!ap->flist->xbf_low && ap->aeof) {
+	if (!ap->flist->dop_low && ap->aeof) {
 		if (!ap->offset) {
 			args.alignment = stripe_align;
 			atype = args.type;
@@ -3826,7 +3793,7 @@ xfs_bmap_btalloc(
 		args.minleft = 0;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
-		ap->flist->xbf_low = 1;
+		ap->flist->dop_low = true;
 	}
 	if (args.fsbno != NULLFSBLOCK) {
 		/*
@@ -3836,7 +3803,7 @@ xfs_bmap_btalloc(
 		ASSERT(*ap->firstblock == NULLFSBLOCK ||
 		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) ==
 		       XFS_FSB_TO_AGNO(mp, args.fsbno) ||
-		       (ap->flist->xbf_low &&
+		       (ap->flist->dop_low &&
 			XFS_FSB_TO_AGNO(mp, *ap->firstblock) <
 			XFS_FSB_TO_AGNO(mp, args.fsbno)));
 
@@ -3844,7 +3811,7 @@ xfs_bmap_btalloc(
 		if (*ap->firstblock == NULLFSBLOCK)
 			*ap->firstblock = args.fsbno;
 		ASSERT(nullfb || fb_agno == args.agno ||
-		       (ap->flist->xbf_low && fb_agno < args.agno));
+		       (ap->flist->dop_low && fb_agno < args.agno));
 		ap->length = args.len;
 		ap->ip->i_d.di_nblocks += args.len;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
@@ -4311,7 +4278,7 @@ xfs_bmapi_allocate(
 	if (error)
 		return error;
 
-	if (bma->flist->xbf_low)
+	if (bma->flist->dop_low)
 		bma->minleft = 0;
 	if (bma->cur)
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
@@ -4676,7 +4643,7 @@ error0:
 			       XFS_FSB_TO_AGNO(mp, *firstblock) ==
 			       XFS_FSB_TO_AGNO(mp,
 				       bma.cur->bc_private.b.firstblock) ||
-			       (flist->xbf_low &&
+			       (flist->dop_low &&
 				XFS_FSB_TO_AGNO(mp, *firstblock) <
 				XFS_FSB_TO_AGNO(mp,
 					bma.cur->bc_private.b.firstblock)));
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index c165b2d..9a74610 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
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
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 2ae701e..8d4d4b0 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
@@ -459,7 +460,7 @@ xfs_bmbt_alloc_block(
 		 * block allocation here and corrupt the filesystem.
 		 */
 		args.minleft = args.tp->t_blk_res;
-	} else if (cur->bc_private.b.flist->xbf_low) {
+	} else if (cur->bc_private.b.flist->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -487,7 +488,7 @@ xfs_bmbt_alloc_block(
 		error = xfs_alloc_vextent(&args);
 		if (error)
 			goto error0;
-		cur->bc_private.b.flist->xbf_low = 1;
+		cur->bc_private.b.flist->dop_low = true;
 	}
 	if (args.fsbno == NULLFSBLOCK) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4f48878..c5a475f 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_btree.h"
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 743fc32..4c05ba6 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -94,4 +94,11 @@ struct xfs_defer_op_type {
 void xfs_defer_init_op_type(const struct xfs_defer_op_type *type);
 void xfs_defer_init_types(void);
 
+/* XXX: compatibility shims, will go away in the next patch */
+#define xfs_bmap_finish		xfs_defer_finish
+#define xfs_bmap_cancel		xfs_defer_cancel
+#define xfs_bmap_init		xfs_defer_init
+#define xfs_bmap_free		xfs_defer_ops
+typedef struct xfs_defer_ops	xfs_bmap_free_t;
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 723b267..402611f 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -21,6 +21,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 249512b..44d5e76 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index c21a4e6..572c101 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -22,6 +22,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_cksum.h"
 #include "xfs_trans.h"
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index e2cc83e..a4ee48e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -24,6 +24,7 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
