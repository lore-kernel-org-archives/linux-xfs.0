Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01MjXsq000361 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 16:45:33 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BBC6586BF
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 14:45:31 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 2BZuDeHFHnOwC5AW for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 14:45:31 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 6C48AAC6273
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 16:45:32 -0600 (CST)
Message-ID: <495D478B.9080702@sandeen.net>
Date: Thu, 01 Jan 2009 16:45:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove flags param from xfs_free_eofblocks
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

Remove unused XFS_FREE_EOF_NOLOCK and make XFS_FREE_EOF_LOCK default.

XFS_FREE_EOF_NOLOCK is never used, so remove it, make
XFS_FREE_EOF_LOCK the only behavior, and remove the
flags parameters.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs/fs/xfs/xfs_rw.h
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.h
+++ xfs/fs/xfs/xfs_rw.h
@@ -37,13 +37,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
 }
 
 /*
- * Flags for xfs_free_eofblocks
- */
-#define XFS_FREE_EOF_LOCK	(1<<0)
-#define XFS_FREE_EOF_NOLOCK	(1<<1)
-
-
-/*
  * helper function to extract extent size hint from inode
  */
 STATIC_INLINE xfs_extlen_t
@@ -81,7 +74,6 @@ extern void xfs_ioerror_alert(char *func
 /*
  * Prototypes for functions in xfs_vnodeops.c.
  */
-extern int xfs_free_eofblocks(struct xfs_mount *mp, struct xfs_inode *ip,
-			int flags);
+extern int xfs_free_eofblocks(struct xfs_mount *mp, struct xfs_inode *ip);
 
 #endif /* __XFS_RW_H__ */
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c
+++ xfs/fs/xfs/xfs_vnodeops.c
@@ -814,8 +814,7 @@ xfs_fsync(
 int
 xfs_free_eofblocks(
 	xfs_mount_t	*mp,
-	xfs_inode_t	*ip,
-	int		flags)
+	xfs_inode_t	*ip)
 {
 	xfs_trans_t	*tp;
 	int		error;
@@ -824,7 +823,6 @@ xfs_free_eofblocks(
 	xfs_filblks_t	map_len;
 	int		nimaps;
 	xfs_bmbt_irec_t	imap;
-	int		use_iolock = (flags & XFS_FREE_EOF_LOCK);
 
 	/*
 	 * Figure out if there are any blocks beyond the end
@@ -865,14 +863,12 @@ xfs_free_eofblocks(
 		 * cache and we can't
 		 * do that within a transaction.
 		 */
-		if (use_iolock)
-			xfs_ilock(ip, XFS_IOLOCK_EXCL);
+		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
 				    ip->i_size);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
-			if (use_iolock)
-				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
 		}
 
@@ -909,8 +905,7 @@ xfs_free_eofblocks(
 			error = xfs_trans_commit(tp,
 						XFS_TRANS_RELEASE_LOG_RES);
 		}
-		xfs_iunlock(ip, (use_iolock ? (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)
-					    : XFS_ILOCK_EXCL));
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL);
 	}
 	return error;
 }
@@ -1204,7 +1199,7 @@ xfs_release(
 		     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
 		    (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+			error = xfs_free_eofblocks(mp, ip);
 			if (error)
 				return error;
 		}
@@ -1275,7 +1270,7 @@ xfs_inactive(
 		     (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
 		      (ip->i_delayed_blks != 0)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+			error = xfs_free_eofblocks(mp, ip);
 			if (error)
 				return VN_INACTIVE_CACHE;
 		}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
