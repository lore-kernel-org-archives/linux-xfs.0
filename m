Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8e0Oo001349 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:40:00 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qNM6HrvYpjaGfFmX for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:39:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJbr-00013a-QE
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJbr-0003uT-M8
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/10] xfstests: add --largefs check option
Date: Thu, 26 Jul 2012 18:39:40 +1000
Message-Id: <1343291989-14987-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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

Make it easier to check large filesystems quickly by adding a
--large-fs option to check to turn on shortcuts for large scratch
device filesystem testing.

Also, reject invalid command line options with a usage message.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common |   63 +++++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/common b/common
index 0723224..7d13078 100644
--- a/common
+++ b/common
@@ -27,6 +27,35 @@ _setenvironment()
     export MSGVERB
 }
 
+usage()
+{
+    echo "Usage: $0 [options] [testlist]"'
+
+common options
+    -v			verbose
+
+check options
+    -xfs                test XFS (default)
+    -udf                test UDF
+    -nfs                test NFS
+    -l			line mode diff
+    -xdiff		graphical mode diff
+    -udiff		show unified diff (default)
+    -n			show me, do not run tests
+    -q			quick [deprecated]
+    -T			output timestamps
+    -r			randomize test order
+    --large-fs		optimise scratch device for large filesystems
+
+testlist options
+    -g group[,group...]	include tests from these groups
+    -x group[,group...]	exclude tests from these groups
+    NNN			include test NNN
+    NNN-NNN		include test range (eg. 012-021)
+'
+	    exit 0
+}
+
 here=`pwd`
 rm -f $here/$iam.out
 _setenvironment
@@ -117,30 +146,7 @@ s/ .*//p
     in
 
 	-\? | -h | --help)	# usage
-	    echo "Usage: $0 [options] [testlist]"'
-
-common options
-    -v			verbose
-
-check options
-    -xfs                test XFS (default)
-    -udf                test UDF
-    -nfs                test NFS
-    -l			line mode diff
-    -xdiff		graphical mode diff
-    -udiff		show unified diff (default)
-    -n			show me, do not run tests
-    -q			quick [deprecated]
-    -T			output timestamps
-    -r 			randomize test order
-    
-testlist options
-    -g group[,group...]	include tests from these groups
-    -x group[,group...]	exclude tests from these groups
-    NNN			include test NNN
-    NNN-NNN		include test range (eg. 012-021)
-'
-	    exit 0
+	    usage
 	    ;;
 
 	-udf)	# -udf ... set FSTYP to udf
@@ -232,6 +238,15 @@ testlist options
 	    fi
 	    ;;
 
+	--large-fs)
+	    export USE_BIG_LOOPFS=yes
+	    xpand=false
+	    ;;
+
+	-*)
+	    usage
+	    ;;
+
 	*)
 	    start=$r
 	    end=$r
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
