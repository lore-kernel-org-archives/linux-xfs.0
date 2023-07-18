Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1164C04A6A
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jul 2023 19:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjGRTtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 15:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjGRTtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 15:49:32 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97961996
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 12:49:30 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-760dff4b701so56223939f.0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 12:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689709770; x=1692301770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J26GveNzN3vnRUoz11F2mi8E7fquCj+ZYxoQryvAmE8=;
        b=xphtAXKMDXOJ9QPgbjRMoJ+8ODPEqI+DnKqdVe8DCR3COUUW8MjAAwVvGxjLWeCoa2
         pMkpL0qvCf5xvTBsGH7ViXZH8KXqenPdhjWrFoFW+yK9n0O7LHaU+9LqJVPh/K2+fCTe
         VlRE/2kWeqAeOiMViILQ0yLnhQHSrH/XQ7GcEbZywSnJHXnJHgmkBvf2j9IExlz0hvNO
         iGY2Phm95CLvi1cvPOMS9WyUrzP7j33UqfKeG+Rv3XG08x3jES/37z72+FPSAV06Tlev
         kemJ9x43fWNSJkszHF2PsyIuqg2bM1uy6GbrTUEfxBdFXEYxq0HPjr//l6EtsO4tX/MM
         ECUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689709770; x=1692301770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J26GveNzN3vnRUoz11F2mi8E7fquCj+ZYxoQryvAmE8=;
        b=jc9xz9LzId+h38jdSkrvQxcUuuVMKYiNya9zk3Lwxrc5q1rwyxg0il98Q4ztPogJvd
         X3NLMcRb0bADpp/S65ExqKbSvJMHwh1b5gYUFvvNNmpQhvvbfLxNM6sannKzdtB9+uxY
         W3DNUyZtewrIV7NSsdvpNQO2KNWUBrulBOxpjjMgVwlUpq43NI6N8Pm3yX0Ze1IucIY1
         aWSn3NPdVN/IQ25N5ozSypwAj0vX3qAjsMFLMdJ65CmvxmCUArsPmpsR+Faa8lt5soLQ
         wI1dJAxVZtcN934M/b0kw1iy06wALc59BQsd01JvRAgQMzKUnS10Kh1o8jEDOEqPho9r
         AWkw==
X-Gm-Message-State: ABy/qLbHNVBnoD4CGl6NAxOaLi7bnNZS4norMZr7zYWtvaD5SruY9lDA
        M3k1uRgscEup+S+bnVBtLCqTEA==
X-Google-Smtp-Source: APBJJlH/cHKNq5jol565/7foeVIkNajJ8mIGx1SHa+z5r1S2bOcQL8NEsSxra8I5OMxlP9onhHXTPw==
X-Received: by 2002:a05:6e02:220f:b0:345:db9a:be2c with SMTP id j15-20020a056e02220f00b00345db9abe2cmr2320311ilf.1.1689709770277;
        Tue, 18 Jul 2023 12:49:30 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v18-20020a92d252000000b00345e3a04f2dsm897463ilg.62.2023.07.18.12.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 12:49:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] iomap: add local 'iocb' variable in iomap_dio_bio_end_io()
Date:   Tue, 18 Jul 2023 13:49:19 -0600
Message-Id: <20230718194920.1472184-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230718194920.1472184-1-axboe@kernel.dk>
References: <20230718194920.1472184-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We use this multiple times, add a local variable for the kiocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 6fa77094cf0a..92b9b9db8b67 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -158,6 +158,8 @@ void iomap_dio_bio_end_io(struct bio *bio)
 		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
 
 	if (atomic_dec_and_test(&dio->ref)) {
+		struct kiocb *iocb = dio->iocb;
+
 		if (dio->wait_for_completion) {
 			struct task_struct *waiter = dio->submit.waiter;
 			WRITE_ONCE(dio->submit.waiter, NULL);
@@ -166,9 +168,9 @@ void iomap_dio_bio_end_io(struct bio *bio)
 			WRITE_ONCE(dio->iocb->private, NULL);
 			iomap_dio_complete_work(&dio->aio.work);
 		} else {
-			struct inode *inode = file_inode(dio->iocb->ki_filp);
+			struct inode *inode = file_inode(iocb->ki_filp);
 
-			WRITE_ONCE(dio->iocb->private, NULL);
+			WRITE_ONCE(iocb->private, NULL);
 			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
 			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
 		}
-- 
2.40.1

