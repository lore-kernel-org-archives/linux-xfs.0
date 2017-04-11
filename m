Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753266AbdDKO0j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 10:26:39 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 2/9] nowait aio: Introduce RWF_NOWAIT
Date: Tue, 11 Apr 2017 09:26:12 -0500
Message-Id: <20170411142619.27205-3-rgoldwyn@suse.de>
In-Reply-To: <20170411142619.27205-1-rgoldwyn@suse.de>
References: <20170411142619.27205-1-rgoldwyn@suse.de>
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

RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/aio.c                | 12 ++++++++++--
 include/linux/fs.h      |  1 +
 include/uapi/linux/fs.h |  1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 7cd1443ad1c8..948af3729d69 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1546,12 +1546,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		return -EINVAL;
 	}
 
-	if (unlikely(iocb->aio_rw_flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))) {
+	if (unlikely(iocb->aio_rw_flags &
+		     ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT))) {
 		pr_debug("EINVAL: aio_rw_flags set with incompatible flags\n");
 		return -EINVAL;
 	}
 
-
 	/* prevent overflows */
 	if (unlikely(
 	    (iocb->aio_buf != (unsigned long)iocb->aio_buf) ||
@@ -1598,6 +1598,14 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		req->common.ki_flags |= IOCB_DSYNC;
 	if (iocb->aio_rw_flags & RWF_SYNC)
 		req->common.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
+	if (iocb->aio_rw_flags & RWF_NOWAIT) {
+		if (!(iocb->aio_lio_opcode & IOCB_CMD_PWRITE) ||
+		    !(req->common.ki_flags & IOCB_DIRECT)) {
+			ret = -EINVAL;
+			goto out_put_req;
+		}
+		req->common.ki_flags |= IOCB_NOWAIT;
+	}
 
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7251f7bb45e8..e8d93462529c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -270,6 +270,7 @@ struct writeback_control;
 #define IOCB_DSYNC		(1 << 4)
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
+#define IOCB_NOWAIT		(1 << 7)
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 048a85e9f017..7bcaef101876 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -347,5 +347,6 @@ struct fscrypt_policy {
 #define RWF_HIPRI			0x00000001 /* high priority request, poll if possible */
 #define RWF_DSYNC			0x00000002 /* per-IO O_DSYNC */
 #define RWF_SYNC			0x00000004 /* per-IO O_SYNC */
+#define RWF_NOWAIT			0x00000008 /* per-IO, return -EAGAIN if operation would block */
 
 #endif /* _UAPI_LINUX_FS_H */
-- 
2.12.0

