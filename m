Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:08:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97M86W2009019
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:08:06 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30AB54C8253
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:09:44 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id eHxH2ag7aLoQvMx8 for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:09:44 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKkL-0002Vb-Dj
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:09:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] XFS: rename xfs_get_perag
Date: Wed,  8 Oct 2008 09:09:31 +1100
Message-Id: <1223417377-8679-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417377-8679-1-git-send-email-david@fromorbit.com>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_get_perag is really getting the perag that an inode belongs to
based on it's inode number. Rename it appropriately so we can use
xfs_perag_get() to get the perag from a provided ag number. Convert
a number of sites over to using this interface.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   21 ++++++++++++---------
 fs/xfs/xfs_iget.c           |   14 +++++++-------
 fs/xfs/xfs_inode.c          |    6 +++---
 fs/xfs/xfs_mount.h          |   15 ++++++++++++---
 4 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index ee1648b..08b2acf 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -57,7 +57,7 @@ xfs_sync_inodes_ag(
 	int		ag,
 	int		flags)
 {
-	xfs_perag_t	*pag = &mp->m_perag[ag];
+	xfs_perag_t	*pag = xfs_perag_get(mp, ag);
 	int		nr_found;
 	uint32_t	first_index = 0;
 	int		error = 0;
@@ -197,10 +197,11 @@ xfs_sync_inodes_ag(
 		 * bail out if the filesystem is corrupted.
 		 */
 		if (error == EFSCORRUPTED)
-			return XFS_ERROR(error);
+			break;
 
 	} while (nr_found);
 
+	xfs_perag_put(pag);
 	return last_error;
 }
 
@@ -598,7 +599,7 @@ xfs_reclaim_inode(
 	int		locked,
 	int		sync_mode)
 {
-	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
+	xfs_perag_t	*pag = xfs_perag_get_from_ino(ip->i_mount, ip->i_ino);
 
 	/* The hash lock here protects a thread in xfs_iget_core from
 	 * racing with us on linking the inode back with a vnode.
@@ -615,12 +616,13 @@ xfs_reclaim_inode(
 			xfs_ifunlock(ip);
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		}
+		xfs_perag_put(pag);
 		return 1;
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
 	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(ip->i_mount, pag);
+	xfs_perag_put(pag);
 
 	/*
 	 * If the inode is still dirty, then flush it out.  If the inode
@@ -663,7 +665,7 @@ xfs_inode_set_reclaim_tag(
 	xfs_inode_t	*ip)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
+	xfs_perag_t	*pag = xfs_perag_get_from_ino(mp, ip->i_ino);
 
 	read_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
@@ -672,7 +674,7 @@ xfs_inode_set_reclaim_tag(
 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 }
 
 void
@@ -690,14 +692,14 @@ xfs_inode_clear_reclaim_tag(
 	xfs_inode_t	*ip)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
+	xfs_perag_t	*pag = xfs_perag_get_from_ino(mp, ip->i_ino);
 
 	read_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	__xfs_inode_clear_reclaim_tag(mp, pag, ip);
 	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 }
 
 
@@ -709,7 +711,7 @@ xfs_reclaim_inodes_ag(
 	int		mode)
 {
 	xfs_inode_t	*ip = NULL;
-	xfs_perag_t	*pag = &mp->m_perag[ag];
+	xfs_perag_t	*pag = xfs_perag_get(mp, ag);
 	int		nr_found;
 	uint32_t	first_index;
 	int		skipped;
@@ -779,6 +781,7 @@ restart:
 		delay(1);
 		goto restart;
 	}
+	xfs_perag_put(pag);
 	return;
 
 }
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index a1f209b..b34b732 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -245,7 +245,7 @@ xfs_iget(
 		return EINVAL;
 
 	/* get the perag structure and ensure that it's inode capable */
-	pag = xfs_get_perag(mp, ino);
+	pag = xfs_perag_get_from_ino(mp, ino);
 	if (!pag->pagi_inodeok)
 		return EINVAL;
 	ASSERT(pag->pag_ici_init);
@@ -269,7 +269,7 @@ again:
 		if (error)
 			goto out_error_or_again;
 	}
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 
 	xfs_iflags_set(ip, XFS_IMODIFIED);
 	*ipp = ip;
@@ -289,7 +289,7 @@ out_error_or_again:
 		delay(1);
 		goto again;
 	}
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 	return error;
 }
 
@@ -307,11 +307,11 @@ xfs_inode_incore(xfs_mount_t	*mp,
 	xfs_inode_t	*ip;
 	xfs_perag_t	*pag;
 
-	pag = xfs_get_perag(mp, ino);
+	pag = xfs_perag_get_from_ino(mp, ino);
 	read_lock(&pag->pag_ici_lock);
 	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ino));
 	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 
 	/* the returned inode must match the transaction */
 	if (ip && (ip->i_transp != tp))
@@ -410,12 +410,12 @@ xfs_iextract(
 	xfs_inode_t	*ip)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
+	xfs_perag_t	*pag = xfs_perag_get_from_ino(mp, ip->i_ino);
 
 	write_lock(&pag->pag_ici_lock);
 	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
 	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 
 	mp->m_ireclaims++;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index eba2ff0..17dbf24 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2111,7 +2111,7 @@ xfs_ifree_cluster(
 	xfs_inode_t		*ip, **ip_found;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
-	xfs_perag_t		*pag = xfs_get_perag(mp, inum);
+	xfs_perag_t		*pag = xfs_perag_get_from_ino(mp, inum);
 
 	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
 		blks_per_cluster = 1;
@@ -2253,7 +2253,7 @@ xfs_ifree_cluster(
 	}
 
 	kmem_free(ip_found);
-	xfs_put_perag(mp, pag);
+	xfs_perag_put(pag);
 }
 
 /*
@@ -2973,7 +2973,7 @@ xfs_iflush_cluster(
 	xfs_buf_t	*bp)
 {
 	xfs_mount_t		*mp = ip->i_mount;
-	xfs_perag_t		*pag = xfs_get_perag(mp, ip->i_ino);
+	xfs_perag_t		*pag = xfs_perag_get_from_ino(mp, ip->i_ino);
 	unsigned long		first_index, mask;
 	unsigned long		inodes_per_cluster;
 	int			ilist_size;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f927ada..55cc89f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -455,18 +455,27 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
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
1.5.6.5
