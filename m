Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33765 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdBAEwo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 23:52:44 -0500
Received: by mail-pg0-f68.google.com with SMTP id 194so32998621pgd.0
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 20:52:43 -0800 (PST)
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] Fix building xfsprogs on 32-bit platforms (again)
Date: Tue, 31 Jan 2017 20:51:44 -0800
Message-Id: <20170201045144.29488-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Gwendal Grignou <gwendal@chromium.org>, Felix Janda <felix.janda@posteo.de>, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

Building xfsprogs on 32-bit platforms was broken again by the recent
split of BUILD_CFLAGS from CFLAGS.  -D_FILE_OFFSET_BITS=64 was not added
to BUILD_CFLAGS, but in fact BUILD_CFLAGS is used to compile
crc32selftest, which includes xfs.h and therefore requires this
declaration.  Fix this by adding -D_FILE_OFFSET_BITS=64 to BUILD_CFLAGS.

Fixes: 0a71e3839630 ("build: Allow compiling xfsprogs in a cross compile environment")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/builddefs.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index 612b547d..6554e421 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -26,7 +26,7 @@ MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
 CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64
-BUILD_CFLAGS = @BUILD_CFLAGS@
+BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
 
 LIBRT = @librt@
 LIBUUID = @libuuid@
-- 
2.11.0

