Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 56ADF8002
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 22:17:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B5F98F8078
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 20:17:18 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YgkDvdKNRlZguR2k for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 20:17:16 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WFyaT-00022k-7S
	for xfs@oss.sgi.com; Wed, 19 Feb 2014 15:16:45 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WFyaT-0001Fa-5S
	for xfs@oss.sgi.com; Wed, 19 Feb 2014 15:16:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: fix directory inode iolock lockdep false positive
Date: Wed, 19 Feb 2014 15:16:41 +1100
Message-Id: <1392783402-4726-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1392783402-4726-1-git-send-email-david@fromorbit.com>
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The change to add the IO lock to protect the directory extent map
during readdir operations has cause lockdep to have a heart attack
as it now sees a different locking order on inodes w.r.t. the
mmap_sem because readdir has a different ordering to write().

Add a new lockdep class for directory inodes to avoid this false
positive.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9ddfb81..bb3bb65 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -48,6 +48,18 @@
 #include <linux/fiemap.h>
 #include <linux/slab.h>
 
+/*
+ * Directories have different lock order w.r.t. mmap_sem compared to regular
+ * files. This is due to readdir potentially triggering page faults on a user
+ * buffer inside filldir(), and this happens with the ilock on the directory
+ * held. For regular files, the lock order is the other way around - the
+ * mmap_sem is taken during the page fault, and then we lock the ilock to do
+ * block mapping. Hence we need a different class for the directory ilock so
+ * that lockdep can tell them apart.
+ */
+static struct lock_class_key xfs_nondir_ilock_class;
+static struct lock_class_key xfs_dir_ilock_class;
+
 static int
 xfs_initxattrs(
 	struct inode		*inode,
@@ -1191,6 +1203,7 @@ xfs_setup_inode(
 	xfs_diflags_to_iflags(inode, ip);
 
 	ip->d_ops = ip->i_mount->m_nondir_inode_ops;
+	lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &xfs_inode_operations;
@@ -1198,6 +1211,7 @@ xfs_setup_inode(
 		inode->i_mapping->a_ops = &xfs_address_space_operations;
 		break;
 	case S_IFDIR:
+		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
 		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
 			inode->i_op = &xfs_dir_ci_inode_operations;
 		else
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
