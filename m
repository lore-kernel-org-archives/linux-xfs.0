Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 42F6A7F37
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 22:27:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C3C0AC001
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 20:27:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YGpMpUX7zsTJBp27 for <xfs@oss.sgi.com>;
	Sun, 18 Oct 2015 20:27:37 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: xfs_filemap_pmd_fault treats read faults as write
	faults
Date: Mon, 19 Oct 2015 14:27:18 +1100
Message-Id: <1445225238-30413-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1445225238-30413-1-git-send-email-david@fromorbit.com>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

The code initially committed didn't have the same checks for write
faults as the dax_pmd_fault code and hence treats all faults as
write faults. We can get read faults through this path because they
is no pmd_mkwrite path for write faults similar to the normal page
fault path. Hence we need to ensure that we only do c/mtime updates
on write faults, and freeze protection is unnecessary for read
faults.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e7cf9ec..0045b0a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1482,7 +1482,7 @@ xfs_file_llseek(
  *
  * mmap_sem (MM)
  *   sb_start_pagefault(vfs, freeze)
- *     i_mmap_lock (XFS - truncate serialisation)
+ *     i_mmaplock (XFS - truncate serialisation)
  *       page_lock (MM)
  *         i_lock (XFS - extent map serialisation)
  */
@@ -1550,6 +1550,13 @@ xfs_filemap_fault(
 	return ret;
 }
 
+/*
+ * Similar to xfs_filemap_fault(), the DAX fault path can call into here on
+ * both read and write faults. Hence we need to handle both cases. There is no
+ * ->pmd_mkwrite callout for huge pages, so we have a single function here to
+ * handle both cases here. @flags carries the information on the type of fault
+ * occuring.
+ */
 STATIC int
 xfs_filemap_pmd_fault(
 	struct vm_area_struct	*vma,
@@ -1566,13 +1573,18 @@ xfs_filemap_pmd_fault(
 
 	trace_xfs_filemap_pmd_fault(ip);
 
-	sb_start_pagefault(inode->i_sb);
-	file_update_time(vma->vm_file);
+	if (flags & FAULT_FLAG_WRITE) {
+		sb_start_pagefault(inode->i_sb);
+		file_update_time(vma->vm_file);
+	}
+
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault,
 			      NULL);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	sb_end_pagefault(inode->i_sb);
+
+	if (flags & FAULT_FLAG_WRITE)
+		sb_end_pagefault(inode->i_sb);
 
 	return ret;
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
