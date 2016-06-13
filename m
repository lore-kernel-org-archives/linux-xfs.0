Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 016607CA0
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 13:37:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8CFD304039
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 11:37:34 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id LF5tEsxHs9IKlfqH
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jun 2016 11:37:31 -0700 (PDT)
Content-Disposition: inline
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 13 Jun 2016 19:36:37 +0100
Message-ID: <lsq.1465842997.501457717@decadent.org.uk>
Subject: [PATCH 3.16 094/114] xfs: take i_mmap_lock on extent manipulation
	operations
In-Reply-To: <lsq.1465842997.838358341@decadent.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, akpm@linux-foundation.org

3.16.36-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit e8e9ad42c1f1e1bfbe0e8c32c8cac02e9ebfb7ef upstream.

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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
[bwh: Backported to 3.16:
 - We never need to break layouts, so take both i_iolock and i_mmaplock at the
   same time
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com
---
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -786,7 +786,7 @@ xfs_file_fallocate(
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -866,7 +866,7 @@ xfs_file_fallocate(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 	return -error;
 }
 
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -640,7 +640,7 @@ xfs_ioc_space(
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
@@ -757,7 +757,7 @@ xfs_ioc_space(
 	error = xfs_trans_commit(tp, 0);
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 	mnt_drop_write_file(filp);
 	return -error;
 }
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -759,6 +759,7 @@ xfs_setattr_size(
 		return XFS_ERROR(error);
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 	ASSERT(S_ISREG(ip->i_d.di_mode));
 	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
 		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
@@ -935,9 +936,9 @@ xfs_vn_setattr(
 	int			error;
 
 	if (iattr->ia_valid & ATTR_SIZE) {
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
+		xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 		error = xfs_setattr_size(ip, iattr);
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 	} else {
 		error = xfs_setattr_nonsize(ip, iattr, 0);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
