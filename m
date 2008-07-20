Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jul 2008 05:19:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6KCIsdF019391
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:18:54 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55A5DE63FEC
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:20:02 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id xBJ6qUBVhzeADmFR for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 05:20:02 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] XFS: Traverse inode trees when releasing dquots
Date: Sun, 20 Jul 2008 22:19:53 +1000
Message-Id: <1216556394-17529-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1216556394-17529-1-git-send-email-david@fromorbit.com>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>

Make releasing all inode dquots traverse the per-ag
inode radix trees rather than the mount inode list.
This removes another user of the mount inode list.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_qm_syscalls.c |  120 ++++++++++++++++++----------------------
 1 files changed, 53 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index adfb872..c43b6d4 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -1022,101 +1022,87 @@ xfs_qm_export_flags(
 
 
 /*
- * Go thru all the inodes in the file system, releasing their dquots.
- * Note that the mount structure gets modified to indicate that quotas are off
- * AFTER this, in the case of quotaoff. This also gets called from
- * xfs_rootumount.
+ * Release all the dquots on the inodes in an AG.
  */
-void
-xfs_qm_dqrele_all_inodes(
-	struct xfs_mount *mp,
-	uint		 flags)
+STATIC void
+xfs_qm_dqrele_inodes_ag(
+	xfs_mount_t	*mp,
+	int		ag,
+	uint		flags)
 {
-	xfs_inode_t	*ip, *topino;
-	uint		ireclaims;
-	bhv_vnode_t	*vp;
-	boolean_t	vnode_refd;
-
-	ASSERT(mp->m_quotainfo);
+	xfs_inode_t	*ip = NULL;
+	bhv_vnode_t	*vp = NULL;
+	xfs_perag_t	*pag = &mp->m_perag[ag];
+	int		first_index = 0;
+	int		nr_found;
 
-	XFS_MOUNT_ILOCK(mp);
-again:
-	ip = mp->m_inodes;
-	if (ip == NULL) {
-		XFS_MOUNT_IUNLOCK(mp);
+	if (!pag->pag_ici_init)
 		return;
-	}
 	do {
-		/* Skip markers inserted by xfs_sync */
-		if (ip->i_mount == NULL) {
-			ip = ip->i_mnext;
-			continue;
+		boolean_t	vnode_refd = B_FALSE;
+
+		read_lock(&pag->pag_ici_lock);
+		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+				(void**)&ip, first_index, 1);
+
+		if (!nr_found) {
+			read_unlock(&pag->pag_ici_lock);
+			break;
 		}
+
+		/* update the index for the next lookup */
+		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+
 		/* Root inode, rbmip and rsumip have associated blocks */
-		if (ip == XFS_QI_UQIP(mp) || ip == XFS_QI_GQIP(mp)) {
-			ASSERT(ip->i_udquot == NULL);
-			ASSERT(ip->i_gdquot == NULL);
-			ip = ip->i_mnext;
-			continue;
-		}
 		vp = XFS_ITOV_NULL(ip);
-		if (!vp) {
+		if (!vp || ip == XFS_QI_UQIP(mp) || ip == XFS_QI_GQIP(mp)) {
 			ASSERT(ip->i_udquot == NULL);
 			ASSERT(ip->i_gdquot == NULL);
-			ip = ip->i_mnext;
+			read_unlock(&pag->pag_ici_lock);
 			continue;
 		}
-		vnode_refd = B_FALSE;
 		if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0) {
-			ireclaims = mp->m_ireclaims;
-			topino = mp->m_inodes;
 			vp = vn_grab(vp);
+			read_unlock(&pag->pag_ici_lock);
 			if (!vp)
-				goto again;
-
-			XFS_MOUNT_IUNLOCK(mp);
-			/* XXX restart limit ? */
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
+				continue;
 			vnode_refd = B_TRUE;
+			xfs_ilock(ip, XFS_ILOCK_EXCL);
 		} else {
-			ireclaims = mp->m_ireclaims;
-			topino = mp->m_inodes;
-			XFS_MOUNT_IUNLOCK(mp);
+			read_unlock(&pag->pag_ici_lock);
 		}
-
-		/*
-		 * We don't keep the mountlock across the dqrele() call,
-		 * since it can take a while..
-		 */
 		if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
 			xfs_qm_dqrele(ip->i_udquot);
 			ip->i_udquot = NULL;
 		}
-		if (flags & (XFS_PQUOTA_ACCT|XFS_GQUOTA_ACCT) && ip->i_gdquot) {
+		if (flags & (XFS_PQUOTA_ACCT|XFS_GQUOTA_ACCT) &&
+		    ip->i_gdquot) {
 			xfs_qm_dqrele(ip->i_gdquot);
 			ip->i_gdquot = NULL;
 		}
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		/*
-		 * Wait until we've dropped the ilock and mountlock to
-		 * do the vn_rele. Or be condemned to an eternity in the
-		 * inactive code in hell.
-		 */
 		if (vnode_refd)
-			IRELE(ip);
-		XFS_MOUNT_ILOCK(mp);
-		/*
-		 * If an inode was inserted or removed, we gotta
-		 * start over again.
-		 */
-		if (topino != mp->m_inodes || mp->m_ireclaims != ireclaims) {
-			/* XXX use a sentinel */
-			goto again;
-		}
-		ip = ip->i_mnext;
-	} while (ip != mp->m_inodes);
+			VN_RELE(vp);
+	} while (nr_found);
+}
 
-	XFS_MOUNT_IUNLOCK(mp);
+/*
+ * Go thru all the inodes in the file system, releasing their dquots.
+ * Note that the mount structure gets modified to indicate that quotas are off
+ * AFTER this, in the case of quotaoff. This also gets called from
+ * xfs_rootumount.
+ */
+void
+xfs_qm_dqrele_all_inodes(
+	struct xfs_mount *mp,
+	uint		 flags)
+{
+	int		i;
+
+	ASSERT(mp->m_quotainfo);
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		xfs_qm_dqrele_inodes_ag(mp, i, flags);
+	}
 }
 
 /*------------------------------------------------------------------------*/
-- 
1.5.6
