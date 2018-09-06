Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35062 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbeIGDLf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Sep 2018 23:11:35 -0400
Subject: Re: [PATCH xfsprogs] build: don't assume $BUILD_CC has fsmap.h just
 because $CC does
References: <20180906183529.117251-1-briannorris@chromium.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <30774ff1-57c1-c9f4-4ec3-31c177b11489@sandeen.net>
Date: Thu, 6 Sep 2018 17:33:56 -0500
MIME-Version: 1.0
In-Reply-To: <20180906183529.117251-1-briannorris@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Norris <briannorris@chromium.org>, linux-xfs@vger.kernel.org

On 9/6/18 1:35 PM, Brian Norris wrote:
> The $BUILD_CC toolchain might have an older set of Linux headers than
> the $CC toolchain. It's generally unsafe to try to build both with the
> same definitions, but in particular, this one can cause compilation
> failures in the local crc32selftest build:
> 
>  In file included from crc32.c:37:
>  In file included from ../include/xfs.h:37:
>  ../include/xfs/linux.h:226:11: fatal error: 'linux/fsmap.h' file not found
>  # include <linux/fsmap.h>
>            ^~~~~~~~~~~~~~~
> 
> It's safe to always assume that the headers don't have getfsmap, since
> the alternative just includes our local definitions anyway.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Seems reasonable, thanks for bringing up the problem.

At first I was thinking that separating out crc32test.c from crc32.c
like the kernel did would help, but of course crc32.c still has to be
built.  ;)

I was trying to just get the selftest to build with a custom set of
userspace headers, like the patch below, so we don't have to pull in all
the various and sundry xfs headers & dependencies.  Not sure what the better
approach is here ...

---



diff --git a/libfrog/crc32.c b/libfrog/crc32.c
index 1d52f68..b5addad 100644
--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -29,16 +29,34 @@
  * match the hardware acceleration available on Intel CPUs.
  */
 
+#ifdef CRC32_SELFTEST
+#define __STDC_FORMAT_MACROS
+#include <inttypes.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <asm/types.h>
+#include "xfs_arch.h"
+#include "crc32c.h"
+
+/* types specifc to this file */
+typedef unsigned char  u8;
+typedef unsigned int   u32;
+#else
 #include "platform_defs.h"
 #include "xfs.h"
 #include "xfs_arch.h"
-#include "crc32defs.h"
 
 /* types specifc to this file */
 typedef __u8	u8;
-typedef __u16	u16;
 typedef __u32	u32;
-typedef __u32	u64;
+
+#endif /* CRC32_SELFTEST */
+
+#include "crc32defs.h"
+
 #define __pure
 
 #if CRC_LE_BITS > 8
