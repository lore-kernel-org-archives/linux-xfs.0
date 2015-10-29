Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E9007F53
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 15:12:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 323C3304053
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 13:12:36 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id PxN4OrpBzM9wdwZt for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 13:12:34 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [RFC 06/11] mm: add pgoff_mkclean()
Date: Thu, 29 Oct 2015 14:12:10 -0600
Message-Id: <1446149535-16200-7-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Jeff Layton <jlayton@poochiereds.net>, x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

Introduce pgoff_mkclean() which conceptually is similar to page_mkclean()
except it works in the absence of struct page and it can also be used to
clean PMDs.  This is needed for DAX's dirty page handling.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/linux/rmap.h |  5 +++++
 mm/rmap.c            | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 29446ae..627875f9 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -223,6 +223,11 @@ unsigned long page_address_in_vma(struct page *, struct vm_area_struct *);
 int page_mkclean(struct page *);
 
 /*
+ * Cleans and write protects the PTEs of shared mappings.
+ */
+int pgoff_mkclean(pgoff_t, struct address_space *);
+
+/*
  * called in munlock()/munmap() path to check for other vmas holding
  * the page mlocked.
  */
diff --git a/mm/rmap.c b/mm/rmap.c
index f5b5c1f..0ce16ab 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -586,6 +586,16 @@ vma_address(struct page *page, struct vm_area_struct *vma)
 	return address;
 }
 
+static inline unsigned long
+pgoff_address(pgoff_t pgoff, struct vm_area_struct *vma)
+{
+	unsigned long address;
+
+	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
+	return address;
+}
+
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 static void percpu_flush_tlb_batch_pages(void *data)
 {
@@ -1040,6 +1050,49 @@ int page_mkclean(struct page *page)
 }
 EXPORT_SYMBOL_GPL(page_mkclean);
 
+int pgoff_mkclean(pgoff_t pgoff, struct address_space *mapping)
+{
+	struct vm_area_struct *vma;
+	int ret = 0;
+
+	i_mmap_lock_read(mapping);
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+		struct mm_struct *mm = vma->vm_mm;
+		pmd_t pmd, *pmdp = NULL;
+		pte_t pte, *ptep = NULL;
+		unsigned long address;
+		spinlock_t *ptl;
+
+		address = pgoff_address(pgoff, vma);
+
+		ret = follow_pte_pmd(mm, address, &ptep, &pmdp, &ptl);
+		if (ret)
+			goto out;
+
+		if (pmdp) {
+			flush_cache_page(vma, address, pmd_pfn(*pmdp));
+			pmd = pmdp_huge_clear_flush(vma, address, pmdp);
+			pmd = pmd_wrprotect(pmd);
+			pmd = pmd_mkclean(pmd);
+			set_pmd_at(mm, address, pmdp, pmd);
+			spin_unlock(ptl);
+		} else {
+			BUG_ON(!ptep);
+			flush_cache_page(vma, address, pte_pfn(*ptep));
+			pte = ptep_clear_flush(vma, address, ptep);
+			pte = pte_wrprotect(pte);
+			pte = pte_mkclean(pte);
+			set_pte_at(mm, address, ptep, pte);
+			pte_unmap_unlock(ptep, ptl);
+		}
+	}
+
+ out:
+	i_mmap_unlock_read(mapping);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pgoff_mkclean);
+
 /**
  * page_move_anon_rmap - move a page to our anon_vma
  * @page:	the page to move to our anon_vma
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
