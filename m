Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SHSbu0126082 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 12:28:37 -0500
Received: from cxfsxe4.americas.sgi.com (cxfsxe4.americas.sgi.com
	[128.162.240.177])
	by estes.americas.sgi.com (Postfix) with ESMTP id 3810F7001AB0;
	Tue, 28 Aug 2012 12:29:29 -0500 (CDT)
Received: by cxfsxe4.americas.sgi.com (Postfix, from userid 48222)
	id 2F593CDA81; Tue, 28 Aug 2012 12:29:29 -0500 (CDT)
Message-Id: <20120828172928.999971219@sgi.com>
Date: Tue, 28 Aug 2012 12:26:07 -0500
From: Rich Johnston <rjohnston@sgi.com>
Subject: [PATCH 2/5] xfstests: Use libtool to install applications
References: <20120828172605.607853317@sgi.com>
Content-Disposition: inline;
	filename=2-5-xftests-use-libtool-to-install-applications.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

This patch replaces the INSTALL macro with LTINSTALL so that libtool is used
to install the applications.  Libtool will install the binary from the proper
location and display a warning if any shared library dependancies are not
properly installed.  This ensures that a libtool wrapper shell script is not
installed in place of application when libtool wrappers are being used.


Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 ltp/Makefile |    2 +-
 src/Makefile |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: b/ltp/Makefile
===================================================================
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -44,7 +44,7 @@ $(TARGETS): $(LIBTEST)
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp
-	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
+	$(LTINSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
 	$(INSTALL) -m 755 $(SCRIPTS) $(PKG_LIB_DIR)/ltp
 
 -include .dep
Index: b/src/Makefile
===================================================================
--- a/src/Makefile
+++ b/src/Makefile
@@ -74,9 +74,9 @@ LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS
 
 install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src
-	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
-	$(INSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh $(PKG_LIB_DIR)/src
-	$(INSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src
+	$(LTINSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
+	$(LTINSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh $(PKG_LIB_DIR)/src
+	$(LTINSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src
 
 %-install:
 	$(MAKE) -C $* install

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
