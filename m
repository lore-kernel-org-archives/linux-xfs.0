Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDCAC001DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 19:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjGSTy3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjGSTy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 15:54:28 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A92DB3
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 12:54:26 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-3461b58c61dso149485ab.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 12:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689796465; x=1692388465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45begm+fIx+LrUIPU3YZoGzZeihEJfvQZCl04QelfsE=;
        b=YqXQR4MHANqJ4lqNW+dVVcLxA6p+84Z8JqnMPbx2YwUnr3ejibQ3s0RNm3WmVb+2zp
         BaxyAnKKw7OEVhFtW+ifnNtlqJ03MjuOcUeaK8wrGrZLcT0s51LMRP3DQr5txqrzr3XH
         +g74qADtzwULZf650xEAwHFSiW3r/4o8hJ95HRlmucc6K9AilmzmK21wOtrOlSL2p/9a
         +3HDWmTrunAiIJVU7SMz82WLYie45vODi+6FtLpQaxRdLxAS7QwLp19vqnZqkK0YHFKy
         8mGqA4Rt4kYNJrlbwGFst2KNYRja3/r+6VG+/UjbkR2wUVQ4aw1E4ILMu9tSSpEW2Ql0
         XvHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689796465; x=1692388465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45begm+fIx+LrUIPU3YZoGzZeihEJfvQZCl04QelfsE=;
        b=DiBCSALI4xtup5Z4jCIK7R6SkEZrG1DS0BP35izwyHW3/8IGIC1nWaU4pXnMijpKYR
         cauui4U+gaQwm7CO0M4/L1Y+iYHoEr5EaqrcfDA54kl34O4MRwWHJOc5iGTMwSQePqW6
         JtIzYX0tmTfc1/WzieeCkJ3m5ZKWopSKeHcXbWqUxASHN3nSw6IXT12W0iikDZlIzzXr
         zYlF3sUnFHFbcUWqlMbbfX/62qVtmEStWkh71xYKkq0BjVStj+kdarFC1YLshTDfmKrb
         O/XFWDvEOPGijnO8GOidtfzIc4wVsn0V1/mX+HUsz1TWA0Giu+wYw3nIsHGQaoMRuojH
         kPZg==
X-Gm-Message-State: ABy/qLaDz1zfXHDHDwBwlvCM7O+T1u6VzxaSa8fE3emyezGVFMtGgvRO
        WYy5tqaGZv0/yusvV9UmLMwbZ00+3azeBp3drco=
X-Google-Smtp-Source: APBJJlFFfZAK6BEoCWdwWC6nABZAvmNLxmkBzkKmeWekoeuiJzcEvs+ie0vVzdLsUtQ159wXwx5Zbg==
X-Received: by 2002:a05:6602:3404:b0:77a:ee79:652 with SMTP id n4-20020a056602340400b0077aee790652mr511333ioz.1.1689796465599;
        Wed, 19 Jul 2023 12:54:25 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j21-20020a02a695000000b0042bb13cb80fsm1471893jam.120.2023.07.19.12.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 12:54:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] iomap: add IOMAP_DIO_INLINE_COMP
Date:   Wed, 19 Jul 2023 13:54:13 -0600
Message-Id: <20230719195417.1704513-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719195417.1704513-1-axboe@kernel.dk>
References: <20230719195417.1704513-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rather than gate whether or not we need to punt a dio completion to a
workqueue, add an explicit flag for it. For now we treat them the same,
reads always set the flags and async writes do not.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 1c32f734c767..6b302bf8790b 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,6 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_INLINE_COMP	(1 << 27)
 #define IOMAP_DIO_WRITE_FUA	(1 << 28)
 #define IOMAP_DIO_NEED_SYNC	(1 << 29)
 #define IOMAP_DIO_WRITE		(1 << 30)
@@ -171,20 +172,25 @@ void iomap_dio_bio_end_io(struct bio *bio)
 	}
 
 	/*
-	 * If this dio is an async write, queue completion work for async
-	 * handling. Reads can always complete inline.
+	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
 	 */
-	if (dio->flags & IOMAP_DIO_WRITE) {
-		struct inode *inode = file_inode(iocb->ki_filp);
-
-		WRITE_ONCE(iocb->private, NULL);
-		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
-		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
-	} else {
+	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
+		goto release_bio;
 	}
 
+	/*
+	 * Async DIO completion that requires filesystem level completion work
+	 * gets punted to a work queue to complete as the operation may require
+	 * more IO to be issued to finalise filesystem metadata changes or
+	 * guarantee data integrity.
+	 */
+	WRITE_ONCE(iocb->private, NULL);
+	INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
+	queue_work(file_inode(iocb->ki_filp)->i_sb->s_dio_done_wq,
+			&dio->aio.work);
+
 release_bio:
 	if (should_dirty) {
 		bio_check_pages_dirty(bio);
@@ -524,6 +530,9 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomi.flags |= IOMAP_NOWAIT;
 
 	if (iov_iter_rw(iter) == READ) {
+		/* reads can always complete inline */
+		dio->flags |= IOMAP_DIO_INLINE_COMP;
+
 		if (iomi.pos >= dio->i_size)
 			goto out_free_dio;
 
-- 
2.40.1

