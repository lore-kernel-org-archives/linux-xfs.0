Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8908ABA37
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980084; cv=none; b=GxPXTiVrbEFlG/jTzqwasKlZaW9RclgdMYeEr14Bp0Rs1A1o7Bz/jqGwEbxmvO+ZZRKcawd/SIJhjoIH9K58p7lQuRwb7drbOQiiafPR9yxIAJvCJlR3cEDemLm8TihYyYpdeuGzKvBX+OMOEVJ8TKjQ0xEbnLZHoNm7vvI3Ui4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980084; c=relaxed/simple;
	bh=OhQw3+kGeo7kyEtl3Dfs+71bsLYKX0JreBGLjFfl+o4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A5DXyEDA8KJq6I0GWwy3zNnCTyMcwNwscSpaLQjaIEQeMMuZ8M4MD3Hp9eDeEJw6uT0YxulaqASH/E/+yk7/aNNjSsndngtUkycOyA9seBMe0edagCmUIgEY/WPrIJYtJOqyMUlW4JxhGokyTgzvCnNj/+t/w9reoaQQXcNsSUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4gzVYhpP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4gzVYhpP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FS8dMg9cHaEYmsuf7FHsADVaMEeDLpVGvqLx4GxNRK0=; b=4gzVYhpP4gqwgy+X7l5sQdzkPb
	JjPbZYZAuwltqq4nZawhHzE+KmyLFPW1M0biPXX2ISRXV1kEzsHP250jKymwG7Sr1jdwGO4Qc0hn4
	NIe01/e3RFs9J5SJJZ+fdK91QATP2SWCYu1hUwK1ojBmA+RZ2YCSUVdpi99oCN7Sg8Yikyed/1SpO
	FpgTGac2URDd8SVtvSCdXsHkv+TymnMbevPYUz18xAMAAFnrFuXXRexKGTiS8hDIcU2ol86UOEHth
	kWvQ1/cCHynq4xgtPMOQtuRCt/gQJevTgoIEFPGCBz4BkiUYFCnV/jwZH8ecqUCJNsJMHTBB2IK10
	Q63/Xi2A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVdq-0000000F9CL-3ou4;
	Thu, 15 Feb 2024 06:54:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 05/26] include: stop generating platform_defs.h
Date: Thu, 15 Feb 2024 07:54:03 +0100
Message-Id: <20240215065424.2193735-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215065424.2193735-1-hch@lst.de>
References: <20240215065424.2193735-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
index 8e7e8b2ed..127bd90ef 100644
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

