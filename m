Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:37242 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751985AbdIGCTJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 22:19:09 -0400
Received: by mail-pg0-f47.google.com with SMTP id d8so18403903pgt.4
        for <linux-xfs@vger.kernel.org>; Wed, 06 Sep 2017 19:19:09 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] spaceman: Add missing link to libuuid
Date: Wed,  6 Sep 2017 19:19:00 -0700
Message-Id: <20170907021900.41040-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

When uuid is enabled then we see linking failures with gold linker e.g.

libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_compare'
libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_copy'
clang-5.0: error: linker command failed with exit code 1 (use -v to see invocation)

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 spaceman/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/spaceman/Makefile b/spaceman/Makefile
index 95ec3c0..060e0af 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -9,7 +9,7 @@ LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
 CFILES = init.c file.c prealloc.c trim.c
 
-LLDLIBS = $(LIBXCMD)
+LLDLIBS = $(LIBXCMD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD)
 LLDFLAGS = -static
 
-- 
2.14.1

