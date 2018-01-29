Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751919AbeA2O5v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Jan 2018 09:57:51 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v6 1/2] Return bytes transferred for partial direct I/O
Date: Mon, 29 Jan 2018 08:57:40 -0600
Message-Id: <20180129145741.29486-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, ak@linux.intel.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

In case direct I/O encounters an error midway, it returns the error.
Instead it should be returning the number of bytes transferred so far.

Test case for filesystems (with ENOSPC):
1. Create an almost full filesystem
2. Create a file, say /mnt/lastfile, until the filesystem is full.
3. Direct write() with count > sizeof /mnt/lastfile.

Result: write() returns -ENOSPC. However, file content has data written
in step 3.

Added a sysctl entry: dio_short_writes which is on by default. This is
to support applications which expect either and error or the bytes submitted
as a return value for the write calls.

This fixes fstest generic/472.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---

Changes since v1:
 - incorporated iomap and block devices

Changes since v2:
 - realized that file size was not increasing when performing a (partial)
   direct I/O because end_io function was receiving the error instead of
   size. Fixed.

Changes since v3:
 - [hch] initialize transferred with dio->size and use transferred instead
   of dio->size.

Changes since v4:
 - Refreshed to v4.14

Changes since v5:
 - Added /proc/sys/fs/dio_short_writes (default 1) to guard older applications
   which expect write(fd, buf, count) returns either count or error.


 Documentation/sysctl/fs.txt | 14 ++++++++++++++
 fs/block_dev.c              |  2 +-
 fs/direct-io.c              |  7 +++++--
 fs/iomap.c                  | 23 ++++++++++++-----------
 include/linux/fs.h          |  1 +
 kernel/sysctl.c             |  9 +++++++++
 6 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 6c00c1e2743f..72e213d62511 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -22,6 +22,7 @@ Currently, these files are in /proc/sys/fs:
 - aio-max-nr
 - aio-nr
 - dentry-state
+- dio_short_writes
 - dquot-max
 - dquot-nr
 - file-max
@@ -76,6 +77,19 @@ dcache isn't pruned yet.
 
 ==============================================================
 
+dio_short_writes:
+
+In case Direct I/O encounters an transient error, it returns
+the errorcode, even if it has performed part of the write.
+This flag, if on (default), will return the number of bytes written
+so far, as the write(2) symantics are. However, some older applications
+still consider a direct write as an error if all of the I/O
+submitted is not complete. ie write(file, count, buf) != count.
+This option can be disabled on systems in order to support
+existing applications which do not expect short writes.
+
+==============================================================
+
 dquot-max & dquot-nr:
 
 The file dquot-max shows the maximum number of cached disk
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4a181fcb5175..49d94360bb51 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -409,7 +409,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 
 	if (!ret)
 		ret = blk_status_to_errno(dio->bio.bi_status);
-	if (likely(!ret))
+	if (likely(dio->size))
 		ret = dio->size;
 
 	bio_put(&dio->bio);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 3aafb3343a65..9bd15be64c25 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -151,6 +151,7 @@ struct dio {
 } ____cacheline_aligned_in_smp;
 
 static struct kmem_cache *dio_cache __read_mostly;
+unsigned int sysctl_dio_short_writes = 1;
 
 /*
  * How many pages are in the queue?
@@ -262,7 +263,7 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, unsigned int flags)
 		ret = dio->page_errors;
 	if (ret == 0)
 		ret = dio->io_error;
-	if (ret == 0)
+	if (!sysctl_dio_short_writes && (ret == 0))
 		ret = transferred;
 
 	if (dio->end_io) {
@@ -310,7 +311,9 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, unsigned int flags)
 	}
 
 	kmem_cache_free(dio_cache, dio);
-	return ret;
+	if (!sysctl_dio_short_writes)
+		return ret;
+	return transferred ? transferred : ret;
 }
 
 static void dio_aio_complete_work(struct work_struct *work)
diff --git a/fs/iomap.c b/fs/iomap.c
index 47d29ccffaef..a8d6908dc0de 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -716,23 +716,24 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
 	struct kiocb *iocb = dio->iocb;
 	struct inode *inode = file_inode(iocb->ki_filp);
 	loff_t offset = iocb->ki_pos;
-	ssize_t ret;
+	ssize_t err;
+	ssize_t transferred = dio->size;
 
 	if (dio->end_io) {
-		ret = dio->end_io(iocb,
-				dio->error ? dio->error : dio->size,
-				dio->flags);
+		err = dio->end_io(iocb,
+				  (transferred && sysctl_dio_short_writes) ?
+						transferred : dio->error,
+				  dio->flags);
 	} else {
-		ret = dio->error;
+		err = dio->error;
 	}
 
-	if (likely(!ret)) {
-		ret = dio->size;
+	if (likely(transferred)) {
 		/* check for short read */
-		if (offset + ret > dio->i_size &&
+		if (offset + transferred > dio->i_size &&
 		    !(dio->flags & IOMAP_DIO_WRITE))
-			ret = dio->i_size - offset;
-		iocb->ki_pos += ret;
+			transferred = dio->i_size - offset;
+		iocb->ki_pos += transferred;
 	}
 
 	/*
@@ -759,7 +760,7 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
 	inode_dio_end(file_inode(iocb->ki_filp));
 	kfree(dio);
 
-	return ret;
+	return (transferred && sysctl_dio_short_writes) ? transferred : err;
 }
 
 static void iomap_dio_complete_work(struct work_struct *work)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 511fbaabf624..a25652e5ae1b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1469,6 +1469,7 @@ static inline void i_gid_write(struct inode *inode, gid_t gid)
 }
 
 extern struct timespec current_time(struct inode *inode);
+extern unsigned int sysctl_dio_short_writes;
 
 /*
  * Snapshotting support.
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 557d46728577..362a9c3156f1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1844,6 +1844,15 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &one,
 	},
+	{
+		.procname	= "dio_short_writes",
+		.data		= &sysctl_dio_short_writes,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 	{ }
 };
 
-- 
2.16.1

