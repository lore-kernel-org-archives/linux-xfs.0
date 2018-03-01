Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25547 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965738AbeCAD4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 22:56:48 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1erFKn-0000Zq-JT
        for linux-xfs@vger.kernel.org; Thu, 01 Mar 2018 14:56:45 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1erFKn-0008V3-GE
        for linux-xfs@vger.kernel.org; Thu, 01 Mar 2018 14:56:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_io: fix operation time reporting
Date: Thu,  1 Mar 2018 14:56:45 +1100
Message-Id: <20180301035645.32633-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

CUrrently the 100th/sec units always report zero, such as:

32 MiB, 8192 ops; 0:00:21.00 (1.476 MiB/sec and 377.9260 ops/sec)
                          ^^

This is incorrect. Fix the maths that is wrong by removing all the
unnecesary floating point maths and just using basic integer
division...

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 libxcmd/input.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/libxcmd/input.c b/libxcmd/input.c
index 441bb2fbbf34..6e7a8c9822ee 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -154,9 +154,10 @@ tdiv(double value, struct timeval tv)
 	return value / ((double)tv.tv_sec + ((double)tv.tv_usec / 1000000.0));
 }
 
-#define HOURS(sec)	((sec) / (60 * 60))
-#define MINUTES(sec)	(((sec) % (60 * 60)) / 60)
-#define SECONDS(sec)	((sec) % 60)
+#define HOURS(sec)		((sec) / (60 * 60))
+#define MINUTES(sec)		(((sec) % (60 * 60)) / 60)
+#define SECONDS(sec)		((sec) % 60)
+#define USEC_TO_100THS(usec)	((usec) / 1000 / 10)
 
 void
 timestr(
@@ -165,14 +166,12 @@ timestr(
 	size_t		size,
 	int		format)
 {
-	double		usec = (double)tv->tv_usec / 1000000.0;
-
 	if (format & TERSE_FIXED_TIME) {
 		if (!HOURS(tv->tv_sec)) {
 			snprintf(ts, size, "%u:%02u.%02u",
 				(unsigned int) MINUTES(tv->tv_sec),
 				(unsigned int) SECONDS(tv->tv_sec),
-				(unsigned int) usec * 100);
+				(unsigned int) USEC_TO_100THS(tv->tv_usec));
 			return;
 		}
 		format |= VERBOSE_FIXED_TIME;	/* fallback if hours needed */
@@ -183,9 +182,10 @@ timestr(
 			(unsigned int) HOURS(tv->tv_sec),
 			(unsigned int) MINUTES(tv->tv_sec),
 			(unsigned int) SECONDS(tv->tv_sec),
-			(unsigned int) usec * 100);
+			(unsigned int) USEC_TO_100THS(tv->tv_usec));
 	} else {
-		snprintf(ts, size, "0.%04u sec", (unsigned int) usec * 10000);
+		snprintf(ts, size, "0.%04u sec",
+			(unsigned int) tv->tv_usec / 100);
 	}
 }
 
-- 
2.16.1

