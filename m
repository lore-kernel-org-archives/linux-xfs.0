Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FF7C7F5D
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 18:07:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 401F48F808F
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 16:07:19 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	YtZtoGaqMKcv2U1D for <xfs@oss.sgi.com>;
	Fri, 13 Nov 2015 16:07:17 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 09/11] ext2: add support for DAX fsync/msync
Date: Fri, 13 Nov 2015 17:06:48 -0700
Message-Id: <1447459610-14259-10-git-send-email-ross.zwisler@linux.intel.com>
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
 fs/ext2/file.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 11a42c5..6c30ea2 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -102,8 +102,8 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
 {
 	struct inode *inode = file_inode(vma->vm_file);
 	struct ext2_inode_info *ei = EXT2_I(inode);
-	int ret = VM_FAULT_NOPAGE;
 	loff_t size;
+	int ret;
 
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
@@ -113,6 +113,8 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (vmf->pgoff >= size)
 		ret = VM_FAULT_SIGBUS;
+	else
+		ret = dax_pfn_mkwrite(vma, vmf);
 
 	up_read(&ei->dax_sem);
 	sb_end_pagefault(inode->i_sb);
@@ -161,6 +163,16 @@ int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct super_block *sb = file->f_mapping->host->i_sb;
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 
+#ifdef CONFIG_FS_DAX
+	if (dax_mapping(mapping)) {
+		struct ext2_inode_info *ei = EXT2_I(file_inode(file));
+
+		down_read(&ei->dax_sem);
+		dax_fsync(mapping, start, end);
+		up_read(&ei->dax_sem);
+	}
+#endif
+
 	ret = generic_file_fsync(file, start, end, datasync);
 	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
 		/* We don't really know where the IO error happened... */
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
