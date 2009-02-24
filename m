Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OEwKk2149766 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 08:58:20 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19FB51994772
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 06:57:49 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id SPVL2uJoJiu2MdVT for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 06:57:49 -0800 (PST)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 3E27E64C28
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 14:57:18 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] fix parallel builds
Date: Tue, 24 Feb 2009 09:57:17 -0500
Message-Id: <1235487437-20761-1-git-send-email-vapier@gentoo.org>
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

I noticed that xfsprogs-3.0.0 sometimes fails to build in parallel with an
error about fsr not being able to find libhandle.  Looking at the top level
Makefile shows the obvious missing depend (fsr: libhandle).  Playing around
a bit found a few more not so obvious missing depends on the include subdir
so I fixed that too.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Makefile |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index b450150..133e496 100644
--- a/Makefile
+++ b/Makefile
@@ -15,11 +15,11 @@ LSRCFILES = configure configure.in Makepkgs aclocal.m4 install-sh README VERSION
 LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	Logs/* built .census install.* install-dev.* *.gz
 
-LIB_SUBDIRS = include libxfs libxlog libxcmd libhandle libdisk
+LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc po debian build
 
-SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
 default: include/builddefs include/platform_defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
@@ -29,9 +29,10 @@ else
 endif
 
 # tool/lib dependencies
-libxcmd: include
+$(LIB_SUBDIRS) $(TOOL_SUBDIRS): include
 copy mdrestore: libxfs
 db logprint: libxfs libxlog
+fsr: libhandle
 growfs: libxfs libxcmd
 io: libxcmd libhandle
 mkfs: libxfs libdisk
-- 
1.6.1.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
