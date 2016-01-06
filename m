Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE6EC7F59
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 12:01:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51140AC004
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 10:01:23 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id ueJSc0cLp7a2maIx for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 10:01:21 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v7 2/9] dax: fix conversion of holes to PMDs
Date: Wed,  6 Jan 2016 11:00:56 -0700
Message-Id: <1452103263-1592-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1452103263-1592-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1452103263-1592-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

When we get a DAX PMD fault for a write it is possible that there could be
some number of 4k zero pages already present for the same range that were
inserted to service reads from a hole.  These 4k zero pages need to be
unmapped from the VMAs and removed from the struct address_space radix tree
before the real DAX PMD entry can be inserted.

For PTE faults this same use case also exists and is handled by a
combination of unmap_mapping_range() to unmap the VMAs and
delete_from_page_cache() to remove the page from the address_space radix
tree.

For PMD faults we do have a call to unmap_mapping_range() (protected by a
buffer_new() check), but nothing clears out the radix tree entry.  The
buffer_new() check is also incorrect as the current ext4 and XFS filesystem
code will never return a buffer_head with BH_New set, even when allocating
new blocks over a hole.  Instead the filesystem will zero the blocks
manually and return a buffer_head with only BH_Mapped set.

Fix this situation by removing the buffer_new() check and adding a call to
truncate_inode_pages_range() to clear out the radix tree entries before we
insert the DAX PMD.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 03cc4a3..9dc0c97 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -594,6 +594,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	bool write = flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
 	pgoff_t size, pgoff;
+	loff_t lstart, lend;
 	sector_t block;
 	int result = 0;
 
@@ -647,15 +648,13 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		goto fallback;
 	}
 
-	/*
-	 * If we allocated new storage, make sure no process has any
-	 * zero pages covering this hole
-	 */
-	if (buffer_new(&bh)) {
-		i_mmap_unlock_read(mapping);
-		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
-		i_mmap_lock_read(mapping);
-	}
+	/* make sure no process has any zero pages covering this hole */
+	lstart = pgoff << PAGE_SHIFT;
+	lend = lstart + PMD_SIZE - 1; /* inclusive */
+	i_mmap_unlock_read(mapping);
+	unmap_mapping_range(mapping, lstart, PMD_SIZE, 0);
+	truncate_inode_pages_range(mapping, lstart, lend);
+	i_mmap_lock_read(mapping);
 
 	/*
 	 * If a truncate happened while we were allocating blocks, we may
@@ -669,7 +668,8 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		goto out;
 	}
 	if ((pgoff | PG_PMD_COLOUR) >= size) {
-		dax_pmd_dbg(&bh, address, "pgoff unaligned");
+		dax_pmd_dbg(&bh, address,
+				"offset + huge page size > file size");
 		goto fallback;
 	}
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
