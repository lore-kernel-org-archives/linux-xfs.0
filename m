Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE2017F8C
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 00:45:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B751130404E
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 22:45:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jf7RxWM4XVsXzPkB for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 22:45:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X6vY5-0001m1-4z
	for xfs@oss.sgi.com; Tue, 15 Jul 2014 15:45:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X6vY5-0000oW-48
	for xfs@oss.sgi.com; Tue, 15 Jul 2014 15:45:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] dump: don't redefine min() or max()
Date: Tue, 15 Jul 2014 15:45:05 +1000
Message-Id: <1405403106-3084-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1405403106-3084-1-git-send-email-david@fromorbit.com>
References: <1405403106-3084-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

They are included from other header files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/util.h     | 3 ---
 restore/dirattr.c | 2 --
 restore/namreg.c  | 2 --
 restore/node.c    | 3 ---
 4 files changed, 10 deletions(-)

diff --git a/common/util.h b/common/util.h
index 529c319..86ea8d2 100644
--- a/common/util.h
+++ b/common/util.h
@@ -67,9 +67,6 @@ extern intgen_t read_buf( char *bufp,
 			  intgen_t *statp );
 
 
-#define min( a, b )	( ( ( a ) < ( b ) ) ? ( a ) : ( b ) )
-#define max( a, b )	( ( ( a ) > ( b ) ) ? ( a ) : ( b ) )
-
 
 /* strncpyterm - like strncpy, but guarantees the destination is null-terminated
  */
diff --git a/restore/dirattr.c b/restore/dirattr.c
index 8a1fb06..fcfa0c8 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -51,8 +51,6 @@
 
 /* structure definitions used locally ****************************************/
 
-#define max( a, b )	( ( ( a ) > ( b ) ) ? ( a ) : ( b ) )
-
 /* node handle limits
  */
 #ifdef DIRATTRCHK
diff --git a/restore/namreg.c b/restore/namreg.c
index 80d558a..41362d1 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -34,8 +34,6 @@
 
 /* structure definitions used locally ****************************************/
 
-#define max( a, b )	( ( ( a ) > ( b ) ) ? ( a ) : ( b ) )
-
 #define NAMREG_AVGLEN	10
 
 /* persistent context for a namreg - placed in first page
diff --git a/restore/node.c b/restore/node.c
index b5df88a..4cc8fb0 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -30,9 +30,6 @@
 #include "node.h"
 #include "mmap.h"
 
-#define max( a, b )	( ( ( a ) > ( b ) ) ? ( a ) : ( b ) )
-#define min( a, b )	( ( ( a ) < ( b ) ) ? ( a ) : ( b ) )
-
 extern size_t pgsz;
 extern size_t pgmask;
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
