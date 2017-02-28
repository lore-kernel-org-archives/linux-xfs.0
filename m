Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52385 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751186AbdB1X7y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 18:59:54 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/8] nowait aio: Introduce IOCB_FLAG_NOWAIT
Date: Tue, 28 Feb 2017 17:36:03 -0600
Message-Id: <20170228233610.25456-2-rgoldwyn@suse.de>
In-Reply-To: <20170228233610.25456-1-rgoldwyn@suse.de>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This flag informs kernel to bail out if an AIO request will block
for reasons such as file allocations, or a writeback triggered,
or would block while allocating requests while performing
direct I/O.

IOCB_FLAG_NOWAIT is translated to IOCB_NOWAIT for
iocb->ki_flags.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/aio.c                     | 3 +++
 include/linux/fs.h           | 1 +
 include/uapi/linux/aio_abi.h | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 873b4ca..5ae19ba 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1586,6 +1586,9 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		req->common.ki_flags |= IOCB_EVENTFD;
 	}
 
+	if (iocb->aio_flags & IOCB_FLAG_NOWAIT)
+		req->common.ki_flags |= IOCB_NOWAIT;
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2ba0743..ab2f556 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -270,6 +270,7 @@ struct writeback_control;
 #define IOCB_DSYNC		(1 << 4)
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
+#define IOCB_NOWAIT		(1 << 7)
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index bb2554f..82d1d94 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -51,8 +51,11 @@ enum {
  *
  * IOCB_FLAG_RESFD - Set if the "aio_resfd" member of the "struct iocb"
  *                   is valid.
+ * IOCB_FLAG_NOWAIT - Set if the user wants the iocb to fail if it would block
+ *			for operations such as disk allocation.
  */
 #define IOCB_FLAG_RESFD		(1 << 0)
+#define IOCB_FLAG_NOWAIT	(1 << 1)
 
 /* read() from /dev/aio returns these structures. */
 struct io_event {
-- 
2.10.2

