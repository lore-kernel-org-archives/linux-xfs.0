Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 19:47:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8R2lY85011251
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 19:47:36 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id B68521803C97E
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 21:47:33 -0500 (CDT)
Message-ID: <46FB19C4.8070703@sandeen.net>
Date: Wed, 26 Sep 2007 21:47:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix up out-of-tree xfs builds
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Fix up xfs out-of-tree builds. (a.k.a. external modules)

Change -I include directives to find headers in the out-of-tree spot.
This allows a directory containing only xfs files to be built as:

  # make -C /path/to/kernel M=`pwd`

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/Makefile
===================================================================
--- linux.orig/fs/xfs/Makefile
+++ linux/fs/xfs/Makefile
@@ -16,7 +16,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-EXTRA_CFLAGS +=	 -Ifs/xfs -Ifs/xfs/linux-2.6 -funsigned-char
+EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6 -funsigned-char
 
 XFS_LINUX := linux-2.6
 
Index: linux/fs/xfs/dmapi/Makefile
===================================================================
--- linux.orig/fs/xfs/dmapi/Makefile
+++ linux/fs/xfs/dmapi/Makefile
@@ -16,8 +16,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-EXTRA_CFLAGS += -I $(TOPDIR)/fs/xfs -I $(TOPDIR)/fs/xfs/linux-2.6
-EXTRA_CFLAGS += -I $(TOPDIR)/fs/dmapi
+EXTRA_CFLAGS += -I$(src)/.. -I$(src)/../linux-2.6
+EXTRA_CFLAGS += -I$(TOPDIR)/fs/dmapi
 
 ifeq ($(CONFIG_XFS_DEBUG),y)
 	EXTRA_CFLAGS += -g -DDEBUG

Index: linux/fs/xfs/quota/Makefile
===================================================================
--- linux.orig/fs/xfs/quota/Makefile
+++ linux/fs/xfs/quota/Makefile
@@ -16,7 +16,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-EXTRA_CFLAGS += -I $(TOPDIR)/fs/xfs -I $(TOPDIR)/fs/xfs/linux-2.6
+EXTRA_CFLAGS += -I$(src)/.. -I$(src)/../linux-2.6
 
 ifeq ($(CONFIG_XFS_DEBUG),y)
 	EXTRA_CFLAGS += -g
