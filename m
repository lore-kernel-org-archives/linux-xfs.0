Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44620 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbfDDQ5s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Apr 2019 12:57:48 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [POC][PATCH] xfs: reduce ilock contention on buffered randrw workload
Date: Thu,  4 Apr 2019 19:57:37 +0300
Message-Id: <20190404165737.30889-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

This patch improves performance of mixed random rw workload
on xfs without relaxing the atomic buffered read/write guaranty
that xfs has always provided.

We achieve that by calling generic_file_read_iter() twice.
Once with a discard iterator to warm up page cache before taking
the shared ilock and once again under shared ilock.

Since this is a POC patch it also includes a separate fix to the
copy_page_to_iter() helper when called with discard iterator.
There is no other caller in the kernel to this method with a
discard iterator as far as I could see.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi Folks,

With this experimenital patch I was able to bring performance
of random rw workload benchmark on xfs much closer to ext4.

Ext4, as most Linux filesystems doesn't take the shared inode
lock on buffered reads and does not provide atomic buffered
reads w.r.t buffered writes.

Following are the numbers I got with filebench randomrw workload [1]
on a VM with 4 CPUs and spindles.

Note that this improvement is unrelated to the rw_semaphore starvation
issue that was observed when running the same benchmark on fast SDD
drive [2].

=== random read/write - cold page cache ===
--- EXT4 ---
 filebench randomrw (8 read threads, 8 write threads)
 kernel 5.1.0-rc2, ext4
 rand-write1          862304ops    14235ops/s 111.2mb/s      0.5ms/op
 rand-read1           22065ops      364ops/s   2.8mb/s     21.5ms/op

--- XFS ---
 filebench randomrw (8 read threads, 8 write threads)
 kernel 5.1.0-rc2, xfs
 rand-write1          39451ops      657ops/s   5.1mb/s     12.0ms/op
 rand-read1           2035ops       34ops/s   0.3mb/s    232.7ms/op

--- XFS+ ---
 filebench randomrw (8 read threads, 8 write threads)
 kernel 5.1.0-rc2+ (xfs page cache warmup patch)
 rand-write1          935597ops    15592ops/s 121.8mb/s      0.5ms/op
 rand-read1           4446ops       74ops/s   0.6mb/s    107.6ms/op

To measure the effects of two passes of generic_file_read_iter(), I ran
a random read [2] benchmark on 5GB file with warm and cold page cache.

=== random read - cold page cache ===
--- EXT4 ---
 filebench randomread (8 read threads) - cold page cache
 kernel 5.1.0-rc2
 rand-read1           23589ops      393ops/s   3.1mb/s     20.3ms/op

--- XFS ---
 filebench randomread (8 read threads) - cold page cache
 kernel 5.1.0-rc2
 rand-read1           20578ops      343ops/s   2.7mb/s     23.3ms/op

--- XFS+ ---
 filebench randomread (8 read threads) - cold page cache
 kernel 5.1.0-rc2+ (xfs page cache warmup patch)
 rand-read1           20476ops      341ops/s   2.7mb/s     23.4ms/op

=== random read - warm page cache ===
--- EXT4 ---
 filebench randomread (8 read threads) - warm page cache
 kernel 5.1.0-rc2
 rand-read1           58168696ops   969410ops/s 7573.5mb/s      0.0ms/op

--- XFS ---
 filebench randomread (8 read threads) - warm page cache
 kernel 5.1.0-rc2
 rand-read1           52748818ops   878951ops/s 6866.8mb/s      0.0ms/op

--- XFS+ ---
 filebench randomread (8 read threads) - warm page cache
 kernel 5.1.0-rc2+ (xfs page cache warmup patch)
 rand-read1           52770537ops   879445ops/s 6870.7mb/s      0.0ms/op

The numbers of this benchmark do not show and measurable difference for
readers only workload with either cold or warm page cache.

If needed I can provide more measurments with fio or with different
workloads and different drives.

Fire away!

Thanks,
Amir.

[1] https://github.com/amir73il/filebench/blob/overlayfs-devel/workloads/randomrw.f
[2] https://marc.info/?l=linux-xfs&m=155347265016053&w=2
[3] https://github.com/amir73il/filebench/blob/overlayfs-devel/workloads/randomread.f

 fs/xfs/xfs_file.c | 14 ++++++++++++++
 lib/iov_iter.c    |  5 +++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1f2e284..4e5f88a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -240,6 +240,20 @@ xfs_file_buffered_aio_read(
 		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
 			return -EAGAIN;
 	} else {
+		/*
+		 * Warm up page cache to minimize time spent under
+		 * shared ilock.
+		 */
+		struct iov_iter	iter;
+		loff_t pos = iocb->ki_pos;
+
+		iov_iter_discard(&iter, READ, iov_iter_count(to));
+		ret = generic_file_read_iter(iocb, &iter);
+		if (ret <= 0)
+			return ret;
+
+		iocb->ki_pos = pos;
+
 		xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	}
 	ret = generic_file_read_iter(iocb, to);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index ea36dc3..b22e433 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -893,9 +893,10 @@ size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 		size_t wanted = copy_to_iter(kaddr + offset, bytes, i);
 		kunmap_atomic(kaddr);
 		return wanted;
-	} else if (unlikely(iov_iter_is_discard(i)))
+	} else if (unlikely(iov_iter_is_discard(i))) {
+		i->count -= bytes;
 		return bytes;
-	else if (likely(!iov_iter_is_pipe(i)))
+	} else if (likely(!iov_iter_is_pipe(i)))
 		return copy_page_to_iter_iovec(page, offset, bytes, i);
 	else
 		return copy_page_to_iter_pipe(page, offset, bytes, i);
-- 
2.7.4
