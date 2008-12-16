Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBGKNA1m012031
	for <linux-xfs@oss.sgi.com>; Tue, 16 Dec 2008 14:23:10 -0600
Received: from carme.pld-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31E1F27761
	for <linux-xfs@oss.sgi.com>; Tue, 16 Dec 2008 12:23:08 -0800 (PST)
Received: from carme.pld-linux.org (carme.pld-linux.org [193.239.45.140]) by
	cuda.sgi.com with ESMTP id omAeHG5oMaqW5fUX for
	<linux-xfs@oss.sgi.com>; Tue, 16 Dec 2008 12:23:08 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: [PATCH] build system: Make --enable-gettext actually enable gettext.
Date: Tue, 16 Dec 2008 21:23:08 +0100
Message-Id: <1229458988-91783-1-git-send-email-arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: linux-xfs@oss.sgi.com

ENABLE_GETTEXT wasn't defined when --enable-gettext was
passed as configure option. Now this is fixed.
---
 xfsprogs/include/builddefs.in |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/xfsprogs/include/builddefs.in b/xfsprogs/include/builddefs.in
index f1b4340..f07d8d6 100644
--- a/xfsprogs/include/builddefs.in
+++ b/xfsprogs/include/builddefs.in
@@ -118,6 +118,10 @@ GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include
 
+ifeq ($(ENABLE_GETTEXT),yes)
+GCFLAGS += -DENABLE_GETTEXT
+endif
+
 # First, Global, Platform, Local CFLAGS
 CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
 
-- 
1.6.0.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
