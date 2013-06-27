Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C1AE37F3F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 10:57:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF805304051
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 08:57:47 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id fGWeGEti1e6clBvf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 08:57:46 -0700 (PDT)
Date: Thu, 27 Jun 2013 11:57:36 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v2] xfstests: fix README, FSTYP options
Message-ID: <20130627115736.66d28ca1@oracle.com>
In-Reply-To: <20130626005029.GY29376@dastard>
References: <20130625153423.513e4074@oracle.com>
	<20130626005029.GY29376@dastard>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

commit cbcc88fb changed test selection to use shell globs, so fixup the
examples given in the README file.

remove options for FSTYP other than NFS since the FSTYP will be automatically
detected (on Linux) from $TEST_DEV.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 README | 8 +++++---
 check  | 4 ----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/README b/README
index d4d4f31..da75dcf 100644
--- a/README
+++ b/README
@@ -81,9 +81,11 @@ Running tests:
 
     - cd xfstests
     - By default the tests suite will run xfs tests:
-    - ./check 001 002 003 ... or you can explicitly run a filesystem: 
-      ./check -xfs [test(s)]
-    - You can run a range of tests: ./check 067-078
+    - ./check '*/001' '*/002' '*/003'
+    - ./check '*/06?'
+    - You can explicitly specify NFS, otherwise the filesystem type will be
+      autodetected from $TEST_DEV:
+      ./check -nfs [test(s)]
     - Groups of tests maybe ran by: ./check -g [group(s)]
       See the 'group' file for details on groups
     - for udf tests: ./check -udf [test(s)]
diff --git a/check b/check
index ff8fbcf..4085eae 100755
--- a/check
+++ b/check
@@ -73,8 +73,6 @@ usage()
     echo "Usage: $0 [options] [testlist]"'
 
 check options
-    -xfs                test XFS (default)
-    -udf                test UDF
     -nfs                test NFS
     -l			line mode diff
     -udiff		show unified diff (default)
@@ -159,8 +157,6 @@ while [ $# -gt 0 ]; do
 	case "$1" in
 	-\? | -h | --help) usage ;;
 
-	-udf)	FSTYP=udf ;;
-	-xfs)	FSTYP=xfs ;;
 	-nfs)	FSTYP=nfs ;;
 
 	-g)	group=$2 ; shift ;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
