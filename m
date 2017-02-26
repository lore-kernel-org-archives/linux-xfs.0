Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150242.b2b57rjcmbjckjnf@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33949 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752031AbdBZLPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Feb 2017 06:15:48 -0500
Received: by mail-wr0-f193.google.com with SMTP id m5so1200701wrm.1
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2017 03:15:29 -0800 (PST)
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH] build: add EXTRALIBS to link with
Date: Sun, 26 Feb 2017 12:15:22 +0100
Message-Id: <1488107722-15022-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, Waldemar Brodkorb <wbx@openadk.org>

When doing a uClibc static build, the build fails to link:
    http://autobuild.buildroot.org/results/503/50314716a9f72e8bb238e52e9dc342c68f7e0b8b/build-end.log

The cause is due to:
  - xfsprogs links dome programs with util-linux' libblkid
  - util-linux' libblkid is linked to util-linux' libuuid
  - util-linux' libuuid uses i18n functions when locales are enabled
  - uClibc does not provide i18n functions
  - i18n functions are provided by libintl from libintl from gettext

util-linux installs pkg-config files for thos two libs. However,
xfsprogs does not use pkg-config to find libblkid or libuuid, thus it
misses the Libs.private field from libuid.

In this case, it is necessary to pass LIBS=-lintl at configure time, so
that configure correctly finds libblkid.

Still, this is not enough, because the build will not use LIBS during
the link phase.

We fix that last bit by adding EXTRALIBS to the libraries to link with,
so that it is possible to pass EXTRALIBS=-lintl at build time:

    $ ./configure [...] LIBS=-lintl
    $ make EXTRALIBS=-lintl

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Waldemar Brodkorb <wbx@openadk.org>
---
 include/buildmacros | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/buildmacros b/include/buildmacros
index a7c5d8a..dd62d80 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -11,7 +11,7 @@ BUILDRULES = $(TOPDIR)/include/buildrules
 
 LDFLAGS += $(LOADERFLAGS) $(LLDFLAGS)
 LTLDFLAGS += $(LOADERFLAGS)
-LDLIBS = $(LLDLIBS) $(PLDLIBS) $(MALLOCLIB)
+LDLIBS = $(LLDLIBS) $(PLDLIBS) $(MALLOCLIB) $(EXTRALIBS)
 
 MAKEOPTS = --no-print-directory Q=$(Q)
 SRCFILES = Makefile $(HFILES) $(CFILES) $(LSRCFILES) $(LFILES) $(YFILES)
-- 
2.7.4

