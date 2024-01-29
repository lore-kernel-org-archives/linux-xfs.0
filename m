Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113F24F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513554; cv=none; b=uKWqM3JOnFBTeU/XxB9sXw1fS/UpZqhaQvhjo14kYCv3MOLC5hFx//mh6Z9IKMxIkVpZdbjPPUeIXIxhYA90rA00MR5WvdGc11crUD4u8d2T2JFpe5JRf+NuYfQo4TLz8+biM33hSFZDSanYxwdf+T/VY88S+UQRxcWuFmqM0+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513554; c=relaxed/simple;
	bh=S8TwuoUPt5k6zelpTX0oc58CbTWdKyfwzoet7tROUz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nykfTcMWBj1Z2akzrQZQg1xqzrZBts1X2DNID6Igejid7CnXRRcJMLh9HV4HMyNVXjqAimhByl+lVpcV9OhuV/XBQG6wCElBzGssY8LJv+3rDli8vajRlm4BJLRuTM3bVW63UkEeAnCrYi7LnpeADh1Wqqdnr+YsQrsaMhg8WqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o9qIxDRp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o9qIxDRp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4I7Jvkjbvw6oksiovZdZO76Ox3H7+Z2jkrId6Y4zo8o=; b=o9qIxDRpvb3Nu/1x0EgOiy3hFW
	gU8rOjsz+UK8nOHQ6bfOwBLz+14O1xkE2tqSwT9gaFCdr78uwfBANpu3YO6Eh7VwBguXrVqLzDC3+
	sj2Jd38i8ryFd12kIfQPUHlLI6+TGGv/tOQ7mNoal71Qj1hjVFssuT5+KQjLJgpaQp729BAOM9Ggw
	J4DUdQ4PbFwImCJQnsVnrHlCK/nkG+L3UPcUP73W+A3QdVestDsdUzvU2yT6vDffo70rPJ2wtwMmF
	RyXyWQrQ/YpGEaHNRW7EB4Ot0A9mpk1JNohJL0cj0OpIT/vGegILMljoKjzpB9XUmD45iQCTm7qdk
	Dw0NkhDg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM87-0000000Bcbt-0wmv;
	Mon, 29 Jan 2024 07:32:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/27] include: stop generating platform_defs.h
Date: Mon, 29 Jan 2024 08:31:53 +0100
Message-Id: <20240129073215.108519-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129073215.108519-1-hch@lst.de>
References: <20240129073215.108519-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Now that the sizeof checks are gone, we can stop generating platform_defs.h.
The only caveat is that we need to stop undefining ENABLE_GETTEXT, which the
generation process had removed before.  The actual ENABLE_GETTEXT will be
passd on the compiler command line, just like other ENABLE or HAVE values
from autoconf.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Makefile                                        | 15 ++++-----------
 configure.ac                                    |  1 -
 include/{platform_defs.h.in => platform_defs.h} |  1 -
 3 files changed, 4 insertions(+), 13 deletions(-)
 rename include/{platform_defs.h.in => platform_defs.h} (99%)

diff --git a/Makefile b/Makefile
index c12df98db..4e768526c 100644
--- a/Makefile
+++ b/Makefile
@@ -49,7 +49,7 @@ SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
            m4/ltversion.m4 po/xfsprogs.pot .gitcensus $(CONFIGURE)
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* built .census install.* install-dev.* *.gz *.xz \
-	autom4te.cache/* libtool include/builddefs include/platform_defs.h
+	autom4te.cache/* libtool include/builddefs
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 LDIRDIRT = $(SRCDIR)
@@ -76,7 +76,7 @@ endif
 # include is listed last so it is processed last in clean rules.
 SUBDIRS = $(LIBFROG_SUBDIR) $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
 
-default: include/builddefs include/platform_defs.h
+default: include/builddefs
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
@@ -116,13 +116,6 @@ configure: configure.ac
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS
 
-include/platform_defs.h: include/builddefs
-## Recover from the removal of $@
-	@if test -f $@; then :; else \
-		rm -f include/builddefs; \
-		$(MAKE) $(MAKEOPTS) $(AM_MAKEFLAGS) include/builddefs; \
-	fi
-
 install: $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
 	$(INSTALL) -m 644 README $(PKG_DOC_DIR)
@@ -146,14 +139,14 @@ realclean: distclean
 #
 # All this gunk is to allow for a make dist on an unconfigured tree
 #
-dist: include/builddefs include/platform_defs.h default
+dist: include/builddefs default
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
 	$(Q)$(MAKE) $(MAKEOPTS) $(SRCTAR)
 endif
 
-deb: include/builddefs include/platform_defs.h
+deb: include/builddefs
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
diff --git a/configure.ac b/configure.ac
index e4da95638..3e40931b1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,6 @@ AC_PREREQ([2.69])
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_SRCDIR([include/libxfs.h])
-AC_CONFIG_HEADERS([include/platform_defs.h])
 AC_PREFIX_DEFAULT(/usr)
 
 AC_PROG_INSTALL
diff --git a/include/platform_defs.h.in b/include/platform_defs.h
similarity index 99%
rename from include/platform_defs.h.in
rename to include/platform_defs.h
index dce7154cd..c01d4c426 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h
@@ -31,7 +31,6 @@
 typedef unsigned short umode_t;
 
 /* Define if you want gettext (I18N) support */
-#undef ENABLE_GETTEXT
 #ifdef ENABLE_GETTEXT
 # include <libintl.h>
 # define _(x)                   gettext(x)
-- 
2.39.2

