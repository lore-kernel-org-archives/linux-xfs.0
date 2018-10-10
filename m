Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbeJKET1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Oct 2018 00:19:27 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: don't include all xfs headers just for crc32
Message-ID: <e1259a8b-b5aa-cfa2-aeab-13d63757d7a5@redhat.com>
Date: Wed, 10 Oct 2018 15:55:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Brian Norris <briannorris@chromium.org>

Brian Norris reported that "The $BUILD_CC toolchain might have an
older set of Linux headers than the $CC toolchain. It's generally
unsafe to try to build both with the same definitions, but in
particular, this one can cause compilation failures in the local
crc32selftest build: [failure to find fsmap.h]"

It seems like the most straightforward thing to do here is include
a specific set of system headers, instead of pulling in the whole
xfs.h header chain which has multiple tests and definitions in
place for headers that may or may not be there during the build.

Reported-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Brian, here's try #3, does this also work for you?

diff --git a/libfrog/crc32.c b/libfrog/crc32.c
index 1d52f68..220b33b 100644
--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -29,8 +29,11 @@
  * match the hardware acceleration available on Intel CPUs.
  */
 
+#include <inttypes.h>
+#include <asm/types.h>
+#include <sys/time.h>
 #include "platform_defs.h"
-#include "xfs.h"
+/* For endian conversion routines */
 #include "xfs_arch.h"
 #include "crc32defs.h"
 
