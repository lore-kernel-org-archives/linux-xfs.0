Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6265C001E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 20:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjGKUdh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjGKUdg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 16:33:36 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565E9170C
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 13:33:35 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-676cc97ca74so1390664b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 13:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689107615; x=1689712415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd5q4QGxS59bSAw+JDmQ90OVbkUJjAQIgvePrWiPffo=;
        b=GDFBVXHrRbHPsPVU4DCmRN6oNIWp52f4jpnmeWVWuO5m92w0TVuR59FJTTN+ga1vtS
         CDq7NW98kbb95PEhjGTPtMyAZ00nxb4mMve2wzye7sZ2Rgos0LiFLINEeUtipY7/lT3C
         zxQJbjNL29IIqWIaMbK/uCju3tUA3gmNKiaaQABjaNlVJO/0oCvZA3bDCqBk8h+J9iTC
         8w2MnI3/l08WbdKv5OTadqfBMma7qlYKK+n7F5Yzrs/rLEOPJPjW/ZMJngZ8uS64+h6m
         9Zv8jBnVRjjg6+bDrfwAd5q4S7p/RFoLs2h4rymbI22cMnbzzvS/A+hx4fdBQ/1hm/1r
         Uy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689107615; x=1689712415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd5q4QGxS59bSAw+JDmQ90OVbkUJjAQIgvePrWiPffo=;
        b=Df63tXEXpWjNMBQ4vB8zk6rpjNG1LhfdwRujsuDmJtincXmMRKZtkooukWg55/63sZ
         q5JKBHOUxGm2S1t1Mfw3vuDwwRYJZFCydGuHptCaC2L1cMRcKr7Pu0F/PxEW88AOsK0M
         Xcl6jSDy5HpAUPfetHgabtWfP/UHcHeTKpGl/jrwmLvkXA8i9C1CvzoFjKbiRwjCtD4x
         ShOBaF/XRcTHtFrvl/8nhmBPv3gGt1hJM5RrlGZWeDglZ8Pw2hWBKPSE2y2dEuV7IRHe
         xX4XAGGPNvnvYoa6yKkA33QnzdeqlQHYHjPey/grVIEpE5n/S8F/1VCU+Mlli0h+vnD0
         UDVQ==
X-Gm-Message-State: ABy/qLaP6vY5aEvusbqXC3F+ttEgSsuipneSSzzrCpv+x4u6NZiRbw6Z
        Kkq/WBm2w2NorQi85yhyf2iuo+Vt29mdoSn3x28=
X-Google-Smtp-Source: APBJJlHh4R8H8y0q7l/+iJSpHFtPMwjZxdkfJxKb3+C34QPTz5vRIWajkTtepebKwCc5RmqimcURtw==
X-Received: by 2002:a05:6a20:7da6:b0:12f:dce2:b381 with SMTP id v38-20020a056a207da600b0012fdce2b381mr20396148pzj.3.1689107614789;
        Tue, 11 Jul 2023 13:33:34 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fk13-20020a056a003a8d00b0067903510abbsm2108081pfb.163.2023.07.11.13.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:33:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring/rw: add write support for IOCB_DIO_DEFER
Date:   Tue, 11 Jul 2023 14:33:23 -0600
Message-Id: <20230711203325.208957-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230711203325.208957-1-axboe@kernel.dk>
References: <20230711203325.208957-1-axboe@kernel.dk>
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
 io_uring/rw.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1bce2208b65c..4ed378c70249 100644
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
@@ -914,7 +924,13 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
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

