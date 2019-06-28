Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54214 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfF1Sfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 14:35:36 -0400
Subject: [PATCH 2/2] vfs: don't allow writes to swap files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 28 Jun 2019 11:35:24 -0700
Message-ID: <156174692434.1557844.13804911834937629088.stgit@magnolia>
In-Reply-To: <156174691124.1557844.14293659081769020256.stgit@magnolia>
References: <156174691124.1557844.14293659081769020256.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, akpm@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't let userspace write to an active swap file because the kernel
effectively has a long term lease on the storage and things could get
seriously corrupted if we let this happen.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/attr.c      |   16 ++++++++--------
 fs/block_dev.c |    3 +++
 mm/filemap.c   |    3 +++
 mm/memory.c    |    3 ++-
 mm/mmap.c      |    2 ++
 mm/swapfile.c  |   12 +++++++++++-
 6 files changed, 29 insertions(+), 10 deletions(-)


diff --git a/fs/attr.c b/fs/attr.c
index 1fcfdcc5b367..7480d5dd22c0 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -134,6 +134,14 @@ EXPORT_SYMBOL(setattr_prepare);
  */
 int inode_newsize_ok(const struct inode *inode, loff_t offset)
 {
+	/*
+	 * Truncation of in-use swapfiles is disallowed - the kernel owns the
+	 * disk space now.  We must prevent subsequent swapout to scribble on
+	 * the now-freed blocks.
+	 */
+	if (IS_SWAPFILE(inode) && inode->i_size != offset)
+		return -ETXTBSY;
+
 	if (inode->i_size < offset) {
 		unsigned long limit;
 
@@ -142,14 +150,6 @@ int inode_newsize_ok(const struct inode *inode, loff_t offset)
 			goto out_sig;
 		if (offset > inode->i_sb->s_maxbytes)
 			goto out_big;
-	} else {
-		/*
-		 * truncation of in-use swapfiles is disallowed - it would
-		 * cause subsequent swapout to scribble on the now-freed
-		 * blocks.
-		 */
-		if (IS_SWAPFILE(inode))
-			return -ETXTBSY;
 	}
 
 	return 0;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 749f5984425d..f57d15e5338b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1948,6 +1948,9 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (bdev_read_only(I_BDEV(bd_inode)))
 		return -EPERM;
 
+	if (IS_SWAPFILE(bd_inode))
+		return -ETXTBSY;
+
 	if (!iov_iter_count(from))
 		return 0;
 
diff --git a/mm/filemap.c b/mm/filemap.c
index dad85e10f5f8..fd80bc20e30a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2938,6 +2938,9 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	if (IS_IMMUTABLE(inode))
 		return -EPERM;
 
+	if (IS_SWAPFILE(inode))
+		return -ETXTBSY;
+
 	if (!iov_iter_count(from))
 		return 0;
 
diff --git a/mm/memory.c b/mm/memory.c
index abf795277f36..5acb5bb04e21 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2236,7 +2236,8 @@ static vm_fault_t do_page_mkwrite(struct vm_fault *vmf)
 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 
 	if (vmf->vma->vm_file &&
-	    IS_IMMUTABLE(vmf->vma->vm_file->f_mapping->host))
+	    (IS_IMMUTABLE(vmf->vma->vm_file->f_mapping->host) ||
+	     IS_SWAPFILE(vmf->vma->vm_file->f_mapping->host)))
 		return VM_FAULT_SIGBUS;
 
 	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
diff --git a/mm/mmap.c b/mm/mmap.c
index b3ebca2702bf..1abe55822324 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1488,6 +1488,8 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 					return -EACCES;
 				if (IS_IMMUTABLE(file->f_mapping->host))
 					return -EPERM;
+				if (IS_SWAPFILE(file->f_mapping->host))
+					return -ETXTBSY;
 			}
 
 			/*
diff --git a/mm/swapfile.c b/mm/swapfile.c
index fa4edd0cca3a..1fc820c71baf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3165,6 +3165,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap;
 
+	/*
+	 * Flush any pending IO and dirty mappings before we start using this
+	 * swap device.
+	 */
+	inode->i_flags |= S_SWAPFILE;
+	error = inode_drain_writes(inode);
+	if (error) {
+		inode->i_flags &= ~S_SWAPFILE;
+		goto bad_swap;
+	}
+
 	mutex_lock(&swapon_mutex);
 	prio = -1;
 	if (swap_flags & SWAP_FLAG_PREFER)
@@ -3185,7 +3196,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
-	inode->i_flags |= S_SWAPFILE;
 	error = 0;
 	goto out;
 bad_swap:
