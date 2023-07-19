Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B929C001DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 19:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjGSTyc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjGSTyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 15:54:31 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EAE1FD6
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 12:54:30 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-346434c7793so171425ab.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 12:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689796469; x=1692388469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmSjJDLDmeliZeLZZd2Btg4MO1D55XByrYaapFM2zhA=;
        b=pAxJhc8Zrqww3ifH7tblUbxcnSaGGpK6Flzmom88IdoU4B6DS38U4aSmjG/hCStwDs
         8OK8brESywMi2HMvjpegdMgf10LhDAqY2LRx0uHjG/27of6Atj7tKZGn3AzL44Lkw8eC
         Ny2RPnGhyIrh3ibS3g83vWFAV2Qv9II94vA6KErvtFudclA6oKOX8lsU/YyVRQt1QaSo
         g782Au/0mIUGTbLxLX9a1aIPqqUw4ipXxkJtfFXRWMEplopn9AiQv/mXoJEVzKE3PfoY
         g4qWlKXYkjZQRKAVbSEAWGDgbgejPhZJRX629AGt7H8yaxM54EIiaYl8QjsSwBpgIyBx
         jXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689796469; x=1692388469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YmSjJDLDmeliZeLZZd2Btg4MO1D55XByrYaapFM2zhA=;
        b=LjI6zgUWvKE/ARipBA9tMsKBTidXwXAjREav4xGFV4zfInI4FV+ffz1y7EJE1J0L4U
         rb2+tP3rI67Gi/BefTiQMbNiY2bZtZDNlikvA/F14Vqg0ddbJ9t7U7hgio2RyLz+oLFw
         w/rrr2CX3P1xIsOcq2ggmM57bRaKUSmoxlmT6WLvjl5zl3mVH4eCdkMQFw/OO4QEWAbx
         8RYSEIQvYrszEIuYmIQnUiyDRarS0F/gabL4c3GZLZaLHl2wmJNYB+OhnYCiz1dFdBR6
         xS/Rsldv/8JRptFFyD3sIIOCskKD0LYahnbZtBNOkiWQAL4dOgELndVVHnjDSAY/DGKv
         TqYg==
X-Gm-Message-State: ABy/qLbitAXL3Es8Yy0LJPMZ0ADsYpGuRearjN1LoI1FPzZ2Xh68eAcI
        ZJ7uh2VwmAolFmtW1LU6c+Pfig==
X-Google-Smtp-Source: APBJJlG5AcxR0HUDfbb2X91dM4A8cbc003r5OK2/TGl957f1MPdCIviBNGBxD1RJ5yYp6sohizmfUg==
X-Received: by 2002:a05:6602:3710:b0:788:2d78:813c with SMTP id bh16-20020a056602371000b007882d78813cmr498953iob.0.1689796469594;
        Wed, 19 Jul 2023 12:54:29 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j21-20020a02a695000000b0042bb13cb80fsm1471893jam.120.2023.07.19.12.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 12:54:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring/rw: add write support for IOCB_DIO_DEFER
Date:   Wed, 19 Jul 2023 13:54:16 -0600
Message-Id: <20230719195417.1704513-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719195417.1704513-1-axboe@kernel.dk>
References: <20230719195417.1704513-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the filesystem dio handler understands IOCB_DIO_DEFER, we'll get
a kiocb->ki_complete() callback with kiocb->dio_complete set. In that
case, rather than complete the IO directly through task_work, queue
up an intermediate task_work handler that first processes this
callback and then immediately completes the request.

For XFS, this avoids a punt through a workqueue, which is a lot less
efficient and adds latency to lower queue depth (or sync) O_DIRECT
writes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1bce2208b65c..4657e11acf02 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -285,6 +285,14 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 
 void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	if (rw->kiocb.dio_complete) {
+		long res = rw->kiocb.dio_complete(rw->kiocb.private);
+
+		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	}
+
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
@@ -300,9 +308,11 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
-	if (__io_complete_rw_common(req, res))
-		return;
-	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	if (!rw->kiocb.dio_complete) {
+		if (__io_complete_rw_common(req, res))
+			return;
+		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	}
 	req->io_task_work.func = io_req_rw_complete;
 	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
 }
@@ -312,6 +322,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
+	if (rw->kiocb.dio_complete)
+		res = rw->kiocb.dio_complete(rw->kiocb.private);
+
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 	if (unlikely(res != req->cqe.res)) {
@@ -914,7 +927,13 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		__sb_writers_release(file_inode(req->file)->i_sb,
 					SB_FREEZE_WRITE);
 	}
-	kiocb->ki_flags |= IOCB_WRITE;
+
+	/*
+	 * Set IOCB_DIO_DEFER, stating that our handler groks deferring the
+	 * completion to task context.
+	 */
+	kiocb->ki_flags |= IOCB_WRITE | IOCB_DIO_DEFER;
+	kiocb->dio_complete = NULL;
 
 	if (likely(req->file->f_op->write_iter))
 		ret2 = call_write_iter(req->file, kiocb, &s->iter);
-- 
2.40.1

