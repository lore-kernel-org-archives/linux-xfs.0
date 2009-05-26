Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QJ4xHq156541 for <xfs@oss.sgi.com>; Tue, 26 May 2009 14:04:59 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FD572ADDD2
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 12:05:11 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id hMC6U1fTyAfkCl5S for <xfs@oss.sgi.com>;
	Tue, 26 May 2009 12:05:11 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4QJ5AlL030459
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 15:05:10 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4QJ5Agq012454
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 15:05:10 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4QJ59Bb008005
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 15:05:09 -0400
Message-ID: <4A1C3D65.4020306@sandeen.net>
Date: Tue, 26 May 2009 14:05:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] add more statics & drop some unused functions
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

A lot more functions could be made static, but they need
forward declarations; this does some easy ones, and also 
found a few unused functions in the process.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

 linux-2.6/xfs_super.c |    2 +-
 linux-2.6/xfs_sync.c  |   16 ----------------
 linux-2.6/xfs_sync.h  |    1 -
 xfs_ag.h              |    3 ---
 xfs_alloc.c           |    2 +-
 xfs_bmap.c            |    2 +-
 xfs_bmap.h            |   11 -----------
 xfs_bmap_btree.c      |   20 ++++++++++----------
 xfs_bmap_btree.h      |    1 -
 xfs_btree.c           |   42 +-----------------------------------------
 xfs_btree.h           |   15 ---------------
 xfs_inode.c           |    8 ++++----
 xfs_inode.h           |    5 -----
 xfs_itable.c          |    2 +-
 xfs_itable.h          |    5 -----
 xfs_log_priv.h        |    2 --
 xfs_log_recover.c     |    2 +-
 xfs_mount.c           |    2 +-
 xfs_mount.h           |    3 ---
 xfs_mru_cache.c       |   29 -----------------------------
 xfs_mru_cache.h       |    1 -
 xfs_rw.h              |    6 ------
 xfs_vnodeops.c        |    2 +-
 23 files changed, 22 insertions(+), 160 deletions(-)

Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c
@@ -688,7 +688,7 @@ xfs_barrier_test(
 	return error;
 }
 
-void
+STATIC void
 xfs_mountfs_check_barriers(xfs_mount_t *mp)
 {
 	int error;
Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
@@ -640,22 +640,6 @@ __xfs_inode_clear_reclaim_tag(
 			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
 }
 
-void
-xfs_inode_clear_reclaim_tag(
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
-
-	read_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	__xfs_inode_clear_reclaim_tag(mp, pag, ip);
-	spin_unlock(&ip->i_flags_lock);
-	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
-}
-
-
 STATIC void
 xfs_reclaim_inodes_ag(
 	xfs_mount_t	*mp,
Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.h
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.h
@@ -51,7 +51,6 @@ int xfs_reclaim_inode(struct xfs_inode *
 int xfs_reclaim_inodes(struct xfs_mount *mp, int noblock, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
-void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
 #endif
Index: linux-2.6/fs/xfs/xfs_ag.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_ag.h
+++ linux-2.6/fs/xfs/xfs_ag.h
@@ -91,9 +91,6 @@ typedef struct xfs_agf {
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
 #define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)XFS_BUF_PTR(bp))
 
-extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
-			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
-
 /*
  * Size of the unlinked inode hash table in the agi.
  */
Index: linux-2.6/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.c
+++ linux-2.6/fs/xfs/xfs_alloc.c
@@ -2248,7 +2248,7 @@ xfs_alloc_put_freelist(
 /*
  * Read in the allocation group header (free/alloc section).
  */
-int					/* error */
+STATIC int				/* error */
 xfs_read_agf(
 	struct xfs_mount	*mp,	/* mount point structure */
 	struct xfs_trans	*tp,	/* transaction pointer */
Index: linux-2.6/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.c
+++ linux-2.6/fs/xfs/xfs_bmap.c
@@ -3713,7 +3713,7 @@ done:
  * entry (null if none).  Else, *lastxp will be set to the index
  * of the found entry; *gotp will contain the entry.
  */
-xfs_bmbt_rec_host_t *			/* pointer to found extent entry */
+STATIC xfs_bmbt_rec_host_t *		/* pointer to found extent entry */
 xfs_bmap_search_multi_extents(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_fileoff_t	bno,		/* block number searched for */
Index: linux-2.6/fs/xfs/xfs_bmap.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.h
+++ linux-2.6/fs/xfs/xfs_bmap.h
@@ -392,17 +392,6 @@ xfs_bmap_count_blocks(
 	int			whichfork,
 	int			*count);
 
-/*
- * Search the extent records for the entry containing block bno.
- * If bno lies in a hole, point to the next entry.  If bno lies
- * past eof, *eofp will be set, and *prevp will contain the last
- * entry (null if none).  Else, *lastxp will be set to the index
- * of the found entry; *gotp will contain the entry.
- */
-xfs_bmbt_rec_host_t *
-xfs_bmap_search_multi_extents(struct xfs_ifork *, xfs_fileoff_t, int *,
-			xfs_extnum_t *, xfs_bmbt_irec_t *, xfs_bmbt_irec_t *);
-
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BMAP_H__ */
Index: linux-2.6/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap_btree.c
+++ linux-2.6/fs/xfs/xfs_bmap_btree.c
@@ -202,16 +202,6 @@ xfs_bmbt_get_state(
 				ext_flag);
 }
 
-/* Endian flipping versions of the bmbt extraction functions */
-void
-xfs_bmbt_disk_get_all(
-	xfs_bmbt_rec_t	*r,
-	xfs_bmbt_irec_t *s)
-{
-	__xfs_bmbt_get_all(get_unaligned_be64(&r->l0),
-				get_unaligned_be64(&r->l1), s);
-}
-
 /*
  * Extract the blockcount field from an on disk bmap extent record.
  */
@@ -816,6 +806,16 @@ xfs_bmbt_trace_key(
 	*l1 = 0;
 }
 
+/* Endian flipping versions of the bmbt extraction functions */
+STATIC void
+xfs_bmbt_disk_get_all(
+	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_irec_t *s)
+{
+	__xfs_bmbt_get_all(get_unaligned_be64(&r->l0),
+				get_unaligned_be64(&r->l1), s);
+}
+
 STATIC void
 xfs_bmbt_trace_record(
 	struct xfs_btree_cur	*cur,
Index: linux-2.6/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap_btree.h
+++ linux-2.6/fs/xfs/xfs_bmap_btree.h
@@ -220,7 +220,6 @@ extern xfs_fsblock_t xfs_bmbt_get_startb
 extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
 extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_host_t *r);
 
-extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 
Index: linux-2.6/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_btree.c
+++ linux-2.6/fs/xfs/xfs_btree.c
@@ -646,46 +646,6 @@ xfs_btree_read_bufl(
 }
 
 /*
- * Get a buffer for the block, return it read in.
- * Short-form addressing.
- */
-int					/* error */
-xfs_btree_read_bufs(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_agblock_t	agbno,		/* allocation group block number */
-	uint		lock,		/* lock flags for read_buf */
-	xfs_buf_t	**bpp,		/* buffer for agno/agbno */
-	int		refval)		/* ref count value for buffer */
-{
-	xfs_buf_t	*bp;		/* return value */
-	xfs_daddr_t	d;		/* real disk block address */
-	int		error;
-
-	ASSERT(agno != NULLAGNUMBER);
-	ASSERT(agbno != NULLAGBLOCK);
-	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	if ((error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
-					mp->m_bsize, lock, &bp))) {
-		return error;
-	}
-	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
-	if (bp != NULL) {
-		switch (refval) {
-		case XFS_ALLOC_BTREE_REF:
-			XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
-			break;
-		case XFS_INO_BTREE_REF:
-			XFS_BUF_SET_VTYPE_REF(bp, B_FS_INOMAP, refval);
-			break;
-		}
-	}
-	*bpp = bp;
-	return 0;
-}
-
-/*
  * Read-ahead the block, don't wait for it, don't return a buffer.
  * Long-form addressing.
  */
@@ -2951,7 +2911,7 @@ error0:
  * inode we have to copy the single block it was pointing to into the
  * inode.
  */
-int
+STATIC int
 xfs_btree_kill_iroot(
 	struct xfs_btree_cur	*cur)
 {
Index: linux-2.6/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_btree.h
+++ linux-2.6/fs/xfs/xfs_btree.h
@@ -379,20 +379,6 @@ xfs_btree_read_bufl(
 	int			refval);/* ref count value for buffer */
 
 /*
- * Get a buffer for the block, return it read in.
- * Short-form addressing.
- */
-int					/* error */
-xfs_btree_read_bufs(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	xfs_agblock_t		agbno,	/* allocation group block number */
-	uint			lock,	/* lock flags for read_buf */
-	struct xfs_buf		**bpp,	/* buffer for agno/agbno */
-	int			refval);/* ref count value for buffer */
-
-/*
  * Read-ahead the block, don't wait for it, don't return a buffer.
  * Long-form addressing.
  */
@@ -432,7 +418,6 @@ int xfs_btree_decrement(struct xfs_btree
 int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
 int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
 int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
-int xfs_btree_kill_iroot(struct xfs_btree_cur *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c
+++ linux-2.6/fs/xfs/xfs_inode.c
@@ -642,7 +642,7 @@ xfs_iformat_btree(
 	return 0;
 }
 
-void
+STATIC void
 xfs_dinode_from_disk(
 	xfs_icdinode_t		*to,
 	xfs_dinode_t		*from)
@@ -1238,7 +1238,7 @@ xfs_isize_check(
  * In that case the pages will still be in memory, but the inode size
  * will never have been updated.
  */
-xfs_fsize_t
+STATIC xfs_fsize_t
 xfs_file_last_byte(
 	xfs_inode_t	*ip)
 {
@@ -3828,7 +3828,7 @@ xfs_iext_inline_to_direct(
 /*
  * Resize an extent indirection array to new_size bytes.
  */
-void
+STATIC void
 xfs_iext_realloc_indirect(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* new indirection array size */
@@ -3853,7 +3853,7 @@ xfs_iext_realloc_indirect(
 /*
  * Switch from indirection array to linear (direct) extent allocations.
  */
-void
+STATIC void
 xfs_iext_indirect_to_direct(
 	 xfs_ifork_t	*ifp)		/* inode fork pointer */
 {
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h
+++ linux-2.6/fs/xfs/xfs_inode.h
@@ -520,7 +520,6 @@ void		xfs_ipin(xfs_inode_t *);
 void		xfs_iunpin(xfs_inode_t *);
 int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_ichgtime(xfs_inode_t *, int);
-xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
@@ -588,8 +587,6 @@ int		xfs_itobp(struct xfs_mount *, struc
 			  struct xfs_buf **, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, xfs_daddr_t, uint);
-void		xfs_dinode_from_disk(struct xfs_icdinode *,
-				     struct xfs_dinode *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
@@ -608,8 +605,6 @@ void		xfs_iext_remove_inline(xfs_ifork_t
 void		xfs_iext_remove_direct(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_indirect(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_realloc_direct(xfs_ifork_t *, int);
-void		xfs_iext_realloc_indirect(xfs_ifork_t *, int);
-void		xfs_iext_indirect_to_direct(xfs_ifork_t *);
 void		xfs_iext_direct_to_inline(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_inline_to_direct(xfs_ifork_t *, int);
 void		xfs_iext_destroy(xfs_ifork_t *);
Index: linux-2.6/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_itable.c
+++ linux-2.6/fs/xfs/xfs_itable.c
@@ -39,7 +39,7 @@
 #include "xfs_error.h"
 #include "xfs_btree.h"
 
-int
+STATIC int
 xfs_internal_inum(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino)
Index: linux-2.6/fs/xfs/xfs_itable.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_itable.h
+++ linux-2.6/fs/xfs/xfs_itable.h
@@ -99,11 +99,6 @@ xfs_bulkstat_one(
 	void			*dibuff,
 	int			*stat);
 
-int
-xfs_internal_inum(
-	xfs_mount_t		*mp,
-	xfs_ino_t		ino);
-
 typedef int (*inumbers_fmt_pf)(
 	void			__user *ubuffer, /* buffer to write to */
 	const xfs_inogrp_t	*buffer,	/* buffer to read from */
Index: linux-2.6/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log_priv.h
+++ linux-2.6/fs/xfs/xfs_log_priv.h
@@ -451,8 +451,6 @@ extern int	 xlog_find_tail(xlog_t	*log,
 extern int	 xlog_recover(xlog_t *log);
 extern int	 xlog_recover_finish(xlog_t *log);
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
-extern void	 xlog_recover_process_iunlinks(xlog_t *log);
-
 extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
 extern void	 xlog_put_bp(struct xfs_buf *);
 
Index: linux-2.6/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log_recover.c
+++ linux-2.6/fs/xfs/xfs_log_recover.c
@@ -3237,7 +3237,7 @@ xlog_recover_process_one_iunlink(
  * freeing of the inode and its removal from the list must be
  * atomic.
  */
-void
+STATIC void
 xlog_recover_process_iunlinks(
 	xlog_t		*log)
 {
Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c
+++ linux-2.6/fs/xfs/xfs_mount.c
@@ -1568,7 +1568,7 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
  *
  * The m_sb_lock must be held when this routine is called.
  */
-int
+STATIC int
 xfs_mod_incore_sb_unlocked(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field,
Index: linux-2.6/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.h
+++ linux-2.6/fs/xfs/xfs_mount.h
@@ -415,13 +415,10 @@ typedef struct xfs_mod_sb {
 
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
 extern int	xfs_mountfs(xfs_mount_t *mp);
-extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
 
 extern void	xfs_unmountfs(xfs_mount_t *);
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
-extern int	xfs_mod_incore_sb_unlocked(xfs_mount_t *, xfs_sb_field_t,
-			int64_t, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);
 extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
Index: linux-2.6/fs/xfs/xfs_mru_cache.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mru_cache.c
+++ linux-2.6/fs/xfs/xfs_mru_cache.c
@@ -564,35 +564,6 @@ xfs_mru_cache_lookup(
 }
 
 /*
- * To look up an element using its key, but leave its location in the internal
- * lists alone, call xfs_mru_cache_peek().  If the element isn't found, this
- * function returns NULL.
- *
- * See the comments above the declaration of the xfs_mru_cache_lookup() function
- * for important locking information pertaining to this call.
- */
-void *
-xfs_mru_cache_peek(
-	xfs_mru_cache_t	*mru,
-	unsigned long	key)
-{
-	xfs_mru_cache_elem_t *elem;
-
-	ASSERT(mru && mru->lists);
-	if (!mru || !mru->lists)
-		return NULL;
-
-	spin_lock(&mru->lock);
-	elem = radix_tree_lookup(&mru->store, key);
-	if (!elem)
-		spin_unlock(&mru->lock);
-	else
-		__release(mru_lock); /* help sparse not be stupid */
-
-	return elem ? elem->value : NULL;
-}
-
-/*
  * To release the internal data structure spinlock after having performed an
  * xfs_mru_cache_lookup() or an xfs_mru_cache_peek(), call xfs_mru_cache_done()
  * with the data store pointer.
Index: linux-2.6/fs/xfs/xfs_mru_cache.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mru_cache.h
+++ linux-2.6/fs/xfs/xfs_mru_cache.h
@@ -49,7 +49,6 @@ int xfs_mru_cache_insert(struct xfs_mru_
 void * xfs_mru_cache_remove(struct xfs_mru_cache *mru, unsigned long key);
 void xfs_mru_cache_delete(struct xfs_mru_cache *mru, unsigned long key);
 void *xfs_mru_cache_lookup(struct xfs_mru_cache *mru, unsigned long key);
-void *xfs_mru_cache_peek(struct xfs_mru_cache *mru, unsigned long key);
 void xfs_mru_cache_done(struct xfs_mru_cache *mru);
 
 #endif /* __XFS_MRU_CACHE_H__ */
Index: linux-2.6/fs/xfs/xfs_rw.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_rw.h
+++ linux-2.6/fs/xfs/xfs_rw.h
@@ -78,10 +78,4 @@ extern int xfs_read_buf(struct xfs_mount
 extern void xfs_ioerror_alert(char *func, struct xfs_mount *mp,
 				xfs_buf_t *bp, xfs_daddr_t blkno);
 
-/*
- * Prototypes for functions in xfs_vnodeops.c.
- */
-extern int xfs_free_eofblocks(struct xfs_mount *mp, struct xfs_inode *ip,
-			int flags);
-
 #endif /* __XFS_RW_H__ */
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c
+++ linux-2.6/fs/xfs/xfs_vnodeops.c
@@ -702,7 +702,7 @@ xfs_fsync(
  * when the link count isn't zero and by xfs_dm_punch_hole() when
  * punching a hole to EOF.
  */
-int
+STATIC int
 xfs_free_eofblocks(
 	xfs_mount_t	*mp,
 	xfs_inode_t	*ip,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
