Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:14117 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933192AbcJLWuu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Oct 2016 18:50:50 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v6 16/17] xfs: use struct iomap based DAX PMD fault path
Date: Wed, 12 Oct 2016 16:50:21 -0600
Message-Id: <20161012225022.15507-17-ross.zwisler@linux.intel.com>
In-Reply-To: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
References: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Switch xfs_filemap_pmd_fault() from using dax_pmd_fault() to the new and
improved dax_iomap_pmd_fault().  Also, now that it has no more users,
remove xfs_get_blocks_dax_fault().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_aops.c | 26 +++++---------------------
 fs/xfs/xfs_aops.h |  3 ---
 fs/xfs/xfs_file.c |  2 +-
 3 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0e2a931..1c73d0a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1298,8 +1298,7 @@ __xfs_get_blocks(
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
 	int			create,
-	bool			direct,
-	bool			dax_fault)
+	bool			direct)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1420,13 +1419,8 @@ __xfs_get_blocks(
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
 		/* direct IO needs special help */
-		if (create) {
-			if (dax_fault)
-				ASSERT(!ISUNWRITTEN(&imap));
-			else
-				xfs_map_direct(inode, bh_result, &imap, offset,
-						is_cow);
-		}
+		if (create)
+			xfs_map_direct(inode, bh_result, &imap, offset, is_cow);
 	}
 
 	/*
@@ -1466,7 +1460,7 @@ xfs_get_blocks(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, false, false);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
 }
 
 int
@@ -1476,17 +1470,7 @@ xfs_get_blocks_direct(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, true, false);
-}
-
-int
-xfs_get_blocks_dax_fault(
-	struct inode		*inode,
-	sector_t		iblock,
-	struct buffer_head	*bh_result,
-	int			create)
-{
-	return __xfs_get_blocks(inode, iblock, bh_result, create, true, true);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, true);
 }
 
 /*
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index b3c6634..34dc00d 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -59,9 +59,6 @@ int	xfs_get_blocks(struct inode *inode, sector_t offset,
 		       struct buffer_head *map_bh, int create);
 int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
 			      struct buffer_head *map_bh, int create);
-int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
-			         struct buffer_head *map_bh, int create);
-
 int	xfs_end_io_direct_write(struct kiocb *iocb, loff_t offset,
 		ssize_t size, void *private);
 int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8f12152..7b13dda 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1750,7 +1750,7 @@ xfs_filemap_pmd_fault(
 	}
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	ret = dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault);
+	ret = dax_iomap_pmd_fault(vma, addr, pmd, flags, &xfs_iomap_ops);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (flags & FAULT_FLAG_WRITE)
-- 
2.9.0

