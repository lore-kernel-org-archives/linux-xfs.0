Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK8HWxx126219 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 02:17:32 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id l6VPV83BntqlQC7n (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 00:19:41 -0800 (PST)
Subject: [PATCH 9/9] blkdev: Fix up AIO+DIO+O_SYNC to do the sync part
	correctly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 19 Nov 2012 23:51:15 -0800
Message-ID: <20121120075115.25270.62451.stgit@blackbox.djwong.org>
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

When performing O_SYNC+AIO+DIO writes to block devices, use the DIO_SYNC_WRITES
flag so that flushes are issued /after/ the write completes, not before.

Note, however, that for block devices, the DIO setup code ensures that a flush
wq is attached to the superblock of the bdevfs filesystem, not the filesystem
that the device node happens to reside in.  This means that unlike regular
files, iocb->ki_filp->f_mapping->host->i_sb != inode->i_sb.  Therefore, adjust
Jeff's earlier patch to keep the pointer use consistent and avoid a NULL deref.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/block_dev.c |    5 +++--
 fs/direct-io.c |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1a1e5e3..05ff33a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -235,7 +235,8 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	struct inode *inode = file->f_mapping->host;
 
 	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
-				    nr_segs, blkdev_get_blocks, NULL, NULL, 0);
+				    nr_segs, blkdev_get_blocks, NULL, NULL,
+				    DIO_SYNC_WRITES);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
@@ -1631,7 +1632,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
-	if (ret > 0 || ret == -EIOCBQUEUED) {
+	if (ret > 0) {
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, ret);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index b7391d4..c626c43 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -258,7 +258,8 @@ void generic_dio_end_io(struct kiocb *iocb, loff_t offset, ssize_t bytes,
 		work->ret = ret;
 		work->offset = offset;
 		work->len = bytes;
-		queue_work(inode->i_sb->s_dio_flush_wq, &work->work);
+		queue_work(iocb->ki_filp->f_mapping->host->i_sb->s_dio_flush_wq,
+			   &work->work);
 	} else {
 		aio_complete(iocb, ret, 0);
 		inode_dio_done(inode);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
