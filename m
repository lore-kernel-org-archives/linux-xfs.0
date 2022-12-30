Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA2CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbiLaCWt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaCWt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:22:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6D519C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:22:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CED4761C43
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AA0C433EF;
        Sat, 31 Dec 2022 02:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453367;
        bh=MiuHvsC/tBqxyPKHtP1pAHm4pCl3IpB2W1oOEpp1FKA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KjXfKGT7IF1iTbLqgRhItOJpxTG3cjpwVLvCGU+/I4eIYrzQlTJeea0EdM86wkk4w
         uRIDe8KTMPY4YVKynkn3lZ2iCycijjyQ4IpmM08JcpIXOJqXSAiyaaTVp1XLN2y19K
         yqjT3Km6Dc7YA4RMGpWqKX+BljTbjFVlO8jMCo8VUG1iaO7H1RnqHmrGtnS+3WkEGq
         CwXQEdNDROV6Yua6Kk+xVMos8rXmBS25NWbeRBOb5pud4fKzT+Y43Ml8rR70N7Tlhl
         urZaSe22WAC+kJNFIr2bWCkMuFjV2Vze8L6Kh30piTfLGpOkPfXY+0N39z9AvudP+B
         /3nwKf9pqtmIA==
Subject: [PATCH 04/10] libfrog: move 64-bit division wrappers to libfrog
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:28 -0800
Message-ID: <167243876868.727509.14947013529888847664.stgit@magnolia>
In-Reply-To: <167243876812.727509.17144221830951566022.stgit@magnolia>
References: <167243876812.727509.17144221830951566022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We want to keep the rtgroup unit conversion functions as static inlines,
so share the div64 functions via libfrog instead of libxfs_priv.h.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/Makefile     |    1 +
 libfrog/div64.h      |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h |   61 +-------------------------------------------
 3 files changed, 71 insertions(+), 60 deletions(-)
 create mode 100644 libfrog/div64.h


diff --git a/libfrog/Makefile b/libfrog/Makefile
index 66d2afe56fe..04aecf1abf1 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -40,6 +40,7 @@ crc32c.h \
 crc32cselftest.h \
 crc32defs.h \
 crc32table.h \
+div64.h \
 file_exchange.h \
 fsgeom.h \
 logging.h \
diff --git a/libfrog/div64.h b/libfrog/div64.h
new file mode 100644
index 00000000000..265487916fc
--- /dev/null
+++ b/libfrog/div64.h
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef LIBFROG_DIV64_H_
+#define LIBFROG_DIV64_H_
+
+static inline int __do_div(unsigned long long *n, unsigned base)
+{
+	int __res;
+	__res = (int)(((unsigned long) *n) % (unsigned) base);
+	*n = ((unsigned long) *n) / (unsigned) base;
+	return __res;
+}
+
+#define do_div(n,base)	(__do_div((unsigned long long *)&(n), (base)))
+#define do_mod(a, b)		((a) % (b))
+#define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
+
+/**
+ * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 32bit divisor
+ * @remainder: pointer to unsigned 32bit remainder
+ *
+ * Return: sets ``*remainder``, then returns dividend / divisor
+ *
+ * This is commonly provided by 32bit archs to provide an optimized 64bit
+ * divide.
+ */
+static inline uint64_t
+div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+/**
+ * div_u64 - unsigned 64bit divide with 32bit divisor
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 32bit divisor
+ *
+ * This is the most common 64bit divide and should be used if possible,
+ * as many 32bit archs can optimize this variant better than a full 64bit
+ * divide.
+ */
+static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
+{
+	uint32_t remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
+}
+
+/**
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 64bit divisor
+ * @remainder: pointer to unsigned 64bit remainder
+ *
+ * Return: sets ``*remainder``, then returns dividend / divisor
+ */
+static inline uint64_t
+div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+#endif /* LIBFROG_DIV64_H_ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 4cb996a3f3f..49441ac787f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -50,6 +50,7 @@
 #include "bitops.h"
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
+#include "libfrog/div64.h"
 #include "atomic.h"
 #include "spinlock.h"
 #include "linux-err.h"
@@ -257,66 +258,6 @@ static inline bool __must_check __must_check_overflow(bool overflow)
 	__builtin_add_overflow(__a, __b, __d);	\
 }))
 
-static inline int __do_div(unsigned long long *n, unsigned base)
-{
-	int __res;
-	__res = (int)(((unsigned long) *n) % (unsigned) base);
-	*n = ((unsigned long) *n) / (unsigned) base;
-	return __res;
-}
-
-#define do_div(n,base)	(__do_div((unsigned long long *)&(n), (base)))
-#define do_mod(a, b)		((a) % (b))
-#define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
-
-/**
- * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
- * @dividend: unsigned 64bit dividend
- * @divisor: unsigned 32bit divisor
- * @remainder: pointer to unsigned 32bit remainder
- *
- * Return: sets ``*remainder``, then returns dividend / divisor
- *
- * This is commonly provided by 32bit archs to provide an optimized 64bit
- * divide.
- */
-static inline uint64_t
-div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
-{
-	*remainder = dividend % divisor;
-	return dividend / divisor;
-}
-
-/**
- * div_u64 - unsigned 64bit divide with 32bit divisor
- * @dividend: unsigned 64bit dividend
- * @divisor: unsigned 32bit divisor
- *
- * This is the most common 64bit divide and should be used if possible,
- * as many 32bit archs can optimize this variant better than a full 64bit
- * divide.
- */
-static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
-{
-	uint32_t remainder;
-	return div_u64_rem(dividend, divisor, &remainder);
-}
-
-/**
- * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
- * @dividend: unsigned 64bit dividend
- * @divisor: unsigned 64bit divisor
- * @remainder: pointer to unsigned 64bit remainder
- *
- * Return: sets ``*remainder``, then returns dividend / divisor
- */
-static inline uint64_t
-div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
-{
-	*remainder = dividend % divisor;
-	return dividend / divisor;
-}
-
 #define min_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
 #define max_t(type,x,y) \

