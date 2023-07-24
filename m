Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC578C04FE1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 22:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjGXWzX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 18:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjGXWzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 18:55:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213FE10E6
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 15:55:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bba9539a23so1825925ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 15:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239320; x=1690844120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UkiYXAkH9GVD15ideYRW3eg5TFVpCBJh44wXJ9Qv8IA=;
        b=uMRNz4lYhIHghddKBkDuUHf0sS4xU5ctdO8KePyUfVQHcgs3wI++XVI2MyZ3fcz0ok
         GO8j6DrkoPJy8E0LBMD7NWiH5Be6+/grUqqthwMNBx1iyWW1q8g4L0oNULyvp8E20asX
         fnjUCaUqLN+ivFtIinQDYENNz/pQdPdufuuL3FOBlCJ65cWpI/QGU6W1Hq5ZJhBWBUk+
         zapQYXyROrczWGS/MU/lvkk6Zdz2i5SjWZkMiR/WTQsI9izC2DULRCFQDweG4xDZEJVX
         1ePCWR59SPbppPg9TK3asjiY1soPE7RXVMjq17RyT1H5R5LMNcOND1gb6potLHvmTkll
         5NuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239320; x=1690844120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UkiYXAkH9GVD15ideYRW3eg5TFVpCBJh44wXJ9Qv8IA=;
        b=OWKufJ7dUcEBmWeelIM1uzsHtJAa8bQjVz/bXVydues+DdVxcNrLznDKBtH0L4CNUb
         n+aCPEf7BOLEdi0jiQZphJTn8uOiI1vnR2FdKmvf7feLaxQ1I9XwUFZVOmMJQkGGTaDz
         f1sMJ6Dj6SNL6MzA2PaSfGYrk99EYeD0Gy9Rriwy+QgIgSq0qZAevINtM2vcDw6M9Csx
         CsR+sU1HIAA0j+jRzir3lejdVTAs+p1esfb6Fkdub0tWxqLzLnsp/xzgt1+Mtb8GLeD0
         V/lyh/k6BRk+sAKWsR7xxhG9EHAAd5H2pwMvJnEO72OIAz58kSIAVpIbJlVJnlKcC43q
         mBaw==
X-Gm-Message-State: ABy/qLa8jCOriTkefdab4dm/Nz0KyRc7PGuYMlZoVMo0GFtvdd35FK8j
        nPNyM6GDNiE0ymp4YsVWh5pjwQ==
X-Google-Smtp-Source: APBJJlE75QLPlazs431saOk4q704bVzGQ9hXd/HdIVqUe6ICO+GIg7JpBbH53tBMy7aw60lbIeereg==
X-Received: by 2002:a17:903:2305:b0:1b8:b0c4:2e3d with SMTP id d5-20020a170903230500b001b8b0c42e3dmr14474787plh.4.1690239320604;
        Mon, 24 Jul 2023 15:55:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] iomap: add IOMAP_DIO_INLINE_COMP
Date:   Mon, 24 Jul 2023 16:55:08 -0600
Message-Id: <20230724225511.599870-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
References: <20230724225511.599870-1-axboe@kernel.dk>
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
index e4b9d9123b75..b943bc5c7b18 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,6 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_INLINE_COMP	(1U << 27)
 #define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
 #define IOMAP_DIO_NEED_SYNC	(1U << 29)
 #define IOMAP_DIO_WRITE		(1U << 30)
@@ -172,8 +173,10 @@ void iomap_dio_bio_end_io(struct bio *bio)
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
@@ -528,6 +531,9 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomi.flags |= IOMAP_NOWAIT;
 
 	if (iov_iter_rw(iter) == READ) {
+		/* reads can always complete inline */
+		dio->flags |= IOMAP_DIO_INLINE_COMP;
+
 		if (iomi.pos >= dio->i_size)
 			goto out_free_dio;
 
-- 
2.40.1

