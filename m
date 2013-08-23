Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBF027F5A
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 19:03:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69DBCAC005
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:45 -0700 (PDT)
Received: from mail-pd0-f182.google.com (mail-pd0-f182.google.com
	[209.85.192.182]) by cuda.sgi.com with ESMTP id
	PLxiDw8bKH3B1IMX (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Aug 2013 17:03:44 -0700 (PDT)
Received: by mail-pd0-f182.google.com with SMTP id r10so2584800pdi.13
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:43 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 4/7] mm: Scan for dirty ptes and update cmtime on MS_ASYNC
Date: Thu, 22 Aug 2013 17:03:20 -0700
Message-Id: <cd44947e645bc37a5ce32626e86596b0d5e667a1.1377193658.git.luto@amacapital.net>
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

This is probably unimportant but improves POSIX compliance.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 mm/msync.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 73 insertions(+), 11 deletions(-)

diff --git a/mm/msync.c b/mm/msync.c
index 632df45..a2ee43c 100644
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
@@ -28,6 +31,54 @@
  * So by _not_ starting I/O in MS_ASYNC we provide complete flexibility to
  * applications.
  */
+
+static int msync_async_range(struct vm_area_struct *vma,
+			      unsigned long *start, unsigned long end)
+{
+	struct mm_struct *mm;
+	int iters = 0;
+
+	while (*start < end && *start < vma->vm_end && iters < 128) {
+		unsigned int page_mask, page_increm;
+
+		/*
+		 * Require that the pte is writable (because otherwise
+		 * it can't be dirty, so there's nothing to clean).
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
+	mapping_flush_cmtime_nowb(vma->vm_file->f_mapping);
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
@@ -77,18 +128,29 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
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
+				if (error || start >= end)
+					goto out_unlock;
+			} else {
+				start = vma->vm_end;
+				if (start >= end)
+					goto out_unlock;
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
