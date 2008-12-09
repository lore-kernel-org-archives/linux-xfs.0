Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB99m2fc012823 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 03:48:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE47973A
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2008 01:48:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4vfnu5lveay3phHE for
	<xfs@oss.sgi.com>; Tue, 09 Dec 2008 01:48:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L9zCD-0005W0-Ar
	for xfs@oss.sgi.com; Tue, 09 Dec 2008 09:48:01 +0000
Message-Id: <20081209094801.249246000@bombadil.infradead.org>
References: <20081209094729.939583000@bombadil.infradead.org>
Date: Tue, 09 Dec 2008 04:47:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 2/5] simplify projid check in xfs_rename
Content-Disposition: inline; filename=xfs-rename-projid-check
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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


Check for the project ID after attaching all inodes to the transaction.
That way the unlock in the error case is done by the transaction subsystem,
which guaratees that is uses the right flags (which was wrong from day one
of this check), and avoids having special code unlocking an array of inodes
with potential duplicates.  Attaching the inode first is the method used
by xfs_rename and the other namespace methods all other error that require
multiple locked inodes.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>

Index: xfs/fs/xfs/xfs_rename.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rename.c	2008-12-03 23:26:34.000000000 +0100
+++ xfs/fs/xfs/xfs_rename.c	2008-12-03 23:29:09.000000000 +0100
@@ -42,31 +42,6 @@
 
 
 /*
- * Given an array of up to 4 inode pointers, unlock the pointed to inodes.
- * If there are fewer than 4 entries in the array, the empty entries will
- * be at the end and will have NULL pointers in them.
- */
-STATIC void
-xfs_rename_unlock4(
-	xfs_inode_t	**i_tab,
-	uint		lock_mode)
-{
-	int	i;
-
-	xfs_iunlock(i_tab[0], lock_mode);
-	for (i = 1; i < 4; i++) {
-		if (i_tab[i] == NULL)
-			break;
-
-		/*
-		 * Watch out for duplicate entries in the table.
-		 */
-		if (i_tab[i] != i_tab[i-1])
-			xfs_iunlock(i_tab[i], lock_mode);
-	}
-}
-
-/*
  * Enter all inodes for a rename transaction into a sorted array.
  */
 STATIC void
@@ -205,19 +180,6 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * If we are using project inheritance, we only allow renames
-	 * into our tree when the project IDs are the same; else the
-	 * tree quota mechanism would be circumvented.
-	 */
-	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
-		error = XFS_ERROR(EXDEV);
-		xfs_rename_unlock4(inodes, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(tp, cancel_flags);
-		goto std_return;
-	}
-
-	/*
 	 * Join all the inodes to the transaction. From this point on,
 	 * we can rely on either trans_commit or trans_cancel to unlock
 	 * them.  Note that we need to add a vnode reference to the
@@ -242,6 +204,17 @@ xfs_rename(
 	}
 
 	/*
+	 * If we are using project inheritance, we only allow renames
+	 * into our tree when the project IDs are the same; else the
+	 * tree quota mechanism would be circumvented.
+	 */
+	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+		     (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
+		error = XFS_ERROR(EXDEV);
+		goto error_return;
+	}
+
+	/*
 	 * Set up the target.
 	 */
 	if (target_ip == NULL) {

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
