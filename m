Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T6lic7046762 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 01:47:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6F998EBF66
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 23:49:46 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	QGEL2xtvjsrMALpJ for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 23:49:46 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	22414786-1927428
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 16:19:45 +0930 (CST)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1O7NZ9-00077C-Te
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 16:49:43 +1000
Date: Thu, 29 Apr 2010 16:49:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfsqa: build dbtest on debian platforms
Message-ID: <20100429064943.GB3774@dastard>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
	<1272500186-29393-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1272500186-29393-4-git-send-email-david@fromorbit.com>
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

On Thu, Apr 29, 2010 at 10:16:26AM +1000, Dave Chinner wrote:
> Set up autoconf to find the correct headers and compat libraries for
> debian squeeze, and massage the includes to ensure the right headers get
> included. Also fix a compile warning that was emitted now that it is being
> compiled.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

I missed a O_WRONLY->O_RDWR dbm_open fix (forgot to refresh the
patch before sending the patchbomb) in this, so it builds but
doesn't run.

Updated patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfsqa: build dbtest on debian platforms

Set up autoconf to find the correct headers and compat libraries for
debian squeeze, and massage the includes to ensure the right headers get
included. Also fix a compile warning that was emitted now that it is being
compiled.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 m4/package_gdbmdev.m4 |    8 ++++++--
 src/dbtest.c          |   24 ++++++++++++------------
 2 files changed, 18 insertions(+), 14 deletions(-)

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
index 48667b7..ec8db0b 100644
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
@@ -140,11 +138,12 @@ int InitDbmLookup(int howmany)
 
 	sprintf(filename, "%s-%d", DBNAME, (int)getpid());
 	if (debugflg) {
-		printf("dbm_open(%s, O_WRONLY|O_CREAT, 0644)\n", filename);
+		printf("dbm_open(%s, O_RDWR|O_CREAT, 0644)\n", filename);
 		fflush(stdout);
 	}
-	dbm = dbm_open(filename, O_WRONLY|O_CREAT, 0644);
-	if(dbm == NULL) DoSysError("\ndbm_open", (int)dbm);
+	dbm = dbm_open(filename, O_RDWR|O_CREAT, 0644);
+	if(dbm == NULL)
+		DoSysError("\ndbm_open", -1);
 
 	if ((KeyArray = (unsigned short *)calloc( howmany,
 				sizeof(unsigned short))) == NULL)
@@ -191,11 +190,12 @@ int InitDbmLookup(int howmany)
 	}
 	dbm_close(dbm); /* close to eliminate chance of in-memory caching */
 	if (debugflg) {
-		printf("dbm_open(%s, O_RDNLY, 0)\n", filename);
+		printf("dbm_open(%s, O_RDONLY, 0)\n", filename);
 		fflush(stdout);
 	}
 	dbm = dbm_open(filename, O_RDONLY, 0);
-	if(dbm == NULL) DoSysError("\ndbm_open", (int)dbm);
+	if(dbm == NULL)
+		DoSysError("\ndbm_open", -1);
 	return 0;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
