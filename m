Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752786AbdJKUGV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 16:06:21 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 18/19] xfs: support for synchronous DAX faults
Date: Wed, 11 Oct 2017 22:06:02 +0200
Message-Id: <20171011200603.27442-19-jack@suse.cz>
In-Reply-To: <20171011200603.27442-1-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>

From: Christoph Hellwig <hch@lst.de>

Return IOMAP_F_NEEDDSYNC from xfs_file_iomap_begin() for a synchronous
write fault when inode is pinned, and has dirty fields other than the
timestamps.  In xfs_filemap_huge_fault() we then detect this case and
call dax_finish_sync_fault() to make sure all metadata is committed, and
to insert the page table entry.

Note that this will also dirty corresponding radix tree entry which is
what we want - fsync(2) will still provide data integrity guarantees for
applications not using userspace flushing. And applications using
userspace flushing can avoid calling fsync(2) and thus avoid the
performance overhead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c  | 6 +++++-
 fs/xfs/xfs_iomap.c | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7c6b8def6eed..c45f24ffab22 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1040,7 +1040,11 @@ __xfs_filemap_fault(
 
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

