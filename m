Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9BA6829E1D
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 03:32:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 204FDAC002
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 01:32:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7VdoFEkblfTJDFVb for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 01:32:18 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UXSSV-00087H-Mc
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UXSSV-0000fs-Id
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] xfstests: fix broken redirects in generic/131
Date: Wed,  1 May 2013 18:32:03 +1000
Message-Id: <1367397123-2530-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1367397123-2530-1-git-send-email-david@fromorbit.com>
References: <1367397123-2530-1-git-send-email-david@fromorbit.com>
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
