Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40360 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753665AbdEIMWa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 08:22:30 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/8] Use RWF_* flags for AIO operations
Date: Tue,  9 May 2017 07:22:12 -0500
Message-Id: <20170509122219.31756-2-rgoldwyn@suse.de>
In-Reply-To: <20170509122219.31756-1-rgoldwyn@suse.de>
References: <20170509122219.31756-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

RWF_* flags is used for preadv2/pwritev2 calls. Port to use
it for aio operations as well. For this, aio_rw_flags is
introduced in struct iocb (using aio_reserved1) which will
carry these flags.

This is a precursor to the nowait AIO calls.

Note, the only place RWF_HIPRI comes in effect is dio_await_one().
All the rest of the locations, aio code return -EIOCBQUEUED before the
checks for RWF_HIPRI.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/aio.c                     |  8 +++++++-
 fs/read_write.c              | 12 +++---------
 include/linux/fs.h           | 14 ++++++++++++++
 include/uapi/linux/aio_abi.h |  2 +-
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index f52d925ee259..020fa0045e3c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1541,7 +1541,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
+	if (unlikely(iocb->aio_reserved2)) {
 		pr_debug("EINVAL: reserve field set\n");
 		return -EINVAL;
 	}
@@ -1586,6 +1586,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		req->common.ki_flags |= IOCB_EVENTFD;
 	}
 
+	ret = kiocb_set_rw_flags(&req->common, iocb->aio_rw_flags);
+	if (unlikely(ret)) {
+		pr_debug("EINVAL: aio_rw_flags\n");
+		goto out_put_req;
+	}
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
diff --git a/fs/read_write.c b/fs/read_write.c
index c4f88afbc67f..362f91cd8d66 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -678,16 +678,10 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 	struct kiocb kiocb;
 	ssize_t ret;
 
-	if (flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))
-		return -EOPNOTSUPP;
-
 	init_sync_kiocb(&kiocb, filp);
-	if (flags & RWF_HIPRI)
-		kiocb.ki_flags |= IOCB_HIPRI;
-	if (flags & RWF_DSYNC)
-		kiocb.ki_flags |= IOCB_DSYNC;
-	if (flags & RWF_SYNC)
-		kiocb.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
+	ret = kiocb_set_rw_flags(&kiocb, flags);
+	if (ret)
+		return ret;
 	kiocb.ki_pos = *ppos;
 
 	if (type == READ)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7251f7bb45e8..869c9a6fe58d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3049,6 +3049,20 @@ static inline int iocb_flags(struct file *file)
 	return res;
 }
 
+static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
+{
+	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC)))
+		return -EOPNOTSUPP;
+
+	if (flags & RWF_HIPRI)
+		ki->ki_flags |= IOCB_HIPRI;
+	if (flags & RWF_DSYNC)
+		ki->ki_flags |= IOCB_DSYNC;
+	if (flags & RWF_SYNC)
+		ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
+	return 0;
+}
+
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index bb2554f7fbd1..a2d4a8ac94ca 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -79,7 +79,7 @@ struct io_event {
 struct iocb {
 	/* these are internal to the kernel/libc. */
 	__u64	aio_data;	/* data to be returned in event's data */
-	__u32	PADDED(aio_key, aio_reserved1);
+	__u32	PADDED(aio_key, aio_rw_flags);
 				/* the kernel sets aio_key to the req # */
 
 	/* common fields */
-- 
2.12.0

