Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALBVjkk255448 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:31:45 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 925B456F9F2
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 03:31:43 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PEmNSiYqntYk9Yfx for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 03:31:43 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfstests: add --largefs check option
Date: Mon, 21 Nov 2011 22:31:21 +1100
Message-Id: <1321875088-30801-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Make it easier to check large filesystems quickly by adding a
--large-fs option to check to turn on shortcuts for large scratch
device filesystem testing.

Also, reject invalid command line options with a usage message.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common |   63 +++++++++++++++++++++++++++++++++++++++------------------------
 1 files changed, 39 insertions(+), 24 deletions(-)

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
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
