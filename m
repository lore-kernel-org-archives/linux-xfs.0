Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19608E732C0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 11:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjI1L0I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 07:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjI1LZz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 07:25:55 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E5A5257
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 04:23:43 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3226b8de467so10923097f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 04:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695900221; x=1696505021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cX505rAX+gWXx3BwmDOZYzN9xGLWy7O0BrxxEhEYULg=;
        b=Zt0jM85BzOI4BJkajWs9th8xHOp6GRNqIy3kB8mkMfEb8GEooICLg+WC6b7/BvP4BV
         +ylpzfqCbX/2xjxB4ji00eJrEQPBp5FD8qC9bJGi7LHOrJKGF5w/wiZuS44Ys+sUAqr4
         XD07bVEzDnGuFrWYi7ot8YhwyIXow5oJPCIjq1t+QOXfIOITbia+RaCBx6HVDHJzgYRg
         VRJq1PgMZN4mdiuXtOkma23SO4CnWtU5zi5qBEV2IRZqVjnCRgxiwLBzQW0aUHTLkiBR
         vOQpKPgqX6LqYkLOm32iVXV+tY1RbfHlyqAEz/H63SsxV5Z7egJBvlB8QEycwM0HMVRJ
         stDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695900221; x=1696505021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cX505rAX+gWXx3BwmDOZYzN9xGLWy7O0BrxxEhEYULg=;
        b=GXU62ba73zp4EnsQwaOD32KeYYd23Lf5mWQlhxxWiDJO0g4GDYN6om7dEKHBVCdXnV
         hFTkbhGtXW2GNbvuTVfdXL/7f+59bpipr1wQZeXAPbeCU7B6FG31v2Uapopl+3DLazMn
         BK9ThLvrQIFjaWUtnKbuvnnnqbwOw7+BSZz3dD+ft6cjTq/a8cdPV0f8UwY5if7d9ZTb
         HkCc8HlSj8BxtlhOq1RorBReHUrSNPDd6jW5KAfAjpfgkBXnlq69PqjCoqmmDCqDJ/ta
         fRC54T9xKylfBUZDwwrJJtfct8LG474eJFF26fWqseo1N+2uT/Mu+ThfN8e6PYWBOFV3
         Gayg==
X-Gm-Message-State: AOJu0Yxl3SzT1B+RU6Qn+wuAhpbfspPR+WocBfLol56GHDmus2OeKY6v
        /2uV1xGHiqTsWF5KpP7uybOn2iXaUKA=
X-Google-Smtp-Source: AGHT+IHmK8xprHuh7X66zLPW6eNhObA5Kl2gKIy+lJoBd7hNetafkOyHRUCjPqRjPV4cQbgHA6oxwg==
X-Received: by 2002:adf:ee10:0:b0:319:71be:9248 with SMTP id y16-20020adfee10000000b0031971be9248mr907740wrn.19.1695900221237;
        Thu, 28 Sep 2023 04:23:41 -0700 (PDT)
Received: from krnowak-ms-ubuntu.fritz.box ([45.135.60.1])
        by smtp.gmail.com with ESMTPSA id s7-20020adfea87000000b0030ada01ca78sm19084490wrm.10.2023.09.28.04.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 04:23:40 -0700 (PDT)
From:   Krzesimir Nowak <qdlacz@gmail.com>
X-Google-Original-From: Krzesimir Nowak <knowak@microsoft.com>
To:     linux-xfs@vger.kernel.org
Cc:     Krzesimir Nowak <knowak@microsoft.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2] libfrog: drop build host crc32 selftest
Date:   Thu, 28 Sep 2023 13:23:38 +0200
Message-Id: <20230928112338.120861-1-knowak@microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

CRC selftests running on a build host were useful long time ago, when
CRC support was added to the on-disk support. Now it's purpose is
replaced by fstests. Also mkfs.xfs and xfs_repair have their own
selftests.

On top of that, it adds a dependency on liburcu on the build host for
no reason - liburcu is not used by the crc32 selftest.

Signed-off-by: Krzesimir Nowak <knowak@microsoft.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/Makefile | 14 ++------------
 libfrog/crc32.c  | 21 ---------------------
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/libfrog/Makefile b/libfrog/Makefile
index f292afe3..8cde97d4 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -57,9 +57,9 @@ ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
 endif
 
-LDIRT = gen_crc32table crc32table.h crc32selftest
+LDIRT = gen_crc32table crc32table.h
 
-default: crc32selftest ltdepend $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY)
 
 crc32table.h: gen_crc32table.c crc32defs.h
 	@echo "    [CC]     gen_crc32table"
@@ -67,16 +67,6 @@ crc32table.h: gen_crc32table.c crc32defs.h
 	@echo "    [GENERATE] $@"
 	$(Q) ./gen_crc32table > crc32table.h
 
-# The selftest binary will return an error if it fails. This is made a
-# dependency of the build process so that we refuse to build the tools on broken
-# systems/architectures. Hence we make sure that xfsprogs will never use a
-# busted CRC calculation at build time and hence avoid putting bad CRCs down on
-# disk.
-crc32selftest: gen_crc32table.c crc32table.h crc32.c crc32defs.h randbytes.c
-	@echo "    [TEST]    CRC32"
-	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=1 randbytes.c crc32.c -o $@
-	$(Q) ./$@
-
 include $(BUILDRULES)
 
 install install-dev: default
diff --git a/libfrog/crc32.c b/libfrog/crc32.c
index 2499615d..d07e5371 100644
--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -186,24 +186,3 @@ u32 __pure crc32c_le(u32 crc, unsigned char const *p, size_t len)
 			(const u32 (*)[256])crc32ctable_le, CRC32C_POLY_LE);
 }
 #endif
-
-
-#ifdef CRC32_SELFTEST
-# include "crc32cselftest.h"
-
-/*
- * make sure we always return 0 for a successful test run, and non-zero for a
- * failed run. The build infrastructure is looking for this information to
- * determine whether to allow the build to proceed.
- */
-int main(int argc, char **argv)
-{
-	int errors;
-
-	printf("CRC_LE_BITS = %d\n", CRC_LE_BITS);
-
-	errors = crc32c_test(0);
-
-	return errors != 0;
-}
-#endif /* CRC32_SELFTEST */
-- 
2.25.1

