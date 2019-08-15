Return-Path: linux-xfs-owner@vger.kernel.org
Received: from aserp2120.oracle.com ([141.146.126.78]:47096 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfHOQGT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 12:06:19 -0400
Subject: [PATCH 2/2] vfs: don't allow writes to swap files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Aug 2019 09:05:56 -0700
Message-ID: <156588515613.111054.13578448017133006248.stgit@magnolia>
In-Reply-To: <156588514105.111054.13645634739408399209.stgit@magnolia>
References: <156588514105.111054.13645634739408399209.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: hch@infradead.org, akpm@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't let userspace write to an active swap file because the kernel
effectively has a long term lease on the storage and things could get
seriously corrupted if we let this happen.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/block_dev.c |    3 +++
 mm/filemap.c   |    3 +++
 mm/memory.c    |    4 ++++
 mm/mmap.c      |    8 ++++++--
 mm/swapfile.c  |   12 +++++++++++-
 5 files changed, 27 insertions(+), 3 deletions(-)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index eb657ab94060..017f46719ebe 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -2011,6 +2011,9 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (bdev_read_only(I_BDEV(bd_inode)))
 		return -EPERM;
 
+	if (IS_SWAPFILE(bd_inode))
+		return -ETXTBSY;
+
 	if (!iov_iter_count(from))
 		return 0;
 
diff --git a/mm/filemap.c b/mm/filemap.c
index d0cf700bf201..40667c2f3383 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2988,6 +2988,9 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	loff_t count;
 	int ret;
 
+	if (IS_SWAPFILE(inode))
+		return -ETXTBSY;
+
 	if (!iov_iter_count(from))
 		return 0;
 
diff --git a/mm/memory.c b/mm/memory.c
index e2bb51b6242e..b1dff75640b7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2196,6 +2196,10 @@ static vm_fault_t do_page_mkwrite(struct vm_fault *vmf)
 
 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 
+	if (vmf->vma->vm_file &&
+	    IS_SWAPFILE(vmf->vma->vm_file->f_mapping->host))
+		return VM_FAULT_SIGBUS;
+
 	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
 	/* Restore original flags so that caller is not surprised */
 	vmf->flags = old_flags;
diff --git a/mm/mmap.c b/mm/mmap.c
index 7e8c3e8ae75f..6bc21fca20bc 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1483,8 +1483,12 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		case MAP_SHARED_VALIDATE:
 			if (flags & ~flags_mask)
 				return -EOPNOTSUPP;
-			if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
-				return -EACCES;
+			if (prot & PROT_WRITE) {
+				if (!(file->f_mode & FMODE_WRITE))
+					return -EACCES;
+				if (IS_SWAPFILE(file->f_mapping->host))
+					return -ETXTBSY;
+			}
 
 			/*
 			 * Make sure we don't allow writing to an append-only
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a53b7c49b40e..dab43523afdd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3275,6 +3275,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
@@ -3295,7 +3306,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
-	inode->i_flags |= S_SWAPFILE;
 	error = 0;
 	goto out;
 bad_swap:
