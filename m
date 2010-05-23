Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4N2MU2X096175 for <xfs@oss.sgi.com>; Sat, 22 May 2010 21:22:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9484515741AA
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 19:26:15 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	RYXWge907j1qOcLx for <xfs@oss.sgi.com>;
	Sat, 22 May 2010 19:26:15 -0700 (PDT)
Received: from dastard (unverified [121.44.31.48])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	25493829-1927428
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 11:54:47 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OG0rt-0004LE-NU
	for xfs@oss.sgi.com; Sun, 23 May 2010 12:24:45 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OG0rm-000512-Gj
	for xfs@oss.sgi.com; Sun, 23 May 2010 12:24:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix race in inode cluster freeing failing to stale inodes
Date: Sun, 23 May 2010 12:24:38 +1000
Message-Id: <1274581478-19260-1-git-send-email-david@fromorbit.com>
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

When an inode cluster is freed, it needs to mark all inodes in memory as
XFS_ISTALE before marking the buffer as stale. This is eeded because the inodes
have a different life cycle to the buffer, and once the buffer is torn down
during transaction completion, we must ensure none of the inodes get written
back (which is what XFS_ISTALE does).

Unfortunately, xfs_ifree_cluster() has some bugs that lead to inodes not being
marked with XFS_ISTALE. This shows up when xfs_iflush() is called on these
inodes either during inode reclaim or tail pushing on the AIL.  The buffer is
read back, but no longer contains inodes and so triggers assert failures and
shutdowns. This was reproducable with at run.dbench10 invocation from xfstests.

There are two main causes of xfs_ifree_cluster() failing. The first is simple -
it checks in-memory inodes it finds in the per-ag icache to see if they are
clean without holding the flush lock. if they are clean it skips them
completely. However, If an inode is flushed delwri, it will
appear clean, but is not guaranteed to be written back until the flush lock has
been dropped. Hence we may have raced on the clean check and the inode may
actually be dirty. Hence always mark inodes found in memory stale before we
check properly if they are clean.

The second is more complex, and makes the first problem easier to hit.
Basically the in-memory inode scan is done with full knowledge it can be racing
with inode flushing and AIl tail pushing, which means that inodes that it can't
get the flush lock on might not be attached to the buffer after then in-memory
inode scan due to IO completion occurring. This is actually documented in the
code as "needs better interlocking". i.e. this is a zero-day bug.

Effectively, the in-memory scan must be done while the inode buffer is locked
and Io cannot be issued on it while we do the in-memory inode scan. This
ensures that inodes we couldn't get the flush lock on are guaranteed to be
attached to the cluster buffer, so we can then catch all in-memory inodes and
mark them stale.

Now that the inode cluster buffer is locked before the in-memory scan is done,
there is no need for the two-phase update of the in-memory inodes, so simplify
the code into two loops and remove the allocation of the temporary buffer used
to hold locked inodes across the phases.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c |  141 ++++++++++++++++++++++------------------------------
 1 files changed, 60 insertions(+), 81 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8cd6e8d..791e762 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1940,10 +1940,10 @@ xfs_ifree_cluster(
 	int			blks_per_cluster;
 	int			nbufs;
 	int			ninodes;
-	int			i, j, found, pre_flushed;
+	int			i, j;
 	xfs_daddr_t		blkno;
 	xfs_buf_t		*bp;
-	xfs_inode_t		*ip, **ip_found;
+	xfs_inode_t		*ip;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
 	struct xfs_perag	*pag;
@@ -1960,114 +1960,94 @@ xfs_ifree_cluster(
 		nbufs = XFS_IALLOC_BLOCKS(mp) / blks_per_cluster;
 	}
 
-	ip_found = kmem_alloc(ninodes * sizeof(xfs_inode_t *), KM_NOFS);
-
 	for (j = 0; j < nbufs; j++, inum += ninodes) {
+		int	found = 0;
+
 		blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, inum),
 					 XFS_INO_TO_AGBNO(mp, inum));
 
+		/*
+		 * We obtain and lock the backing buffer first in the process
+		 * here, as we have to ensure that any dirty inode that we
+		 * can't get the flush lock on is attached to the buffer.
+		 * If we scan the in-memory inodes first, then buffer IO can
+		 * complete before we get a lock on it, and hence we may fail
+		 * to mark all the active inodes on the buffer stale.
+		 */
+		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
+					mp->m_bsize * blks_per_cluster,
+					XBF_LOCK);
+
+		/*
+		 * Walk the inodes already attached to the buffer and mark them
+		 * stale. These will all have the flush locks held, so an
+		 * in-memory inode walk can't lock them.
+		 */
+		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
+		while (lip) {
+			if (lip->li_type == XFS_LI_INODE) {
+				iip = (xfs_inode_log_item_t *)lip;
+				ASSERT(iip->ili_logged == 1);
+				lip->li_cb = (void(*)(xfs_buf_t*,xfs_log_item_t*)) xfs_istale_done;
+				xfs_trans_ail_copy_lsn(mp->m_ail,
+							&iip->ili_flush_lsn,
+							&iip->ili_item.li_lsn);
+				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
+				found++;
+			}
+			lip = lip->li_bio_list;
+		}
 
 		/*
-		 * Look for each inode in memory and attempt to lock it,
-		 * we can be racing with flush and tail pushing here.
-		 * any inode we get the locks on, add to an array of
-		 * inode items to process later.
-		 *
-		 * The get the buffer lock, we could beat a flush
-		 * or tail pushing thread to the lock here, in which
-		 * case they will go looking for the inode buffer
-		 * and fail, we need some other form of interlock
-		 * here.
+		 * Now we've locked out tail pushing and flushing by locking
+		 * the buffer, look for each inode in memory and attempt to
+		 * lock it. Any inode we get the locks on add it to the inode
+		 * buffer and set it up for being staled on buffer IO
+		 * completion.
 		 */
-		found = 0;
 		for (i = 0; i < ninodes; i++) {
 			read_lock(&pag->pag_ici_lock);
 			ip = radix_tree_lookup(&pag->pag_ici_root,
 					XFS_INO_TO_AGINO(mp, (inum + i)));
 
-			/* Inode not in memory or we found it already,
-			 * nothing to do
-			 */
+			/* Inode not in memory or stale, nothing to do */
 			if (!ip || xfs_iflags_test(ip, XFS_ISTALE)) {
 				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
 
-			if (xfs_inode_clean(ip)) {
-				read_unlock(&pag->pag_ici_lock);
-				continue;
-			}
-
-			/* If we can get the locks then add it to the
-			 * list, otherwise by the time we get the bp lock
-			 * below it will already be attached to the
-			 * inode buffer.
-			 */
-
-			/* This inode will already be locked - by us, lets
-			 * keep it that way.
-			 */
-
-			if (ip == free_ip) {
-				if (xfs_iflock_nowait(ip)) {
-					xfs_iflags_set(ip, XFS_ISTALE);
-					if (xfs_inode_clean(ip)) {
-						xfs_ifunlock(ip);
-					} else {
-						ip_found[found++] = ip;
-					}
-				}
+			/* don't try to lock/unlock the current inode */
+			if (ip != free_ip &&
+			    !xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
 				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
+			read_unlock(&pag->pag_ici_lock);
 
-			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
-				if (xfs_iflock_nowait(ip)) {
-					xfs_iflags_set(ip, XFS_ISTALE);
-
-					if (xfs_inode_clean(ip)) {
-						xfs_ifunlock(ip);
-						xfs_iunlock(ip, XFS_ILOCK_EXCL);
-					} else {
-						ip_found[found++] = ip;
-					}
-				} else {
+			if (!xfs_iflock_nowait(ip)) {
+				if (ip != free_ip)
 					xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				}
+				continue;
 			}
-			read_unlock(&pag->pag_ici_lock);
-		}
 
-		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno, 
-					mp->m_bsize * blks_per_cluster,
-					XBF_LOCK);
-
-		pre_flushed = 0;
-		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
-		while (lip) {
-			if (lip->li_type == XFS_LI_INODE) {
-				iip = (xfs_inode_log_item_t *)lip;
-				ASSERT(iip->ili_logged == 1);
-				lip->li_cb = (void(*)(xfs_buf_t*,xfs_log_item_t*)) xfs_istale_done;
-				xfs_trans_ail_copy_lsn(mp->m_ail,
-							&iip->ili_flush_lsn,
-							&iip->ili_item.li_lsn);
-				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
-				pre_flushed++;
+			xfs_iflags_set(ip, XFS_ISTALE);
+			if (xfs_inode_clean(ip)) {
+				ASSERT(ip != free_ip);
+				xfs_ifunlock(ip);
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
+				continue;
 			}
-			lip = lip->li_bio_list;
-		}
 
-		for (i = 0; i < found; i++) {
-			ip = ip_found[i];
 			iip = ip->i_itemp;
-
 			if (!iip) {
+				/* inode with unlogged changes only */
+				ASSERT(ip != free_ip);
 				ip->i_update_core = 0;
 				xfs_ifunlock(ip);
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 				continue;
 			}
+			found++;
 
 			iip->ili_last_fields = iip->ili_format.ilf_fields;
 			iip->ili_format.ilf_fields = 0;
@@ -2078,17 +2058,16 @@ xfs_ifree_cluster(
 			xfs_buf_attach_iodone(bp,
 				(void(*)(xfs_buf_t*,xfs_log_item_t*))
 				xfs_istale_done, (xfs_log_item_t *)iip);
-			if (ip != free_ip) {
+
+			if (ip != free_ip)
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			}
 		}
 
-		if (found || pre_flushed)
+		if (found)
 			xfs_trans_stale_inode_buf(tp, bp);
 		xfs_trans_binval(tp, bp);
 	}
 
-	kmem_free(ip_found);
 	xfs_perag_put(pag);
 }
 
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
