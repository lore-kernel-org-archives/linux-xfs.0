Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB04829DFC
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 07:51:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 395B1AC002
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 05:51:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LQOzRlzO0qLqi4z5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 05:51:39 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z088u-0004Y9-Sb
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 12:51:37 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] xfs: switch remaining xfs_trans_dup users to
	xfs_trans_roll
Date: Wed,  3 Jun 2015 14:49:52 +0200
Message-Id: <1433335796-23445-2-git-send-email-hch@lst.de>
In-Reply-To: <1433335796-23445-1-git-send-email-hch@lst.de>
References: <1433335796-23445-1-git-send-email-hch@lst.de>
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

We have three remaining callers of xfs_trans_dup:

 - xfs_itruncate_extents which open codes xfs_trans_roll
 - xfs_bmap_finish doesn't have an xfs_inode argument and thus leaves
   attaching them to it's callers, but otherwise is identical to
   xfs_trans_roll
 - xfs_dir_ialloc looks at the log reservations in the old xfs_trans
   structure instead of the log reservation parameters, but otherwise
   is identical to xfs_trans_roll.

By allowing a NULL xfs_inode argument to xfs_trans_roll we can switch
these three remaining users over to xfs_trans_roll and mark xfs_trans_dup
static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 31 ++++++------------------
 fs/xfs/xfs_inode.c     | 66 +++-----------------------------------------------
 fs/xfs/xfs_trans.c     |  8 +++---
 fs/xfs/xfs_trans.h     |  3 ---
 4 files changed, 16 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a52bbd3..f469aad 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -75,28 +75,20 @@ xfs_bmap_finish(
 	xfs_efi_log_item_t	*efi;		/* extent free intention */
 	int			error;		/* error return value */
 	xfs_bmap_free_item_t	*free;		/* free extent item */
-	struct xfs_trans_res	tres;		/* new log reservation */
 	xfs_mount_t		*mp;		/* filesystem mount structure */
 	xfs_bmap_free_item_t	*next;		/* next item on free list */
-	xfs_trans_t		*ntp;		/* new transaction pointer */
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 	if (flist->xbf_count == 0) {
 		*committed = 0;
 		return 0;
 	}
-	ntp = *tp;
-	efi = xfs_trans_get_efi(ntp, flist->xbf_count);
+	efi = xfs_trans_get_efi(*tp, flist->xbf_count);
 	for (free = flist->xbf_first; free; free = free->xbfi_next)
-		xfs_trans_log_efi_extent(ntp, efi, free->xbfi_startblock,
+		xfs_trans_log_efi_extent(*tp, efi, free->xbfi_startblock,
 			free->xbfi_blockcount);
 
-	tres.tr_logres = ntp->t_log_res;
-	tres.tr_logcount = ntp->t_log_count;
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	ntp = xfs_trans_dup(*tp);
-	error = xfs_trans_commit(*tp, 0);
-	*tp = ntp;
+	error = xfs_trans_roll(tp, NULL);
 	*committed = 1;
 	/*
 	 * We have a new transaction, so we should return committed=1,
@@ -105,19 +97,10 @@ xfs_bmap_finish(
 	if (error)
 		return error;
 
-	/*
-	 * transaction commit worked ok so we can drop the extra ticket
-	 * reference that we gained in xfs_trans_dup()
-	 */
-	xfs_log_ticket_put(ntp->t_ticket);
-
-	error = xfs_trans_reserve(ntp, &tres, 0, 0);
-	if (error)
-		return error;
-	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
+	efd = xfs_trans_get_efd(*tp, efi, flist->xbf_count);
 	for (free = flist->xbf_first; free != NULL; free = next) {
 		next = free->xbfi_next;
-		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
+		if ((error = xfs_free_extent(*tp, free->xbfi_startblock,
 				free->xbfi_blockcount))) {
 			/*
 			 * The bmap free list will be cleaned up at a
@@ -127,7 +110,7 @@ xfs_bmap_finish(
 			 * happens, since this transaction may not be
 			 * dirty yet.
 			 */
-			mp = ntp->t_mountp;
+			mp = (*tp)->t_mountp;
 			if (!XFS_FORCED_SHUTDOWN(mp))
 				xfs_force_shutdown(mp,
 						   (error == -EFSCORRUPTED) ?
@@ -135,7 +118,7 @@ xfs_bmap_finish(
 						   SHUTDOWN_META_IO_ERROR);
 			return error;
 		}
-		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
+		xfs_trans_log_efd_extent(*tp, efd, free->xbfi_startblock,
 			free->xbfi_blockcount);
 		xfs_bmap_del_free(flist, NULL, free);
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4c054f6..11b051a5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -905,7 +905,6 @@ xfs_dir_ialloc(
 
 {
 	xfs_trans_t	*tp;
-	xfs_trans_t	*ntp;
 	xfs_inode_t	*ip;
 	xfs_buf_t	*ialloc_context = NULL;
 	int		code;
@@ -954,8 +953,6 @@ xfs_dir_ialloc(
 	 * to succeed the second time.
 	 */
 	if (ialloc_context) {
-		struct xfs_trans_res tres;
-
 		/*
 		 * Normally, xfs_trans_commit releases all the locks.
 		 * We call bhold to hang on to the ialloc_context across
@@ -964,12 +961,6 @@ xfs_dir_ialloc(
 		 * allocation group.
 		 */
 		xfs_trans_bhold(tp, ialloc_context);
-		/*
-		 * Save the log reservation so we can use
-		 * them in the next transaction.
-		 */
-		tres.tr_logres = xfs_trans_get_log_res(tp);
-		tres.tr_logcount = xfs_trans_get_log_count(tp);
 
 		/*
 		 * We want the quota changes to be associated with the next
@@ -985,35 +976,9 @@ xfs_dir_ialloc(
 			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
 		}
 
-		ntp = xfs_trans_dup(tp);
-		code = xfs_trans_commit(tp, 0);
-		tp = ntp;
-		if (committed != NULL) {
+		code = xfs_trans_roll(&tp, 0);
+		if (committed != NULL)
 			*committed = 1;
-		}
-		/*
-		 * If we get an error during the commit processing,
-		 * release the buffer that is still held and return
-		 * to the caller.
-		 */
-		if (code) {
-			xfs_buf_relse(ialloc_context);
-			if (dqinfo) {
-				tp->t_dqinfo = dqinfo;
-				xfs_trans_free_dqinfo(tp);
-			}
-			*tpp = ntp;
-			*ipp = NULL;
-			return code;
-		}
-
-		/*
-		 * transaction commit worked ok so we can drop the extra ticket
-		 * reference that we gained in xfs_trans_dup()
-		 */
-		xfs_log_ticket_put(tp->t_ticket);
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		code = xfs_trans_reserve(tp, &tres, 0, 0);
 
 		/*
 		 * Re-attach the quota info that we detached from prev trx.
@@ -1025,7 +990,7 @@ xfs_dir_ialloc(
 
 		if (code) {
 			xfs_buf_relse(ialloc_context);
-			*tpp = ntp;
+			*tpp = tp;
 			*ipp = NULL;
 			return code;
 		}
@@ -1555,7 +1520,6 @@ xfs_itruncate_extents(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
-	struct xfs_trans	*ntp;
 	xfs_bmap_free_t		free_list;
 	xfs_fsblock_t		first_block;
 	xfs_fileoff_t		first_unmap_block;
@@ -1613,29 +1577,7 @@ xfs_itruncate_extents(
 		if (error)
 			goto out_bmap_cancel;
 
-		if (committed) {
-			/*
-			 * Mark the inode dirty so it will be logged and
-			 * moved forward in the log as part of every commit.
-			 */
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		}
-
-		ntp = xfs_trans_dup(tp);
-		error = xfs_trans_commit(tp, 0);
-		tp = ntp;
-
-		xfs_trans_ijoin(tp, ip, 0);
-
-		if (error)
-			goto out;
-
-		/*
-		 * Transaction commit worked ok so we can drop the extra ticket
-		 * reference that we gained in xfs_trans_dup()
-		 */
-		xfs_log_ticket_put(tp->t_ticket);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+		error = xfs_trans_roll(&tp, ip);
 		if (error)
 			goto out;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 220ef2c..a2dfb30 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -113,7 +113,7 @@ xfs_trans_free(
  * blocks.  Locks and log items, however, are no inherited.  They must
  * be added to the new transaction explicitly.
  */
-xfs_trans_t *
+STATIC xfs_trans_t *
 xfs_trans_dup(
 	xfs_trans_t	*tp)
 {
@@ -1055,7 +1055,8 @@ xfs_trans_roll(
 	 * Ensure that the inode is always logged.
 	 */
 	trans = *tpp;
-	xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
+	if (dp)
+		xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
 
 	/*
 	 * Copy the critical parameters from one trans to the next.
@@ -1100,6 +1101,7 @@ xfs_trans_roll(
 	if (error)
 		return error;
 
-	xfs_trans_ijoin(trans, dp, 0);
+	if (dp)
+		xfs_trans_ijoin(trans, dp, 0);
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index b5bc1ab..3bfb417 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -133,8 +133,6 @@ typedef struct xfs_trans {
  * XFS transaction mechanism exported interfaces that are
  * actually macros.
  */
-#define	xfs_trans_get_log_res(tp)	((tp)->t_log_res)
-#define	xfs_trans_get_log_count(tp)	((tp)->t_log_count)
 #define	xfs_trans_get_block_res(tp)	((tp)->t_blk_res)
 #define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
 
@@ -153,7 +151,6 @@ typedef struct xfs_trans {
  */
 xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
 xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, xfs_km_flags_t);
-xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
 				  uint, uint);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
