Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D3D6C7F83
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 20:17:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AEDF6304043
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 18:17:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	S2TDBozdUwbEE9xQ for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 18:17:21 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: call dax_fault on read page faults for DAX
Date: Tue, 21 Jul 2015 11:09:02 +1000
Message-Id: <1437440945-23457-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1437440945-23457-1-git-send-email-david@fromorbit.com>
References: <1437440945-23457-1-git-send-email-david@fromorbit.com>
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
Cc: willy@linux.intel.com

From: Dave Chinner <dchinner@redhat.com>

When modifying the patch series to handle the XFS MMAP_LOCK nesting
of page faults, I botched the conversion of the read page fault
path, and so it is only every calling through the page cache. Re-add
the necessary __dax_fault() call for such files.

Because the get_blocks callback on read faults may not set up the
mapping buffer correctly to allow unwritten extent completion to be
run, we need to allow callers of __dax_fault() to pass a null
complete_unwritten() callback. The DAX code always zeros the
unwritten page when it is read faulted so there are no stale data
exposure issues with not doing the conversion. The only downside
will be the potential for increased CPU overhead on repeated read
faults of the same page. If this proves to be a problem, then the
filesystem needs to fix it's get_block callback and provide a
convert_unwritten() callback to the read fault path.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/dax.c          |  9 ++++++++-
 fs/xfs/xfs_file.c | 21 +++++++++++++++------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c3e21cc..86d2cee 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -319,6 +319,11 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
  * @vma: The virtual memory area where the fault occurred
  * @vmf: The description of the fault
  * @get_block: The filesystem method used to translate file offsets to blocks
+ * @complete_unwritten: The filesystem method used to convert unwritten blocks
+ *	to written so the data written to them is exposed. This is required for
+ *	write faults, but optional for read faults as dax_insert_mapping() will
+ *	always do the right thing on a read fault (i.e. zero the underlying
+ *	page).
  *
  * When a page fault occurs, filesystems may call this helper in their
  * fault handler for DAX files. __dax_fault() assumes the caller has done all
@@ -339,6 +344,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	int error;
 	int major = 0;
 
+	WARN_ON_ONCE((vmf->flags & FAULT_FLAG_WRITE) && !complete_unwritten);
+
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
@@ -437,7 +444,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	 * as for normal BH based IO completions.
 	 */
 	error = dax_insert_mapping(inode, &bh, vma, vmf);
-	if (buffer_unwritten(&bh))
+	if (buffer_unwritten(&bh) && complete_unwritten)
 		complete_unwritten(&bh, !error);
 
  out:
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f0e8249..db4acc1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1514,18 +1514,27 @@ xfs_filemap_fault(
 	struct vm_area_struct	*vma,
 	struct vm_fault		*vmf)
 {
-	struct xfs_inode	*ip = XFS_I(file_inode(vma->vm_file));
+	struct inode		*inode = file_inode(vma->vm_file);
 	int			ret;
 
-	trace_xfs_filemap_fault(ip);
+	trace_xfs_filemap_fault(XFS_I(inode));
 
 	/* DAX can shortcut the normal fault path on write faults! */
-	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(VFS_I(ip)))
+	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(inode))
 		return xfs_filemap_page_mkwrite(vma, vmf);
 
-	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
-	ret = filemap_fault(vma, vmf);
-	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	if (IS_DAX(inode)) {
+		/*
+		 * we do not want to trigger unwritten extent conversion on read
+		 * faults - that is unnecessary overhead and would also require
+		 * changes to xfs_get_blocks_direct() to map unwritten extent
+		 * ioend for conversion on read-only mappings.
+		 */
+		ret = __dax_fault(vma, vmf, xfs_get_blocks_direct, NULL);
+	} else
+		ret = filemap_fault(vma, vmf);
+	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	return ret;
 }
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
