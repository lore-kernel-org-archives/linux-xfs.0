Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5D88F7F94
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 16:26:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D994304051
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 14:26:12 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XUlZ24JoCazy6aWa for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 14:26:10 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 3/6] xfs: use i_mmaplock on write faults
Date: Thu,  8 Jan 2015 09:25:40 +1100
Message-Id: <1420669543-8093-4-git-send-email-david@fromorbit.com>
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

Take the i_mmaplock over write page faults. These come through the
->page_mkwrite callout, so we need to wrap that calls with the
i_mmaplock.

This gives us a lock order of mmap_sem -> i_mmaplock -> page_lock
-> i_lock.

Also, move the page_mkwrite wrapper to the same region of xfs_file.c
as the read fault wrappers and add a tracepoint.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c  | 39 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_trace.h |  1 +
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 87535e6..e6e7e75 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -961,20 +961,6 @@ xfs_file_mmap(
 }
 
 /*
- * mmap()d file has taken write protection fault and is being made
- * writable. We can set the page state up correctly for a writable
- * page, which means we can do correct delalloc accounting (ENOSPC
- * checking!) and unwritten extent mapping.
- */
-STATIC int
-xfs_vm_page_mkwrite(
-	struct vm_area_struct	*vma,
-	struct vm_fault		*vmf)
-{
-	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
-}
-
-/*
  * This type is designed to indicate the type of offset we would like
  * to search from page cache for xfs_seek_hole_data().
  */
@@ -1375,6 +1361,29 @@ xfs_filemap_fault(
 	return error;
 }
 
+/*
+ * mmap()d file has taken write protection fault and is being made writable. We
+ * can set the page state up correctly for a writable page, which means we can
+ * do correct delalloc accounting (ENOSPC checking!) and unwritten extent
+ * mapping.
+ */
+STATIC int
+xfs_filemap_page_mkwrite(
+	struct vm_area_struct	*vma,
+	struct vm_fault		*vmf)
+{
+	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
+	int			error;
+
+	trace_xfs_filemap_page_mkwrite(ip);
+
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
+	error = block_page_mkwrite(vma, vmf, xfs_get_blocks);
+	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+
+	return error;
+}
+
 const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
 	.read		= new_sync_read,
@@ -1409,6 +1418,6 @@ const struct file_operations xfs_dir_file_operations = {
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
 	.map_pages	= filemap_map_pages,
-	.page_mkwrite	= xfs_vm_page_mkwrite,
+	.page_mkwrite	= xfs_filemap_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c496153..b1e059b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -686,6 +686,7 @@ DEFINE_INODE_EVENT(xfs_inode_clear_eofblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 
 DEFINE_INODE_EVENT(xfs_filemap_fault);
+DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
 
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
