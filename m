Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A774E80A93
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 06:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjI0Gi4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Sep 2023 02:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjI0Giz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Sep 2023 02:38:55 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66616D6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 23:38:54 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-50325ce89e9so17215809e87.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 23:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695796732; x=1696401532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7S/If62RagWdI1zZN3s+xfmELEUla/KNPXRhI8NzCiA=;
        b=g0fXx0kbhYBxg1m0TvBJv0YvFxHxyIeOjtw0MgKp5ftc89ghjFKbG32Q9SEf1vI6j7
         5GDSVryufTqFivBXcVZsh7EEXOVa8KIoCpDnfmBwFaHf4eted3iz0UbkgM6pslQ7Src3
         n3Pa1elm0B53+AsTGuEmN6QjdMIUrYBr+GEgK0+MW5NeszihAwnGTvM6esxvw0IO87WP
         5/Dok3B27wZ/dg+mRLfidtS85WGNJDdXud3zUYhSTa9kDhBtNObUxVPeCIjVxogeOUN3
         bOnEGPeercrcJidFtfFRFCRLccev0gPaHaJlUXAwvnjf7A3GTbW4JR29EijCIX6bgO78
         8c3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695796732; x=1696401532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7S/If62RagWdI1zZN3s+xfmELEUla/KNPXRhI8NzCiA=;
        b=psBIxzizwEG7YywCk9q54hqV0FDVa1WscCsxFeVbeX+DDPTsOByVGUIPXZQAWRYeC+
         gFclV412nA7ZRgn9mlEoxD75Pctxub2enOz1vVrr+kiNkibBSvS/3QghwLIbeOqQzbhH
         exsfVcZfsUwZTy/SeietWxuPptTl7UpfNYBmCAWO6SNjavZwMdvFZR3Ce4+0iImWNkF0
         jZNW6DjFhP+qz9xWlvgYNca5FGv+xOmPOnci0OcYQjliK70NOKZrIJEvZIpRzPAdaHoe
         a9CjzTVeEZlhm882wUKv2NQb6+tQTi18eMaQl0ggtggpqqsXo19zgz6A8Lniv0PLgodN
         caBw==
X-Gm-Message-State: AOJu0YxHqgegBpPYYdXjWGRP/ivyl4bWHSOdksizQUiqMRQ3AqRUFg5C
        ioJD/p6NWs2qv41+WOJtFO6WdLo8aiI=
X-Google-Smtp-Source: AGHT+IFb4YayGfH2iinlcq6Qqz5npXfCDsHSU+GWzk7dQSxyws2u2ROzMj9WiLiM9qNzjkccS+IxAw==
X-Received: by 2002:a19:674a:0:b0:500:d4d9:25b5 with SMTP id e10-20020a19674a000000b00500d4d925b5mr736744lfj.56.1695796732210;
        Tue, 26 Sep 2023 23:38:52 -0700 (PDT)
Received: from krnowak-ms-ubuntu.fritz.box ([45.135.60.1])
        by smtp.gmail.com with ESMTPSA id o5-20020a50c905000000b0053448f23b33sm414725edh.93.2023.09.26.23.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 23:38:51 -0700 (PDT)
From:   Krzesimir Nowak <qdlacz@gmail.com>
X-Google-Original-From: Krzesimir Nowak <knowak@microsoft.com>
To:     linux-xfs@vger.kernel.org
Cc:     Krzesimir Nowak <knowak@microsoft.com>
Subject: [PATCH] libfrog: drop build host crc32 selftest
Date:   Wed, 27 Sep 2023 08:38:47 +0200
Message-Id: <20230927063847.81000-1-knowak@microsoft.com>
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

On top of that, it fails to build when crosscompiling and would be
useless anyway.

Signed-off-by: Krzesimir Nowak <knowak@microsoft.com>
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

