Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 20:14:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A3DYsb016384
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 20:13:37 -0700
Date: Thu, 10 Apr 2008 13:14:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] ensure inodes are joined in xfs_itruncate_finish
Message-ID: <20080410031405.GR108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On success, we still need to join the inode to the current
transaction in xfs_itruncate_finish(). Fixes regression from
error handling changes.

Note that this does some comment reformatting (to wrap at
80 columns) for comments that were modified.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_inode.c |  149 +++++++++++++++++++++++++----------------------------
 1 file changed, 71 insertions(+), 78 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-04-10 11:02:38.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-04-10 12:27:43.005660375 +1000
@@ -1464,51 +1464,50 @@ xfs_itruncate_start(
 }
 
 /*
- * Shrink the file to the given new_size.  The new
- * size must be smaller than the current size.
- * This will free up the underlying blocks
- * in the removed range after a call to xfs_itruncate_start()
- * or xfs_atruncate_start().
- *
- * The transaction passed to this routine must have made
- * a permanent log reservation of at least XFS_ITRUNCATE_LOG_RES.
- * This routine may commit the given transaction and
- * start new ones, so make sure everything involved in
- * the transaction is tidy before calling here.
- * Some transaction will be returned to the caller to be
- * committed.  The incoming transaction must already include
- * the inode, and both inode locks must be held exclusively.
- * The inode must also be "held" within the transaction.  On
- * return the inode will be "held" within the returned transaction.
- * This routine does NOT require any disk space to be reserved
- * for it within the transaction.
- *
- * The fork parameter must be either xfs_attr_fork or xfs_data_fork,
- * and it indicates the fork which is to be truncated.  For the
- * attribute fork we only support truncation to size 0.
- *
- * We use the sync parameter to indicate whether or not the first
- * transaction we perform might have to be synchronous.  For the attr fork,
- * it needs to be so if the unlink of the inode is not yet known to be
- * permanent in the log.  This keeps us from freeing and reusing the
- * blocks of the attribute fork before the unlink of the inode becomes
- * permanent.
- *
- * For the data fork, we normally have to run synchronously if we're
- * being called out of the inactive path or we're being called
- * out of the create path where we're truncating an existing file.
- * Either way, the truncate needs to be sync so blocks don't reappear
- * in the file with altered data in case of a crash.  wsync filesystems
- * can run the first case async because anything that shrinks the inode
- * has to run sync so by the time we're called here from inactive, the
- * inode size is permanently set to 0.
- *
- * Calls from the truncate path always need to be sync unless we're
- * in a wsync filesystem and the file has already been unlinked.
- *
- * The caller is responsible for correctly setting the sync parameter.
- * It gets too hard for us to guess here which path we're being called
- * out of just based on inode state.
+ * Shrink the file to the given new_size.  The new size must be smaller than
+ * the current size.  This will free up the underlying blocks in the removed
+ * range after a call to xfs_itruncate_start() or xfs_atruncate_start().
+ *
+ * The transaction passed to this routine must have made a permanent log
+ * reservation of at least XFS_ITRUNCATE_LOG_RES.  This routine may commit the
+ * given transaction and start new ones, so make sure everything involved in
+ * the transaction is tidy before calling here.  Some transaction will be
+ * returned to the caller to be committed.  The incoming transaction must
+ * already include the inode, and both inode locks must be held exclusively.
+ * The inode must also be "held" within the transaction.  On return the inode
+ * will be "held" within the returned transaction.  This routine does NOT
+ * require any disk space to be reserved for it within the transaction.
+ *
+ * The fork parameter must be either xfs_attr_fork or xfs_data_fork, and it
+ * indicates the fork which is to be truncated.  For the attribute fork we only
+ * support truncation to size 0.
+ *
+ * We use the sync parameter to indicate whether or not the first transaction
+ * we perform might have to be synchronous.  For the attr fork, it needs to be
+ * so if the unlink of the inode is not yet known to be permanent in the log.
+ * This keeps us from freeing and reusing the blocks of the attribute fork
+ * before the unlink of the inode becomes permanent.
+ *
+ * For the data fork, we normally have to run synchronously if we're being
+ * called out of the inactive path or we're being called out of the create path
+ * where we're truncating an existing file.  Either way, the truncate needs to
+ * be sync so blocks don't reappear in the file with altered data in case of a
+ * crash.  wsync filesystems can run the first case async because anything that
+ * shrinks the inode has to run sync so by the time we're called here from
+ * inactive, the inode size is permanently set to 0.
+ *
+ * Calls from the truncate path always need to be sync unless we're in a wsync
+ * filesystem and the file has already been unlinked.
+ *
+ * The caller is responsible for correctly setting the sync parameter.  It gets
+ * too hard for us to guess here which path we're being called out of just
+ * based on inode state.
+ *
+ * If we get an error, we must return with the inode locked and linked into the
+ * current transaction. This keeps things simple for the higher level code,
+ * because it always knows that the inode is locked and held in the transaction
+ * that returns to it whether errors occur or not.  We don't mark the inode
+ * dirty on error so that transactions can be easily aborted if possible.
  */
 int
 xfs_itruncate_finish(
@@ -1687,45 +1686,51 @@ xfs_itruncate_finish(
 		 */
 		error = xfs_bmap_finish(tp, &free_list, &committed);
 		ntp = *tp;
+		if (committed) {
+			/* link the inode into the next xact in the chain */
+			xfs_trans_ijoin(ntp, ip,
+					XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+			xfs_trans_ihold(ntp, ip);
+		}
+
 		if (error) {
 			/*
-			 * If the bmap finish call encounters an error,
-			 * return to the caller where the transaction
-			 * can be properly aborted.  We just need to
-			 * make sure we're not holding any resources
-			 * that we were not when we came in.
+			 * If the bmap finish call encounters an error, return
+			 * to the caller where the transaction can be properly
+			 * aborted.  We just need to make sure we're not
+			 * holding any resources that we were not when we came
+			 * in.
 			 *
-			 * Aborting from this point might lose some
-			 * blocks in the file system, but oh well.
+			 * Aborting from this point might lose some blocks in
+			 * the file system, but oh well.
 			 */
 			xfs_bmap_cancel(&free_list);
-			if (committed)
-				goto error_join;
 			return error;
 		}
 
 		if (committed) {
 			/*
-			 * The first xact was committed, so add the inode to
-			 * the new one.  Mark it dirty so it will be logged and
+			 * Mark the inode dirty so it will be logged and
 			 * moved forward in the log as part of every commit.
 			 */
-			xfs_trans_ijoin(ntp, ip,
-					XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-			xfs_trans_ihold(ntp, ip);
 			xfs_trans_log_inode(ntp, ip, XFS_ILOG_CORE);
 		}
+
 		ntp = xfs_trans_dup(ntp);
 		error = xfs_trans_commit(*tp, 0);
 		*tp = ntp;
-		if (error)
-			goto error_join;
-		error = xfs_trans_reserve(ntp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-					  XFS_TRANS_PERM_LOG_RES,
-					  XFS_ITRUNCATE_LOG_COUNT);
-		if (error)
-			goto error_join;
 
+		/* link the inode into the next transaction in the chain */
+		xfs_trans_ijoin(ntp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+		xfs_trans_ihold(ntp, ip);
+
+		if (!error)
+			error = xfs_trans_reserve(ntp, 0,
+					XFS_ITRUNCATE_LOG_RES(mp), 0,
+					XFS_TRANS_PERM_LOG_RES,
+					XFS_ITRUNCATE_LOG_COUNT);
+		if (error)
+			return error;
 	}
 	/*
 	 * Only update the size in the case of the data fork, but
@@ -1757,18 +1762,6 @@ xfs_itruncate_finish(
 	       (ip->i_d.di_nextents == 0));
 	xfs_itrunc_trace(XFS_ITRUNC_FINISH2, ip, 0, new_size, 0, 0);
 	return 0;
-
-error_join:
-	/*
-	 * Add the inode being truncated to the next chained transaction.  This
-	 * keeps things simple for the higher level code, because it always
-	 * knows that the inode is locked and held in the transaction that
-	 * returns to it whether errors occur or not.  We don't mark the inode
-	 * dirty so that this transaction can be easily aborted if possible.
-	 */
-	xfs_trans_ijoin(ntp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_trans_ihold(ntp, ip);
-	return error;
 }
 
 
