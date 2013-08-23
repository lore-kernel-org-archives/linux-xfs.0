Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F63A7F6D
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 19:03:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4B54AC001
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:49 -0700 (PDT)
Received: from mail-pb0-f42.google.com (mail-pb0-f42.google.com
	[209.85.160.42]) by cuda.sgi.com with ESMTP id 5Lk3DkXDPBAkPF2g
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:48 -0700 (PDT)
Received: by mail-pb0-f42.google.com with SMTP id un15so2498718pbc.1
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:48 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 6/7] btrfs: Defer mmap cmtime updates
Date: Thu, 22 Aug 2013 17:03:22 -0700
Message-Id: <7d32564366be185ce9a1a8030af394bdfd266c7a.1377193658.git.luto@amacapital.net>
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

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/btrfs/extent_io.c |  1 +
 fs/btrfs/inode.c     | 32 ++++++++++++++++----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fe443fe..dc2f851 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3756,6 +3756,7 @@ int extent_writepages(struct extent_io_tree *tree,
 				       __extent_writepage, &epd,
 				       flush_write_bio);
 	flush_epd_write_bio(&epd);
+	mapping_flush_cmtime(mapping);
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 021694c..fc51380 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7499,10 +7499,8 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	sb_start_pagefault(inode->i_sb);
 	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
-	if (!ret) {
-		ret = file_update_time(vma->vm_file);
+	if (!ret)
 		reserved = 1;
-	}
 	if (ret) {
 		if (ret == -ENOMEM)
 			ret = VM_FAULT_OOM;
@@ -8711,22 +8709,24 @@ static struct extent_io_ops btrfs_extent_io_ops = {
  * For now we're avoiding this by dropping bmap.
  */
 static const struct address_space_operations btrfs_aops = {
-	.readpage	= btrfs_readpage,
-	.writepage	= btrfs_writepage,
-	.writepages	= btrfs_writepages,
-	.readpages	= btrfs_readpages,
-	.direct_IO	= btrfs_direct_IO,
-	.invalidatepage = btrfs_invalidatepage,
-	.releasepage	= btrfs_releasepage,
-	.set_page_dirty	= btrfs_set_page_dirty,
-	.error_remove_page = generic_error_remove_page,
+	.readpage		= btrfs_readpage,
+	.writepage		= btrfs_writepage,
+	.writepages		= btrfs_writepages,
+	.update_cmtime_deferred	= generic_update_cmtime_deferred,
+	.readpages		= btrfs_readpages,
+	.direct_IO		= btrfs_direct_IO,
+	.invalidatepage		= btrfs_invalidatepage,
+	.releasepage		= btrfs_releasepage,
+	.set_page_dirty		= btrfs_set_page_dirty,
+	.error_remove_page	= generic_error_remove_page,
 };
 
 static const struct address_space_operations btrfs_symlink_aops = {
-	.readpage	= btrfs_readpage,
-	.writepage	= btrfs_writepage,
-	.invalidatepage = btrfs_invalidatepage,
-	.releasepage	= btrfs_releasepage,
+	.readpage		= btrfs_readpage,
+	.writepage		= btrfs_writepage,
+	.update_cmtime_deferred	= generic_update_cmtime_deferred,
+	.invalidatepage 	= btrfs_invalidatepage,
+	.releasepage		= btrfs_releasepage,
 };
 
 static const struct inode_operations btrfs_file_inode_operations = {
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
