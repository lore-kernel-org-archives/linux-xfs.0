Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89F4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 09:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244913AbiDTJ34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 05:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244362AbiDTJ3z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 05:29:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AD5410FFE
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 02:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650446828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4dTwK67U3Ol8e3iWjDo1+lTVKP/yswiPklESBpjAd6k=;
        b=SEQrBg+O/3AWlcmz0szrRQ5iIf0Gb0SY5a7mcpy8XIrmiPZjDwji/ovExnyBcJ7ucu3YVL
        FXAZMSxFE6hLSz/uJfWnpfryhP03FV4B04nO3iqxujxIAvAaoaxZ8dpgu9807xUwO6QDVh
        i14foVUW6WlOiVXCwG1DLxF/1Cml9Tk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-1zlVpXKKO2WxAcAuONjVnA-1; Wed, 20 Apr 2022 05:27:07 -0400
X-MC-Unique: 1zlVpXKKO2WxAcAuONjVnA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39F293801EC9;
        Wed, 20 Apr 2022 09:27:07 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36A9C407F764;
        Wed, 20 Apr 2022 09:27:05 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: [PATCH] block: ignore RWF_HIPRI hint for sync dio
Date:   Wed, 20 Apr 2022 17:26:51 +0800
Message-Id: <20220420092651.2623016-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So far bio is marked as REQ_POLLED if RWF_HIPRI/IOCB_HIPRI is passed
from userspace sync io interface, then block layer tries to poll until
the bio is completed. But the current implementation calls
blk_io_schedule() if bio_poll() returns 0, and this way causes io hang or
timeout easily.

But looks no one reports this kind of issue, which should have been
triggered in normal io poll sanity test or blktests block/007 as
observed by Changhui, that means it is very likely that no one uses it
or no one cares it.

Also after io_uring is invented, io poll for sync dio becomes legacy
interface.

So ignore RWF_HIPRI hint for sync dio.

CC: linux-mm@kvack.org
Cc: linux-xfs@vger.kernel.org
Reported-by: Changhui Zhong <czhong@redhat.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/fops.c         | 22 +---------------------
 fs/iomap/direct-io.c | 13 ++-----------
 mm/page_io.c         |  4 +---
 3 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index e3643362c244..b9b83030e0df 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -44,14 +44,6 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
 
 #define DIO_INLINE_BIO_VECS 4
 
-static void blkdev_bio_end_io_simple(struct bio *bio)
-{
-	struct task_struct *waiter = bio->bi_private;
-
-	WRITE_ONCE(bio->bi_private, NULL);
-	blk_wake_io_task(waiter);
-}
-
 static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 		struct iov_iter *iter, unsigned int nr_pages)
 {
@@ -83,8 +75,6 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 		bio_init(&bio, bdev, vecs, nr_pages, dio_bio_write_op(iocb));
 	}
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
-	bio.bi_private = current;
-	bio.bi_end_io = blkdev_bio_end_io_simple;
 	bio.bi_ioprio = iocb->ki_ioprio;
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
@@ -97,18 +87,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio.bi_opf |= REQ_NOWAIT;
-	if (iocb->ki_flags & IOCB_HIPRI)
-		bio_set_polled(&bio, iocb);
 
-	submit_bio(&bio);
-	for (;;) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!READ_ONCE(bio.bi_private))
-			break;
-		if (!(iocb->ki_flags & IOCB_HIPRI) || !bio_poll(&bio, NULL, 0))
-			blk_io_schedule();
-	}
-	__set_current_state(TASK_RUNNING);
+	submit_bio_wait(&bio);
 
 	bio_release_pages(&bio, should_dirty);
 	if (unlikely(bio.bi_status))
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 62da020d02a1..8d2223bf7aa6 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -41,7 +41,6 @@ struct iomap_dio {
 		struct {
 			struct iov_iter		*iter;
 			struct task_struct	*waiter;
-			struct bio		*poll_bio;
 		} submit;
 
 		/* used for aio completion: */
@@ -56,11 +55,6 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 {
 	atomic_inc(&dio->ref);
 
-	if (dio->iocb->ki_flags & IOCB_HIPRI) {
-		bio_set_polled(bio, dio->iocb);
-		dio->submit.poll_bio = bio;
-	}
-
 	if (dio->dops && dio->dops->submit_io)
 		dio->dops->submit_io(iter, bio, pos);
 	else
@@ -507,7 +501,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 	dio->submit.iter = iter;
 	dio->submit.waiter = current;
-	dio->submit.poll_bio = NULL;
 
 	if (iov_iter_rw(iter) == READ) {
 		if (iomi.pos >= dio->i_size)
@@ -626,7 +619,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_WRITE_FUA)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
-	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
+	WRITE_ONCE(iocb->private, NULL);
 
 	/*
 	 * We are about to drop our additional submission reference, which
@@ -653,9 +646,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 			if (!READ_ONCE(dio->submit.waiter))
 				break;
 
-			if (!dio->submit.poll_bio ||
-			    !bio_poll(dio->submit.poll_bio, NULL, 0))
-				blk_io_schedule();
+			blk_io_schedule();
 		}
 		__set_current_state(TASK_RUNNING);
 	}
diff --git a/mm/page_io.c b/mm/page_io.c
index 89fbf3cae30f..3fbdab6a940e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -360,7 +360,6 @@ int swap_readpage(struct page *page, bool synchronous)
 	 * attempt to access it in the page fault retry time check.
 	 */
 	if (synchronous) {
-		bio->bi_opf |= REQ_POLLED;
 		get_task_struct(current);
 		bio->bi_private = current;
 	}
@@ -372,8 +371,7 @@ int swap_readpage(struct page *page, bool synchronous)
 		if (!READ_ONCE(bio->bi_private))
 			break;
 
-		if (!bio_poll(bio, NULL, 0))
-			blk_io_schedule();
+		blk_io_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
 	bio_put(bio);
-- 
2.31.1

