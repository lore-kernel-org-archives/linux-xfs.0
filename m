Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A91EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 18:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjGTSNY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 14:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjGTSNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 14:13:22 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B6BFC
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 11:13:22 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-78706966220so10720439f.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 11:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876801; x=1690481601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vkFdmhtuIxCFwZFIvMW05Nk5MCZjzgqa77O2M4w6Fac=;
        b=LWMqSi3R9agDnnB3ZDBuxXuQdEK0985PbGqifHai6o9g9UVb928jR3cHBDidCjDMaZ
         BqCGoAF2Y2UoWZKN5NxTzXGaNwbwxC1s7kxSnuRph+r1Lnf3J9QBbhin+PWEvh4khDSt
         3oGXC6pKOVRASPA69xnSSf18+TlNIJAPnNnnm8RJiUXD8zN+JW8WrHUvwg5UF+sEaNFW
         olStaXqnmEiSKkMWQ7CTlocDD/S7VdufYks0u28+Ltv0X/4CA8ld1UYJr4lKFQNG/1cl
         64RxwYTVaeeoNIhZU4jyGi33OUrD4UcsS8E3k9rIYUz1N3dPex+pNTPh69X82c7+YGO5
         fcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876801; x=1690481601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vkFdmhtuIxCFwZFIvMW05Nk5MCZjzgqa77O2M4w6Fac=;
        b=ZKBGLTjEId5hWuy8qOHJsfGnZr38l8JMaew/LdB7Y9Xz3T3OJk8fwD77IvfofKYhJl
         0Eje0B6cxebc9FaVDhonC0daPzFBLkMrNzRTwruC10uVCe48c9nwFPiAGFkTEPbIiMIe
         +v8GTmlhJiTYZkDy008TGEedFCkS2TmOXhxhNfQl/z6gJGC+uKtc0Tvl9cTixxm13PJQ
         xYkSxlZ67AC0LZopwyTyA/KQgyOUBAkn2IZy0Wm64WpXYI/+XwFzp8dEMT3gme+D44u6
         Pug7ZPCQZDsb9BAJcjAzocnnEZ/xkA8z+ZURMgoUEsU2Y8mcn1g14w9K45qcVD3c5sNp
         sNig==
X-Gm-Message-State: ABy/qLb3PRtFFBHNX6wqyRZX6TFwJ7YoI/Ycp+vQw8t5XuvnOGmZA7lE
        QLm9kAHXZG1YHbLv45zC5+HJFO3zuoR0A/9su0k=
X-Google-Smtp-Source: APBJJlGwgRRJcWW8HC8ms5DLopDsZTENWKAh9pRaFUmDR8PV1ND1TzaaSs4gMEvH4qeTM74lkTmL9g==
X-Received: by 2002:a92:d985:0:b0:345:ad39:ff3 with SMTP id r5-20020a92d985000000b00345ad390ff3mr3407704iln.3.1689876801300;
        Thu, 20 Jul 2023 11:13:21 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] iomap: only set iocb->private for polled bio
Date:   Thu, 20 Jul 2023 12:13:07 -0600
Message-Id: <20230720181310.71589-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720181310.71589-1-axboe@kernel.dk>
References: <20230720181310.71589-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

iocb->private is only used for polled IO, where the completer will
find the bio to poll through that field.

Assign it when we're submitting a polled bio, and get rid of the
dio->poll_bio indirection.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index c3ea1839628f..cce9af019705 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -42,7 +42,6 @@ struct iomap_dio {
 		struct {
 			struct iov_iter		*iter;
 			struct task_struct	*waiter;
-			struct bio		*poll_bio;
 		} submit;
 
 		/* used for aio completion: */
@@ -64,12 +63,14 @@ static struct bio *iomap_dio_alloc_bio(const struct iomap_iter *iter,
 static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 		struct iomap_dio *dio, struct bio *bio, loff_t pos)
 {
+	struct kiocb *iocb = dio->iocb;
+
 	atomic_inc(&dio->ref);
 
 	/* Sync dio can't be polled reliably */
-	if ((dio->iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(dio->iocb)) {
-		bio_set_polled(bio, dio->iocb);
-		dio->submit.poll_bio = bio;
+	if ((iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(iocb)) {
+		bio_set_polled(bio, iocb);
+		WRITE_ONCE(iocb->private, bio);
 	}
 
 	if (dio->dops && dio->dops->submit_io)
@@ -197,7 +198,6 @@ void iomap_dio_bio_end_io(struct bio *bio)
 	 * more IO to be issued to finalise filesystem metadata changes or
 	 * guarantee data integrity.
 	 */
-	WRITE_ONCE(iocb->private, NULL);
 	INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
 	queue_work(file_inode(iocb->ki_filp)->i_sb->s_dio_done_wq,
 			&dio->aio.work);
@@ -536,7 +536,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 	dio->submit.iter = iter;
 	dio->submit.waiter = current;
-	dio->submit.poll_bio = NULL;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iomi.flags |= IOMAP_NOWAIT;
@@ -648,8 +647,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_STABLE_WRITE)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
-	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
-
 	/*
 	 * We are about to drop our additional submission reference, which
 	 * might be the last reference to the dio.  There are three different
-- 
2.40.1

