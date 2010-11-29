Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATGWkHO186688 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 10:32:46 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85A21304066
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 08:34:25 -0800 (PST)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 5DC7A700204B
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 10:34:25 -0600 (CST)
Date: Mon, 29 Nov 2010 10:34:24 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: fix xfs_invutil dependency generation
Message-ID: <20101129163424.GA22014@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Correct the target name for dependency generation in the
invutil Makefile. This is now consistent with other dump
makefiles and eliminates "No such file or directory"
errors during the build.

Signed-off-by: Bill Kendall <wkendall@sgi.com>

---
 invutil/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfsdump-kernel.org/invutil/Makefile
===================================================================
--- xfsdump-kernel.org.orig/invutil/Makefile
+++ xfsdump-kernel.org/invutil/Makefile
@@ -70,7 +70,7 @@ install: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
-depend: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
+.dep: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 
 $(COMMINCL) $(COMMON):
 	@echo "    [LN]     $@"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
