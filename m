Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A3AC7F62
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 18:07:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AEF6AC011
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 16:07:12 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	7ge1G27wmzYCbe0c for <xfs@oss.sgi.com>;
	Fri, 13 Nov 2015 16:07:10 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 06/11] mm: add pgoff_mkclean()
Date: Fri, 13 Nov 2015 17:06:45 -0700
Message-Id: <1447459610-14259-7-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
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

Introduce pgoff_mkclean() which conceptually is similar to page_mkclean()
except it works in the absence of struct page and it can also be used to
clean PMDs.  This is needed for DAX's dirty page handling.

pgoff_mkclean() doesn't return an error for a missing PTE/PMD when looping
through the VMAs because it's not a requirement that each of the
potentially many VMAs associated with a given struct address_space have a
mapping set up for our pgoff.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/linux/rmap.h |  5 +++++
 mm/rmap.c            | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 29446ae..171a4ac 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -223,6 +223,11 @@ unsigned long page_address_in_vma(struct page *, struct vm_area_struct *);
 int page_mkclean(struct page *);
 
 /*
+ * Cleans and write protects the PTEs of shared mappings.
+ */
+void pgoff_mkclean(pgoff_t, struct address_space *);
+
+/*
  * called in munlock()/munmap() path to check for other vmas holding
  * the page mlocked.
  */
diff --git a/mm/rmap.c b/mm/rmap.c
index f5b5c1f..8114862 100644
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
@@ -1040,6 +1050,47 @@ int page_mkclean(struct page *page)
 }
 EXPORT_SYMBOL_GPL(page_mkclean);
 
+void pgoff_mkclean(pgoff_t pgoff, struct address_space *mapping)
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
+		/* when this returns successfully ptl is locked */
+		ret = follow_pte_pmd(mm, address, &ptep, &pmdp, &ptl);
+		if (ret)
+			continue;
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
+	i_mmap_unlock_read(mapping);
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
