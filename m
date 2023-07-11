Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59220C04A94
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 20:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjGKUdi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjGKUdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 16:33:37 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D80F195
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 13:33:36 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-66d6a9851f3so979259b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 13:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689107616; x=1691699616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4lQMN8Le/C1jdSB9yTI2JvyEXlu5Hktu+P+yNzyi4U=;
        b=mrcVeQl9YidPXEIu0qrh18WlOJZDdWABWgO6kgrZ0XmOagDqRVENP+qucVgSkt0anB
         +pzV8VXABn00CAVK3nnZMcHXaOdjUl2w7xmMgqnmWkndLe0qc6+gSZCODFghShrs5bRf
         36qWmIuSDuFGFtg89nYValQI+DF8vXfGPo4qgnSocLzbH1rDTipwGSA/KIVd5yiL3jDh
         BwJioibL7LoWa761AFiHPra/rVJLfaiZ0Ji4vvd4xLWe7gEVofVPknUDeExtPHttAoPg
         EubpbxwUozHnSrcrOowG8jDm2DWhVo6O2YK5O4KEuvCaAKvOlbrQV/HKlzNoHPz73RgN
         b+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689107616; x=1691699616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K4lQMN8Le/C1jdSB9yTI2JvyEXlu5Hktu+P+yNzyi4U=;
        b=lCqNmg+fr3CjvSGdH85EVzfdwzh8VPWvzgp4Td5nUFTCO9ntQiFrzh+KbKoS26ifIi
         nAHlnVfmbWiDIswR6MfVAGfy6s4AH62T4f2BfUuEar+Opxiw2r1I6GeGP2c7kPJ31phv
         leuFILuo4p1Yl87M8h1KKwfVAUa4J9Ysdc8oaRcgaav/KPFE4Drc/FKIxNg4iLFjozTX
         Q1tDQU3L6nXdzbIjjMv9t04/hj09lLha3moMC8jeUbpNIivj4KTA8pu/o8ZudrLF6CRC
         Iaps+BdEJ3+gsoh+MjedYbqeW/SCPN47pEMoDsCZPEqhlVKVLlKhhcxqdkvA1GP2J8cw
         RADQ==
X-Gm-Message-State: ABy/qLa8qGJNPVuGlzjbhW5GgZnfY33hfoZDgL4LUeSh/wmAOY+XdR+d
        8/0Sm3GWPXeelPUxoEy/4jcM/w==
X-Google-Smtp-Source: APBJJlHGZD2pToOKcRdBqvrpeDqGNCC7/KU1/F7yZ4nORGQegCZgWoU5k+zvAQYTDatQpmPxq6XajQ==
X-Received: by 2002:a05:6a20:8e2a:b0:130:9af7:bf1 with SMTP id y42-20020a056a208e2a00b001309af70bf1mr16939638pzj.6.1689107616082;
        Tue, 11 Jul 2023 13:33:36 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fk13-20020a056a003a8d00b0067903510abbsm2108081pfb.163.2023.07.11.13.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:33:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] iomap: add local 'iocb' variable in iomap_dio_bio_end_io()
Date:   Tue, 11 Jul 2023 14:33:24 -0600
Message-Id: <20230711203325.208957-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230711203325.208957-1-axboe@kernel.dk>
References: <20230711203325.208957-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We use this multiple times, add a local variable for the kiocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 343bde5d50d3..94ef78b25b76 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -157,18 +157,20 @@ void iomap_dio_bio_end_io(struct bio *bio)
 		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
 
 	if (atomic_dec_and_test(&dio->ref)) {
+		struct kiocb *iocb = dio->iocb;
+
 		if (dio->wait_for_completion) {
 			struct task_struct *waiter = dio->submit.waiter;
 			WRITE_ONCE(dio->submit.waiter, NULL);
 			blk_wake_io_task(waiter);
 		} else if ((bio->bi_opf & REQ_POLLED) ||
 			   !(dio->flags & IOMAP_DIO_WRITE)) {
-			WRITE_ONCE(dio->iocb->private, NULL);
+			WRITE_ONCE(iocb->private, NULL);
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

