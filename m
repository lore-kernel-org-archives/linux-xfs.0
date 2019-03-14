Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49980 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbfCNVEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:04:23 -0400
Subject: [PATCH 05/36] debian: don't bypass top level Makefile when building
 subdirs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:04:14 -0700
Message-ID: <155259745436.31886.466306969009991047.stgit@magnolia>
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

The top level Makefile does some processing to set build environment
variables (Q and CHECK_CMD).  debian/rules uses -C to build subdirs
directly, which bypases this feature of the top-level makefile, which
causes more build spew than necessary (because Q never gets set to quiet
the build).

Since the top level makefile can be used to build the subdirs
debian/rules cares about, drop the -C and build subdirs via the top
level Makefile to quiet the build.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/rules |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debian/rules b/debian/rules
index 80dff4bb..7c2a8b3c 100755
--- a/debian/rules
+++ b/debian/rules
@@ -51,7 +51,7 @@ dibuild:
 			$(MAKE) -C $$dir NODEP=1 install-headers; \
 		done; \
 		for dir in include libxfs libxcmd libfrog mkfs; do \
-			$(MAKE) -C $$dir; \
+			$(MAKE) $$dir; \
 		done; \
 		mv mkfs/mkfs.xfs mkfs/mkfs.xfs-$(bootpkg); \
 		$(MAKE) distclean; \
