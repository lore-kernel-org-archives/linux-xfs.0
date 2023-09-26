Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD440E7D242
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Sep 2023 07:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjIZHOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 03:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjIZHOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 03:14:48 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC45F3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 00:14:41 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-40572aeb673so49489315e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 00:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695712480; x=1696317280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=maymslVMxkZdvjLxwzyIPdrGUOv2Ix7Z/WHtMhZ84Ww=;
        b=nrnZh9utsDFNEtzwb1dJLZC7urk7+nt0JkpwKJ9TN59QS3qhPqGxtVRQNPkpPRlKFJ
         4zpaIxmd1aDH9iAQK9zCZmqg/WJkKOEEJ9EEteVj1DGe4pVulbJhptyrA/ilfxlovcrF
         x4Y5+VzDPCixDQMAIdrnSIxjlS/dW9zSxokfUFI0Dgjt8Gk+cjFvuecY5VwAJKHAaKR2
         botdw8xs8WOR1QrbSDRjwXm7GxD2LQilbvDz1qnfbplrHjKLUNJeGzWMrLaPKb0KMWV/
         fQZ4/5O1HuQqZUa5nov3MSV1+YxabxF1q3+kSsPCrGiP/37HpdmQ0HX1Pp6owZwgyyQq
         EwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695712480; x=1696317280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=maymslVMxkZdvjLxwzyIPdrGUOv2Ix7Z/WHtMhZ84Ww=;
        b=KJNbrA/b4X2mprHI241Fcan+KL1Fo3I88O6ln7Z/f+/FlAAbQk3NJ02JTQRtfZ8DDq
         /z7rbeqooPqYq6fqhA8laceAoBgLZcOisA0PZPa4ljiO1nmuBnuvxAgOitV2Noxzma/H
         v586O+x+WJpXyoe41XQtTdulE3JgDjWQPbLWsxPCxfhZJ+yF7uhKGEWHWGUkBq9vlWcH
         53gGD918Am1KRn8FsHL6ETY1lEAsmYunAuLiyerdKc5Jdh0Mnw4/+hto0FvIkV/1GTDK
         1NPYBs6Mh1Us9N6UF7Bbo+7dw+V5vKxn2ETrFH07qYFOH94xdjI1Aa7KfoBX6HkMlguJ
         VWqw==
X-Gm-Message-State: AOJu0YxyMQ0WAU7NdZ24wuM+J8LMJQjjZocR2UyYsZnaaHPTQlxKtdwP
        wYRSqkh3puNIw4qAM+KReoC88I2nIoI=
X-Google-Smtp-Source: AGHT+IGhKNpIjyqDkVIA2lgCZJPirIo5ErELmy1J9UjyrrK+beNLOowNpTGxRFcS3/+fVNqRlQzPNA==
X-Received: by 2002:a05:600c:2294:b0:3fe:dcd0:2e10 with SMTP id 20-20020a05600c229400b003fedcd02e10mr8559910wmf.17.1695712479920;
        Tue, 26 Sep 2023 00:14:39 -0700 (PDT)
Received: from krnowak-ms-ubuntu.fritz.box ([45.135.60.1])
        by smtp.gmail.com with ESMTPSA id r5-20020a05600c320500b003fc0505be19sm9046210wmp.37.2023.09.26.00.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 00:14:39 -0700 (PDT)
From:   Krzesimir Nowak <qdlacz@gmail.com>
X-Google-Original-From: Krzesimir Nowak <knowak@microsoft.com>
To:     linux-xfs@vger.kernel.org
Cc:     Krzesimir Nowak <knowak@microsoft.com>
Subject: [PATCH 1/1] libfrog: Fix cross-compilation issue with randbytes
Date:   Tue, 26 Sep 2023 09:14:32 +0200
Message-Id: <20230926071432.51866-2-knowak@microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230926071432.51866-1-knowak@microsoft.com>
References: <20230926071432.51866-1-knowak@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

randbytes.c was mostly split off from crc32.c and, like crc32.c, is
used for selftests, which are run on the build host. As such it should
not include platform_defs.h which in turn includes urcu.h from
userspace-rcu library, because the build host might not have the
library installed.

Signed-off-by: Krzesimir Nowak <knowak@microsoft.com>
---
 libfrog/randbytes.c | 1 -
 libfrog/randbytes.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libfrog/randbytes.c b/libfrog/randbytes.c
index f22da0d3..2023b601 100644
--- a/libfrog/randbytes.c
+++ b/libfrog/randbytes.c
@@ -6,7 +6,6 @@
  *
  * This is the buffer of random bytes used for self tests.
  */
-#include "platform_defs.h"
 #include "libfrog/randbytes.h"
 
 /* 4096 random bytes */
diff --git a/libfrog/randbytes.h b/libfrog/randbytes.h
index 00fd7c4c..fddea9c7 100644
--- a/libfrog/randbytes.h
+++ b/libfrog/randbytes.h
@@ -6,6 +6,8 @@
 #ifndef __LIBFROG_RANDBYTES_H__
 #define __LIBFROG_RANDBYTES_H__
 
+#include <stdint.h>
+
 extern uint8_t randbytes_test_buf[];
 
 #endif /* __LIBFROG_RANDBYTES_H__ */
-- 
2.25.1

