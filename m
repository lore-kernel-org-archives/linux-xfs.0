Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p680s6S5204487 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 19:54:06 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2DD9E8E8BA
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 17:54:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pgVdzSs6TTb91GGW for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 17:54:05 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QezKR-0003RE-MT
	for xfs@oss.sgi.com; Fri, 08 Jul 2011 10:53:59 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QezKH-0007yS-Di
	for xfs@oss.sgi.com; Fri, 08 Jul 2011 10:53:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfstests: fix brain-o in fallocate log dump
Date: Fri,  8 Jul 2011 10:53:45 +1000
Message-Id: <1310086426-30605-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1310086426-30605-1-git-send-email-david@fromorbit.com>
References: <1310086426-30605-1-git-send-email-david@fromorbit.com>
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

fsx segvs when dumping fallocate log entries. Fix magic string
array index parameters to be zero based rather than one based.

While touching log string related stuff, make the format consistent
with read and write operations so the log dump is easier to look at
with the human eye.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 ltp/fsx.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 41d7c20..62dea0b 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -252,14 +252,14 @@ logdump(void)
 		int opnum;
 
 		opnum = i+1 + (logcount/LOGSIZE)*LOGSIZE;
-		prt("%d(%d mod 256): ", opnum, opnum%256);
+		prt("%d(%3d mod 256): ", opnum, opnum%256);
 		lp = &oplog[i];
 		if ((closeopen = lp->operation < 0))
 			lp->operation = ~ lp->operation;
 			
 		switch (lp->operation) {
 		case OP_MAPREAD:
-			prt("MAPREAD\t0x%x thru 0x%x\t(0x%x bytes)",
+			prt("MAPREAD  0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
 			if (badoff >= lp->args[0] && badoff <
@@ -275,7 +275,7 @@ logdump(void)
 				prt("\t******WWWW");
 			break;
 		case OP_READ:
-			prt("READ\t0x%x thru 0x%x\t(0x%x bytes)",
+			prt("READ     0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
 			if (badoff >= lp->args[0] &&
@@ -283,7 +283,7 @@ logdump(void)
 				prt("\t***RRRR***");
 			break;
 		case OP_WRITE:
-			prt("WRITE\t0x%x thru 0x%x\t(0x%x bytes)",
+			prt("WRITE    0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
 			if (lp->args[0] > lp->args[2])
@@ -304,14 +304,15 @@ logdump(void)
 			break;
 		case OP_FALLOCATE:
 			/* 0: offset 1: length 2: where alloced */
-			prt("FALLOCATE %s\tfrom 0x%x to 0x%x",
-			    falloc_type[lp->args[2]], lp->args[0], lp->args[0] + lp->args[1]);
+			prt("FALLOC   0x%x thru 0x%x\t(0x%x bytes) %s",
+				lp->args[0], lp->args[0] + lp->args[1],
+				lp->args[1], falloc_type[lp->args[2]]);
 			if (badoff >= lp->args[0] &&
 			    badoff < lp->args[0] + lp->args[1])
 				prt("\t******FFFF");
 			break;
 		case OP_PUNCH_HOLE:
-			prt("PUNCH HOLE\t0x%x thru 0x%x\t(0x%x bytes)",
+			prt("PUNCH    0x%x thru 0x%x\t(0x%x bytes)",
 			    lp->args[0], lp->args[0] + lp->args[1] - 1,
 			    lp->args[1]);
 			if (badoff >= lp->args[0] && badoff <
@@ -906,12 +907,12 @@ do_preallocate(unsigned offset, unsigned length)
 	}
 
 	/*
-	 * last arg:
-	 * 	1: allocate past EOF
-	 * 	2: extending prealloc
-	 * 	3: interior prealloc
+	 * last arg matches fallocate string array index in logdump:
+	 * 	0: allocate past EOF
+	 * 	1: extending prealloc
+	 * 	2: interior prealloc
 	 */
-	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? (keep_size ? 1 : 2) : 3);
+	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? (keep_size ? 0 : 1) : 2);
 
 	if (end_offset > file_size) {
 		memset(good_buf + file_size, '\0', end_offset - file_size);
@@ -924,7 +925,8 @@ do_preallocate(unsigned offset, unsigned length)
 	if ((progressinterval && testcalls % progressinterval == 0) ||
 	    (debug && (monitorstart == -1 || monitorend == -1 ||
 		      end_offset <= monitorend)))
-		prt("%lu falloc\tfrom 0x%x to 0x%x\n", testcalls, offset, length);
+		prt("%lu falloc\tfrom 0x%x to 0x%x (0x%x bytes)\n", testcalls,
+				offset, offset + length, length);
 	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, (loff_t)length) == -1) {
 	        prt("fallocate: %x to %x\n", offset, length);
 		prterr("do_preallocate: fallocate");
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
