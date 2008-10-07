Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:53:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97Lr5Oq005440
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:53:06 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2A9E4C6340
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:54:44 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id DQTUrmZFo2xYWz7W for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:54:44 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKVt-00022e-6P
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:54:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] XFS: mark inodes for reclaim via a tag in the inode radix tree
Date: Wed,  8 Oct 2008 08:54:37 +1100
Message-Id: <1223416480-7701-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1223416480-7701-1-git-send-email-david@fromorbit.com>
References: <1223416480-7701-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Prepare for removing the deleted inode list by marking inodes
for reclaim in the inode radix trees so that we can use the
radix trees to find reclaimable inodes.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_sync.h |    4 ++++
 fs/xfs/xfs_ag.h             |    5 +++++
 fs/xfs/xfs_iget.c           |    3 +++
 fs/xfs/xfs_vnodeops.c       |    1 +
 5 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 34413ce..9e7f4dc 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -644,6 +644,47 @@ xfs_reclaim_inode(
 	return 0;
 }
 
+void
+xfs_inode_set_reclaim_tag(
+	xfs_inode_t	*ip)
+{
+	xfs_mount_t	*mp = ip->i_mount;
+	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
+
+	read_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+	radix_tree_tag_set(&pag->pag_ici_root,
+			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
+	spin_unlock(&ip->i_flags_lock);
+	read_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(mp, pag);
+}
+
+void
+__xfs_inode_clear_reclaim_tag(
+	xfs_mount_t	*mp,
+	xfs_perag_t	*pag,
+	xfs_inode_t	*ip)
+{
+	radix_tree_tag_clear(&pag->pag_ici_root,
+			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
+}
+
+void
+xfs_inode_clear_reclaim_tag(
+	xfs_inode_t	*ip)
+{
+	xfs_mount_t	*mp = ip->i_mount;
+	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
+
+	read_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+	__xfs_inode_clear_reclaim_tag(mp, pag, ip);
+	spin_unlock(&ip->i_flags_lock);
+	read_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(mp, pag);
+}
+
 int
 xfs_reclaim_inodes(
 	xfs_mount_t	*mp,
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index c1bcd50..5f6de1e 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -48,4 +48,8 @@ void xfs_flush_device(struct xfs_inode *ip);
 int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
 int xfs_reclaim_inodes(struct xfs_mount *mp, int noblock, int mode);
 
+void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
+void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
+void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
+				struct xfs_inode *ip);
 #endif
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 729ee3e..2bfd863 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -204,6 +204,11 @@ typedef struct xfs_perag
 #endif
 } xfs_perag_t;
 
+/*
+ * tags for inode radix tree
+ */
+#define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
+
 #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
 #define	XFS_MIN_FREELIST_RAW(bl,cl,mp)	\
 	(MIN(bl + 1, XFS_AG_MAXLEVELS(mp)) + MIN(cl + 1, XFS_AG_MAXLEVELS(mp)))
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index c4414e8..a0387f1 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -91,6 +91,9 @@ xfs_iget_cache_hit(
 		}
 		xfs_iflags_set(ip, XFS_INEW);
 		xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
+
+		/* clear the radix tree reclaim flag as well. */
+		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
 		read_unlock(&pag->pag_ici_lock);
 
 		XFS_MOUNT_ILOCK(mp);
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 1addcc7..cbde288 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2820,6 +2820,7 @@ xfs_reclaim(
 		spin_unlock(&ip->i_flags_lock);
 		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
 		XFS_MOUNT_IUNLOCK(mp);
+		xfs_inode_set_reclaim_tag(ip);
 	}
 	return 0;
 }
-- 
1.5.6.5
