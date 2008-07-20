Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jul 2008 05:42:49 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6KCgiLL022209
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:42:45 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFCBF1905F6A
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:43:53 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Kpro4YwLDYdxFtOD for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:43:53 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] XFS: kill shouty XFS_ITOV_NULL macro
Date: Sun, 20 Jul 2008 22:43:47 +1000
Message-Id: <1216557828-29056-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1216557828-29056-1-git-send-email-david@fromorbit.com>
References: <1216557828-29056-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>

Replace XFS_ITOV_NULL() with the new VFS_I() inline.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_vnode.c   |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    2 +-
 fs/xfs/xfs_inode.h             |    1 -
 fs/xfs/xfs_vfsops.c            |    2 +-
 fs/xfs/xfs_vnodeops.c          |    2 +-
 5 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_vnode.c b/fs/xfs/linux-2.6/xfs_vnode.c
index bc7afe0..ffd6003 100644
--- a/fs/xfs/linux-2.6/xfs_vnode.c
+++ b/fs/xfs/linux-2.6/xfs_vnode.c
@@ -158,7 +158,7 @@ vn_hold(
  */
 static inline int xfs_icount(struct xfs_inode *ip)
 {
-	bhv_vnode_t *vp = XFS_ITOV_NULL(ip);
+	bhv_vnode_t *vp = VFS_I(ip);
 
 	if (vp)
 		return vn_count(vp);
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index c43b6d4..8407f32 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -1054,7 +1054,7 @@ xfs_qm_dqrele_inodes_ag(
 		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 
 		/* Root inode, rbmip and rsumip have associated blocks */
-		vp = XFS_ITOV_NULL(ip);
+		vp = VFS_I(ip);
 		if (!vp || ip == XFS_QI_UQIP(mp) || ip == XFS_QI_GQIP(mp)) {
 			ASSERT(ip->i_udquot == NULL);
 			ASSERT(ip->i_gdquot == NULL);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7726d41..4d966a4 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -272,7 +272,6 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 	return vn_to_inode(ip->i_vnode);
 }
 #define	XFS_ITOV(ip)		VFS_I(ip)
-#define	XFS_ITOV_NULL(ip)	VFS_I(ip)
 
 /*
  * i_flags helper functions
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index 0ff9812..a184e36 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -325,7 +325,7 @@ xfs_sync_inodes_ag(
 		 * skip inodes in reclaim. Let xfs_syncsub do that for
 		 * us so we don't need to worry.
 		 */
-		vp = XFS_ITOV_NULL(ip);
+		vp = VFS_I(ip);
 		if (!vp) {
 			read_unlock(&pag->pag_ici_lock);
 			continue;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 2af1be3..5d1b254 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2924,7 +2924,7 @@ xfs_finish_reclaim(
 	int		sync_mode)
 {
 	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
-	bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
+	bhv_vnode_t	*vp = VFS_I(ip);
 
 	if (vp && VN_BAD(vp))
 		goto reclaim;
-- 
1.5.6
