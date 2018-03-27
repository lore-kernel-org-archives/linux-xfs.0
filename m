Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4335 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750873AbeC0H0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 03:26:42 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1f0j0C-0003Y7-3b
        for linux-xfs@vger.kernel.org; Tue, 27 Mar 2018 18:26:40 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1f0j0C-0002fR-2T
        for linux-xfs@vger.kernel.org; Tue, 27 Mar 2018 18:26:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_io: fix operation time reporting
Date: Tue, 27 Mar 2018 18:26:40 +1100
Message-Id: <20180327072640.10213-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently the 100th/sec units always report zero, such as:

32 MiB, 8192 ops; 0:00:21.00 (1.476 MiB/sec and 377.9260 ops/sec)
                          ^^
This is incorrect.

Fix it by reporting milliseconds to be consistent with other
time recording utilities. This means we can just use simple
integer divsion to implement this and remove all the confusion
around calculating non-standard units of time.

Also fix the non-verbose, sub-second time output printed 4
significant digits but only calculated the time to hundreths of a
second. Again, just use milliseconds for it.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 libxcmd/input.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/libxcmd/input.c b/libxcmd/input.c
index 441bb2fbbf34..4830494eb173 100644
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
+#define MILLISECONDS(usec)	((usec) / 1000)
 
 void
 timestr(
@@ -165,27 +166,26 @@ timestr(
 	size_t		size,
 	int		format)
 {
-	double		usec = (double)tv->tv_usec / 1000000.0;
-
 	if (format & TERSE_FIXED_TIME) {
 		if (!HOURS(tv->tv_sec)) {
-			snprintf(ts, size, "%u:%02u.%02u",
+			snprintf(ts, size, "%u:%02u.%03u",
 				(unsigned int) MINUTES(tv->tv_sec),
 				(unsigned int) SECONDS(tv->tv_sec),
-				(unsigned int) usec * 100);
+				(unsigned int) MILLISECONDS(tv->tv_usec));
 			return;
 		}
 		format |= VERBOSE_FIXED_TIME;	/* fallback if hours needed */
 	}
 
 	if ((format & VERBOSE_FIXED_TIME) || tv->tv_sec) {
-		snprintf(ts, size, "%u:%02u:%02u.%02u",
+		snprintf(ts, size, "%u:%02u:%02u.%03u",
 			(unsigned int) HOURS(tv->tv_sec),
 			(unsigned int) MINUTES(tv->tv_sec),
 			(unsigned int) SECONDS(tv->tv_sec),
-			(unsigned int) usec * 100);
+			(unsigned int) MILLISECONDS(tv->tv_usec));
 	} else {
-		snprintf(ts, size, "0.%04u sec", (unsigned int) usec * 10000);
+		snprintf(ts, size, "0.%03u sec",
+			(unsigned int) MILLISECONDS(tv->tv_usec));
 	}
 }
 
-- 
2.16.1

