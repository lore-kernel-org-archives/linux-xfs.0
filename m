Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RIrMW9204157 for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:53:23 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C68EB1A2DC41
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:36 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 5ZWl3gvE4DGbFUCr for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:36 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 9/9] Report which tests did get run
Date: Wed, 27 May 2009 13:53:33 -0500
Message-Id: <1243450413-12681-10-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

fs type mismatches are now likely enough that it may be
nice to report which tests -were- run at the end...

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 check |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/check b/check
index 7ca17ef..348b68e 100755
--- a/check
+++ b/check
@@ -8,7 +8,8 @@
 tmp=/tmp/$$
 status=0
 needwrap=true
-try=0
+n_try=0
+try=""
 n_bad=0
 bad=""
 notrun=""
@@ -86,7 +87,7 @@ END	{ if (NR > 0) {
 	if [ -f $tmp.expunged ]
 	then
 	    notrun=`wc -l <$tmp.expunged | sed -e 's/  *//g'`
-	    try=`expr $try - $notrun`
+	    n_try=`expr $n_try - $notrun`
 	    list=`echo "$list" | sed -f $tmp.expunged`
 	fi
 
@@ -95,20 +96,26 @@ END	{ if (NR > 0) {
 	echo $list | fmt | sed -e 's/^/    /' >>check.log
 	$interrupt && echo "Interrupted!" >>check.log
         
+        if [ ! -z "$n_try" -a $n_try != 0 ]
+	then
+	    echo "Ran:$try"
+	fi
+
 	if [ ! -z "$notrun" ]
 	then
 	    echo "Not run:$notrun"
 	    echo "Not run:$notrun" >>check.log
 	fi
+
         if [ ! -z "$n_bad" -a $n_bad != 0 ]
 	then
 	    echo "Failures:$bad"
-	    echo "Failed $n_bad of $try tests"
+	    echo "Failed $n_bad of $n_try tests"
 	    echo "Failures:$bad" | fmt >>check.log
-	    echo "Failed $n_bad of $try tests" >>check.log
+	    echo "Failed $n_bad of $n_try tests" >>check.log
 	else
-	    echo "Passed all $try tests"
-	    echo "Passed all $try tests" >>check.log
+	    echo "Passed all $n_try tests"
+	    echo "Passed all $n_try tests" >>check.log
 	fi
 	needwrap=false
     fi
@@ -281,7 +288,11 @@ do
 	n_bad=`expr $n_bad + 1`
 	quick=false
     fi
-    [ -f $seq.notrun ] || try=`expr $try + 1`
+    if [ ! -f $seq.notrun ]
+    then
+	try="$try $seq"
+	n_try=`expr $n_try + 1`
+    fi
     
     seq="after_$seq"
     _check_test_fs
-- 
1.5.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
