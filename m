Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7ADB37CAF
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:38:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 327A88F8049
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:38:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JFkN05MdZ9qfEVOG for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 16:38:30 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aoJVK-00004q-B4
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:38:26 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aoJUo-0006Fy-6X
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:37:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: rename variables in xfs_iflush_cluster for clarity
Date: Fri,  8 Apr 2016 09:37:47 +1000
Message-Id: <1460072271-23923-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1460072271-23923-1-git-send-email-david@fromorbit.com>
References: <1460072271-23923-1-git-send-email-david@fromorbit.com>
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

The cluster inode variable uses unconventional naming - iq - which
makes it hard to distinguish it between the inode passed into the
function - ip - and that is a vector for mistakes to be made.
Rename all the cluster inode variables to use a more conventional
prefixes to reduce potential future confusion (cilist, cilist_size,
cip).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 32f11a9..2718d10 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3149,16 +3149,16 @@ out_release_wip:
 
 STATIC int
 xfs_iflush_cluster(
-	xfs_inode_t	*ip,
-	xfs_buf_t	*bp)
+	struct xfs_inode	*ip,
+	struct xfs_buf		*bp)
 {
-	xfs_mount_t		*mp = ip->i_mount;
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
 	unsigned long		first_index, mask;
 	unsigned long		inodes_per_cluster;
-	int			ilist_size;
-	xfs_inode_t		**ilist;
-	xfs_inode_t		*iq;
+	int			cilist_size;
+	struct xfs_inode	**cilist;
+	struct xfs_inode	*cip;
 	int			nr_found;
 	int			clcount = 0;
 	int			bufwasdelwri;
@@ -3167,23 +3167,23 @@ xfs_iflush_cluster(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
 	inodes_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
-	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
-	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
-	if (!ilist)
+	cilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
+	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
+	if (!cilist)
 		goto out_put;
 
 	mask = ~(((mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
 	rcu_read_lock();
 	/* really need a gang lookup range call here */
-	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)ilist,
+	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
 					first_index, inodes_per_cluster);
 	if (nr_found == 0)
 		goto out_free;
 
 	for (i = 0; i < nr_found; i++) {
-		iq = ilist[i];
-		if (iq == ip)
+		cip = cilist[i];
+		if (cip == ip)
 			continue;
 
 		/*
@@ -3192,20 +3192,20 @@ xfs_iflush_cluster(
 		 * We need to check under the i_flags_lock for a valid inode
 		 * here. Skip it if it is not valid or the wrong inode.
 		 */
-		spin_lock(&iq->i_flags_lock);
-		if (!iq->i_ino ||
-		    (XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) != first_index) {
-			spin_unlock(&iq->i_flags_lock);
+		spin_lock(&cip->i_flags_lock);
+		if (!cip->i_ino ||
+		    (XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
+			spin_unlock(&cip->i_flags_lock);
 			continue;
 		}
-		spin_unlock(&iq->i_flags_lock);
+		spin_unlock(&cip->i_flags_lock);
 
 		/*
 		 * Do an un-protected check to see if the inode is dirty and
 		 * is a candidate for flushing.  These checks will be repeated
 		 * later after the appropriate locks are acquired.
 		 */
-		if (xfs_inode_clean(iq) && xfs_ipincount(iq) == 0)
+		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
 			continue;
 
 		/*
@@ -3213,15 +3213,15 @@ xfs_iflush_cluster(
 		 * then this inode cannot be flushed and is skipped.
 		 */
 
-		if (!xfs_ilock_nowait(iq, XFS_ILOCK_SHARED))
+		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
 			continue;
-		if (!xfs_iflock_nowait(iq)) {
-			xfs_iunlock(iq, XFS_ILOCK_SHARED);
+		if (!xfs_iflock_nowait(cip)) {
+			xfs_iunlock(cip, XFS_ILOCK_SHARED);
 			continue;
 		}
-		if (xfs_ipincount(iq)) {
-			xfs_ifunlock(iq);
-			xfs_iunlock(iq, XFS_ILOCK_SHARED);
+		if (xfs_ipincount(cip)) {
+			xfs_ifunlock(cip);
+			xfs_iunlock(cip, XFS_ILOCK_SHARED);
 			continue;
 		}
 
@@ -3229,18 +3229,18 @@ xfs_iflush_cluster(
 		 * arriving here means that this inode can be flushed.  First
 		 * re-check that it's dirty before flushing.
 		 */
-		if (!xfs_inode_clean(iq)) {
+		if (!xfs_inode_clean(cip)) {
 			int	error;
-			error = xfs_iflush_int(iq, bp);
+			error = xfs_iflush_int(cip, bp);
 			if (error) {
-				xfs_iunlock(iq, XFS_ILOCK_SHARED);
+				xfs_iunlock(cip, XFS_ILOCK_SHARED);
 				goto cluster_corrupt_out;
 			}
 			clcount++;
 		} else {
-			xfs_ifunlock(iq);
+			xfs_ifunlock(cip);
 		}
-		xfs_iunlock(iq, XFS_ILOCK_SHARED);
+		xfs_iunlock(cip, XFS_ILOCK_SHARED);
 	}
 
 	if (clcount) {
@@ -3250,7 +3250,7 @@ xfs_iflush_cluster(
 
 out_free:
 	rcu_read_unlock();
-	kmem_free(ilist);
+	kmem_free(cilist);
 out_put:
 	xfs_perag_put(pag);
 	return 0;
@@ -3293,8 +3293,8 @@ cluster_corrupt_out:
 	/*
 	 * Unlocks the flush lock
 	 */
-	xfs_iflush_abort(iq, false);
-	kmem_free(ilist);
+	xfs_iflush_abort(cip, false);
+	kmem_free(cilist);
 	xfs_perag_put(pag);
 	return -EFSCORRUPTED;
 }
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
