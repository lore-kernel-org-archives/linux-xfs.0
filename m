Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94BB7EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 16:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjGUQSr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjGUQSZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 12:18:25 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01E74488
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:17:11 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-780c89d1998so28218639f.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956227; x=1690561027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0ou5k87I8sTPpRqra9CBhOtTJt5c6QaC2AAQjrnZvU=;
        b=BRMTxmI+PY4omQ235bdiMvhNB9Ce0C4YAQO7D88bN1+VRHjEB099g87e/bvfP/1YhR
         5hpT1PMNCuZ3F/8gb/DiAwM8QPNGFzTCjcjYwZwF/tpdZAEDSfg+e3YQ6yvlwwHtADKC
         NmfjXaRAmejWyQAiMtaKd23p/fO3w/y1DeeBzQUJY1xSEKaGu8dQdse9qxvi2jKG8FeL
         BTxkGLhrs9jz9T/OlYUpOIBN4UWYc7azcEoyEKe+JAwQIqChR0GcB7gRne2A6ggKOKwO
         /16n9VzKV1pfwLrpyfswYblpDYe6DS8h95HQwZWrgFxzMDKjl5R1nHa5xIVEpjuwY3g4
         Y7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956227; x=1690561027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/0ou5k87I8sTPpRqra9CBhOtTJt5c6QaC2AAQjrnZvU=;
        b=arF/q9PM2RLp2XVtM3ZAHiaa+n+Bpfw9cy2avho+n/iekgf+zjkvuKsXaJk7Ab/Kgs
         H2JRGEjg+sf1jl9wY7m1r+w5k9SMGQi7HH2rpG/Ij2WMndsnA1VFolWRYkPbEVaq3Ncf
         BYooqE2EDehSAW3eF4bygW2o9N6Nf8yguZwwm3fpCaGFKGVT/hHmPw7BlaFzN6gGUc6h
         IX2pDOw0LvOzhH6dzbC5au7BkGxWRr+gBmP75+8VYCNZPn53wJ02pSih2GYNRwrOZ3rO
         E9lb2Y5KIKOBbPqWU4w3jsEDFbLkiqSuQFWmHxb01744zBCxr9yyCjp9OrON3gGoHOPt
         QAUw==
X-Gm-Message-State: ABy/qLYZiNXJZicNeuVYMOTXESIPpOMvqictJfzNHobAL3NByJfapzB+
        kjjusqj8I/PyvOYcIjrSWgLNUQ==
X-Google-Smtp-Source: APBJJlGSsWXWU4FHIUZtiYJSZA11IzqG/adw0m0igijzMWLTfMvgHAO4+Tzm08vKqUEF0hI3XCz9YA==
X-Received: by 2002:a05:6602:1a05:b0:780:c6bb:ad8d with SMTP id bo5-20020a0566021a0500b00780c6bbad8dmr2383411iob.0.1689956227115;
        Fri, 21 Jul 2023 09:17:07 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:17:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] iomap: use an unsigned type for IOMAP_DIO_* defines
Date:   Fri, 21 Jul 2023 10:16:50 -0600
Message-Id: <20230721161650.319414-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

IOMAP_DIO_DIRTY shifts by 31 bits, which makes UBSAN unhappy. Clean up
all the defines by making the shifted value an unsigned value.

Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ae9046d16d71..dc9fe2ac9136 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,12 +20,12 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
-#define IOMAP_DIO_CALLER_COMP	(1 << 26)
-#define IOMAP_DIO_INLINE_COMP	(1 << 27)
-#define IOMAP_DIO_WRITE_THROUGH	(1 << 28)
-#define IOMAP_DIO_NEED_SYNC	(1 << 29)
-#define IOMAP_DIO_WRITE		(1 << 30)
-#define IOMAP_DIO_DIRTY		(1 << 31)
+#define IOMAP_DIO_CALLER_COMP	(1U << 26)
+#define IOMAP_DIO_INLINE_COMP	(1U << 27)
+#define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
+#define IOMAP_DIO_NEED_SYNC	(1U << 29)
+#define IOMAP_DIO_WRITE		(1U << 30)
+#define IOMAP_DIO_DIRTY		(1U << 31)
 
 struct iomap_dio {
 	struct kiocb		*iocb;
-- 
2.40.1

