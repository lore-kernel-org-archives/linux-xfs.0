Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 22:05:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G556jQ002226
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:05:06 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02E19444087
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:06:37 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id TaBmV8kjVuVDbEE5 for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:06:37 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KfSln-0007Sx-NU
	for xfs@oss.sgi.com; Tue, 16 Sep 2008 15:06:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] XFS: use the inode radix tree for reclaiming inodes
Date: Tue, 16 Sep 2008 15:06:29 +1000
Message-Id: <1221541590-28469-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1221541590-28469-1-git-send-email-david@fromorbit.com>
References: <1221541590-28469-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Use the reclaim tag to walk the radix tree and find
the inodes under reclaim. This was the only user of the
deleted inode list.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   81 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 9e7f4dc..bbb40e2 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -685,32 +685,93 @@ xfs_inode_clear_reclaim_tag(
 	xfs_put_perag(mp, pag);
 }
 
-int
-xfs_reclaim_inodes(
+
+STATIC void
+xfs_reclaim_inodes_ag(
 	xfs_mount_t	*mp,
-	int		 noblock,
+	int		ag,
+	int		noblock,
 	int		mode)
 {
-	xfs_inode_t	*ip, *n;
+	xfs_inode_t	*ip = NULL;
+	xfs_perag_t	*pag = &mp->m_perag[ag];
+	int		nr_found;
+	int		first_index;
+	int		skipped;
 
 restart:
-	XFS_MOUNT_ILOCK(mp);
-	list_for_each_entry_safe(ip, n, &mp->m_del_inodes, i_reclaim) {
+	first_index = 0;
+	skipped = 0;
+	do {
+		/*
+		 * use a gang lookup to find the next inode in the tree
+		 * as the tree is sparse and a gang lookup walks to find
+		 * the number of objects requested.
+		 */
+		read_lock(&pag->pag_ici_lock);
+		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
+					(void**)&ip, first_index, 1,
+					XFS_ICI_RECLAIM_TAG);
+
+		if (!nr_found) {
+			read_unlock(&pag->pag_ici_lock);
+			break;
+		}
+
+		/* update the index for the next lookup */
+		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+
+		ASSERT(xfs_iflags_test(ip, (XFS_IRECLAIMABLE|XFS_IRECLAIM)));
+
+		/* ignore if already under reclaim */
+		if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
+			read_unlock(&pag->pag_ici_lock);
+			continue;
+		}
+
 		if (noblock) {
-			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0)
+			if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+				read_unlock(&pag->pag_ici_lock);
 				continue;
+			}
 			if (xfs_ipincount(ip) ||
 			    !xfs_iflock_nowait(ip)) {
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
+				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
 		}
-		XFS_MOUNT_IUNLOCK(mp);
+		read_unlock(&pag->pag_ici_lock);
+
+		/*
+		 * hmmm - this is an inode already in reclaim. Do
+		 * we even bother catching it here?
+		 */
 		if (xfs_reclaim_inode(ip, noblock, mode))
-			delay(1);
+			skipped++;
+	} while (nr_found);
+
+	if (skipped) {
+		delay(1);
 		goto restart;
 	}
-	XFS_MOUNT_IUNLOCK(mp);
+	return;
+
+}
+
+int
+xfs_reclaim_inodes(
+	xfs_mount_t	*mp,
+	int		 noblock,
+	int		mode)
+{
+	int		i;
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		if (!mp->m_perag[i].pag_ici_init)
+			continue;
+		xfs_reclaim_inodes_ag(mp, i, noblock, mode);
+	}
 	return 0;
 }
 
-- 
1.5.6
