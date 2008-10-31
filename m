Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 18:15:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V1FWxK001224
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:32 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C649562F62
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:32 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id HQs1p4GyjfvVGSlB for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:32 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Kvibp-0007qa-Ej
	for xfs@oss.sgi.com; Fri, 31 Oct 2008 12:15:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] XFS: Avoid using inodes that haven't been completely initialised
Date: Fri, 31 Oct 2008 12:15:29 +1100
Message-Id: <1225415729-26514-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1225415729-26514-1-git-send-email-david@fromorbit.com>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The radix tree walks in xfs_sync_inodes_ag and xfs_qm_dqrele_all_inodes()
can find inodes that are still undergoing initialisation. Avoid
them by checking for the the XFS_INEW() flag once we have a reference
on the inode. This flag is cleared once the inode is properly initialised.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_iops.c    |    1 -
 fs/xfs/linux-2.6/xfs_sync.c    |    5 +++--
 fs/xfs/quota/xfs_qm_syscalls.c |    6 ++++++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index b7deff9..f131409 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -772,7 +772,6 @@ xfs_setup_inode(
 	inode->i_ino = ip->i_ino;
 	inode->i_state = I_NEW|I_LOCK;
 	inode_add_to_lists(ip->i_mount->m_super, inode);
-	ASSERT(atomic_read(&inode->i_count) == 1);
 
 	inode->i_mode	= ip->i_d.di_mode;
 	inode->i_nlink	= ip->i_d.di_nlink;
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index fb5cca3..d12d31b 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -117,8 +117,9 @@ xfs_sync_inodes_ag(
 		}
 		read_unlock(&pag->pag_ici_lock);
 
-		/* bad inodes are dealt with elsewhere */
-		if (is_bad_inode(inode)) {
+		/* avoid new or bad inodes */
+		if (is_bad_inode(inode) ||
+		    xfs_iflags_test(ip, XFS_INEW)) {
 			IRELE(ip);
 			continue;
 		}
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 2c57a6e..68139b3 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -1080,6 +1080,12 @@ xfs_qm_dqrele_inodes_ag(
 		}
 		read_unlock(&pag->pag_ici_lock);
 
+		/* avoid new inodes though we shouldn't find any here */
+		if (xfs_iflags_test(ip, XFS_INEW)) {
+			IRELE(ip);
+			continue;
+		}
+
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
 			xfs_qm_dqrele(ip->i_udquot);
-- 
1.5.6.5
