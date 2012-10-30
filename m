Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UMBMBk076719 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 17:11:23 -0500
Message-Id: <20121030221310.436866758@sgi.com>
Date: Tue, 30 Oct 2012 17:12:51 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch 1/2] [PATCH 2/6] xfstests: build: use new autoconf constructs
References: <20121030221250.049661416@sgi.com>
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

Looks like AC_CONFIG_FILES existed since 2.14 already.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>

---
v2: modified to apply to xfstests -bpm

 configure.ac |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

Index: xfstests/configure.ac
===================================================================
--- xfstests.orig/configure.ac
+++ xfstests/configure.ac
@@ -1,5 +1,6 @@
-AC_INIT(src/xfsctl.c)
+AC_INIT([xfstests], [1.1.0])
 AC_PREREQ(2.50)
+AC_CONFIG_SRCDIR([src/xfsctl.c])
 AC_PACKAGE_GLOBALS(xfstests)
 AC_PACKAGE_UTILITIES(xfstests)
 
@@ -73,4 +74,5 @@ in
 esac
 
 AC_CONFIG_HEADER(include/config.h)
-AC_OUTPUT(include/builddefs)
+AC_CONFIG_FILES([include/builddefs])
+AC_OUTPUT

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
