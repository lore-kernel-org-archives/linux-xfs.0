Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35473 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdCAQrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2017 11:47:23 -0500
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v2] iomap: invalidate page caches should be after iomap_dio_complete() in direct write
Date: Thu,  2 Mar 2017 00:37:08 +0800
Message-Id: <20170301163708.7002-1-guaneryu@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, Eryu Guan <eguan@redhat.com>

From: Eryu Guan <eguan@redhat.com>

After XFS switching to iomap based DIO (commit acdda3aae146 ("xfs:
use iomap_dio_rw")), I started to notice dio29/dio30 tests failures
from LTP run on ppc64 hosts, and they can be reproduced on x86_64
hosts with 512B/1k block size XFS too.

dio29	diotest3 -b 65536 -n 100 -i 1000 -o 1024000
dio30	diotest6 -b 65536 -n 100 -i 1000 -o 1024000

The failure message is like:
bufcmp: offset 0: Expected: 0x62, got 0x0
diotest03    1  TPASS  :  Read with Direct IO, Write without
diotest03    2  TFAIL  :  diotest3.c:142: comparsion failed; child=98 offset=1425408
diotest03    3  TFAIL  :  diotest3.c:194: Write Direct-child 98 failed

Direct write wrote 0x62 but buffer read got zero. This is because,
when doing direct write to a hole or preallocated file, we
invalidate the page caches before converting the extent from
unwritten state to normal state, which is done by
iomap_dio_complete(), thus leave a window for other buffer reader to
cache the unwritten state extent.

Consider this case, with sub-page blocksize XFS, two processes are
direct writing to different blocksize-aligned regions (say 512B) of
the same preallocated file, and reading the region back via buffered
I/O to compare contents.

process A, region [0,512]		process B, region [512,1024]
xfs_file_write_iter
 xfs_file_aio_dio_write
  iomap_dio_rw
   iomap_apply
   invalidate_inode_pages2_range
   					xfs_file_write_iter
				 	xfs_file_aio_dio_write
					  iomap_dio_rw
					   iomap_apply
					   invalidate_inode_pages2_range
					   iomap_dio_complete
					xfs_file_read_iter
					 xfs_file_buffered_aio_read
					  generic_file_read_iter
					   do_generic_file_read
					    <readahead fills pagecache with 0>
   iomap_dio_complete
xfs_file_read_iter
 <read gets 0 from pagecache>

Process A first invalidates page caches, at this point the
underlying extent is still in unwritten state (iomap_dio_complete
not called yet), and process B finishs direct write and populates
page caches via readahead, which caches zeros in page for region A,
then process A reads zeros from page cache, instead of the actual
data.

Fix it by invalidating page caches after converting unwritten extent
to make sure we read content from disk after extent state changed,
as what we did before switching to iomap based dio.

Also introduce a new 'start' variable to save the original write
offset (iomap_dio_complete() updates iocb->ki_pos), and a 'err'
variable for invalidating caches result, cause we can't reuse 'ret'
anymore.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2:
- kill global 'res' var and use local var in if block with better name

 fs/iomap.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 0f85f24..864ad17 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -844,7 +844,8 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = file_inode(iocb->ki_filp);
 	size_t count = iov_iter_count(iter);
-	loff_t pos = iocb->ki_pos, end = iocb->ki_pos + count - 1, ret = 0;
+	loff_t pos = iocb->ki_pos, start = pos;
+	loff_t end = iocb->ki_pos + count - 1, ret = 0;
 	unsigned int flags = IOMAP_DIRECT;
 	struct blk_plug plug;
 	struct iomap_dio *dio;
@@ -885,12 +886,12 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	}
 
 	if (mapping->nrpages) {
-		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos, end);
+		ret = filemap_write_and_wait_range(mapping, start, end);
 		if (ret)
 			goto out_free_dio;
 
 		ret = invalidate_inode_pages2_range(mapping,
-				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
+				start >> PAGE_SHIFT, end >> PAGE_SHIFT);
 		WARN_ON_ONCE(ret);
 		ret = 0;
 	}
@@ -939,6 +940,8 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		__set_current_state(TASK_RUNNING);
 	}
 
+	ret = iomap_dio_complete(dio);
+
 	/*
 	 * Try again to invalidate clean pages which might have been cached by
 	 * non-direct readahead, or faulted in by get_user_pages() if the source
@@ -947,12 +950,12 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	 * this invalidation fails, tough, the write still worked...
 	 */
 	if (iov_iter_rw(iter) == WRITE && mapping->nrpages) {
-		ret = invalidate_inode_pages2_range(mapping,
-				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
-		WARN_ON_ONCE(ret);
+		int err = invalidate_inode_pages2_range(mapping,
+				start >> PAGE_SHIFT, end >> PAGE_SHIFT);
+		WARN_ON_ONCE(err);
 	}
 
-	return iomap_dio_complete(dio);
+	return ret;
 
 out_free_dio:
 	kfree(dio);
-- 
2.9.3

