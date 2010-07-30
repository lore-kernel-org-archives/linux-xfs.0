Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59EAuo1068215 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 09:10:56 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFF163040C8
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 14:48:47 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o6ULmlbT008273
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 16:48:47 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o6ULmlpA008272
	for xfs@oss.sgi.com; Fri, 30 Jul 2010 16:48:47 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201007302148.o6ULmlpA008272@stout.americas.sgi.com>
Date: Fri, 30 Jul 2010 16:48:47 -0500
Subject: [PATCH] xfsdump: fix depend targets
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
 dump/Makefile      |    2 +-
 include/buildrules |   16 ++++++++++------
 inventory/Makefile |    2 +-
 librmt/Makefile    |    2 +-
 restore/Makefile   |    2 +-
 6 files changed, 17 insertions(+), 13 deletions(-)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -30,9 +30,9 @@ SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.
 CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
 LSRCFILES = configure.in release.sh README VERSION $(CONFIGURE)
 
-LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
-	built .census install.* install-dev.* *.gz autom4te.cache/* libtool \
-	include/builddefs include/config.h
+LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
+	conftest* built .census install.* install-dev.* *.gz \
+	autom4te.cache/* libtool include/builddefs include/config.h
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 LDIRDIRT = $(SRCDIR)
Index: b/dump/Makefile
===================================================================
--- a/dump/Makefile
+++ b/dump/Makefile
@@ -105,7 +105,7 @@ install: default
 	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
-depend: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
+.dep: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 
 $(COMMINCL) $(COMMON):
 	@echo "    [LN]     $@"
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
-	$(Q)$(MAKEDEP) $(CFILES) > .dep
+	$(Q)[ -n "$(CFILES)" ] && $(MAKEDEP) $(CFILES) > .dep
Index: b/inventory/Makefile
===================================================================
--- a/inventory/Makefile
+++ b/inventory/Makefile
@@ -13,4 +13,4 @@ default install install-dev:
 
 include $(BUILDRULES)
 
--include .dep
+-include .ltdep
Index: b/librmt/Makefile
===================================================================
--- a/librmt/Makefile
+++ b/librmt/Makefile
@@ -21,4 +21,4 @@ include $(BUILDRULES)
 
 install install-dev: default
 
--include .dep
+-include .ltdep
Index: b/restore/Makefile
===================================================================
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -117,7 +117,7 @@ install: default
 	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
-depend: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
+.dep: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 
 $(COMMINCL) $(COMMON):
 	@echo "    [LN]     $@"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
