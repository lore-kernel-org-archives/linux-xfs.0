Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3MgjLw024964 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 16:42:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A11F16879B7
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 14:42:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3Fq3AdvubBPN0X1q for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 14:42:44 -0800 (PST)
Date: Wed, 3 Dec 2008 17:42:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.27.7 vanilla, project quota enabled and process stuck in D
	state (repeatable every time)
Message-ID: <20081203224244.GA7777@infradead.org>
References: <200812021949.55463.arekm@maven.pl>
	<200812031406.41882.arekm@maven.pl>
	<20081203213028.GW18236@disturbed>
	<200812032242.29326.arekm@maven.pl>
	<20081203220724.GA13974@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203220724.GA13974@infradead.org>
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

For reason I don't understand myself yet this patch from my queue
fix it for me:


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_rename.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rename.c	2008-12-03 23:26:34.000000000 +0100
+++ xfs/fs/xfs/xfs_rename.c	2008-12-03 23:29:09.000000000 +0100
@@ -42,31 +42,6 @@
 
 
 /*
- * Given an array of up to 4 inode pointers, unlock the pointed to inodes.
  * If there are fewer than 4 entries in the array, the empty entries will
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
-		xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
