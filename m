Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49928 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfCNVEY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:04:24 -0400
Subject: [PATCH 06/36] debian: enable parallel make
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:04:20 -0700
Message-ID: <155259746044.31886.13633380455067163247.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use parallel make to speed up dpkg builds.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/rules |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)


diff --git a/debian/rules b/debian/rules
index 7c2a8b3c..e8509fb3 100755
--- a/debian/rules
+++ b/debian/rules
@@ -2,6 +2,11 @@
 
 export DH_VERBOSE=1
 
+ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
+    NUMJOBS = $(patsubst parallel=%,%,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
+    PMAKEFLAGS += -j$(NUMJOBS)
+endif
+
 package = xfsprogs
 develop = xfslibs-dev
 bootpkg = xfsprogs-udeb
@@ -30,7 +35,7 @@ build-arch: built
 build-indep: built
 built: dibuild config
 	@echo "== dpkg-buildpackage: build" 1>&2
-	$(MAKE) default
+	$(MAKE) $(PMAKEFLAGS) default
 	touch built
 
 config: .census
@@ -38,7 +43,7 @@ config: .census
 	@echo "== dpkg-buildpackage: configure" 1>&2
 	$(checkdir)
 	AUTOHEADER=/bin/true dh_autoreconf
-	$(options) $(MAKE) include/platform_defs.h
+	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
 	touch .census
 
 dibuild:
@@ -48,10 +53,10 @@ dibuild:
 		$(diopts) $(MAKE) include/platform_defs.h; \
 		mkdir -p include/xfs; \
 		for dir in include libxfs; do \
-			$(MAKE) -C $$dir NODEP=1 install-headers; \
+			$(MAKE) $(PMAKEFLAGS) -C $$dir NODEP=1 install-headers; \
 		done; \
 		for dir in include libxfs libxcmd libfrog mkfs; do \
-			$(MAKE) $$dir; \
+			$(MAKE) $(PMAKEFLAGS) $$dir; \
 		done; \
 		mv mkfs/mkfs.xfs mkfs/mkfs.xfs-$(bootpkg); \
 		$(MAKE) distclean; \
