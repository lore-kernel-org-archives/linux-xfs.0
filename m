Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B3637F54
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:51:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58CB88F8050
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:51:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	q2BgAnJtQHuceX3j for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:51:21 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] dax: expose __dax_fault for filesystems with locking
	constraints
Date: Tue, 24 Mar 2015 21:51:01 +1100
Message-Id: <1427194266-2885-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194266-2885-1-git-send-email-david@fromorbit.com>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

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
---
 fs/dax.c           | 15 +++++++++++++--
 include/linux/fs.h |  5 ++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 431ec2b..0121f7d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -313,7 +313,17 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
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
@@ -440,6 +450,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	}
 	goto out;
 }
+EXPORT_SYMBOL(__dax_fault);
 
 /**
  * dax_fault - handle a page fault on a DAX file
@@ -460,7 +471,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
 	}
-	result = do_dax_fault(vma, vmf, get_block, complete_unwritten);
+	result = __dax_fault(vma, vmf, get_block, complete_unwritten);
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(sb);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 82100ae..7e5a2d6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2606,7 +2606,10 @@ int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
 		dax_iodone_t);
-#define dax_mkwrite(vma, vmf, gb, iod)	dax_fault(vma, vmf, gb, iod)
+int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
+		dax_iodone_t);
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
