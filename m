Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 18:45:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7C1jHDT032381
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 18:45:17 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 185DD384293
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 18:46:33 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id auiddXrkFy5CLoEh for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 18:46:33 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] XFS: remove the mount inode list
Date: Tue, 12 Aug 2008 11:46:11 +1000
Message-Id: <1218505571-27588-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1218505571-27588-1-git-send-email-david@fromorbit.com>
References: <1218505571-27588-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>

Now we've removed all users of the mount inode list,
we can kill it. This reduces the size of the xfs_inode
by 2 pointers.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iget.c  |   42 +-----------------------------------------
 fs/xfs/xfs_inode.h |    8 --------
 fs/xfs/xfs_mount.c |    5 -----
 fs/xfs/xfs_mount.h |    1 -
 4 files changed, 1 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 539c2dd..cd442da 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -76,7 +76,6 @@ xfs_iget_core(
 {
 	struct inode	*old_inode;
 	xfs_inode_t	*ip;
-	xfs_inode_t	*iq;
 	int		error;
 	unsigned long	first_index, mask;
 	xfs_perag_t	*pag;
@@ -260,24 +259,6 @@ finish_inode:
 
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
-
-	/*
-	 * Link ip to its mount and thread it on the mount's inode list.
-	 */
-	XFS_MOUNT_ILOCK(mp);
-	if ((iq = mp->m_inodes)) {
-		ASSERT(iq->i_mprev->i_mnext == iq);
-		ip->i_mprev = iq->i_mprev;
-		iq->i_mprev->i_mnext = ip;
-		iq->i_mprev = ip;
-		ip->i_mnext = iq;
-	} else {
-		ip->i_mnext = ip;
-		ip->i_mprev = ip;
-	}
-	mp->m_inodes = ip;
-
-	XFS_MOUNT_IUNLOCK(mp);
 	xfs_put_perag(mp, pag);
 
  return_ip:
@@ -498,36 +479,15 @@ xfs_iextract(
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
-	xfs_inode_t	*iq;
 
 	write_lock(&pag->pag_ici_lock);
 	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 
-	/*
-	 * Remove from mount's inode list.
-	 */
-	XFS_MOUNT_ILOCK(mp);
-	ASSERT((ip->i_mnext != NULL) && (ip->i_mprev != NULL));
-	iq = ip->i_mnext;
-	iq->i_mprev = ip->i_mprev;
-	ip->i_mprev->i_mnext = iq;
-
-	/*
-	 * Fix up the head pointer if it points to the inode being deleted.
-	 */
-	if (mp->m_inodes == ip) {
-		if (ip == iq) {
-			mp->m_inodes = NULL;
-		} else {
-			mp->m_inodes = iq;
-		}
-	}
-
 	/* Deal with the deleted inodes list */
+	XFS_MOUNT_ILOCK(mp);
 	list_del_init(&ip->i_reclaim);
-
 	mp->m_ireclaims++;
 	XFS_MOUNT_IUNLOCK(mp);
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 455b1a9..c1ee977 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -192,16 +192,8 @@ typedef struct xfs_icdinode {
 	__uint32_t	di_gen;		/* generation number */
 } xfs_icdinode_t;
 
-typedef struct {
-	struct xfs_inode	*ip_mnext;	/* next inode in mount list */
-	struct xfs_inode	*ip_mprev;	/* ptr to prev inode */
-	struct xfs_mount	*ip_mount;	/* fs mount struct ptr */
-} xfs_iptr_t;
-
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
-	struct xfs_inode	*i_mnext;	/* next inode in mount list */
-	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct list_head	i_reclaim;	/* reclaim list */
 	struct inode		*i_vnode;	/* vnode backpointer */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d048e3b..512d378 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1307,11 +1307,6 @@ xfs_unmountfs(xfs_mount_t *mp)
 
 	xfs_freesb(mp);
 
-	/*
-	 * All inodes from this mount point should be freed.
-	 */
-	ASSERT(mp->m_inodes == NULL);
-
 	if ((mp->m_flags & XFS_MOUNT_NOUUID) == 0)
 		uuid_table_remove(&mp->m_sb.sb_uuid);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 88eb9e6..3267782 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -248,7 +248,6 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	struct xfs_inode	*m_inodes;	/* active inode list */
 	struct list_head	m_del_inodes;	/* inodes to reclaim */
 	mutex_t			m_ilock;	/* inode list mutex */
 	uint			m_ireclaims;	/* count of calls to reclaim*/
-- 
1.5.6
