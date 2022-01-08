Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F45C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Jan 2022 19:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiAHT5r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Jan 2022 14:57:47 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49588 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230057AbiAHT5q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Jan 2022 14:57:46 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 208JvgMC029875
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 8 Jan 2022 14:57:43 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 64F7D15C33E5; Sat,  8 Jan 2022 14:57:42 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] xfsprogs: fix static build problems caused by liburcu
Date:   Sat,  8 Jan 2022 14:57:39 -0500
Message-Id: <20220108195739.1212901-1-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The liburcu library has a dependency on pthreads.  Hence, in order for
static builds of xfsprogs to work, $(LIBPTHREAD) needs to appear
*after* $(LUBURCU) in LLDLIBS.  Otherwise, static links of xfs_* will
fail due to undefined references of pthread_create, pthread_exit,
et. al.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 copy/Makefile      | 4 ++--
 db/Makefile        | 4 ++--
 growfs/Makefile    | 4 ++--
 logprint/Makefile  | 4 ++--
 mdrestore/Makefile | 3 +--
 mkfs/Makefile      | 4 ++--
 repair/Makefile    | 2 +-
 scrub/Makefile     | 4 ++--
 8 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/copy/Makefile b/copy/Makefile
index 1b00cd0d..55160f84 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -9,8 +9,8 @@ LTCOMMAND = xfs_copy
 CFILES = xfs_copy.c
 HFILES = xfs_copy.h
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT) \
-	  $(LIBURCU)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
+	  $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/db/Makefile b/db/Makefile
index 5c017898..b2e01174 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -18,8 +18,8 @@ CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
 	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
-	  $(LIBURCU)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
+	  $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS += -static-libtool-libs
 
diff --git a/growfs/Makefile b/growfs/Makefile
index 08601de7..2f4cc66a 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -9,8 +9,8 @@ LTCOMMAND = xfs_growfs
 
 CFILES = xfs_growfs.c
 
-LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
-	  $(LIBURCU)
+LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
+	  $(LIBPTHREAD)
 
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
diff --git a/logprint/Makefile b/logprint/Makefile
index cdedbd0d..bbbed5d2 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -12,8 +12,8 @@ CFILES = logprint.c \
 	 log_copy.c log_dump.c log_misc.c \
 	 log_print_all.c log_print_trans.c log_redo.c
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
-	  $(LIBURCU)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
+	  $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index 8f28ddab..4a932efb 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -8,8 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_mdrestore
 CFILES = xfs_mdrestore.c
 
-LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID) \
-	  $(LIBURCU)
+LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBUUID) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBFROG)
 LLDFLAGS = -static
 
diff --git a/mkfs/Makefile b/mkfs/Makefile
index 811ba9db..9f6a4fad 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -10,8 +10,8 @@ LTCOMMAND = mkfs.xfs
 HFILES =
 CFILES = proto.c xfs_mkfs.c
 
-LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
-	$(LIBUUID) $(LIBINIH) $(LIBURCU)
+LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
+	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/repair/Makefile b/repair/Makefile
index 47536ca1..2c40e59a 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -72,7 +72,7 @@ CFILES = \
 	xfs_repair.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
-	$(LIBPTHREAD) $(LIBBLKID) $(LIBURCU)
+	$(LIBBLKID) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/scrub/Makefile b/scrub/Makefile
index 849e3afd..fd6bb679 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -71,8 +71,8 @@ spacemap.c \
 vfs.c \
 xfs_scrub.c
 
-LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBICU_LIBS) $(LIBRT) \
-	$(LIBURCU)
+LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBICU_LIBS) $(LIBRT) $(LIBURCU) \
+	$(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
 
-- 
2.31.0

