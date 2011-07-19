Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J3nNqt145928 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 22:49:23 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7B997D050
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 20:49:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	hQDYW9lUPxODo2RP for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 20:49:21 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Qj1J4-00028j-5i
	for xfs@oss.sgi.com; Tue, 19 Jul 2011 13:49:14 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Qj1J3-0006ER-Sk
	for xfs@oss.sgi.com; Tue, 19 Jul 2011 13:49:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: fix modulo-by-zero error in fsx
Date: Tue, 19 Jul 2011 13:49:13 +1000
Message-Id: <1311047353-23925-1-git-send-email-david@fromorbit.com>
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

The recent fsx fixes has a logic error in the offset trimming code.
If a read is done when the file size is zero, then the logic error
causes a offset % 0 opertaion to occur. This causes fsx to get a
SIGFPE and die.

This was not discovered during my testing because I was using a
random seed that didn't trip this condition. Changing the seed to
that which test 091 uses (the default of 1) causes such an operation
to occur....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 ltp/fsx.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 771bcdc..d53c498 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -987,14 +987,14 @@ docloseopen(void)
 	}
 }
 
-#define TRIM_OFF_LEN(off, len, size, zero_offset)	\
-do {					\
-	if (!zero_offset || file_size)	\
-		offset %= size;		\
-	else				\
-		offset = 0;		\
-	if (offset + len > size)	\
-		len = size - offset;	\
+#define TRIM_OFF_LEN(off, len, size, allow_zero_file_size)	\
+do {						\
+	if (allow_zero_file_size || file_size)	\
+		offset %= size;			\
+	else					\
+		offset = 0;			\
+	if (offset + len > size)		\
+		len = size - offset;		\
 } while (0)
 
 void
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
