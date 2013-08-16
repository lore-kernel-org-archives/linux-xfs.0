Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C22D7F63
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 18:22:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 13508AC00A
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:32 -0700 (PDT)
Received: from mail-pd0-f170.google.com (mail-pd0-f170.google.com
	[209.85.192.170]) by cuda.sgi.com with ESMTP id
	pnKuXZ3Ttgp8WNPH (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Aug 2013 16:22:30 -0700 (PDT)
Received: by mail-pd0-f170.google.com with SMTP id x10so2830010pdj.29
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:30 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 4/5] mm: Scan for dirty ptes and update cmtime on MS_ASYNC
Date: Fri, 16 Aug 2013 16:22:11 -0700
Message-Id: <1c0ffd25b5adb4ea65a29e8858ab4674b10aa9df.1376679411.git.luto@amacapital.net>
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

This is probably unimportant but improves POSIX compliance.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 mm/msync.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 11 deletions(-)

diff --git a/mm/msync.c b/mm/msync.c
index 632df45..9e41acd 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -13,13 +13,16 @@
 #include <linux/file.h>
 #include <linux/syscalls.h>
 #include <linux/sched.h>
+#include <linux/rmap.h>
+#include <linux/pagemap.h>
 
 /*
  * MS_SYNC syncs the entire file - including mappings.
  *
  * MS_ASYNC does not start I/O (it used to, up to 2.5.67).
  * Nor does it marks the relevant pages dirty (it used to up to 2.6.17).
- * Now it doesn't do anything, since dirty pages are properly tracked.
+ * Now all it does is ensure that file timestamps get updated, since POSIX
+ * requires it.  We track dirty pages correct without MS_ASYNC.
  *
  * The application may now run fsync() to
  * write out the dirty pages and wait on the writeout and check the result.
@@ -28,6 +31,57 @@
  * So by _not_ starting I/O in MS_ASYNC we provide complete flexibility to
  * applications.
  */
+
+static int msync_async_range(struct vm_area_struct *vma,
+			      unsigned long *start, unsigned long end)
+{
+	struct mm_struct *mm;
+	struct address_space *mapping;
+	int iters = 0;
+
+	while (*start < end && *start < vma->vm_end && iters < 128) {
+		unsigned int page_mask, page_increm;
+
+		/*
+		 * Require that the pte writable (because otherwise it can't
+		 * be dirty, so there's nothing to clean).
+		 *
+		 * In theory we could check the pte dirty bit, but this is
+		 * awkward and barely worth it.
+		 */
+		struct page *page = follow_page_mask(vma, *start,
+						     FOLL_GET | FOLL_WRITE,
+						     &page_mask);
+
+		if (page && !IS_ERR(page)) {
+			if (lock_page_killable(page) == 0) {
+				page_mkclean(page);
+				unlock_page(page);
+			}
+			put_page(page);
+		}
+
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+
+		page_increm = 1 + (~(*start >> PAGE_SHIFT) & page_mask);
+		*start += page_increm * PAGE_SIZE;
+		cond_resched();
+		iters++;
+	}
+
+	/* XXX: try to do this only once? */
+	mapping = vma->vm_file->f_mapping;
+	if (mapping->a_ops->flush_cmtime)
+		mapping->a_ops->flush_cmtime(mapping);
+
+	/* Give mmap_sem writers a chance. */
+	mm = current->mm;
+	up_read(&mm->mmap_sem);
+	down_read(&mm->mmap_sem);
+	return 0;
+}
+
 SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 {
 	unsigned long end;
@@ -77,18 +131,25 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 			goto out_unlock;
 		}
 		file = vma->vm_file;
-		start = vma->vm_end;
-		if ((flags & MS_SYNC) && file &&
-				(vma->vm_flags & VM_SHARED)) {
-			get_file(file);
-			up_read(&mm->mmap_sem);
-			error = vfs_fsync(file, 0);
-			fput(file);
-			if (error || start >= end)
-				goto out;
-			down_read(&mm->mmap_sem);
+		if (file && vma->vm_flags & VM_SHARED) {
+			if (flags & MS_SYNC) {
+				start = vma->vm_end;
+				get_file(file);
+				up_read(&mm->mmap_sem);
+				error = vfs_fsync(file, 0);
+				fput(file);
+				if (error || start >= end)
+					goto out;
+				down_read(&mm->mmap_sem);
+			} else if ((vma->vm_flags & VM_WRITE) &&
+				   file->f_mapping) {
+				error = msync_async_range(vma, &start, end);
+			} else {
+				start = vma->vm_end;
+			}
 			vma = find_vma(mm, start);
 		} else {
+			start = vma->vm_end;
 			if (start >= end) {
 				error = 0;
 				goto out_unlock;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
