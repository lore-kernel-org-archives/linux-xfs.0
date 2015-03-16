Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5418C7F59
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 06:35:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F38D4AC004
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:17 -0700 (PDT)
Received: from mail-pd0-f170.google.com (mail-pd0-f170.google.com
	[209.85.192.170]) by cuda.sgi.com with ESMTP id
	DxE6a9L9DU1jIFc4 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2015 04:35:16 -0700 (PDT)
Received: by pdbni2 with SMTP id ni2so56103448pdb.1
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:16 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 3/5] Remove rw from dax_{do_,}io()
Date: Mon, 16 Mar 2015 04:33:51 -0700
Message-Id: <e883c902cc6d3861454a5f456788bed214c57bcf.1426502566.git.osandov@osandov.com>
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

And use iov_iter_rw() instead.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/dax.c           | 27 +++++++++++++--------------
 fs/ext2/inode.c    |  4 ++--
 fs/ext4/indirect.c |  4 ++--
 fs/ext4/inode.c    |  2 +-
 include/linux/fs.h |  4 ++--
 5 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ed1619e..a278469 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -98,9 +98,9 @@ static bool buffer_size_valid(struct buffer_head *bh)
 	return bh->b_state != 0;
 }
 
-static ssize_t dax_io(int rw, struct inode *inode, struct iov_iter *iter,
-			loff_t start, loff_t end, get_block_t get_block,
-			struct buffer_head *bh)
+static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
+		      loff_t start, loff_t end, get_block_t get_block,
+		      struct buffer_head *bh)
 {
 	ssize_t retval = 0;
 	loff_t pos = start;
@@ -109,7 +109,7 @@ static ssize_t dax_io(int rw, struct inode *inode, struct iov_iter *iter,
 	void *addr;
 	bool hole = false;
 
-	if (rw != WRITE)
+	if (iov_iter_rw(iter) != WRITE)
 		end = min(end, i_size_read(inode));
 
 	while (pos < end) {
@@ -124,7 +124,7 @@ static ssize_t dax_io(int rw, struct inode *inode, struct iov_iter *iter,
 				bh->b_size = PAGE_ALIGN(end - pos);
 				bh->b_state = 0;
 				retval = get_block(inode, block, bh,
-								rw == WRITE);
+						   iov_iter_rw(iter) == WRITE);
 				if (retval)
 					break;
 				if (!buffer_size_valid(bh))
@@ -137,7 +137,7 @@ static ssize_t dax_io(int rw, struct inode *inode, struct iov_iter *iter,
 				bh->b_size -= done;
 			}
 
-			hole = (rw != WRITE) && !buffer_written(bh);
+			hole = iov_iter_rw(iter) != WRITE && !buffer_written(bh);
 			if (hole) {
 				addr = NULL;
 				size = bh->b_size - first;
@@ -154,7 +154,7 @@ static ssize_t dax_io(int rw, struct inode *inode, struct iov_iter *iter,
 			max = min(pos + size, end);
 		}
 
-		if (rw == WRITE)
+		if (iov_iter_rw(iter) == WRITE)
 			len = copy_from_iter(addr, max - pos, iter);
 		else if (!hole)
 			len = copy_to_iter(addr, max - pos, iter);
@@ -173,7 +173,6 @@ static ssize_t dax_io(int rw, struct inode *inode, struct iov_iter *iter,
 
 /**
  * dax_do_io - Perform I/O to a DAX file
- * @rw: READ to read or WRITE to write
  * @iocb: The control block for this I/O
  * @inode: The file which the I/O is directed at
  * @iter: The addresses to do I/O from or to
@@ -189,9 +188,9 @@ static ssize_t dax_io(int rw, struct inode *inode, struct iov_iter *iter,
  * As with do_blockdev_direct_IO(), we increment i_dio_count while the I/O
  * is in progress.
  */
-ssize_t dax_do_io(int rw, struct kiocb *iocb, struct inode *inode,
-			struct iov_iter *iter, loff_t pos,
-			get_block_t get_block, dio_iodone_t end_io, int flags)
+ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
+		  struct iov_iter *iter, loff_t pos, get_block_t get_block,
+		  dio_iodone_t end_io, int flags)
 {
 	struct buffer_head bh;
 	ssize_t retval = -EINVAL;
@@ -199,7 +198,7 @@ ssize_t dax_do_io(int rw, struct kiocb *iocb, struct inode *inode,
 
 	memset(&bh, 0, sizeof(bh));
 
-	if ((flags & DIO_LOCKING) && (rw == READ)) {
+	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ) {
 		struct address_space *mapping = inode->i_mapping;
 		mutex_lock(&inode->i_mutex);
 		retval = filemap_write_and_wait_range(mapping, pos, end - 1);
@@ -212,9 +211,9 @@ ssize_t dax_do_io(int rw, struct kiocb *iocb, struct inode *inode,
 	/* Protects against truncate */
 	atomic_inc(&inode->i_dio_count);
 
-	retval = dax_io(rw, inode, iter, pos, end, get_block, &bh);
+	retval = dax_io(inode, iter, pos, end, get_block, &bh);
 
-	if ((flags & DIO_LOCKING) && (rw == READ))
+	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
 		mutex_unlock(&inode->i_mutex);
 
 	if ((retval > 0) && end_io)
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 00979a6..cf95bda 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -861,8 +861,8 @@ ext2_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	ssize_t ret;
 
 	if (IS_DAX(inode))
-		ret = dax_do_io(rw, iocb, inode, iter, offset, ext2_get_block,
-				NULL, DIO_LOCKING);
+		ret = dax_do_io(iocb, inode, iter, offset, ext2_get_block, NULL,
+				DIO_LOCKING);
 	else
 		ret = blockdev_direct_IO(iocb, inode, iter, offset,
 					 ext2_get_block);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 57135a7..86e8765 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -690,7 +690,7 @@ retry:
 			goto locked;
 		}
 		if (IS_DAX(inode))
-			ret = dax_do_io(rw, iocb, inode, iter, offset,
+			ret = dax_do_io(iocb, inode, iter, offset,
 					ext4_get_block, NULL, 0);
 		else
 			ret = __blockdev_direct_IO(iocb, inode,
@@ -701,7 +701,7 @@ retry:
 	} else {
 locked:
 		if (IS_DAX(inode))
-			ret = dax_do_io(rw, iocb, inode, iter, offset,
+			ret = dax_do_io(iocb, inode, iter, offset,
 					ext4_get_block, NULL, DIO_LOCKING);
 		else
 			ret = blockdev_direct_IO(iocb, inode, iter, offset,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 81f8f10..094cc4a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3035,7 +3035,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		dio_flags = DIO_LOCKING;
 	}
 	if (IS_DAX(inode))
-		ret = dax_do_io(rw, iocb, inode, iter, offset, get_block_func,
+		ret = dax_do_io(iocb, inode, iter, offset, get_block_func,
 				ext4_end_io_dio, dio_flags);
 	else
 		ret = __blockdev_direct_IO(iocb, inode,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ba1b580..8fcda74 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2591,8 +2591,8 @@ extern loff_t fixed_size_llseek(struct file *file, loff_t offset,
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
-ssize_t dax_do_io(int rw, struct kiocb *, struct inode *, struct iov_iter *,
-		loff_t, get_block_t, dio_iodone_t, int flags);
+ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
+		  get_block_t, dio_iodone_t, int flags);
 int dax_clear_blocks(struct inode *, sector_t block, long size);
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
-- 
2.3.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
