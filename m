Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB26BA3t217328 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 00:11:10 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB8EE12DADAD
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 22:11:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	jZNjakjh1qmFmXhd for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2009 22:11:38 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	9364469-1927428
	for <xfs@oss.sgi.com>; Wed, 02 Dec 2009 16:41:36 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NFiR5-0000gD-6i
	for xfs@oss.sgi.com; Wed, 02 Dec 2009 17:11:35 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NFiRD-0005Kp-6S
	for xfs@oss.sgi.com; Wed, 02 Dec 2009 17:11:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] [XFS] rename xfs_get_perag
Date: Wed,  2 Dec 2009 17:11:34 +1100
Message-Id: <1259734299-20306-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1259734299-20306-1-git-send-email-david@fromorbit.com>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
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
belongs to based on it's inode number. Rename it appropriately
so we can use xfs_perag_get() to get the perag from a
provided ag number.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   24 ++++++++++++++----------
 fs/xfs/xfs_iget.c           |   10 +++++-----
 fs/xfs/xfs_inode.c          |    6 +++---
 fs/xfs/xfs_mount.h          |   15 ++++++++++++---
 4 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index d895a3a..eb54004 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -95,13 +95,12 @@ unlock:
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
@@ -136,8 +135,6 @@ restart:
 		delay(1);
 		goto restart;
 	}
-
-	xfs_put_perag(mp, pag);
 	return last_error;
 }
 
@@ -154,9 +151,15 @@ xfs_inode_ag_iterator(
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
@@ -668,7 +671,7 @@ xfs_reclaim_inode(
 	xfs_inode_t	*ip,
 	int		sync_mode)
 {
-	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
+	xfs_perag_t	*pag = xfs_perag_get_from_ino(ip->i_mount, ip->i_ino);
 
 	/* The hash lock here protects a thread in xfs_iget_core from
 	 * racing with us on linking the inode back with a vnode.
@@ -681,12 +684,13 @@ xfs_reclaim_inode(
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
@@ -737,7 +741,7 @@ xfs_inode_set_reclaim_tag(
 	xfs_inode_t	*ip)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
+	xfs_perag_t	*pag = xfs_perag_get_from_ino(mp, ip->i_ino);
 
 	read_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
@@ -745,7 +749,7 @@ xfs_inode_set_reclaim_tag(
 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 }
 
 void
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 073bb4a..0238408 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -411,7 +411,7 @@ xfs_iget(
 		return EINVAL;
 
 	/* get the perag structure and ensure that it's inode capable */
-	pag = xfs_get_perag(mp, ino);
+	pag = xfs_perag_get_from_ino(mp, ino);
 	if (!pag->pagi_inodeok)
 		return EINVAL;
 	ASSERT(pag->pag_ici_init);
@@ -435,7 +435,7 @@ again:
 		if (error)
 			goto out_error_or_again;
 	}
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 
 	*ipp = ip;
 
@@ -454,7 +454,7 @@ out_error_or_again:
 		delay(1);
 		goto again;
 	}
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 	return error;
 }
 
@@ -522,11 +522,11 @@ xfs_ireclaim(
 	 * if it was never added to it because radix_tree_delete can deal
 	 * with that case just fine.
 	 */
-	pag = xfs_get_perag(mp, ip->i_ino);
+	pag = xfs_perag_get_from_ino(mp, ip->i_ino);
 	write_lock(&pag->pag_ici_lock);
 	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
 	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 
 	/*
 	 * Here we do an (almost) spurious inode lock in order to coordinate
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b92a4fa..44a1168 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1982,7 +1982,7 @@ xfs_ifree_cluster(
 	xfs_inode_t		*ip, **ip_found;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
-	xfs_perag_t		*pag = xfs_get_perag(mp, inum);
+	xfs_perag_t		*pag = xfs_perag_get_from_ino(mp, inum);
 
 	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
 		blks_per_cluster = 1;
@@ -2124,7 +2124,7 @@ xfs_ifree_cluster(
 	}
 
 	kmem_free(ip_found);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 }
 
 /*
@@ -2711,7 +2711,7 @@ xfs_iflush_cluster(
 	xfs_buf_t	*bp)
 {
 	xfs_mount_t		*mp = ip->i_mount;
-	xfs_perag_t		*pag = xfs_get_perag(mp, ip->i_ino);
+	xfs_perag_t		*pag = xfs_perag_get_from_ino(mp, ip->i_ino);
 	unsigned long		first_index, mask;
 	unsigned long		inodes_per_cluster;
 	int			ilist_size;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1df7e45..0068d03 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -387,18 +387,27 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
  * perag get/put wrappers for eventual ref counting
  */
 static inline xfs_perag_t *
-xfs_get_perag(struct xfs_mount *mp, xfs_ino_t ino)
+xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 {
-	return &mp->m_perag[XFS_INO_TO_AGNO(mp, ino)];
+	return &mp->m_perag[agno];
 }
 
 static inline void
-xfs_put_perag(struct xfs_mount *mp, xfs_perag_t *pag)
+xfs_perag_put(xfs_perag_t *pag)
 {
 	/* nothing to see here, move along */
 }
 
 /*
+ * Get the perag associated with the given inode number
+ */
+static inline xfs_perag_t *
+xfs_perag_get_from_ino(struct xfs_mount *mp, xfs_ino_t ino)
+{
+	return xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
+}
+
+/*
  * Per-cpu superblock locking functions
  */
 #ifdef HAVE_PERCPU_SB
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
