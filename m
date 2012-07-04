Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64FEjkP223592 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 10:14:45 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	9A1DrJTFGsxHQKrl (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 08:14:44 -0700 (PDT)
Message-Id: <20120704151444.136872347@bombadil.infradead.org>
Date: Wed, 04 Jul 2012 11:13:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/5] xfs: avoid the iolock in xfs_free_eofblocks for evicted
	inodes
References: <20120704151328.928543446@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dont-hold-iolock-during-eviction-2
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
Cc: sage@newdream.net

Same rational as the last patch - these inodes are not reachable, so
don't bother with locking.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_vnodeops.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2012-07-04 09:51:03.913705064 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2012-07-04 09:57:07.987036223 +0200
@@ -146,11 +146,6 @@ xfs_readlink(
 }
 
 /*
- * Flags for xfs_free_eofblocks
- */
-#define XFS_FREE_EOF_TRYLOCK	(1<<0)
-
-/*
  * This is called by xfs_inactive to free any blocks beyond eof
  * when the link count isn't zero and by xfs_dm_punch_hole() when
  * punching a hole to EOF.
@@ -159,7 +154,7 @@ STATIC int
 xfs_free_eofblocks(
 	xfs_mount_t	*mp,
 	xfs_inode_t	*ip,
-	int		flags)
+	bool		need_iolock)
 {
 	xfs_trans_t	*tp;
 	int		error;
@@ -201,13 +196,11 @@ xfs_free_eofblocks(
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
 
-		if (flags & XFS_FREE_EOF_TRYLOCK) {
+		if (need_iolock) {
 			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 				xfs_trans_cancel(tp, 0);
 				return 0;
 			}
-		} else {
-			xfs_ilock(ip, XFS_IOLOCK_EXCL);
 		}
 
 		error = xfs_trans_reserve(tp, 0,
@@ -217,7 +210,8 @@ xfs_free_eofblocks(
 		if (error) {
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
 			xfs_trans_cancel(tp, 0);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+			if (need_iolock)
+				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
 		}
 
@@ -244,7 +238,10 @@ xfs_free_eofblocks(
 			error = xfs_trans_commit(tp,
 						XFS_TRANS_RELEASE_LOG_RES);
 		}
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL);
+
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (need_iolock)
+			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	}
 	return error;
 }
@@ -466,8 +463,7 @@ xfs_release(
 		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
 			return 0;
 
-		error = xfs_free_eofblocks(mp, ip,
-					   XFS_FREE_EOF_TRYLOCK);
+		error = xfs_free_eofblocks(mp, ip, true);
 		if (error)
 			return error;
 
@@ -524,7 +520,7 @@ xfs_inactive(
 		    (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
 		     ip->i_delayed_blks != 0))) {
-			error = xfs_free_eofblocks(mp, ip, 0);
+			error = xfs_free_eofblocks(mp, ip, false);
 			if (error)
 				return VN_INACTIVE_CACHE;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
