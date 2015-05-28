Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A3677F55
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 18:46:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 159AAAC003
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:46:12 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bgtcOh3Lhl193SHA for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 16:46:11 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yy7Uy-0006cq-9O
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yy7Uy-00024Q-8c
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] dax: expose __dax_fault for filesystems with locking
	constraints
Date: Fri, 29 May 2015 09:45:50 +1000
Message-Id: <1432856755-7859-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1432856755-7859-1-git-send-email-david@fromorbit.com>
References: <1432856755-7859-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Some filesystems cannot call dax_fault() directly because they have
different locking and/or allocation constraints in the page fault IO
path. To handle this, we need to follow the same model as the
generic block_page_mkwrite code, where the internals are exposed via
__block_page_mkwrite() so that filesystems can wrap the correct
locking and operations around the outside.

This is loosely based on a patch originally from Matthew Willcox.
Unlike the original patch, it does not change ext4 code, error
returns or unwritten extent conversion handling.  It also adds a
__dax_mkwrite() wrapper for .page_mkwrite implementations to do the
right thing, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/dax.c           | 15 +++++++++++++--
 include/linux/fs.h |  5 ++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4bb5b7c..99b5fbc 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -312,7 +312,17 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	return error;
 }
 
-static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+/**
+ * __dax_fault - handle a page fault on a DAX file
+ * @vma: The virtual memory area where the fault occurred
+ * @vmf: The description of the fault
+ * @get_block: The filesystem method used to translate file offsets to blocks
+ *
+ * When a page fault occurs, filesystems may call this helper in their
+ * fault handler for DAX files. __dax_fault() assumes the caller has done all
+ * the necessary locking for the page fault to proceed successfully.
+ */
+int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			get_block_t get_block, dax_iodone_t complete_unwritten)
 {
 	struct file *file = vma->vm_file;
@@ -443,6 +453,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	}
 	goto out;
 }
+EXPORT_SYMBOL(__dax_fault);
 
 /**
  * dax_fault - handle a page fault on a DAX file
@@ -463,7 +474,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
 	}
-	result = do_dax_fault(vma, vmf, get_block, complete_unwritten);
+	result = __dax_fault(vma, vmf, get_block, complete_unwritten);
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(sb);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c9b4cca..5784377 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2630,8 +2630,11 @@ int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
 		dax_iodone_t);
+int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
+		dax_iodone_t);
 int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
-#define dax_mkwrite(vma, vmf, gb, iod)	dax_fault(vma, vmf, gb, iod)
+#define dax_mkwrite(vma, vmf, gb, iod)		dax_fault(vma, vmf, gb, iod)
+#define __dax_mkwrite(vma, vmf, gb, iod)	__dax_fault(vma, vmf, gb, iod)
 
 #ifdef CONFIG_BLOCK
 typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
