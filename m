Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AA0D7F51
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 22:38:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38A528F8035
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 20:38:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bBvTtZlAkmpeP3FX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 20:38:47 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 362F583F7D
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 03:38:47 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfsprogs: fix syntax error in include/buildmacros
Date: Tue,  4 Aug 2015 11:38:29 +0800
Message-Id: <1438659509-16656-1-git-send-email-eguan@redhat.com>
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
To: xfs@oss.sgi.com
Cc: Eryu Guan <eguan@redhat.com>

There's an extra ";" in include/buildmacros, which causes make
install-dev to fail

    ......
    Installing libhandle-install-dev
    cd ../libhandle/.libs; ... if [ "x/usr/lib64" != "x/usr/lib64"; ]; ...
    /bin/sh: line 0: [: missing `]'
    /bin/sh: ]: command not found
    ......

This was introduced by
02ef543 libhandle: fix installation for symlinked /usr

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 include/buildmacros | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/buildmacros b/include/buildmacros
index 4e4e8fa..a7c5d8a 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -77,7 +77,7 @@ INSTALL_LTLIB_DEV = \
 	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
 	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
 	if [ "x$(shell readlink -f $(PKG_LIB_DIR))" != \
-	     "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))"; ]; then \
+	     "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))" ]; then \
 		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIBNAME).a; \
 		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/$(LIBNAME).la; \
 		../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
