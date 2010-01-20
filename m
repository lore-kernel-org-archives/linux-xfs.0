Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K3bJAH235614 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:37:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FA0E177465
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:38:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	PDs47ISMUY1Up4gc for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 19:38:17 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11651450-1927428
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:08:16 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXROY-00053V-Kc
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:14 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXROX-00008Y-H1
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfstests: fix printf warnings in locktest.c
Date: Wed, 20 Jan 2010 14:38:07 +1100
Message-Id: <1263958688-435-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1263958688-435-1-git-send-email-david@fromorbit.com>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 src/locktest.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/src/locktest.c b/src/locktest.c
index 7552ace..a108b6f 100644
--- a/src/locktest.c
+++ b/src/locktest.c
@@ -718,7 +718,7 @@ send_ctl(void)
 
     if (debug > 1) {
 	fprintf(stderr, "send_ctl: test=%d, command=%d offset=%"LL"d, length=%"LL"d, result=%d, error=%d\n", 
-                ctl.test, ctl.command, ctl.offset, ctl.length,ctl.result, ctl.error);
+                ctl.test, ctl.command, (long long)ctl.offset, (long long)ctl.length,ctl.result, ctl.error);
     }
 
     ctl.test= bswap_uint32(ctl.test);
@@ -741,7 +741,7 @@ send_ctl(void)
         if (nwrite < 0)
             perror("send_ctl: write");
         else
-            fprintf(stderr, "send_ctl[%d]: write() returns %d, not %d as expected\n", 
+            fprintf(stderr, "send_ctl[%d]: write() returns %d, not %lu as expected\n", 
                     ctl.test, nwrite, sizeof(ctl));
         exit(1);
         /*NOTREACHED*/
@@ -756,7 +756,7 @@ void recv_ctl(void)
         if (nread < 0)
             perror("recv_ctl: read");
         else {
-            fprintf(stderr, "recv_ctl[%d]: read() returns %d, not %d as expected\n", 
+            fprintf(stderr, "recv_ctl[%d]: read() returns %d, not %lu as expected\n", 
                     ctl.test, nread, sizeof(ctl));
 	    fprintf(stderr, "socket might has been closed by other locktest\n");
 	} 
@@ -773,7 +773,7 @@ void recv_ctl(void)
 
     if (debug > 1) {
 	fprintf(stderr, "recv_ctl: test=%d, command=%d offset=%"LL"d, length=%"LL"d, result=%d, error=%d\n", 
-                ctl.test, ctl.command, ctl.offset, ctl.length, ctl.result, ctl.error);
+                ctl.test, ctl.command, (long long)ctl.offset, (long long)ctl.length, ctl.result, ctl.error);
     }
 }
 
@@ -1040,14 +1040,16 @@ main(int argc, char *argv[])
 			fail_flag++;
 			/* We have a failure */
 			if(debug)
-			    fprintf(stderr, "Server failure in test %d, while %sing using offset %llu, length %llu - err = %d:%s\n", 
+			    fprintf(stderr, "Server failure in test %d, while %sing using offset %lld, length %lld - err = %d:%s\n", 
 					ctl.test, tests[index][COMMAND]==WRLOCK?"write lock":
 						tests[index][COMMAND]==RDLOCK?"read lock":
 						tests[index][COMMAND]==UNLOCK?"unlock":
 						tests[index][COMMAND]==F_OPEN?"open":"clos", 
-						tests[index][OFFSET], tests[index][LENGTH], saved_errno, strerror(saved_errno));
-			fprintf(stderr, "Server failure in %llu:%s\n",
-					tests[index][TEST_NUM],
+						(long long)tests[index][OFFSET],
+						(long long)tests[index][LENGTH],
+						saved_errno, strerror(saved_errno));
+			fprintf(stderr, "Server failure in %lld:%s\n",
+					(long long)tests[index][TEST_NUM],
 					descriptions[tests[index][TEST_NUM] - 1]);
 		    }
 		}
@@ -1058,12 +1060,13 @@ main(int argc, char *argv[])
 		    end=1;
 		} 
 		if(debug > 1)
-		    fprintf(stderr, "Sending command to client (%d) - %s - %llu:%llu\n", 
+		    fprintf(stderr, "Sending command to client (%d) - %s - %lld:%lld\n", 
 					index, tests[index][COMMAND]==WRLOCK?"write lock":
 					tests[index][COMMAND]==RDLOCK?"read lock":
 					tests[index][COMMAND]==UNLOCK?"unlock": 
 					tests[index][COMMAND]==F_OPEN?"open":"clos", 
-					tests[index][OFFSET], tests[index][LENGTH]);
+					(long long)tests[index][OFFSET],
+					(long long)tests[index][LENGTH]);
 		/* get the client to do something */
 		ctl.index = index;
 		send_ctl();
@@ -1075,14 +1078,15 @@ main(int argc, char *argv[])
 		    if( ctl.result == FAIL ) {
 			fail_flag++;
 			if(debug)
-			    fprintf(stderr, "Client failure in test %d, while %sing using offset %llu, length %llu - err = %d:%s\n",
+			    fprintf(stderr, "Client failure in test %d, while %sing using offset %lld, length %lld - err = %d:%s\n",
 					ctl.test, ctl.command==WRLOCK?"write lock":
 					ctl.command==RDLOCK?"read lock":
 					ctl.command==UNLOCK?"unlock":
 					ctl.command==F_OPEN?"open":"clos",
-					ctl.offset, ctl.length, ctl.error, strerror(ctl.error));
-			fprintf(stderr, "Client failure in %llu:%s\n",
-					tests[index][TEST_NUM],
+					(long long)ctl.offset, (long long)ctl.length,
+					ctl.error, strerror(ctl.error));
+			fprintf(stderr, "Client failure in %lld:%s\n",
+					(long long)tests[index][TEST_NUM],
 					descriptions[tests[index][TEST_NUM] - 1]);
 		    }
 		}
@@ -1144,7 +1148,8 @@ main(int argc, char *argv[])
 	    }
 	    if( result != tests[index][RESULT] ) {
 		if(debug)
-		    fprintf(stderr,"Got %d, wanted %llu\n", result, tests[index][RESULT]);
+		    fprintf(stderr,"Got %d, wanted %lld\n", result,
+					(long long)tests[index][RESULT]);
 		ctl.result = FAIL;
 		ctl.error = saved_errno;
 		fail_count++;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
