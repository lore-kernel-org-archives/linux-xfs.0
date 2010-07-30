Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59E7sF4068120 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 09:07:55 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 891E18F804B
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 14:45:46 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o6ULjkMY008061
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 16:45:46 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o6ULjk4v008060
	for xfs@oss.sgi.com; Fri, 30 Jul 2010 16:45:46 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201007302145.o6ULjk4v008060@stout.americas.sgi.com>
Date: Fri, 30 Jul 2010 16:45:45 -0500
Subject: [PATCH] xfsprogs: fix depend targets
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There's no need to re-make the dependency files all the time.  Make
it so the "depend" target rebuilds the ".dep" file only if necessary.
Also change the name of the dependency file created for "ltdepend"
to be ".ltdep".

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 Makefile           |    6 +++---
 include/buildrules |   14 +++++++++-----
 libdisk/Makefile   |    2 +-
 libhandle/Makefile |    2 +-
 libxcmd/Makefile   |    2 +-
 libxfs/Makefile    |    2 +-
 libxlog/Makefile   |    2 +-
 7 files changed, 17 insertions(+), 13 deletions(-)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -30,9 +30,9 @@ SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.
 CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
 LSRCFILES = configure.in release.sh README VERSION $(CONFIGURE)
 
-LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
-	built .census install.* install-dev.* *.gz autom4te.cache/* libtool \
-	include/builddefs include/platform_defs.h
+LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
+	conftest* built .census install.* install-dev.* *.gz \
+	autom4te.cache/* libtool include/builddefs include/platform_defs.h
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 LDIRDIRT = $(SRCDIR)
Index: b/include/buildrules
===================================================================
--- a/include/buildrules
+++ b/include/buildrules
@@ -7,7 +7,7 @@ _BUILDRULES_INCLUDED_ = 1
 include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
-	@rm -f $(DIRT) .dep
+	@rm -f $(DIRT) .ltdep .dep
 	@rm -fr $(DIRDIRT)
 %-clean:
 	@echo "Cleaning $*"
@@ -94,10 +94,14 @@ $(_FORCE):
 
 MAKEDEP := $(MAKEDEPEND) $(CFLAGS)
 
-ltdepend: $(CFILES) $(HFILES)
-	@echo "    [DEP]"
-	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .dep
+ltdepend: .ltdep
+
+.ltdep: $(CFILES) $(HFILES)
+	@echo "    [LTDEP]"
+	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
+
+depend: .dep
 
-depend: $(CFILES) $(HFILES)
+.dep: $(CFILES) $(HFILES)
 	@echo "    [DEP]"
 	$(Q)$(MAKEDEP) $(CFILES) > .dep
Index: b/libdisk/Makefile
===================================================================
--- a/libdisk/Makefile
+++ b/libdisk/Makefile
@@ -30,4 +30,4 @@ install-dev: default
 
 install-qa: install-dev
 
--include .dep
+-include .ltdep
Index: b/libhandle/Makefile
===================================================================
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -27,4 +27,4 @@ install-dev: default
 
 install-qa: install-dev
 
--include .dep
+-include .ltdep
Index: b/libxcmd/Makefile
===================================================================
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -34,4 +34,4 @@ include $(BUILDRULES)
 
 install install-dev install-qa: default
 
--include .dep
+-include .ltdep
Index: b/libxfs/Makefile
===================================================================
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -48,4 +48,4 @@ install-dev: default
 
 install-qa: default
 
--include .dep
+-include .ltdep
Index: b/libxlog/Makefile
===================================================================
--- a/libxlog/Makefile
+++ b/libxlog/Makefile
@@ -21,4 +21,4 @@ include $(BUILDRULES)
 
 install install-dev install-qa: default
 
--include .dep
+-include .ltdep

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
