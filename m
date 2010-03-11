Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMesep194278 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:40:54 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A4C51D2DEA5
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	96xjr7G8SX307qQa for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:25 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/19] xfs: fix mmap_sem/iolock inversion in xfs_free_eofblocks
Date: Fri, 12 Mar 2010 09:42:00 +1100
Message-Id: <1268347337-7160-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1268347337-7160-1-git-send-email-david@fromorbit.com>
References: <1268347337-7160-1-git-send-email-david@fromorbit.com>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

>From c56c9631cbe88f08854a56ff9776c1f310916830
Date: Mon, 19 Oct 2009 04:03:46 +0000
When xfs_free_eofblocks is called from ->release the VM might already
hold the mmap_sem, but in the write path we take the iolock before
taking the mmap_sem in the generic write code.

Switch xfs_free_eofblocks to only trylock the iolock if called from
->release and skip trimming the prellocated blocks in that case.
We'll still free them later on the final iput.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_rw.h       |    7 -------
 fs/xfs/xfs_vnodeops.c |   34 ++++++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_rw.h b/fs/xfs/xfs_rw.h
index f5e4874..726014d 100644
--- a/fs/xfs/xfs_rw.h
+++ b/fs/xfs/xfs_rw.h
@@ -37,13 +37,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
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
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 3fac146..d984014 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -709,6 +709,11 @@ xfs_fsync(
 }
 
 /*
+ * Flags for xfs_free_eofblocks
+ */
+#define XFS_FREE_EOF_TRYLOCK	(1<<0)
+
+/*
  * This is called by xfs_inactive to free any blocks beyond eof
  * when the link count isn't zero and by xfs_dm_punch_hole() when
  * punching a hole to EOF.
@@ -726,7 +731,6 @@ xfs_free_eofblocks(
 	xfs_filblks_t	map_len;
 	int		nimaps;
 	xfs_bmbt_irec_t	imap;
-	int		use_iolock = (flags & XFS_FREE_EOF_LOCK);
 
 	/*
 	 * Figure out if there are any blocks beyond the end
@@ -768,14 +772,19 @@ xfs_free_eofblocks(
 		 * cache and we can't
 		 * do that within a transaction.
 		 */
-		if (use_iolock)
+		if (flags & XFS_FREE_EOF_TRYLOCK) {
+			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+				xfs_trans_cancel(tp, 0);
+				return 0;
+			}
+		} else {
 			xfs_ilock(ip, XFS_IOLOCK_EXCL);
+		}
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
 				    ip->i_size);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
-			if (use_iolock)
-				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
 		}
 
@@ -812,8 +821,7 @@ xfs_free_eofblocks(
 			error = xfs_trans_commit(tp,
 						XFS_TRANS_RELEASE_LOG_RES);
 		}
-		xfs_iunlock(ip, (use_iolock ? (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)
-					    : XFS_ILOCK_EXCL));
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL);
 	}
 	return error;
 }
@@ -1113,7 +1121,17 @@ xfs_release(
 		     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
 		    (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+
+			/*
+			 * If we can't get the iolock just skip truncating
+			 * the blocks past EOF because we could deadlock
+			 * with the mmap_sem otherwise.  We'll get another
+			 * chance to drop them once the last reference to
+			 * the inode is dropped, so we'll never leak blocks
+			 * permanently.
+			 */
+			error = xfs_free_eofblocks(mp, ip,
+						   XFS_FREE_EOF_TRYLOCK);
 			if (error)
 				return error;
 		}
@@ -1184,7 +1202,7 @@ xfs_inactive(
 		     (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
 		      (ip->i_delayed_blks != 0)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+			error = xfs_free_eofblocks(mp, ip, 0);
 			if (error)
 				return VN_INACTIVE_CACHE;
 		}
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
