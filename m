Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33862 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdALROx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 12:14:53 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1437E5CCE4A
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2017 11:14:07 -0600 (CST)
Subject: [PATCH 2/3] build: add .tar.xz target
References: <056383cb-cf7e-3880-aecf-d97d5516a60f@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d8bdc1f2-af99-f7fd-659b-45f7ebf36efb@sandeen.net>
Date: Thu, 12 Jan 2017 11:14:52 -0600
MIME-Version: 1.0
In-Reply-To: <056383cb-cf7e-3880-aecf-d97d5516a60f@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

kup generates .xz files, and Fedora RPMs now use that.
It'd be nice to have a handy target to generate .xz
files locally, so hack that in.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I imagine there's a prettier way with wildcards or
templates or whatnot, but my Make is rusty.

 Makefile | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 84dc62c..6e45733 100644
--- a/Makefile
+++ b/Makefile
@@ -26,18 +26,19 @@ endif
 
 SRCDIR = $(PKG_NAME)-$(PKG_VERSION)
 SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
+SRCTARXZ = $(PKG_NAME)-$(PKG_VERSION).tar.xz
 
 CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
 LSRCFILES = configure.ac release.sh README VERSION $(CONFIGURE)
 SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
            m4/ltversion.m4 po/xfsprogs.pot .gitcensus $(CONFIGURE)
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
-	conftest* built .census install.* install-dev.* *.gz \
+	conftest* built .census install.* install-dev.* *.gz *.xz \
 	autom4te.cache/* libtool include/builddefs include/platform_defs.h
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 LDIRDIRT = $(SRCDIR)
-LDIRT += $(SRCTAR)
+LDIRT += $(SRCTAR) $(SRCTARXZ)
 endif
 
 # header install rules to populate include/xfs correctly
@@ -165,6 +166,11 @@ $(SRCTAR) : default $(SRCTARINC) .gitcensus
 	   `cat .gitcensus` $(SRCTARINC)
 	echo Wrote: $@
 
+$(SRCTARXZ) : default $(SRCTARINC) .gitcensus
+	$(Q)$(TAR) --transform "s,^,$(SRCDIR)/," -Jcf $(SRCDIR).tar.xz  \
+	   `cat .gitcensus` $(SRCTARINC)
+	echo Wrote: $@
+
 .gitcensus: $(_FORCE)
 	$(Q)if test -d .git; then \
 	  git ls-files > .gitcensus && echo "new .gitcensus"; \
-- 
1.8.3.1

