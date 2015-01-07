Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0768C7FA5
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 16:26:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CFEAAC001
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 14:26:12 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pGJ3n3TXxFn7GDEu for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 14:26:10 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 4/6] xfs: take i_mmap_lock on extent manipulation
	operations
Date: Thu,  8 Jan 2015 09:25:41 +1100
Message-Id: <1420669543-8093-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1420669543-8093-1-git-send-email-david@fromorbit.com>
References: <1420669543-8093-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

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
 fs/xfs/xfs_iops.c  | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e6e7e75..b08c9e6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -794,7 +794,7 @@ xfs_file_fallocate(
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -874,7 +874,7 @@ xfs_file_fallocate(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a183198..8810959 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -634,7 +634,7 @@ xfs_ioc_space(
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
@@ -751,7 +751,7 @@ xfs_ioc_space(
 	error = xfs_trans_commit(tp, 0);
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL);
 	mnt_drop_write_file(filp);
 	return error;
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8be5bb5..f491860 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -768,7 +768,7 @@ xfs_setattr_size(
 	if (error)
 		return error;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL));
 	ASSERT(S_ISREG(ip->i_d.di_mode));
 	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
 		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
@@ -984,9 +984,9 @@ xfs_vn_setattr(
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
