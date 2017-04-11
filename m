Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51221 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753484AbdDKO0l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 10:26:41 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/9] Use RWF_* flags for AIO operations
Date: Tue, 11 Apr 2017 09:26:11 -0500
Message-Id: <20170411142619.27205-2-rgoldwyn@suse.de>
In-Reply-To: <20170411142619.27205-1-rgoldwyn@suse.de>
References: <20170411142619.27205-1-rgoldwyn@suse.de>
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
 fs/aio.c                     | 15 ++++++++++++++-
 include/uapi/linux/aio_abi.h |  2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index f52d925ee259..7cd1443ad1c8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1541,11 +1541,17 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
+	if (unlikely(iocb->aio_reserved2)) {
 		pr_debug("EINVAL: reserve field set\n");
 		return -EINVAL;
 	}
 
+	if (unlikely(iocb->aio_rw_flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))) {
+		pr_debug("EINVAL: aio_rw_flags set with incompatible flags\n");
+		return -EINVAL;
+	}
+
+
 	/* prevent overflows */
 	if (unlikely(
 	    (iocb->aio_buf != (unsigned long)iocb->aio_buf) ||
@@ -1586,6 +1592,13 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		req->common.ki_flags |= IOCB_EVENTFD;
 	}
 
+	if (iocb->aio_rw_flags & RWF_HIPRI)
+		req->common.ki_flags |= IOCB_HIPRI;
+	if (iocb->aio_rw_flags & RWF_DSYNC)
+		req->common.ki_flags |= IOCB_DSYNC;
+	if (iocb->aio_rw_flags & RWF_SYNC)
+		req->common.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
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

