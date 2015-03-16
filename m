Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AFE77F58
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 06:35:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 093D8304032
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:16 -0700 (PDT)
Received: from mail-pd0-f176.google.com (mail-pd0-f176.google.com
	[209.85.192.176]) by cuda.sgi.com with ESMTP id
	o8FxEApUELnw7YK6 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2015 04:35:14 -0700 (PDT)
Received: by pdbni2 with SMTP id ni2so56102740pdb.1
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:14 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 2/5] Remove rw from {,__,do_}blockdev_direct_IO()
Date: Mon, 16 Mar 2015 04:33:50 -0700
Message-Id: <16009f67c954bb645848d55d75a2601023604055.1426502566.git.osandov@osandov.com>
In-Reply-To: <cover.1426502566.git.osandov@osandov.com>
References: <cover.1426502566.git.osandov@osandov.com>
In-Reply-To: <cover.1426502566.git.osandov@osandov.com>
References: <cover.1426502566.git.osandov@osandov.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, osd-dev@open-osd.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, HPDD-discuss@lists.01.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, Jan Kara <jack@suse.cz>, Trond Myklebust <trond.myklebust@primarydata.com>, David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Changman Lee <cm224.lee@samsung.com>, Boaz Harrosh <ooo@electrozaur.com>, Eric Van Hensbergen <ericvh@gmail.com>, Mark Fasheh <mfasheh@suse.com>, Oleg Drokin <oleg.drokin@intel.com>, Joel Becker <jlbec@evilplan.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Benny Halevy <bhalevy@primarydata.com>, Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, Ron Minnich <rminnich@sandia.gov>, Omar Sandoval <osandov@osandov.com>, Anna Schumaker <anna.schumaker@netapp.com>

Most filesystems call through to these at some point, so we'll start
here.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/affs/file.c      |  2 +-
 fs/block_dev.c      |  5 ++---
 fs/btrfs/inode.c    |  8 ++++----
 fs/direct-io.c      | 39 ++++++++++++++++++---------------------
 fs/ext2/inode.c     |  2 +-
 fs/ext3/inode.c     |  2 +-
 fs/ext4/indirect.c  | 11 ++++++-----
 fs/ext4/inode.c     |  2 +-
 fs/f2fs/data.c      |  2 +-
 fs/fat/inode.c      |  2 +-
 fs/gfs2/aops.c      |  5 ++---
 fs/hfs/inode.c      |  2 +-
 fs/hfsplus/inode.c  |  3 +--
 fs/jfs/inode.c      |  2 +-
 fs/nilfs2/inode.c   |  3 +--
 fs/ocfs2/aops.c     | 16 +++++++---------
 fs/reiserfs/inode.c |  2 +-
 fs/udf/inode.c      |  2 +-
 fs/xfs/xfs_aops.c   |  9 ++++-----
 include/linux/fs.h  | 22 ++++++++++++----------
 20 files changed, 67 insertions(+), 74 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index d2468bf..f3028aa 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -405,7 +405,7 @@ affs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 			return 0;
 	}
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, affs_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, offset, affs_get_block);
 	if (ret < 0 && (rw & WRITE))
 		affs_write_failed(mapping, offset + count);
 	return ret;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 975266b..e3a3125 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -153,9 +153,8 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iter,
-				    offset, blkdev_get_block,
-				    NULL, NULL, 0);
+	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter, offset,
+				    blkdev_get_block, NULL, NULL, 0);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index da828cf..d6413f4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8119,10 +8119,10 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		wakeup = false;
 	}
 
-	ret = __blockdev_direct_IO(rw, iocb, inode,
-			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
-			iter, offset, btrfs_get_blocks_direct, NULL,
-			btrfs_submit_direct, flags);
+	ret = __blockdev_direct_IO(iocb, inode,
+				   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
+				   iter, offset, btrfs_get_blocks_direct, NULL,
+				   btrfs_submit_direct, flags);
 	if (rw & WRITE) {
 		if (ret < 0 && ret != -EIOCBQUEUED)
 			btrfs_delalloc_release_space(inode, count);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index e181b6b..02a87d9 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1094,10 +1094,10 @@ static inline int drop_refcount(struct dio *dio)
  * for the whole file.
  */
 static inline ssize_t
-do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, struct iov_iter *iter, loff_t offset, 
-	get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags)
+do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
+		      struct block_device *bdev, struct iov_iter *iter,
+		      loff_t offset, get_block_t get_block, dio_iodone_t end_io,
+		      dio_submit_t submit_io, int flags)
 {
 	unsigned i_blkbits = ACCESS_ONCE(inode->i_blkbits);
 	unsigned blkbits = i_blkbits;
@@ -1111,9 +1111,6 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct blk_plug plug;
 	unsigned long align = offset | iov_iter_alignment(iter);
 
-	if (rw & WRITE)
-		rw = WRITE_ODIRECT;
-
 	/*
 	 * Avoid references to bdev if not absolutely needed to give
 	 * the early prefetch in the caller enough time.
@@ -1128,7 +1125,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	}
 
 	/* watch out for a 0 len io from a tricksy fs */
-	if (rw == READ && !iov_iter_count(iter))
+	if (iov_iter_rw(iter) == READ && !iov_iter_count(iter))
 		return 0;
 
 	dio = kmem_cache_alloc(dio_cache, GFP_KERNEL);
@@ -1144,7 +1141,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 	dio->flags = flags;
 	if (dio->flags & DIO_LOCKING) {
-		if (rw == READ) {
+		if (iov_iter_rw(iter) == READ) {
 			struct address_space *mapping =
 					iocb->ki_filp->f_mapping;
 
@@ -1170,19 +1167,19 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (is_sync_kiocb(iocb))
 		dio->is_async = false;
 	else if (!(dio->flags & DIO_ASYNC_EXTEND) &&
-            (rw & WRITE) && end > i_size_read(inode))
+		 iov_iter_rw(iter) == WRITE && end > i_size_read(inode))
 		dio->is_async = false;
 	else
 		dio->is_async = true;
 
 	dio->inode = inode;
-	dio->rw = rw;
+	dio->rw = iov_iter_rw(iter) == WRITE ? WRITE_ODIRECT : READ;
 
 	/*
 	 * For AIO O_(D)SYNC writes we need to defer completions to a workqueue
 	 * so that we can call ->fsync.
 	 */
-	if (dio->is_async && (rw & WRITE) &&
+	if (dio->is_async && iov_iter_rw(iter) == WRITE &&
 	    ((iocb->ki_filp->f_flags & O_DSYNC) ||
 	     IS_SYNC(iocb->ki_filp->f_mapping->host))) {
 		retval = dio_set_defer_completion(dio);
@@ -1275,7 +1272,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 * we can let i_mutex go now that its achieved its purpose
 	 * of protecting us from looking up uninitialized blocks.
 	 */
-	if (rw == READ && (dio->flags & DIO_LOCKING))
+	if (iov_iter_rw(iter) == READ && (dio->flags & DIO_LOCKING))
 		mutex_unlock(&dio->inode->i_mutex);
 
 	/*
@@ -1287,7 +1284,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 */
 	BUG_ON(retval == -EIOCBQUEUED);
 	if (dio->is_async && retval == 0 && dio->result &&
-	    (rw == READ || dio->result == count))
+	    (iov_iter_rw(iter) == READ || dio->result == count))
 		retval = -EIOCBQUEUED;
 	else
 		dio_await_completion(dio);
@@ -1301,11 +1298,11 @@ out:
 	return retval;
 }
 
-ssize_t
-__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
-	get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags)
+ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
+			     struct block_device *bdev, struct iov_iter *iter,
+			     loff_t offset, get_block_t get_block,
+			     dio_iodone_t end_io, dio_submit_t submit_io,
+			     int flags)
 {
 	/*
 	 * The block device state is needed in the end to finally
@@ -1319,8 +1316,8 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	prefetch(bdev->bd_queue);
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
-	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
-				     get_block, end_io, submit_io, flags);
+	return do_blockdev_direct_IO(iocb, inode, bdev, iter, offset, get_block,
+				     end_io, submit_io, flags);
 }
 
 EXPORT_SYMBOL(__blockdev_direct_IO);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 6434bc0..00979a6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -864,7 +864,7 @@ ext2_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 		ret = dax_do_io(rw, iocb, inode, iter, offset, ext2_get_block,
 				NULL, DIO_LOCKING);
 	else
-		ret = blockdev_direct_IO(rw, iocb, inode, iter, offset,
+		ret = blockdev_direct_IO(iocb, inode, iter, offset,
 					 ext2_get_block);
 	if (ret < 0 && (rw & WRITE))
 		ext2_write_failed(mapping, offset + count);
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2c6ccc4..28bba7d 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1856,7 +1856,7 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retry:
-	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, ext3_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, offset, ext3_get_block);
 	/*
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 45fe924..57135a7 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -693,9 +693,10 @@ retry:
 			ret = dax_do_io(rw, iocb, inode, iter, offset,
 					ext4_get_block, NULL, 0);
 		else
-			ret = __blockdev_direct_IO(rw, iocb, inode,
-					inode->i_sb->s_bdev, iter, offset,
-					ext4_get_block, NULL, NULL, 0);
+			ret = __blockdev_direct_IO(iocb, inode,
+						   inode->i_sb->s_bdev, iter,
+						   offset, ext4_get_block, NULL,
+						   NULL, 0);
 		inode_dio_done(inode);
 	} else {
 locked:
@@ -703,8 +704,8 @@ locked:
 			ret = dax_do_io(rw, iocb, inode, iter, offset,
 					ext4_get_block, NULL, DIO_LOCKING);
 		else
-			ret = blockdev_direct_IO(rw, iocb, inode, iter,
-					offset, ext4_get_block);
+			ret = blockdev_direct_IO(iocb, inode, iter, offset,
+						 ext4_get_block);
 
 		if (unlikely((rw & WRITE) && ret < 0)) {
 			loff_t isize = i_size_read(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5cb9a21..81f8f10 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3038,7 +3038,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		ret = dax_do_io(rw, iocb, inode, iter, offset, get_block_func,
 				ext4_end_io_dio, dio_flags);
 	else
-		ret = __blockdev_direct_IO(rw, iocb, inode,
+		ret = __blockdev_direct_IO(iocb, inode,
 					   inode->i_sb->s_bdev, iter, offset,
 					   get_block_func,
 					   ext4_end_io_dio, NULL, dio_flags);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 985ed02..d2addce 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1159,7 +1159,7 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 	if (rw & WRITE)
 		__allocate_data_blocks(inode, offset, count);
 
-	err = blockdev_direct_IO(rw, iocb, inode, iter, offset, get_data_block);
+	err = blockdev_direct_IO(iocb, inode, iter, offset, get_data_block);
 	if (err < 0 && (rw & WRITE))
 		f2fs_write_failed(mapping, offset + count);
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 497c7c5..a969a34 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -275,7 +275,7 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 	 * FAT need to use the DIO_LOCKING for avoiding the race
 	 * condition of fat_get_block() and ->truncate().
 	 */
-	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, fat_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, offset, fat_get_block);
 	if (ret < 0 && (rw & WRITE))
 		fat_write_failed(mapping, offset + count);
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 4ad4f94..fc691f2 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1095,9 +1095,8 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 			truncate_inode_pages_range(mapping, lstart, end);
 	}
 
-	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				  iter, offset,
-				  gfs2_get_block_direct, NULL, NULL, 0);
+	rv = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
+				  offset, gfs2_get_block_direct, NULL, NULL, 0);
 out:
 	gfs2_glock_dq(&gh);
 	gfs2_holder_uninit(&gh);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index d0929bc..d367253 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -133,7 +133,7 @@ static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, hfs_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, offset, hfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 0cf786f..a7ec37d 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -131,8 +131,7 @@ static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, 
-				 hfsplus_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, offset, hfsplus_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index bd3df1c..88271ac 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -339,7 +339,7 @@ static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, jfs_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, offset, jfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 8b59695..76587c3 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -318,8 +318,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	size = blockdev_direct_IO(rw, iocb, inode, iter, offset,
-				  nilfs_get_block);
+	size = blockdev_direct_IO(iocb, inode, iter, offset, nilfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 44db180..162a2a8 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -737,10 +737,9 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 		di_bh = NULL;
 	}
 
-	written = __blockdev_direct_IO(WRITE, iocb, inode, inode->i_sb->s_bdev,
-			iter, offset,
-			ocfs2_direct_IO_get_blocks,
-			ocfs2_dio_end_io, NULL, 0);
+	written = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
+				       offset, ocfs2_direct_IO_get_blocks,
+				       ocfs2_dio_end_io, NULL, 0);
 	if (unlikely(written < 0)) {
 		loff_t i_size = i_size_read(inode);
 
@@ -843,11 +842,10 @@ static ssize_t ocfs2_direct_IO(int rw,
 		return 0;
 
 	if (rw == READ)
-		return __blockdev_direct_IO(rw, iocb, inode,
-				    inode->i_sb->s_bdev,
-				    iter, offset,
-				    ocfs2_direct_IO_get_blocks,
-				    ocfs2_dio_end_io, NULL, 0);
+		return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
+					    iter, offset,
+					    ocfs2_direct_IO_get_blocks,
+					    ocfs2_dio_end_io, NULL, 0);
 	else
 		return ocfs2_direct_IO_write(iocb, iter, offset);
 }
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index e72401e..254e800 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3286,7 +3286,7 @@ static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset,
+	ret = blockdev_direct_IO(iocb, inode, iter, offset,
 				 reiserfs_get_blocks_direct_io);
 
 	/*
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index a445d59..bcb0082 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -225,7 +225,7 @@ static ssize_t udf_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, udf_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, offset, udf_get_block);
 	if (unlikely(ret < 0 && (rw & WRITE)))
 		udf_write_failed(mapping, offset + count);
 	return ret;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3a9b7a1..fdb1353 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1505,14 +1505,13 @@ xfs_vm_direct_IO(
 	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
 
 	if (rw & WRITE) {
-		return __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
-					    offset, xfs_get_blocks_direct,
+		return __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
+					    xfs_get_blocks_direct,
 					    xfs_end_io_direct_write, NULL,
 					    DIO_ASYNC_EXTEND);
 	}
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
-				    offset, xfs_get_blocks_direct,
-				    NULL, NULL, 0);
+	return __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
+				    xfs_get_blocks_direct, NULL, NULL, 0);
 }
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b4d71b5..ba1b580 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2616,16 +2616,18 @@ enum {
 
 void dio_end_io(struct bio *bio, int error);
 
-ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
-	get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags);
-
-static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-		struct inode *inode, struct iov_iter *iter, loff_t offset,
-		get_block_t get_block)
-{
-	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
+ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
+			     struct block_device *bdev, struct iov_iter *iter,
+			     loff_t offset, get_block_t get_block,
+			     dio_iodone_t end_io, dio_submit_t submit_io,
+			     int flags);
+
+static inline ssize_t blockdev_direct_IO(struct kiocb *iocb,
+					 struct inode *inode,
+					 struct iov_iter *iter, loff_t offset,
+					 get_block_t get_block)
+{
+	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
 				    offset, get_block, NULL, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
-- 
2.3.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
