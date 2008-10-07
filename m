Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:40:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LdxaT031008
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:39:59 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 475BA4B2AD3
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:41:38 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id nYzsKQAMmEGFFfvg for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:41:38 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKJA-0001gL-Ur
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:41:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] XFS: remove the mount inode list
Date: Wed,  8 Oct 2008 08:41:32 +1100
Message-Id: <1223415692-6354-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1223415692-6354-1-git-send-email-david@fromorbit.com>
References: <1223415692-6354-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

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
index 4c92d19..1256746 100644
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
@@ -255,24 +254,6 @@ finish_inode:
 
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
@@ -493,36 +474,15 @@ xfs_iextract(
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
index 9e8e81d..47265b8 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -233,16 +233,8 @@ typedef struct dm_attrs_s {
 	__uint16_t	da_pad;		/* DMIG extra padding */
 } dm_attrs_t;
 
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
index 5ec6032..1e10882 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1288,11 +1288,6 @@ xfs_unmountfs(
 	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
 	xfs_log_unmount(mp);			/* Done! No more fs ops. */
 
-	/*
-	 * All inodes from this mount point should be freed.
-	 */
-	ASSERT(mp->m_inodes == NULL);
-
 	if ((mp->m_flags & XFS_MOUNT_NOUUID) == 0)
 		uuid_table_remove(&mp->m_sb.sb_uuid);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3c66a01..dfa307d 100644
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
1.5.6.5
