Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBAMCRAB119759 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 16:12:27 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11E55DFA4ED
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 14:13:00 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id 1OFKICklNmQTaOlJ for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 14:13:00 -0800 (PST)
Date: Fri, 11 Dec 2009 09:12:55 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <733693069.1070091260483175291.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <404301816.1070071260483145992.JavaMail.root@mail-au.aconex.com>
Subject: Re: User Space Releases
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_75086_1612157724.1260483175289"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com

------=_Part_75086_1612157724.1260483175289
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


----- "Nathan Scott" <nscott@aconex.com> wrote:
> ----- "Christoph Hellwig" <hch@infradead.org> wrote:
> 
> > xfsdump:
> >  - get my configure defaults patch (just posted) in
> >  - update the changelog and possibly any other documentation
> >  - update the Debian packaging, possibly including the new source
> >    generation using the hardlinked package directory.
> >
> > Nathan, what's the time frame to get the Debian release bits done?
> 
> Will look into getting the deb packaging converted over during
> the next day or two at most.

Here's the conversion to new-fangled build style for xfsdump.  Review?
Its largely same as xfsprogs, the one slight wrinkle was the symlinked
files in "common"... but thats sorted out with this patch too.

cheers.

-- 
Nathan

------=_Part_75086_1612157724.1260483175289
Content-Type: text/x-patch; name=xfsdump.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=xfsdump.patch

diff --git a/.gitignore b/.gitignore
index cd5b633..575e36e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,23 +3,22 @@
 
 # build system
 .census
-Logs/
 include/config.h
 include/builddefs
 install-sh
 
-# magic diretory symlinks
-#include/disk
-#include/xfs
-
-# Makepgs
-build/src-manifest
-build/xfsdump-*.tar.gz
+# packaging
 doc/CHANGES.gz
 xfsdump-*
+xfsdump_*
 
 # autoconf generated files
 aclocal.m4
+m4/libtool.m4
+m4/ltoptions.m4
+m4/ltsugar.m4
+m4/ltversion.m4
+m4/lt~obsolete.m4
 autom4te.cache/
 config.guess
 config.log
@@ -38,6 +37,9 @@ ltmain.sh
 po/xfsdump.pot
 po/*.mo
 
+# cscope stuff
+cscope.*
+
 # quilt stuff
 .pc/
 patches/
diff --git a/Makefile b/Makefile
index 54bd6e6..13c8834 100644
--- a/Makefile
+++ b/Makefile
@@ -9,20 +9,25 @@ ifeq ($(HAVE_BUILDDEFS), yes)
 include $(TOPDIR)/include/builddefs
 endif
 
-CONFIGURE = aclocal.m4 configure config.guess config.sub configure install-sh \
-	    ltmain.sh m4/libtool.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
-	    m4/ltversion.m4 m4/lt~obsolete.m4
-LSRCFILES = configure.in Makepkgs release.sh README VERSION $(CONFIGURE)
+SRCDIR = $(PKG_NAME)-$(PKG_VERSION)
+SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
+
+CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
+LSRCFILES = configure.in release.sh README VERSION $(CONFIGURE)
 
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
-	Logs/* built .census install.* install-dev.* *.gz autom4te.cache/* \
-	libtool include/builddefs include/config.h
+	built .census install.* install-dev.* *.gz autom4te.cache/* libtool \
+	include/builddefs include/config.h
 
-LIB_SUBDIRS = include librmt
-TOOL_SUBDIRS = common inventory invutil dump restore \
-	m4 man doc po debian build
+ifeq ($(HAVE_BUILDDEFS), yes)
+LDIRDIRT = $(SRCDIR)
+LDIRT += $(SRCTAR)
+endif
 
-SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+LIB_SUBDIRS = librmt
+TOOL_SUBDIRS = common inventory invutil dump restore m4 man doc po debian
+
+SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
 default: include/builddefs include/config.h
 ifeq ($(HAVE_BUILDDEFS), no)
@@ -32,6 +37,7 @@ else
 endif
 
 # tool/lib dependencies
+$(LIB_SUBDIRS) $(TOOL_SUBDIRS): include
 invutil dump restore: librmt
 
 ifeq ($(HAVE_BUILDDEFS), yes)
@@ -52,19 +58,7 @@ configure:
 	autoconf
 
 include/builddefs: configure
-	./configure \
-		--prefix=/ \
-		--exec-prefix=/ \
-		--sbindir=/sbin \
-		--bindir=/usr/sbin \
-		--libdir=/lib \
-		--libexecdir=/usr/lib \
-		--enable-lib64=yes \
-		--includedir=/usr/include \
-		--mandir=/usr/share/man \
-		--datadir=/usr/share \
-		$$LOCAL_CONFIGURE_OPTIONS
-	touch .census
+	./configure $$LOCAL_CONFIGURE_OPTIONS
 
 include/config.h: include/builddefs
 ## Recover from the removal of $@
@@ -90,3 +84,32 @@ distclean: clean
 
 realclean: distclean
 	rm -f $(CONFIGURE)
+
+#
+# All this gunk is to allow for a make dist on an unconfigured tree
+#
+dist: include/builddefs include/config.h default
+ifeq ($(HAVE_BUILDDEFS), no)
+	$(MAKE) -C . $@
+else
+	$(MAKE) $(SRCTAR)
+endif
+
+deb: include/builddefs include/config.h
+ifeq ($(HAVE_BUILDDEFS), no)
+	$(MAKE) -C . $@
+else
+	$(MAKE) $(SRCDIR)
+	$(MAKE) -C po
+	$(MAKE) source-link
+	cd $(SRCDIR) && dpkg-buildpackage
+endif
+
+$(SRCDIR) : $(_FORCE)
+	rm -fr $@
+	mkdir -p $@
+
+$(SRCTAR) : default $(SRCDIR)
+	$(MAKE) source-link
+	unset TAPE; $(TAR) -cf - $(SRCDIR) | $(ZIP) --best > $@ && \
+	echo Wrote: $@
diff --git a/configure.in b/configure.in
index 52e0950..05a9aa2 100644
--- a/configure.in
+++ b/configure.in
@@ -17,10 +17,43 @@ AC_ARG_ENABLE(gettext,
 AC_SUBST(enable_gettext)
 
 AC_ARG_ENABLE(lib64,
-[ --enable-lib64=[yes/no] Enable lib64 support [default=no]],,
-	enable_lib64=no)
+[ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
+	enable_lib64=yes)
 AC_SUBST(enable_lib64)
 
+#
+# If the user specified a libdir ending in lib64 do not append another
+# 64 to the library names.
+#
+base_libdir=`basename "$libdir"`
+case $base_libdir in
+lib64)
+  enable_lib64=no
+esac
+
+#
+# Some important tools should be installed into the root partitions.
+#
+# Check whether exec_prefix=/usr: and install them to /sbin in that
+# case.  If the user choses a different prefix assume he just wants
+# a local install for testing and not a system install.
+#
+case $exec_prefix:$prefix in
+NONE:NONE | NONE:/usr | /usr:*)
+  root_sbindir='/sbin'
+  AC_SUBST([root_sbindir])
+
+  root_libdir="/${base_libdir}"
+  AC_SUBST([root_libdir])
+esac
+
+# Find localized files
+LOCALIZED_FILES=""
+for lfile in `find ${srcdir} -name '*.c' -type f || exit 1`; do
+    LOCALIZED_FILES="$LOCALIZED_FILES \$(TOPDIR)/$lfile"
+done
+AC_SUBST(LOCALIZED_FILES)
+
 AC_PACKAGE_GLOBALS(xfsdump)
 AC_PACKAGE_UTILITIES(xfsdump)
 AC_MULTILIB($enable_lib64)
diff --git a/debian/Makefile b/debian/Makefile
index 0d14c7f..8839b3e 100644
--- a/debian/Makefile
+++ b/debian/Makefile
@@ -6,6 +6,8 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 LSRCFILES = changelog compat control copyright rules shlibs.local
+LDIRDIRT = xfsdump
+LDIRT = files *.log *.substvars *.debhelper
 
 default:
 
diff --git a/debian/rules b/debian/rules
index e8acda3..baa2945 100755
--- a/debian/rules
+++ b/debian/rules
@@ -40,8 +40,7 @@ binary-arch: checkroot built
 	$(checkdir)
 	-rm -rf $(dirme)
 	$(pkgme) $(MAKE) -C . install
-	$(pkgme) $(MAKE) -C build src-manifest
-
+	$(pkgme) $(MAKE) dist
 	dh_installdocs
 	dh_installchangelogs
 	dh_strip
@@ -51,7 +50,6 @@ binary-arch: checkroot built
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol
-
 	dh_md5sums
 	dh_builddeb
 
diff --git a/doc/INSTALL b/doc/INSTALL
index 6c32f28..ffbc867 100644
--- a/doc/INSTALL
+++ b/doc/INSTALL
@@ -19,21 +19,13 @@ run them.
    (on an RPM based system) or the uuid-dev package (on a Debian system)
    as some of the commands make use of the UUID library provided by these.
 
-   If you just want to spin an RPM and/or tar file, use the Makepkgs
-   script in the top level directory. This will configure and build
-   the package and leave binary and src RPMs in the build/rpm
-   directory.  It will also leave a tar file in the build/tar
-   directory.
+   To build the package and install it manually, use the following steps:
 
-       # ./Makepkgs verbose
-
-   If you want to build the package and install it manually, use the
-   following steps :
-
-       # make configure  (or run autoconf; ./configure)
-       # make
-       # su root
-       # make install
+	# make
+	# su root
+	# make install
+	[and optionally, for the development libraries and headers]
+	# make install-dev
 
    Note that there are so many "install" variants out there that we
    wrote our own script (see "install-sh" in the top level directory).
@@ -41,10 +33,10 @@ run them.
    If you wish to turn off debugging asserts in the command build and
    turn on the optimizer then set the shell environment variables:
 
-	OPTIMIZER=-O
+	OPTIMIZER=-O1
 	DEBUG=-DNDEBUG
 
-   before running make configure or Makepkgs.
+   before running make or Makepkgs.
 
 2. How to Contribute
 
diff --git a/doc/Makefile b/doc/Makefile
index 694d131..8567172 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -6,7 +6,7 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 README = README.xfsdump
-LSRCFILES = INSTALL PORTING CHANGES COPYING $(README) \
+LSRCFILES = INSTALL CHANGES COPYING $(README) \
 	xfsdump.html xfsdump_ts.txt \
 	*.obj *.gif
 
@@ -21,7 +21,7 @@ CHANGES.gz:
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
-	$(INSTALL) -m 644 PORTING CHANGES.gz $(README) $(PKG_DOC_DIR)
+	$(INSTALL) -m 644 CHANGES.gz $(README) $(PKG_DOC_DIR)
 ifeq ($(PKG_DISTRIBUTION), debian)
 	$(INSTALL) -S CHANGES.gz $(PKG_DOC_DIR)/changelog.gz
 else
diff --git a/dump/Makefile b/dump/Makefile
index 7e0c0b2..11a5f39 100644
--- a/dump/Makefile
+++ b/dump/Makefile
@@ -81,9 +81,11 @@ LOCALINCL = \
 
 LTCOMMAND = xfsdump
 
-CFILES = $(COMMON) $(INVCOMMON) $(LOCALS)
-HFILES = $(LOCALINCL) $(COMMINCL) $(INVINCL)
-LINKS  = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
+CFILES = $(LOCALS)
+LCFILES = $(COMMON) $(INVCOMMON)
+HFILES = $(LOCALINCL)
+LHFILES = $(COMMINCL) $(INVINCL)
+LINKS = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 LDIRT = $(LINKS)
 LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT)
 LTDEPENDENCIES = $(LIBRMT)
@@ -95,10 +97,10 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(INSTALL) -S $(PKG_SBIN_DIR)/$(LTCOMMAND) $(PKG_BIN_DIR)/$(LTCOMMAND)
+	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
 $(COMMINCL) $(COMMON):
diff --git a/include/builddefs.in b/include/builddefs.in
index e29b271..cfbc1a0 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -31,10 +31,15 @@ PKG_RELEASE	= @pkg_release@
 PKG_VERSION	= @pkg_version@
 PKG_PLATFORM	= @pkg_platform@
 PKG_DISTRIBUTION= @pkg_distribution@
-PKG_BIN_DIR	= @bindir@
+
+prefix		= @prefix@
+exec_prefix	= @exec_prefix@
+datarootdir	= @datarootdir@
+top_builddir	= @top_builddir@
+
 PKG_SBIN_DIR	= @sbindir@
-PKG_LIB_DIR	= @libdir@@libdirsuffix@
-PKG_DEVLIB_DIR	= @libexecdir@@libdirsuffix@
+PKG_ROOT_SBIN_DIR = @root_sbindir@
+PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
 PKG_INC_DIR	= @includedir@
 PKG_MAN_DIR	= @mandir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
@@ -55,6 +60,7 @@ MAKEDEPEND	= @makedepend@
 MSGFMT		= @msgfmt@
 MSGMERGE	= @msgmerge@
 XGETTEXT	= @xgettext@
+LOCALIZED_FILES	= @LOCALIZED_FILES@
 
 RPM		= @rpm@
 RPMBUILD	= @rpmbuild@
@@ -66,14 +72,15 @@ ENABLE_GETTEXT	= @enable_gettext@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
-LCFLAGS += -DXFS_BIG_FILES=1 -DXFS_BIG_FILESYSTEMS=1
+GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
+#	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
 ifeq ($(PKG_PLATFORM),linux)
-PCFLAGS = -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64
+PCFLAGS = -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)
 DEPENDFLAGS = -D__linux__
 endif
 ifeq ($(PKG_PLATFORM),darwin)
-PCFLAGS = -traditional-cpp
+PCFLAGS = -traditional-cpp $(GCCFLAGS)
 DEPENDFLAGS = -D__APPLE__
 endif
 ifeq ($(PKG_PLATFORM),irix)
@@ -82,17 +89,16 @@ DEPENDFLAGS = -D__sgi__
 endif
 ifeq ($(PKG_PLATFORM),freebsd)
 PLDLIBS = -L/usr/local/lib -lintl
-PCFLAGS = -I/usr/local/include
+PCFLAGS = -I/usr/local/include $(GCCFLAGS)
 DEPENDFLAGS = -D__FreeBSD__
 endif
 
-
-GCFLAGS = $(OPTIMIZER) $(DEBUG) -funsigned-char -fno-strict-aliasing -Wall \
+GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include
 
-# Global, Platform, Local CFLAGS
-CFLAGS += $(GCFLAGS) $(PCFLAGS) $(LCFLAGS) $(CPPFLAGS)
+# First, Global, Platform, Local CFLAGS
+CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
 
 include $(TOPDIR)/include/buildmacros
 
diff --git a/include/buildmacros b/include/buildmacros
index ce30cd3..ea769fa 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -21,8 +21,11 @@ MANDIRT = *.[1-9].gz
 PODIRT = *.tmpo *.mo
 CDIRT = $(OBJECTS) $(LTOBJECTS) $(LTCOMMAND) $(LTLIBRARY)
 DIRT = $(LDIRT) $(DEPDIRT) $(MANDIRT) $(PODIRT) $(CDIRT)
+LIBDIRT = .libs
+DIRDIRT = $(LDIRDIRT) $(LIBDIRT)
 
 OBJECTS = $(ASFILES:.s=.o) \
+	  $(LCFILES:.c=.o) \
 	  $(CFILES:.c=.o) \
 	  $(LFILES:.l=.o) \
 	  $(YFILES:%.y=%.tab.o)
@@ -48,16 +51,16 @@ LTINSTALL = $(LIBTOOL) --mode=install $(INSTALL)
 LTCOMPILE = $(LIBTOOL) --tag=CC --mode=compile $(CCF)
 
 ifeq ($(ENABLE_SHARED),yes)
-LTLDFLAGS += -rpath $(PKG_LIB_DIR)
+LTLDFLAGS += -rpath $(PKG_ROOT_LIB_DIR)
 LTLDFLAGS += -version-info $(LTVERSION)
 endif
 
 ifeq ($(ENABLE_SHARED),yes)
 INSTALL_LTLIB = \
 	cd $(TOPDIR)/$(LIBNAME)/.libs; \
-	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
-	../$(INSTALL) -m 644 -T so_dot_version $(LIBNAME).lai $(PKG_LIB_DIR); \
-	../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_LIB_DIR)
+	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
+	../$(INSTALL) -m 644 -T so_dot_version $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
+	../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_ROOT_LIB_DIR)
 endif
 
 # Libtool thinks the static and shared libs should be in the same dir, so
@@ -69,15 +72,15 @@ endif
 ifeq ($(ENABLE_SHARED),yes)
 INSTALL_LTLIB_DEV = \
 	cd $(TOPDIR)/$(LIBNAME)/.libs; \
-	../$(INSTALL) -m 755 -d $(PKG_DEVLIB_DIR); \
-	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_DEVLIB_DIR); \
-	../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_DEVLIB_DIR)/$(LIBNAME).la ; \
 	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
-	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_LIB_DIR); \
-	if test "x$(PKG_DEVLIB_DIR)" != "x$(PKG_LIB_DIR)" ; then \
-	../$(INSTALL) -S $(PKG_DEVLIB_DIR)/$(LIBNAME).a $(PKG_LIB_DIR)/$(LIBNAME).a; \
-	../$(INSTALL) -S $(PKG_DEVLIB_DIR)/$(LIBNAME).la $(PKG_LIB_DIR)/$(LIBNAME).la; \
-	../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).so $(PKG_DEVLIB_DIR)/$(LIBNAME).so; \
+	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_LIB_DIR); \
+	../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_LIB_DIR)/$(LIBNAME).la ; \
+	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
+	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
+	if test "x$(PKG_LIB_DIR)" != "x$(PKG_ROOT_LIB_DIR)" ; then \
+	../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIBNAME).a; \
+	../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/$(LIBNAME).la; \
+	../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
 	fi
 else
 INSTALL_LTLIB_DEV = $(INSTALL_LTLIB_STATIC)
@@ -85,8 +88,8 @@ endif
 
 INSTALL_LTLIB_STATIC = \
 	cd $(TOPDIR)/$(LIBNAME)/.libs; \
-	../$(INSTALL) -m 755 -d $(PKG_DEVLIB_DIR); \
-	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_DEVLIB_DIR)
+	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
+	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_LIB_DIR)
 
 INSTALL_MAN = \
 	@for d in $(MAN_PAGES); do \
@@ -131,19 +134,3 @@ MAN_MAKERULE = \
 			$(ZIP) --best -c < $$f > $$f.gz; \
 		fi; \
 	done
-
-DIST_MAKERULE = \
-	$(MAKEF) -C build dist
-
-SOURCE_MAKERULE = \
-	@test -z "$$DIR" && DIR="."; \
-	for f in $(SRCFILES) ""; do \
-	    test -z "$$f" && break; \
-	    test -L "$$f" || $(ECHO) $$DIR/$$f; \
-	done; \
-	for d in `echo $(SUBDIRS)` ""; do \
-	    test -z "$$d" && break; \
-	    if test -d "$$d"; then \
-		$(MAKEF) DIR=$$DIR/$$d -C $$d $@ || exit $$?; \
-	    fi; \
-	done
diff --git a/include/buildrules b/include/buildrules
index e509833..fb32bf5 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -8,8 +8,7 @@ include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
 	rm -f $(DIRT)
-	@rm -fr .libs
-
+	rm -fr $(DIRDIRT)
 %-clean:
 	$(MAKE) -C $* clean
 
@@ -22,6 +21,18 @@ $(SUBDIRS):
 	$(MAKE) -C $@
 endif
 
+source-link: 
+	@test -z "$$DIR" && DIR="."; \
+	for f in `echo $(SRCFILES) $(SUBDIRS) $(POTHEAD)`; do \
+	    if test -d $$f ; then \
+		echo mkdir $(TOPDIR)/$(PKG_NAME)-$(PKG_VERSION)/$$DIR/$$f || exit $$?; \
+		mkdir $(TOPDIR)/$(PKG_NAME)-$(PKG_VERSION)/$$DIR/$$f || exit $$?; \
+		$(MAKEF) DIR=$$DIR/$$f -C $$f $@ || exit $$?; \
+	    else \
+		ln $$f $(TOPDIR)/$(PKG_NAME)-$(PKG_VERSION)/$$DIR/$$f || exit $$?; \
+	    fi; \
+	done
+
 #
 # Standard targets
 #
@@ -40,22 +51,29 @@ $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
 endif
 
 ifdef POTHEAD
-%.pot: $(XGETTEXTFILES)
-	$(XGETTEXT) --language=C --keyword=_ -o $@ $(XGETTEXTFILES)
-
-# Generate temp .po files, to check whether translations need updating.
-# Not by default, due to gettext output differences between versions.
-%.po: $(POTHEAD)
-#	$(MSGMERGE) -o $@.tmpo $@ $(POTHEAD)
-#	if ! diff $@.tmpo $@ >/dev/null; then echo "$@ dated, see $@.tmpo"; fi
+$(POTHEAD): $(XGETTEXTFILES)
+	$(XGETTEXT) --language=C --keyword=_ --keyword=N_ -o $@ $(XGETTEXTFILES)
+
+# Update translations
+update-po: $(POTHEAD) $(wildcard $(TOPDIR)/po/*.po)
+	catalogs=$(wildcard $(TOPDIR)/po/*.po); \
+	for cat in $$catalogs; do \
+	  lang=`basename $$cat .po`; \
+	  mv $$lang.po $$lang.old.po; \
+	  echo "$$lang:"; \
+	  if $(MSGMERGE) $$lang.old.po $(POTHEAD) -o $$lang.po; then \
+	    rm -f $$lang.old.po; \
+	  else \
+	    echo "msgmerge for $$lang failed!"; \
+	    rm -f $$lang.po; \
+	    mv $$lang.old.po $$lang.po; \
+	  fi; \
+	done
 
 %.mo: %.po
-	$(MSGFMT) -o $@ $<
+	$(MSGFMT) -c --statistics -o $@ $<
 endif
 
-source :
-	$(SOURCE_MAKERULE)
-
 endif # _BUILDRULES_INCLUDED_
 
 $(_FORCE):
@@ -63,7 +81,8 @@ $(_FORCE):
 .PHONY : depend
 
 DEPENDSCRIPT := $(MAKEDEPEND) $(DEPENDFLAGS) -f - -- $(CFLAGS) -- $(CFILES) | \
-	$(SED) -e 's,`pwd`,$(TOPDIR),g' \
+	$(SED) \
+	    -e 's,`pwd`,$(TOPDIR),g' \
 	    -e 's,  */[^ ]*,,g' \
 	    -e '/^[^ ]*: *$$/d' \
 	    -e '/^ *$$/d'
@@ -84,8 +103,8 @@ ifeq ($(shell test -f .dep && echo .dep), .dep)
 include .dep
 else
 ifdef LTLIBRARY
-$(LTOBJECTS): $(HFILES)
+$(LTOBJECTS): $(HFILES) $(LHFILES)
 else
-$(OBJECTS): $(HFILES)
+$(OBJECTS): $(HFILES) $(LHFILES)
 endif
 endif
diff --git a/invutil/Makefile b/invutil/Makefile
index ed2a491..f8fafdb 100644
--- a/invutil/Makefile
+++ b/invutil/Makefile
@@ -39,8 +39,9 @@ CURSESINCL = \
 LOCALS = invutil.c
 
 LTCOMMAND = xfsinvutil
-CFILES = $(COMMON) $(INVCOMMON) $(LOCALS)
-HFILES = $(COMMINCL) $(INVINCL)
+CFILES = $(LOCALS)
+LCFILES = $(COMMON) $(INVCOMMON)
+LHFILES = $(COMMINCL) $(INVINCL)
 LINKS  = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 LDIRT = $(LINKS)
 LLDLIBS = $(LIBUUID) $(LIBCURSES)
@@ -62,8 +63,8 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
 $(COMMINCL) $(COMMON):
diff --git a/m4/Makefile b/m4/Makefile
index a56d269..716f5ee 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -5,6 +5,13 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
+CONFIGURE = \
+	libtool.m4 \
+	ltoptions.m4 \
+	ltsugar.m4 \
+	ltversion.m4 \
+	lt~obsolete.m4
+
 LSRCFILES = \
 	manual_format.m4 \
 	package_attrdev.m4 \
@@ -15,8 +22,11 @@ LSRCFILES = \
 	package_xfslibs.m4 \
 	multilib.m4
 
-default: 
+default:
 
 include $(BUILDRULES)
 
 install install-dev install-lib: default
+
+realclean: distclean
+	rm -f $(CONFIGURE)
diff --git a/po/Makefile b/po/Makefile
index 07495a9..2f9e0a6 100644
--- a/po/Makefile
+++ b/po/Makefile
@@ -7,45 +7,10 @@ include $(TOPDIR)/include/builddefs
 
 POTHEAD = $(PKG_NAME).pot
 LINGUAS =
-LSRCFILES = $(LINGUAS:%=%.po) $(POTHEAD)
+LSRCFILES = $(LINGUAS:%=%.po)
 LDIRT = $(POTHEAD)
 
-# TODO - invutil/
-XGETTEXTFILES =	\
-		$(TOPDIR)/common/cldmgr.c \
-		$(TOPDIR)/common/content_common.c \
-		$(TOPDIR)/common/dlog.c \
-		$(TOPDIR)/common/drive.c \
-		$(TOPDIR)/common/drive_minrmt.c \
-		$(TOPDIR)/common/drive_scsitape.c \
-		$(TOPDIR)/common/drive_simple.c \
-		$(TOPDIR)/common/fs.c \
-		$(TOPDIR)/common/global.c \
-		$(TOPDIR)/common/main.c \
-		$(TOPDIR)/common/media.c \
-		$(TOPDIR)/common/mlog.c \
-		$(TOPDIR)/common/namreg.c \
-		$(TOPDIR)/common/openutil.c \
-		$(TOPDIR)/common/qlock.c \
-		$(TOPDIR)/common/util.c \
-		$(TOPDIR)/dump/content.c \
-		$(TOPDIR)/dump/inomap.c \
-		$(TOPDIR)/dump/var.c \
-		$(TOPDIR)/inventory/inv_api.c \
-		$(TOPDIR)/inventory/inv_core.c \
-		$(TOPDIR)/inventory/inv_fstab.c \
-		$(TOPDIR)/inventory/inv_mgr.c \
-		$(TOPDIR)/inventory/inv_stobj.c \
-		$(TOPDIR)/librmt/rmtioctl.c \
-		$(TOPDIR)/librmt/rmtmsg.c \
-		$(TOPDIR)/librmt/rmtopen.c \
-		$(TOPDIR)/restore/content.c \
-		$(TOPDIR)/restore/dirattr.c \
-		$(TOPDIR)/restore/inomap.c \
-		$(TOPDIR)/restore/namreg.c \
-		$(TOPDIR)/restore/node.c \
-		$(TOPDIR)/restore/tree.c \
-		$(TOPDIR)/restore/win.c
+XGETTEXTFILES =	$(LOCALIZED_FILES)
 
 default: $(POTHEAD) $(LINGUAS:%=%.mo)
 
diff --git a/release.sh b/release.sh
index e8b8421..fcea637 100755
--- a/release.sh
+++ b/release.sh
@@ -18,8 +18,8 @@ git-commit -a -m "${version} release"
 echo "Tagging git repository"
 git-tag v${version}
 
-echo "Creating source tarball in build/tar/"
-./Makepkgs
+echo "Creating source tarball"
+make dist
 
 echo "Done."
 echo "Please remember to push out tags using \"git push --tags\""
diff --git a/restore/Makefile b/restore/Makefile
index d955984..d8abc74 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -91,9 +91,11 @@ LOCALINCL = \
 
 LTCOMMAND = xfsrestore
 
-CFILES = $(COMMON) $(INVCOMMON) $(LOCALS)
-HFILES = $(LOCALINCL) $(COMMINCL) $(INVINCL)
-LINKS  = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
+CFILES = $(LOCALS)
+LCFILES = $(COMMON) $(INVCOMMON)
+HFILES = $(LOCALINCL)
+LHFILES = $(COMMINCL) $(INVINCL)
+LINKS = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 LDIRT = $(LINKS)
 LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT)
 LTDEPENDENCIES = $(LIBRMT)
@@ -107,10 +109,10 @@ default: $(LTCOMMAND)
 include $(BUILDRULES)
 
 install: default
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
-	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
-	$(INSTALL) -S $(PKG_SBIN_DIR)/$(LTCOMMAND) $(PKG_BIN_DIR)/$(LTCOMMAND)
+	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
 $(COMMINCL) $(COMMON):

------=_Part_75086_1612157724.1260483175289
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_75086_1612157724.1260483175289--
