Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10205 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163935AbeCBEC6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Mar 2018 23:02:58 -0500
Subject: [PATCH v5 03/12] ext2, dax: finish implementing dax_sem helpers
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 01 Mar 2018 19:53:50 -0800
Message-ID: <151996283005.28483.12905745385121745420.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: stable@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

dax_sem_{up,down}_write_sem() allow the ext2 dax semaphore to be
compiled out in the CONFIG_FS_DAX=n case. However there are still some
open coded uses of the semaphore. Add dax_sem_{up_read,down_read}() and
dax_sem_assert_held() helpers. Use them to convert all open-coded usages
of the semaphore to the helpers.

Cc: <stable@vger.kernel.org>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/ext2.h  |    6 ++++++
 fs/ext2/file.c  |    5 ++---
 fs/ext2/inode.c |    4 +---
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 032295e1d386..203c31dfe549 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -711,9 +711,15 @@ struct ext2_inode_info {
 #ifdef CONFIG_FS_DAX
 #define dax_sem_down_write(ext2_inode)	down_write(&(ext2_inode)->dax_sem)
 #define dax_sem_up_write(ext2_inode)	up_write(&(ext2_inode)->dax_sem)
+#define dax_sem_assert_held(ei)		WARN_ON(!rwsem_is_locked(&(ei)->dax_sem))
+#define dax_sem_down_read(ext2_inode)	down_read(&(ext2_inode)->dax_sem)
+#define dax_sem_up_read(ext2_inode)	up_read(&(ext2_inode)->dax_sem)
 #else
 #define dax_sem_down_write(ext2_inode)
 #define dax_sem_up_write(ext2_inode)
+#define dax_sem_assert_held(ext2_inode)
+#define dax_sem_down_read(ext2_inode)
+#define dax_sem_up_read(ext2_inode)
 #endif
 
 /*
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 09640220fda8..1c7ea1bcddde 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -91,18 +91,17 @@ static ssize_t ext2_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 static int ext2_dax_fault(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
-	struct ext2_inode_info *ei = EXT2_I(inode);
 	int ret;
 
 	if (vmf->flags & FAULT_FLAG_WRITE) {
 		sb_start_pagefault(inode->i_sb);
 		file_update_time(vmf->vma->vm_file);
 	}
-	down_read(&ei->dax_sem);
+	dax_sem_down_read(EXT2_I(inode));
 
 	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, NULL, &ext2_iomap_ops);
 
-	up_read(&ei->dax_sem);
+	dax_sem_up_read(EXT2_I(inode));
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 9b2ac55ac34f..4783db0e4873 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1187,9 +1187,7 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 	blocksize = inode->i_sb->s_blocksize;
 	iblock = (offset + blocksize-1) >> EXT2_BLOCK_SIZE_BITS(inode->i_sb);
 
-#ifdef CONFIG_FS_DAX
-	WARN_ON(!rwsem_is_locked(&ei->dax_sem));
-#endif
+	dax_sem_assert_held(ei);
 
 	n = ext2_block_to_path(inode, iblock, offsets, NULL);
 	if (n == 0)

