Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:12652 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752963AbeFGFXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 01:23:49 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQnMd-0004sX-3W
        for linux-xfs@vger.kernel.org; Thu, 07 Jun 2018 15:21:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQnMd-0001fI-2I
        for linux-xfs@vger.kernel.org; Thu, 07 Jun 2018 15:21:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: setup VFS i_rwsem lockdep state correctly
Date: Thu,  7 Jun 2018 15:21:31 +1000
Message-Id: <20180607052132.6207-2-david@fromorbit.com>
In-Reply-To: <20180607052132.6207-1-david@fromorbit.com>
References: <20180607052132.6207-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When lockdep is enabled, it changes the type of the inode i_rwsem
semaphore before unlocking a newly instantiated inode. THere is the
possibility that there is already a waiter on that inode lock by the
time we unlock the new inode, so having lockdep re-initialise the
lock is a vector for trouble.

Avoid this whole situation by setting up the i_rwsem lockdep class
at the same time we set up the XFS inode i_ilock classes and so the
VFS doesn't have to change the lock class itself when it is
potentially unsafe.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 29484091c0d2..3020c57fc125 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1258,6 +1258,14 @@ xfs_setup_inode(
 	xfs_diflags_to_iflags(inode, ip);
 
 	if (S_ISDIR(inode->i_mode)) {
+		/*
+		 * We set the i_rwsem class here to avoid potential races with
+		 * lockdep_annotate_inode_mutex_key() reinitialising the lock
+		 * after a filehandle lookup has already found the inode in
+		 * cache before it has been unlocked via unlock_new_inode().
+		 */
+		lockdep_set_class(&inode->i_rwsem,
+				  &inode->i_sb->s_type->i_mutex_dir_key);
 		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
 		ip->d_ops = ip->i_mount->m_dir_inode_ops;
 	} else {
-- 
2.17.0

