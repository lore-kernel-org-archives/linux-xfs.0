Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8A2C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 03:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349147AbiDODto (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 23:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348395AbiDODtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 23:49:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EE505AA64
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 20:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649994434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OmFzF4P+0ykVdRezfaRk2XA/8c8gib3FIWkPQg2gCgk=;
        b=QQ5Ul/IFOUJMk6TZtuSpDOjbq+f1HZbtLZ5eNJP5TysaqBsJKXB46D4jAjSyiAoXoe6mUR
        Ff8q49eD5YTqZf/sWLhcVmhUeiy0W1c4tGjqdL+dY7tH7cDRdHnuJXkFQyayLKPcrBYE8m
        j9sBrMqXxgROgLNMKuOf1o5ZFFBP+p8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-179hF6s6PbSjO_5l_uwFEw-1; Thu, 14 Apr 2022 23:47:11 -0400
X-MC-Unique: 179hF6s6PbSjO_5l_uwFEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7F7A1C04B41;
        Fri, 15 Apr 2022 03:47:10 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6FA840EC010;
        Fri, 15 Apr 2022 03:47:09 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: [PATCH V2] block: avoid io timeout in case of sync polled dio
Date:   Fri, 15 Apr 2022 11:47:03 +0800
Message-Id: <20220415034703.2081695-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For POLLED bio, bio_poll() should be called for reaping io since
there isn't irq for completing the request, so we can't call into
blk_io_schedule() in case that bio_poll() returns zero, otherwise
io timeout is easily triggered.

Also before calling bio_poll(), current->plug should be flushed out,
otherwise the bio may not be issued to driver, and ->bi_cookie won't
be set.

CC: linux-mm@kvack.org
Cc: linux-xfs@vger.kernel.org
Reported-by: Changhui Zhong <czhong@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- as pointed out by Christoph, iomap & mm code should be covered

 block/fops.c         | 7 ++++++-
 fs/iomap/direct-io.c | 7 +++++--
 mm/page_io.c         | 8 +++++++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 9f2ecec406b0..c9bac700e072 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -101,11 +101,16 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 		bio_set_polled(&bio, iocb);
 
 	submit_bio(&bio);
+	/* make sure the bio is issued before polling */
+	if (bio.bi_opf & REQ_POLLED)
+		blk_flush_plug(current->plug, false);
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!READ_ONCE(bio.bi_private))
 			break;
-		if (!(iocb->ki_flags & IOCB_HIPRI) || !bio_poll(&bio, NULL, 0))
+		if (bio.bi_opf & REQ_POLLED)
+			bio_poll(&bio, NULL, 0);
+		else
 			blk_io_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b08f5dc31780..e67d2f63a163 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -654,8 +654,11 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 			if (!READ_ONCE(dio->submit.waiter))
 				break;
 
-			if (!dio->submit.poll_bio ||
-			    !bio_poll(dio->submit.poll_bio, NULL, 0))
+			if (dio->submit.poll_bio &&
+					(dio->submit.poll_bio->bi_opf &
+						REQ_POLLED))
+				bio_poll(dio->submit.poll_bio, NULL, 0);
+			else
 				blk_io_schedule();
 		}
 		__set_current_state(TASK_RUNNING);
diff --git a/mm/page_io.c b/mm/page_io.c
index b417f000b49e..16f2a63e2524 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -421,12 +421,18 @@ int swap_readpage(struct page *page, bool synchronous)
 	count_vm_event(PSWPIN);
 	bio_get(bio);
 	submit_bio(bio);
+
+	/* make sure the bio is issued before polling */
+	if (bio->bi_opf & REQ_POLLED)
+		blk_flush_plug(current->plug, false);
 	while (synchronous) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!READ_ONCE(bio->bi_private))
 			break;
 
-		if (!bio_poll(bio, NULL, 0))
+		if (bio->bi_opf & REQ_POLLED)
+			bio_poll(bio, NULL, 0);
+		else
 			blk_io_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
-- 
2.31.1

