Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4G1VZFZ081358 for <xfs@oss.sgi.com>; Fri, 15 May 2009 20:31:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7C3B28D996
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 18:31:42 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id DQlOCNfgTTy2GmGv for
	<xfs@oss.sgi.com>; Fri, 15 May 2009 18:31:42 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 0C2ACA9B0A4
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 20:31:41 -0500 (CDT)
Message-ID: <4A0E177C.7070902@sandeen.net>
Date: Fri, 15 May 2009 20:31:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: fix readline/editline for xfs_io and xfs_quota
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
To: xfs-oss <xfs@oss.sgi.com>

It looks like libxcmd wasn't ever being built with -DENABLE_READLINE
even when it was asked for by configure --enable-readline=yes
so xfs_io & xfs_quota didn't get the functionality.

This seems to fix it up for me (fixes editline too while we're
at it).

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---


Index: xfsprogs-3.0.1/libxcmd/Makefile
===================================================================
--- xfsprogs-3.0.1.orig/libxcmd/Makefile
+++ xfsprogs-3.0.1/libxcmd/Makefile
@@ -20,6 +20,14 @@ ifeq ($(HAVE_GETMNTINFO),yes)
 LCFLAGS += -DHAVE_GETMNTINFO
 endif
 
+ifeq ($(ENABLE_READLINE),yes)
+LCFLAGS += -DENABLE_READLINE
+endif
+
+ifeq ($(ENABLE_EDITLINE),yes)
+LCFLAGS += -DENABLE_EDITLINE
+endif
+
 default: $(LTLIBRARY)
 
 include $(BUILDRULES)

Index: xfsprogs-3.0.1/growfs/Makefile
===================================================================
--- xfsprogs-3.0.1.orig/growfs/Makefile
+++ xfsprogs-3.0.1/growfs/Makefile
@@ -10,6 +10,14 @@ LTCOMMAND = xfs_growfs
 CFILES = xfs_growfs.c
 
 LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+ifeq ($(ENABLE_READLINE),yes)
+LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
+endif
+
+ifeq ($(ENABLE_EDITLINE),yes)
+LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
+endif
+
 LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD)
 LLDFLAGS = -static
 LSRCFILES = xfs_info.sh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
