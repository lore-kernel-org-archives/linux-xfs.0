Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:33253 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbeDNUDi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Apr 2018 16:03:38 -0400
Received: by mail-pl0-f68.google.com with SMTP id w12-v6so6960932plp.0
        for <linux-xfs@vger.kernel.org>; Sat, 14 Apr 2018 13:03:38 -0700 (PDT)
Date: Sun, 15 Apr 2018 01:35:30 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] fs: xfs: Change return type to vm_fault_t
Message-ID: <20180414200530.GA20184@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, willy@infradead.org

Use new return type vm_fault_t for fault handlers.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/xfs/xfs_file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9ea0832..988ec56 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1027,7 +1027,7 @@
  *       page_lock (MM)
  *         i_lock (XFS - extent map serialisation)
  */
-static int
+static vm_fault_t
 __xfs_filemap_fault(
 	struct vm_fault		*vmf,
 	enum page_entry_size	pe_size,
@@ -1035,7 +1035,7 @@
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
-	int			ret;
+	vm_fault_t		ret;
 
 	trace_xfs_filemap_fault(ip, pe_size, write_fault);
 
@@ -1064,7 +1064,7 @@
 	return ret;
 }
 
-static int
+static vm_fault_t
 xfs_filemap_fault(
 	struct vm_fault		*vmf)
 {
@@ -1074,7 +1074,7 @@
 			(vmf->flags & FAULT_FLAG_WRITE));
 }
 
-static int
+static vm_fault_t
 xfs_filemap_huge_fault(
 	struct vm_fault		*vmf,
 	enum page_entry_size	pe_size)
@@ -1087,7 +1087,7 @@
 			(vmf->flags & FAULT_FLAG_WRITE));
 }
 
-static int
+static vm_fault_t
 xfs_filemap_page_mkwrite(
 	struct vm_fault		*vmf)
 {
@@ -1099,7 +1099,7 @@
  * on write faults. In reality, it needs to serialise against truncate and
  * prepare memory for writing so handle is as standard write fault.
  */
-static int
+static vm_fault_t
 xfs_filemap_pfn_mkwrite(
 	struct vm_fault		*vmf)
 {
-- 
1.9.1

