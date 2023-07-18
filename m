Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7D1C001E0
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jul 2023 19:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjGRTte (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 15:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjGRTtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 15:49:32 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113AA1992
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 12:49:32 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-3461b58c61dso4581495ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 12:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689709771; x=1692301771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+YBW1O6wOlnw08waq30NjAYKZFIoa5A4vGc80qqVFGc=;
        b=GSdt6Ah3rHE8YNoauY7LLPUL8FiJawaIiq+SLiH4Wkn8Gxd0GLBAYeylxBPXTqCTea
         kHN5lKexjSMXrM/4ulTNiN2xmotCRgQnqvGv9sCHYdHqnXNU7f1NorFPas7HYrQFQQWF
         G3u0twbEdsCYSRHWXs8nCrasdpsLXD3YAK/O0i+Iia0J51TXmr3bLMnfkefPITuc6zm2
         5E+e6M92SQ2uVAObgn5sDsTCqfsRu3jjpR2kGWqOa8NG3ZaRqY6fysR8p5Hv99+A0+fK
         ZyWmoaUE6m2yqWywkRHz49+i0F9SXUo7ZLCY4/t5KCzhIuF6FaJK8gijQ8aORAvOj298
         BWjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689709771; x=1692301771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+YBW1O6wOlnw08waq30NjAYKZFIoa5A4vGc80qqVFGc=;
        b=cwX0u7JRWf9hfQb/Q44vMJmj8g/5v8hG/n0CJyyTMVyLSKe8/fY24nHzcdYcJ69rBE
         Hbul5i4ocU/5pc5ylVnEJghPXHrmgSku1Ks2MOzn5XTPzaW+mdATPbCnCEUchDgEe6D7
         JVTXfV2fABlqguFcLdQiUzPW7NNeY2DY+fK33zygM1L3NAQCcdYvk9GMwj5UlFVc7oy/
         dJ/44YI+VW4beIE1/sTZFQsDa5G20d//+Y6wKZYRhXT62hlTdsrkhWWzh2+V23M5hu2B
         csM9K2aYhqkQBDVRFxHilLdBXMcvqy/dbbg2MgH3pgsAJiTLloGb6TmulNGSV/nB2abV
         W+5A==
X-Gm-Message-State: ABy/qLY6m1gCqUyj+AMEXdl6GXfvvW38HR5FZeRBxNBBe9d/C87X+Cip
        /Whqnqx1LGhpU1uVuPNdZN9vog==
X-Google-Smtp-Source: APBJJlH+8HQ3QJoBxiniGs8gIcDARbfvEgB+1gNWxaOUejcULV5e/+COOkPQ+6HqfD/KfitJVVg/Eg==
X-Received: by 2002:a92:7011:0:b0:346:3173:2374 with SMTP id l17-20020a927011000000b0034631732374mr2415279ilc.0.1689709771409;
        Tue, 18 Jul 2023 12:49:31 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v18-20020a92d252000000b00345e3a04f2dsm897463ilg.62.2023.07.18.12.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 12:49:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] iomap: support IOCB_DIO_DEFER
Date:   Tue, 18 Jul 2023 13:49:20 -0600
Message-Id: <20230718194920.1472184-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230718194920.1472184-1-axboe@kernel.dk>
References: <20230718194920.1472184-1-axboe@kernel.dk>
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
--cpus_allowed=4 --ioengine=io_uring --iodepth=16

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
 fs/iomap/direct-io.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 92b9b9db8b67..ed615177e1f6 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -131,6 +131,11 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
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
@@ -167,6 +172,25 @@ void iomap_dio_bio_end_io(struct bio *bio)
 		} else if ((dio->flags & IOMAP_DIO_INLINE_COMP) && in_task()) {
 			WRITE_ONCE(dio->iocb->private, NULL);
 			iomap_dio_complete_work(&dio->aio.work);
+		} else if ((dio->flags & IOMAP_DIO_INLINE_COMP) &&
+			   (iocb->ki_flags & IOCB_DIO_DEFER)) {
+			/* only polled IO cares about private cleared */
+			iocb->private = dio;
+			iocb->dio_complete = iomap_dio_deferred_complete;
+			/*
+			 * Invoke ->ki_complete() directly. We've assigned
+			 * out dio_complete callback handler, and since the
+			 * issuer set IOCB_DIO_DEFER, we know their
+			 * ki_complete handler will notice ->dio_complete
+			 * being set and will defer calling that handler
+			 * until it can be done from a safe task context.
+			 *
+			 * Note that the 'res' being passed in here is
+			 * not important for this case. The actual completion
+			 * value of the request will be gotten from dio_complete
+			 * when that is run by the issuer.
+			 */
+			iocb->ki_complete(iocb, 0);
 		} else {
 			struct inode *inode = file_inode(iocb->ki_filp);
 
-- 
2.40.1

