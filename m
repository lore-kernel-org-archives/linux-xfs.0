Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C63057CB3
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 21:34:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B42128F8040
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 19:34:43 -0800 (PST)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	shDPwuFYybnfkOup for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 19:34:42 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 6/6] block: use dax_do_io() if blkdev_dax_capable()
Date: Tue, 16 Feb 2016 20:34:19 -0700
Message-Id: <1455680059-20126-7-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1455680059-20126-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1455680059-20126-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jeff Layton <jlayton@poochiereds.net>, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Al Viro <viro@ftp.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

From: Dan Williams <dan.j.williams@intel.com>

Setting S_DAX on an inode requires that the inode participate in the
DAX-fsync mechanism which expects to use the pagecache for tracking
potentially dirty cpu cachelines.  However, dax_do_io() participates in
the standard pagecache sync semantics and arranges for dirty pages to be
flushed through the driver when a direct-IO operation accesses the same
ranges.

It should always be valid to use the dax_do_io() path regardless of
whether the block_device inode has S_DAX set.  In either case dirty
pages or dirty cachelines are made durable before the direct-IO
operation proceeds.

Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 block/ioctl.c      |  1 +
 fs/block_dev.c     |  3 ++-
 include/linux/fs.h | 31 +++++++++++++++++++++----------
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index d8996bb..7c64286 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -434,6 +434,7 @@ bool blkdev_dax_capable(struct block_device *bdev)
 
 	return true;
 }
+EXPORT_SYMBOL(blkdev_dax_capable);
 #endif
 
 static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 826b164..0e937dd 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -166,8 +166,9 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = bdev_file_inode(file);
+	struct block_device *bdev = I_BDEV(inode);
 
-	if (IS_DAX(inode))
+	if (blkdev_dax_capable(bdev))
 		return dax_do_io(iocb, inode, iter, offset, blkdev_get_block,
 				NULL, DIO_SKIP_DIO_COUNT);
 	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter, offset,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ae68100..a3f5ee8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -830,7 +830,14 @@ static inline unsigned imajor(const struct inode *inode)
 	return MAJOR(inode->i_rdev);
 }
 
+#ifdef CONFIG_BLOCK
 extern struct block_device *I_BDEV(struct inode *inode);
+#else
+static inline struct block_device *I_BDEV(struct inode *inode)
+{
+	return NULL;
+}
+#endif
 
 struct fown_struct {
 	rwlock_t lock;          /* protects pid, uid, euid fields */
@@ -2306,15 +2313,6 @@ extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
-#ifdef CONFIG_FS_DAX
-extern bool blkdev_dax_capable(struct block_device *bdev);
-#else
-static inline bool blkdev_dax_capable(struct block_device *bdev)
-{
-	return false;
-}
-#endif
-
 extern struct super_block *blockdev_superblock;
 
 static inline bool sb_is_blkdev_sb(struct super_block *sb)
@@ -2902,9 +2900,22 @@ extern int generic_show_options(struct seq_file *m, struct dentry *root);
 extern void save_mount_options(struct super_block *sb, char *options);
 extern void replace_mount_options(struct super_block *sb, char *options);
 
+#ifdef CONFIG_FS_DAX
+extern bool blkdev_dax_capable(struct block_device *bdev);
+#else
+static inline bool blkdev_dax_capable(struct block_device *bdev)
+{
+	return false;
+}
+#endif
+
 static inline bool io_is_direct(struct file *filp)
 {
-	return (filp->f_flags & O_DIRECT) || IS_DAX(filp->f_mapping->host);
+	struct inode *inode = filp->f_mapping->host;
+
+	return (filp->f_flags & O_DIRECT) || IS_DAX(inode)
+		|| (S_ISBLK(file_inode(filp)->i_mode)
+				&& blkdev_dax_capable(I_BDEV(inode)));
 }
 
 static inline int iocb_flags(struct file *file)
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
