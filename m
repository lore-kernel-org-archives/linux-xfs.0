Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85077C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  8 May 2022 19:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiEHTgf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 May 2022 15:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiEHTge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 15:36:34 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC82317
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 12:32:42 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p189so7304929wmp.3
        for <linux-xfs@vger.kernel.org>; Sun, 08 May 2022 12:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1KF1qkavnmnuxfJ180rz5FZAi2zQJkHShj224nVFYLY=;
        b=Ao1DwLFyV9MzEHnfCPKlD4pMDQ/+ZgCvVWTJ/KZe5E4eiXi9op+UPO12u4XJD6R+An
         vxpSkAoWJ/Tprgh48v+1OE0Fx0uAzCdXNBlXyjNi5uIPk31s91NJ34Rm63nG50IXSJmk
         DVvLc9KcbaYL0E+0AhwfusTpuvreBSutThQxpolH+H+mulWxPlOdq2Kp6OxZZLTFqq4M
         Pmm1ZprhZWNg13ugM9t6UJa7PqkJ36yjJYzaZtkLgDQW9XQS/mOV4qnda5RG+aDHnZKM
         yF1yx3/+RQCdR7sx776CM4RIacETI35Rqs1AY5aVxyyAMsTrBmg88OJFwZ6wld04CK6U
         9PzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1KF1qkavnmnuxfJ180rz5FZAi2zQJkHShj224nVFYLY=;
        b=SH3SWQ5nZzDKrQS0KRv5WJvYHvjdix3Aei4KFmKmxcD1KSL3e5TpiCRn0muFHYNGZc
         UQu12grPY/zdAdxU0yCc6Hz5uxKi2hMDjwV1HjJUElFqX7QoJjTLpbGUhJZb7JuIZAkS
         bdVJSis2hfx2GZ+3x256iIs6JOEuOKAsda76IkRwVZxaRhnfjUhuPSDrkxxkWj3Usm9L
         oV0gzsI62sOIcmkOEW4XP0FFRCUasskMHTQkQq1gQJCOTZh7sSVLXfDqN7QrgTrU9xv9
         vSJtwuBnZEwhcB68lk8PZ5q4hgrUxsmnIEISDVLHZ2/br9BwBRalBuienTmMURFS0AS+
         j2xg==
X-Gm-Message-State: AOAM530fP0i4JvmSlX8lEFs/F10Pov1Jnf7Cw7XjHObLIPKxm6057yNA
        bm0ABA9TU9vsWHro/AkuWKF32KyC0pM=
X-Google-Smtp-Source: ABdhPJyUkH4aQnua3yWm41VFLyclJOARL6fZh5pp6o4OfwNUb9x5wsm98odhfrmKy+f8ge63uUpGCg==
X-Received: by 2002:a7b:cb8f:0:b0:394:30b5:edab with SMTP id m15-20020a7bcb8f000000b0039430b5edabmr12818020wmi.148.1652038360951;
        Sun, 08 May 2022 12:32:40 -0700 (PDT)
Received: from kali.home (2a01cb088e0b5b002be75de2a1caa253.ipv6.abo.wanadoo.fr. [2a01:cb08:8e0b:5b00:2be7:5de2:a1ca:a253])
        by smtp.gmail.com with ESMTPSA id a7-20020a05600c348700b003942a244ed7sm9853280wmq.28.2022.05.08.12.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:32:40 -0700 (PDT)
From:   Fabrice Fontaine <fontaine.fabrice@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [PATCH v2] io/mmap.c: fix musl build on mips64
Date:   Sun,  8 May 2022 21:30:29 +0200
Message-Id: <20220508193029.1277260-1-fontaine.fabrice@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

musl undefines MAP_SYNC on some architectures such as mips64 since
version 1.1.20 and
https://github.com/ifduyue/musl/commit/9b57db3f958d9adc3b1c7371b5c6723aaee448b7
resulting in the following build failure:

mmap.c: In function 'mmap_f':
mmap.c:196:33: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
  196 |                         flags = MAP_SYNC | MAP_SHARED_VALIDATE;
      |                                 ^~~~~~~~
      |                                 MS_SYNC

This build failure is raised because header includes have been tangled
up:

input.h -> libfrog/projects.h -> xfs.h -> linux.h.

As a result, linux.h will be included before sys/mman.h and the
following piece of code from linux.h will be "overriden" on platforms
without MAP_SYNC:

 #ifndef HAVE_MAP_SYNC
 #define MAP_SYNC 0
 #define MAP_SHARED_VALIDATE 0
 #else
 #include <asm-generic/mman.h>
 #include <asm-generic/mman-common.h>
 #endif /* HAVE_MAP_SYNC */

To fix this build failure, include <sys/mman.h> before the other
includes.

A more long-term solution would be to untangle the headers.

Fixes:
 - http://autobuild.buildroot.org/results/3296194907baf7d3fe039f59bcbf595aa8107a28

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
Changes v1 -> v2 (after review of Dave Chinner):
 - Update commit message

 io/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/mmap.c b/io/mmap.c
index 8c048a0a..b8609295 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -4,9 +4,9 @@
  * All Rights Reserved.
  */
 
+#include <sys/mman.h>
 #include "command.h"
 #include "input.h"
-#include <sys/mman.h>
 #include <signal.h>
 #include "init.h"
 #include "io.h"
-- 
2.35.1

