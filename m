Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 176CE29DF8
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 02:53:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAB7630406B
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 00:53:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fUMC5ajoLip9nMBz for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 00:53:34 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UXRr2-00083B-PF
	for xfs@oss.sgi.com; Wed, 01 May 2013 17:53:32 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UXRr2-0000IZ-Ky
	for xfs@oss.sgi.com; Wed, 01 May 2013 17:53:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: fix broken redirects in generic/131
Date: Wed,  1 May 2013 17:53:32 +1000
Message-Id: <1367394812-1117-1-git-send-email-david@fromorbit.com>
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

generic/131 attempts to kill processes that may no longer exist when
the test finishes and has a broken redirect for the error messages
and they end up in a file nemaed "1" in the xfstests root instead of
/dev/null.

Not only that, the attempts to redirect stderr to stdout in the
middle of the test use incorrect redirect syntax, so they create an
empty file named "1" in the xfstests root...

IOWs, all the redirects in the test are broken. Fix them and clean
up the failure case to use the exit trap to trigger the cleanup
function....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/131 |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tests/generic/131 b/tests/generic/131
index 95eb612..6c3131c 100755
--- a/tests/generic/131
+++ b/tests/generic/131
@@ -33,8 +33,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    kill $locktest_pid2 2&>1 /dev/null
-    kill $locktest_pid1 2&>1 /dev/null
+    kill $locktest_pid2 > /dev/null 2>&1
+    kill $locktest_pid1 > /dev/null 2>&1
     _cleanup_testdir
 }
 
@@ -60,23 +60,21 @@ elif [ $$ -gt 32000 ]; then
 fi
 
 # Start the server
-src/locktest -p $PORT $TESTFILE > $testdir/server.out 2>&1 &
+src/locktest -p $PORT $TESTFILE 2>&1 > $testdir/server.out &
 locktest_pid1=$!
 
 sleep 1
 
 # Start the client
-src/locktest -p $PORT -h localhost $TESTFILE > $testdir/client.out 2>&1
+src/locktest -p $PORT -h localhost $TESTFILE 2>&1 > $testdir/client.out
 locktest_pid2=$!
 result=$?
 if [ $result -eq 0 ]; then
-    echo success!
+	echo success!
+	status=0
 else
-    echo "Client reported failure ($result)"
-    cat $testdir/*.out
-    _cleanup
-    exit $status
+	echo "Client reported failure ($result)"
+	cat $testdir/*.out
 fi
 
-status=0
 exit
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
