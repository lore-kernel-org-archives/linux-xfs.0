Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 98DE67F5A
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 06:35:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8773F8F8035
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:21 -0700 (PDT)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
	[209.85.220.47]) by cuda.sgi.com with ESMTP id YkA7sDd6KjapPTRq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:18 -0700 (PDT)
Received: by pabyw6 with SMTP id yw6so62599362pab.2
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:18 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 4/5] direct_IO: use iov_iter_rw() instead of rw everywhere
Date: Mon, 16 Mar 2015 04:33:52 -0700
Message-Id: <16b2a270e560277f4a43c4eaf04bbc2bc825c28d.1426502566.git.osandov@osandov.com>
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

The rw parameter to direct_IO is redundant with iov_iter->type, and
treated slightly differently just about everywhere it's used: some users
do rw & WRITE, and others do rw == WRITE where they should be doing a
bitwise check. Simplify this with the new iov_iter_rw() helper, which
always returns either READ or WRITE.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 drivers/staging/lustre/lustre/llite/rw26.c | 18 +++++++++---------
 fs/affs/file.c                             |  4 ++--
 fs/btrfs/inode.c                           | 12 ++++++------
 fs/ext2/inode.c                            |  2 +-
 fs/ext3/inode.c                            |  8 ++++----
 fs/ext4/ext4.h                             |  4 ++--
 fs/ext4/indirect.c                         | 10 +++++-----
 fs/ext4/inode.c                            | 20 ++++++++++----------
 fs/f2fs/data.c                             | 16 ++++++++--------
 fs/fat/inode.c                             |  4 ++--
 fs/fuse/file.c                             | 13 +++++++------
 fs/gfs2/aops.c                             |  7 +++----
 fs/hfs/inode.c                             |  2 +-
 fs/hfsplus/inode.c                         |  2 +-
 fs/jfs/inode.c                             |  2 +-
 fs/nfs/direct.c                            |  2 +-
 fs/nilfs2/inode.c                          |  4 ++--
 fs/ocfs2/aops.c                            |  2 +-
 fs/reiserfs/inode.c                        |  2 +-
 fs/udf/inode.c                             |  2 +-
 fs/xfs/xfs_aops.c                          |  2 +-
 21 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
index 2f21304..3aa9de6 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -399,7 +399,7 @@ static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
 	 *    size changing by concurrent truncates and writes.
 	 * 1. Need inode mutex to operate transient pages.
 	 */
-	if (rw == READ)
+	if (iov_iter_rw(iter) == READ)
 		mutex_lock(&inode->i_mutex);
 
 	LASSERT(obj->cob_transient_pages == 0);
@@ -408,7 +408,7 @@ static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
 		size_t offs;
 
 		count = min_t(size_t, iov_iter_count(iter), size);
-		if (rw == READ) {
+		if (iov_iter_rw(iter) == READ) {
 			if (file_offset >= i_size_read(inode))
 				break;
 			if (file_offset + count > i_size_read(inode))
@@ -418,11 +418,11 @@ static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
 		result = iov_iter_get_pages_alloc(iter, &pages, count, &offs);
 		if (likely(result > 0)) {
 			int n = DIV_ROUND_UP(result + offs, PAGE_SIZE);
-			result = ll_direct_IO_26_seg(env, io, rw, inode,
-						     file->f_mapping,
-						     result, file_offset,
-						     pages, n);
-			ll_free_user_pages(pages, n, rw==READ);
+			result = ll_direct_IO_26_seg(env, io, iov_iter_rw(iter),
+						     inode, file->f_mapping,
+						     result, file_offset, pages,
+						     n);
+			ll_free_user_pages(pages, n, iov_iter_rw(iter) == READ);
 		}
 		if (unlikely(result <= 0)) {
 			/* If we can't allocate a large enough buffer
@@ -449,11 +449,11 @@ static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
 	}
 out:
 	LASSERT(obj->cob_transient_pages == 0);
-	if (rw == READ)
+	if (iov_iter_rw(iter) == READ)
 		mutex_unlock(&inode->i_mutex);
 
 	if (tot_bytes > 0) {
-		if (rw == WRITE) {
+		if (iov_iter_rw(iter) == WRITE) {
 			struct lov_stripe_md *lsm;
 
 			lsm = ccc_inode_lsm_get(inode);
diff --git a/fs/affs/file.c b/fs/affs/file.c
index f3028aa..0314acd 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -398,7 +398,7 @@ affs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	if (rw == WRITE) {
+	if (iov_iter_rw(iter) == WRITE) {
 		loff_t size = offset + count;
 
 		if (AFFS_I(inode)->mmu_private < size)
@@ -406,7 +406,7 @@ affs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	}
 
 	ret = blockdev_direct_IO(iocb, inode, iter, offset, affs_get_block);
-	if (ret < 0 && (rw & WRITE))
+	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		affs_write_failed(mapping, offset + count);
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d6413f4..5c17f61 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8037,8 +8037,8 @@ free_ordered:
 	bio_endio(dio_bio, ret);
 }
 
-static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *iocb,
-			const struct iov_iter *iter, loff_t offset)
+static ssize_t check_direct_IO(struct btrfs_root *root, struct kiocb *iocb,
+			       const struct iov_iter *iter, loff_t offset)
 {
 	int seg;
 	int i;
@@ -8052,7 +8052,7 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 		goto out;
 
 	/* If this is a write we don't need to check anymore */
-	if (rw & WRITE)
+	if (iov_iter_rw(iter) == WRITE)
 		return 0;
 	/*
 	 * Check to make sure we don't have duplicate iov_base's in this
@@ -8081,7 +8081,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	bool relock = false;
 	ssize_t ret;
 
-	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iter, offset))
+	if (check_direct_IO(BTRFS_I(inode)->root, iocb, iter, offset))
 		return 0;
 
 	atomic_inc(&inode->i_dio_count);
@@ -8099,7 +8099,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		filemap_fdatawrite_range(inode->i_mapping, offset,
 					 offset + count - 1);
 
-	if (rw & WRITE) {
+	if (iov_iter_rw(iter) == WRITE) {
 		/*
 		 * If the write DIO is beyond the EOF, we need update
 		 * the isize, but it is protected by i_mutex. So we can
@@ -8123,7 +8123,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 				   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 				   iter, offset, btrfs_get_blocks_direct, NULL,
 				   btrfs_submit_direct, flags);
-	if (rw & WRITE) {
+	if (iov_iter_rw(iter) == WRITE) {
 		if (ret < 0 && ret != -EIOCBQUEUED)
 			btrfs_delalloc_release_space(inode, count);
 		else if (ret >= 0 && (size_t)ret < count)
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index cf95bda..d59d21f 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -866,7 +866,7 @@ ext2_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	else
 		ret = blockdev_direct_IO(iocb, inode, iter, offset,
 					 ext2_get_block);
-	if (ret < 0 && (rw & WRITE))
+	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		ext2_write_failed(mapping, offset + count);
 	return ret;
 }
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 28bba7d..8832f2d 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1832,9 +1832,9 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	int retries = 0;
 
-	trace_ext3_direct_IO_enter(inode, offset, count, rw);
+	trace_ext3_direct_IO_enter(inode, offset, count, iov_iter_rw(iter));
 
-	if (rw == WRITE) {
+	if (iov_iter_rw(iter) == WRITE) {
 		loff_t final_size = offset + count;
 
 		if (final_size > inode->i_size) {
@@ -1861,7 +1861,7 @@ retry:
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
 	 */
-	if (unlikely((rw & WRITE) && ret < 0)) {
+	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + count;
 
@@ -1908,7 +1908,7 @@ retry:
 			ret = err;
 	}
 out:
-	trace_ext3_direct_IO_exit(inode, offset, count, rw, ret);
+	trace_ext3_direct_IO_exit(inode, offset, count, iov_iter_rw(iter), ret);
 	return ret;
 }
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f63c3d5..2031c99 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2152,8 +2152,8 @@ extern void ext4_da_update_reserve_space(struct inode *inode,
 /* indirect.c */
 extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 				struct ext4_map_blocks *map, int flags);
-extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
-				struct iov_iter *iter, loff_t offset);
+extern ssize_t ext4_ind_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+				  loff_t offset);
 extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
 extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks);
 extern void ext4_ind_truncate(handle_t *, struct inode *inode);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 86e8765..e249aee 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -642,8 +642,8 @@ out:
  * crashes then stale disk data _may_ be exposed inside the file. But current
  * VFS code falls back into buffered path in that case so we are safe.
  */
-ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
-			   struct iov_iter *iter, loff_t offset)
+ssize_t ext4_ind_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			   loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -654,7 +654,7 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	int retries = 0;
 
-	if (rw == WRITE) {
+	if (iov_iter_rw(iter) == WRITE) {
 		loff_t final_size = offset + count;
 
 		if (final_size > inode->i_size) {
@@ -676,7 +676,7 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retry:
-	if (rw == READ && ext4_should_dioread_nolock(inode)) {
+	if (iov_iter_rw(iter) == READ && ext4_should_dioread_nolock(inode)) {
 		/*
 		 * Nolock dioread optimization may be dynamically disabled
 		 * via ext4_inode_block_unlocked_dio(). Check inode's state
@@ -707,7 +707,7 @@ locked:
 			ret = blockdev_direct_IO(iocb, inode, iter, offset,
 						 ext4_get_block);
 
-		if (unlikely((rw & WRITE) && ret < 0)) {
+		if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 			loff_t isize = i_size_read(inode);
 			loff_t end = offset + count;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 094cc4a..1e63c19 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2953,8 +2953,8 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
  * if the machine crashes during the write.
  *
  */
-static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
-			      struct iov_iter *iter, loff_t offset)
+static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+				  loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -2967,8 +2967,8 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	ext4_io_end_t *io_end = NULL;
 
 	/* Use the old path for reads and writes beyond i_size. */
-	if (rw != WRITE || final_size > inode->i_size)
-		return ext4_ind_direct_IO(rw, iocb, iter, offset);
+	if (iov_iter_rw(iter) != WRITE || final_size > inode->i_size)
+		return ext4_ind_direct_IO(iocb, iter, offset);
 
 	BUG_ON(iocb->private == NULL);
 
@@ -2977,7 +2977,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	 * conversion. This also disallows race between truncate() and
 	 * overwrite DIO as i_dio_count needs to be incremented under i_mutex.
 	 */
-	if (rw == WRITE)
+	if (iov_iter_rw(iter) == WRITE)
 		atomic_inc(&inode->i_dio_count);
 
 	/* If we do a overwrite dio, i_mutex locking can be released */
@@ -3079,7 +3079,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retake_lock:
-	if (rw == WRITE)
+	if (iov_iter_rw(iter) == WRITE)
 		inode_dio_done(inode);
 	/* take i_mutex locking again if we do a ovewrite dio */
 	if (overwrite) {
@@ -3108,12 +3108,12 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	if (ext4_has_inline_data(inode))
 		return 0;
 
-	trace_ext4_direct_IO_enter(inode, offset, count, rw);
+	trace_ext4_direct_IO_enter(inode, offset, count, iov_iter_rw(iter));
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		ret = ext4_ext_direct_IO(rw, iocb, iter, offset);
+		ret = ext4_ext_direct_IO(iocb, iter, offset);
 	else
-		ret = ext4_ind_direct_IO(rw, iocb, iter, offset);
-	trace_ext4_direct_IO_exit(inode, offset, count, rw, ret);
+		ret = ext4_ind_direct_IO(iocb, iter, offset);
+	trace_ext4_direct_IO_exit(inode, offset, count, iov_iter_rw(iter), ret);
 	return ret;
 }
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d2addce..9c8f0c0 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1118,12 +1118,12 @@ static int f2fs_write_end(struct file *file,
 	return copied;
 }
 
-static int check_direct_IO(struct inode *inode, int rw,
-		struct iov_iter *iter, loff_t offset)
+static int check_direct_IO(struct inode *inode, struct iov_iter *iter,
+			   loff_t offset)
 {
 	unsigned blocksize_mask = inode->i_sb->s_blocksize - 1;
 
-	if (rw == READ)
+	if (iov_iter_rw(iter) == READ)
 		return 0;
 
 	if (offset & blocksize_mask)
@@ -1151,19 +1151,19 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 			return err;
 	}
 
-	if (check_direct_IO(inode, rw, iter, offset))
+	if (check_direct_IO(inode, iter, offset))
 		return 0;
 
-	trace_f2fs_direct_IO_enter(inode, offset, count, rw);
+	trace_f2fs_direct_IO_enter(inode, offset, count, iov_iter_rw(iter));
 
-	if (rw & WRITE)
+	if (iov_iter_rw(iter) == WRITE)
 		__allocate_data_blocks(inode, offset, count);
 
 	err = blockdev_direct_IO(iocb, inode, iter, offset, get_data_block);
-	if (err < 0 && (rw & WRITE))
+	if (err < 0 && iov_iter_rw(iter) == WRITE)
 		f2fs_write_failed(mapping, offset + count);
 
-	trace_f2fs_direct_IO_exit(inode, offset, count, rw, err);
+	trace_f2fs_direct_IO_exit(inode, offset, count, iov_iter_rw(iter), err);
 
 	return err;
 }
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index a969a34..cfc3461 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -256,7 +256,7 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	if (rw == WRITE) {
+	if (iov_iter_rw(iter) == WRITE) {
 		/*
 		 * FIXME: blockdev_direct_IO() doesn't use ->write_begin(),
 		 * so we need to update the ->mmu_private to block boundary.
@@ -276,7 +276,7 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 	 * condition of fat_get_block() and ->truncate().
 	 */
 	ret = blockdev_direct_IO(iocb, inode, iter, offset, fat_get_block);
-	if (ret < 0 && (rw & WRITE))
+	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		fat_write_failed(mapping, offset + count);
 
 	return ret;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c01ec3b..d9679d4 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2815,11 +2815,11 @@ fuse_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	inode = file->f_mapping->host;
 	i_size = i_size_read(inode);
 
-	if ((rw == READ) && (offset > i_size))
+	if ((iov_iter_rw(iter) == READ) && (offset > i_size))
 		return 0;
 
 	/* optimization for short read */
-	if (async_dio && rw != WRITE && offset + count > i_size) {
+	if (async_dio && iov_iter_rw(iter) != WRITE && offset + count > i_size) {
 		if (offset >= i_size)
 			return 0;
 		count = min_t(loff_t, count, fuse_round_up(i_size - offset));
@@ -2834,7 +2834,7 @@ fuse_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	io->bytes = -1;
 	io->size = 0;
 	io->offset = offset;
-	io->write = (rw == WRITE);
+	io->write = (iov_iter_rw(iter) == WRITE);
 	io->err = 0;
 	io->file = file;
 	/*
@@ -2849,10 +2849,11 @@ fuse_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	 * to wait on real async I/O requests, so we must submit this request
 	 * synchronously.
 	 */
-	if (!is_sync_kiocb(iocb) && (offset + count > i_size) && rw == WRITE)
+	if (!is_sync_kiocb(iocb) && (offset + count > i_size) &&
+	    iov_iter_rw(iter) == WRITE)
 		io->async = false;
 
-	if (rw == WRITE)
+	if (iov_iter_rw(iter) == WRITE)
 		ret = __fuse_direct_write(io, iter, &pos);
 	else
 		ret = __fuse_direct_read(io, iter, &pos);
@@ -2869,7 +2870,7 @@ fuse_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 		kfree(io);
 	}
 
-	if (rw == WRITE) {
+	if (iov_iter_rw(iter) == WRITE) {
 		if (ret > 0)
 			fuse_write_update_size(inode, pos);
 		else if (ret < 0 && offset + count > i_size)
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index fc691f2..4544200 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1016,13 +1016,12 @@ out:
 /**
  * gfs2_ok_for_dio - check that dio is valid on this file
  * @ip: The inode
- * @rw: READ or WRITE
  * @offset: The offset at which we are reading or writing
  *
  * Returns: 0 (to ignore the i/o request and thus fall back to buffered i/o)
  *          1 (to accept the i/o request)
  */
-static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
+static int gfs2_ok_for_dio(struct gfs2_inode *ip, loff_t offset)
 {
 	/*
 	 * Should we return an error here? I can't see that O_DIRECT for
@@ -1061,7 +1060,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	rv = gfs2_glock_nq(&gh);
 	if (rv)
 		return rv;
-	rv = gfs2_ok_for_dio(ip, rw, offset);
+	rv = gfs2_ok_for_dio(ip, offset);
 	if (rv != 1)
 		goto out; /* dio not valid, fall back to buffered i/o */
 
@@ -1091,7 +1090,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 		rv = filemap_write_and_wait_range(mapping, lstart, end);
 		if (rv)
 			goto out;
-		if (rw == WRITE)
+		if (iov_iter_rw(iter) == WRITE)
 			truncate_inode_pages_range(mapping, lstart, end);
 	}
 
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index d367253..754d31f 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -139,7 +139,7 @@ static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
 	 */
-	if (unlikely((rw & WRITE) && ret < 0)) {
+	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + count;
 
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index a7ec37d..fb0e914 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -137,7 +137,7 @@ static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
 	 */
-	if (unlikely((rw & WRITE) && ret < 0)) {
+	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + count;
 
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 88271ac..62a2e39 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -345,7 +345,7 @@ static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
 	 */
-	if (unlikely((rw & WRITE) && ret < 0)) {
+	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + count;
 
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index e907c8c..541dcc0 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -267,7 +267,7 @@ ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t
 #else
 	VM_BUG_ON(iocb->ki_nbytes != PAGE_SIZE);
 
-	if (rw == READ)
+	if (iov_iter_rw(iter) == READ)
 		return nfs_file_direct_read(iocb, iter, pos);
 	return nfs_file_direct_write(iocb, iter, pos);
 #endif /* CONFIG_NFS_SWAP */
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 76587c3..10c2e39 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -314,7 +314,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t size;
 
-	if (rw == WRITE)
+	if (iov_iter_rw(iter) == WRITE)
 		return 0;
 
 	/* Needs synchronization with the cleaner */
@@ -324,7 +324,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
 	 */
-	if (unlikely((rw & WRITE) && size < 0)) {
+	if (unlikely(iov_iter_rw(iter) == WRITE && size < 0)) {
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + count;
 
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 162a2a8..a4a1b9a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -841,7 +841,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (i_size_read(inode) <= offset && !full_coherency)
 		return 0;
 
-	if (rw == READ)
+	if (iov_iter_rw(iter) == READ)
 		return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
 					    iter, offset,
 					    ocfs2_direct_IO_get_blocks,
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 254e800..6d253da 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3293,7 +3293,7 @@ static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
 	 */
-	if (unlikely((rw & WRITE) && ret < 0)) {
+	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + count;
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index bcb0082..91e7e1c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -226,7 +226,7 @@ static ssize_t udf_direct_IO(int rw, struct kiocb *iocb,
 	ssize_t ret;
 
 	ret = blockdev_direct_IO(iocb, inode, iter, offset, udf_get_block);
-	if (unlikely(ret < 0 && (rw & WRITE)))
+	if (unlikely(ret < 0 && iov_iter_rw(iter) == WRITE))
 		udf_write_failed(mapping, offset + count);
 	return ret;
 }
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index fdb1353..fd6e6f5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1504,7 +1504,7 @@ xfs_vm_direct_IO(
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
 
-	if (rw & WRITE) {
+	if (iov_iter_rw(iter) == WRITE) {
 		return __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
 					    xfs_get_blocks_direct,
 					    xfs_end_io_direct_write, NULL,
-- 
2.3.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
