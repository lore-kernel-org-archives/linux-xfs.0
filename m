Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QKkWg6040841 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 15:46:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20C27154D145
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 13:47:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wxzAGKP2eABlsXeS for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 13:47:03 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MgPOX-0003Jb-Gl
	for xfs@oss.sgi.com; Wed, 26 Aug 2009 20:47:01 +0000
Date: Wed, 26 Aug 2009 16:47:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: simplify xfs_trans_iget
Message-ID: <20090826204701.GA31870@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

xfs_trans_iget is a wrapper for xfs_iget that adds the inode to the
transaction after it is read.  Except when the inode already is in the
inode cache, in which case it returns the existing locked inode with
increment lock recursion counts.

Now, no one in the tree every decrements these lock recursion counts,
so any user of this gets a potential double unlock when both the original
owner of the inode and the xfs_trans_iget caller unlock it.  When looking
back in a git bisect in the historic XFS tree there was only one place
that decremented these counts, xfs_trans_iput.  Introduced in commit
ca25df7a840f426eb566d52667b6950b92bb84b5 by Adam Sweeney in 1993,
and removed in commit 19f899a3ab155ff6a49c0c79b06f2f61059afaf3 by
Steve Lord in 2003.  And as long as it didn't slip through git bisects
cracks never actually used in that time frame.

A quick audit of the callers of xfs_trans_iget shows that no caller
really relies on this behaviour fortunately - xfs_ialloc allows this
inode from disk so it must not be there before, and all the RT allocator
routines only every add each RT bitmap inode once.

In addition to removing lots of code and reducing the size of the inode
item this patch also avoids the double inode cache lookup in each
create/mkdir/mknod transaction.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-26 14:14:32.113357904 -0300
+++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-26 14:15:40.613392686 -0300
@@ -456,32 +456,6 @@ out_error_or_again:
 	return error;
 }
 
-
-/*
- * Look for the inode corresponding to the given ino in the hash table.
- * If it is there and its i_transp pointer matches tp, return it.
- * Otherwise, return NULL.
- */
-xfs_inode_t *
-xfs_inode_incore(xfs_mount_t	*mp,
-		 xfs_ino_t	ino,
-		 xfs_trans_t	*tp)
-{
-	xfs_inode_t	*ip;
-	xfs_perag_t	*pag;
-
-	pag = xfs_get_perag(mp, ino);
-	read_lock(&pag->pag_ici_lock);
-	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ino));
-	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
-
-	/* the returned inode must match the transaction */
-	if (ip && (ip->i_transp != tp))
-		return NULL;
-	return ip;
-}
-
 /*
  * Decrement reference count of an inode structure and unlock it.
  *
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2009-08-26 14:14:32.121355431 -0300
+++ linux-2.6/fs/xfs/xfs_inode.h	2009-08-26 14:15:40.617361208 -0300
@@ -468,8 +468,6 @@ static inline void xfs_ifunlock(xfs_inod
 /*
  * xfs_iget.c prototypes.
  */
-xfs_inode_t	*xfs_inode_incore(struct xfs_mount *, xfs_ino_t,
-				  struct xfs_trans *);
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 			 uint, uint, xfs_inode_t **, xfs_daddr_t);
 void		xfs_iput(xfs_inode_t *, uint);
Index: linux-2.6/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode_item.c	2009-08-26 14:14:32.125355311 -0300
+++ linux-2.6/fs/xfs/xfs_inode_item.c	2009-08-26 14:15:40.617361208 -0300
@@ -712,8 +712,6 @@ xfs_inode_item_unlock(
 	 * Clear out the fields of the inode log item particular
 	 * to the current transaction.
 	 */
-	iip->ili_ilock_recur = 0;
-	iip->ili_iolock_recur = 0;
 	iip->ili_flags = 0;
 
 	/*
Index: linux-2.6/fs/xfs/xfs_inode_item.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode_item.h	2009-08-26 14:14:32.129361687 -0300
+++ linux-2.6/fs/xfs/xfs_inode_item.h	2009-08-26 14:15:40.621446924 -0300
@@ -137,8 +137,6 @@ typedef struct xfs_inode_log_item {
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
-	unsigned short		ili_ilock_recur;   /* lock recursion count */
-	unsigned short		ili_iolock_recur;  /* lock recursion count */
 	unsigned short		ili_flags;	   /* misc flags */
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
Index: linux-2.6/fs/xfs/xfs_trans_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_trans_inode.c	2009-08-26 14:15:45.689894519 -0300
+++ linux-2.6/fs/xfs/xfs_trans_inode.c	2009-08-26 14:17:14.434495492 -0300
@@ -49,30 +49,7 @@ xfs_trans_inode_broot_debug(
 
 
 /*
- * Get and lock the inode for the caller if it is not already
- * locked within the given transaction.  If it is already locked
- * within the transaction, just increment its lock recursion count
- * and return a pointer to it.
- *
- * For an inode to be locked in a transaction, the inode lock, as
- * opposed to the io lock, must be taken exclusively.  This ensures
- * that the inode can be involved in only 1 transaction at a time.
- * Lock recursion is handled on the io lock, but only for lock modes
- * of equal or lesser strength.  That is, you can recur on the io lock
- * held EXCL with a SHARED request but not vice versa.  Also, if
- * the inode is already a part of the transaction then you cannot
- * go from not holding the io lock to having it EXCL or SHARED.
- *
- * Use the inode cache routine xfs_inode_incore() to find the inode
- * if it is already owned by this transaction.
- *
- * If we don't already own the inode, use xfs_iget() to get it.
- * Since the inode log item structure is embedded in the incore
- * inode structure and is initialized when the inode is brought
- * into memory, there is nothing to do with it here.
- *
- * If the given transaction pointer is NULL, just call xfs_iget().
- * This simplifies code which must handle both cases.
+ * Get an inode and join it to the transaction.
  */
 int
 xfs_trans_iget(
@@ -84,62 +61,11 @@ xfs_trans_iget(
 	xfs_inode_t	**ipp)
 {
 	int			error;
-	xfs_inode_t		*ip;
-
-	/*
-	 * If the transaction pointer is NULL, just call the normal
-	 * xfs_iget().
-	 */
-	if (tp == NULL)
-		return xfs_iget(mp, NULL, ino, flags, lock_flags, ipp, 0);
-
-	/*
-	 * If we find the inode in core with this transaction
-	 * pointer in its i_transp field, then we know we already
-	 * have it locked.  In this case we just increment the lock
-	 * recursion count and return the inode to the caller.
-	 * Assert that the inode is already locked in the mode requested
-	 * by the caller.  We cannot do lock promotions yet, so
-	 * die if someone gets this wrong.
-	 */
-	if ((ip = xfs_inode_incore(tp->t_mountp, ino, tp)) != NULL) {
-		/*
-		 * Make sure that the inode lock is held EXCL and
-		 * that the io lock is never upgraded when the inode
-		 * is already a part of the transaction.
-		 */
-		ASSERT(ip->i_itemp != NULL);
-		ASSERT(lock_flags & XFS_ILOCK_EXCL);
-		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-		ASSERT((!(lock_flags & XFS_IOLOCK_EXCL)) ||
-		       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-		ASSERT((!(lock_flags & XFS_IOLOCK_EXCL)) ||
-		       (ip->i_itemp->ili_flags & XFS_ILI_IOLOCKED_EXCL));
-		ASSERT((!(lock_flags & XFS_IOLOCK_SHARED)) ||
-		       xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED));
-		ASSERT((!(lock_flags & XFS_IOLOCK_SHARED)) ||
-		       (ip->i_itemp->ili_flags & XFS_ILI_IOLOCKED_ANY));
-
-		if (lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) {
-			ip->i_itemp->ili_iolock_recur++;
-		}
-		if (lock_flags & XFS_ILOCK_EXCL) {
-			ip->i_itemp->ili_ilock_recur++;
-		}
-		*ipp = ip;
-		return 0;
-	}
-
-	ASSERT(lock_flags & XFS_ILOCK_EXCL);
-	error = xfs_iget(tp->t_mountp, tp, ino, flags, lock_flags, &ip, 0);
-	if (error) {
-		return error;
-	}
-	ASSERT(ip != NULL);
 
-	xfs_trans_ijoin(tp, ip, lock_flags);
-	*ipp = ip;
-	return 0;
+	error = xfs_iget(mp, tp, ino, flags, lock_flags, ipp, 0);
+	if (!error && tp)
+		xfs_trans_ijoin(tp, *ipp, lock_flags);
+	return error;
 }
 
 /*
@@ -163,8 +89,6 @@ xfs_trans_ijoin(
 		xfs_inode_item_init(ip, ip->i_mount);
 	iip = ip->i_itemp;
 	ASSERT(iip->ili_flags == 0);
-	ASSERT(iip->ili_ilock_recur == 0);
-	ASSERT(iip->ili_iolock_recur == 0);
 
 	/*
 	 * Get a log_item_desc to point at the new item.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
