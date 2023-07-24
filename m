Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34166C04A94
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 22:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjGXWzU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 18:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjGXWzT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 18:55:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C59100
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 15:55:18 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1bba9539a23so1825845ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 15:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239318; x=1690844118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVeLYS33nnc1708rDqfbQibRM29ZHSZOxWFzkowQIMY=;
        b=ykm9gWdurj0xOxNjjFoGt7mW+OF9Gw/mBBQYDdfmgAR63NziZCw7JWsImTNuRnwqQo
         Wa1aZQ8/c6v82ktiGrh8sftd+3evkOvwVSYT8EuHB0ykswG2vdvFhgDu67fczpcRPwmn
         DRFxhrtpDi+H7zZy0A5D0sjP93cQYLEZE4vhxnhA/7bDs1VI2cayrOp5LJdJN4v2f5Rt
         /j/RKgIBYDUYcz+Wa8NLZcr39bRM/paQtfR6K2cNHC/QiYD/u6s6Uk6dr4CIiIeEwFSI
         DgBH9UNr3jaCGYG61cc8CciPApi+Q7wQJOCJ0SdmTPBHxayNs9nRH6rM51+6gYeaxbJM
         gn9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239318; x=1690844118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eVeLYS33nnc1708rDqfbQibRM29ZHSZOxWFzkowQIMY=;
        b=jgy3/7zhNfoaJ44TSgHC+2CVrs2CeXnnj+lHaSZmWMpKeVSJq61dfVfW0Q/lNxxSGP
         buMyl7B/VVbsm4bzFHcayrieKdEWbrtonpFPrb5vbtvmkNYDXmEdCEePCkuLjAeh+c8G
         7Rwrr3jnBQzce+U3SI4sCraH1CLWoKZnGtAoq3kOoe0yaUQV9pZ6S/Oyftrc3WIQkN4C
         kfnt9dAmysAzjPb1MdlUaUx+EA0mW/bgCz1EpFmowda4vIrJH1kPBkyFZSxBFILI12cp
         o2f6YRFMQNNnYAMu/Qeo9vfX4l7JlzA0FpD+7JkUDW3ejqI00h9EpqcgIEIJ2J32qt1o
         q/bw==
X-Gm-Message-State: ABy/qLamfG82pP+NBowN/QC0aZ/PBXQr27Nd3OiMYdWfNx3bHFNuMevV
        YBA+meqOA8rdkPqWlNJetmB3pg==
X-Google-Smtp-Source: APBJJlGftuzyUY14869rqyzSOwXATOafJNKRe47t9tts3Omzk/El6tbEHeyUXO9Zpn43CHB8fY3Tlg==
X-Received: by 2002:a17:902:dad2:b0:1b8:9fc4:2733 with SMTP id q18-20020a170902dad200b001b89fc42733mr14708729plx.3.1690239317766;
        Mon, 24 Jul 2023 15:55:17 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] iomap: use an unsigned type for IOMAP_DIO_* defines
Date:   Mon, 24 Jul 2023 16:55:05 -0600
Message-Id: <20230724225511.599870-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
References: <20230724225511.599870-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

IOMAP_DIO_DIRTY shifts by 31 bits, which makes UBSAN unhappy. Clean up
all the defines by making the shifted value an unsigned value.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 0ce60e80c901..7d627d43d10b 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,10 +20,10 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
-#define IOMAP_DIO_WRITE_FUA	(1 << 28)
-#define IOMAP_DIO_NEED_SYNC	(1 << 29)
-#define IOMAP_DIO_WRITE		(1 << 30)
-#define IOMAP_DIO_DIRTY		(1 << 31)
+#define IOMAP_DIO_WRITE_FUA	(1U << 28)
+#define IOMAP_DIO_NEED_SYNC	(1U << 29)
+#define IOMAP_DIO_WRITE		(1U << 30)
+#define IOMAP_DIO_DIRTY		(1U << 31)
 
 struct iomap_dio {
 	struct kiocb		*iocb;
-- 
2.40.1

