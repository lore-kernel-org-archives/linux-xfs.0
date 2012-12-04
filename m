Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB4N62Rt203887 for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 17:06:02 -0600
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7F6E304064
	for <xfs@oss.sgi.com>; Tue,  4 Dec 2012 15:08:22 -0800 (PST)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	qB4N8LuQ008583
	for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 17:08:21 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121204224938.990495241@sgi.com>
Date: Tue, 04 Dec 2012 17:18:06 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v3 5/5] xfs remove the XFS_TRANS_DEBUG routines
References: <20121204231801.982422341@sgi.com>
Content-Disposition: inline; filename=v3-4-xfs-remove-XFS_TRANS_DEBUG.patch
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove the XFS_TRANS_DEBUG routines. They are no longer appropriate
and have not been used in years

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf_item.c    |  106 -----------------------------------------------
 fs/xfs/xfs_buf_item.h    |   14 ------
 fs/xfs/xfs_inode.c       |    6 --
 fs/xfs/xfs_inode_item.c  |   16 -------
 fs/xfs/xfs_inode_item.h  |    4 -
 fs/xfs/xfs_trans_ail.c   |   14 ------
 fs/xfs/xfs_trans_inode.c |   41 ------------------
 7 files changed, 201 deletions(-)

Index: b/fs/xfs/xfs_buf_item.c
===================================================================
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -37,109 +37,6 @@ static inline struct xfs_buf_log_item *B
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
-
-#ifdef XFS_TRANS_DEBUG
-/*
- * This function uses an alternate strategy for tracking the bytes
- * that the user requests to be logged.  This can then be used
- * in conjunction with the bli_orig array in the buf log item to
- * catch bugs in our callers' code.
- *
- * We also double check the bits set in xfs_buf_item_log using a
- * simple algorithm to check that every byte is accounted for.
- */
-STATIC void
-xfs_buf_item_log_debug(
-	xfs_buf_log_item_t	*bip,
-	uint			first,
-	uint			last)
-{
-	uint	x;
-	uint	byte;
-	uint	nbytes;
-	uint	chunk_num;
-	uint	word_num;
-	uint	bit_num;
-	uint	bit_set;
-	uint	*wordp;
-
-	ASSERT(bip->bli_logged != NULL);
-	byte = first;
-	nbytes = last - first + 1;
-	bfset(bip->bli_logged, first, nbytes);
-	for (x = 0; x < nbytes; x++) {
-		chunk_num = byte >> XFS_BLF_SHIFT;
-		word_num = chunk_num >> BIT_TO_WORD_SHIFT;
-		bit_num = chunk_num & (NBWORD - 1);
-		wordp = &(bip->__bli_format.blf_data_map[word_num]);
-		bit_set = *wordp & (1 << bit_num);
-		ASSERT(bit_set);
-		byte++;
-	}
-}
-
-/*
- * This function is called when we flush something into a buffer without
- * logging it.  This happens for things like inodes which are logged
- * separately from the buffer.
- */
-void
-xfs_buf_item_flush_log_debug(
-	xfs_buf_t	*bp,
-	uint		first,
-	uint		last)
-{
-	xfs_buf_log_item_t	*bip = bp->b_fspriv;
-	uint			nbytes;
-
-	if (bip == NULL || (bip->bli_item.li_type != XFS_LI_BUF))
-		return;
-
-	ASSERT(bip->bli_logged != NULL);
-	nbytes = last - first + 1;
-	bfset(bip->bli_logged, first, nbytes);
-}
-
-/*
- * This function is called to verify that our callers have logged
- * all the bytes that they changed.
- *
- * It does this by comparing the original copy of the buffer stored in
- * the buf log item's bli_orig array to the current copy of the buffer
- * and ensuring that all bytes which mismatch are set in the bli_logged
- * array of the buf log item.
- */
-STATIC void
-xfs_buf_item_log_check(
-	xfs_buf_log_item_t	*bip)
-{
-	char		*orig;
-	char		*buffer;
-	int		x;
-	xfs_buf_t	*bp;
-
-	ASSERT(bip->bli_orig != NULL);
-	ASSERT(bip->bli_logged != NULL);
-
-	bp = bip->bli_buf;
-	ASSERT(bp->b_length > 0);
-	ASSERT(bp->b_addr != NULL);
-	orig = bip->bli_orig;
-	buffer = bp->b_addr;
-	for (x = 0; x < BBTOB(bp->b_length); x++) {
-		if (orig[x] != buffer[x] && !btst(bip->bli_logged, x)) {
-			xfs_emerg(bp->b_mount,
-				"%s: bip %x buffer %x orig %x index %d",
-				__func__, bip, bp, orig, x);
-			ASSERT(0);
-		}
-	}
-}
-#else
-#define		xfs_buf_item_log_debug(x,y,z)
-#define		xfs_buf_item_log_check(x)
-#endif
-
 STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
 
 /*
@@ -429,7 +326,6 @@ xfs_buf_item_format(
 	 * Check to make sure everything is consistent.
 	 */
 	trace_xfs_buf_item_format(bip);
-	xfs_buf_item_log_check(bip);
 }
 
 /*
@@ -915,8 +811,6 @@ xfs_buf_item_log_segment(
 		mask = (1 << end_bit) - 1;
 		*wordp |= mask;
 	}
-
-	xfs_buf_item_log_debug(bip, first, last);
 }
 
 /*
Index: b/fs/xfs/xfs_buf_item.h
===================================================================
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -98,10 +98,6 @@ typedef struct xfs_buf_log_item {
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* lock recursion count */
 	atomic_t		bli_refcount;	/* cnt of tp refs */
-#ifdef XFS_TRANS_DEBUG
-	char			*bli_orig;	/* original buffer copy */
-	char			*bli_logged;	/* bytes logged (bitmap) */
-#endif
 	int			bli_format_count;	/* count of headers */
 	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
 	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
@@ -117,16 +113,6 @@ void	xfs_buf_attach_iodone(struct xfs_bu
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 
-#ifdef XFS_TRANS_DEBUG
-void
-xfs_buf_item_flush_log_debug(
-	struct xfs_buf *bp,
-	uint	first,
-	uint	last);
-#else
-#define	xfs_buf_item_flush_log_debug(bp, first, last)
-#endif
-
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BUF_ITEM_H__ */
Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2379,9 +2379,6 @@ xfs_iflush_fork(
 	char			*cp;
 	xfs_ifork_t		*ifp;
 	xfs_mount_t		*mp;
-#ifdef XFS_TRANS_DEBUG
-	int			first;
-#endif
 	static const short	brootflag[2] =
 		{ XFS_ILOG_DBROOT, XFS_ILOG_ABROOT };
 	static const short	dataflag[2] =
@@ -2724,9 +2721,6 @@ xfs_iflush_int(
 	xfs_inode_log_item_t	*iip;
 	xfs_dinode_t		*dip;
 	xfs_mount_t		*mp;
-#ifdef XFS_TRANS_DEBUG
-	int			first;
-#endif
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
Index: b/fs/xfs/xfs_inode_item.c
===================================================================
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -269,17 +269,6 @@ xfs_inode_item_format(
 		} else {
 			ASSERT(!(iip->ili_fields &
 				 XFS_ILOG_DBROOT));
-#ifdef XFS_TRANS_DEBUG
-			if (iip->ili_root_size > 0) {
-				ASSERT(iip->ili_root_size ==
-				       ip->i_df.if_broot_bytes);
-				ASSERT(memcmp(iip->ili_orig_root,
-					    ip->i_df.if_broot,
-					    iip->ili_root_size) == 0);
-			} else {
-				ASSERT(ip->i_df.if_broot_bytes == 0);
-			}
-#endif
 			iip->ili_fields &= ~XFS_ILOG_DBROOT;
 		}
 		break;
@@ -678,11 +667,6 @@ void
 xfs_inode_item_destroy(
 	xfs_inode_t	*ip)
 {
-#ifdef XFS_TRANS_DEBUG
-	if (ip->i_itemp->ili_root_size != 0) {
-		kmem_free(ip->i_itemp->ili_orig_root);
-	}
-#endif
 	kmem_zone_free(xfs_ili_zone, ip->i_itemp);
 }
 
Index: b/fs/xfs/xfs_inode_item.h
===================================================================
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -148,10 +148,6 @@ typedef struct xfs_inode_log_item {
 						      data exts */
 	struct xfs_bmbt_rec	*ili_aextents_buf; /* array of logged
 						      attr exts */
-#ifdef XFS_TRANS_DEBUG
-	int			ili_root_size;
-	char			*ili_orig_root;
-#endif
 	xfs_inode_log_format_t	ili_format;	   /* logged structure */
 } xfs_inode_log_item_t;
 
Index: b/fs/xfs/xfs_trans_ail.c
===================================================================
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -55,20 +55,6 @@ xfs_ail_check(
 		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) >= 0);
 
 
-#ifdef XFS_TRANS_DEBUG
-	/*
-	 * Walk the list checking lsn ordering, and that every entry has the
-	 * XFS_LI_IN_AIL flag set. This is really expensive, so only do it
-	 * when specifically debugging the transaction subsystem.
-	 */
-	prev_lip = list_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
-	list_for_each_entry(lip, &ailp->xa_ail, li_ail) {
-		if (&prev_lip->li_ail != &ailp->xa_ail)
-			ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
-		ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
-		prev_lip = lip;
-	}
-#endif /* XFS_TRANS_DEBUG */
 }
 #else /* !DEBUG */
 #define	xfs_ail_check(a,l)
Index: b/fs/xfs/xfs_trans_inode.c
===================================================================
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -33,14 +33,6 @@
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
 
-#ifdef XFS_TRANS_DEBUG
-STATIC void
-xfs_trans_inode_broot_debug(
-	xfs_inode_t	*ip);
-#else
-#define	xfs_trans_inode_broot_debug(ip)
-#endif
-
 /*
  * Add a locked inode to the transaction.
  *
@@ -67,8 +59,6 @@ xfs_trans_ijoin(
 	 * Get a log_item_desc to point at the new item.
 	 */
 	xfs_trans_add_item(tp, &iip->ili_item);
-
-	xfs_trans_inode_broot_debug(ip);
 }
 
 /*
@@ -135,34 +125,3 @@ xfs_trans_log_inode(
 	flags |= ip->i_itemp->ili_last_fields;
 	ip->i_itemp->ili_fields |= flags;
 }
-
-#ifdef XFS_TRANS_DEBUG
-/*
- * Keep track of the state of the inode btree root to make sure we
- * log it properly.
- */
-STATIC void
-xfs_trans_inode_broot_debug(
-	xfs_inode_t	*ip)
-{
-	xfs_inode_log_item_t	*iip;
-
-	ASSERT(ip->i_itemp != NULL);
-	iip = ip->i_itemp;
-	if (iip->ili_root_size != 0) {
-		ASSERT(iip->ili_orig_root != NULL);
-		kmem_free(iip->ili_orig_root);
-		iip->ili_root_size = 0;
-		iip->ili_orig_root = NULL;
-	}
-	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
-		ASSERT((ip->i_df.if_broot != NULL) &&
-		       (ip->i_df.if_broot_bytes > 0));
-		iip->ili_root_size = ip->i_df.if_broot_bytes;
-		iip->ili_orig_root =
-			(char*)kmem_alloc(iip->ili_root_size, KM_SLEEP);
-		memcpy(iip->ili_orig_root, (char*)(ip->i_df.if_broot),
-		      iip->ili_root_size);
-	}
-}
-#endif


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
