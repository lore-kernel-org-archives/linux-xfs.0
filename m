Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IBa4fK110371 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 06:36:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1F1615D51FF
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 04:45:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	t7nBkfkhGl0blfLw for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 04:45:50 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	35687654-1927428
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 21:06:30 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OlgwW-0005Kb-UR
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:28 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OlgwS-0007nr-Tp
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfs: ensure we mark all inodes in a freed cluster
	XFS_ISTALE
Date: Wed, 18 Aug 2010 21:36:13 +1000
Message-Id: <1282131379-29932-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1282131379-29932-1-git-send-email-david@fromorbit.com>
References: <1282131379-29932-1-git-send-email-david@fromorbit.com>
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

Under heavy load parallel metadata loads (e.g. dbench), we can fail
to mark all the inodes in a cluster being freed as XFS_ISTALE as we
skip inodes we cannot get the XFS_ILOCK_EXCL or the flush lock on.
When this happens and the inode cluster buffer has already been
marked stale and freed, inode reclaim can try to write the inode out
as it is dirty and not marked stale. This can result in writing th
metadata to an freed extent, or in the case it has already
been overwritten trigger a magic number check failure and return an
EUCLEAN error such as:

Filesystem "ram0": inode 0x442ba1 background reclaim flush failed with 117

Fix this by ensuring that we hoover up all in memory inodes in the
cluster and mark them XFS_ISTALE when freeing the cluster.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c |   49 ++++++++++++++++++++++++++-----------------------
 1 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 68415cb..34798f3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1914,6 +1914,11 @@ xfs_iunlink_remove(
 	return 0;
 }
 
+/*
+ * A big issue when freeing the inode cluster is is that we _cannot_ skip any
+ * inodes that are in memory - they all must be marked stale and attached to
+ * the cluster buffer.
+ */
 STATIC void
 xfs_ifree_cluster(
 	xfs_inode_t	*free_ip,
@@ -1945,8 +1950,6 @@ xfs_ifree_cluster(
 	}
 
 	for (j = 0; j < nbufs; j++, inum += ninodes) {
-		int	found = 0;
-
 		blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, inum),
 					 XFS_INO_TO_AGBNO(mp, inum));
 
@@ -1965,7 +1968,9 @@ xfs_ifree_cluster(
 		/*
 		 * Walk the inodes already attached to the buffer and mark them
 		 * stale. These will all have the flush locks held, so an
-		 * in-memory inode walk can't lock them.
+		 * in-memory inode walk can't lock them. By marking them all
+		 * stale first, we will not attempt to lock them in the loop
+		 * below as the XFS_ISTALE flag will be set.
 		 */
 		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
 		while (lip) {
@@ -1977,11 +1982,11 @@ xfs_ifree_cluster(
 							&iip->ili_flush_lsn,
 							&iip->ili_item.li_lsn);
 				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
-				found++;
 			}
 			lip = lip->li_bio_list;
 		}
 
+
 		/*
 		 * For each inode in memory attempt to add it to the inode
 		 * buffer and set it up for being staled on buffer IO
@@ -1993,6 +1998,7 @@ xfs_ifree_cluster(
 		 * even trying to lock them.
 		 */
 		for (i = 0; i < ninodes; i++) {
+retry:
 			read_lock(&pag->pag_ici_lock);
 			ip = radix_tree_lookup(&pag->pag_ici_root,
 					XFS_INO_TO_AGINO(mp, (inum + i)));
@@ -2003,38 +2009,36 @@ xfs_ifree_cluster(
 				continue;
 			}
 
-			/* don't try to lock/unlock the current inode */
+			/*
+			 * Don't try to lock/unlock the current inode, but we
+			 * _cannot_ skip the other inodes that we did not find
+			 * in the list attached to the buffer and are not
+			 * already marked stale. If we can't lock it, back off
+			 * and retry.
+			 */
 			if (ip != free_ip &&
 			    !xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
 				read_unlock(&pag->pag_ici_lock);
-				continue;
+				delay(1);
+				goto retry;
 			}
 			read_unlock(&pag->pag_ici_lock);
 
-			if (!xfs_iflock_nowait(ip)) {
-				if (ip != free_ip)
-					xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				continue;
-			}
-
+			xfs_iflock(ip);
 			xfs_iflags_set(ip, XFS_ISTALE);
-			if (xfs_inode_clean(ip)) {
-				ASSERT(ip != free_ip);
-				xfs_ifunlock(ip);
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				continue;
-			}
 
+			/*
+			 * we don't need to attach clean inodes or those only
+			 * with unlogged changes (which we throw away, anyway).
+			 */
 			iip = ip->i_itemp;
-			if (!iip) {
-				/* inode with unlogged changes only */
+			if (!iip || xfs_inode_clean(ip)) {
 				ASSERT(ip != free_ip);
 				ip->i_update_core = 0;
 				xfs_ifunlock(ip);
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 				continue;
 			}
-			found++;
 
 			iip->ili_last_fields = iip->ili_format.ilf_fields;
 			iip->ili_format.ilf_fields = 0;
@@ -2049,8 +2053,7 @@ xfs_ifree_cluster(
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		}
 
-		if (found)
-			xfs_trans_stale_inode_buf(tp, bp);
+		xfs_trans_stale_inode_buf(tp, bp);
 		xfs_trans_binval(tp, bp);
 	}
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
