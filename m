Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 99CD729DF7
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:20:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8AF888F8049
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 11:20:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OxlYJBbq2Rg4LuR1 for
	<xfs@oss.sgi.com>; Mon, 21 Apr 2014 11:20:34 -0700 (PDT)
Message-ID: <5355478C.8070905@redhat.com>
Date: Mon, 21 Apr 2014 11:30:04 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: introduce FSX_AVOID env var
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>

Just like FSSTRESS_AVOID, FSX_AVOID can be used to add
options at the end of the default fsx runs in each test.
i.e. FSX_AVOID="-H -z -C" will disable punch hole, zero range,
and collapse range calls in all tests which run fsx.

This should handle Ted's concerns about buggy ext4 fallocate
code without needing to add tunables to the kernel to reject
these operations during xfstests runs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/README b/README
index 295d67f..b299c8f 100644
--- a/README
+++ b/README
@@ -68,6 +68,11 @@ Preparing system for tests (IRIX and Linux):
              - setenv FSTYP "the filesystem you want to test", the filesystem
                type is devised from the TEST_DEV device, but you may want to
                override it; if unset, the default is 'xfs'
+             - setenv FSSTRESS_AVOID and/or FSX_AVOID, which contain options
+               added to the end of fsstresss and fsx invocations, respectively,
+               in case you wish to exclude certain operational modes from these
+               tests.
+
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
           machine
diff --git a/tests/generic/075 b/tests/generic/075
index 8b4ab39..af4f34b 100755
--- a/tests/generic/075
+++ b/tests/generic/075
@@ -75,7 +75,7 @@ _do_test()
 
     # This cd and use of -P gets full debug on $here (not TEST_DEV)
     cd $out
-    if ! $here/ltp/fsx $_param -P $here $seq.$_n &>/dev/null
+    if ! $here/ltp/fsx $_param -P $here $seq.$_n $FSX_AVOID &>/dev/null
     then
 	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
 	mv $out/$seq.$_n $seqres.$_n.full
diff --git a/tests/generic/091 b/tests/generic/091
index bb176f1..e7b60fe 100755
--- a/tests/generic/091
+++ b/tests/generic/091
@@ -46,7 +46,7 @@ run_fsx()
 	echo fsx $@ | tee -a $seqres.full
 	args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
 	rm -f $TEST_DIR/junk
-	$here/ltp/fsx $args $TEST_DIR/junk >>$seqres.full 2>&1
+	$here/ltp/fsx $args $FSX_AVOID $TEST_DIR/junk >>$seqres.full 2>&1
 	if [ $? -ne 0 ]; then
 		cat $seqres.full
 		exit 1
diff --git a/tests/generic/112 b/tests/generic/112
index 4918f75..1e34d99 100755
--- a/tests/generic/112
+++ b/tests/generic/112
@@ -75,7 +75,7 @@ _do_test()
 
     # This cd and use of -P gets full debug on $here (not TEST_DEV)
     cd $out
-    if ! $here/ltp/fsx $_param -P $here $seq.$_n &>/dev/null
+    if ! $here/ltp/fsx $_param -P $here $FSX_AVOID $seq.$_n &>/dev/null
     then
 	echo "    fsx ($_param) returned $? - see $seq.$_n.full"
 	mv $seq.$_n.fsxlog $seqres.$_n.full
diff --git a/tests/generic/127 b/tests/generic/127
index 58ca91e..f6b7f95 100755
--- a/tests/generic/127
+++ b/tests/generic/127
@@ -51,7 +51,7 @@ _fsx_lite_nommap()
 {
     echo "=== FSX Light Mode, No Memory Mapping ==="
     dd if=/dev/zero of=$TEST_DIR/fsx_lite_nommap bs=${FSX_FILE_SIZE} count=1 > /dev/null 2>&1
-    if ! ltp/fsx $FSX_ARGS -L -R -W $TEST_DIR/fsx_lite_nommap > $tmp.output 2>&1
+    if ! ltp/fsx $FSX_ARGS -L -R -W $FSX_AVOID $TEST_DIR/fsx_lite_nommap > $tmp.output 2>&1
     then
         echo "ltp/fsx $FSX_ARGS -L -R -W $TEST_DIR/fsx_lite_nommap"
         cat $tmp.output
@@ -65,7 +65,7 @@ _fsx_lite_mmap()
 {
     echo "=== FSX Light Mode, Memory Mapping ==="
     dd if=/dev/zero of=$TEST_DIR/fsx_lite_mmap bs=${FSX_FILE_SIZE} count=1 > /dev/null 2>&1
-    if ! ltp/fsx $FSX_ARGS -L $TEST_DIR/fsx_lite_mmap > $tmp.output 2>&1
+    if ! ltp/fsx $FSX_ARGS -L $FSX_AVOID $TEST_DIR/fsx_lite_mmap > $tmp.output 2>&1
     then
     	echo "ltp/fsx $FSX_ARGS -L fsx_lite_mmap"
 	cat $tmp.output
@@ -78,7 +78,7 @@ _fsx_lite_mmap()
 _fsx_std_nommap()
 {
     echo "=== FSX Standard Mode, No Memory Mapping ==="
-    if ! ltp/fsx $FSX_ARGS -R -W $TEST_DIR/fsx_std_nommap > $tmp.output 2>&1
+    if ! ltp/fsx $FSX_ARGS -R -W $FSX_AVOID $TEST_DIR/fsx_std_nommap > $tmp.output 2>&1
     then
         echo "ltp/fsx $FSX_ARGS -R -W fsx_std_nommap"
         cat $tmp.output
@@ -91,7 +91,7 @@ _fsx_std_nommap()
 _fsx_std_mmap()
 {
     echo "=== FSX Standard Mode, Memory Mapping ==="
-    if ! ltp/fsx $FSX_ARGS $TEST_DIR/fsx_std_mmap > $tmp.output 2>&1
+    if ! ltp/fsx $FSX_ARGS $FSX_AVOID $TEST_DIR/fsx_std_mmap > $tmp.output 2>&1
     then
     	echo "ltp/fsx $FSX_ARGS fsx_std_mmap"
 	cat $tmp.output
diff --git a/tests/generic/231 b/tests/generic/231
index a7cff35..df7d76c 100755
--- a/tests/generic/231
+++ b/tests/generic/231
@@ -48,7 +48,7 @@ _fsx()
 		SEED=$RANDOM
 		echo "ltp/fsx $FSX_ARGS -S $SEED $SCRATCH_MNT/fsx_file$i" >>$seqres.full
 		su $qa_user -c "ltp/fsx $FSX_ARGS -S $SEED \
-			$SCRATCH_MNT/fsx_file$i" >$tmp.output$i 2>&1 &
+			$FSX_AVOID $SCRATCH_MNT/fsx_file$i" >$tmp.output$i 2>&1 &
 	done
 
 	for (( i = 1; i <= $tasks; i++ )); do
diff --git a/tests/generic/263 b/tests/generic/263
index bc59865..6ecb74d 100755
--- a/tests/generic/263
+++ b/tests/generic/263
@@ -46,7 +46,7 @@ run_fsx()
 	echo fsx $@ | tee -a $seqres.full
 	args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
 	rm -f $TEST_DIR/junk
-	$here/ltp/fsx $args $TEST_DIR/junk >>$seqres.full 2>&1
+	$here/ltp/fsx $args $FSX_AVOID $TEST_DIR/junk >>$seqres.full 2>&1
 	if [ $? -ne 0 ]; then
 		cat $seqres.full
 		exit 1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
