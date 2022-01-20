Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDB7C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357683AbiATARb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344962AbiATAR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:17:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B944C06161C
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:17:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AE8B614F4
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84905C004E1;
        Thu, 20 Jan 2022 00:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637848;
        bh=TjxJAMg6xpzzmPzyhTPLRMGSBNvC6IFMV/8k8wWGkog=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RT0Va1URL29Ft59JGUK3KiiTPghu0nCSd8tmMm84nR9irfA7seuPLc1q1o8exz5zg
         6//+TVyjkkuiXRwnvBwUl+8i5RpZIDM45FfB0oVRFvOe30raywEDPylnB5F6NXC5Bl
         5GGcX/vKsK8zpCwGphREzWjt/aqsuigGveh/iNvJiR5eJZs2YidNI3wI73cEJQm/ew
         Qwhf0YJDuemZf8rCF+qfwO5pRC5cFdFNNre7Sx2wkTb2WQ+nvwDwcZhWFV2Ve3IUOm
         RLq0EhrNgpEFFT7+0fshHBynwHtnLZYAsSxRyYNi/Sb5EF29X6cYIec5Y7Evt1smIo
         0RePGtcmPfbkQ==
Subject: [PATCH 01/45] xfsprogs: fix static build problems caused by liburcu
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:17:28 -0800
Message-ID: <164263784824.860211.4356217439516535488.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

The liburcu library has a dependency on pthreads.  Hence, in order for
static builds of xfsprogs to work, $(LIBPTHREAD) needs to appear
*after* $(LUBURCU) in LLDLIBS.  Otherwise, static links of xfs_* will
fail due to undefined references of pthread_create, pthread_exit,
et. al.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/Makefile      |    4 ++--
 db/Makefile        |    4 ++--
 growfs/Makefile    |    4 ++--
 logprint/Makefile  |    4 ++--
 mdrestore/Makefile |    3 +--
 mkfs/Makefile      |    4 ++--
 repair/Makefile    |    2 +-
 scrub/Makefile     |    4 ++--
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
 

