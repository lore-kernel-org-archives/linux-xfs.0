Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE262C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F29260F9C
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhHBVuk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:50:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhHBVuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 17:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627941029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IRanT4Z3WzLcBCgfoZ3uLI1oBFpL9RD6lC7I2HAteo4=;
        b=eisUS8guieLEFW0xUuc5KQLSdxLyxtSj+W2pB0Y8WpWAlLq6Lp39XMWBSwbePEYBWml2Sk
        wGPrVPcUkFJb0tmmgj88VrFwsPiVyXxl0o+96Jn0xf1JZ6smtZ0teq+OndB7EICrbX2DDf
        rB81zCVbhneqB+t8R3FOZ6eGLpJnNmc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-g8fIBNstOOiSRCijVOZdRg-1; Mon, 02 Aug 2021 17:50:28 -0400
X-MC-Unique: g8fIBNstOOiSRCijVOZdRg-1
Received: by mail-wr1-f72.google.com with SMTP id f6-20020adfe9060000b0290153abe88c2dso6908369wrm.20
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 14:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IRanT4Z3WzLcBCgfoZ3uLI1oBFpL9RD6lC7I2HAteo4=;
        b=ll0JaFoyGrHNuJ8v5jnQxfvHRKyXe7g37w6omG4Q6OS+1D1iE8bqfFUBAEAw009sZX
         NLYWouJfm8kaKVVKrQLFA2FJOLRPILJgcCDAuqhgAkx3TI7KyZvlzSFVu5RP1l5GIi4+
         G1+Gpq+W/A9hGCVv86rB1tMgJv5BJLHYD8v8lPni+xKl7dD9mCQshF92rOKhCTiqgtsf
         z81FHbCi0wBQ7G+hu8vRz6x5PD9CEU3MDI2yVnGdPr66W/OQE1R+jibi9lZd6afvlcfz
         sBmfRsUOSTl54eeyflnzayILtuKyTAgcFKnQ9AjlpBHVVetFWXm5h5xb2bo2E95Thl07
         qNJg==
X-Gm-Message-State: AOAM5335bZKQdik3R0V2pU+UtpKAHKlu7LHNInz+aLjWg2DlOOmf2JT2
        uZBqwfttGK13vr61rPDwuuGc2MBzZ7XXjy2HK9puGuCNrX2pgjB5uynyX9YnLkSppop6mYzdptZ
        caZ04hqxDKye+D+lUOX7ed5uvOykFxH0DUvAeCG1mEaj3kQmRP2mWtybde1C5Nc7ZPneeeLE=
X-Received: by 2002:adf:f446:: with SMTP id f6mr20421623wrp.361.1627941026656;
        Mon, 02 Aug 2021 14:50:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2C/8s7m/czZbSmi8qj34gzAHpy/9jwuf+rgkUdhvCbH0bcIaeJ54wVcbWqbw8x1cQwp2zRg==
X-Received: by 2002:adf:f446:: with SMTP id f6mr20421607wrp.361.1627941026254;
        Mon, 02 Aug 2021 14:50:26 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id u11sm12838418wrt.89.2021.08.02.14.50.25
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:50:25 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfsprogs: Rename platform_defs.h.in -> defs.h.in
Date:   Mon,  2 Aug 2021 23:50:17 +0200
Message-Id: <20210802215024.949616-2-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
References: <20210802215024.949616-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No other platform then linux is supported, so drop the extra "platform_"
from filename.
---
 .gitignore                                |  2 +-
 Makefile                                  | 10 +++++-----
 configure.ac                              |  2 +-
 debian/rules                              |  4 ++--
 include/Makefile                          |  4 ++--
 include/{platform_defs.h.in => defs.h.in} |  6 +++---
 include/libxfs.h                          |  2 +-
 io/bmap.c                                 |  2 +-
 io/bulkstat.c                             |  2 +-
 io/cowextsize.c                           |  2 +-
 io/crc32cselftest.c                       |  2 +-
 io/encrypt.c                              |  2 +-
 io/fiemap.c                               |  2 +-
 io/fsmap.c                                |  2 +-
 io/fsync.c                                |  2 +-
 io/init.c                                 |  2 +-
 io/label.c                                |  2 +-
 io/log_writes.c                           |  2 +-
 io/sync.c                                 |  2 +-
 libfrog/avl64.c                           |  2 +-
 libfrog/bitmap.c                          |  2 +-
 libfrog/convert.c                         |  2 +-
 libfrog/crc32.c                           |  2 +-
 libfrog/fsgeom.c                          |  2 +-
 libfrog/linux.c                           |  2 +-
 libfrog/paths.h                           |  2 +-
 libfrog/projects.h                        |  2 +-
 libfrog/ptvar.c                           |  2 +-
 libfrog/radix-tree.c                      |  2 +-
 libfrog/util.c                            |  2 +-
 libhandle/handle.c                        |  2 +-
 libhandle/jdm.c                           |  2 +-
 libxcmd/command.c                         |  2 +-
 libxcmd/help.c                            |  2 +-
 libxcmd/input.c                           |  2 +-
 libxcmd/quit.c                            |  2 +-
 libxfs/libxfs_priv.h                      |  2 +-
 scrub/common.c                            |  2 +-
 scrub/descr.c                             |  2 +-
 scrub/disk.c                              |  4 ++--
 scrub/fscounters.c                        |  2 +-
 scrub/inodes.c                            |  2 +-
 scrub/xfs_scrub.c                         |  2 +-
 spaceman/health.c                         |  2 +-
 44 files changed, 53 insertions(+), 53 deletions(-)
 rename include/{platform_defs.h.in => defs.h.in} (96%)

diff --git a/.gitignore b/.gitignore
index fd131b6f..59b81d6d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,7 +6,7 @@
 # build system
 .census
 .gitcensus
-/include/platform_defs.h
+/include/defs.h
 /include/builddefs
 /install-sh
 
diff --git a/Makefile b/Makefile
index 0edc2700..296dcc09 100644
--- a/Makefile
+++ b/Makefile
@@ -49,7 +49,7 @@ SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
            m4/ltversion.m4 po/xfsprogs.pot .gitcensus $(CONFIGURE)
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* built .census install.* install-dev.* *.gz *.xz \
-	autom4te.cache/* libtool include/builddefs include/platform_defs.h
+	autom4te.cache/* libtool include/builddefs include/defs.h
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 LDIRDIRT = $(SRCDIR)
@@ -84,7 +84,7 @@ endif
 # include is listed last so it is processed last in clean rules.
 SUBDIRS = $(LIBFROG_SUBDIR) $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
 
-default: include/builddefs include/platform_defs.h
+default: include/builddefs include/defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
@@ -130,7 +130,7 @@ configure: configure.ac
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS
 
-include/platform_defs.h: include/builddefs
+include/defs.h: include/builddefs
 ## Recover from the removal of $@
 	@if test -f $@; then :; else \
 		rm -f include/builddefs; \
@@ -160,14 +160,14 @@ realclean: distclean
 #
 # All this gunk is to allow for a make dist on an unconfigured tree
 #
-dist: include/builddefs include/platform_defs.h default
+dist: include/builddefs include/defs.h default
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
 	$(Q)$(MAKE) $(MAKEOPTS) $(SRCTAR)
 endif
 
-deb: include/builddefs include/platform_defs.h
+deb: include/builddefs include/defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
diff --git a/configure.ac b/configure.ac
index e1775ed9..b328ccb5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_SRCDIR([include/libxfs.h])
-AC_CONFIG_HEADER(include/platform_defs.h)
+AC_CONFIG_HEADER(include/defs.h)
 AC_PREFIX_DEFAULT(/usr)
 
 AC_PROG_INSTALL
diff --git a/debian/rules b/debian/rules
index fe9a1c3a..700df898 100755
--- a/debian/rules
+++ b/debian/rules
@@ -44,14 +44,14 @@ config: .census
 	$(checkdir)
 	AUTOHEADER=/bin/true dh_autoreconf
 	dh_update_autotools_config
-	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
+	$(options) $(MAKE) $(PMAKEFLAGS) include/defs.h
 	touch .census
 
 dibuild:
 	$(checkdir)
 	@echo "== dpkg-buildpackage: installer" 1>&2
 	if [ ! -f mkfs/mkfs.xfs-$(bootpkg) ]; then \
-		$(diopts) $(MAKE) include/platform_defs.h; \
+		$(diopts) $(MAKE) include/defs.h; \
 		mkdir -p include/xfs; \
 		for dir in include libxfs; do \
 			$(MAKE) $(PMAKEFLAGS) -C $$dir NODEP=1 install-headers; \
diff --git a/include/Makefile b/include/Makefile
index 632b819f..8e14ffae 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -27,7 +27,7 @@ LIBHFILES = libxfs.h \
 	xfs_trans.h \
 	command.h \
 	input.h \
-	platform_defs.h
+	defs.h
 
 HFILES = handle.h \
 	jdm.h \
@@ -37,7 +37,7 @@ HFILES = handle.h \
 	xfs_fs_compat.h \
 	xfs_arch.h
 
-LSRCFILES = platform_defs.h.in builddefs.in buildmacros buildrules install-sh
+LSRCFILES = defs.h.in builddefs.in buildmacros buildrules install-sh
 LSRCFILES += $(DKHFILES) $(LIBHFILES)
 LDIRT = disk
 LDIRDIRT = xfs
diff --git a/include/platform_defs.h.in b/include/defs.h.in
similarity index 96%
rename from include/platform_defs.h.in
rename to include/defs.h.in
index 539bdbec..ce0c1a0e 100644
--- a/include/platform_defs.h.in
+++ b/include/defs.h.in
@@ -3,8 +3,8 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#ifndef __XFS_PLATFORM_DEFS_H__
-#define __XFS_PLATFORM_DEFS_H__
+#ifndef __XFS_DEFS_H__
+#define __XFS_DEFS_H__
 
 #include <stdio.h>
 #include <errno.h>
@@ -112,4 +112,4 @@ static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
 		sizeof(*(p)->member) + __must_be_array((p)->member),	\
 		sizeof(*(p)))
 
-#endif	/* __XFS_PLATFORM_DEFS_H__ */
+#endif	/* __XFS_DEFS_H__ */
diff --git a/include/libxfs.h b/include/libxfs.h
index bc07655e..af1feedb 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -8,7 +8,7 @@
 #define __LIBXFS_H__
 
 #include "libxfs_api_defs.h"
-#include "platform_defs.h"
+#include "defs.h"
 #include "xfs.h"
 
 #include "list.h"
diff --git a/io/bmap.c b/io/bmap.c
index 27383ca6..31a27848 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 201470b2..f1a8113e 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -4,7 +4,7 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "init.h"
 #include "libfrog/logging.h"
diff --git a/io/cowextsize.c b/io/cowextsize.c
index f6b134df..86496bb3 100644
--- a/io/cowextsize.c
+++ b/io/cowextsize.c
@@ -9,7 +9,7 @@
  * build with the internal definition of struct fsxattr, which has
  * fsx_cowextsize.
  */
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "init.h"
 #include "io.h"
diff --git a/io/crc32cselftest.c b/io/crc32cselftest.c
index f8f757f6..3ae8b98a 100644
--- a/io/crc32cselftest.c
+++ b/io/crc32cselftest.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "init.h"
 #include "io.h"
diff --git a/io/encrypt.c b/io/encrypt.c
index 1b347dc1..8d733363 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -7,7 +7,7 @@
 #ifdef OVERRIDE_SYSTEM_FSCRYPT_ADD_KEY_ARG
 #  define fscrypt_add_key_arg sys_fscrypt_add_key_arg
 #endif
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "init.h"
 #include "libfrog/paths.h"
diff --git a/io/fiemap.c b/io/fiemap.c
index f0c74dfe..00bf5ec7 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "input.h"
 #include <linux/fiemap.h>
diff --git a/io/fsmap.c b/io/fsmap.c
index 4b217595..5cfb7794 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "init.h"
 #include "libfrog/paths.h"
diff --git a/io/fsync.c b/io/fsync.c
index b425b612..0ba2fa6f 100644
--- a/io/fsync.c
+++ b/io/fsync.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "init.h"
 #include "io.h"
diff --git a/io/init.c b/io/init.c
index 033ed67d..0fbc703e 100644
--- a/io/init.c
+++ b/io/init.c
@@ -5,7 +5,7 @@
  */
 
 #include <pthread.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/label.c b/io/label.c
index 890ddde4..25b4adfb 100644
--- a/io/label.c
+++ b/io/label.c
@@ -4,7 +4,7 @@
  */
 
 #include <sys/ioctl.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "libxfs.h"
 #include "libfrog/paths.h"
 #include "command.h"
diff --git a/io/log_writes.c b/io/log_writes.c
index 20049d18..0e24705e 100644
--- a/io/log_writes.c
+++ b/io/log_writes.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include <libdevmapper.h>
 #include "command.h"
 #include "init.h"
diff --git a/io/sync.c b/io/sync.c
index 89f787ec..40c88531 100644
--- a/io/sync.c
+++ b/io/sync.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "init.h"
 #include "io.h"
diff --git a/libfrog/avl64.c b/libfrog/avl64.c
index 2547bf3b..456c20e2 100644
--- a/libfrog/avl64.c
+++ b/libfrog/avl64.c
@@ -5,7 +5,7 @@
  */
 #include <stdint.h>
 #include <stdio.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "avl64.h"
 
 #define CERT	ASSERT
diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 5af5ab8d..3081ecf6 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -8,7 +8,7 @@
 #include <stdlib.h>
 #include <assert.h>
 #include <pthread.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "avl64.h"
 #include "list.h"
 #include "bitmap.h"
diff --git a/libfrog/convert.c b/libfrog/convert.c
index 0ceeb389..6211e192 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2003-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "platform_defs.h"
+#include "defs.h"
 #include "input.h"
 #include <ctype.h>
 #include <stdbool.h>
diff --git a/libfrog/crc32.c b/libfrog/crc32.c
index 526ce950..c7f9c24b 100644
--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -32,7 +32,7 @@
 #include <inttypes.h>
 #include <asm/types.h>
 #include <sys/time.h>
-#include "platform_defs.h"
+#include "defs.h"
 /* For endian conversion routines */
 #include "xfs_arch.h"
 #include "crc32defs.h"
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 4f1a1842..62313c6b 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc. All Rights Reserved.
  */
-#include "platform_defs.h"
+#include "defs.h"
 #include "xfs.h"
 #include "bitops.h"
 #include "fsgeom.h"
diff --git a/libfrog/linux.c b/libfrog/linux.c
index a45d99ab..ea69b29b 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -9,7 +9,7 @@
 #include <sys/ioctl.h>
 #include <sys/sysinfo.h>
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "xfs.h"
 #include "init.h"
 
diff --git a/libfrog/paths.h b/libfrog/paths.h
index c08e3733..01ca1e29 100644
--- a/libfrog/paths.h
+++ b/libfrog/paths.h
@@ -6,7 +6,7 @@
 #ifndef __LIBFROG_PATH_H__
 #define __LIBFROG_PATH_H__
 
-#include "platform_defs.h"
+#include "defs.h"
 
 /*
  * XFS Filesystem Paths
diff --git a/libfrog/projects.h b/libfrog/projects.h
index 77919474..52c5cd33 100644
--- a/libfrog/projects.h
+++ b/libfrog/projects.h
@@ -6,7 +6,7 @@
 #ifndef __LIBFROG_PROJECTS_H__
 #define __LIBFROG_PROJECTS_H__
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "xfs.h"
 
 extern int setprojid(const char *__name, int __fd, prid_t __id);
diff --git a/libfrog/ptvar.c b/libfrog/ptvar.c
index 7ac8c541..95e0eb15 100644
--- a/libfrog/ptvar.c
+++ b/libfrog/ptvar.c
@@ -10,7 +10,7 @@
 #include <assert.h>
 #include <pthread.h>
 #include <unistd.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "ptvar.h"
 
 /*
diff --git a/libfrog/radix-tree.c b/libfrog/radix-tree.c
index 261fc248..d07af105 100644
--- a/libfrog/radix-tree.c
+++ b/libfrog/radix-tree.c
@@ -8,7 +8,7 @@
 #include <string.h>
 #include <errno.h>
 #include <stdint.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "radix-tree.h"
 
 #ifndef ARRAY_SIZE
diff --git a/libfrog/util.c b/libfrog/util.c
index 8fb10cf8..8ab901f9 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "platform_defs.h"
+#include "defs.h"
 #include "util.h"
 
 /*
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 27abc6b2..dbf56aba 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -5,7 +5,7 @@
  */
 
 #include <libgen.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "xfs.h"
 #include "handle.h"
 #include "parent.h"
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index 07b0c609..d8f0efc0 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "xfs.h"
 #include "handle.h"
 #include "jdm.h"
diff --git a/libxcmd/command.c b/libxcmd/command.c
index a76d1515..7e37a9d6 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "input.h"
 
diff --git a/libxcmd/help.c b/libxcmd/help.c
index b7e02073..09359dc0 100644
--- a/libxcmd/help.c
+++ b/libxcmd/help.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "../quota/init.h"
 
diff --git a/libxcmd/input.c b/libxcmd/input.c
index e3fa626a..83b5a67d 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "input.h"
 #include <ctype.h>
 #include <stdbool.h>
diff --git a/libxcmd/quit.c b/libxcmd/quit.c
index 7c2d04f8..037b032c 100644
--- a/libxcmd/quit.c
+++ b/libxcmd/quit.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
+#include "defs.h"
 #include "command.h"
 #include "../quota/init.h"
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e37d5933..2815c79f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -38,7 +38,7 @@
 #define __LIBXFS_INTERNAL_XFS_H__
 
 #include "libxfs_api_defs.h"
-#include "platform_defs.h"
+#include "defs.h"
 #include "xfs.h"
 
 #include "list.h"
diff --git a/scrub/common.c b/scrub/common.c
index 49a87f41..66be3f18 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -7,7 +7,7 @@
 #include <pthread.h>
 #include <sys/statvfs.h>
 #include <syslog.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/descr.c b/scrub/descr.c
index e694d01d..ffd57abe 100644
--- a/scrub/descr.c
+++ b/scrub/descr.c
@@ -6,7 +6,7 @@
 #include "xfs.h"
 #include <assert.h>
 #include <sys/statvfs.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "input.h"
 #include "libfrog/paths.h"
 #include "libfrog/ptvar.h"
diff --git a/scrub/disk.c b/scrub/disk.c
index a1ef798a..8bd2a36d 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -16,13 +16,13 @@
 #ifdef HAVE_HDIO_GETGEO
 # include <linux/hdreg.h>
 #endif
-#include "platform_defs.h"
+#include "defs.h"
 #include "libfrog/util.h"
 #include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "disk.h"
-#include "platform_defs.h"
+#include "defs.h"
 
 #ifndef BLKROTATIONAL
 # define BLKROTATIONAL	_IO(0x12, 126)
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index f21b24e0..ef197687 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -7,7 +7,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "xfs_arch.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
diff --git a/scrub/inodes.c b/scrub/inodes.c
index cc73da7f..f4f154da 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -8,7 +8,7 @@
 #include <stdlib.h>
 #include <pthread.h>
 #include <sys/statvfs.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "xfs_arch.h"
 #include "handle.h"
 #include "libfrog/paths.h"
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index bc2e84a7..afd2b3c1 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -10,7 +10,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <sys/statvfs.h>
-#include "platform_defs.h"
+#include "defs.h"
 #include "input.h"
 #include "libfrog/paths.h"
 #include "xfs_scrub.h"
diff --git a/spaceman/health.c b/spaceman/health.c
index d83c5ccd..85a73c82 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2019 Oracle.
  * All Rights Reserved.
  */
-#include "platform_defs.h"
+#include "defs.h"
 #include "libxfs.h"
 #include "command.h"
 #include "init.h"
-- 
2.31.1

