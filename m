Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5159B7F5E
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 13:10:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34803304059
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 11:10:18 -0700 (PDT)
Received: from lynxeye.de (ns.lynxeye.de [87.118.118.114]) by cuda.sgi.com
	with ESMTP id dD3hJzqQtH1enM73 for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 11:10:16 -0700 (PDT)
From: Lucas Stach <dev@lynxeye.de>
Subject: [PATCH] progs: use make provided CURDIR instead of rolling our own
Date: Tue,  1 Sep 2015 20:10:10 +0200
Message-Id: <1441131010-5439-1-git-send-email-dev@lynxeye.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This fixes broken header symlinks when make isn't triggered from the xfsprogs
source location, but as a recursion from another make in a different
directory. This is a common pattern found in cross build systems.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
---
 include/Makefile | 2 +-
 libxfs/Makefile  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/Makefile b/include/Makefile
index 51ac955..6148756 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -67,7 +67,7 @@ include $(BUILDRULES)
 install-headers: $(addsuffix -hdrs, $(PHFILES) $(DKHFILES) $(HFILES))
 
 %-hdrs:
-	$(Q)$(LN_S) -f $(PWD)/include/$* xfs/$*
+	$(Q)$(LN_S) -f $(CURDIR)/$* xfs/$*
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 85c3ed7..ecf1921 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -134,7 +134,7 @@ install: default
 install-headers: $(addsuffix -hdrs, $(PKGHFILES))
 
 %-hdrs:
-	$(Q)$(LN_S) -f $(PWD)/libxfs/$* $(TOPDIR)/include/xfs/$*
+	$(Q)$(LN_S) -f $(CURDIR)/$* $(TOPDIR)/include/xfs/$*
 
 install-dev: install
 	$(INSTALL) -m 644 $(PKGHFILES) $(PKG_INC_DIR)
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
