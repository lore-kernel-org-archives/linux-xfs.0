Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 029A47F3F
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 02:48:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CFD4C8F8049
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 00:47:56 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QBkl1E8qtzDsESpq for <xfs@oss.sgi.com>;
	Thu, 01 Oct 2015 00:47:53 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] Revert "dax: fix race between simultaneous faults"
Date: Thu,  1 Oct 2015 17:46:34 +1000
Message-Id: <1443685599-4843-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1443685599-4843-1-git-send-email-david@fromorbit.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com

This reverts commit 843172978bb92997310d2f7fbc172ece423cfc02.
---
 fs/dax.c    | 33 ++++++++++++++++-----------------
 mm/memory.c | 11 +++--------
 2 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 400fe95..3994a2b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -285,6 +285,7 @@ static int copy_user_bh(struct page *to, struct buffer_head *bh,
 static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 			struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct address_space *mapping = inode->i_mapping;
 	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
 	void __pmem *addr;
@@ -292,6 +293,8 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	pgoff_t size;
 	int error;
 
+	i_mmap_lock_read(mapping);
+
 	/*
 	 * Check truncate didn't happen while we were allocating a block.
 	 * If it did, this block may or may not be still allocated to the
@@ -321,6 +324,8 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	error = vm_insert_mixed(vma, vaddr, pfn);
 
  out:
+	i_mmap_unlock_read(mapping);
+
 	return error;
 }
 
@@ -382,17 +387,15 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			 * from a read fault and we've raced with a truncate
 			 */
 			error = -EIO;
-			goto unlock;
+			goto unlock_page;
 		}
-	} else {
-		i_mmap_lock_write(mapping);
 	}
 
 	error = get_block(inode, block, &bh, 0);
 	if (!error && (bh.b_size < PAGE_SIZE))
 		error = -EIO;		/* fs corruption? */
 	if (error)
-		goto unlock;
+		goto unlock_page;
 
 	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
@@ -403,9 +406,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			if (!error && (bh.b_size < PAGE_SIZE))
 				error = -EIO;
 			if (error)
-				goto unlock;
+				goto unlock_page;
 		} else {
-			i_mmap_unlock_write(mapping);
 			return dax_load_hole(mapping, page, vmf);
 		}
 	}
@@ -417,15 +419,17 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		else
 			clear_user_highpage(new_page, vaddr);
 		if (error)
-			goto unlock;
+			goto unlock_page;
 		vmf->page = page;
 		if (!page) {
+			i_mmap_lock_read(mapping);
 			/* Check we didn't race with truncate */
 			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
 								PAGE_SHIFT;
 			if (vmf->pgoff >= size) {
+				i_mmap_unlock_read(mapping);
 				error = -EIO;
-				goto unlock;
+				goto out;
 			}
 		}
 		return VM_FAULT_LOCKED;
@@ -461,8 +465,6 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			WARN_ON_ONCE(!(vmf->flags & FAULT_FLAG_WRITE));
 	}
 
-	if (!page)
-		i_mmap_unlock_write(mapping);
  out:
 	if (error == -ENOMEM)
 		return VM_FAULT_OOM | major;
@@ -471,14 +473,11 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		return VM_FAULT_SIGBUS | major;
 	return VM_FAULT_NOPAGE | major;
 
- unlock:
+ unlock_page:
 	if (page) {
 		unlock_page(page);
 		page_cache_release(page);
-	} else {
-		i_mmap_unlock_write(mapping);
 	}
-
 	goto out;
 }
 EXPORT_SYMBOL(__dax_fault);
@@ -556,10 +555,10 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
-	i_mmap_lock_write(mapping);
 	length = get_block(inode, block, &bh, write);
 	if (length)
 		return VM_FAULT_SIGBUS;
+	i_mmap_lock_read(mapping);
 
 	/*
 	 * If the filesystem isn't willing to tell us the length of a hole,
@@ -633,11 +632,11 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
  out:
+	i_mmap_unlock_read(mapping);
+
 	if (buffer_unwritten(&bh))
 		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
 
-	i_mmap_unlock_write(mapping);
-
 	return result;
 
  fallback:
diff --git a/mm/memory.c b/mm/memory.c
index 5ec066f..deb679c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2427,16 +2427,11 @@ void unmap_mapping_range(struct address_space *mapping,
 		details.last_index = ULONG_MAX;
 
 
-	/*
-	 * DAX already holds i_mmap_lock to serialise file truncate vs
-	 * page fault and page fault vs page fault.
-	 */
-	if (!IS_DAX(mapping->host))
-		i_mmap_lock_write(mapping);
+	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
+	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-	if (!IS_DAX(mapping->host))
-		i_mmap_unlock_write(mapping);
+	i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
