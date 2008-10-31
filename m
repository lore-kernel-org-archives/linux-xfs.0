Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 18:16:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V1FX48001241
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:33 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 505C11B6F451
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:33 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id ojrTMztz3KKg7L3S for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:33 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Kvibp-0007qP-AM
	for xfs@oss.sgi.com; Fri, 31 Oct 2008 12:15:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] XFS: fix uninitialised variable bug in dquot release.
Date: Fri, 31 Oct 2008 12:15:27 +1100
Message-Id: <1225415729-26514-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1225415729-26514-1-git-send-email-david@fromorbit.com>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

gcc on ARM warns about an using an uninitialised variable
in xfs_qm_dqrele_all_inodes(). This is a real bug, but gcc
on x86_64 is not reporting this warning so it went unnoticed.

Fix the bug by bring the inode radix tree walk code up to
date with xfs_sync_inodes_ag().

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_qm_syscalls.c |   42 ++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 9ff28e6..2c57a6e 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -1036,9 +1036,6 @@ xfs_qm_dqrele_inodes_ag(
 	int		nr_found;
 
 	do {
-		boolean_t	inode_refed;
-		struct inode	*inode;
-
 		/*
 		 * use a gang lookup to find the next inode in the tree
 		 * as the tree is sparse and a gang lookup walks to find
@@ -1053,27 +1050,37 @@ xfs_qm_dqrele_inodes_ag(
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
 
-		/* skip quota inodes and those in reclaim */
-		inode = VFS_I(ip);
-		if (!inode || ip == XFS_QI_UQIP(mp) || ip == XFS_QI_GQIP(mp)) {
+		/* skip quota inodes */
+		if (ip == XFS_QI_UQIP(mp) || ip == XFS_QI_GQIP(mp)) {
 			ASSERT(ip->i_udquot == NULL);
 			ASSERT(ip->i_gdquot == NULL);
 			read_unlock(&pag->pag_ici_lock);
 			continue;
 		}
-		if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0) {
-			inode = igrab(inode);
-			read_unlock(&pag->pag_ici_lock);
-			if (!inode)
-				continue;
-			inode_refed = B_TRUE;
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-		} else {
+
+		/*
+		 * If we can't get a reference on the inode, it must be
+		 * in reclaim. Leave it for the reclaim code to flush.
+		 */
+		if (!igrab(VFS_I(ip))) {
 			read_unlock(&pag->pag_ici_lock);
+			continue;
 		}
+		read_unlock(&pag->pag_ici_lock);
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
 			xfs_qm_dqrele(ip->i_udquot);
 			ip->i_udquot = NULL;
@@ -1083,9 +1090,8 @@ xfs_qm_dqrele_inodes_ag(
 			xfs_qm_dqrele(ip->i_gdquot);
 			ip->i_gdquot = NULL;
 		}
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (inode_refed)
-			IRELE(ip);
+		xfs_iput(ip, XFS_ILOCK_EXCL);
+
 	} while (nr_found);
 }
 
-- 
1.5.6.5
