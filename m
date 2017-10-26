Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932127AbdJZR3B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 13:29:01 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] build: define _DEFAULT_SOURCE if _BSD_SOURCE
Date: Thu, 26 Oct 2017 10:28:57 -0700
Message-Id: <20171026172857.8683-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

./configure will leave traces of a complaint on config.log when
_BSD_SOURCE is defined but not _DEFAULT_SOURCE. _BSD_SOURCE is
deprecated so if defining _BSD_SOURCE also define _DEFAULT_SOURCE.

>From config.log:
/usr/include/features.h:183:3: warning: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-Wcpp]

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 m4/package_libcdev.m4 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index fa5b63978797..af2a9631b8ba 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -137,6 +137,7 @@ AC_DEFUN([AC_HAVE_PREADV],
   [ AC_MSG_CHECKING([for preadv])
     AC_TRY_LINK([
 #define _BSD_SOURCE
+#define _DEFAULT_SOURCE
 #include <sys/uio.h>
     ], [
          preadv(0, 0, 0, 0);
-- 
2.14.2

