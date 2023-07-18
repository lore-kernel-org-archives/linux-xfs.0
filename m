Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE46C001DE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jul 2023 19:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjGRTtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 15:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjGRTta (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 15:49:30 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5649D
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 12:49:29 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so68142339f.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 12:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689709769; x=1690314569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd5q4QGxS59bSAw+JDmQ90OVbkUJjAQIgvePrWiPffo=;
        b=pa9ml1Yq+mAUfVkTfAFqTdCTO//R/u8eINJuCUIgrPVylkBY2W2xIpTcVPIW4wAQZf
         wqQFKiXHH8mP6ilgsivhhV1sWq122AQhtfGjO8MW+NSM5Dwd9p1fBg9a7rdPecEAkfHa
         QICn2OplSCK/D8EaM75WZI9NYgCaaToa4yyUa0Qh9GUAIKeFd+tT4cIDiab8bk9WwbQH
         AtrnWPUMu6V+8nu6IzcUgBZjG5hnFdcK/OLUc50hem5+u1mAli/VHa1JDv6OWho/WzqS
         kuzawnY63NYtXJ7GAJLijCJNUjLdnc8gvaAr3bcKW0SuVfXCBPS0Hj2i2qUPgGJloePR
         l4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689709769; x=1690314569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd5q4QGxS59bSAw+JDmQ90OVbkUJjAQIgvePrWiPffo=;
        b=dsy/1T7QnmYYsbqCO0fIsvPq7SdKqClZSZzjyPBJ9vlWrNzd5HNu00RjzNyM8jCxEM
         m7iBGUGqV+uCjZp3pZefTq6qdwbo/lanWp8gx2+qcEUui1OTg4DhTE9lNcpMLxvQeYqo
         lNIzILaAEy8CXnHWMvcRDYDY7/B77FF4hZnrqsl2of/yLOgyfGMkaH75X8B3dBLC1Wno
         lVC3H9HBvkJO1V557lzHazAqfEE65gnu/5sUL6FRol4N7kth9UCk5IvKkZp2/7PaAJaY
         18GSO5DOMspDAbDTsHsOxwRA9Soozm3s+vctzv+6PlrVfHuzgLlghRZvQ6emq2UAZSio
         WnrA==
X-Gm-Message-State: ABy/qLZeb+fvfrSk9Fifexm3mt9DEU91OyeZtgCpxxnSySA6jP0bd5kd
        ljUFJivyrjx99CFBOrDuRWM6bg==
X-Google-Smtp-Source: APBJJlHlgVHXiTYXQZrmik3S+TX69txqAaXEnmAvcKDroC538cvy7f4ZwipVFMwfo9UCpMhMF1ZU3w==
X-Received: by 2002:a05:6e02:3486:b0:33b:d741:5888 with SMTP id bp6-20020a056e02348600b0033bd7415888mr2794446ilb.0.1689709769146;
        Tue, 18 Jul 2023 12:49:29 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v18-20020a92d252000000b00345e3a04f2dsm897463ilg.62.2023.07.18.12.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 12:49:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring/rw: add write support for IOCB_DIO_DEFER
Date:   Tue, 18 Jul 2023 13:49:18 -0600
Message-Id: <20230718194920.1472184-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230718194920.1472184-1-axboe@kernel.dk>
References: <20230718194920.1472184-1-axboe@kernel.dk>
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

