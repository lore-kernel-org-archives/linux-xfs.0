Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8R1lVmV150742 for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 20:47:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F91A1864615
	for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 18:48:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	sQmjDPfHWXV9jPlz for <xfs@oss.sgi.com>;
	Sun, 26 Sep 2010 18:48:27 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40809228-1927428
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 11:18:26 +0930 (CST)
Received: from [192.168.1.9] (helo=disturbed) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1P02pM-0002t5-F6
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:48:24 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1P02p5-0003qD-VB
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:48:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/18] xfs: implement batched inode lookups for AG walking
Date: Mon, 27 Sep 2010 11:47:49 +1000
Message-Id: <1285552073-14663-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1285552073-14663-1-git-send-email-david@fromorbit.com>
References: <1285552073-14663-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

With the reclaim code separated from the generic walking code, it is
simple to implement batched lookups for the generic walk code.
Separate out the inode validation from the execute operations and
modify the tree lookups to get a batch of inodes at a time.

Reclaim operations will be optimised separately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_sync.c |   68 ++++++++++++++++++++++++++++--------------
 fs/xfs/linux-2.6/xfs_sync.h |    2 +-
 2 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 1ef1c65..892ce33 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -39,6 +39,14 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+/*
+ * The inode lookup is done in batches to keep the amount of lock traffic and
+ * radix tree lookups to a minimum. The batch size is a trade off between
+ * lookup reduction and stack usage. This is in the reclaim path, so we can't
+ * be too greedy.
+ */
+#define XFS_LOOKUP_BATCH	32
+
 STATIC int
 xfs_inode_ag_walk_grab(
 	struct xfs_inode	*ip)
@@ -66,7 +74,6 @@ xfs_inode_ag_walk_grab(
 	return 0;
 }
 
-
 STATIC int
 xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
@@ -79,54 +86,69 @@ xfs_inode_ag_walk(
 	int			last_error = 0;
 	int			skipped;
 	int			done;
+	int			nr_found;
 
 restart:
 	done = 0;
 	skipped = 0;
 	first_index = 0;
+	nr_found = 0;
 	do {
+		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
 		int		error = 0;
-		int		nr_found;
-		xfs_inode_t	*ip;
+		int		i;
 
 		read_lock(&pag->pag_ici_lock);
 		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-				(void **)&ip, first_index, 1);
+					(void **)batch, first_index,
+					XFS_LOOKUP_BATCH);
 		if (!nr_found) {
 			read_unlock(&pag->pag_ici_lock);
 			break;
 		}
 
 		/*
-		 * Update the index for the next lookup. Catch overflows
-		 * into the next AG range which can occur if we have inodes
-		 * in the last block of the AG and we are currently
-		 * pointing to the last inode.
+		 * Grab the inodes before we drop the lock. if we found
+		 * nothing, nr == 0 and the loop will be skipped.
 		 */
-		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-			done = 1;
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_inode *ip = batch[i];
 
-		if (xfs_inode_ag_walk_grab(ip)) {
-			read_unlock(&pag->pag_ici_lock);
-			continue;
+			if (done || xfs_inode_ag_walk_grab(ip))
+				batch[i] = NULL;
+
+			/*
+			 * Update the index for the next lookup. Catch overflows
+			 * into the next AG range which can occur if we have inodes
+			 * in the last block of the AG and we are currently
+			 * pointing to the last inode.
+			 */
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+				done = 1;
 		}
+
+		/* unlock now we've grabbed the inodes. */
 		read_unlock(&pag->pag_ici_lock);
 
-		error = execute(ip, pag, flags);
-		IRELE(ip);
-		if (error == EAGAIN) {
-			skipped++;
-			continue;
+		for (i = 0; i < nr_found; i++) {
+			if (!batch[i])
+				continue;
+			error = execute(batch[i], pag, flags);
+			IRELE(batch[i]);
+			if (error == EAGAIN) {
+				skipped++;
+				continue;
+			}
+			if (error && last_error != EFSCORRUPTED)
+				last_error = error;
 		}
-		if (error)
-			last_error = error;
 
 		/* bail out if the filesystem is corrupted.  */
 		if (error == EFSCORRUPTED)
 			break;
 
-	} while (!done);
+	} while (nr_found && !done);
 
 	if (skipped) {
 		delay(1);
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index e8a3528..32ba662 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -47,7 +47,7 @@ void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
 
-int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
+int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
 	int flags);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
