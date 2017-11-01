Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44226 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754826AbdKAPhF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Nov 2017 11:37:05 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 18/18] xfs: support for synchronous DAX faults
Date: Wed,  1 Nov 2017 16:36:47 +0100
Message-Id: <20171101153648.30166-19-jack@suse.cz>
In-Reply-To: <20171101153648.30166-1-jack@suse.cz>
References: <20171101153648.30166-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>

From: Christoph Hellwig <hch@lst.de>

Return IOMAP_F_DIRTY from xfs_file_iomap_begin() when asked to prepare
blocks for writing and the inode is pinned, and has dirty fields other
than the timestamps.  In __xfs_filemap_fault() we then detect this case
and call dax_finish_sync_fault() to make sure all metadata is committed,
and to insert the page table entry.

Note that this will also dirty corresponding radix tree entry which is
what we want - fsync(2) will still provide data integrity guarantees for
applications not using userspace flushing. And applications using
userspace flushing can avoid calling fsync(2) and thus avoid the
performance overhead.

[JK: Added VM_SYNC flag handling]

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c  | 15 ++++++++++++++-
 fs/xfs/xfs_iomap.c |  5 +++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4496b45678de..4827e82d5d2c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -44,6 +44,7 @@
 #include <linux/falloc.h>
 #include <linux/pagevec.h>
 #include <linux/backing-dev.h>
+#include <linux/mman.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1040,7 +1041,11 @@ __xfs_filemap_fault(
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	if (IS_DAX(inode)) {
-		ret = dax_iomap_fault(vmf, pe_size, NULL, &xfs_iomap_ops);
+		pfn_t pfn;
+
+		ret = dax_iomap_fault(vmf, pe_size, &pfn, &xfs_iomap_ops);
+		if (ret & VM_FAULT_NEEDDSYNC)
+			ret = dax_finish_sync_fault(vmf, pe_size, pfn);
 	} else {
 		if (write_fault)
 			ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
@@ -1110,6 +1115,13 @@ xfs_file_mmap(
 	struct file	*filp,
 	struct vm_area_struct *vma)
 {
+	/*
+	 * We don't support synchronous mappings for non-DAX files. At least
+	 * until someone comes with a sensible use case.
+	 */
+	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
+		return -EOPNOTSUPP;
+
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(file_inode(filp)))
@@ -1128,6 +1140,7 @@ const struct file_operations xfs_file_operations = {
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
 	.mmap		= xfs_file_mmap,
+	.mmap_supported_flags = MAP_SYNC,
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f179bdf1644d..b43be199fbdf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -33,6 +33,7 @@
 #include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
+#include "xfs_inode_item.h"
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
@@ -1086,6 +1087,10 @@ xfs_file_iomap_begin(
 		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
 	}
 
+	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
+	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+		iomap->flags |= IOMAP_F_DIRTY;
+
 	xfs_bmbt_to_iomap(ip, iomap, &imap);
 
 	if (shared)
-- 
2.12.3

