Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3BCDA7F56
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 06:35:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B32F8F8050
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:23 -0700 (PDT)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
	[209.85.220.46]) by cuda.sgi.com with ESMTP id Ne5KScK45neN11pa
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:20 -0700 (PDT)
Received: by pabyw6 with SMTP id yw6so62600135pab.2
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:20 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 5/5] direct_IO: remove rw from a_ops->direct_IO()
Date: Mon, 16 Mar 2015 04:33:53 -0700
Message-Id: <49efea30d5bc5ce744171c832523717b5d642864.1426502566.git.osandov@osandov.com>
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

Now that no one is using rw, remove it completely.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 Documentation/filesystems/Locking          | 2 +-
 Documentation/filesystems/vfs.txt          | 2 +-
 drivers/staging/lustre/lustre/llite/rw26.c | 4 ++--
 fs/9p/vfs_addr.c                           | 2 +-
 fs/affs/file.c                             | 3 +--
 fs/block_dev.c                             | 3 +--
 fs/btrfs/inode.c                           | 4 ++--
 fs/ceph/addr.c                             | 3 +--
 fs/cifs/file.c                             | 3 +--
 fs/exofs/inode.c                           | 4 ++--
 fs/ext2/inode.c                            | 3 +--
 fs/ext3/inode.c                            | 4 ++--
 fs/ext4/inode.c                            | 4 ++--
 fs/f2fs/data.c                             | 4 ++--
 fs/fat/inode.c                             | 3 +--
 fs/fuse/file.c                             | 3 +--
 fs/gfs2/aops.c                             | 4 ++--
 fs/hfs/inode.c                             | 4 ++--
 fs/hfsplus/inode.c                         | 4 ++--
 fs/jfs/inode.c                             | 4 ++--
 fs/nfs/direct.c                            | 2 +-
 fs/nilfs2/inode.c                          | 3 +--
 fs/ocfs2/aops.c                            | 4 +---
 fs/reiserfs/inode.c                        | 4 ++--
 fs/udf/file.c                              | 3 +--
 fs/udf/inode.c                             | 3 +--
 fs/xfs/xfs_aops.c                          | 1 -
 include/linux/fs.h                         | 2 +-
 include/linux/nfs_fs.h                     | 2 +-
 mm/filemap.c                               | 4 ++--
 mm/page_io.c                               | 4 +---
 31 files changed, 42 insertions(+), 57 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index f91926f..b38abaf 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -196,7 +196,7 @@ prototypes:
 	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	int (*direct_IO)(int, struct kiocb *, struct iov_iter *iter, loff_t offset);
+	int (*direct_IO)(struct kiocb *, struct iov_iter *iter, loff_t offset);
 	int (*migratepage)(struct address_space *, struct page *, struct page *);
 	int (*launder_page)(struct page *);
 	int (*is_partially_uptodate)(struct page *, unsigned long, unsigned long);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 966b228..d8ebc3c 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -590,7 +590,7 @@ struct address_space_operations {
 	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter, loff_t offset);
+	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter, loff_t offset);
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct page *, struct page *);
 	int (*launder_page) (struct page *);
diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
index 3aa9de6..0d7ce6b 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -359,8 +359,8 @@ static ssize_t ll_direct_IO_26_seg(const struct lu_env *env, struct cl_io *io,
  * up to 22MB for 128kB kmalloc and up to 682MB for 4MB kmalloc. */
 #define MAX_DIO_SIZE ((MAX_MALLOC / sizeof(struct brw_page) * PAGE_CACHE_SIZE) & \
 		      ~(DT_MAX_BRW_SIZE - 1))
-static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
-			       struct iov_iter *iter, loff_t file_offset)
+static ssize_t ll_direct_IO_26(struct kiocb *iocb, struct iov_iter *iter,
+			       loff_t file_offset)
 {
 	struct lu_env *env;
 	struct cl_io *io;
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index eb14e05..b298a90 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -259,7 +259,7 @@ static int v9fs_launder_page(struct page *page)
  *
  */
 static ssize_t
-v9fs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
+v9fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	/*
 	 * FIXME
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 0314acd..ef5dcb4 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -389,8 +389,7 @@ static void affs_write_failed(struct address_space *mapping, loff_t to)
 }
 
 static ssize_t
-affs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
-	       loff_t offset)
+affs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index e3a3125..02ba7b0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -147,8 +147,7 @@ blkdev_get_block(struct inode *inode, sector_t iblock,
 }
 
 static ssize_t
-blkdev_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
-			loff_t offset)
+blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5c17f61..ffad756 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8070,8 +8070,8 @@ out:
 	return retval;
 }
 
-static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
-			struct iov_iter *iter, loff_t offset)
+static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			       loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index fd5599d..155ab9c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1198,8 +1198,7 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
  * intercept O_DIRECT reads and writes early, this function should
  * never get called.
  */
-static ssize_t ceph_direct_io(int rw, struct kiocb *iocb,
-			      struct iov_iter *iter,
+static ssize_t ceph_direct_io(struct kiocb *iocb, struct iov_iter *iter,
 			      loff_t pos)
 {
 	WARN_ON(1);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a94b3e6..83ae6cc 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3876,8 +3876,7 @@ void cifs_oplock_break(struct work_struct *work)
  * Direct IO is not yet supported in the cached mode. 
  */
 static ssize_t
-cifs_direct_io(int rw, struct kiocb *iocb, struct iov_iter *iter,
-               loff_t pos)
+cifs_direct_io(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
         /*
          * FIXME
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index a198e94..35073aa 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -963,8 +963,8 @@ static void exofs_invalidatepage(struct page *page, unsigned int offset,
 
 
  /* TODO: Should be easy enough to do proprly */
-static ssize_t exofs_direct_IO(int rw, struct kiocb *iocb,
-		struct iov_iter *iter, loff_t offset)
+static ssize_t exofs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			       loff_t offset)
 {
 	return 0;
 }
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index d59d21f..ac2a281 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -851,8 +851,7 @@ static sector_t ext2_bmap(struct address_space *mapping, sector_t block)
 }
 
 static ssize_t
-ext2_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
-			loff_t offset)
+ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 8832f2d..91ac933 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1820,8 +1820,8 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
  * crashes then stale disk data _may_ be exposed inside the file. But current
  * VFS code falls back into buffered path in that case so we are safe.
  */
-static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
-			struct iov_iter *iter, loff_t offset)
+static ssize_t ext3_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			      loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1e63c19..8a5d3a1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3090,8 +3090,8 @@ retake_lock:
 	return ret;
 }
 
-static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
-			      struct iov_iter *iter, loff_t offset)
+static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			      loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9c8f0c0..8e58b43 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1135,8 +1135,8 @@ static int check_direct_IO(struct inode *inode, struct iov_iter *iter,
 	return 0;
 }
 
-static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
-		struct iov_iter *iter, loff_t offset)
+static ssize_t f2fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			      loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index cfc3461..eeea430 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -246,8 +246,7 @@ static int fat_write_end(struct file *file, struct address_space *mapping,
 	return err;
 }
 
-static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
-			     struct iov_iter *iter,
+static ssize_t fat_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			     loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d9679d4..1d11ce2 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2798,8 +2798,7 @@ static inline loff_t fuse_round_up(loff_t off)
 }
 
 static ssize_t
-fuse_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
-			loff_t offset)
+fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	ssize_t ret = 0;
 	struct file *file = iocb->ki_filp;
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 4544200..5cee2ab 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1038,8 +1038,8 @@ static int gfs2_ok_for_dio(struct gfs2_inode *ip, loff_t offset)
 
 
 
-static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
-			      struct iov_iter *iter, loff_t offset)
+static ssize_t gfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			      loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 754d31f..1f2e376 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -124,8 +124,8 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 	return res ? try_to_free_buffers(page) : 0;
 }
 
-static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
-		struct iov_iter *iter, loff_t offset)
+static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			     loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index fb0e914..ee9fb03 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -122,8 +122,8 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 	return res ? try_to_free_buffers(page) : 0;
 }
 
-static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
-		struct iov_iter *iter, loff_t offset)
+static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+				 loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 62a2e39..33b10c5 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -330,8 +330,8 @@ static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, jfs_get_block);
 }
 
-static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
-	struct iov_iter *iter, loff_t offset)
+static ssize_t jfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+			     loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 541dcc0..6db73a0 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -251,7 +251,7 @@ static int nfs_direct_cmp_commit_data_verf(struct nfs_direct_req *dreq,
  * shunt off direct read and write requests before the VFS gets them,
  * so this method is only ever called for swap.
  */
-ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
+ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 10c2e39..946de2f 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -305,8 +305,7 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t
-nilfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
-		loff_t offset)
+nilfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index a4a1b9a..a804143 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -817,9 +817,7 @@ out:
 	return ret;
 }
 
-static ssize_t ocfs2_direct_IO(int rw,
-			       struct kiocb *iocb,
-			       struct iov_iter *iter,
+static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			       loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 6d253da..4f1a8f3 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3278,8 +3278,8 @@ static int reiserfs_releasepage(struct page *page, gfp_t unused_gfp_flags)
  * We thank Mingming Cao for helping us understand in great detail what
  * to do in this section of the code.
  */
-static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
-				  struct iov_iter *iter, loff_t offset)
+static ssize_t reiserfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+				  loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 08f3555..d7ad099 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -100,8 +100,7 @@ static int udf_adinicb_write_begin(struct file *file,
 	return 0;
 }
 
-static ssize_t udf_adinicb_direct_IO(int rw, struct kiocb *iocb,
-				     struct iov_iter *iter,
+static ssize_t udf_adinicb_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 				     loff_t offset)
 {
 	/* Fallback to buffered I/O. */
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 91e7e1c..20d7bc9 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -215,8 +215,7 @@ static int udf_write_begin(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
-static ssize_t udf_direct_IO(int rw, struct kiocb *iocb,
-			     struct iov_iter *iter,
+static ssize_t udf_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			     loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index fd6e6f5..e362299 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1496,7 +1496,6 @@ xfs_end_io_direct_write(
 
 STATIC ssize_t
 xfs_vm_direct_IO(
-	int			rw,
 	struct kiocb		*iocb,
 	struct iov_iter		*iter,
 	loff_t			offset)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8fcda74..19b8adf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -361,7 +361,7 @@ struct address_space_operations {
 	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
 	int (*releasepage) (struct page *, gfp_t);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter, loff_t offset);
+	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter, loff_t offset);
 	/*
 	 * migrate the contents of a page to the specified target. If
 	 * migrate_mode is MIGRATE_ASYNC, it must not block.
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index b01ccf3..3d1b0d2 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -447,7 +447,7 @@ static inline struct rpc_cred *nfs_file_cred(struct file *file)
 /*
  * linux/fs/nfs/direct.c
  */
-extern ssize_t nfs_direct_IO(int, struct kiocb *, struct iov_iter *, loff_t);
+extern ssize_t nfs_direct_IO(struct kiocb *, struct iov_iter *, loff_t);
 extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
 			struct iov_iter *iter,
 			loff_t pos);
diff --git a/mm/filemap.c b/mm/filemap.c
index ad72420..cb63a50 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1708,7 +1708,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 					pos + count - 1);
 		if (!retval) {
 			struct iov_iter data = *iter;
-			retval = mapping->a_ops->direct_IO(READ, iocb, &data, pos);
+			retval = mapping->a_ops->direct_IO(iocb, &data, pos);
 		}
 
 		if (retval > 0) {
@@ -2396,7 +2396,7 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos)
 	}
 
 	data = *from;
-	written = mapping->a_ops->direct_IO(WRITE, iocb, &data, pos);
+	written = mapping->a_ops->direct_IO(iocb, &data, pos);
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
diff --git a/mm/page_io.c b/mm/page_io.c
index e604580..14ca9d3 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -278,9 +278,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 
 		set_page_writeback(page);
 		unlock_page(page);
-		ret = mapping->a_ops->direct_IO(ITER_BVEC | WRITE,
-						&kiocb, &from,
-						kiocb.ki_pos);
+		ret = mapping->a_ops->direct_IO(&kiocb, &from, kiocb.ki_pos);
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
 			ret = 0;
-- 
2.3.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
