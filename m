Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968818AbdDXU3r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 16:29:47 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_io: fix statx definition for non-x86 architecture
Message-ID: <52721b67-60e0-0570-0e90-282e4d525797@redhat.com>
Date: Mon, 24 Apr 2017 15:29:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Gwendal Grignou <gwendal@chromium.org>

Apply the same fix to xfs_io as Gwendal did for fstests:

Fix a compilation error for ARM:
__ILP32__ is defined but not __X32_SYSCALL_BIT.

The check should only apply for x86_64 architecture, statx for other
architectures is not implemented yet - see commit 7acc839c9e57
"statx: Add a system call to make enhanced file info available".

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/statx.h b/io/statx.h
index ff08e27..eea7944 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -18,10 +18,12 @@
 #ifndef __NR_statx
 # ifdef __i386__
 #  define __NR_statx 383
-# elif defined (__ILP32__)
-#  define __NR_statx (__X32_SYSCALL_BIT + 332)
 # elif defined (__x86_64__)
-#  define __NR_statx 332
+#  if defined (__ILP32__)
+#   define __NR_statx (__X32_SYSCALL_BIT + 332)
+#  else
+#   define __NR_statx 332
+#  endif
 # endif
 #endif
 

