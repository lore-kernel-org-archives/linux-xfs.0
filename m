Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45905 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752226AbdDCSxl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 14:53:41 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/8] nowait aio: Introduce IOCB_RW_FLAG_NOWAIT
Date: Mon,  3 Apr 2017 13:53:00 -0500
Message-Id: <20170403185307.6243-2-rgoldwyn@suse.de>
In-Reply-To: <20170403185307.6243-1-rgoldwyn@suse.de>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This flag informs kernel to bail out if an AIO request will block
for reasons such as file allocations, or a writeback triggered,
or would block while allocating requests while performing
direct I/O.

Unfortunately, aio_flags is not checked for validity, which would
break existing applications which have it set to anything besides zero
or IOCB_FLAG_RESFD. So, we are using aio_reserved1 and renaming it
to aio_rw_flags.

IOCB_RW_FLAG_NOWAIT is translated to IOCB_NOWAIT for
iocb->ki_flags.

Added FS_NOWAIT to make sure VFS knows that the filesystem is capable
of performing direct-AIO with IOCB_RW_FLAG_NOWAIT.
---
 fs/aio.c                     | 15 ++++++++++++++-
 include/linux/fs.h           |  2 ++
 include/uapi/linux/aio_abi.h |  9 ++++++++-
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index f52d925..25ae59b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1541,11 +1541,16 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
+	if (unlikely(iocb->aio_reserved2)) {
 		pr_debug("EINVAL: reserve field set\n");
 		return -EINVAL;
 	}
 
+	if (unlikely(iocb->aio_rw_flags & ~IOCB_RW_FLAG_NOWAIT)) {
+		pr_debug("EINVAL: aio_rw_flags set with incompatible flags\n");
+		return -EINVAL;
+	}
+
 	/* prevent overflows */
 	if (unlikely(
 	    (iocb->aio_buf != (unsigned long)iocb->aio_buf) ||
@@ -1586,6 +1591,14 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		req->common.ki_flags |= IOCB_EVENTFD;
 	}
 
+	if (iocb->aio_rw_flags & IOCB_RW_FLAG_NOWAIT) {
+		if (!(file->f_inode->i_sb->s_type->fs_flags & FS_NOWAIT)) {
+			ret = -EOPNOTSUPP;
+			goto out_put_req;
+		}
+		req->common.ki_flags |= IOCB_NOWAIT;
+	}
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7251f7b..802cfe2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -270,6 +270,7 @@ struct writeback_control;
 #define IOCB_DSYNC		(1 << 4)
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
+#define IOCB_NOWAIT		(1 << 7)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -2020,6 +2021,7 @@ struct file_system_type {
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
+#define FS_NOWAIT		65536	/* FS supports nowait direct AIO */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
 	void (*kill_sb) (struct super_block *);
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index bb2554f..6d98cbe 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -54,6 +54,13 @@ enum {
  */
 #define IOCB_FLAG_RESFD		(1 << 0)
 
+/*
+ * Flags for aio_rw_flags member of "struct iocb".
+ * IOCB_RW_FLAG_NOWAIT - Set if the user wants the iocb to fail if it
+ *			would block for operations such as disk allocation.
+ */
+#define IOCB_RW_FLAG_NOWAIT	(1 << 1)
+
 /* read() from /dev/aio returns these structures. */
 struct io_event {
 	__u64		data;		/* the data field from the iocb */
@@ -79,7 +86,7 @@ struct io_event {
 struct iocb {
 	/* these are internal to the kernel/libc. */
 	__u64	aio_data;	/* data to be returned in event's data */
-	__u32	PADDED(aio_key, aio_reserved1);
+	__u32	PADDED(aio_key, aio_rw_flags);
 				/* the kernel sets aio_key to the req # */
 
 	/* common fields */
-- 
2.10.2

