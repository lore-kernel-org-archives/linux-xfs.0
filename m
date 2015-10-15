Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ABC197F47
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 18:47:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 488CAAC003
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 16:47:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Yitg5YOXFFnmmqzK for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 16:47:09 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZmsEY-0000yK-UL
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 10:46:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZmsEY-0003PM-TK
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 10:46:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] headers: remove definition of ASSERT from xfs.h
Date: Fri, 16 Oct 2015 10:46:54 +1100
Message-Id: <1444952814-13063-1-git-send-email-david@fromorbit.com>
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

If we define ASSERT() in the installed xfs.h header file, programs
including this header file will have their local definitions of
ASSERT screwed up. This is something internal to the xfsprogs build,
so move it to platform_defs.h.in where it will no longer be public.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/platform_defs.h.in | 6 ++++++
 include/xfs.h              | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 30dd7a4..f4e4261 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -83,4 +83,10 @@ typedef unsigned short umode_t;
 #define NBBY 8
 #endif
 
+#ifdef DEBUG
+# define ASSERT(EX)	assert(EX)
+#else
+# define ASSERT(EX)	((void) 0)
+#endif
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/include/xfs.h b/include/xfs.h
index bc94068..7bed957 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -47,12 +47,6 @@
 # error unknown platform... have fun porting!
 #endif
 
-#ifdef DEBUG
-# define ASSERT(EX)	assert(EX)
-#else
-# define ASSERT(EX)	((void) 0)
-#endif
-
 /*
  * sparse kernel source annotations
  */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
