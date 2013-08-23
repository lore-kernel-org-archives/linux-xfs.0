Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A02437F56
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 19:03:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A5F5AC001
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:38 -0700 (PDT)
Received: from mail-pb0-f51.google.com (mail-pb0-f51.google.com
	[209.85.160.51]) by cuda.sgi.com with ESMTP id IVypsp3h2Fo0EHnc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:37 -0700 (PDT)
Received: by mail-pb0-f51.google.com with SMTP id jt11so2459259pbb.38
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:37 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 1/7] mm: Track mappings that have been written via ptes
Date: Thu, 22 Aug 2013 17:03:17 -0700
Message-Id: <f2ac22142b4634b55ff6858d159b45dac96f81b6.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>

This will allow the mm code to figure out when a file has been
changed through a writable mmap.  Future changes will use this
information to update the file timestamp after writes.

This is handled in core mm code for two reasons:

1. Performance.  Setting a bit directly is faster than an indirect
   call to a vma op.

2. Simplicity.  The cmtime bit is set with lots of mm locks held.
   Rather than making filesystems add a new vm operation that needs
   to be aware of locking, it's easier to just get it right in core
   code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/linux/pagemap.h | 16 ++++++++++++++++
 mm/memory.c             |  7 ++++++-
 mm/rmap.c               | 27 +++++++++++++++++++++++++--
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e3dea75..9a461ee 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -25,6 +25,7 @@ enum mapping_flags {
 	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
 	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
 	AS_BALLOON_MAP  = __GFP_BITS_SHIFT + 4, /* balloon page special map */
+	AS_CMTIME	= __GFP_BITS_SHIFT + 5, /* cmtime update deferred */
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
@@ -74,6 +75,21 @@ static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 	return (__force gfp_t)mapping->flags & __GFP_BITS_MASK;
 }
 
+static inline void mapping_set_cmtime(struct address_space * mapping)
+{
+	set_bit(AS_CMTIME, &mapping->flags);
+}
+
+static inline bool mapping_test_cmtime(struct address_space * mapping)
+{
+	return test_bit(AS_CMTIME, &mapping->flags);
+}
+
+static inline bool mapping_test_clear_cmtime(struct address_space * mapping)
+{
+	return test_and_clear_bit(AS_CMTIME, &mapping->flags);
+}
+
 /*
  * This is non-atomic.  Only to be used before the mapping is activated.
  * Probably needs a barrier...
diff --git a/mm/memory.c b/mm/memory.c
index 4026841..1737a90 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1150,8 +1150,13 @@ again:
 			if (PageAnon(page))
 				rss[MM_ANONPAGES]--;
 			else {
-				if (pte_dirty(ptent))
+				if (pte_dirty(ptent)) {
+					struct address_space *mapping =
+						page_mapping(page);
+					if (mapping)
+						mapping_set_cmtime(mapping);
 					set_page_dirty(page);
+				}
 				if (pte_young(ptent) &&
 				    likely(!(vma->vm_flags & VM_SEQ_READ)))
 					mark_page_accessed(page);
diff --git a/mm/rmap.c b/mm/rmap.c
index b2e29ac..2e3fb27 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -928,6 +928,10 @@ static int page_mkclean_file(struct address_space *mapping, struct page *page)
 		}
 	}
 	mutex_unlock(&mapping->i_mmap_mutex);
+
+	if (ret)
+		mapping_set_cmtime(mapping);
+
 	return ret;
 }
 
@@ -1179,6 +1183,19 @@ out:
 }
 
 /*
+ * Mark a page's mapping for future cmtime update.  It's safe to call this
+ * on any page, but it only has any effect if the page is backed by a mapping
+ * that uses mapping_test_clear_cmtime to handle file time updates.  This means
+ * that there's no need to call this on for non-VM_SHARED vmas.
+ */
+static void page_set_cmtime(struct page *page)
+{
+	struct address_space *mapping = page_mapping(page);
+	if (mapping)
+		mapping_set_cmtime(mapping);
+}
+
+/*
  * Subfunctions of try_to_unmap: try_to_unmap_one called
  * repeatedly from try_to_unmap_ksm, try_to_unmap_anon or try_to_unmap_file.
  */
@@ -1219,8 +1236,11 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	pteval = ptep_clear_flush(vma, address, pte);
 
 	/* Move the dirty bit to the physical page now the pte is gone. */
-	if (pte_dirty(pteval))
+	if (pte_dirty(pteval)) {
 		set_page_dirty(page);
+		if (vma->vm_flags & VM_SHARED)
+			page_set_cmtime(page);
+	}
 
 	/* Update high watermark before we lower rss */
 	update_hiwater_rss(mm);
@@ -1413,8 +1433,11 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
 		}
 
 		/* Move the dirty bit to the physical page now the pte is gone. */
-		if (pte_dirty(pteval))
+		if (pte_dirty(pteval)) {
 			set_page_dirty(page);
+			if (vma->vm_flags & VM_SHARED)
+				page_set_cmtime(page);
+		}
 
 		page_remove_rmap(page);
 		page_cache_release(page);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
