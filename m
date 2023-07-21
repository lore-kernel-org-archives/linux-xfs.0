Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0887BEB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 16:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjGUQSo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjGUQSR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 12:18:17 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC263C01
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:17:08 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-780c89d1998so28217939f.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956224; x=1690561024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0K7Dvo7paWgjEVh49lf7ANu+PDRkYsLiCLFfzkR8qLs=;
        b=3xPTlZlQRZBxIsm15+JS0gtC8owGRTHiYuFA5FVf+3R59m8jSoVd+Aad9Gju5NSOME
         DFR4N+ny5AJPtBa4DIY+4OMRuFVywbPq07tOgAs7L2SrzWEkXL2MdHebpAEE9lXVp38I
         8Oh3IHvSrtYXz/nLdFZ/ckMt+ASJ1b2JrMo1TvsQR4wKe/CxsXwgj0fTOTfHzaHWnvLG
         W5JoREMNpl6EF3alGMzryTEFVEMNWAs97JFUz/Ws0EsiEmSSOmxHB9JjiGKx3obwltwh
         U425f+oqLCmcnPPMP6oglw35A54wo7zoHa8BciLXc0BVvqbQQO2v3VvN77WNHuOfSDDo
         YHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956224; x=1690561024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0K7Dvo7paWgjEVh49lf7ANu+PDRkYsLiCLFfzkR8qLs=;
        b=Np+rK3UraGTPHzSghRrpEXTXp/s7H5EQDv5Zg2cTh7CCjnwPfZLpqCiQu5ftkazETt
         etxqj3j78pdBAiwa+sn3eAlOpLNenSyEv1eZ1tQGRp+B4K4tf8Tda0JZ2NXFh9/9Lfwv
         toaAbZXa0xflG5h+rWEUg3IUOWKY88SJC/3sOca5RrYa47eaQlduDWub4nbL5F+2sfPs
         Kc8U9uDg11c82jkOq6sj5B1Kv4Z/zc3ni8HmVeKjkYKLFHkfUUWI736OfKDplcbEQQkn
         9xI4uFIh0rcEHefvIY2B/mZWd5sBqjlg9vQZmaGzcrd/fupVlh8o9Fz2yfrjgxo6y0nP
         3k+g==
X-Gm-Message-State: ABy/qLYRShdrE8Bg252b9FqzV/g8RHBaee0kTjJbNE4+/L8tYy6ohCvG
        TQDQd337DWczdAm3mbJ5VNaolw==
X-Google-Smtp-Source: APBJJlGyujB7gg6Xoypqc8Ia7cP1l3+HuYf0PntZvVUWZ8Lc0yUkwdvkmlxtPWqSHyNJb9MxPcbysg==
X-Received: by 2002:a05:6602:480b:b0:780:d6ef:160 with SMTP id ed11-20020a056602480b00b00780d6ef0160mr2532052iob.1.1689956224684;
        Fri, 21 Jul 2023 09:17:04 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:17:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring/rw: add write support for IOCB_DIO_CALLER_COMP
Date:   Fri, 21 Jul 2023 10:16:48 -0600
Message-Id: <20230721161650.319414-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the filesystem dio handler understands IOCB_DIO_CALLER_COMP, we'll
get a kiocb->ki_complete() callback with kiocb->dio_complete set. In
that case, rather than complete the IO directly through task_work, queue
up an intermediate task_work handler that first processes this callback
and then immediately completes the request.

For XFS, this avoids a punt through a workqueue, which is a lot less
efficient and adds latency to lower queue depth (or sync) O_DIRECT
writes.

Only do this for non-polled IO, as polled IO doesn't need this kind
of deferral as it always completes within the task itself. This then
avoids a check for deferral in the polled IO completion handler.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1bce2208b65c..f19f65b3f0ee 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -105,6 +105,7 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	} else {
 		rw->kiocb.ki_ioprio = get_current_ioprio();
 	}
+	rw->kiocb.dio_complete = NULL;
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
@@ -285,6 +286,14 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 
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
@@ -300,9 +309,11 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
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
@@ -916,6 +927,15 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	kiocb->ki_flags |= IOCB_WRITE;
 
+	/*
+	 * For non-polled IO, set IOCB_DIO_CALLER_COMP, stating that our handler
+	 * groks deferring the completion to task context. This isn't
+	 * necessary and useful for polled IO as that can always complete
+	 * directly.
+	 */
+	if (!(kiocb->ki_flags & IOCB_HIPRI))
+		kiocb->ki_flags |= IOCB_DIO_CALLER_COMP;
+
 	if (likely(req->file->f_op->write_iter))
 		ret2 = call_write_iter(req->file, kiocb, &s->iter);
 	else if (req->file->f_op->write)
-- 
2.40.1

