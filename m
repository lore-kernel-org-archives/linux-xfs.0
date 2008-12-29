Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTMJ660009564 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 16:19:06 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 728E017945B5
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:19:04 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id z2Aat725u8vjSPwP for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:19:04 -0800 (PST)
Message-ID: <49594CD9.3010402@sandeen.net>
Date: Mon, 29 Dec 2008 16:19:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs-cmds: fix parallel installs in include/ dirs
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Mike Frysinger <vapier@gentoo.org>

This is for http://oss.sgi.com/bugzilla/show_bug.cgi?id=759
"fix parallel issue with include/ symlinks"

Doing something like "make -j2 install install-dev" would lead
to a race of removing & creating symlinks in include/

Thanks to Mike for reporting & suggesting the fix.

Reported-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/acl/include/Makefile
===================================================================
--- xfs-cmds.orig/acl/include/Makefile
+++ xfs-cmds/acl/include/Makefile
@@ -9,10 +9,10 @@ HFILES = acl.h libacl.h acl_ea.h misc.h 
 LSRCFILES = builddefs.in buildmacros buildrules config.h.in
 LDIRT = sys acl
 
-default:
-	rm -f sys acl
-	$(LN_S) . sys
-	$(LN_S) . acl
+sys acl:
+	$(LN_S) . $@
+
+default: sys acl
 
 include $(BUILDRULES)
 
@@ -22,4 +22,5 @@ install-dev: default
 	$(INSTALL) -m 644 acl.h $(PKG_INC_DIR)/sys/acl.h
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)/acl
 	$(INSTALL) -m 644 libacl.h $(PKG_INC_DIR)/acl/libacl.h
+
 install install-lib:
Index: xfs-cmds/attr/include/Makefile
===================================================================
--- xfs-cmds.orig/attr/include/Makefile
+++ xfs-cmds/attr/include/Makefile
@@ -11,13 +11,15 @@ HFILES = $(INST_HFILES) misc.h walk_tree
 LSRCFILES = builddefs.in buildmacros buildrules config.h.in
 LDIRT = $(INCDIR)
 
-default:
-	rm -f $(INCDIR)
-	$(LN_S) . $(INCDIR)
+$(INCDIR):
+	$(LN_S) . $@
+
+default: $(INCDIR)
 
 include $(BUILDRULES)
 
 install-dev: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 	$(INSTALL) -m 644 $(INST_HFILES) $(PKG_INC_DIR)
+
 install install-lib:
Index: xfs-cmds/dmapi/include/Makefile
===================================================================
--- xfs-cmds.orig/dmapi/include/Makefile
+++ xfs-cmds/dmapi/include/Makefile
@@ -9,9 +9,10 @@ HFILES = dmapi.h
 LSRCFILES = builddefs.in buildmacros buildrules dmapi_kern.h
 LDIRT = xfs
 
-default install :
-	rm -f xfs
-	$(LN_S) . xfs
+xfs:
+	$(LN_S) . $@
+
+default install: xfs
 
 include $(BUILDRULES)
 
Index: xfs-cmds/nfs4acl/include/Makefile
===================================================================
--- xfs-cmds.orig/nfs4acl/include/Makefile
+++ xfs-cmds/nfs4acl/include/Makefile
@@ -9,9 +9,10 @@ HFILES = nfs4acl.h nfs4acl-internal.h nf
 LSRCFILES = builddefs.in buildmacros buildrules config.h.in
 LDIRT = sys
 
-default:
-	rm -f sys
-	$(LN_S) . sys
+sys:
+	$(LN_S) . $@
+
+default: sys
 
 include $(BUILDRULES)
 
@@ -19,4 +20,5 @@ install-dev: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)/sys
 	$(INSTALL) -m 644 nfs4acl.h $(PKG_INC_DIR)/sys/nfs4acl.h
+
 install install-lib:
Index: xfs-cmds/xfsprogs/include/Makefile
===================================================================
--- xfs-cmds.orig/xfsprogs/include/Makefile
+++ xfs-cmds/xfsprogs/include/Makefile
@@ -40,10 +40,10 @@ LSRCFILES += platform_defs.h.in builddef
 LSRCFILES += command.h input.h path.h project.h
 LDIRT = xfs disk
 
-default install :
-	rm -f xfs disk
-	$(LN_S) . xfs
-	$(LN_S) . disk
+xfs disk:
+	$(LN_S) . $@
+
+default install: xfs disk
 
 include $(BUILDRULES)
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
