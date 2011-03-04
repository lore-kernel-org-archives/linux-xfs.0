Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JYmFB184510 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:34:48 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103041937.p24JbaaN004813@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 13:37:36 -0600
Subject: [PATCH 1/2] xfstests: a few fixes to Makefile
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

A few changes to the Makefile:
- Separate the rules for "configure" and "include/builddefs" into
  two parts, each of which generate one of the files
- Get rid of the rule for include/config.h, and group it with the
  one for include/builddefs (the same command creates both files)
- Use the $(Q) convention in a few missed spots
- Stop a DMAPI-only comment from getting echoed on default build

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 Makefile |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -44,9 +44,9 @@ ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) $@
 else
 	$(Q)$(MAKE) $(MAKEOPTS) $(SUBDIRS)
+ifeq ($(HAVE_DMAPI), true)
 	# automake doesn't always support "default" target 
 	# so do dmapi make explicitly with "all"
-ifeq ($(HAVE_DMAPI), true)
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(TOPDIR)/dmapi all
 endif
 endif
@@ -60,22 +60,19 @@ else
 clean:  # if configure hasn't run, nothing to clean
 endif
 
-configure include/builddefs:
+configure: configure.in
 	autoheader
 	autoconf
+
+include/builddefs include/config.h: configure
 	./configure \
                 --libexecdir=/usr/lib \
                 --enable-lib64=yes
 
-include/config.h: include/builddefs
-## Recover from the removal of $@
-	@if test -f $@; then :; else \
-		rm -f include/builddefs; \
-		$(MAKE) $(AM_MAKEFLAGS) include/builddefs; \
-	fi
-
+ifeq ($(HAVE_DMAPI), true)
 $(DMAPI_MAKEFILE):
-	cd $(TOPDIR)/dmapi/ ; ./configure
+	$(Q)cd $(TOPDIR)/dmapi && ./configure
+endif
 
 aclocal.m4::
 	aclocal --acdir=`pwd`/m4 --output=$@
@@ -97,5 +94,5 @@ install-dev install-lib:
 	$(MAKE) $(MAKEOPTS) -C $* install
 
 realclean distclean: clean
-	rm -f $(LDIRT) $(CONFIGURE)
-	rm -rf autom4te.cache Logs
+	$(Q)rm -f $(LDIRT) $(CONFIGURE)
+	$(Q)rm -rf autom4te.cache Logs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
