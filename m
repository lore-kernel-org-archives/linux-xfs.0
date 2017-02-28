Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/12] xfs: implement the F_IOINFO fcntl
Date: Tue, 28 Feb 2017 06:57:33 -0800
Message-Id: <20170228145737.19016-9-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a7d8324b59c5..4d955b3266df 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -898,6 +898,39 @@ xfs_file_dedupe_range(
 	return len;
 }
 
+static uint16_t
+xfs_dio_alignment(struct file *file)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(file));
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (file->f_flags & O_ATOMIC)
+		return mp->m_sb.sb_blocksize;
+	else if (XFS_IS_REALTIME_INODE(ip))
+		return mp->m_rtdev_targp->bt_logical_sectorsize;
+	else
+		return mp->m_ddev_targp->bt_logical_sectorsize;
+}
+
+static int
+xfs_file_ioinfo(
+	struct file		*file,
+	struct fcntl_ioinfo	*fio)
+{
+	if (file->f_flags & O_DIRECT)
+		fio->fio_alignment = xfs_dio_alignment(file);
+
+	if (file->f_flags & O_ATOMIC) {
+		fio->fio_flags = FIO_FL_ATOMIC_OSYNC | FIO_FL_ATOMIC_FSYNC;
+		fio->fio_max_atomic = INT_MAX;
+		if (fio->fio_alignment)
+			fio->fio_max_atomic &= ~(fio->fio_alignment - 1);
+	}
+
+
+	return 0;
+};
+
 STATIC int
 xfs_file_open(
 	struct inode	*inode,
@@ -1556,6 +1589,7 @@ const struct file_operations xfs_file_operations = {
 	.fallocate	= xfs_file_fallocate,
 	.clone_file_range = xfs_file_clone_range,
 	.dedupe_file_range = xfs_file_dedupe_range,
+	.ioinfo		= xfs_file_ioinfo,
 };
 
 const struct file_operations xfs_dir_file_operations = {
-- 
2.11.0

