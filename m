Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 987277F5D
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 18:07:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 183ECAC009
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 16:07:22 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	LAcQcag9i3dFigdC for <xfs@oss.sgi.com>;
	Fri, 13 Nov 2015 16:07:20 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 10/11] ext4: add support for DAX fsync/msync
Date: Fri, 13 Nov 2015 17:06:49 -0700
Message-Id: <1447459610-14259-11-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

To properly support the new DAX fsync/msync infrastructure filesystems
need to call dax_pfn_mkwrite() so that DAX can properly track when a user
write faults on a previously cleaned address.  They also need to call
dax_fsync() in the filesystem fsync() path.  This dax_fsync() call uses
addresses retrieved from get_block() so it needs to be ordered with
respect to truncate.  This is accomplished by using the same locking that
was set up for DAX page faults.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext4/file.c  |  4 +++-
 fs/ext4/fsync.c | 12 ++++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 749b222..8c8965c 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -291,8 +291,8 @@ static int ext4_dax_pfn_mkwrite(struct vm_area_struct *vma,
 {
 	struct inode *inode = file_inode(vma->vm_file);
 	struct super_block *sb = inode->i_sb;
-	int ret = VM_FAULT_NOPAGE;
 	loff_t size;
+	int ret;
 
 	sb_start_pagefault(sb);
 	file_update_time(vma->vm_file);
@@ -300,6 +300,8 @@ static int ext4_dax_pfn_mkwrite(struct vm_area_struct *vma,
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (vmf->pgoff >= size)
 		ret = VM_FAULT_SIGBUS;
+	else
+		ret = dax_pfn_mkwrite(vma, vmf);
 	up_read(&EXT4_I(inode)->i_mmap_sem);
 	sb_end_pagefault(sb);
 
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 8850254..e87c29b 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
+#include <linux/dax.h>
 
 #include "ext4.h"
 #include "ext4_jbd2.h"
@@ -86,7 +87,8 @@ static int ext4_sync_parent(struct inode *inode)
 
 int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct inode *inode = file->f_mapping->host;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 	int ret = 0, err;
@@ -112,7 +114,13 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
-	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (dax_mapping(mapping)) {
+		down_read(&ei->i_mmap_sem);
+		dax_fsync(mapping, start, end);
+		up_read(&ei->i_mmap_sem);
+	}
+
+	ret = filemap_write_and_wait_range(mapping, start, end);
 	if (ret)
 		return ret;
 	/*
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
