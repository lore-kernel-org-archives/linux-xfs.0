Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VMDoav240067 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 17:13:50 -0500
Message-Id: <20121031221537.911583684@sgi.com>
Date: Wed, 31 Oct 2012 17:15:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch 1/1] xfsdump: enable gettext
References: <20121031221513.348916389@sgi.com>
Content-Disposition: inline; filename=xfsdump-enable-gettext
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
Cc: Phil White <pwhite@sgi.com>

ENABLE_GETTEXT was not being defined when --enable-gettext
was specified as a config option, neither the German or
Polish translations were working.  Add this define to
builddefs.in

See commit e84ec15d in xfsprogs.

Signed-off-by: Ben Myers <bpm@sgi.com>
Index: xfsdump/include/builddefs.in
===================================================================
--- xfsdump.orig/include/builddefs.in
+++ xfsdump/include/builddefs.in
@@ -95,6 +95,10 @@ GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include
 
+ifeq ($(ENABLE_GETTEXT),yes)
+GCFLAGS += -DENABLE_GETTEXT
+endif
+
 # First, Global, Platform, Local CFLAGS
 CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
