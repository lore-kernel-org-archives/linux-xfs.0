Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5ACC001E0
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 19:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjGSTyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjGSTyd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 15:54:33 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AFDA7
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 12:54:31 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-785ccd731a7so30839f.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 12:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689796471; x=1690401271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kTvYQlDOhP6EOVmXA2umB2ZKrh0BWM6v9ydQBvMCtEo=;
        b=bntvLtM93TfxHDv1res/Le2NnqIAI2hPK1vOgQO+ZboYSOMGk0AyDqi0tcI2iSWnP2
         kBPZ2hoO6+JtUocaEoPTyx+AnaVilw9JCpUvrbfOISFu8KlGjVmsTul36huDeAfZFZom
         famDHX0bTR7bVniAyiKg1W1WvspZAHb9qmUv5yZ40X+abb0PeHmq7e/9tRRPBZwXJzSF
         LX/bCOiBKfF7z0Og5QDpXU5O+x4rltwbjzmkW9YYP0nZISYPG2ZRZQWdKEDHgHFwV8lA
         cITkp69rHLOflHD7M2nh/eraJ8QIJhB9FK8g6SRJ2PIyDH4CPvm+UjZbjZi0UCHoDGfE
         yhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689796471; x=1690401271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kTvYQlDOhP6EOVmXA2umB2ZKrh0BWM6v9ydQBvMCtEo=;
        b=TAtCXRapIKi2yF9rvi08VXk7WGmZudIDVCq3XB4JjW0esiEufUdPEfq5L3YEODbolV
         o1/rY4U+X/W5myNPVjqxDyCMh3We/ACc/JethoGRj1muwi2G7WedGKe736a7KBsf+jRQ
         7yqWz0TxU15Hi/uLvUj/UVzsCi1U/5YMldjrL8Z12VVXjh+3DQF8XBJrYXQ0bXzMU/7t
         m4Of8kNkm+N3l4RRGUM2GxUbctoEsEK/nSeLkV1L6WzEqoUnzFzkrJUfiB5jLTSBB2Bz
         ++H4MB4C7wz+mGpPmEwSWHEPFRaL7B6A72Xdz+8/7YmTSQLg0++sSDvJuQ5AUJ5NGdMw
         AA4A==
X-Gm-Message-State: ABy/qLaHR0c7Nkgr8bkFBNK1+BcECDbRsKhOZopRZZDMz3MLe/I40WHu
        312tbtxA0HtLR0HWwcYzTlrEmA==
X-Google-Smtp-Source: APBJJlFnEcVMxJ5LOd6PR/a75IhjhuRWzWbS5J5uUVT/bik2+nthisdHTN19bYSQbo/z7VRMMUf64Q==
X-Received: by 2002:a05:6602:3423:b0:780:d65c:d78f with SMTP id n35-20020a056602342300b00780d65cd78fmr586047ioz.2.1689796471049;
        Wed, 19 Jul 2023 12:54:31 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j21-20020a02a695000000b0042bb13cb80fsm1471893jam.120.2023.07.19.12.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 12:54:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] iomap: support IOCB_DIO_DEFER
Date:   Wed, 19 Jul 2023 13:54:17 -0600
Message-Id: <20230719195417.1704513-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719195417.1704513-1-axboe@kernel.dk>
References: <20230719195417.1704513-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If IOCB_DIO_DEFER is set, utilize that to set kiocb->dio_complete handler
and data for that callback. Rather than punt the completion to a
workqueue, we pass back the handler and data to the issuer and will get a
callback from a safe task context.

Using the following fio job to randomly dio write 4k blocks at
queue depths of 1..16:

fio --name=dio-write --filename=/data1/file --time_based=1 \
--runtime=10 --bs=4096 --rw=randwrite --norandommap --buffered=0 \
--cpus_allowed=4 --ioengine=io_uring --iodepth=$depth

shows the following results before and after this patch:

	Stock	Patched		Diff
=======================================
QD1	155K	162K		+ 4.5%
QD2	290K	313K		+ 7.9%
QD4	533K	597K		+12.0%
QD8	604K	827K		+36.9%
QD16	615K	845K		+37.4%

which shows nice wins all around. If we factored in per-IOP efficiency,
the wins look even nicer. This becomes apparent as queue depth rises,
as the offloaded workqueue completions runs out of steam.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 47 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b30c3edf2ef3..b7055d50dd99 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,6 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_DEFER_COMP	(1 << 26)
 #define IOMAP_DIO_INLINE_COMP	(1 << 27)
 #define IOMAP_DIO_WRITE_FUA	(1 << 28)
 #define IOMAP_DIO_NEED_SYNC	(1 << 29)
@@ -131,6 +132,11 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 }
 EXPORT_SYMBOL_GPL(iomap_dio_complete);
 
+static ssize_t iomap_dio_deferred_complete(void *data)
+{
+	return iomap_dio_complete(data);
+}
+
 static void iomap_dio_complete_work(struct work_struct *work)
 {
 	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
@@ -180,6 +186,31 @@ void iomap_dio_bio_end_io(struct bio *bio)
 		goto release_bio;
 	}
 
+	/*
+	 * If this dio is flagged with IOMAP_DIO_DEFER_COMP, then schedule
+	 * our completion that way to avoid an async punt to a workqueue.
+	 */
+	if (dio->flags & IOMAP_DIO_DEFER_COMP) {
+		/* only polled IO cares about private cleared */
+		iocb->private = dio;
+		iocb->dio_complete = iomap_dio_deferred_complete;
+
+		/*
+		 * Invoke ->ki_complete() directly. We've assigned out
+		 * dio_complete callback handler, and since the issuer set
+		 * IOCB_DIO_DEFER, we know their ki_complete handler will
+		 * notice ->dio_complete being set and will defer calling that
+		 * handler until it can be done from a safe task context.
+		 *
+		 * Note that the 'res' being passed in here is not important
+		 * for this case. The actual completion value of the request
+		 * will be gotten from dio_complete when that is run by the
+		 * issuer.
+		 */
+		iocb->ki_complete(iocb, 0);
+		goto release_bio;
+	}
+
 	/*
 	 * Async DIO completion that requires filesystem level completion work
 	 * gets punted to a work queue to complete as the operation may require
@@ -277,12 +308,15 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		 * data IO that doesn't require any metadata updates (including
 		 * after IO completion such as unwritten extent conversion) and
 		 * the underlying device supports FUA. This allows us to avoid
-		 * cache flushes on IO completion.
+		 * cache flushes on IO completion. If we can't use FUA and
+		 * need to sync, disable in-task completions.
 		 */
 		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
 		    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
 		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
 			use_fua = true;
+		else if (dio->flags & IOMAP_DIO_NEED_SYNC)
+			dio->flags &= ~IOMAP_DIO_DEFER_COMP;
 	}
 
 	/*
@@ -308,6 +342,8 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		pad = pos & (fs_block_size - 1);
 		if (pad)
 			iomap_dio_zero(iter, dio, pos - pad, pad);
+
+		dio->flags &= ~IOMAP_DIO_DEFER_COMP;
 	}
 
 	/*
@@ -547,6 +583,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomi.flags |= IOMAP_WRITE;
 		dio->flags |= IOMAP_DIO_WRITE;
 
+		/*
+		 * Flag as supporting deferred completions, if the issuer
+		 * groks it. This can avoid a workqueue punt for writes.
+		 * We may later clear this flag if we need to do other IO
+		 * as part of this IO completion.
+		 */
+		if (iocb->ki_flags & IOCB_DIO_DEFER)
+			dio->flags |= IOMAP_DIO_DEFER_COMP;
+
 		if (dio_flags & IOMAP_DIO_OVERWRITE_ONLY) {
 			ret = -EAGAIN;
 			if (iomi.pos >= dio->i_size ||
-- 
2.40.1

