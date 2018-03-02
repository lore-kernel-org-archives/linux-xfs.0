Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10237 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164868AbeCBEDf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Mar 2018 23:03:35 -0500
Subject: [PATCH v5 10/12] fs, dax: kill IS_DAX()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 01 Mar 2018 19:54:28 -0800
Message-ID: <151996286805.28483.12933227722062678008.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, stable@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

In preparation for fixing the broken definition of S_DAX in the
CONFIG_FS_DAX=n + CONFIG_DEV_DAX=y case, convert all the remaining
IS_DAX() usages to use explicit tests for FSDAX.

Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: <stable@vger.kernel.org>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/iomap.c          |    2 +-
 include/linux/dax.h |    2 +-
 include/linux/fs.h  |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index afd163586aa0..fe379d8949fd 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -377,7 +377,7 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 		offset = pos & (PAGE_SIZE - 1); /* Within page */
 		bytes = min_t(loff_t, PAGE_SIZE - offset, count);
 
-		if (IS_DAX(inode))
+		if (IS_FSDAX(inode))
 			status = iomap_dax_zero(pos, offset, bytes, iomap);
 		else
 			status = iomap_zero(inode, pos, offset, bytes, iomap);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 47edbce4fc52..ce520e932adc 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -124,7 +124,7 @@ static inline ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 static inline bool dax_mapping(struct address_space *mapping)
 {
-	return mapping->host && IS_DAX(mapping->host);
+	return mapping->host && IS_FSDAX(mapping->host);
 }
 
 struct writeback_control;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 33e859e7d100..b2b2e15d227b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1903,7 +1903,6 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
 #define IS_IMA(inode)		((inode)->i_flags & S_IMA)
 #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
-#define IS_DAX(inode)		((inode)->i_flags & S_DAX)
 #define IS_ENCRYPTED(inode)	((inode)->i_flags & S_ENCRYPTED)
 
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
@@ -3203,7 +3202,7 @@ extern int file_update_time(struct file *file);
 
 static inline bool io_is_direct(struct file *filp)
 {
-	return (filp->f_flags & O_DIRECT) || IS_DAX(filp->f_mapping->host);
+	return (filp->f_flags & O_DIRECT) || IS_FSDAX(filp->f_mapping->host);
 }
 
 static inline bool vma_is_dax(struct vm_area_struct *vma)

