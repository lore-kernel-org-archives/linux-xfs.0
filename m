Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33A8B7F37
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 18:37:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA1A8304032
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:37:19 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FM7N3CuLR4qIW7k0 for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 16:37:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQQY1-0005z8-Fe
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 09:37:09 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQQY1-0003WI-Et
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 09:37:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock
	ordering
Date: Mon, 30 Sep 2013 09:37:05 +1000
Message-Id: <1380497826-13474-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1380497826-13474-1-git-send-email-david@fromorbit.com>
References: <1380497826-13474-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Removing an inode from the namespace involves removing the directory
entry and dropping the link count on the inode. Removing the
directory entry can result in locking an AGF (directory blocks were
freed) and removing a link count can result in placing the inode on
an unlinked list which results in locking an AGI.

The big problem here is that we have an ordering constraint on AGF
and AGI locking - inode allocation locks the AGI, then can allocate
a new extent for new inodes, locking the AGF after the AGI.
Similarly, freeing the inode removes the inode from the unlinked
list, requiring that we lock the AGI first, and then freeing the
inode can result in an inode chunk being freed and hence freeing
disk space requiring that we lock an AGF.

Hence the ordering that is imposed by other parts of the code is AGI
before AGF. This means we cannot remove the directory entry before
we drop the inode reference count and put it on the unlinked list as
this results in a lock order of AGF then AGI, and this can deadlock
against inode allocation and freeing. Therefore we must drop the
link counts before we remove the directory entry.

This is still safe from a transactional point of view - it is not
until we get to xfs_bmap_finish() that we have the possibility of
multiple transactions in this operation. Hence as long as we remove
the directory entry and drop the link count in the first transaction
of the remove operation, there are no transactional constraints on
the ordering here.

Change the ordering of the operations in the xfs_remove() function
to align the ordering of AGI and AGF locking to match that of the
rest of the code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 72 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e3d7538..7a460d8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2370,6 +2370,33 @@ xfs_iunpin_wait(
 		__xfs_iunpin_wait(ip);
 }
 
+/*
+ * Removing an inode from the namespace involves removing the directory entry
+ * and dropping the link count on the inode. Removing the directory entry can
+ * result in locking an AGF (directory blocks were freed) and removing a link
+ * count can result in placing the inode on an unlinked list which results in
+ * locking an AGI.
+ *
+ * The big problem here is that we have an ordering constraint on AGF and AGI
+ * locking - inode allocation locks the AGI, then can allocate a new extent for
+ * new inodes, locking the AGF after the AGI. Similarly, freeing the inode
+ * removes the inode from the unlinked list, requiring that we lock the AGI
+ * first, and then freeing the inode can result in an inode chunk being freed
+ * and hence freeing disk space requiring that we lock an AGF.
+ *
+ * Hence the ordering that is imposed by other parts of the code is AGI before
+ * AGF. This means we cannot remove the directory entry before we drop the inode
+ * reference count and put it on the unlinked list as this results in a lock
+ * order of AGF then AGI, and this can deadlock against inode allocation and
+ * freeing. Therefore we must drop the link counts before we remove the
+ * directory entry.
+ *
+ * This is still safe from a transactional point of view - it is not until we
+ * get to xfs_bmap_finish() that we have the possibility of multiple
+ * transactions in this operation. Hence as long as we remove the directory
+ * entry and drop the link count in the first transaction of the remove
+ * operation, there are no transactional constraints on the ordering here.
+ */
 int
 xfs_remove(
 	xfs_inode_t             *dp,
@@ -2439,6 +2466,7 @@ xfs_remove(
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
+	cancel_flags |= XFS_TRANS_ABORT;
 	if (is_dir) {
 		ASSERT(ip->i_d.di_nlink >= 2);
 		if (ip->i_d.di_nlink != 2) {
@@ -2449,31 +2477,16 @@ xfs_remove(
 			error = XFS_ERROR(ENOTEMPTY);
 			goto out_trans_cancel;
 		}
-	}
 
-	xfs_bmap_init(&free_list, &first_block);
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
-					&first_block, &free_list, resblks);
-	if (error) {
-		ASSERT(error != ENOENT);
-		goto out_bmap_cancel;
-	}
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-	if (is_dir) {
-		/*
-		 * Drop the link from ip's "..".
-		 */
+		/* Drop the link from ip's "..".  */
 		error = xfs_droplink(tp, dp);
 		if (error)
-			goto out_bmap_cancel;
+			goto out_trans_cancel;
 
-		/*
-		 * Drop the "." link from ip to self.
-		 */
+		/* Drop the "." link from ip to self.  */
 		error = xfs_droplink(tp, ip);
 		if (error)
-			goto out_bmap_cancel;
+			goto out_trans_cancel;
 	} else {
 		/*
 		 * When removing a non-directory we need to log the parent
@@ -2482,20 +2495,24 @@ xfs_remove(
 		 */
 		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	}
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
-	/*
-	 * Drop the link from dp to ip.
-	 */
+	/* Drop the link from dp to ip. */
 	error = xfs_droplink(tp, ip);
 	if (error)
-		goto out_bmap_cancel;
+		goto out_trans_cancel;
 
-	/*
-	 * Determine if this is the last link while
-	 * we are in the transaction.
-	 */
+	/* Determine if this is the last link while the inode is locked */
 	link_zero = (ip->i_d.di_nlink == 0);
 
+	xfs_bmap_init(&free_list, &first_block);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
+					&first_block, &free_list, resblks);
+	if (error) {
+		ASSERT(error != ENOENT);
+		goto out_bmap_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2525,7 +2542,6 @@ xfs_remove(
 
  out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
-	cancel_flags |= XFS_TRANS_ABORT;
  out_trans_cancel:
 	xfs_trans_cancel(tp, cancel_flags);
  std_return:
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
