Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfCNVFu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:05:50 -0400
Subject: [PATCH 18/36] scrub: fix Makefile targets which depend on builddefs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:05:41 -0700
Message-ID: <155259754139.31886.15219987362146132076.stgit@magnolia>
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

Add Makefile dependencies for targets that require variables set in
builddefs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 6e155c2c..bbcfe338 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -3,7 +3,8 @@
 #
 
 TOPDIR = ..
-include $(TOPDIR)/include/builddefs
+builddefs=$(TOPDIR)/include/builddefs
+include $(builddefs)
 
 # On linux we get fsmap from the system or define it ourselves
 # so include this based on platform type.  If this reverts to only
@@ -103,27 +104,27 @@ LDIRT = $(XFS_SCRUB_ALL_PROG) *.service *.cron
 
 default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
 
-xfs_scrub_all: xfs_scrub_all.in
+xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
 	$(Q)chmod a+x $@
 
-phase5.o unicrash.o xfs.o: $(TOPDIR)/include/builddefs
+phase5.o unicrash.o xfs.o: $(builddefs)
 
 include $(BUILDRULES)
 
 install: $(INSTALL_SCRUB)
 
-%.service: %.service.in
+%.service: %.service.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
 		   -e "s|@pkg_lib_dir@|$(PKG_LIB_DIR)|g" \
 		   -e "s|@pkg_name@|$(PKG_NAME)|g" < $< > $@
 
-%.cron: %.cron.in
+%.cron: %.cron.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" < $< > $@
 
