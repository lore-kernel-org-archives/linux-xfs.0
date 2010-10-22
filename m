Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9ME8CTq181855 for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 09:08:13 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201010221409.o9ME9OTQ003885@stout.americas.sgi.com>
Date: Fri, 22 Oct 2010 09:09:24 -0500
Subject: [PATCH] xfstests: use a common _filter_test_dir function
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Christoph Hellwig suggested that a function similar to the common
"_filter_scratch" function ought to be created to handle filtering
of the TEST_DIR and TEST_DEV variables.  This patch implements that.

The name "_filter_test" seems like it might suggest it does
something different, so I'm calling this one "_filter_test_dir".
This unfortunately makes the "test" and "scratch" functions have
different naming conventions, but I guess we should be accustomed
to that by now (consider "TEST_DIR" and "SCRATCH_MNT").

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 084           |    3 +--
 084.out       |    4 ++--
 088           |    3 +--
 203           |    2 +-
 common.filter |    5 +++++
 5 files changed, 10 insertions(+), 7 deletions(-)

Index: b/084
===================================================================
--- a/084
+++ b/084
@@ -39,8 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 
 _filter_resv()
 {
-	sed -e "s,$TEST_DIR/resv,[TESTFILE],g" \
-	    -e 's/[0-9][0-9]* bytes/NUM bytes/g'
+	_filter_test_dir | sed -e 's/[0-9][0-9]* bytes/NUM bytes/g'
 }
 
 pgsize=`$here/src/feature -s`
Index: b/084.out
===================================================================
--- a/084.out
+++ b/084.out
@@ -1,9 +1,9 @@
 QA output created by 084
 
 *** First case - I/O blocksize same as pagesize
-reserved NUM bytes for [TESTFILE] using XFS_IOC_RESVSP64
+reserved NUM bytes for TEST_DIR/resv using XFS_IOC_RESVSP64
 done
 
 *** Second case - 512 byte I/O blocksize
-reserved NUM bytes for [TESTFILE] using XFS_IOC_RESVSP64
+reserved NUM bytes for TEST_DIR/resv using XFS_IOC_RESVSP64
 done
Index: b/088
===================================================================
--- a/088
+++ b/088
@@ -39,8 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 
 _filter()
 {
-    sed -e "s#$TEST_DIR#TEST_DIR#g" \
-        -e '/----------/d'
+    _filter_test_dir | sed -e '/----------/d'
 }
 
 # link correct .out file
Index: b/203
===================================================================
--- a/203
+++ b/203
@@ -48,7 +48,7 @@ _write_holes()
 #       1: [8..2047]: hole
 _filter_bmap()
 {
-	sed "s#$TEST_DIR#TEST_DIR#g" | \
+	_filter_test_dir |
 	awk '$3 ~ /hole/ { print $1, $2, $3; next }
              {print $1, $2; next}'
 }
Index: b/common.filter
===================================================================
--- a/common.filter
+++ b/common.filter
@@ -214,6 +214,11 @@ _filter_xfs_io_unique()
     common_line_filter | _filter_xfs_io
 }
 
+_filter_test_dir()
+{
+	sed -e "s,$TEST_DEV,TEST_DEV,g" -e "s,$TEST_DIR,TEST_DIR,g"
+}
+
 _filter_scratch()
 {
 	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
