Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33973 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755071AbcK1Wmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 17:42:52 -0500
Received: by mail-pg0-f53.google.com with SMTP id x23so61567830pgx.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:42:52 -0800 (PST)
From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] Fix building xfsprogs on 32-bit platforms
Date: Mon, 28 Nov 2016 14:42:35 -0800
Message-Id: <1480372955-41315-1-git-send-email-ebiggers@google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eric Biggers <ebiggers@google.com>

Since commit 7fda99a0c297 ("xfs.h: require transparent LFS for all
users"), building xfsprogs fails on a 32-bit platform because it does
not define _FILE_OFFSET_BITS=64 itself.  Fix it by adding this to CFLAGS
in builddefs.in.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/builddefs.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index aeb2905..5219071 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -25,7 +25,7 @@ OPTIMIZER = @opt_build@
 MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
-CFLAGS = @CFLAGS@
+CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64
 
 LIBRT = @librt@
 LIBUUID = @libuuid@
-- 
2.8.0.rc3.226.g39d4020

