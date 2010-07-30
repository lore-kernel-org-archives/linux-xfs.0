Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59EBsL9068255 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 09:11:54 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD6CA8F80A1
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 14:49:48 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o6ULnmtd008331
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 16:49:48 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o6ULnmTR008330
	for xfs@oss.sgi.com; Fri, 30 Jul 2010 16:49:48 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201007302149.o6ULnmTR008330@stout.americas.sgi.com>
Date: Fri, 30 Jul 2010 16:49:48 -0500
Subject: [PATCH] xfstests: fix depend targets
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
 Makefile           |    4 ++--
 include/buildrules |   18 ++++++++++++------
 lib/Makefile       |    2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -27,8 +27,8 @@ endif
 TESTS = $(shell sed -n -e '/^[0-9][0-9][0-9]*/s/ .*//p' group)
 CONFIGURE = configure include/builddefs include/config.h
 LSRCFILES = configure configure.in aclocal.m4 README VERSION
-LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
-	check.log check.time
+LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
+	conftest* check.log check.time
 
 ifeq ($(HAVE_DMAPI), true)
 DMAPI_MAKEFILE = dmapi/Makefile
Index: b/include/buildrules
===================================================================
--- a/include/buildrules
+++ b/include/buildrules
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
 	$(Q)rm -f $(DIRT)
-	$(Q)rm -fr .libs .dep
+	$(Q)rm -fr .libs .ltdep .dep
 
 %-clean:
 	@echo "Cleaning $*"
@@ -75,11 +75,17 @@ $(_FORCE):
 
 MAKEDEP := $(MAKEDEPEND) $(CFLAGS)
 
-ltdepend: $(CFILES) $(HFILES)
-	@echo "    [DEP]"
-	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .dep
+ltdepend: .ltdep
+
+.ltdep: $(CFILES) $(HFILES)
+	@echo "    [LTDEP]"
+	$(Q)[ -n "$(CFILES)" ] && \
+	    $(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
+
+depend: .dep
 
-depend: $(CFILES) $(HFILES)
+.dep: $(CFILES) $(HFILES)
 	@echo "    [DEP]"
-	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1,' > .dep
+	$(Q)[ -n "$(CFILES)" ] && \
+	    $(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1,' > .dep
 
Index: b/lib/Makefile
===================================================================
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -25,4 +25,4 @@ include $(BUILDRULES)
 
 install install-dev: default
 
--include .dep
+-include .ltdep

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
