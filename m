Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0G2I0tU150661 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 20:18:00 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4B25F14667
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 18:18:56 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id SGo9naIBb0EUyS3w for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2010 18:18:56 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id BFEF496E28C
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 20:18:55 -0600 (CST)
Message-ID: <4B51220F.7020703@sandeen.net>
Date: Fri, 15 Jan 2010 20:18:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests 131: kill locktest process in cleanup & better error
	msgs
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
To: xfs-oss <xfs@oss.sgi.com>

I occasionally get failures in 131 like:

gethostbyname: Success

1) perror is the wrong thing for gethostbyname errors, so this
is confusing

2) the locktest thread doesn't get killed, so the fs
is busy and the next test fails when it can't unmount

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/src/locktest.c b/src/locktest.c
index e35f6a6..7552ace 100644
--- a/src/locktest.c
+++ b/src/locktest.c
@@ -44,6 +44,8 @@
 #define PLATFORM_CLEANUP()  /*no-op*/
 #define LL                  "ll"
 
+extern int h_errno;
+
 #define inet_aton(STRING, INADDRP) \
     (((INADDRP)->s_addr = inet_addr(STRING)) == -1 ? 0 : 1)
 
@@ -937,7 +939,10 @@ main(int argc, char *argv[])
         struct hostent  *servInfo;
 
         if ((servInfo = gethostbyname(host)) == NULL) {
-            perror("gethostbyname");
+	    printf("Couldn't get hostbyname for %s", host);
+	    if (h_errno == HOST_NOT_FOUND)
+		printf(": host not found");
+	    printf("\n");
             exit(1);
             /*NOTREACHED*/
         }



diff --git a/131 b/131
index b095c2f..de83fe2 100755
--- a/131
+++ b/131
@@ -34,6 +34,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
+    kill $locktest_pid2
+    kill $locktest_pid1
     _cleanup_testdir
 }
 
@@ -60,11 +62,13 @@ fi
 
 # Start the server
 src/locktest -p $PORT $TESTFILE > $testdir/server.out 2>&1 &
+locktest_pid1=$!
 
 sleep 1
 
 # Start the client
 src/locktest -p $PORT -h localhost $TESTFILE > $testdir/client.out 2>&1
+locktest_pid2=$!
 result=$?
 if [ $result -eq 0 ]; then
     echo success!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
