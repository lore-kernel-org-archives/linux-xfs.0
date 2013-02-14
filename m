Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 548948018
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 11:31:24 -0600 (CST)
Date: Thu, 14 Feb 2013 11:31:20 -0600
From: Ben Myers <bpm@sgi.com>
Subject: xfsdump: update 'make deb' to use tarball archive
Message-ID: <20130214173120.GF22182@sgi.com>
References: <20130214010853.GD22182@sgi.com>
	<1295709208.2558271.1360808077935.JavaMail.root@redhat.com>
	<20130214162454.GH30652@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130214162454.GH30652@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@debian.org>
Cc: Andrew Dahl <adahl@sgi.com>, xfs@oss.sgi.com

This patch changes the build process so that 'make deb' uses the same
process of creating a source tree as the release script.

* Add a list of files which go in the release tarball in .gitcensus
  This is needed so that you can create a tarball in a bare release
  tree, when .git is not available.

* Modify the SRCTAR target to include files from .gitcensus and use tar
  instead of git archive.

* Modify the SRCTARINC files to include .gitcensus, and include
  .gitcensus in the 'make realclean' target.

* remove the 'make source-link' target.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 .gitignore         |    1 +
 Makefile           |   23 ++++++++++++-----------
 include/buildrules |   11 -----------
 3 files changed, 13 insertions(+), 22 deletions(-)

Index: b/.gitignore
===================================================================
--- a/.gitignore	2013-02-14 10:55:13.061985803 -0600
+++ b/.gitignore	2013-02-14 10:55:49.061340568 -0600
@@ -4,6 +4,7 @@
 
 # build system
 .census
+.gitcensus
 /include/config.h
 /include/builddefs
 /install-sh
Index: b/Makefile
===================================================================
--- a/Makefile	2013-02-14 10:55:06.961977139 -0600
+++ b/Makefile	2013-02-14 10:59:19.131340450 -0600
@@ -30,7 +30,7 @@ SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.
 CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
 LSRCFILES = configure.ac release.sh README VERSION $(CONFIGURE)
 SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
-            m4/ltversion.m4 $(CONFIGURE)
+            m4/ltversion.m4 .gitcensus $(CONFIGURE)
 
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* built .census install.* install-dev.* *.gz \
@@ -100,7 +100,7 @@ distclean: clean
 	rm -f $(LDIRT)
 
 realclean: distclean
-	rm -f $(CONFIGURE)
+	rm -f $(CONFIGURE) .gitcensus
 
 #
 # All this gunk is to allow for a make dist on an unconfigured tree
@@ -117,18 +117,19 @@ ifeq ($(HAVE_BUILDDEFS), no)
 	$(MAKE) $(MAKEOPTS) -C . $@
 else
 	$(Q)$(MAKE) $(MAKEOPTS) $(SRCDIR)
-	$(Q)$(MAKE) $(MAKEOPTS) -C po
-	$(Q)$(MAKE) $(MAKEOPTS) source-link
 	$(Q)cd $(SRCDIR) && dpkg-buildpackage
 endif
 
-$(SRCDIR) : $(_FORCE)
+$(SRCDIR) : $(_FORCE) $(SRCTAR)
 	rm -fr $@
-	mkdir -p $@
+	$(Q)$(TAR) -zxvf $(SRCTAR)
 
-$(SRCTAR) : default
-	$(Q)git archive --prefix=$(SRCDIR)/ --format=tar v$(PKG_VERSION) > $(SRCDIR).tar
-	$(Q)$(TAR) --transform "s,^,$(SRCDIR)/," -rf $(SRCDIR).tar \
-	  $(SRCTARINC)
-	$(Q)$(ZIP) $(SRCDIR).tar
+$(SRCTAR) : default $(SRCTARINC) .gitcensus
+	$(Q)$(TAR) --transform "s,^,$(SRCDIR)/," -zcf $(SRCDIR).tar.gz \
+	  `cat .gitcensus` $(SRCTARINC)
 	echo Wrote: $@
+
+.gitcensus: $(_FORCE)
+	$(Q) if test -d .git; then \
+	  git ls-files > .gitcensus && echo "new .gitcensus"; \
+	fi
Index: b/include/buildrules
===================================================================
--- a/include/buildrules	2013-02-14 10:59:26.221945695 -0600
+++ b/include/buildrules	2013-02-14 10:59:39.321985640 -0600
@@ -23,17 +23,6 @@ $(SUBDIRS):
 	$(Q)$(MAKE) $(MAKEOPTS) -q -C $@ || $(MAKE) $(MAKEOPTS) -C $@
 endif
 
-source-link: 
-	@test -z "$$DIR" && DIR="."; \
-	for f in `echo $(SRCFILES) $(SUBDIRS) $(POTHEAD)`; do \
-	    if test -d $$f ; then \
-		mkdir $(TOPDIR)/$(PKG_NAME)-$(PKG_VERSION)/$$DIR/$$f || exit $$?; \
-		$(MAKEF) DIR=$$DIR/$$f -C $$f $@ || exit $$?; \
-	    else \
-		ln $$f $(TOPDIR)/$(PKG_NAME)-$(PKG_VERSION)/$$DIR/$$f || exit $$?; \
-	    fi; \
-	done
-
 #
 # Standard targets
 #

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
