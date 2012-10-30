Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ULUHeg073922 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 16:30:17 -0500
Message-Id: <20121030213206.971568871@sgi.com>
Date: Tue, 30 Oct 2012 16:31:51 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch 1/2] [PATCH 2/6] xfsdump: build: use new autoconf constructs
References: <20121030213150.696351829@sgi.com>
Content-Disposition: inline; filename=build-use-new-autoconf-constructs-2.patch
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
Cc: Jan Engelhardt <jengelh@inai.de>, Rich Johnston <rjohnston@sgi.com>

From: Jan Engelhardt <jengelh@inai.de>

Looks like AC_CONFIG_FILES existed since 2.14 already.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>

---
v2: minor changes to apply to xfsdump -bpm

 configure.ac |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

Index: xfsdump/configure.ac
===================================================================
--- xfsdump.orig/configure.ac
+++ xfsdump/configure.ac
@@ -1,7 +1,8 @@
-AC_INIT(common/main.c)
+AC_INIT([xfsdump], [3.1.0])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
+AC_CONFIG_SRCDIR([common/main.c])
 AC_CONFIG_HEADER(include/config.h)
 AC_PREFIX_DEFAULT(/usr)
 
@@ -83,4 +84,5 @@ AC_PACKAGE_NEED_ATTRGET_LIBATTR
 
 AC_MANUAL_FORMAT
 
-AC_OUTPUT(include/builddefs)
+AC_CONFIG_FILES([include/builddefs])
+AC_OUTPUT

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
