Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 31B537F58
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 19:03:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 041CB304064
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:43 -0700 (PDT)
Received: from mail-pd0-f172.google.com (mail-pd0-f172.google.com
	[209.85.192.172]) by cuda.sgi.com with ESMTP id
	4vEDFDJLgZv5Lsvx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Aug 2013 17:03:41 -0700 (PDT)
Received: by mail-pd0-f172.google.com with SMTP id z10so2580409pdj.3
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:41 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 3/7] mm: Allow filesystems to defer cmtime updates
Date: Thu, 22 Aug 2013 17:03:19 -0700
Message-Id: <e1620c8e4909a65e270c8e9590e307c22fd96a44.1377193658.git.luto@amacapital.net>
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

Filesystems that defer cmtime updates should update cmtime when any
of these events happen after a write via a mapping:

 - The mapping is written back to disk.  This happens from all kinds
   of places, most of which eventually call ->writepages.  (The
   exceptions are vmscan and migration.)

 - munmap is called or the mapping is removed when the process exits

 - msync(MS_ASYNC) is called.  Linux currently does nothing for
   msync(MS_ASYNC), but POSIX says that cmtime should be updated some
   time between an mmaped write and the subsequent msync call.
   MS_SYNC calls ->writepages, but MS_ASYNC needs special handling.

Filesystems are responsible for checking for pending deferred cmtime
updates in .writepages (a helper is provided for this purpose) and
for doing the actual update in .update_cmtime_deferred.

These changes have no effect by themselves; filesystems must opt in
by implementing .update_cmtime_deferred and removing any
file_update_time call in .page_mkwrite.

This patch does not implement the MS_ASYNC case; that's in the next
patch.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/linux/fs.h        |  8 +++++++
 include/linux/pagemap.h   |  6 ++++++
 include/linux/writeback.h |  1 +
 mm/migrate.c              |  2 ++
 mm/mmap.c                 |  6 +++++-
 mm/page-writeback.c       | 53 ++++++++++++++++++++++++++++++++++++++++++++++-
 mm/vmscan.c               |  1 +
 7 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 86cf0a4..f6b0f8b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -350,6 +350,14 @@ struct address_space_operations {
 	/* Write back some dirty pages from this mapping. */
 	int (*writepages)(struct address_space *, struct writeback_control *);
 
+	/*
+	 * Called when a deferred cmtime update should be applied.
+	 * Implementations should update cmtime.  (As an optional
+	 * optimization, implementaions can call mapping_test_clear_cmtime
+	 * from writepages as well.)
+	 */
+	void (*update_cmtime_deferred)(struct address_space *);
+
 	/* Set a page dirty.  Return true if this dirtied it */
 	int (*set_page_dirty)(struct page *page);
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 9a461ee..2647a13 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -90,6 +90,12 @@ static inline bool mapping_test_clear_cmtime(struct address_space * mapping)
 	return test_and_clear_bit(AS_CMTIME, &mapping->flags);
 }
 
+/* Use this one in writepages, etc. */
+extern void mapping_flush_cmtime(struct address_space * mapping);
+
+/* Use this one outside writeback. */
+extern void mapping_flush_cmtime_nowb(struct address_space * mapping);
+
 /*
  * This is non-atomic.  Only to be used before the mapping is activated.
  * Probably needs a barrier...
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 4e198ca..efe4970 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -174,6 +174,7 @@ typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 
 int generic_writepages(struct address_space *mapping,
 		       struct writeback_control *wbc);
+void generic_update_cmtime_deferred(struct address_space *mapping);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 int write_cache_pages(struct address_space *mapping,
diff --git a/mm/migrate.c b/mm/migrate.c
index 6f0c244..e4124e2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -627,6 +627,8 @@ static int writeout(struct address_space *mapping, struct page *page)
 		/* unlocked. Relock */
 		lock_page(page);
 
+	mapping_flush_cmtime(mapping);
+
 	return (rc < 0) ? -EIO : -EAGAIN;
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 1edbaa3..189eb7a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1,3 +1,4 @@
+
 /*
  * mm/mmap.c
  *
@@ -249,8 +250,11 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
 	might_sleep();
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
-	if (vma->vm_file)
+	if (vma->vm_file) {
+		if ((vma->vm_flags & VM_SHARED) && vma->vm_file->f_mapping)
+			mapping_flush_cmtime_nowb(vma->vm_file->f_mapping);
 		fput(vma->vm_file);
+	}
 	mpol_put(vma_policy(vma));
 	kmem_cache_free(vm_area_cachep, vma);
 	return next;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3f0c895..4ec8c02 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1912,12 +1912,30 @@ int generic_writepages(struct address_space *mapping,
 
 	blk_start_plug(&plug);
 	ret = write_cache_pages(mapping, wbc, __writepage, mapping);
+	mapping_flush_cmtime(mapping);
 	blk_finish_plug(&plug);
 	return ret;
 }
-
 EXPORT_SYMBOL(generic_writepages);
 
+/**
+ * generic_update_cmtime_deferred - update cmtime after an mmapped write
+ * @mapping: The mapping
+ *
+ * This library function implements .update_cmtime_deferred.  It is unlikely
+ * that any filesystem will want to do anything here except update the time
+ * (using this helper) or nothing at all (by leaving .update_cmtime_deferred
+ * NULL).
+ */
+void generic_update_cmtime_deferred(struct address_space *mapping)
+{
+	struct blk_plug plug;
+	blk_start_plug(&plug);
+	inode_update_time_writable(mapping->host);
+	blk_finish_plug(&plug);
+}
+EXPORT_SYMBOL(generic_update_cmtime_deferred);
+
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
@@ -1970,6 +1988,39 @@ int write_one_page(struct page *page, int wait)
 }
 EXPORT_SYMBOL(write_one_page);
 
+void mapping_flush_cmtime(struct address_space *mapping)
+{
+	if (mapping_test_clear_cmtime(mapping) &&
+	    mapping->a_ops->update_cmtime_deferred)
+		mapping->a_ops->update_cmtime_deferred(mapping);
+}
+EXPORT_SYMBOL(mapping_flush_cmtime);
+
+void mapping_flush_cmtime_nowb(struct address_space *mapping)
+{
+	/*
+	 * We get called from munmap and msync.  Both calls can race
+	 * with fs freezing.  If the fs is frozen after
+	 * mapping_test_clear_cmtime but before the time update, then
+	 * sync_filesystem will miss the cmtime update (because we
+	 * just cleared it) and we don't be able to write (because the
+	 * fs is frozen).  On the other hand, we can't just return if
+	 * we're in the SB_FREEZE_PAGEFAULT state because our caller
+	 * expects the timestamp to be synchronously updated.  So we
+	 * get write access without blocking, at the SB_FREEZE_FS
+	 * level.  If the fs is already fully frozen, then we already
+	 * know we have nothing to do.
+	 */
+
+	if (!mapping_test_cmtime(mapping))
+		return;  /* Optimization: nothing to do. */
+
+	if (__sb_start_write(mapping->host->i_sb, SB_FREEZE_FS, false)) {
+		mapping_flush_cmtime(mapping);
+		__sb_end_write(mapping->host->i_sb, SB_FREEZE_FS);
+	}
+}
+
 /*
  * For address_spaces which do not use buffers nor write back.
  */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2cff0d4..3b759e7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -429,6 +429,7 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 		res = mapping->a_ops->writepage(page, &wbc);
 		if (res < 0)
 			handle_write_error(mapping, page, res);
+		mapping_flush_cmtime(mapping);
 		if (res == AOP_WRITEPAGE_ACTIVATE) {
 			ClearPageReclaim(page);
 			return PAGE_ACTIVATE;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
