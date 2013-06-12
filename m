Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B1FB8031
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B7E18F8037
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:08 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9KGFPwqDXYARoWDA for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:37:06 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiQD-0001By-WA
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:58 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiQ3-0006o2-Tp
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 21/22] xfsprogs: define min/max once and use them everywhere.
Date: Wed, 12 Jun 2013 20:36:33 +1000
Message-Id: <1371033394-26006-22-git-send-email-david@fromorbit.com>
In-Reply-To: <1371033394-26006-1-git-send-email-david@fromorbit.com>
References: <1371033394-26006-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h           |    1 -
 include/platform_defs.h.in |    5 +++++
 io/init.h                  |    3 ---
 libxfs/rdwr.c              |    1 -
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index e57e2fd..6331067 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -72,7 +72,6 @@
 #define __round_mask(x, y) ((__typeof__(x))((y)-1))
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
-#define min(a,b)	((a) < (b) ? (a) : (b))
 
 /*
  * Argument structure for libxfs_init().
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 217d6c0..03391f5 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -168,4 +168,9 @@ typedef unsigned long long __psunsigned_t;
 #define __arch_pack
 #endif
 
+#ifndef min
+#define min(a,b)	(((a)<(b))?(a):(b))
+#define max(a,b)	(((a)>(b))?(a):(b))
+#endif
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/io/init.h b/io/init.h
index 1dac211..d773b1b 100644
--- a/io/init.h
+++ b/io/init.h
@@ -26,7 +26,4 @@ extern int	expert;
 extern size_t	pagesize;
 extern struct timeval stopwatch;
 
-#define min(a,b)	(((a)<(b))?(a):(b))
-#define max(a,b)	(((a)>(b))?(a):(b))
-
 extern void init_cvtnum(size_t *blocksize, size_t *sectsize);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index c679f81..93beb23 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -22,7 +22,6 @@
 #include "init.h"
 
 #define BDSTRAT_SIZE	(256 * 1024)
-#define min(x, y)	((x) < (y) ? (x) : (y))
 
 #define IO_BCOMPARE_CHECK
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
