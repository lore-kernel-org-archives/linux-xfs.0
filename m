Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08EE47CBF
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 15:12:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C9F8AC003
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 13:12:37 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id JGC5Q0L5sdOVFkYR for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 13:12:36 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [RFC 08/11] fs: add get_block() to struct inode_operations
Date: Thu, 29 Oct 2015 14:12:12 -0600
Message-Id: <1446149535-16200-9-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Jeff Layton <jlayton@poochiereds.net>, x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

To be able to flush dirty pages to media as part of the fsync/msync path
DAX needs to be able to map file offsets to kernel addresses via a
combination of the filesystem's get_block() routine and
bdev_direct_access().  This currently happens in the DAX fault handlers
which receive a get_block() callback directly from the filesystem via a
function parameter.

For the fsync/msync path this doesn't work, though, because DAX is called
not by the filesystem but by the writeback infrastructure which doesn't
know about the filesystem specific get_block() routine.

To handle this we make get_block() an entry in the struct inode_operations
table so that we can access the correct get_block() routine in the
context of the writeback infrastructure.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext2/file.c     | 1 +
 fs/ext4/file.c     | 1 +
 fs/xfs/xfs_iops.c  | 1 +
 include/linux/fs.h | 4 ++--
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 11a42c5..fc1418c 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -202,4 +202,5 @@ const struct inode_operations ext2_file_inode_operations = {
 	.get_acl	= ext2_get_acl,
 	.set_acl	= ext2_set_acl,
 	.fiemap		= ext2_fiemap,
+	.get_block	= ext2_get_block,
 };
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 113837e..54d7729 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -720,5 +720,6 @@ const struct inode_operations ext4_file_inode_operations = {
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
 	.fiemap		= ext4_fiemap,
+	.get_block	= ext4_get_block_dax,
 };
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8294132..c58c270 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1112,6 +1112,7 @@ static const struct inode_operations xfs_inode_operations = {
 	.listxattr		= xfs_vn_listxattr,
 	.fiemap			= xfs_vn_fiemap,
 	.update_time		= xfs_vn_update_time,
+	.get_block		= xfs_get_blocks_direct,
 };
 
 static const struct inode_operations xfs_dir_inode_operations = {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f791698..1dca85b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1679,8 +1679,8 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
-
-	/* WARNING: probably going away soon, do not use! */
+	int (*get_block)(struct inode *inode, sector_t iblock,
+			struct buffer_head *bh_result, int create);
 } ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
