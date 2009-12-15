Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF6BHxo210889 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 00:11:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F52DF65EF
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 22:11:54 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	GRV5YPLN6AjRtpxv for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 22:11:54 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10080027-1927428
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 16:41:51 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NKQdH-0001l7-AH
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:39 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NKQcx-0000cu-Sz
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 17:11:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] XFS: rename xfs_get_perag
Date: Tue, 15 Dec 2009 17:11:12 +1100
Message-Id: <1260857477-2368-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1260857477-2368-1-git-send-email-david@fromorbit.com>
References: <1260857477-2368-1-git-send-email-david@fromorbit.com>
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

xfs_get_perag is really getting the perag that an inode
belongs to based on it's inode number. Convert the use of this
function to just get the perag from a provided ag number.
Use this new function to obtain the per-ag structure when
traversing the per AG inode trees for sync and reclaim.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   33 +++++++++++++++++++++------------
 fs/xfs/xfs_iget.c           |   10 +++++-----
 fs/xfs/xfs_inode.c          |    8 +++++---
 fs/xfs/xfs_mount.h          |    8 ++++----
 4 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 6fed97a..0e17683 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -96,13 +96,12 @@ unlock:
 STATIC int
 xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		ag,
+	struct xfs_perag	*pag,
 	int			(*execute)(struct xfs_inode *ip,
 					   struct xfs_perag *pag, int flags),
 	int			flags,
 	int			tag)
 {
-	struct xfs_perag	*pag = &mp->m_perag[ag];
 	uint32_t		first_index;
 	int			last_error = 0;
 	int			skipped;
@@ -137,8 +136,6 @@ restart:
 		delay(1);
 		goto restart;
 	}
-
-	xfs_put_perag(mp, pag);
 	return last_error;
 }
 
@@ -155,9 +152,15 @@ xfs_inode_ag_iterator(
 	xfs_agnumber_t		ag;
 
 	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
-		if (!mp->m_perag[ag].pag_ici_init)
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, ag);
+		if (!pag->pag_ici_init) {
+			xfs_perag_put(pag);
 			continue;
-		error = xfs_inode_ag_walk(mp, ag, execute, flags, tag);
+		}
+		error = xfs_inode_ag_walk(mp, pag, execute, flags, tag);
+		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
 			if (error == EFSCORRUPTED)
@@ -669,25 +672,30 @@ xfs_reclaim_inode(
 	xfs_inode_t	*ip,
 	int		sync_mode)
 {
-	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
+	struct xfs_mount *mp = ip->i_mount;
+	struct xfs_perag *pag;
+
 
-	/* The hash lock here protects a thread in xfs_iget_core from
+	/*
+	 * The radix tree lock here protects a thread in xfs_iget_core from
 	 * racing with us on linking the inode back with a vnode.
 	 * Once we have the XFS_IRECLAIM flag set it will not touch
 	 * us.
 	 */
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	write_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
 	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
 		spin_unlock(&ip->i_flags_lock);
 		write_unlock(&pag->pag_ici_lock);
+		xfs_perag_put(pag);
 		return -EAGAIN;
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
 	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(ip->i_mount, pag);
+	xfs_perag_put(pag);
 
 	/*
 	 * If the inode is still dirty, then flush it out.  If the inode
@@ -737,16 +745,17 @@ void
 xfs_inode_set_reclaim_tag(
 	xfs_inode_t	*ip)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
+	struct xfs_mount *mp = ip->i_mount;
+	struct xfs_perag *pag;
 
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	read_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	__xfs_inode_set_reclaim_tag(pag, ip);
 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 }
 
 void
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index f5c904a..d1e7250 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -375,7 +375,7 @@ xfs_iget(
 		return EINVAL;
 
 	/* get the perag structure and ensure that it's inode capable */
-	pag = xfs_get_perag(mp, ino);
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
 	if (!pag->pagi_inodeok)
 		return EINVAL;
 	ASSERT(pag->pag_ici_init);
@@ -399,7 +399,7 @@ again:
 		if (error)
 			goto out_error_or_again;
 	}
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 
 	*ipp = ip;
 
@@ -418,7 +418,7 @@ out_error_or_again:
 		delay(1);
 		goto again;
 	}
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 	return error;
 }
 
@@ -486,11 +486,11 @@ xfs_ireclaim(
 	 * if it was never added to it because radix_tree_delete can deal
 	 * with that case just fine.
 	 */
-	pag = xfs_get_perag(mp, ip->i_ino);
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	write_lock(&pag->pag_ici_lock);
 	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
 	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 
 	/*
 	 * Here we do an (almost) spurious inode lock in order to coordinate
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ce278b3..1f69dda 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1946,8 +1946,9 @@ xfs_ifree_cluster(
 	xfs_inode_t		*ip, **ip_found;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
-	xfs_perag_t		*pag = xfs_get_perag(mp, inum);
+	struct xfs_perag	*pag;
 
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
 	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
 		blks_per_cluster = 1;
 		ninodes = mp->m_sb.sb_inopblock;
@@ -2088,7 +2089,7 @@ xfs_ifree_cluster(
 	}
 
 	kmem_free(ip_found);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 }
 
 /*
@@ -2675,7 +2676,7 @@ xfs_iflush_cluster(
 	xfs_buf_t	*bp)
 {
 	xfs_mount_t		*mp = ip->i_mount;
-	xfs_perag_t		*pag = xfs_get_perag(mp, ip->i_ino);
+	struct xfs_perag	*pag;
 	unsigned long		first_index, mask;
 	unsigned long		inodes_per_cluster;
 	int			ilist_size;
@@ -2686,6 +2687,7 @@ xfs_iflush_cluster(
 	int			bufwasdelwri;
 	int			i;
 
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	ASSERT(pag->pagi_inodeok);
 	ASSERT(pag->pag_ici_init);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1df7e45..f8a68a2 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -386,14 +386,14 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 /*
  * perag get/put wrappers for eventual ref counting
  */
-static inline xfs_perag_t *
-xfs_get_perag(struct xfs_mount *mp, xfs_ino_t ino)
+static inline struct xfs_perag *
+xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 {
-	return &mp->m_perag[XFS_INO_TO_AGNO(mp, ino)];
+	return &mp->m_perag[agno];
 }
 
 static inline void
-xfs_put_perag(struct xfs_mount *mp, xfs_perag_t *pag)
+xfs_perag_put(struct xfs_perag *pag)
 {
 	/* nothing to see here, move along */
 }
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
