Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB5A77FC9
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 15:04:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9BDD6304053
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 13:04:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	r6wloOfud1XCKIEB for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2015 13:04:42 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YJ77c-0003G8-7w
	for xfs@oss.sgi.com; Thu, 05 Feb 2015 08:04:28 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YJ77c-0007Xe-72
	for xfs@oss.sgi.com; Thu, 05 Feb 2015 08:04:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: take i_mmap_lock on extent manipulation operations
Date: Thu,  5 Feb 2015 08:04:17 +1100
Message-Id: <1423083859-28439-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1423083859-28439-1-git-send-email-david@fromorbit.com>
References: <1423083859-28439-1-git-send-email-david@fromorbit.com>
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

Now we have the i_mmap_lock being held across the page fault IO
path, we now add extent manipulation operation exclusion by adding
the lock to the paths that directly modify extent maps. This
includes truncate, hole punching and other fallocate based
operations. The operations will now take both the i_iolock and the
i_mmaplock in exclusive mode, thereby ensuring that all IO and page
faults block without holding any page locks while the extent
manipulation is in progress.

This gives us the lock order during truncate of i_iolock ->
i_mmaplock -> page_lock -> i_lock, hence providing the same
lock order as the iolock provides the normal IO path without
involving the mmap_sem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c  | 4 ++--
 fs/xfs/xfs_ioctl.c | 4 ++--
 fs/xfs/xfs_iops.c  | 5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 2bb25fd..76bf14a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -830,7 +830,7 @@ xfs_file_fallocate(
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -894,7 +894,7 @@ xfs_file_fallocate(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index b88ab92..972fa13 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -636,7 +636,7 @@ xfs_ioc_space(
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
@@ -725,7 +725,7 @@ xfs_ioc_space(
 	error = xfs_update_prealloc_flags(ip, flags);
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 	mnt_drop_write_file(filp);
 	return error;
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8be5bb5..0362b65 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -769,6 +769,7 @@ xfs_setattr_size(
 		return error;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 	ASSERT(S_ISREG(ip->i_d.di_mode));
 	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
 		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
@@ -984,9 +985,9 @@ xfs_vn_setattr(
 	int			error;
 
 	if (iattr->ia_valid & ATTR_SIZE) {
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
+		xfs_ilock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 		error = xfs_setattr_size(ip, iattr);
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 	} else {
 		error = xfs_setattr_nonsize(ip, iattr, 0);
 	}
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
