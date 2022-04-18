Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488EBC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Apr 2022 20:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238682AbiDRUlG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Apr 2022 16:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiDRUlF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Apr 2022 16:41:05 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A79D1DA75
        for <linux-xfs@vger.kernel.org>; Mon, 18 Apr 2022 13:38:23 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r64so9395568wmr.4
        for <linux-xfs@vger.kernel.org>; Mon, 18 Apr 2022 13:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rctyBqjSVk9prCmNL0O0g/tr9XBGL/QTEURUM84v6rk=;
        b=f2dDp33fizGaFl4DFB3UZ2EA4Ox2Y8CefrZYGHkTl5NG2gx/HiFifE5LzvF0vcmx2Q
         y5fp352dIfdedzZbARHFYmB8y5kt1ywL+Zi3/tWxEBkYp4VtDUWkHFMYNw5Eq59r2Udk
         0Vk6ILLaaAZKPP3JlrBVPDpxPp+Ky8Wbn5nlc1JgVG77MEYhMCiU6KL0sg2deas42r5C
         o/55jUnkub4UKNScQM2TWnz50Y5vVIeqoAHs5wU+2SVx1oIo34L8CeQg3UgAV011p6kZ
         2gzO+cprbRKVDMiC2AUS/0HHQqQXfhsQnbeWVCFTee7s/u6YUWZoTrePra41wtOWQmbw
         8Uaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rctyBqjSVk9prCmNL0O0g/tr9XBGL/QTEURUM84v6rk=;
        b=rR8xZJzTY5GxCGUqm/VgPJjpd73MVZgQuyS4qTDLExnPJXwVwVlcTkz7nR3DnBCyNM
         F7F71w+u3ErV2DIqT70IPyIRB2oMwYWldiMLTRB4kqRW5rshtU5NeSzcjpxTitimcHpZ
         01iKFLBWK639ZBqSwveWj2xt7m8YH8Yj26B1PwDvnAq4YdWOd9CT+9DFBzSLj6hRSnlB
         um85yDMj5yrvZFGv4Lfzeez/rtx71t84KD4Of0CbjTxIR/62NNJDfUkWsWzoNeWQK8Wl
         Cgyu6Bl7vnj3Oer6QvZzP8yaYP8cQjn5mx1Y1XdnbJhHwIGq2Uvj7qmpz8Qz62ftCkbm
         DKSw==
X-Gm-Message-State: AOAM530vu8IXIyHIAgT5Ca9biNhtEZXNpwH2KBDO3sW5poC5FJb+x8cz
        sDaesuLMXW1JCf5KvmQWlsORDjjVfPg=
X-Google-Smtp-Source: ABdhPJzavI1yb6tVddFe/1jAWY2EtNpgL21BnVNMxpuAHTIGZqxwoPcQiMKDBdNre8zBxsqhtf8c+g==
X-Received: by 2002:a1c:f415:0:b0:37f:ab4d:1df2 with SMTP id z21-20020a1cf415000000b0037fab4d1df2mr16517324wma.75.1650314301862;
        Mon, 18 Apr 2022 13:38:21 -0700 (PDT)
Received: from kali.home (2a01cb088e0b5b002be75de2a1caa253.ipv6.abo.wanadoo.fr. [2a01:cb08:8e0b:5b00:2be7:5de2:a1ca:a253])
        by smtp.gmail.com with ESMTPSA id 7-20020a056000156700b0020aa549d399sm606978wrz.11.2022.04.18.13.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 13:38:21 -0700 (PDT)
From:   Fabrice Fontaine <fontaine.fabrice@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [PATCH] io/mmap.c: fix musl build on mips64
Date:   Mon, 18 Apr 2022 22:36:06 +0200
Message-Id: <20220418203606.760110-1-fontaine.fabrice@gmail.com>
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

To fix this build failure, include <sys/mman.h> before the other
includes

Fixes:
 - http://autobuild.buildroot.org/results/3296194907baf7d3fe039f59bcbf595aa8107a28

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
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

