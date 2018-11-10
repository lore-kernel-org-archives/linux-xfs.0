Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35884 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbeKJVgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 16:36:39 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] generic: move prealloc-enabled fsx to separate tests
Date: Sat, 10 Nov 2018 12:51:41 +0100
Message-Id: <20181110115145.30356-2-hch@lst.de>
In-Reply-To: <20181110115145.30356-1-hch@lst.de>
References: <20181110115145.30356-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Currently generic/075 and generic/112 have two extra fsx passes each that
exercise fsx with preallocation, which are only enabled for XFS.

These tests can also be run with other file systems, given that the XFS
prealloc ioctls are implemented in generic code since the addition of
the fallocate system call.  This also means a version of XFS that does
not support preallocation (e.g. because it always writes out of place)
can skip the prealloc tests while still completing the normal fsx tests
just fine.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/075     |   7 +--
 tests/generic/075.out |  10 +--
 tests/generic/112     |  13 +---
 tests/generic/112.out |  10 +--
 tests/generic/601     | 136 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/601.out |  10 +++
 tests/generic/602     | 137 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/602.out |  10 +++
 tests/generic/group   |   2 +
 9 files changed, 299 insertions(+), 36 deletions(-)
 create mode 100755 tests/generic/601
 create mode 100644 tests/generic/601.out
 create mode 100755 tests/generic/602
 create mode 100644 tests/generic/602.out

diff --git a/tests/generic/075 b/tests/generic/075
index 2b957891..424ec485 100755
--- a/tests/generic/075
+++ b/tests/generic/075
@@ -48,14 +48,11 @@ _do_test()
     echo "fsx.$_n : $_filter_param"
     echo "-----------------------------------------------"
 
-    if [ "$FSTYP" != "xfs" ]
-    then
 	if [ "$_n" = "1" -o "$_n" = "3" ]
 	then
 	    # HACK: only xfs handles preallocation (-x) so just skip this test
 	    return
 	fi
-    fi
 
     # This cd and use of -P gets full debug on $here (not TEST_DEV)
     cd $out
@@ -138,9 +135,7 @@ _check_test_fs
 # -x: pre-allocate file space, exercising unwritten extents
 
 _do_test 0 "-d -N $numops1 -S 0"
-_do_test 1 "-d -N $numops1 -S 0 -x"
-_do_test 2 "-d -N $numops2 -l $filelen -S 0"
-_do_test 3 "-d -N $numops2 -l $filelen -S 0 -x"
+_do_test 1 "-d -N $numops2 -l $filelen -S 0"
 
 rm -f $seq.*.fsx{good,log}
 exit 0
diff --git a/tests/generic/075.out b/tests/generic/075.out
index 1f81cdf0..3ad4ae95 100644
--- a/tests/generic/075.out
+++ b/tests/generic/075.out
@@ -6,13 +6,5 @@ fsx.0 : -d -N numops -S 0
 -----------------------------------------------
 
 -----------------------------------------------
-fsx.1 : -d -N numops -S 0 -x
------------------------------------------------
-
------------------------------------------------
-fsx.2 : -d -N numops -l filelen -S 0
------------------------------------------------
-
------------------------------------------------
-fsx.3 : -d -N numops -l filelen -S 0 -x
+fsx.1 : -d -N numops -l filelen -S 0
 -----------------------------------------------
diff --git a/tests/generic/112 b/tests/generic/112
index 1879e7b5..c9c5e194 100755
--- a/tests/generic/112
+++ b/tests/generic/112
@@ -48,15 +48,6 @@ _do_test()
     echo "fsx.$_n : $_filter_param"
     echo "-----------------------------------------------"
 
-    if [ "$FSTYP" != "xfs" ]
-    then
-        if [ "$_n" = "1" -o "$_n" = "3" ]
-        then
-            # HACK: only xfs handles preallocation (-x) so just skip this test
-            return
-        fi
-    fi
-
     # This cd and use of -P gets full debug on $here (not TEST_DEV)
     cd $out
     if ! $here/ltp/fsx $_param -P $here $FSX_AVOID $seq.$_n &>/dev/null
@@ -139,9 +130,7 @@ _check_test_fs
 # -A: use the AIO system calls
 
 _do_test 0 "-A -d -N $numops1 -S 0"
-_do_test 1 "-A -d -N $numops1 -S 0 -x"
-_do_test 2 "-A -d -N $numops2 -l $filelen -S 0"
-_do_test 3 "-A -d -N $numops2 -l $filelen -S 0 -x"
+_do_test 1 "-A -d -N $numops2 -l $filelen -S 0"
 
 rm -f $seq.*.fsx{good,log}
 exit 0
diff --git a/tests/generic/112.out b/tests/generic/112.out
index 7d1709cf..488ec682 100644
--- a/tests/generic/112.out
+++ b/tests/generic/112.out
@@ -6,13 +6,5 @@ fsx.0 : -A -d -N numops -S 0
 -----------------------------------------------
 
 -----------------------------------------------
-fsx.1 : -A -d -N numops -S 0 -x
------------------------------------------------
-
------------------------------------------------
-fsx.2 : -A -d -N numops -l filelen -S 0
------------------------------------------------
-
------------------------------------------------
-fsx.3 : -A -d -N numops -l filelen -S 0 -x
+fsx.1 : -A -d -N numops -l filelen -S 0
 -----------------------------------------------
diff --git a/tests/generic/601 b/tests/generic/601
new file mode 100755
index 00000000..3fb785a1
--- /dev/null
+++ b/tests/generic/601
@@ -0,0 +1,136 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2000-2003 Silicon Graphics, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 601
+#
+# fsx (non-AIO variant, with preallocation)
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0	# success is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $TEST_DIR/fsx.* $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_do_test()
+{
+    _n="$1"
+    _param="$2"
+
+    out=$TEST_DIR/fsx
+    rm -rf $out
+    if ! mkdir $out
+    then
+	echo "    failed to mkdir $out"
+	status=1
+	exit
+    fi
+
+    _filter_param=`echo "$_param" | sed\
+	-e 's/-N [0-9][0-9]*/-N numops/' \
+	-e 's/-l [0-9][0-9]*/-l filelen/'`
+
+    echo ""
+    echo "-----------------------------------------------"
+    echo "fsx.$_n : $_filter_param"
+    echo "-----------------------------------------------"
+
+    # This cd and use of -P gets full debug on $here (not TEST_DEV)
+    cd $out
+    if ! $here/ltp/fsx $_param -P $here $seq.$_n $FSX_AVOID &>/dev/null
+    then
+	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
+	mv $out/$seq.$_n $seqres.$_n.full
+	mv $here/$seq.$_n.fsxlog $seqres.$_n.fsxlog
+	od -xAx $seqres.$_n.full > $seqres.$_n.bad
+	od -xAx $here/$seq.$_n.fsxgood > $seqres.$_n.good
+	rm -f $here/$seq.$_n.fsxgood
+	status=1
+	exit
+    fi
+
+    cd $here
+    _check_test_fs
+}
+
+_usage()
+{
+    echo "$0: [-l filelen] [-n numops1] [-N numops2]"
+}
+
+_process_args()
+{
+    OPTIND=1
+    while getopts "l:n:N:?" c $@
+    do
+        case $c
+        in
+            l)
+                filelen=$OPTARG
+		param_type="$param_type, overidde -l"
+                ;;
+            N)
+                numops2=$OPTARG
+		param_type="$param_type, overidde -N"
+                ;;
+            n)
+                numops1=$OPTARG
+		param_type="$param_type, overidde -n"
+                ;;
+	    ?)
+		_usage
+		exit	
+		;;
+	esac
+    done
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_xfs_io_command "falloc"
+
+size10=`expr 10 \* 1024 \* 1024`	# 10 megabytes
+filelen=$size10
+numops1=1000
+numops2=10000
+
+# can override the params here
+_process_args "$@"
+
+echo "Params are for $param_type" >>$seqres.full
+echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seqres.full
+
+rm -f $seqres.full
+echo "brevity is wit..."
+
+_check_test_fs
+
+# Options:
+# -d: debug output for all operations
+# -l flen: the upper bound on file size (default 262144)
+# -o oplen: the upper bound on operation size
+# -N numops: total # operations to do (default infinity)
+# -P: save .fsxlog and .fsxgood files in dirpath (default ./)
+# -S seed: for random # generator (default 1) 0 gets timestamp
+# -x: pre-allocate file space, exercising unwritten extents
+
+_do_test 0 "-d -N $numops1 -S 0 -x"
+_do_test 1 "-d -N $numops2 -l $filelen -S 0 -x"
+
+rm -f $seq.*.fsx{good,log}
+exit 0
diff --git a/tests/generic/601.out b/tests/generic/601.out
new file mode 100644
index 00000000..d1346da2
--- /dev/null
+++ b/tests/generic/601.out
@@ -0,0 +1,10 @@
+QA output created by 601
+brevity is wit...
+
+-----------------------------------------------
+fsx.0 : -d -N numops -S 0 -x
+-----------------------------------------------
+
+-----------------------------------------------
+fsx.1 : -d -N numops -l filelen -S 0 -x
+-----------------------------------------------
diff --git a/tests/generic/602 b/tests/generic/602
new file mode 100755
index 00000000..ec853eb1
--- /dev/null
+++ b/tests/generic/602
@@ -0,0 +1,137 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 602
+#
+# fsx (AIO variant, with preallocation, based on 601)
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0	# success is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $TEST_DIR/fsx.* $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_do_test()
+{
+    _n="$1"
+    _param="$2"
+
+    out=$TEST_DIR/fsx
+    rm -rf $out
+    if ! mkdir $out
+    then
+	echo "    failed to mkdir $out"
+	status=1
+	exit
+    fi
+
+    _filter_param=`echo "$_param" | sed\
+	-e 's/-N [0-9][0-9]*/-N numops/' \
+	-e 's/-l [0-9][0-9]*/-l filelen/'`
+
+    echo ""
+    echo "-----------------------------------------------"
+    echo "fsx.$_n : $_filter_param"
+    echo "-----------------------------------------------"
+
+    # This cd and use of -P gets full debug on $here (not TEST_DEV)
+    cd $out
+    if ! $here/ltp/fsx $_param -P $here $FSX_AVOID $seq.$_n &>/dev/null
+    then
+	echo "    fsx ($_param) returned $? - see $seq.$_n.full"
+	mv $here/$seq.$_n.fsxlog $seqres.$_n.full
+	status=1
+	exit
+    fi
+
+    cd $here
+    _check_test_fs
+}
+
+_usage()
+{
+    echo "$0: [-l filelen] [-n numops1] [-N numops2]"
+}
+
+_process_args()
+{
+    OPTIND=1
+    while getopts "l:n:N:?" c $@
+    do
+        case $c
+        in
+            l)
+                filelen=$OPTARG
+		param_type="$param_type, overidde -l"
+                ;;
+            N)
+                numops2=$OPTARG
+		param_type="$param_type, overidde -N"
+                ;;
+            n)
+                numops1=$OPTARG
+		param_type="$param_type, overidde -n"
+                ;;
+	    ?)
+		_usage
+		exit	
+		;;
+	esac
+    done
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_aio
+_require_xfs_io_command "falloc"
+
+[ -x $here/ltp/aio-stress ] || \
+	_notrun "fsx not built with AIO for this platform"
+
+size10=`expr 10 \* 1024 \* 1024`	# 10 megabytes
+filelen=$size10
+numops1=1000
+numops2=10000
+
+# can override the params here
+_process_args "$@"
+
+echo "Params are for $param_type" >>$seqres.full
+echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seqres.full
+
+rm -f $seqres.full
+echo "brevity is wit..."
+
+_check_test_fs
+
+# Options:
+# -d: debug output for all operations
+# -l flen: the upper bound on file size (default 262144)
+# -o oplen: the upper bound on operation size
+# -N numops: total # operations to do (default infinity)
+# -P: save .fsxlog and .fsxgood files in dirpath (default ./)
+# -S seed: for random # generator (default 1) 0 gets timestamp
+# -x: pre-allocate file space, exercising unwritten extents
+# -A: use the AIO system calls
+
+_do_test 0 "-A -d -N $numops1 -S 0 -x"
+_do_test 1 "-A -d -N $numops2 -l $filelen -S 0 -x"
+
+rm -f $seq.*.fsx{good,log}
+exit 0
diff --git a/tests/generic/602.out b/tests/generic/602.out
new file mode 100644
index 00000000..bf771f04
--- /dev/null
+++ b/tests/generic/602.out
@@ -0,0 +1,10 @@
+QA output created by 602
+brevity is wit...
+
+-----------------------------------------------
+fsx.0 : -A -d -N numops -S 0 -x
+-----------------------------------------------
+
+-----------------------------------------------
+fsx.1 : -A -d -N numops -l filelen -S 0 -x
+-----------------------------------------------
diff --git a/tests/generic/group b/tests/generic/group
index 54d71d55..b01e1cb0 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -519,3 +519,5 @@
 514 auto quick clone
 515 auto quick clone
 516 auto quick dedupe clone
+601 auto rw
+602 auto aio rw
-- 
2.19.1
