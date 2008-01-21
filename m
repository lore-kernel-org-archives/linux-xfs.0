Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 20:59:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L4xRK0013170
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:59:31 -0800
Date: Mon, 21 Jan 2008 15:59:39 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch] Don't block pdflush when flushing inodes V2
Message-ID: <20080121045939.GD155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

When pdflush is writing back inodes, it can get stuck on inode cluster
buffers that are currently under I/O. This occurs when we write data to
multiple inodes in the same inode cluster at the same time.

Effectively, delayed allocation marks the inode dirty during the data
writeback. Hence if the inode cluster was flushed during the writeback
of the first inode, the writeback of the second inode will block waiting
for the inode cluster write to complete before writing it again for the
newly dirtied inode.

Basically, we want to avoid this from happening so we don't block
pdflush and slow down all of writeback. Hence we introduce a
non-blocking async inode flush flag that pdflush uses. If this flag is
set, we use non-blocking operations (e.g. try locks) whereever we can
to avoid blocking or extra I/O being issued.

Version 2:
- kill xfs_itobp_flags() and just add a parameter to xfs_itobp
- remove superfluous buf_flags == 0 check.
- remove unneed parenthesis from comparison
- introduce xfs_iunpin_nowait() for triggering a log flush to
  unpin the inode but not to wait for it.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    3 
 fs/xfs/linux-2.6/xfs_vnode.h |    5 -
 fs/xfs/xfs_inode.c           |  135 ++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_inode.h           |    3 
 fs/xfs/xfs_log_recover.c     |    3 
 fs/xfs/xfs_trans_buf.c       |    3 
 fs/xfs/xfs_vnodeops.c        |   55 +++--------------
 7 files changed, 103 insertions(+), 104 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-01-21 15:35:39.980364728 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-01-21 15:44:22.397197239 +1100
@@ -145,11 +145,16 @@ xfs_imap_to_bp(
 	xfs_buf_t	*bp;
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-				   (int)imap->im_len, XFS_BUF_LOCK, &bp);
+				   (int)imap->im_len, buf_flags, &bp);
 	if (error) {
-		cmn_err(CE_WARN, "xfs_imap_to_bp: xfs_trans_read_buf()returned "
+		if (error != EAGAIN) {
+			cmn_err(CE_WARN,
+				"xfs_imap_to_bp: xfs_trans_read_buf()returned "
 				"an error %d on %s.  Returning error.",
 				error, mp->m_fsname);
+		} else {
+			ASSERT(buf_flags & XFS_BUF_TRYLOCK);
+		}
 		return error;
 	}
 
@@ -274,7 +279,8 @@ xfs_itobp(
 	xfs_dinode_t	**dipp,
 	xfs_buf_t	**bpp,
 	xfs_daddr_t	bno,
-	uint		imap_flags)
+	uint		imap_flags,
+	uint		buf_flags)
 {
 	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
@@ -305,10 +311,17 @@ xfs_itobp(
 	}
 	ASSERT(bno == 0 || bno == imap.im_blkno);
 
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, buf_flags, imap_flags);
 	if (error)
 		return error;
 
+	if (!bp) {
+		ASSERT(buf_flags & XFS_BUF_TRYLOCK);
+		ASSERT(tp == NULL);
+		*bpp = NULL;
+		return EAGAIN;
+	}
+
 	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
 	*bpp = bp;
 	return 0;
@@ -812,7 +825,7 @@ xfs_iread(
 	 * return NULL as well.  Set i_blkno to 0 so that xfs_itobp() will
 	 * know that this is a new incore inode.
 	 */
-	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, imap_flags);
+	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, imap_flags, XFS_BUF_LOCK);
 	if (error) {
 		kmem_zone_free(xfs_inode_zone, ip);
 		return error;
@@ -1901,7 +1914,7 @@ xfs_iunlink(
 		 * Here we put the head pointer into our next pointer,
 		 * and then we fall through to point the head at us.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
 		if (error)
 			return error;
 
@@ -2009,7 +2022,7 @@ xfs_iunlink_remove(
 		 * of dealing with the buffer when there is no need to
 		 * change it.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
 		if (error) {
 			cmn_err(CE_WARN,
 				"xfs_iunlink_remove: xfs_itobp()  returned an error %d on %s.  Returning error.",
@@ -2071,7 +2084,7 @@ xfs_iunlink_remove(
 		 * Now last_ibp points to the buffer previous to us on
 		 * the unlinked list.  Pull us from the list.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
 		if (error) {
 			cmn_err(CE_WARN,
 				"xfs_iunlink_remove: xfs_itobp()  returned an error %d on %s.  Returning error.",
@@ -2334,7 +2347,7 @@ xfs_ifree(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, 0, 0);
+	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
 	if (error)
 		return error;
 
@@ -2777,38 +2790,41 @@ xfs_iunpin(
 }
 
 /*
- * This is called to wait for the given inode to be unpinned.
- * It will sleep until this happens.  The caller must have the
- * inode locked in at least shared mode so that the buffer cannot
- * be subsequently pinned once someone is waiting for it to be
- * unpinned.
+ * This is called to unpin an inode. It can be directed to wait or to return
+ * immediately without waiting for the inode to be unpinned.  The caller must
+ * have the inode locked in at least shared mode so that the buffer cannot be
+ * subsequently pinned once someone is waiting for it to be unpinned.
  */
 STATIC void
-xfs_iunpin_wait(
-	xfs_inode_t	*ip)
+__xfs_iunpin_wait(
+	xfs_inode_t	*ip,
+	int		wait)
 {
-	xfs_inode_log_item_t	*iip;
-	xfs_lsn_t	lsn;
+	xfs_inode_log_item_t	*iip = ip->i_itemp;
 
 	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE | MR_ACCESS));
-
-	if (atomic_read(&ip->i_pincount) == 0) {
+	if (atomic_read(&ip->i_pincount) == 0)
 		return;
-	}
 
-	iip = ip->i_itemp;
-	if (iip && iip->ili_last_lsn) {
-		lsn = iip->ili_last_lsn;
-	} else {
-		lsn = (xfs_lsn_t)0;
-	}
+	/* Give the log a push to start the unpinning I/O */
+	xfs_log_force(ip->i_mount, (iip && iip->ili_last_lsn) ?
+				iip->ili_last_lsn : 0, XFS_LOG_FORCE);
+	if (wait)
+		wait_event(ip->i_ipin_wait, (atomic_read(&ip->i_pincount) == 0));
+}
 
-	/*
-	 * Give the log a push so we don't wait here too long.
-	 */
-	xfs_log_force(ip->i_mount, lsn, XFS_LOG_FORCE);
+static inline void
+xfs_iunpin_wait(
+	xfs_inode_t	*ip)
+{
+	__xfs_iunpin_wait(ip, 1);
+}
 
-	wait_event(ip->i_ipin_wait, (atomic_read(&ip->i_pincount) == 0));
+static inline void
+xfs_iunpin_nowait(
+	xfs_inode_t	*ip)
+{
+	__xfs_iunpin_wait(ip, 0);
 }
 
 
@@ -3003,6 +3019,7 @@ xfs_iflush(
 	int			bufwasdelwri;
 	struct hlist_node	*entry;
 	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
+	int			noblock = (flags == XFS_IFLUSH_ASYNC_NOBLOCK);
 
 	XFS_STATS_INC(xs_iflush_count);
 
@@ -3027,11 +3044,21 @@ xfs_iflush(
 	}
 
 	/*
-	 * We can't flush the inode until it is unpinned, so
-	 * wait for it.  We know noone new can pin it, because
-	 * we are holding the inode lock shared and you need
-	 * to hold it exclusively to pin the inode.
+	 * We can't flush the inode until it is unpinned, so wait for it if we
+	 * are allowed to block.  We know noone new can pin it, because we are
+	 * holding the inode lock shared and you need to hold it exclusively to
+	 * pin the inode.
+	 *
+	 * If we are not allowed to block, force the log out asynchronously so
+	 * that when we come back the inode will be unpinned. If other inodes
+	 * in the same cluster are dirty, they will probably write the inode
+	 * out for us if they occur after the log force completes.
 	 */
+	if (noblock && xfs_ipincount(ip)) {
+		xfs_iunpin_nowait(ip);
+		xfs_ifunlock(ip);
+		return EAGAIN;
+	}
 	xfs_iunpin_wait(ip);
 
 	/*
@@ -3048,15 +3075,6 @@ xfs_iflush(
 	}
 
 	/*
-	 * Get the buffer containing the on-disk inode.
-	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &bp, 0, 0);
-	if (error) {
-		xfs_ifunlock(ip);
-		return error;
-	}
-
-	/*
 	 * Decide how buffer will be flushed out.  This is done before
 	 * the call to xfs_iflush_int because this field is zeroed by it.
 	 */
@@ -3072,6 +3090,7 @@ xfs_iflush(
 		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
 			flags = 0;
 			break;
+		case XFS_IFLUSH_ASYNC_NOBLOCK:
 		case XFS_IFLUSH_ASYNC:
 		case XFS_IFLUSH_DELWRI_ELSE_ASYNC:
 			flags = INT_ASYNC;
@@ -3091,6 +3110,7 @@ xfs_iflush(
 		case XFS_IFLUSH_DELWRI:
 			flags = INT_DELWRI;
 			break;
+		case XFS_IFLUSH_ASYNC_NOBLOCK:
 		case XFS_IFLUSH_ASYNC:
 			flags = INT_ASYNC;
 			break;
@@ -3105,6 +3125,16 @@ xfs_iflush(
 	}
 
 	/*
+	 * Get the buffer containing the on-disk inode.
+	 */
+	error = xfs_itobp(mp, NULL, ip, &dip, &bp, 0, 0,
+				noblock ? XFS_BUF_TRYLOCK : XFS_BUF_LOCK);
+	if (error || !bp) {
+		xfs_ifunlock(ip);
+		return error;
+	}
+
+	/*
 	 * First flush out the inode that xfs_iflush was called with.
 	 */
 	error = xfs_iflush_int(ip, bp);
@@ -3113,6 +3143,13 @@ xfs_iflush(
 	}
 
 	/*
+	 * If the buffer is pinned then push on the log now so we won't
+	 * get stuck waiting in the write for too long.
+	 */
+	if (XFS_BUF_ISPINNED(bp))
+		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
+
+	/*
 	 * inode clustering:
 	 * see if other inodes can be gathered into this write
 	 */
@@ -3181,14 +3218,6 @@ xfs_iflush(
 		XFS_STATS_ADD(xs_icluster_flushinode, clcount);
 	}
 
-	/*
-	 * If the buffer is pinned then push on the log so we won't
-	 * get stuck waiting in the write for too long.
-	 */
-	if (XFS_BUF_ISPINNED(bp)){
-		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-	}
-
 	if (flags & INT_DELWRI) {
 		xfs_bdwrite(mp, bp);
 	} else if (flags & INT_ASYNC) {
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2008-01-21 15:19:50.582375528 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2008-01-21 15:44:33.275799218 +1100
@@ -461,6 +461,7 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
 #define	XFS_IFLUSH_SYNC			3
 #define	XFS_IFLUSH_ASYNC		4
 #define	XFS_IFLUSH_DELWRI		5
+#define	XFS_IFLUSH_ASYNC_NOBLOCK	6
 
 /*
  * Flags for xfs_itruncate_start().
@@ -515,7 +516,7 @@ int		xfs_finish_reclaim_all(struct xfs_m
  */
 int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
 			  xfs_inode_t *, struct xfs_dinode **, struct xfs_buf **,
-			  xfs_daddr_t, uint);
+			  xfs_daddr_t, uint, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 			  xfs_inode_t **, xfs_daddr_t, uint);
 int		xfs_iread_extents(struct xfs_trans *, xfs_inode_t *, int);
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2008-01-21 15:19:50.582375528 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2008-01-21 15:38:51.287765170 +1100
@@ -898,7 +898,8 @@ xfs_fs_write_inode(
 	struct inode		*inode,
 	int			sync)
 {
-	int			error = 0, flags = FLUSH_INODE;
+	int			error = 0;
+	int			flags = 0;
 
 	xfs_itrace_entry(XFS_I(inode));
 	if (sync) {
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-01-21 15:19:50.582375528 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.h	2008-01-21 15:38:51.287765170 +1100
@@ -73,12 +73,9 @@ typedef enum bhv_vrwlock {
 #define IO_INVIS	0x00020		/* don't update inode timestamps */
 
 /*
- * Flags for vop_iflush call
+ * Flags for xfs_inode_flush
  */
 #define FLUSH_SYNC		1	/* wait for flush to complete	*/
-#define FLUSH_INODE		2	/* flush the inode itself	*/
-#define FLUSH_LOG		4	/* force the last log entry for
-					 * this inode out to disk	*/
 
 /*
  * Flush/Invalidate options for vop_toss/flush/flushinval_pages.
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2008-01-21 15:19:50.594373988 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2008-01-21 15:38:51.299763628 +1100
@@ -3504,29 +3504,6 @@ xfs_inode_flush(
 	    ((iip == NULL) || !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)))
 		return 0;
 
-	if (flags & FLUSH_LOG) {
-		if (iip && iip->ili_last_lsn) {
-			xlog_t		*log = mp->m_log;
-			xfs_lsn_t	sync_lsn;
-			int		log_flags = XFS_LOG_FORCE;
-
-			spin_lock(&log->l_grant_lock);
-			sync_lsn = log->l_last_sync_lsn;
-			spin_unlock(&log->l_grant_lock);
-
-			if ((XFS_LSN_CMP(iip->ili_last_lsn, sync_lsn) > 0)) {
-				if (flags & FLUSH_SYNC)
-					log_flags |= XFS_LOG_SYNC;
-				error = xfs_log_force(mp, iip->ili_last_lsn, log_flags);
-				if (error)
-					return error;
-			}
-
-			if (ip->i_update_core == 0)
-				return 0;
-		}
-	}
-
 	/*
 	 * We make this non-blocking if the inode is contended,
 	 * return EAGAIN to indicate to the caller that they
@@ -3534,30 +3511,22 @@ xfs_inode_flush(
 	 * blocking on inodes inside another operation right
 	 * now, they get caught later by xfs_sync.
 	 */
-	if (flags & FLUSH_INODE) {
-		int	flush_flags;
-
-		if (flags & FLUSH_SYNC) {
-			xfs_ilock(ip, XFS_ILOCK_SHARED);
-			xfs_iflock(ip);
-		} else if (xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
-			if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip)) {
-				xfs_iunlock(ip, XFS_ILOCK_SHARED);
-				return EAGAIN;
-			}
-		} else {
+	if (flags & FLUSH_SYNC) {
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		xfs_iflock(ip);
+	} else if (xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
+		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip)) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 			return EAGAIN;
 		}
-
-		if (flags & FLUSH_SYNC)
-			flush_flags = XFS_IFLUSH_SYNC;
-		else
-			flush_flags = XFS_IFLUSH_ASYNC;
-
-		error = xfs_iflush(ip, flush_flags);
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	} else {
+		return EAGAIN;
 	}
 
+	error = xfs_iflush(ip, (flags & FLUSH_SYNC) ? XFS_IFLUSH_SYNC
+						    : XFS_IFLUSH_ASYNC_NOBLOCK);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
 	return error;
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_buf.c	2008-01-21 15:19:50.610371934 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_buf.c	2008-01-21 15:38:51.299763628 +1100
@@ -304,7 +304,8 @@ xfs_trans_read_buf(
 	if (tp == NULL) {
 		bp = xfs_buf_read_flags(target, blkno, len, flags | BUF_BUSY);
 		if (!bp)
-			return XFS_ERROR(ENOMEM);
+			return (flags & XFS_BUF_TRYLOCK) ?
+					EAGAIN : XFS_ERROR(ENOMEM);
 
 		if ((bp != NULL) && (XFS_BUF_GETERROR(bp) != 0)) {
 			xfs_ioerror_alert("xfs_trans_read_buf", mp,
Index: 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_recover.c	2008-01-16 16:24:02.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c	2008-01-21 15:49:42.440069284 +1100
@@ -3214,7 +3214,8 @@ xlog_recover_process_iunlinks(
 					 * next inode in the bucket.
 					 */
 					error = xfs_itobp(mp, NULL, ip, &dip,
-							&ibp, 0, 0);
+							&ibp, 0, 0,
+							XFS_BUF_LOCK);
 					ASSERT(error || (dip != NULL));
 				}
 
