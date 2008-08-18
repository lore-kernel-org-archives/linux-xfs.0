Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Aug 2008 00:51:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7I7ooNQ011692
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2008 00:50:51 -0700
Message-ID: <48A92BC6.5020105@sgi.com>
Date: Mon, 18 Aug 2008 17:59:02 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Allocate inode tracing buffers before locking inode cluster
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Trying to allocate memory while holding the inode cluster locked can cause
deadlocks; a thread creating an inode will have the inode cluster locked
and is stuck allocating memory, pdflush/kswapd are both trying to push out
dirty pages and convert delayed allocations which need space in the log and
xfsaild is trying to push on the tail of the log but is stuck trying to
acquire the inode cluster lock.

I tried fixing this with KM_NOFS but turned a two-way deadlock into a
three-way deadlock.  This patch moves the allocation of the inode tracing
buffers before we lock the inode cluster.  We can also leak memory because
we don't free these allocations if we return from this function early so
use xfs_idestroy() to fully clean up the inode first.

Lachlan

--- a/fs/xfs/xfs_inode.c	2008-08-18 17:40:42.000000000 +1000
+++ b/fs/xfs/xfs_inode.c	2008-08-15 12:05:14.000000000 +1000
@@ -818,19 +818,6 @@ xfs_iread(
 	spin_lock_init(&ip->i_flags_lock);
 
 	/*
-	 * Get pointer's to the on-disk inode and the buffer containing it.
-	 * If the inode number refers to a block outside the file system
-	 * then xfs_itobp() will return NULL.  In this case we should
-	 * return NULL as well.  Set i_blkno to 0 so that xfs_itobp() will
-	 * know that this is a new incore inode.
-	 */
-	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, imap_flags, XFS_BUF_LOCK);
-	if (error) {
-		kmem_zone_free(xfs_inode_zone, ip);
-		return error;
-	}
-
-	/*
 	 * Initialize inode's trace buffers.
 	 * Do this before xfs_iformat in case it adds entries.
 	 */
@@ -854,11 +841,24 @@ xfs_iread(
 #endif
 
 	/*
+	 * Get pointer's to the on-disk inode and the buffer containing it.
+	 * If the inode number refers to a block outside the file system
+	 * then xfs_itobp() will return NULL.  In this case we should
+	 * return NULL as well.  Set i_blkno to 0 so that xfs_itobp() will
+	 * know that this is a new incore inode.
+	 */
+	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, imap_flags, XFS_BUF_LOCK);
+	if (error) {
+		xfs_idestroy(ip);
+		return error;
+	}
+
+	/*
 	 * If we got something that isn't an inode it means someone
 	 * (nfs or dmi) has a stale handle.
 	 */
 	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC) {
-		kmem_zone_free(xfs_inode_zone, ip);
+		xfs_idestroy(ip);
 		xfs_trans_brelse(tp, bp);
 #ifdef DEBUG
 		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
@@ -881,7 +881,7 @@ xfs_iread(
 		xfs_dinode_from_disk(&ip->i_d, &dip->di_core);
 		error = xfs_iformat(ip, dip);
 		if (error)  {
-			kmem_zone_free(xfs_inode_zone, ip);
+			xfs_idestroy(ip);
 			xfs_trans_brelse(tp, bp);
 #ifdef DEBUG
 			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
