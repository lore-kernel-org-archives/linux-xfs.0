Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p61KrHY1101199 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 15:53:17 -0500
Received: from smtp-out.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E0B1178D5EE
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 13:53:15 -0700 (PDT)
Received: from smtp-out.google.com (smtp-out.google.com [74.125.121.67]) by
	cuda.sgi.com with ESMTP id fwqv20ckLcOOcYBZ for
	<xfs@oss.sgi.com>; Fri, 01 Jul 2011 13:53:15 -0700 (PDT)
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com
	[172.24.198.65]) by smtp-out.google.com with ESMTP id p61KrE3G028338
	for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 13:53:14 -0700
Received: from gwaa12 (gwaa12.prod.google.com [10.200.27.12])
	by wpaz1.hot.corp.google.com with ESMTP id p61KqgtM022250
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 13:53:13 -0700
Received: by gwaa12 with SMTP id a12so1803119gwa.0
	for <xfs@oss.sgi.com>; Fri, 01 Jul 2011 13:53:13 -0700 (PDT)
MIME-Version: 1.0
From: Akshay Lal <akshaylal@google.com>
Date: Fri, 1 Jul 2011 13:52:43 -0700
Message-ID: <CAP57jx5TWxwaDhp6yY+b_tBb8_WTBaRPDCfdQ3pV4Bs-S869QQ@mail.gmail.com>
Subject: [PATCH 1/1] Fix the ltp Makefile to allow for installation of all
	non-c (scripts) files
Reply-To: alal@google.com
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

Current the Makefile only builds the .c files and installs
them in the $INSTALL path. However, the ltp directory contains a shell script,
which doen't get copied over (installed) when a "make install"is invoked.

This behaviour causes test 080 to fail since it requires rwtest.sh to be
present in the ltp/ directory.

Tested: Updated the Makefile and ran a static build script & test
080.

Signed-off-by: Akshay Lal <akshaylal@google.com>
---
 ltp/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/ltp/Makefile b/ltp/Makefile
index 32cd380..d47247b 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -6,6 +6,7 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs

 TARGETS = doio fsstress fsx growfiles iogen
+SCRIPTS = rwtest.sh
 CFILES = $(TARGETS:=.c)
 HFILES = doio.h
 LDIRT = $(TARGETS)
@@ -44,5 +45,6 @@ $(TARGETS): $(LIBTEST)
 install: default
       $(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp
       $(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
+       $(INSTALL) -m 755 $(SCRIPTS) $(PKG_LIB_DIR)/ltp

 -include .dep
--
1.7.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
