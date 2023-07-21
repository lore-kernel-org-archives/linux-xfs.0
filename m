Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C8AEB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 16:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbjGUQSh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbjGUQSD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 12:18:03 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06F4210
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:17:01 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-785ccd731a7so26077239f.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956218; x=1690561018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7cLLw1JpMnOMXLNHlH7JagCdHX69bYdsN+9qujHNmA=;
        b=vAUGNAgV1Vbq0eLmgbSiSvCxRWW2+Cw9dLYbFJT3lDY7TdJ5AZFO7HBSWJdLUoNNIA
         XdMVnORN2Hq+gCapIl1iD8L515U+oRRCx5H8wKu4bfBM13MOfjjNqDlTcimtvilsRWFt
         h6RVxA+lgtJl9gnjCNmQqTi/HI3+iOmdW5lnItmg+NDFaLFRT4EUUW/FJ4OuKFHIPZxq
         BrWLIAmRfd+v7rLsQnNBbiVPJWO+xH3VoDmfomiD9AdisfnGxvlMrFhDUHSIPIT5arF/
         m61tR+TRcbo23cOs5c9J4YdLTUd5kw+IKQxzRmndPACj0Rvd0hc1zHVtKOKQ3e4PXYIW
         VOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956218; x=1690561018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7cLLw1JpMnOMXLNHlH7JagCdHX69bYdsN+9qujHNmA=;
        b=VDh6NSJqsKubMpE54KxVprJ6t6oToFpxVrSfRPqH2TPTdnEdZbJ5Aztt9ncg7zouFD
         wpZ6lr83YgTRx9vivEAijszPCzhwqwcssVeKHv172kb55ErN+9fopqoe+vhAykGUfUo1
         6N6Lout92chc90F6gdZ/Dupkr9chWx5nX52fdR6tgd8Qd6moxjARLkTW3xkCEtS00FLc
         kUNSeGJl6MLWryW1bpduNdXJav3lN/9awJ7eP7MSKIpQ7pAExp3imr1XVTN+fiq3u8/x
         kqHuANchYLi4J3yy/4oRgsqLEzatZ+8tXgKORz0W1OGMN97OfdFoJoeiIWP/EHXZrD8S
         UuQQ==
X-Gm-Message-State: ABy/qLbe1i60TTI5G2v7OKCSp0Zhhq6t7xoovu21C4nfDPJgK90mu7Ne
        PlB5X7j9E+U47X+2huoVpWg8Hg==
X-Google-Smtp-Source: APBJJlFG0eKMp+V3bd8Ngr/HkKy7BtsI6srIw0YeAKla/vxNKEZgZUFepNJgNUqes7/7Q1N6HppK3A==
X-Received: by 2002:a05:6602:14d2:b0:783:6ec1:65f6 with SMTP id b18-20020a05660214d200b007836ec165f6mr3086501iow.1.1689956218099;
        Fri, 21 Jul 2023 09:16:58 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:16:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] iomap: add IOMAP_DIO_INLINE_COMP
Date:   Fri, 21 Jul 2023 10:16:43 -0600
Message-Id: <20230721161650.319414-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rather than gate whether or not we need to punt a dio completion to a
workqueue on whether the IO is a write or not, add an explicit flag for
it. For now we treat them the same, reads always set the flags and async
writes do not.

No functional changes in this patch.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 0ce60e80c901..c654612b24e5 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,6 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_INLINE_COMP	(1 << 27)
 #define IOMAP_DIO_WRITE_FUA	(1 << 28)
 #define IOMAP_DIO_NEED_SYNC	(1 << 29)
 #define IOMAP_DIO_WRITE		(1 << 30)
@@ -171,8 +172,10 @@ void iomap_dio_bio_end_io(struct bio *bio)
 		goto release_bio;
 	}
 
-	/* Read completion can always complete inline. */
-	if (!(dio->flags & IOMAP_DIO_WRITE)) {
+	/*
+	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
+	 */
+	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
 		goto release_bio;
@@ -527,6 +530,9 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomi.flags |= IOMAP_NOWAIT;
 
 	if (iov_iter_rw(iter) == READ) {
+		/* reads can always complete inline */
+		dio->flags |= IOMAP_DIO_INLINE_COMP;
+
 		if (iomi.pos >= dio->i_size)
 			goto out_free_dio;
 
-- 
2.40.1

