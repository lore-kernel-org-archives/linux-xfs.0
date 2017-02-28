Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49757 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752093AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/12] fs: add a F_IOINFO fcntl
Date: Tue, 28 Feb 2017 06:57:30 -0800
Message-Id: <20170228145737.19016-6-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

This fcntl can be used to query I/O parameters for the given file
descriptor.  Initially it is used for the I/O alignment and atomic
write parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fcntl.c                 | 18 ++++++++++++++++++
 include/linux/fs.h         |  1 +
 include/uapi/linux/fcntl.h | 16 ++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index ca5d228be7ea..248fb4cc66a6 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -241,6 +241,21 @@ static int f_getowner_uids(struct file *filp, unsigned long arg)
 }
 #endif
 
+static int fcntl_ioinfo(struct file *file, void __user *argp)
+{
+	struct fcntl_ioinfo fio = { 0, };
+
+	if (file->f_op->ioinfo) {
+		int ret = file->f_op->ioinfo(file, &fio);
+		if (ret)
+			return ret;
+	}
+
+	if (copy_to_user(argp, &fio, sizeof(fio)))
+		return -EFAULT;
+	return 0;
+}
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -335,6 +350,9 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	case F_GET_SEALS:
 		err = shmem_fcntl(filp, cmd, arg);
 		break;
+	case F_IOINFO:
+		err = fcntl_ioinfo(filp, (void __user *)arg);
+		break;
 	default:
 		break;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2ba074328894..33b08a8c2bc3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1680,6 +1680,7 @@ struct file_operations {
 			u64);
 	ssize_t (*dedupe_file_range)(struct file *, u64, u64, struct file *,
 			u64);
+	int (*ioinfo)(struct file *, struct fcntl_ioinfo *);
 };
 
 struct inode_operations {
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index beed138bd359..6b0aaba7c623 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -42,6 +42,22 @@
 #define F_SEAL_WRITE	0x0008	/* prevent writes */
 /* (1U << 31) is reserved for signed error codes */
 
+
+#define F_IOINFO	(F_LINUX_SPECIFIC_BASE +  11)
+
+struct fcntl_ioinfo {
+	__u16		fio_flags;	/* FIO_FL_* */
+	__u16		fio_alignment;	/* required I/O alignment on disk */
+	__u32		__reserved1;	/* must be zero */
+	__u64		fio_max_atomic;	/* max size for atomic writes */
+	__u64		__reserved2[14];/* must be zero */
+};
+
+/* supports atomic writes using O_(D)SYNC */
+#define FIO_FL_ATOMIC_OSYNC	(1 << 0)
+/* supports atomic writes committed using fsync/fdatasync/msync */
+#define FIO_FL_ATOMIC_FSYNC	(1 << 1)
+
 /*
  * Types of directory notifications that may be requested.
  */
-- 
2.11.0

