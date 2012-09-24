Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ONcKSH229928 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 18:38:20 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id SKmO859letRNoieH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 16:39:36 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id CB1A733D704
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 23:39:35 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 3/3] install shared libs with +x bits
Date: Mon, 24 Sep 2012 19:39:38 -0400
Message-Id: <1348529978-30048-3-git-send-email-vapier@gentoo.org>
In-Reply-To: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
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
To: xfs@oss.sgi.com

These are shared libs w/executable code, so make sure they have +x bits
set on them.  Some kernels will proactively disallow executable mmaps if
the files lack +x bits.  It's also the right thing to do.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/buildmacros | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/buildmacros b/include/buildmacros
index 31c7eb0..7a01880 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -58,7 +58,7 @@ ifeq ($(ENABLE_SHARED),yes)
 INSTALL_LTLIB = \
 	cd $(TOPDIR)/$(LIBNAME)/.libs; \
 	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
-	../$(INSTALL) -m 644 -T so_dot_version $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
+	../$(INSTALL) -m 755 -T so_dot_version $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
 	../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_ROOT_LIB_DIR)
 endif
 
-- 
1.7.12

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
