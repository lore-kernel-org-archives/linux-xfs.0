Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n62594W1066895 for <xfs@oss.sgi.com>; Thu, 2 Jul 2009 00:09:04 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 252E010951A2
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 22:15:58 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 0Zpy2W8SWtjdVF6F for
	<xfs@oss.sgi.com>; Wed, 01 Jul 2009 22:15:58 -0700 (PDT)
Message-ID: <4A4C410D.5040205@sandeen.net>
Date: Thu, 02 Jul 2009 00:09:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] add more statics & drop some unused functions
References: <4A1C3D65.4020306@sandeen.net>
	<20090527102319.GA28274@infradead.org>
	<4A48D218.5050208@sandeen.net>
	<6E6C2EFA-9893-4585-AA36-CDE866C7CE45@sgi.com>
In-Reply-To: <6E6C2EFA-9893-4585-AA36-CDE866C7CE45@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>

Felix Blyakher wrote:
> On Jun 29, 2009, at 9:39 AM, Eric Sandeen wrote:
>
>   
>> Christoph Hellwig wrote:
>>     
>>> On Tue, May 26, 2009 at 02:05:09PM -0500, Eric Sandeen wrote:
>>>       
>>>> A lot more functions could be made static, but they need
>>>> forward declarations; this does some easy ones, and also
>>>> found a few unused functions in the process.
>>>>         
>>> Looks good to me.
>>>
>>>       
>> Felix, do you plan to merge this one?
>>     
>
> Eric, this patch doesn't apply cleanly now:
>
> Applying xfs: add more statics & drop some unused functions
> error: patch failed: fs/xfs/linux-2.6/xfs_sync.c:640
> error: fs/xfs/linux-2.6/xfs_sync.c: patch does not apply
> error: patch failed: fs/xfs/linux-2.6/xfs_sync.h:51
> error: fs/xfs/linux-2.6/xfs_sync.h: patch does not apply
> Patch failed at 0002.
>
> Can you rebase and repost it?
>
> Thanks,
> Felix
>
>   
This one applies to linus' tree ok....

-Eric

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a220d36..c709ed6 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -687,7 +687,7 @@ xfs_barrier_test(
 	return error;
 }
 
-void
+STATIC void
 xfs_mountfs_check_barriers(xfs_mount_t *mp)
 {
 	int error;
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index b619d6b..fbf3e02 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -740,21 +740,6 @@ __xfs_inode_clear_reclaim_tag(
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
 STATIC int
 xfs_reclaim_inode_now(
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 2a10301..23e7e7e 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -48,7 +48,6 @@ int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
-void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
 
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index f24b50b..af3cfeb 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -91,9 +91,6 @@ typedef struct xfs_agf {
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
 #define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)XFS_BUF_PTR(bp))
 
-extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
-			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
-
 /*
  * Size of the unlinked inode hash table in the agi.
  */
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 2cf944e..6316004 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2248,7 +2248,7 @@ xfs_alloc_put_freelist(
 /*
  * Read in the allocation group header (free/alloc section).
  */
-int					/* error */
+STATIC int				/* error */
 xfs_read_agf(
 	struct xfs_mount	*mp,	/* mount point structure */
 	struct xfs_trans	*tp,	/* transaction pointer */
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 7928b99..9759724 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3713,7 +3713,7 @@ done:
  * entry (null if none).  Else, *lastxp will be set to the index
  * of the found entry; *gotp will contain the entry.
  */
-xfs_bmbt_rec_host_t *			/* pointer to found extent entry */
+STATIC xfs_bmbt_rec_host_t *		/* pointer to found extent entry */
 xfs_bmap_search_multi_extents(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_fileoff_t	bno,		/* block number searched for */
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 1b8ff92..56f62d2 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
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
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 5c1ade0..eb7b702 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
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
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index 0e8df00..5549d49 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -220,7 +220,6 @@ extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
 extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
 extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_host_t *r);
 
-extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index e9df995..cde5a26 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
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
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 4f852b7..7fa0706 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
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
@@ -432,7 +418,6 @@ int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
 int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
 int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
 int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
-int xfs_btree_kill_iroot(struct xfs_btree_cur *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1f22d65..2dcb3d7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -641,7 +641,7 @@ xfs_iformat_btree(
 	return 0;
 }
 
-void
+STATIC void
 xfs_dinode_from_disk(
 	xfs_icdinode_t		*to,
 	xfs_dinode_t		*from)
@@ -1237,7 +1237,7 @@ xfs_isize_check(
  * In that case the pages will still be in memory, but the inode size
  * will never have been updated.
  */
-xfs_fsize_t
+STATIC xfs_fsize_t
 xfs_file_last_byte(
 	xfs_inode_t	*ip)
 {
@@ -3827,7 +3827,7 @@ xfs_iext_inline_to_direct(
 /*
  * Resize an extent indirection array to new_size bytes.
  */
-void
+STATIC void
 xfs_iext_realloc_indirect(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* new indirection array size */
@@ -3852,7 +3852,7 @@ xfs_iext_realloc_indirect(
 /*
  * Switch from indirection array to linear (direct) extent allocations.
  */
-void
+STATIC void
 xfs_iext_indirect_to_direct(
 	 xfs_ifork_t	*ifp)		/* inode fork pointer */
 {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1804f86..5104dae 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -521,7 +521,6 @@ void		xfs_ipin(xfs_inode_t *);
 void		xfs_iunpin(xfs_inode_t *);
 int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_ichgtime(xfs_inode_t *, int);
-xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
@@ -589,8 +588,6 @@ int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_buf **, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, xfs_daddr_t, uint);
-void		xfs_dinode_from_disk(struct xfs_icdinode *,
-				     struct xfs_dinode *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
@@ -609,8 +606,6 @@ void		xfs_iext_remove_inline(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_direct(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_indirect(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_realloc_direct(xfs_ifork_t *, int);
-void		xfs_iext_realloc_indirect(xfs_ifork_t *, int);
-void		xfs_iext_indirect_to_direct(xfs_ifork_t *);
 void		xfs_iext_direct_to_inline(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_inline_to_direct(xfs_ifork_t *, int);
 void		xfs_iext_destroy(xfs_ifork_t *);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index aeb2d22..c471122 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -39,7 +39,7 @@
 #include "xfs_error.h"
 #include "xfs_btree.h"
 
-int
+STATIC int
 xfs_internal_inum(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino)
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 1fb04e7..20792bf 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
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
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index bcad5f4..679c7c4 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -451,8 +451,6 @@ extern int	 xlog_find_tail(xlog_t	*log,
 extern int	 xlog_recover(xlog_t *log);
 extern int	 xlog_recover_finish(xlog_t *log);
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
-extern void	 xlog_recover_process_iunlinks(xlog_t *log);
-
 extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
 extern void	 xlog_put_bp(struct xfs_buf *);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 47da2fb..1099395 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3263,7 +3263,7 @@ xlog_recover_process_one_iunlink(
  * freeing of the inode and its removal from the list must be
  * atomic.
  */
-void
+STATIC void
 xlog_recover_process_iunlinks(
 	xlog_t		*log)
 {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5c6f092..8b6c9e8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1568,7 +1568,7 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
  *
  * The m_sb_lock must be held when this routine is called.
  */
-int
+STATIC int
 xfs_mod_incore_sb_unlocked(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a512238..a6c023b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -414,13 +414,10 @@ typedef struct xfs_mod_sb {
 
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
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index afee7eb..4b0613d 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
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
diff --git a/fs/xfs/xfs_mru_cache.h b/fs/xfs/xfs_mru_cache.h
index dd58ea1..5d439f3 100644
--- a/fs/xfs/xfs_mru_cache.h
+++ b/fs/xfs/xfs_mru_cache.h
@@ -49,7 +49,6 @@ int xfs_mru_cache_insert(struct xfs_mru_cache *mru, unsigned long key,
 void * xfs_mru_cache_remove(struct xfs_mru_cache *mru, unsigned long key);
 void xfs_mru_cache_delete(struct xfs_mru_cache *mru, unsigned long key);
 void *xfs_mru_cache_lookup(struct xfs_mru_cache *mru, unsigned long key);
-void *xfs_mru_cache_peek(struct xfs_mru_cache *mru, unsigned long key);
 void xfs_mru_cache_done(struct xfs_mru_cache *mru);
 
 #endif /* __XFS_MRU_CACHE_H__ */
diff --git a/fs/xfs/xfs_rw.h b/fs/xfs/xfs_rw.h
index f76c003..ae65f0d 100644
--- a/fs/xfs/xfs_rw.h
+++ b/fs/xfs/xfs_rw.h
@@ -78,10 +78,4 @@ extern int xfs_read_buf(struct xfs_mount *mp, xfs_buftarg_t *btp,
 extern void xfs_ioerror_alert(char *func, struct xfs_mount *mp,
 				xfs_buf_t *bp, xfs_daddr_t blkno);
 
-/*
- * Prototypes for functions in xfs_vnodeops.c.
- */
-extern int xfs_free_eofblocks(struct xfs_mount *mp, struct xfs_inode *ip,
-			int flags);
-
 #endif /* __XFS_RW_H__ */
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index c4eca5e..1dd7068 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -716,7 +716,7 @@ xfs_fsync(
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
