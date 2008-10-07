Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:53:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97Lr6oE005449
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:53:06 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7B2F4C6344
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:54:45 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id GRqAbabFPsAFAhmA for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:54:45 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKVt-00022o-LE
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:54:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] XFS: Prevent looping in xfs_sync_inodes_ag
Date: Wed,  8 Oct 2008 08:54:40 +1100
Message-Id: <1223416480-7701-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1223416480-7701-1-git-send-email-david@fromorbit.com>
References: <1223416480-7701-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

If the last  block of the AG has inodes in it and the AG is an
exactly power-of-2 size then the last inode in the AG points
to the last block in the AG. If we try to find the next inode
in the AG by adding one to the inode number, we increment the
inode number past the size of the AG. The result is that the
macro XFS_INO_TO_AGINO() will strip the AG portion of the inode
number and return an inode number of zero.

That is, instead of terminating the lookup loop because we hit the
inode number went outside the valid range for the AG, the search
index returns to zero and we start traversing the radix tree from
the start again. This results in an endless loop in
xfs_sync_inodes_ag().

Fix it be detecting if the new search index decreases as a result of
incrementing the current inode number. That indicate an overflow and
hence that we have finished processing the AG so we can terminate
the loop.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 22006b5..ee1648b 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -59,7 +59,7 @@ xfs_sync_inodes_ag(
 {
 	xfs_perag_t	*pag = &mp->m_perag[ag];
 	int		nr_found;
-	int		first_index = 0;
+	uint32_t	first_index = 0;
 	int		error = 0;
 	int		last_error = 0;
 	int		fflag = XFS_B_ASYNC;
@@ -97,8 +97,17 @@ xfs_sync_inodes_ag(
 			break;
 		}
 
-		/* update the index for the next lookup */
+		/*
+		 * Update the index for the next lookup. Catch overflows
+		 * into the next AG range which can occur if we have inodes
+		 * in the last block of the AG and we are currently
+		 * pointing to the last inode.
+		 */
 		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino)) {
+			read_unlock(&pag->pag_ici_lock);
+			break;
+		}
 
 		/*
 		 * skip inodes in reclaim. Let xfs_syncsub do that for
@@ -702,7 +711,7 @@ xfs_reclaim_inodes_ag(
 	xfs_inode_t	*ip = NULL;
 	xfs_perag_t	*pag = &mp->m_perag[ag];
 	int		nr_found;
-	int		first_index;
+	uint32_t	first_index;
 	int		skipped;
 
 restart:
@@ -724,8 +733,17 @@ restart:
 			break;
 		}
 
-		/* update the index for the next lookup */
+		/*
+		 * Update the index for the next lookup. Catch overflows
+		 * into the next AG range which can occur if we have inodes
+		 * in the last block of the AG and we are currently
+		 * pointing to the last inode.
+		 */
 		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino)) {
+			read_unlock(&pag->pag_ici_lock);
+			break;
+		}
 
 		ASSERT(xfs_iflags_test(ip, (XFS_IRECLAIMABLE|XFS_IRECLAIM)));
 
-- 
1.5.6.5
