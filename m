Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 897047F85
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 14:12:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A2E38F8033
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:22 -0800 (PST)
Received: from mail-ob0-f201.google.com (mail-ob0-f201.google.com
	[209.85.214.201]) by cuda.sgi.com with ESMTP id
	PRVBSlA4sksarhEH (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 12:12:21 -0800 (PST)
Received: by mail-ob0-f201.google.com with SMTP id wp4so20212obc.2
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:21 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH 08/10] xfstests: check O_DIRECT support before testing direct
	I/O
Date: Tue, 10 Dec 2013 12:11:59 -0800
Message-Id: <1386706321-15795-9-git-send-email-jayr@google.com>
In-Reply-To: <1386706321-15795-1-git-send-email-jayr@google.com>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
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
index 4d46008..02c47ea 100644
--- a/common/rc
+++ b/common/rc
@@ -1185,6 +1185,7 @@ _require_aiodio()
         AIO_TEST=src/aio-dio-regress/$1
         [ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
     fi
+    _require_xfs_io_direct
 }
 
 # run an aio-dio program
@@ -1323,6 +1324,20 @@ _require_xfs_io_fiemap()
 		_notrun "xfs_io fiemap command failed (no fs support?)"
 }
 
+# check that xfs_io, kernel and filesystem support direct I/O
+_require_xfs_io_direct()
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
index bb176f1..926042d 100755
--- a/tests/generic/091
+++ b/tests/generic/091
@@ -38,6 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_xfs_io_direct
 
 rm -f $seqres.full
 
diff --git a/tests/generic/130 b/tests/generic/130
index 8367dc7..f9c885f 100755
--- a/tests/generic/130
+++ b/tests/generic/130
@@ -50,6 +50,7 @@ _supported_os Linux IRIX
 
 _require_scratch
 _require_sparse_files
+_require_xfs_io_direct
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/generic/133 b/tests/generic/133
index 7fb1695..d858756 100755
--- a/tests/generic/133
+++ b/tests/generic/133
@@ -38,6 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux IRIX
+_require_xfs_io_direct
 
 echo "Buffered writer, buffered reader"
 $XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
diff --git a/tests/generic/135 b/tests/generic/135
index 4a8b690..04ceebf 100755
--- a/tests/generic/135
+++ b/tests/generic/135
@@ -39,6 +39,7 @@ trap "exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux IRIX
 
+_require_xfs_io_direct
 _require_scratch
 _scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount > /dev/null 2>&1 || _fail "mount failed"
diff --git a/tests/generic/226 b/tests/generic/226
index 3514965..0fbaea7 100755
--- a/tests/generic/226
+++ b/tests/generic/226
@@ -37,6 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux IRIX
 _require_scratch
+_require_xfs_io_direct
 
 # real QA test starts here
 rm -f $seqres.full
diff --git a/tests/generic/263 b/tests/generic/263
index bc59865..7bfe3ed 100755
--- a/tests/generic/263
+++ b/tests/generic/263
@@ -38,6 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_xfs_io_direct
 
 rm -f $seqres.full
 
diff --git a/tests/generic/299 b/tests/generic/299
index 14cce96..f2a83ee 100755
--- a/tests/generic/299
+++ b/tests/generic/299
@@ -43,6 +43,7 @@ _supported_fs generic
 _supported_os Linux
 _need_to_be_root
 _require_scratch
+_require_xfs_io_direct
 
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
diff --git a/tests/generic/300 b/tests/generic/300
index 7c60728..006c214 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -43,6 +43,7 @@ _supported_fs generic
 _supported_os Linux
 _need_to_be_root
 _require_scratch
+_require_xfs_io_direct
 
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
