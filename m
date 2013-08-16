Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 43B547F62
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 18:22:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A21D8F8037
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:29 -0700 (PDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id hBQCcwbsB2pukgaD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:28 -0700 (PDT)
Received: by mail-pa0-f43.google.com with SMTP id hz10so2405617pad.2
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:27 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 3/5] mm: Notify filesystems when it's time to apply a
	deferred cmtime update
Date: Fri, 16 Aug 2013 16:22:10 -0700
Message-Id: <ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
In-Reply-To: <cover.1376679411.git.luto@amacapital.net>
References: <cover.1376679411.git.luto@amacapital.net>
In-Reply-To: <cover.1376679411.git.luto@amacapital.net>
References: <cover.1376679411.git.luto@amacapital.net>
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
   of places, all of which eventually call ->writepages.

 - munmap is called or the mapping is removed when the process exits

 - msync(MS_ASYNC) is called.  Linux currently does nothing for
   msync(MS_ASYNC), but POSIX says that cmtime should be updated some
   time between an mmaped write and the subsequent msync call.
   MS_SYNC calls ->writepages, but MS_ASYNC needs special handling.

Filesystmes that defer cmtime updates should flush them on munmap or
exit.  Finding out that this happened through vm_ops is messy, so
add a new address space op for this.

It's not strictly necessary to call ->flush_cmtime after ->writepages,
but it simplifies the fs code.  As an optional optimization,
filesystems can call mapping_test_clear_cmtime themselves in
->writepages (as long as they're careful to scan all the pages first
-- the cmtime bit may not be set when ->writepages is entered).

This patch does not implement the MS_ASYNC case; that's in the next
patch.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/linux/fs.h        |  9 +++++++++
 include/linux/writeback.h |  1 +
 mm/mmap.c                 |  9 ++++++++-
 mm/page-writeback.c       | 26 ++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 86cf0a4..f224155 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -350,6 +350,15 @@ struct address_space_operations {
 	/* Write back some dirty pages from this mapping. */
 	int (*writepages)(struct address_space *, struct writeback_control *);
 
+	/*
+	 * Userspace expects certain system calls to update cmtime if
+	 * a file has been recently written using a shared vma.  In
+	 * cases where cmtime may need to be updated but writepages is
+	 * not called, this is called instead.  (Implementations
+	 * should call mapping_test_clear_cmtime.)
+	 */
+	void (*flush_cmtime)(struct address_space *);
+
 	/* Set a page dirty.  Return true if this dirtied it */
 	int (*set_page_dirty)(struct page *page);
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 4e198ca..f6e8261 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -174,6 +174,7 @@ typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 
 int generic_writepages(struct address_space *mapping,
 		       struct writeback_control *wbc);
+void generic_flush_cmtime(struct address_space *mapping);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 int write_cache_pages(struct address_space *mapping,
diff --git a/mm/mmap.c b/mm/mmap.c
index 1edbaa3..7ed7700 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1,3 +1,4 @@
+
 /*
  * mm/mmap.c
  *
@@ -249,8 +250,14 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
 	might_sleep();
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
-	if (vma->vm_file)
+	if (vma->vm_file) {
+		if ((vma->vm_flags & VM_SHARED) && vma->vm_file->f_mapping) {
+			struct address_space *mapping = vma->vm_file->f_mapping;
+			if (mapping->a_ops && mapping->a_ops->flush_cmtime)
+				mapping->a_ops->flush_cmtime(mapping);
+		}
 		fput(vma->vm_file);
+	}
 	mpol_put(vma_policy(vma));
 	kmem_cache_free(vm_area_cachep, vma);
 	return next;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3f0c895..9ab8c9e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1928,6 +1928,18 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 		ret = mapping->a_ops->writepages(mapping, wbc);
 	else
 		ret = generic_writepages(mapping, wbc);
+
+	/*
+	 * ->writepages will call clear_page_dirty_for_io, which may, in turn,
+	 * mark the mapping for deferred cmtime update.  As an optimization,
+	 * a filesystem can flush the update at the end of ->writepages
+	 * (possibly avoiding a journal transaction, for example), but,
+	 * for simplicity, let filesystems skip that part and just implement
+	 * ->flush_cmtime.
+	 */
+	if (mapping->a_ops->flush_cmtime)
+		mapping->a_ops->flush_cmtime(mapping);
+
 	return ret;
 }
 
@@ -1970,6 +1982,20 @@ int write_one_page(struct page *page, int wait)
 }
 EXPORT_SYMBOL(write_one_page);
 
+/**
+ * generic_flush_cmtime - perform a deferred cmtime update if needed
+ * @mapping: address space structure
+ *
+ * This is a library function, which implements the flush_cmtime()
+ * address_space_operation.
+ */
+void generic_flush_cmtime(struct address_space *mapping)
+{
+	if (mapping_test_clear_cmtime(mapping))
+		inode_update_time_writable(mapping->host);
+}
+EXPORT_SYMBOL(generic_flush_cmtime);
+
 /*
  * For address_spaces which do not use buffers nor write back.
  */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
