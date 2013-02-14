Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 443517FE2
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 19:08:57 -0600 (CST)
Date: Wed, 13 Feb 2013 19:08:53 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using git
	archive
Message-ID: <20130214010853.GD22182@sgi.com>
References: <50F44B2E.9050408@sgi.com> <20130201190930.GX27055@sgi.com>
	<20130206011547.GT2667@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130206011547.GT2667@dastard>
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
To: Dave Chinner <david@fromorbit.com>, nathans@debian.org
Cc: Andrew Dahl <adahl@sgi.com>, xfs@oss.sgi.com

On Wed, Feb 06, 2013 at 12:15:47PM +1100, Dave Chinner wrote:
> On Fri, Feb 01, 2013 at 01:09:30PM -0600, Ben Myers wrote:
> > On Mon, Jan 14, 2013 at 12:15:10PM -0600, Andrew Dahl wrote:
> > > The following four patches fix an issue seen during the last user space
> > > release where not all source files were included in xfsprogs.  They each
> > > change xfsprogs, xfstests, xfsdump, and dmapi to all use git archive for
> > > source tarball generation and add 'make realclean' in the release
> > > scripts to ensure the configure and m4/autotools temp files are refreshed.
> > 
> > Applied this series.
> 
> It breaks the 'make deb' command for all the trees.

xfsprogs: update 'make deb' to use tarball

This patch changes the build process so that 'make deb' uses the same
process of creating a source tree as the release script.

* Add a list of files which go in the release tarball in .git_census
  This is needed so that you can create a tarball in a bare release
  tree, when .git is not available.

* Modify the SRCTAR target to include files from .git_census and use tar
  instead of git archive.

* Modify the SRCTARINC files to include .git_census, and include 
  .git_census in the 'make realclean' target.

* 'make deb' now creates unsigned packages by default, 'make debsign'
  creates signed packages.

* remove the 'make source-link' target.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 Makefile           |   29 ++++++++++++++++-------------
 include/buildrules |   11 -----------
 2 files changed, 16 insertions(+), 24 deletions(-)

Index: b/Makefile
===================================================================
--- a/Makefile	2013-02-13 16:55:18.451946936 -0600
+++ b/Makefile	2013-02-13 18:39:16.121985626 -0600
@@ -30,8 +30,7 @@ SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.
 CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
 LSRCFILES = configure.ac release.sh README VERSION $(CONFIGURE)
 SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
-           m4/ltversion.m4 po/xfsprogs.pot $(CONFIGURE)
-
+           m4/ltversion.m4 po/xfsprogs.pot .git_census $(CONFIGURE)
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* built .census install.* install-dev.* *.gz \
 	autom4te.cache/* libtool include/builddefs include/platform_defs.h
@@ -120,7 +119,7 @@ distclean: clean
 	$(Q)rm -f $(LDIRT)
 
 realclean: distclean
-	$(Q)rm -f $(CONFIGURE)
+	$(Q)rm -f $(CONFIGURE) .git_census
 
 #
 # All this gunk is to allow for a make dist on an unconfigured tree
@@ -137,18 +136,22 @@ ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
 	$(Q)$(MAKE) $(MAKEOPTS) $(SRCDIR)
-	$(Q)$(MAKE) $(MAKEOPTS) -C po
-	$(Q)$(MAKE) $(MAKEOPTS) source-link
-	$(Q)cd $(SRCDIR) && dpkg-buildpackage
+	$(Q)cd $(SRCDIR) && dpkg-buildpackage -us -uc
 endif
 
-$(SRCDIR) : $(_FORCE)
+debsign: deb
+	debsign
+
+$(SRCDIR) : $(_FORCE) $(SRCTAR)
 	rm -fr $@
-	mkdir -p $@
+	$(Q)$(TAR) -zxvf $(SRCTAR)
 
-$(SRCTAR) : default
-	$(Q)git archive --prefix=$(SRCDIR)/ --format=tar v$(PKG_VERSION) > $(SRCDIR).tar 
-	$(Q)$(TAR) --transform "s,^,$(SRCDIR)/," -rf $(SRCDIR).tar \
-	   $(SRCTARINC) 
-	$(Q)$(ZIP) $(SRCDIR).tar
+$(SRCTAR) : default $(SRCTARINC) .git_census
+	$(Q)$(TAR) --transform "s,^,$(SRCDIR)/," -zcf $(SRCDIR).tar.gz  \
+	   `cat .git_census` $(SRCTARINC)
 	echo Wrote: $@
+
+.git_census: $(_FORCE)
+	$(Q)if test -d .git; then \
+	  git ls-files > .git_census && echo "new .git_census"; \
+	fi
Index: b/include/buildrules
===================================================================
--- a/include/buildrules	2013-02-13 17:30:04.181945855 -0600
+++ b/include/buildrules	2013-02-13 17:30:24.161985853 -0600
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
