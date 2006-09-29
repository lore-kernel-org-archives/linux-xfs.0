Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Sep 2006 20:29:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8T3TcaG005313
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 20:29:39 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59B1B456F15
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 20:28:57 -0700 (PDT)
Subject: [PATCH 1/2] Make stuff static
Message-Id: <20060929032856.8DA9C18001A5E@sandeen.net>
Date: Thu, 28 Sep 2006 22:28:56 -0500 (CDT)
From: sandeen@sandeen.net
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Make things static which can be.

 linux-2.4/xfs_vfs.c   |    2 -
 linux-2.4/xfs_vfs.h   |    1 
 linux-2.4/xfs_vnode.c |    2 -
 linux-2.6/xfs_vfs.c   |    2 -
 linux-2.6/xfs_vfs.h   |    1 
 linux-2.6/xfs_vnode.c |    2 -
 quota/xfs_dquot.c     |    2 -
 quota/xfs_qm_bhv.c    |    2 -
 xfs_attr.c            |    3 +-
 xfs_attr.h            |    4 ---
 xfs_bmap.c            |    5 +---
 xfs_bmap_btree.c      |   52 ++++++++++++++++++++++++++------------------------
 xfs_bmap_btree.h      |   10 ---------
 xfs_btree.c           |    4 ++-
 xfs_btree.h           |   12 +----------
 xfs_dir2.h            |    4 ---
 xfs_dir2_data.h       |    2 -
 xfs_dir2_node.h       |    2 -
 xfs_inode.c           |   49 ++++++++++++++++++++++++++++++-----------------
 xfs_inode.h           |   29 +--------------------------
 xfs_log_priv.h        |    7 ------
 xfs_log_recover.c     |   10 ++++-----
 xfs_mount.h           |    2 -
 xfs_quota.h           |    2 -
 xfs_trans_buf.c       |    2 -
 25 files changed, 84 insertions(+), 129 deletions(-)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-linux/linux-2.4/xfs_vnode.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_vnode.c
+++ xfs-linux/linux-2.4/xfs_vnode.c
@@ -17,7 +17,7 @@
 #include "xfs.h"
 
 uint64_t vn_generation;		/* vnode generation number */
-spinlock_t vnumber_lock = SPIN_LOCK_UNLOCKED;
+static spinlock_t vnumber_lock = SPIN_LOCK_UNLOCKED;
 
 /*
  * Dedicated vnode inactive/reclaim sync semaphores.
Index: xfs-linux/linux-2.6/xfs_vnode.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_vnode.c
+++ xfs-linux/linux-2.6/xfs_vnode.c
@@ -18,7 +18,7 @@
 #include "xfs.h"
 
 uint64_t vn_generation;		/* vnode generation number */
-DEFINE_SPINLOCK(vnumber_lock);
+static DEFINE_SPINLOCK(vnumber_lock);
 
 /*
  * Dedicated vnode inactive/reclaim sync semaphores.
Index: xfs-linux/xfs_inode.c
===================================================================
--- xfs-linux.orig/xfs_inode.c
+++ xfs-linux/xfs_inode.c
@@ -65,7 +65,22 @@ STATIC int xfs_iflush_int(xfs_inode_t *,
 STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
 STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
 STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
-
+STATIC void xfs_iext_add_indirect_multi(xfs_ifork_t *, int, xfs_extnum_t, int);
+STATIC void xfs_iext_remove_inline(xfs_ifork_t *, xfs_extnum_t, int);
+STATIC void xfs_iext_remove_direct(xfs_ifork_t *, xfs_extnum_t, int);
+STATIC void xfs_iext_remove_indirect(xfs_ifork_t *, xfs_extnum_t, int);
+STATIC void xfs_iext_inline_to_direct(xfs_ifork_t *, int);
+STATIC void xfs_iext_realloc_direct(xfs_ifork_t *, int);
+STATIC void xfs_iext_realloc_indirect(xfs_ifork_t *, int);
+STATIC void xfs_iext_direct_to_inline(xfs_ifork_t *, xfs_extnum_t);
+STATIC void xfs_iext_irec_init(xfs_ifork_t *);
+STATIC void xfs_iext_irec_remove(xfs_ifork_t *, int);
+STATIC void xfs_iext_irec_compact(xfs_ifork_t *);
+STATIC void xfs_iext_irec_compact_pages(xfs_ifork_t *);
+STATIC void xfs_iext_irec_compact_full(xfs_ifork_t *);
+STATIC void xfs_iext_irec_update_extoffs(xfs_ifork_t *, int, int);
+STATIC xfs_ext_irec_t *xfs_iext_bno_to_irec(xfs_ifork_t *, xfs_fileoff_t, int *);
+STATIC xfs_ext_irec_t *xfs_iext_irec_new(xfs_ifork_t *, int);
 
 #ifdef DEBUG
 /*
@@ -105,7 +120,7 @@ xfs_validate_extents(
  * unlinked field of 0.
  */
 #if defined(DEBUG)
-void
+STATIC void
 xfs_inobp_check(
 	xfs_mount_t	*mp,
 	xfs_buf_t	*bp)
@@ -1268,7 +1283,7 @@ xfs_ialloc(
  * at least do it for regular files.
  */
 #ifdef DEBUG
-void
+STATIC void
 xfs_isize_check(
 	xfs_mount_t	*mp,
 	xfs_inode_t	*ip,
@@ -3621,7 +3636,7 @@ xfs_iaccess(
 /*
  * xfs_iroundup: round up argument to next power of two
  */
-uint
+STATIC uint
 xfs_iroundup(
 	uint	v)
 {
@@ -3834,7 +3849,7 @@ xfs_iext_add(
  *    | count |   | nex2  |    nex2 - number of extents after idx + count
  *    |-------|   |-------|
  */
-void
+STATIC void
 xfs_iext_add_indirect_multi(
 	xfs_ifork_t	*ifp,			/* inode fork pointer */
 	int		erp_idx,		/* target extent irec index */
@@ -3971,7 +3986,7 @@ xfs_iext_remove(
  * This removes ext_diff extents from the inline buffer, beginning
  * at extent index idx.
  */
-void
+STATIC void
 xfs_iext_remove_inline(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_extnum_t	idx,		/* index to begin removing exts */
@@ -4008,7 +4023,7 @@ xfs_iext_remove_inline(
  * at idx + ext_diff up in the list to overwrite the records being
  * removed, then remove the extra space via kmem_realloc.
  */
-void
+STATIC void
 xfs_iext_remove_direct(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_extnum_t	idx,		/* index to begin removing exts */
@@ -4060,7 +4075,7 @@ xfs_iext_remove_direct(
  *    |       |   | nex2  |    nex2 - number of extents after idx + count
  *    |-------|   |-------|
  */
-void
+STATIC void
 xfs_iext_remove_indirect(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_extnum_t	idx,		/* index to begin removing extents */
@@ -4126,7 +4141,7 @@ xfs_iext_remove_indirect(
 /*
  * Create, destroy, or resize a linear (direct) block of extents.
  */
-void
+STATIC void
 xfs_iext_realloc_direct(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* new size of extents */
@@ -4187,7 +4202,7 @@ xfs_iext_realloc_direct(
 /*
  * Switch from linear (direct) extent records to inline buffer.
  */
-void
+STATIC void
 xfs_iext_direct_to_inline(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_extnum_t	nextents)	/* number of extents in file */
@@ -4214,7 +4229,7 @@ xfs_iext_direct_to_inline(
  * if_bytes here. It is the caller's responsibility to update
  * if_bytes upon return.
  */
-void
+STATIC void
 xfs_iext_inline_to_direct(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* number of extents in file */
@@ -4234,7 +4249,7 @@ xfs_iext_inline_to_direct(
 /*
  * Resize an extent indirection array to new_size bytes.
  */
-void
+STATIC void
 xfs_iext_realloc_indirect(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* new indirection array size */
@@ -4259,7 +4274,7 @@ xfs_iext_realloc_indirect(
 /*
  * Switch from indirection array to linear (direct) extent allocations.
  */
-void
+STATIC void
 xfs_iext_indirect_to_direct(
 	 xfs_ifork_t	*ifp)		/* inode fork pointer */
 {
@@ -4386,7 +4401,7 @@ xfs_iext_bno_to_ext(
  * extent record for filesystem block bno. Store the index of the
  * target irec in *erp_idxp.
  */
-xfs_ext_irec_t *			/* pointer to found extent record */
+STATIC xfs_ext_irec_t *			/* pointer to found extent record */
 xfs_iext_bno_to_irec(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_fileoff_t	bno,		/* block number to search for */
@@ -4611,7 +4626,7 @@ xfs_iext_irec_remove(
  * Partial Compaction: Extents occupy > 10% and < 50% of allocated space
  *      No Compaction: Extents occupy at least 50% of allocated space
  */
-void
+STATIC void
 xfs_iext_irec_compact(
 	xfs_ifork_t	*ifp)		/* inode fork pointer */
 {
@@ -4639,7 +4654,7 @@ xfs_iext_irec_compact(
 /*
  * Combine extents from neighboring extent pages.
  */
-void
+STATIC void
 xfs_iext_irec_compact_pages(
 	xfs_ifork_t	*ifp)		/* inode fork pointer */
 {
@@ -4676,7 +4691,7 @@ xfs_iext_irec_compact_pages(
 /*
  * Fully compact the extent records managed by the indirection array.
  */
-void
+STATIC void
 xfs_iext_irec_compact_full(
 	xfs_ifork_t	*ifp)			/* inode fork pointer */
 {
Index: xfs-linux/xfs_inode.h
===================================================================
--- xfs-linux.orig/xfs_inode.h
+++ xfs-linux/xfs_inode.h
@@ -460,7 +460,6 @@ int		xfs_iextents_copy(xfs_inode_t *, xf
 int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_iflush_all(struct xfs_mount *);
 int		xfs_iaccess(xfs_inode_t *, mode_t, cred_t *);
-uint		xfs_iroundup(uint);
 void		xfs_ichgtime(xfs_inode_t *, int);
 xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, int, uint);
@@ -473,41 +472,17 @@ xfs_bmbt_rec_t	*xfs_iext_get_ext(xfs_ifo
 void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
 				xfs_bmbt_irec_t *);
 void		xfs_iext_add(xfs_ifork_t *, xfs_extnum_t, int);
-void		xfs_iext_add_indirect_multi(xfs_ifork_t *, int, xfs_extnum_t, int);
 void		xfs_iext_remove(xfs_ifork_t *, xfs_extnum_t, int);
-void		xfs_iext_remove_inline(xfs_ifork_t *, xfs_extnum_t, int);
-void		xfs_iext_remove_direct(xfs_ifork_t *, xfs_extnum_t, int);
-void		xfs_iext_remove_indirect(xfs_ifork_t *, xfs_extnum_t, int);
-void		xfs_iext_realloc_direct(xfs_ifork_t *, int);
-void		xfs_iext_realloc_indirect(xfs_ifork_t *, int);
-void		xfs_iext_indirect_to_direct(xfs_ifork_t *);
-void		xfs_iext_direct_to_inline(xfs_ifork_t *, xfs_extnum_t);
-void		xfs_iext_inline_to_direct(xfs_ifork_t *, int);
 void		xfs_iext_destroy(xfs_ifork_t *);
 xfs_bmbt_rec_t	*xfs_iext_bno_to_ext(xfs_ifork_t *, xfs_fileoff_t, int *);
-xfs_ext_irec_t	*xfs_iext_bno_to_irec(xfs_ifork_t *, xfs_fileoff_t, int *);
 xfs_ext_irec_t	*xfs_iext_idx_to_irec(xfs_ifork_t *, xfs_extnum_t *, int *, int);
-void		xfs_iext_irec_init(xfs_ifork_t *);
-xfs_ext_irec_t *xfs_iext_irec_new(xfs_ifork_t *, int);
-void		xfs_iext_irec_remove(xfs_ifork_t *, int);
-void		xfs_iext_irec_compact(xfs_ifork_t *);
-void		xfs_iext_irec_compact_pages(xfs_ifork_t *);
-void		xfs_iext_irec_compact_full(xfs_ifork_t *);
-void		xfs_iext_irec_update_extoffs(xfs_ifork_t *, int, int);
 
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
-#ifdef DEBUG
-void		xfs_isize_check(struct xfs_mount *, xfs_inode_t *, xfs_fsize_t);
-#else	/* DEBUG */
+#ifndef DEBUG
 #define xfs_isize_check(mp, ip, isize)
-#endif	/* DEBUG */
-
-#if defined(DEBUG)
-void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
-#else
 #define	xfs_inobp_check(mp, bp)
-#endif /* DEBUG */
+#endif /* !DEBUG */
 
 extern struct kmem_zone	*xfs_chashlist_zone;
 extern struct kmem_zone	*xfs_ifork_zone;
Index: xfs-linux/xfs_attr.h
===================================================================
--- xfs-linux.orig/xfs_attr.h
+++ xfs-linux/xfs_attr.h
@@ -59,7 +59,6 @@ typedef struct attrnames {
 #define ATTR_NAMECOUNT	4
 extern struct attrnames attr_user;
 extern struct attrnames attr_secure;
-extern struct attrnames attr_system;
 extern struct attrnames attr_trusted;
 extern struct attrnames *attr_namespaces[ATTR_NAMECOUNT];
 
@@ -161,11 +160,8 @@ struct xfs_da_args;
  */
 int xfs_attr_get(bhv_desc_t *, const char *, char *, int *, int, struct cred *);
 int xfs_attr_set(bhv_desc_t *, const char *, char *, int, int, struct cred *);
-int xfs_attr_set_int(struct xfs_inode *, const char *, int, char *, int, int);
 int xfs_attr_remove(bhv_desc_t *, const char *, int, struct cred *);
-int xfs_attr_remove_int(struct xfs_inode *, const char *, int, int);
 int xfs_attr_list(bhv_desc_t *, char *, int, int, struct attrlist_cursor_kern *, struct cred *);
-int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_attr_inactive(struct xfs_inode *dp);
 
 int xfs_attr_shortform_getvalue(struct xfs_da_args *);
Index: xfs-linux/xfs_bmap_btree.c
===================================================================
--- xfs-linux.orig/xfs_bmap_btree.c
+++ xfs-linux/xfs_bmap_btree.c
@@ -60,7 +60,17 @@ STATIC int xfs_bmbt_rshift(xfs_btree_cur
 STATIC int xfs_bmbt_split(xfs_btree_cur_t *, int, xfs_fsblock_t *,
 		__uint64_t *, xfs_btree_cur_t **, int *);
 STATIC int xfs_bmbt_updkey(xfs_btree_cur_t *, xfs_bmbt_key_t *, int);
-
+STATIC xfs_bmbt_block_t *xfs_bmbt_get_block(struct xfs_btree_cur *cur,
+						int, struct xfs_buf **bpp);
+#ifndef XFS_NATIVE_HOST
+STATIC void xfs_bmbt_disk_set_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
+STATIC void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
+			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
+#ifdef DEBUG
+STATIC xfs_fsblock_t xfs_bmbt_disk_get_startblock(xfs_bmbt_rec_t *r);
+STATIC xfs_exntst_t xfs_bmbt_disk_get_state(xfs_bmbt_rec_t *r);
+#endif
+#endif
 
 #if defined(XFS_BMBT_TRACE)
 
@@ -693,18 +703,14 @@ xfs_bmbt_get_rec(
 {
 	xfs_bmbt_block_t	*block;
 	xfs_buf_t		*bp;
-#ifdef DEBUG
 	int			error;
-#endif
 	int			ptr;
 	xfs_bmbt_rec_t		*rp;
 
 	block = xfs_bmbt_get_block(cur, 0, &bp);
 	ptr = cur->bc_ptrs[0];
-#ifdef DEBUG
 	if ((error = xfs_btree_check_lblock(cur, block, 0, bp)))
 		return error;
-#endif
 	if (ptr > be16_to_cpu(block->bb_numrecs) || ptr <= 0) {
 		*stat = 0;
 		return 0;
@@ -1913,7 +1919,7 @@ xfs_bmbt_get_all(
  * Get the block pointer for the given level of the cursor.
  * Fill in the buffer pointer, if applicable.
  */
-xfs_bmbt_block_t *
+STATIC xfs_bmbt_block_t *
 xfs_bmbt_get_block(
 	xfs_btree_cur_t		*cur,
 	int			level,
@@ -2015,10 +2021,11 @@ xfs_bmbt_disk_get_blockcount(
 	return (xfs_filblks_t)(INT_GET(r->l1, ARCH_CONVERT) & XFS_MASK64LO(21));
 }
 
+#ifdef DEBUG
 /*
  * Extract the startblock field from an on disk bmap extent record.
  */
-xfs_fsblock_t
+STATIC xfs_fsblock_t
 xfs_bmbt_disk_get_startblock(
 	xfs_bmbt_rec_t	*r)
 {
@@ -2026,19 +2033,27 @@ xfs_bmbt_disk_get_startblock(
 	return (((xfs_fsblock_t)INT_GET(r->l0, ARCH_CONVERT) & XFS_MASK64LO(9)) << 43) |
 	       (((xfs_fsblock_t)INT_GET(r->l1, ARCH_CONVERT)) >> 21);
 #else
-#ifdef DEBUG
 	xfs_dfsbno_t	b;
 
 	b = (((xfs_dfsbno_t)INT_GET(r->l0, ARCH_CONVERT) & XFS_MASK64LO(9)) << 43) |
 	    (((xfs_dfsbno_t)INT_GET(r->l1, ARCH_CONVERT)) >> 21);
 	ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
 	return (xfs_fsblock_t)b;
-#else	/* !DEBUG */
-	return (xfs_fsblock_t)(((xfs_dfsbno_t)INT_GET(r->l1, ARCH_CONVERT)) >> 21);
-#endif	/* DEBUG */
 #endif	/* XFS_BIG_BLKNOS */
 }
 
+STATIC xfs_exntst_t
+xfs_bmbt_disk_get_state(
+	xfs_bmbt_rec_t  *r)
+{
+	int	ext_flag;
+
+	ext_flag = (int)((INT_GET(r->l0, ARCH_CONVERT)) >> (64 - BMBT_EXNTFLAG_BITLEN));
+	return xfs_extent_state(xfs_bmbt_disk_get_blockcount(r),
+				ext_flag);
+}
+#endif	/* DEBUG */
+
 /*
  * Extract the startoff field from a disk format bmap extent record.
  */
@@ -2049,17 +2064,6 @@ xfs_bmbt_disk_get_startoff(
 	return ((xfs_fileoff_t)INT_GET(r->l0, ARCH_CONVERT) &
 		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
-
-xfs_exntst_t
-xfs_bmbt_disk_get_state(
-	xfs_bmbt_rec_t  *r)
-{
-	int	ext_flag;
-
-	ext_flag = (int)((INT_GET(r->l0, ARCH_CONVERT)) >> (64 - BMBT_EXNTFLAG_BITLEN));
-	return xfs_extent_state(xfs_bmbt_disk_get_blockcount(r),
-				ext_flag);
-}
 #endif /* XFS_NATIVE_HOST */
 
 
@@ -2506,7 +2510,7 @@ xfs_bmbt_set_allf(
 /*
  * Set all the fields in a bmap extent record from the uncompressed form.
  */
-void
+STATIC void
 xfs_bmbt_disk_set_all(
 	xfs_bmbt_rec_t	*r,
 	xfs_bmbt_irec_t *s)
@@ -2548,7 +2552,7 @@ xfs_bmbt_disk_set_all(
 /*
  * Set all the fields in a disk format bmap extent record from the arguments.
  */
-void
+STATIC void
 xfs_bmbt_disk_set_allf(
 	xfs_bmbt_rec_t	*r,
 	xfs_fileoff_t	o,
Index: xfs-linux/xfs_bmap_btree.h
===================================================================
--- xfs-linux.orig/xfs_bmap_btree.h
+++ xfs-linux/xfs_bmap_btree.h
@@ -306,8 +306,6 @@ extern void xfs_bmdr_to_bmbt(xfs_bmdr_bl
 extern int xfs_bmbt_decrement(struct xfs_btree_cur *, int, int *);
 extern int xfs_bmbt_delete(struct xfs_btree_cur *, int *);
 extern void xfs_bmbt_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
-extern xfs_bmbt_block_t *xfs_bmbt_get_block(struct xfs_btree_cur *cur,
-						int, struct xfs_buf **bpp);
 extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_t *r);
@@ -315,9 +313,7 @@ extern xfs_exntst_t xfs_bmbt_get_state(x
 
 #ifndef XFS_NATIVE_HOST
 extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
-extern xfs_exntst_t xfs_bmbt_disk_get_state(xfs_bmbt_rec_t *r);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
-extern xfs_fsblock_t xfs_bmbt_disk_get_startblock(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 #else
 #define xfs_bmbt_disk_get_all(r, s)	xfs_bmbt_get_all(r, s)
@@ -351,11 +347,7 @@ extern void xfs_bmbt_set_startblock(xfs_
 extern void xfs_bmbt_set_startoff(xfs_bmbt_rec_t *r, xfs_fileoff_t v);
 extern void xfs_bmbt_set_state(xfs_bmbt_rec_t *r, xfs_exntst_t v);
 
-#ifndef XFS_NATIVE_HOST
-extern void xfs_bmbt_disk_set_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
-extern void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
-			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
-#else
+#ifdef XFS_NATIVE_HOST
 #define xfs_bmbt_disk_set_all(r, s)		xfs_bmbt_set_all(r, s)
 #define xfs_bmbt_disk_set_allf(r, o, b, c, v)	xfs_bmbt_set_allf(r, o, b, c, v)
 #endif /* XFS_NATIVE_HOST */
Index: xfs-linux/xfs_dir2.h
===================================================================
--- xfs-linux.orig/xfs_dir2.h
+++ xfs-linux/xfs_dir2.h
@@ -107,10 +107,6 @@ extern int xfs_dir_ino_validate(struct x
  */
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
-extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp,
-				int *vp);
-extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp,
-				int *vp);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_dabuf *bp);
 
Index: xfs-linux/xfs_dir2_data.h
===================================================================
--- xfs-linux.orig/xfs_dir2_data.h
+++ xfs-linux/xfs_dir2_data.h
@@ -161,8 +161,6 @@ extern void xfs_dir2_data_check(struct x
 #else
 #define	xfs_dir2_data_check(dp,bp)
 #endif
-extern xfs_dir2_data_free_t *xfs_dir2_data_freefind(xfs_dir2_data_t *d,
-				xfs_dir2_data_unused_t *dup);
 extern xfs_dir2_data_free_t *xfs_dir2_data_freeinsert(xfs_dir2_data_t *d,
 				xfs_dir2_data_unused_t *dup, int *loghead);
 extern void xfs_dir2_data_freescan(struct xfs_mount *mp, xfs_dir2_data_t *d,
Index: xfs-linux/xfs_dir2_node.h
===================================================================
--- xfs-linux.orig/xfs_dir2_node.h
+++ xfs-linux/xfs_dir2_node.h
@@ -77,8 +77,6 @@ xfs_dir2_db_to_fdindex(struct xfs_mount 
 	return ((db) % XFS_DIR2_MAX_FREE_BESTS(mp));
 }
 
-extern void xfs_dir2_free_log_bests(struct xfs_trans *tp, struct xfs_dabuf *bp,
-				    int first, int last);
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
 				 struct xfs_dabuf *lbp);
 extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_dabuf *bp, int *count);
Index: xfs-linux/xfs_log_priv.h
===================================================================
--- xfs-linux.orig/xfs_log_priv.h
+++ xfs-linux/xfs_log_priv.h
@@ -484,18 +484,11 @@ typedef struct log {
 
 /* common routines */
 extern xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
-extern int	 xlog_find_tail(xlog_t	*log,
-				xfs_daddr_t *head_blk,
-				xfs_daddr_t *tail_blk);
 extern int	 xlog_recover(xlog_t *log);
 extern int	 xlog_recover_finish(xlog_t *log, int mfsi_flags);
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
 extern void	 xlog_recover_process_iunlinks(xlog_t *log);
 
-extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
-extern void	 xlog_put_bp(struct xfs_buf *);
-extern int	 xlog_bread(xlog_t *, xfs_daddr_t, int, struct xfs_buf *);
-
 /* iclog tracing */
 #define XLOG_TRACE_GRAB_FLUSH  1
 #define XLOG_TRACE_REL_FLUSH   2
Index: xfs-linux/xfs_log_recover.c
===================================================================
--- xfs-linux.orig/xfs_log_recover.c
+++ xfs-linux/xfs_log_recover.c
@@ -69,7 +69,7 @@ STATIC void	xlog_recover_check_ail(xfs_m
 	((bbs + (log)->l_sectbb_mask + 1) & ~(log)->l_sectbb_mask) : (bbs) )
 #define XLOG_SECTOR_ROUNDDOWN_BLKNO(log, bno)	((bno) & ~(log)->l_sectbb_mask)
 
-xfs_buf_t *
+STATIC xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
 	int		num_bblks)
@@ -84,7 +84,7 @@ xlog_get_bp(
 	return xfs_buf_get_noaddr(BBTOB(num_bblks), log->l_mp->m_logdev_targp);
 }
 
-void
+STATIC void
 xlog_put_bp(
 	xfs_buf_t	*bp)
 {
@@ -95,7 +95,7 @@ xlog_put_bp(
 /*
  * nbblks should be uint, but oh well.  Just want to catch that 32-bit length.
  */
-int
+STATIC int
 xlog_bread(
 	xlog_t		*log,
 	xfs_daddr_t	blk_no,
@@ -293,7 +293,7 @@ xlog_recover_iodone(
  * Note that the algorithm can not be perfect because the disk will not
  * necessarily be perfect.
  */
-int
+STATIC int
 xlog_find_cycle_start(
 	xlog_t		*log,
 	xfs_buf_t	*bp,
@@ -777,7 +777,7 @@ xlog_find_head(
  * We could speed up search by using current head_blk buffer, but it is not
  * available.
  */
-int
+STATIC int
 xlog_find_tail(
 	xlog_t			*log,
 	xfs_daddr_t		*head_blk,
Index: xfs-linux/xfs_mount.h
===================================================================
--- xfs-linux.orig/xfs_mount.h
+++ xfs-linux/xfs_mount.h
@@ -586,8 +586,6 @@ extern void	xfs_unmountfs_close(xfs_moun
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
 extern int	xfs_unmount_flush(xfs_mount_t *, int);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int, int);
-extern int	xfs_mod_incore_sb_unlocked(xfs_mount_t *, xfs_sb_field_t,
-			int, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
Index: xfs-linux/quota/xfs_qm_bhv.c
===================================================================
--- xfs-linux.orig/quota/xfs_qm_bhv.c
+++ xfs-linux/quota/xfs_qm_bhv.c
@@ -401,7 +401,7 @@ STATIC struct xfs_qmops xfs_qmcore_xfs =
 	.xfs_dqtrxops		= &xfs_trans_dquot_ops,
 };
 
-struct bhv_module_vfsops xfs_qmops = { {
+static struct bhv_module_vfsops xfs_qmops = { {
 	BHV_IDENTITY_INIT(VFS_BHV_QM, VFS_POSITION_QM),
 	.vfs_parseargs		= xfs_qm_parseargs,
 	.vfs_showargs		= xfs_qm_showargs,
Index: xfs-linux/xfs_attr.c
===================================================================
--- xfs-linux.orig/xfs_attr.c
+++ xfs-linux/xfs_attr.c
@@ -59,6 +59,7 @@
 #define ATTR_SYSCOUNT	2
 STATIC struct attrnames posix_acl_access;
 STATIC struct attrnames posix_acl_default;
+STATIC struct attrnames attr_system;
 STATIC struct attrnames *attr_system_names[ATTR_SYSCOUNT];
 
 /*========================================================================
@@ -2690,7 +2691,7 @@ attr_system_remove(
 	return namesp->attr_remove(vp, name, xflags);
 }
 
-struct attrnames attr_system = {
+STATIC struct attrnames attr_system = {
 	.attr_name	= "system.",
 	.attr_namelen	= sizeof("system.") - 1,
 	.attr_flag	= ATTR_SYSTEM,
Index: xfs-linux/xfs_quota.h
===================================================================
--- xfs-linux.orig/xfs_quota.h
+++ xfs-linux/xfs_quota.h
@@ -363,8 +363,6 @@ typedef struct xfs_dqtrxops {
 extern int xfs_qm_dqcheck(xfs_disk_dquot_t *, xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
-extern struct bhv_module_vfsops xfs_qmops;
-
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_QUOTA_H__ */
Index: xfs-linux/linux-2.4/xfs_vfs.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_vfs.c
+++ xfs-linux/linux-2.4/xfs_vfs.c
@@ -275,7 +275,7 @@ vfs_deallocate(
 	kmem_free(vfsp, sizeof(bhv_vfs_t));
 }
 
-void
+static void
 vfs_insertbhv(
 	struct bhv_vfs		*vfsp,
 	struct bhv_desc		*bdp,
Index: xfs-linux/linux-2.4/xfs_vfs.h
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_vfs.h
+++ xfs-linux/linux-2.4/xfs_vfs.h
@@ -230,7 +230,6 @@ typedef struct bhv_module {
 extern bhv_vfs_t *vfs_allocate(struct super_block *);
 extern bhv_vfs_t *vfs_from_sb(struct super_block *);
 extern void vfs_deallocate(bhv_vfs_t *);
-extern void vfs_insertbhv(bhv_vfs_t *, bhv_desc_t *, bhv_vfsops_t *, void *);
 
 #define bhv_lookup_module(n,m)	( (m) ? \
 				inter_module_get_request(n, m) : \
Index: xfs-linux/linux-2.6/xfs_vfs.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_vfs.c
+++ xfs-linux/linux-2.6/xfs_vfs.c
@@ -274,7 +274,7 @@ vfs_deallocate(
 	kmem_free(vfsp, sizeof(bhv_vfs_t));
 }
 
-void
+static void
 vfs_insertbhv(
 	struct bhv_vfs		*vfsp,
 	struct bhv_desc		*bdp,
Index: xfs-linux/linux-2.6/xfs_vfs.h
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_vfs.h
+++ xfs-linux/linux-2.6/xfs_vfs.h
@@ -224,7 +224,6 @@ typedef struct bhv_module {
 extern bhv_vfs_t *vfs_allocate(struct super_block *);
 extern bhv_vfs_t *vfs_from_sb(struct super_block *);
 extern void vfs_deallocate(bhv_vfs_t *);
-extern void vfs_insertbhv(bhv_vfs_t *, bhv_desc_t *, bhv_vfsops_t *, void *);
 
 extern void bhv_module_init(const char *, struct module *, const void *);
 extern void bhv_module_exit(const char *);
Index: xfs-linux/quota/xfs_dquot.c
===================================================================
--- xfs-linux.orig/quota/xfs_dquot.c
+++ xfs-linux/quota/xfs_dquot.c
@@ -72,7 +72,7 @@ STATIC void		xfs_qm_dqflush_done(xfs_buf
 xfs_buftarg_t *xfs_dqerror_target;
 int xfs_do_dqerror;
 int xfs_dqreq_num;
-int xfs_dqerror_mod = 33;
+STATIC int xfs_dqerror_mod = 33;
 #endif
 
 /*
Index: xfs-linux/xfs_bmap.c
===================================================================
--- xfs-linux.orig/xfs_bmap.c
+++ xfs-linux/xfs_bmap.c
@@ -6072,8 +6072,7 @@ xfs_bmap_check_extents(
 	}
 }
 
-STATIC
-xfs_buf_t *
+STATIC xfs_buf_t *
 xfs_bmap_get_bp(
 	xfs_btree_cur_t         *cur,
 	xfs_fsblock_t		bno)
@@ -6134,7 +6133,7 @@ xfs_bmap_get_bp(
 	return(bp);
 }
 
-void
+STATIC void
 xfs_check_block(
 	xfs_bmbt_block_t        *block,
 	xfs_mount_t		*mp,
Index: xfs-linux/xfs_btree.c
===================================================================
--- xfs-linux.orig/xfs_btree.c
+++ xfs-linux/xfs_btree.c
@@ -110,7 +110,7 @@ xfs_btree_maxrecs(
 /*
  * Debug routine: check that block header is ok.
  */
-void
+STATIC void
 xfs_btree_check_block(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	xfs_btree_block_t	*block,	/* generic btree block pointer */
@@ -337,6 +337,7 @@ xfs_btree_check_sblock(
 	return 0;
 }
 
+#ifdef DEBUG
 /*
  * Checking routine: check that (short) pointer is ok.
  */
@@ -357,6 +358,7 @@ xfs_btree_check_sptr(
 		ptr < be32_to_cpu(agf->agf_length));
 	return 0;
 }
+#endif
 
 /*
  * Delete the btree cursor.
Index: xfs-linux/xfs_btree.h
===================================================================
--- xfs-linux.orig/xfs_btree.h
+++ xfs-linux/xfs_btree.h
@@ -192,16 +192,6 @@ typedef struct xfs_btree_cur
 
 #ifdef DEBUG
 /*
- * Debug routine: check that block header is ok.
- */
-void
-xfs_btree_check_block(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_block_t	*block,	/* generic btree block pointer */
-	int			level,	/* level of the btree block */
-	struct xfs_buf		*bp);	/* buffer containing block, if any */
-
-/*
  * Debug routine: check that keys are in the right order.
  */
 void
@@ -256,6 +246,7 @@ xfs_btree_check_sblock(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp);	/* buffer containing block */
 
+#ifdef DEBUG
 /*
  * Checking routine: check that (short) pointer is ok.
  */
@@ -264,6 +255,7 @@ xfs_btree_check_sptr(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	xfs_agblock_t		ptr,	/* btree block disk address */
 	int			level);	/* btree block level */
+#endif
 
 /*
  * Delete the btree cursor.
Index: xfs-linux/xfs_trans_buf.c
===================================================================
--- xfs-linux.orig/xfs_trans_buf.c
+++ xfs-linux/xfs_trans_buf.c
@@ -260,7 +260,7 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 xfs_buftarg_t *xfs_error_target;
 int	xfs_do_error;
 int	xfs_req_num;
-int	xfs_error_mod = 33;
+STATIC int	xfs_error_mod = 33;
 #endif
 
 /*
