Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAN2e6WS189946 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 20:40:06 -0600
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAADF1D2B224
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:40:03 -0800 (PST)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id UnQXoxYASFzmo0ww for
	<xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:40:03 -0800 (PST)
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 8047F3EE0B6
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:40:01 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 6963245DE4E
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:40:01 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 2004045DE54
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:40:01 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 0B2D21DB802F
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:40:01 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.240.81.145])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id C21E8E08002
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:40:00 +0900 (JST)
Message-ID: <4ECC5CCC.1090004@jp.fujitsu.com>
Date: Wed, 23 Nov 2011 11:39:08 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add aiodio helper functions
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

For 198, 239 and 240, use _require_aiodio to fail gracefully if
required program was not built.

For 207-212, use _run_aiodio that includes _require_aiodio and
kicks specified aio-dio program, to make code expressly simple.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 198       |    3 ++-
 207       |    7 +------
 208       |    7 +------
 209       |    7 +------
 210       |    7 +------
 211       |    7 +------
 212       |    7 +------
 239       |    4 +---
 240       |    3 ++-
 common.rc |   36 ++++++++++++++++++++++++++++++++++++
 10 files changed, 47 insertions(+), 41 deletions(-)

diff --git a/198 b/198
index e46ec8d..2c72677 100755
--- a/198
+++ b/198
@@ -44,6 +44,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_aiodio aiodio_sparse2
 
 echo "Silence is golden."
 
@@ -51,7 +52,7 @@ echo "Silence is golden."
 rm -f $seq.full
 
 rm -f "$TEST_DIR/aiodio_sparse*"
-$here/src/aio-dio-regress/aiodio_sparse2 "$TEST_DIR/aiodio_sparse"
+$AIO_TEST "$TEST_DIR/aiodio_sparse"
 
 status=$?
 exit
diff --git a/207 b/207
index 32e6299..6fff833 100755
--- a/207
+++ b/207
@@ -46,11 +46,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-rm -f $TEST_DIR/aio-testfile
-AIO_TEST=src/aio-dio-regress/aio-dio-extend-stat
-[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
-$AIO_TEST $TEST_DIR/aio-testfile 2>&1
-status=$?
-rm -f $TEST_DIR/aio-testfile
+_run_aiodio aio-dio-extend-stat
 
 exit $status
diff --git a/208 b/208
index e1fdaa1..ca01558 100755
--- a/208
+++ b/208
@@ -46,11 +46,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-rm -f $TEST_DIR/aio-testfile
-AIO_TEST=src/aio-dio-regress/aio-dio-invalidate-failure
-[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
-$AIO_TEST $TEST_DIR/aio-testfile 2>&1
-status=$?
-rm -f $TEST_DIR/aio-testfile
+_run_aiodio aio-dio-invalidate-failure
 
 exit $status
diff --git a/209 b/209
index 06f10ae..650e300 100755
--- a/209
+++ b/209
@@ -46,11 +46,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-rm -f $TEST_DIR/aio-testfile
-AIO_TEST=src/aio-dio-regress/aio-dio-invalidate-readahead
-[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
-$AIO_TEST $TEST_DIR/aio-testfile 2>&1
-status=$?
-rm -f $TEST_DIR/aio-testfile
+_run_aiodio aio-dio-invalidate-readahead
 
 exit $status
diff --git a/210 b/210
index e093079..a0873f8 100755
--- a/210
+++ b/210
@@ -46,11 +46,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-rm -f $TEST_DIR/aio-testfile
-AIO_TEST=src/aio-dio-regress/aio-dio-subblock-eof-read
-[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
-$AIO_TEST $TEST_DIR/aio-testfile 2>&1
-status=$?
-rm -f $TEST_DIR/aio-testfile
+_run_aiodio aio-dio-subblock-eof-read
 
 exit $status
diff --git a/211 b/211
index 9428320..bb8d2aa 100755
--- a/211
+++ b/211
@@ -46,11 +46,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-rm -f $TEST_DIR/aio-testfile
-AIO_TEST=src/aio-dio-regress/aio-free-ring-with-bogus-nr-pages
-[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
-$AIO_TEST $TEST_DIR/aio-testfile 2>&1
-status=$?
-rm -f $TEST_DIR/aio-testfile
+_run_aiodio aio-free-ring-with-bogus-nr-pages
 
 exit $status
diff --git a/212 b/212
index 627a431..1b4bb8a 100755
--- a/212
+++ b/212
@@ -47,11 +47,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-rm -f $TEST_DIR/aio-testfile
-AIO_TEST=src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer
-[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
-$AIO_TEST $TEST_DIR/aio-testfile 2>&1
-status=$?
-rm -f $TEST_DIR/aio-testfile
+_run_aiodio aio-io-setup-with-nonwritable-context-pointer
 
 exit $status
diff --git a/239 b/239
index 88ff776..6457c46 100755
--- a/239
+++ b/239
@@ -46,9 +46,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_sparse_files
-
-AIO_TEST=src/aio-dio-regress/aio-dio-hole-filling-race
-[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
+_require_aiodio aio-dio-hole-filling-race
 
 echo "Silence is golden"
 
diff --git a/240 b/240
index 563449e..dafcef3 100755
--- a/240
+++ b/240
@@ -52,6 +52,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_sparse_files
+_require_aiodio aiodio_sparse2
 
 echo "Silence is golden."
 
@@ -69,7 +70,7 @@ fi
 
 # 2 threads, fs block sized writes, 64k filesize, stride through file by
 # fs block size, start at logical block size offset
-$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w $fs_block_size -s 64k -n $fs_block_size -o $logical_block_size "$TEST_DIR/aiodio_sparse"
+$AIO_TEST -i 2 -w $fs_block_size -s 64k -n $fs_block_size -o $logical_block_size "$TEST_DIR/aiodio_sparse"
 
 status=$?
 exit
diff --git a/common.rc b/common.rc
index cab0b64..bb3645f 100644
--- a/common.rc
+++ b/common.rc
@@ -864,6 +864,42 @@ _require_nonexternal()
 	_notrun "External device testing in progress, skipped this test"
 }
 
+# this test requires that a (specified) aio-dio executable exists
+# $1 - command (optional)
+#
+_require_aiodio()
+{
+    if [ -z "$1" ]
+    then
+        AIO_TEST=src/aio-dio-regress/aiodio_sparse2
+        [ -x $AIO_TEST ] || _notrun "aio-dio utilities required"
+    else
+        AIO_TEST=src/aio-dio-regress/$1
+        [ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
+    fi
+}
+
+# run an aio-dio program
+# $1 - command
+_run_aiodio()
+{
+    if [ -z "$1" ]
+    then
+        echo "usage: _run_aiodio command_name" 2>&1
+        status=1; exit 1
+    fi
+
+    _require_aiodio $1
+
+    local testtemp=$TEST_DIR/aio-testfile
+    rm -f $testtemp
+    $AIO_TEST $testtemp 2>&1
+    status=$?
+    rm -f $testtemp
+
+    return $status
+}
+
 # indicate whether YP/NIS is active or not
 #
 _yp_active()
-- 
1.7.7.3


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
