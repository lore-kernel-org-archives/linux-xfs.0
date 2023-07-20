Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A25CC001DE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 18:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjGTSNS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 14:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjGTSNR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 14:13:17 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9210592
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 11:13:16 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-345d2b936c2so1189725ab.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 11:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876796; x=1690481596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNCV/9UyhdagyTy8j9zaAfC1YSEjA868oZWehUYPc18=;
        b=4qN9kcWKtIHkZTeJ+QkMdqZGhivUbWNO2u1UIl3QwSNJZP2aVwNoHHTott6cJFLKIw
         1Ompc0zLAYZrLiHSnqyuVz2PZ44mqJnrMHYKBANXnGxIPW2q4iIeihWTFI619A7Z7n9K
         Lg7lmY6U3VEtA1gL+kwX0CPjICN2CqbeDkFALxDrtnZT8f1UxgKoVRALFwnqvAeQVOMk
         QPRi4DwBeRNVbjx3iE3VhffLhWkYrod0flBXkYR6cWoh6vO+ZQgrfCpIzhwe3NsrS0Hn
         a9SJAd30CTIRal+HdqKoDp8fOjTgJa7BW+DyzHFyEm54rQSCgG3rakK9s5tg36XU8MaK
         G6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876796; x=1690481596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNCV/9UyhdagyTy8j9zaAfC1YSEjA868oZWehUYPc18=;
        b=kU+lT5wBROEbTO8sLn7eVUl54/BqshGSnEN7GK2hQbIwBQghpupeLm5u+lyK6QfOtL
         L9ibkRyL09IsykRCZM5txfnXVS61nNaYHx0MVW2qxTU5N6Sx1Rq4/67c5z95HWjEcnAX
         9e6Ocgjw6bFMN4v6Ki1aB5/qIboMvnHhL/+bS/FsTXLlnV07EBSIGusFJG9H8MFU7/ng
         91DWbaDkOdT5Lpu8sgMoG+E0s8+piaSkNZs3P7N+Cgpu8G19I0vDsUhfsvwaxvV8qjQa
         2qdcARSP7mu2e9+9oxhvpBKrvzUT8B1cwH05zzmaQAeTJx4nD5D+IkYUP7v2xiM923IA
         Vmig==
X-Gm-Message-State: ABy/qLY9CuFPNxCAEHkm2jvCjh0X/bRdUz3cYbznLXnMJXs308vPISoA
        K9BE2r9Scjm6oEpPSfrNiSppuQ==
X-Google-Smtp-Source: APBJJlHiaFZvj/wo7rFRRLGQCApphYLMdD8Tr5+ePFq5J9BpVWtfJI92yHXy0swHFT+5VVo5jzsazg==
X-Received: by 2002:a05:6e02:17c8:b0:346:4eb9:9081 with SMTP id z8-20020a056e0217c800b003464eb99081mr12451688ilu.3.1689876795909;
        Thu, 20 Jul 2023 11:13:15 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] iomap: cleanup up iomap_dio_bio_end_io()
Date:   Thu, 20 Jul 2023 12:13:03 -0600
Message-Id: <20230720181310.71589-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720181310.71589-1-axboe@kernel.dk>
References: <20230720181310.71589-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make the logic a bit easier to follow:

1) Add a release_bio out path, as everybody needs to touch that, and
   have our bio ref check jump there if it's non-zero.
2) Add a kiocb local variable.
3) Add comments for each of the three conditions (sync, inline, or
   async workqueue punt).

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 46 +++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ea3b868c8355..0ce60e80c901 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -152,27 +152,43 @@ void iomap_dio_bio_end_io(struct bio *bio)
 {
 	struct iomap_dio *dio = bio->bi_private;
 	bool should_dirty = (dio->flags & IOMAP_DIO_DIRTY);
+	struct kiocb *iocb = dio->iocb;
 
 	if (bio->bi_status)
 		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
+	if (!atomic_dec_and_test(&dio->ref))
+		goto release_bio;
 
-	if (atomic_dec_and_test(&dio->ref)) {
-		if (dio->wait_for_completion) {
-			struct task_struct *waiter = dio->submit.waiter;
-			WRITE_ONCE(dio->submit.waiter, NULL);
-			blk_wake_io_task(waiter);
-		} else if (dio->flags & IOMAP_DIO_WRITE) {
-			struct inode *inode = file_inode(dio->iocb->ki_filp);
-
-			WRITE_ONCE(dio->iocb->private, NULL);
-			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
-			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
-		} else {
-			WRITE_ONCE(dio->iocb->private, NULL);
-			iomap_dio_complete_work(&dio->aio.work);
-		}
+	/*
+	 * Synchronous dio, task itself will handle any completion work
+	 * that needs after IO. All we need to do is wake the task.
+	 */
+	if (dio->wait_for_completion) {
+		struct task_struct *waiter = dio->submit.waiter;
+
+		WRITE_ONCE(dio->submit.waiter, NULL);
+		blk_wake_io_task(waiter);
+		goto release_bio;
+	}
+
+	/* Read completion can always complete inline. */
+	if (!(dio->flags & IOMAP_DIO_WRITE)) {
+		WRITE_ONCE(iocb->private, NULL);
+		iomap_dio_complete_work(&dio->aio.work);
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
+release_bio:
 	if (should_dirty) {
 		bio_check_pages_dirty(bio);
 	} else {
-- 
2.40.1

