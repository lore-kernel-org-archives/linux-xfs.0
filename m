Return-Path: linux-xfs-owner@vger.kernel.org
Received: from aserp2120.oracle.com ([141.146.126.78]:46786 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfHOQGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 12:06:06 -0400
Subject: [PATCH 1/2] mm: set S_SWAPFILE on blockdev swap devices
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Aug 2019 09:05:47 -0700
Message-ID: <156588514761.111054.15427341787826850860.stgit@magnolia>
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

Set S_SWAPFILE on block device inodes so that they have the same
protections as a swap flie.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mm/swapfile.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)


diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0789a762ce2f..a53b7c49b40e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2368,9 +2368,8 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
  * requirements, they are simply tossed out - we will never use those blocks
  * for swapping.
  *
- * For S_ISREG swapfiles we set S_SWAPFILE across the life of the swapon.  This
- * prevents root from shooting her foot off by ftruncating an in-use swapfile,
- * which will scribble on the fs.
+ * For all swap devices we set S_SWAPFILE across the life of the swapon.  This
+ * prevents users from writing to the swap device, which will corrupt memory.
  *
  * The amount of disk space which a single swap extent represents varies.
  * Typically it is in the 1-4 megabyte range.  So we can have hundreds of
@@ -2661,13 +2660,14 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	inode = mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
+
 		set_blocksize(bdev, old_block_size);
 		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
-	} else {
-		inode_lock(inode);
-		inode->i_flags &= ~S_SWAPFILE;
-		inode_unlock(inode);
 	}
+
+	inode_lock(inode);
+	inode->i_flags &= ~S_SWAPFILE;
+	inode_unlock(inode);
 	filp_close(swap_file, NULL);
 
 	/*
@@ -2890,11 +2890,11 @@ static int claim_swapfile(struct swap_info_struct *p, struct inode *inode)
 		p->flags |= SWP_BLKDEV;
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
-		inode_lock(inode);
-		if (IS_SWAPFILE(inode))
-			return -EBUSY;
-	} else
-		return -EINVAL;
+	}
+
+	inode_lock(inode);
+	if (IS_SWAPFILE(inode))
+		return -EBUSY;
 
 	return 0;
 }
@@ -3295,8 +3295,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
-	if (S_ISREG(inode->i_mode))
-		inode->i_flags |= S_SWAPFILE;
+	inode->i_flags |= S_SWAPFILE;
 	error = 0;
 	goto out;
 bad_swap:
@@ -3318,7 +3317,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
 	if (swap_file) {
-		if (inode && S_ISREG(inode->i_mode)) {
+		if (inode) {
 			inode_unlock(inode);
 			inode = NULL;
 		}
@@ -3331,7 +3330,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 	if (name)
 		putname(name);
-	if (inode && S_ISREG(inode->i_mode))
+	if (inode)
 		inode_unlock(inode);
 	if (!error)
 		enable_swap_slots_cache();
