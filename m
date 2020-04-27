Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35B5C54FD0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 07:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A02A2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 07:26:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oviVWupH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgD0H0H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 03:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgD0H0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 03:26:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8218C061A0F
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 00:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=FJnoAc6zM0f5DLJoB3Aq0M9ZXo2RIiaMm8auWbZn8yE=; b=oviVWupH8681ukmHSAkXaM7l9d
        GegACA4S0j2o4QeXpQUgwIHcY523JYruTqAByNosoz6nsgBawPcDF3LmcX1fw3CJBO/W9iTIEXCeC
        PtXBK/FO5Sx6IRtKNMoJhb0uvEUnSvG69UcvpzdN7B9kfdkQoLYWbsizHVIZALpEPqL3BCj5k570r
        t9hiGR7D0HE7NM7j9e2NRtsDtuapg33DjDdTUbvcPEus18c4S+mDO6cPCZDWg3EbYvam/EGgBznXS
        vHLANPb53wUrVPlKd3Lk65u6X2MFvJ6ikaHqTzCHOj4mFDvLo79TVMtYWnQw0yJ3H1+NG5oXeZdFK
        2MAtkVkw==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSy9W-00040Z-1h; Mon, 27 Apr 2020 07:26:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfsprogs: remove libreadline support
Date:   Mon, 27 Apr 2020 09:26:03 +0200
Message-Id: <20200427072603.1238216-1-hch@lst.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

libreadline has been relicensed to GPLv3 and thus incompatible to
xfsprogs many years ago, and all the distros have dropped or are
in the stages of dropping the last GPLv2 version.  As the BSD
licensed libeditline provides the same functionality there is no
need to keep the obsolete libreadline support around.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac         |  7 -------
 db/Makefile          |  5 -----
 db/input.c           | 26 ++------------------------
 growfs/Makefile      |  3 ---
 include/builddefs.in |  2 --
 io/Makefile          |  4 ----
 libxcmd/Makefile     |  5 -----
 libxcmd/input.c      | 18 ++----------------
 quota/Makefile       |  5 -----
 spaceman/Makefile    |  4 ----
 10 files changed, 4 insertions(+), 75 deletions(-)

diff --git a/configure.ac b/configure.ac
index c609ff6a..0d1ca43e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -42,13 +42,6 @@ AC_ARG_ENABLE(blkid,
 	enable_blkid=yes)
 AC_SUBST(enable_blkid)
 
-AC_ARG_ENABLE(readline,
-[  --enable-readline=[yes/no] Enable readline command editing [default=no]],
-	test $enable_readline = yes && libreadline="-lreadline",
-	enable_readline=no)
-AC_SUBST(libreadline)
-AC_SUBST(enable_readline)
-
 AC_ARG_ENABLE(editline,
 [  --enable-editline=[yes/no] Enable editline command editing [default=no]],
 	test $enable_editline = yes && libeditline="-ledit",
diff --git a/db/Makefile b/db/Makefile
index ed9f56c2..9bd9bf51 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -21,11 +21,6 @@ LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS += -static-libtool-libs
 
-ifeq ($(ENABLE_READLINE),yes)
-LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
-CFLAGS += -DENABLE_READLINE
-endif
-
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 CFLAGS += -DENABLE_EDITLINE
diff --git a/db/input.c b/db/input.c
index 4d6c7376..553025bc 100644
--- a/db/input.c
+++ b/db/input.c
@@ -13,10 +13,7 @@
 #include "malloc.h"
 #include "init.h"
 
-#if defined(ENABLE_READLINE)
-# include <readline/history.h>
-# include <readline/readline.h>
-#elif defined(ENABLE_EDITLINE)
+#ifdef ENABLE_EDITLINE
 # include <histedit.h>
 #endif
 
@@ -211,26 +208,7 @@ fetchline_internal(void)
 	return rval;
 }
 
-#ifdef ENABLE_READLINE
-char *
-fetchline(void)
-{
-	char	*line;
-
-	if (inputstacksize == 1) {
-		line = readline(get_prompt());
-		if (!line)
-			dbprintf("\n");
-		else if (line && *line) {
-			add_history(line);
-			logprintf("%s", line);
-		}
-	} else {
-		line = fetchline_internal();
-	}
-	return line;
-}
-#elif defined(ENABLE_EDITLINE)
+#ifdef ENABLE_EDITLINE
 static char *el_get_prompt(EditLine *e) { return get_prompt(); }
 char *
 fetchline(void)
diff --git a/growfs/Makefile b/growfs/Makefile
index 4104cc0d..a107d348 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -10,9 +10,6 @@ LTCOMMAND = xfs_growfs
 CFILES = xfs_growfs.c
 
 LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
-ifeq ($(ENABLE_READLINE),yes)
-LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
-endif
 
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
diff --git a/include/builddefs.in b/include/builddefs.in
index 6ed9d295..30b2727a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -25,7 +25,6 @@ LIBUUID = @libuuid@
 LIBPTHREAD = @libpthread@
 LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
-LIBREADLINE = @libreadline@
 LIBBLKID = @libblkid@
 LIBDEVMAPPER = @libdevmapper@
 LIBXFS = $(TOPDIR)/libxfs/libxfs.la
@@ -82,7 +81,6 @@ RPM_VERSION	= @rpm_version@
 ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
-ENABLE_READLINE	= @enable_readline@
 ENABLE_BLKID	= @enable_blkid@
 ENABLE_SCRUB	= @enable_scrub@
 
diff --git a/io/Makefile b/io/Makefile
index 1112605e..71741926 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -68,10 +68,6 @@ ifeq ($(HAVE_SYNCFS),yes)
 LCFLAGS += -DHAVE_SYNCFS
 endif
 
-ifeq ($(ENABLE_READLINE),yes)
-LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
-endif
-
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index f9bc1c5c..70e54308 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -14,11 +14,6 @@ LTLDFLAGS += -static
 
 CFILES = command.c input.c help.c quit.c
 
-ifeq ($(ENABLE_READLINE),yes)
-LCFLAGS += -DENABLE_READLINE
-LTLIBS += $(LIBREADLINE) $(LIBTERMCAP)
-endif
-
 ifeq ($(ENABLE_EDITLINE),yes)
 LCFLAGS += -DENABLE_EDITLINE
 LTLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
diff --git a/libxcmd/input.c b/libxcmd/input.c
index 137856e3..203110df 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -9,10 +9,7 @@
 #include <ctype.h>
 #include <stdbool.h>
 
-#if defined(ENABLE_READLINE)
-# include <readline/history.h>
-# include <readline/readline.h>
-#elif defined(ENABLE_EDITLINE)
+#ifdef ENABLE_EDITLINE
 # include <histedit.h>
 #endif
 
@@ -28,18 +25,7 @@ get_prompt(void)
 	return prompt;
 }
 
-#if defined(ENABLE_READLINE)
-char *
-fetchline(void)
-{
-	char	*line;
-
-	line = readline(get_prompt());
-	if (line && *line)
-		add_history(line);
-	return line;
-}
-#elif defined(ENABLE_EDITLINE)
+#ifdef ENABLE_EDITLINE
 static char *el_get_prompt(EditLine *e) { return get_prompt(); }
 char *
 fetchline(void)
diff --git a/quota/Makefile b/quota/Makefile
index 384f023a..da5a1489 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -14,11 +14,6 @@ LLDLIBS = $(LIBXCMD) $(LIBFROG)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
-ifeq ($(ENABLE_READLINE),yes)
-LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
-CFLAGS += -DENABLE_READLINE
-endif
-
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 CFLAGS += -DENABLE_EDITLINE
diff --git a/spaceman/Makefile b/spaceman/Makefile
index d01aa74a..2a366918 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -14,10 +14,6 @@ LLDLIBS = $(LIBXCMD) $(LIBFROG)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
-ifeq ($(ENABLE_READLINE),yes)
-LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
-endif
-
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
-- 
2.26.1

