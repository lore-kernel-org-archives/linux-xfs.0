Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFKuhE9073771 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 14:56:43 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 216081D0E855
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 12:56:41 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hnL9taxT1m65qZrS for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 12:56:41 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RQQ3a-0007aZ-Hq
	for xfs@oss.sgi.com; Wed, 16 Nov 2011 07:56:38 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RQQ3Z-0002PI-VW
	for xfs@oss.sgi.com; Wed, 16 Nov 2011 07:56:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: detect gdbm library correctly
Date: Wed, 16 Nov 2011 07:56:37 +1100
Message-Id: <1321390597-9222-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Debian unstable has move the location of the gdbm libraries as part
of it's multi-arch conversion. The libraries are now only found by
the configured library search path in /etc/ld.conf.d, so change the
autoconf macros to test and find the libraries by link tests rather
than hard coding library paths when a header is found.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 m4/package_gdbmdev.m4 |   41 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/m4/package_gdbmdev.m4 b/m4/package_gdbmdev.m4
index 6580fba..c07f75d 100644
--- a/m4/package_gdbmdev.m4
+++ b/m4/package_gdbmdev.m4
@@ -1,19 +1,50 @@
 AC_DEFUN([AC_PACKAGE_WANT_NDBM],
   [ AC_CHECK_HEADERS(ndbm.h, [ have_db=true ], [ have_db=false ])
+    found=false
     libgdbm=""
+
+    if test $have_db = true; then
+      AC_CHECK_LIB(ndbm,dbm_open,found=true,found=false)
+      AC_CHECK_LIB(ndbm,dbm_fetch,,found=false)
+      AC_CHECK_LIB(ndbm,dbm_store,,found=false)
+      AC_CHECK_LIB(ndbm,dbm_close,,found=false)
+
+      if test $found = true; then
+        libgdbm="$ndbm"
+      fi
+    fi
+
     AC_SUBST(libgdbm)
     AC_SUBST(have_db)
   ])
 
 AC_DEFUN([AC_PACKAGE_WANT_GDBM],
   [ AC_CHECK_HEADERS([gdbm/ndbm.h, gdbm-ndbm.h], [ have_db=true ], [ have_db=false ])
+    found=false
     libgdbm=""
-    if test $have_db = true -a -f ${libexecdir}${libdirsuffix}/libgdbm_compat.a; then
-	libgdbm="${libexecdir}${libdirsuffix}/libgdbm_compat.a"
-    fi
-    if test $have_db = true -a -f ${libexecdir}${libdirsuffix}/libgdbm.a; then
-	libgdbm="${libgdbm} ${libexecdir}${libdirsuffix}/libgdbm.a"
+
+    if test $have_db = true; then
+      AC_CHECK_LIB(gdbm,dbm_open,found=true,found=false)
+      AC_CHECK_LIB(gdbm,dbm_fetch,,found=false)
+      AC_CHECK_LIB(gdbm,dbm_store,,found=false)
+      AC_CHECK_LIB(gdbm,dbm_close,,found=false)
+
+      if test $found = true; then
+        libgdbm="${libgdbm} -lgdbm"
+      fi
+
+      found="no"
+      AC_CHECK_LIB(gdbm_compat,dbm_open,found=true,found=false)
+      AC_CHECK_LIB(gdbm_compat,dbm_fetch,,found=false)
+      AC_CHECK_LIB(gdbm_compat,dbm_store,,found=false)
+      AC_CHECK_LIB(gdbm_compat,dbm_close,,found="no")
+
+      if test $found = true ; then
+        libgdbm="${libgdbm} -lgdbm_compat"
+      fi
     fi
+
     AC_SUBST(libgdbm)
     AC_SUBST(have_db)
   ])
+
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
