Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85ED7C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 20:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiGTUxM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 16:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGTUxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 16:53:11 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AEF5006B
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 13:53:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so3430583pjl.0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 13:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pOKODZQyBMnzMvR5KmC8mfKFBN/Sfm4J11T65D/3W8Q=;
        b=Rv8hseAf8yS1H4Ce7L7Qz4WXr3ilvKvygpZNP7QHKrw62vsZ3ftZvjAErgwG8zhTv2
         SnXS44C/WbKDmseP4Zjsz25yWMYqnVeoupIy5rldXvq6cUAqfY37XgGvHCvRC3OMupCs
         o+7hjDjxVPqjRpChIhISDwsTLJOVKcbwlNyesvmilWa+mU3jXKAuhNEryuU0nGtx50rt
         MgAI8f5R+PlBHHHn7mSJKVCe6hkWjKMY3kOu/u0OG72lfTQyyJog7A+ScoaB3OYS67Fg
         MXw+B01spSbgMb8/chnFzQV5/EKhzbafrbTgHcQ+H63YDA4YHgBgo/4wGz/P2qN3/NvU
         tc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pOKODZQyBMnzMvR5KmC8mfKFBN/Sfm4J11T65D/3W8Q=;
        b=gj+xnT3o0+LfjMsjcPFFjgfrgpqVyERrJnYuRdn0mc6qwLN3aa5pXnXGG1N0ufKs1a
         wovMEadH1bo2fMF0Qsqj+9FaKZDzm7Tmi04dXXpfrku5Kyiv6nbOkAVrlI3aA39coH5p
         lRwPedRUsC8zgr+/DUueXSyDUhqSw3JLxKFk+gA3yw4hwzS4Occgyt4cUEg8xYzqRPUq
         +7TjT9eyaa3UywHyHM51sDfQDjG0GrnWQM46kFF4+T056iAswPGJvBPLbl5akJJTysB2
         UOoAwRYlTcs/R7Zsrl4U+TM9z8SU9orwozHwPqK8QVin7y18E6lCGTrKC/PBSdPwkbJD
         O7DA==
X-Gm-Message-State: AJIora8224s0tzB40MDSvkcdNOvWJXQpmsqay7xHFY7OJfJ9w62GVANV
        ERaITYOBqsOA6pQa6+QXD9WKSdsV1sY=
X-Google-Smtp-Source: AGRyM1uqtCI78rCce9SJD/fBn9epc0Omnp9ijUk+O7ZjWKlxOdlc/4BGvJfAddcs4QUwaJuDxMWPug==
X-Received: by 2002:a17:902:a710:b0:16c:5305:2244 with SMTP id w16-20020a170902a71000b0016c53052244mr38256061plq.125.1658350390118;
        Wed, 20 Jul 2022 13:53:10 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9-20020a656b89000000b00415b0c3f0b1sm11999364pgw.69.2022.07.20.13.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 13:53:09 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     ross.zwisler@linux.intel.com, david@fromorbit.com,
        darrick.wong@oracle.com, sandeen@sandeen.net,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] xfs_io: Make HAVE_MAP_SYNC more robust
Date:   Wed, 20 Jul 2022 13:53:07 -0700
Message-Id: <20220720205307.2345230-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

MIPS platforms building with recent kernel headers and the musl-libc toolchain
will expose the following build failure:

mmap.c: In function 'mmap_f':
mmap.c:196:12: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
  196 |    flags = MAP_SYNC | MAP_SHARED_VALIDATE;
      |            ^~~~~~~~
      |            MS_SYNC
mmap.c:196:12: note: each undeclared identifier is reported only once for each function it appears in
make[4]: *** [../include/buildrules:81: mmap.o] Error 1

The reason for that is that the linux.h header file which intends to provide a fallback definition for MAP_SYNC and MAP_SHARED_VALIDATE is included too early through:

input.h -> libfrog/projects.h -> xfs.h -> linux.h and this happens
*before* sys/mman.h is included.

sys/mman.h -> bits/mman.h which has a:
  #undef MAP_SYNC

see: https://git.musl-libc.org/cgit/musl/tree/arch/mips/bits/mman.h#n21

The end result is that sys/mman.h being included for the first time
ends-up overriding the HAVE_MAP_SYNC fallbacks.

To remedy that, make sure that linux.h is updated to include sys/mman.h
such that its fallbacks are independent of the inclusion order. As a
consequence this forces us to ensure that we do not re-define
accidentally MAP_SYNC or MAP_SHARED_VALIDATE so we protect against that.

Fixes: dad796834cb9 ("xfs_io: add MAP_SYNC support to mmap()")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux.h b/include/linux.h
index 3d9f4e3dca80..c3cc8e30c677 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -252,8 +252,13 @@ struct fsxattr {
 #endif
 
 #ifndef HAVE_MAP_SYNC
+#include <sys/mman.h>
+#ifndef MAP_SYNC
 #define MAP_SYNC 0
+#endif
+#ifndef MAP_SHARED_VALIDATE
 #define MAP_SHARED_VALIDATE 0
+#endif
 #else
 #include <asm-generic/mman.h>
 #include <asm-generic/mman-common.h>
-- 
2.25.1

