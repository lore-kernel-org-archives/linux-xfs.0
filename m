Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 21:47:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6C4lhbm012063
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 21:47:45 -0700
Date: Thu, 12 Jul 2007 14:47:36 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 2 of 2] Make XFS use block_page_mkwrite
Message-ID: <20070712044736.GR31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Implement ->page_mkwrite in XFS.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_file.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_file.c	2007-02-07 23:00:10.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c	2007-02-07 23:15:20.170880823 +1100
@@ -446,6 +446,20 @@ xfs_file_open_exec(
 }
 #endif /* HAVE_FOP_OPEN_EXEC */
 
+/*
+ * mmap()d file has taken write protection fault and is being made
+ * writable. We can set the page state up correctly for a writable
+ * page, which means we can do correct delalloc accounting (ENOSPC
+ * checking!) and unwritten extent mapping.
+ */
+STATIC int
+xfs_vm_page_mkwrite(
+	struct vm_area_struct	*vma,
+	struct page		*page)
+{
+	return block_page_mkwrite(vma, page, xfs_get_blocks);
+}
+
 const struct file_operations xfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -503,12 +517,14 @@ const struct file_operations xfs_dir_fil
 static struct vm_operations_struct xfs_file_vm_ops = {
 	.nopage		= filemap_nopage,
 	.populate	= filemap_populate,
+	.page_mkwrite	= xfs_vm_page_mkwrite,
 };
 
 #ifdef HAVE_DMAPI
 static struct vm_operations_struct xfs_dmapi_file_vm_ops = {
 	.nopage		= xfs_vm_nopage,
 	.populate	= filemap_populate,
+	.page_mkwrite	= xfs_vm_page_mkwrite,
 #ifdef HAVE_VMOP_MPROTECT
 	.mprotect	= xfs_vm_mprotect,
 #endif
