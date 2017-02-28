Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/12] block_dev: implement the F_IOINFO fcntl
Date: Tue, 28 Feb 2017 06:57:36 -0800
Message-Id: <20170228145737.19016-12-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4dd5c54cdefb..48a799964e1d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -2116,6 +2116,26 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 					     end >> PAGE_SHIFT);
 }
 
+static int blkdev_ioinfo(struct file *file, struct fcntl_ioinfo *fio)
+{
+	struct block_device *bdev = I_BDEV(bdev_file_inode(file));
+	struct request_queue *q = bdev_get_queue(bdev);
+	unsigned int atomic_sectors = queue_max_atomic_write_sectors(q);
+
+	if (file->f_flags & O_DIRECT) {
+		fio->fio_alignment = bdev_logical_block_size(bdev);
+
+		if ((file->f_flags & O_ATOMIC) && atomic_sectors) {
+			fio->fio_flags = FIO_FL_ATOMIC_OSYNC;
+			fio->fio_max_atomic = (atomic_sectors << 9);
+			if (fio->fio_alignment)
+				fio->fio_max_atomic &= ~(fio->fio_alignment - 1);
+		}
+	}
+
+	return 0;
+};
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_close,
@@ -2131,6 +2151,7 @@ const struct file_operations def_blk_fops = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
+	.ioinfo		= blkdev_ioinfo,
 };
 
 int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)
-- 
2.11.0

