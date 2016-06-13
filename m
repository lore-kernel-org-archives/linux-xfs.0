Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE60C7CA1
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 13:37:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E9BF304032
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 11:37:37 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id bvA8AukHDni882Zt
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jun 2016 11:37:32 -0700 (PDT)
Content-Disposition: inline
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 13 Jun 2016 19:36:37 +0100
Message-ID: <lsq.1465842997.734231581@decadent.org.uk>
Subject: [PATCH 3.16 093/114] xfs: use i_mmaplock on write faults
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

commit 075a924d45cc69c75a35f20b4912b85aa98b180a upstream.

Take the i_mmaplock over write page faults. These come through the
->page_mkwrite callout, so we need to wrap that calls with the
i_mmaplock.

This gives us a lock order of mmap_sem -> i_mmaplock -> page_lock
-> i_lock.

Also, move the page_mkwrite wrapper to the same region of xfs_file.c
as the read fault wrappers and add a tracepoint.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_file.c  | 39 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_trace.h |  1 +
 2 files changed, 25 insertions(+), 15 deletions(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -957,20 +957,6 @@ xfs_file_mmap(
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
  * to search from page cache for either xfs_seek_data() or xfs_seek_hole().
  */
@@ -1443,6 +1429,29 @@ xfs_filemap_fault(
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
@@ -1477,6 +1486,6 @@ const struct file_operations xfs_dir_fil
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
 	.map_pages	= filemap_map_pages,
-	.page_mkwrite	= xfs_vm_page_mkwrite,
+	.page_mkwrite	= xfs_filemap_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -685,6 +685,7 @@ DEFINE_INODE_EVENT(xfs_inode_clear_eofbl
 DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 
 DEFINE_INODE_EVENT(xfs_filemap_fault);
+DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
 
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
