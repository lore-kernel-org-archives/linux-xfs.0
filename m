Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n58FiLV9235804 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 10:44:21 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FFF2148FB4B
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 08:51:40 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id zXGcfJbaDNlXpiQ0 for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2009 08:51:40 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n58Fidh9014007
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 11:44:39 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n58Fiarn004303
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 11:44:39 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n58FiZRg024313
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 11:44:35 -0400
Message-ID: <4A2D31E3.3090108@sandeen.net>
Date: Mon, 08 Jun 2009 10:44:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Allow fsx tests to run on generic filesystems
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
To: xfs mailing list <xfs@oss.sgi.com>

There is already logic in 075 to gracefully skip nfs for fsx
invocations with -x (xfs-specific preallocation) - just extend
this to any non-xfs filesystem, and add to test 112 as well.

Later we can change this behavior to use fallocate and include
more filesystems but this gets some fsx coverage for now.

Test 127 doesn't seem to have anything xfs-specific, so mark
that as generic too.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/075 b/075
index 7948c1f..49d006d 100755
--- a/075
+++ b/075
@@ -66,11 +66,11 @@ _do_test()
     echo "fsx.$_n : $_filter_param"
     echo "-----------------------------------------------"
 
-    if [ "$FSTYP" = "nfs" ]
+    if [ "$FSTYP" != "xfs" ]
     then
 	if [ "$_n" = "1" -o "$_n" = "3" ]
 	then
-	    # HACK: nfs don't handle preallocation (-x) so just skip this test
+	    # HACK: only xfs handles preallocation (-x) so just skip this test
 	    return
 	fi
     fi
@@ -124,7 +124,7 @@ _process_args()
 
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 size10=`expr 10 \* 1024 \* 1024`	# 10 megabytes
diff --git a/112 b/112
index 70fa487..d6c2952 100755
--- a/112
+++ b/112
@@ -66,6 +66,15 @@ _do_test()
     echo "fsx.$_n : $_filter_param"
     echo "-----------------------------------------------"
 
+    if [ "$FSTYP" != "xfs" ]
+    then
+        if [ "$_n" = "1" -o "$_n" = "3" ]
+        then
+            # HACK: only xfs handles preallocation (-x) so just skip this test
+            return
+        fi
+    fi
+
     # This cd and use of -P gets full debug on $here (not TEST_DEV)
     cd $out
     if ! $here/ltp/fsx $_param -P $here $seq.$_n >/dev/null
@@ -113,7 +122,7 @@ _process_args()
 
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 [ -x $here/ltp/aio-stress ] || \
diff --git a/127 b/127
index 44db4fb..30f4fdb 100755
--- a/127
+++ b/127
@@ -103,7 +103,7 @@ _fsx_std_mmap()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
