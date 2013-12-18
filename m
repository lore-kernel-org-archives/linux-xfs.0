Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C86429DF9
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:16:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0432CAC004
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:10 -0800 (PST)
Received: from mail-qc0-f202.google.com (mail-qc0-f202.google.com
	[209.85.216.202]) by cuda.sgi.com with ESMTP id
	0wbnDqYjgriu9q0N (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 10:16:09 -0800 (PST)
Received: by mail-qc0-f202.google.com with SMTP id i17so1040qcy.1
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:09 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v3 07/12] xfstests: check O_DIRECT support before testing
	direct I/O
Date: Wed, 18 Dec 2013 10:15:58 -0800
Message-Id: <1387390563-27064-7-git-send-email-jayr@google.com>
In-Reply-To: <1387390563-27064-1-git-send-email-jayr@google.com>
References: <1387390563-27064-1-git-send-email-jayr@google.com>
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
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

Some filesystems do not support O_DIRECT.  Check whether TEST_DIR supports it
by running xfs_io with and without -d flag.

Signed-off-by: Junho Ryu <jayr@google.com>
---

v3: same as v2

v2: renamed _require_xfs_io_direct to _require_odirect

 common/rc         | 15 +++++++++++++++
 tests/generic/091 |  1 +
 tests/generic/130 |  1 +
 tests/generic/133 |  1 +
 tests/generic/135 |  1 +
 tests/generic/226 |  1 +
 tests/generic/263 |  1 +
 tests/generic/299 |  1 +
 tests/generic/300 |  1 +
 9 files changed, 23 insertions(+)

diff --git a/common/rc b/common/rc
index 81baa1d..3878069 100644
--- a/common/rc
+++ b/common/rc
@@ -1155,6 +1155,7 @@ _require_aiodio()
         AIO_TEST=src/aio-dio-regress/$1
         [ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
     fi
+    _require_odirect
 }
 
 # run an aio-dio program
@@ -1293,6 +1294,20 @@ _require_fiemap()
 		_notrun "xfs_io fiemap command failed (no fs support?)"
 }
 
+# check that kernel and filesystem support direct I/O
+_require_odirect()
+{
+	testfile=$TEST_DIR/$$.direct
+	$XFS_IO_PROG -F -f -c "pwrite 0 20k" $testfile 2>&1
+	if [ $? -eq 0 ]; then
+		$XFS_IO_PROG -F -f -d -c "pwrite 0 20k" $testfile 2>&1
+		if [ $? -ne 0 ]; then
+			_notrun "O_DIRECT is not supported"
+		fi
+	fi
+	rm -f $testfile 2>&1 > /dev/null
+}
+
 # Check that a fs has enough free space (in 1024b blocks)
 #
 _require_fs_space()
diff --git a/tests/generic/091 b/tests/generic/091
index bb176f1..bb5c92c 100755
--- a/tests/generic/091
+++ b/tests/generic/091
@@ -38,6 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/130 b/tests/generic/130
index 8367dc7..1e96630 100755
--- a/tests/generic/130
+++ b/tests/generic/130
@@ -50,6 +50,7 @@ _supported_os Linux IRIX
 
 _require_scratch
 _require_sparse_files
+_require_odirect
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/generic/133 b/tests/generic/133
index 7fb1695..8af4dde 100755
--- a/tests/generic/133
+++ b/tests/generic/133
@@ -38,6 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux IRIX
+_require_odirect
 
 echo "Buffered writer, buffered reader"
 $XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
diff --git a/tests/generic/135 b/tests/generic/135
index e3b827a..79558f5 100755
--- a/tests/generic/135
+++ b/tests/generic/135
@@ -39,6 +39,7 @@ trap "exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux IRIX
 
+_require_odirect
 _require_scratch
 _scratch_mkfs >/dev/null 2>&1
 
diff --git a/tests/generic/226 b/tests/generic/226
index b98e889..4ad56a5 100755
--- a/tests/generic/226
+++ b/tests/generic/226
@@ -37,6 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux IRIX
 _require_scratch
+_require_odirect
 
 # real QA test starts here
 rm -f $seqres.full
diff --git a/tests/generic/263 b/tests/generic/263
index bc59865..f639215 100755
--- a/tests/generic/263
+++ b/tests/generic/263
@@ -38,6 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_odirect
 
 rm -f $seqres.full
 
diff --git a/tests/generic/299 b/tests/generic/299
index 14cce96..c674542 100755
--- a/tests/generic/299
+++ b/tests/generic/299
@@ -43,6 +43,7 @@ _supported_fs generic
 _supported_os Linux
 _need_to_be_root
 _require_scratch
+_require_odirect
 
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
diff --git a/tests/generic/300 b/tests/generic/300
index 7c60728..9231cb7 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -43,6 +43,7 @@ _supported_fs generic
 _supported_os Linux
 _need_to_be_root
 _require_scratch
+_require_odirect
 
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
