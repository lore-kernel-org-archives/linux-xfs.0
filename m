Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T0EiAM020701 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 19:14:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4C042FC6D4
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 17:16:48 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	GpWPiAix8UkQfgbk for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 17:16:48 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10751054-1927428
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 09:46:47 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O7HQs-0007Q9-1W
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:16:46 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O7HQY-0007f3-Eu
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:16:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfsqa: build dbtest on debian platforms
Date: Thu, 29 Apr 2010 10:16:26 +1000
Message-Id: <1272500186-29393-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1272500186-29393-1-git-send-email-david@fromorbit.com>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
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

Set up autoconf to find the correct headers and compat libraries for
debian squeeze, and massage the includes to ensure the right headers get
included. Also fix a compile warning that was emitted now that it is being
compiled.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 m4/package_gdbmdev.m4 |    8 ++++++--
 src/dbtest.c          |   18 +++++++++---------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/m4/package_gdbmdev.m4 b/m4/package_gdbmdev.m4
index d826acd..6580fba 100644
--- a/m4/package_gdbmdev.m4
+++ b/m4/package_gdbmdev.m4
@@ -6,9 +6,13 @@ AC_DEFUN([AC_PACKAGE_WANT_NDBM],
   ])
 
 AC_DEFUN([AC_PACKAGE_WANT_GDBM],
-  [ AC_CHECK_HEADERS([gdbm/ndbm.h], [ have_db=true ], [ have_db=false ])
+  [ AC_CHECK_HEADERS([gdbm/ndbm.h, gdbm-ndbm.h], [ have_db=true ], [ have_db=false ])
+    libgdbm=""
+    if test $have_db = true -a -f ${libexecdir}${libdirsuffix}/libgdbm_compat.a; then
+	libgdbm="${libexecdir}${libdirsuffix}/libgdbm_compat.a"
+    fi
     if test $have_db = true -a -f ${libexecdir}${libdirsuffix}/libgdbm.a; then
-	libgdbm="${libexecdir}${libdirsuffix}/libgdbm.a"
+	libgdbm="${libgdbm} ${libexecdir}${libdirsuffix}/libgdbm.a"
     fi
     AC_SUBST(libgdbm)
     AC_SUBST(have_db)
diff --git a/src/dbtest.c b/src/dbtest.c
index 48667b7..297540f 100644
--- a/src/dbtest.c
+++ b/src/dbtest.c
@@ -18,19 +18,17 @@
  
 #include "global.h"
 
-#ifdef HAVE_GDBM_NDBM_H
+#ifdef HAVE_GDBM_NDBM_H_
 #include <gdbm/ndbm.h>
-#else
-#ifdef HAVE_GDBM_H
+#elif HAVE_GDBM_NDBM_H
+#include <gdbm-ndbm.h>
+#elif HAVE_GDBM_H
 #include <gdbm.h>
-#else
-#ifdef HAVE_NDBM_H
+#elif HAVE_NDBM_H
 #include <ndbm.h>
 #else
 bozo!
 #endif
-#endif
-#endif
 
 
 /* #define WorkDir	"/xfs" */
@@ -144,7 +142,8 @@ int InitDbmLookup(int howmany)
 		fflush(stdout);
 	}
 	dbm = dbm_open(filename, O_WRONLY|O_CREAT, 0644);
-	if(dbm == NULL) DoSysError("\ndbm_open", (int)dbm);
+	if(dbm == NULL)
+		DoSysError("\ndbm_open", -1);
 
 	if ((KeyArray = (unsigned short *)calloc( howmany,
 				sizeof(unsigned short))) == NULL)
@@ -195,7 +194,8 @@ int InitDbmLookup(int howmany)
 		fflush(stdout);
 	}
 	dbm = dbm_open(filename, O_RDONLY, 0);
-	if(dbm == NULL) DoSysError("\ndbm_open", (int)dbm);
+	if(dbm == NULL)
+		DoSysError("\ndbm_open", -1);
 	return 0;
 }
 
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
