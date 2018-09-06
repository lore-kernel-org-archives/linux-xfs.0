Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38016 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbeIFXMd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 19:12:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id u11-v6so5377867plq.5
        for <linux-xfs@vger.kernel.org>; Thu, 06 Sep 2018 11:35:50 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
Subject: [PATCH xfsprogs] build: don't assume $BUILD_CC has fsmap.h just because $CC does
Date: Thu,  6 Sep 2018 11:35:29 -0700
Message-Id: <20180906183529.117251-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Norris <briannorris@chromium.org>

The $BUILD_CC toolchain might have an older set of Linux headers than
the $CC toolchain. It's generally unsafe to try to build both with the
same definitions, but in particular, this one can cause compilation
failures in the local crc32selftest build:

 In file included from crc32.c:37:
 In file included from ../include/xfs.h:37:
 ../include/xfs/linux.h:226:11: fatal error: 'linux/fsmap.h' file not found
 # include <linux/fsmap.h>
           ^~~~~~~~~~~~~~~

It's safe to always assume that the headers don't have getfsmap, since
the alternative just includes our local definitions anyway.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
This isn't exactly a pretty solution, but it fixes cross-compilation
problems I'm seeing.

 include/builddefs.in | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index f7d39a4e4094..209abe1d84dd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -156,8 +156,9 @@ endif
 ifeq ($(NEED_INTERNAL_FSXATTR),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
 endif
+# Don't assume $BUILD_CC has getfsmap just because $CC does.
 ifeq ($(HAVE_GETFSMAP),yes)
-PCFLAGS+= -DHAVE_GETFSMAP
+CFLAGS+= -DHAVE_GETFSMAP
 endif
 
 LIBICU_LIBS = @libicu_LIBS@
-- 
2.19.0.rc2.392.g5ba43deb5a-goog
