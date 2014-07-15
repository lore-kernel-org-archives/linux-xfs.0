Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 284527F75
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 04:48:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16230304048
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 02:48:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 51vxyHhc6C702W6Y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 02:48:00 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 2/2] xfstests: Check fs consistency on TEST_DEV only when
	needed
Date: Tue, 15 Jul 2014 11:47:52 +0200
Message-Id: <1405417672-25683-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1405417672-25683-1-git-send-email-lczerner@redhat.com>
References: <1405417672-25683-1-git-send-email-lczerner@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

Currently we're checking file system consistency on TEST_DEV after every
successful test run even though the TEST_DEV might not even be used in
that test.

Fix it by introducing _require_test to for the test ti indicate that
it's about to use TEST_DEV.

Also add _require_test to the new script so that this requirement is a
default.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check             |  3 ++-
 common/rc         | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 new               |  1 +
 tests/btrfs/008   |  1 +
 tests/btrfs/016   |  1 +
 tests/btrfs/019   |  1 +
 tests/btrfs/020   |  1 +
 tests/btrfs/026   |  1 +
 tests/btrfs/027   |  1 +
 tests/btrfs/028   |  1 +
 tests/btrfs/029   |  1 +
 tests/btrfs/031   |  1 +
 tests/btrfs/041   |  1 +
 tests/btrfs/046   |  1 +
 tests/btrfs/047   |  1 +
 tests/btrfs/048   |  1 +
 tests/btrfs/050   |  1 +
 tests/btrfs/051   |  1 +
 tests/btrfs/053   |  1 +
 tests/btrfs/054   |  1 +
 tests/ext4/001    |  1 +
 tests/ext4/002    |  1 +
 tests/generic/001 |  1 +
 tests/generic/002 |  1 +
 tests/generic/004 |  1 +
 tests/generic/005 |  1 +
 tests/generic/006 |  1 +
 tests/generic/007 |  1 +
 tests/generic/008 |  1 +
 tests/generic/009 |  1 +
 tests/generic/010 |  1 +
 tests/generic/011 |  1 +
 tests/generic/012 |  1 +
 tests/generic/013 |  1 +
 tests/generic/014 |  1 +
 tests/generic/016 |  1 +
 tests/generic/020 |  1 +
 tests/generic/021 |  1 +
 tests/generic/022 |  1 +
 tests/generic/023 |  1 +
 tests/generic/024 |  1 +
 tests/generic/025 |  1 +
 tests/generic/026 |  1 +
 tests/generic/028 |  1 +
 tests/generic/070 |  1 +
 tests/generic/074 |  1 +
 tests/generic/075 |  1 +
 tests/generic/088 |  1 +
 tests/generic/089 |  1 +
 tests/generic/091 |  1 +
 tests/generic/093 |  1 +
 tests/generic/097 |  1 +
 tests/generic/099 |  1 +
 tests/generic/100 |  1 +
 tests/generic/112 |  1 +
 tests/generic/113 |  1 +
 tests/generic/123 |  1 +
 tests/generic/124 |  1 +
 tests/generic/125 |  1 +
 tests/generic/126 |  1 +
 tests/generic/127 |  1 +
 tests/generic/131 |  1 +
 tests/generic/133 |  1 +
 tests/generic/184 |  1 +
 tests/generic/192 |  1 +
 tests/generic/193 |  1 +
 tests/generic/198 |  1 +
 tests/generic/207 |  1 +
 tests/generic/208 |  1 +
 tests/generic/209 |  1 +
 tests/generic/210 |  1 +
 tests/generic/211 |  1 +
 tests/generic/212 |  1 +
 tests/generic/213 |  1 +
 tests/generic/214 |  1 +
 tests/generic/215 |  1 +
 tests/generic/221 |  1 +
 tests/generic/228 |  1 +
 tests/generic/236 |  1 +
 tests/generic/237 |  1 +
 tests/generic/239 |  1 +
 tests/generic/240 |  1 +
 tests/generic/241 |  1 +
 tests/generic/245 |  1 +
 tests/generic/246 |  1 +
 tests/generic/247 |  1 +
 tests/generic/248 |  1 +
 tests/generic/249 |  1 +
 tests/generic/255 |  1 +
 tests/generic/256 |  1 +
 tests/generic/257 |  1 +
 tests/generic/258 |  1 +
 tests/generic/263 |  1 +
 tests/generic/285 |  1 +
 tests/generic/286 |  1 +
 tests/generic/306 |  1 +
 tests/generic/308 |  1 +
 tests/generic/309 |  1 +
 tests/generic/310 |  1 +
 tests/generic/313 |  1 +
 tests/generic/314 |  1 +
 tests/generic/315 |  1 +
 tests/generic/316 |  1 +
 tests/shared/051  |  1 +
 tests/shared/298  |  1 +
 tests/xfs/003     |  1 +
 tests/xfs/008     |  1 +
 tests/xfs/012     |  1 +
 tests/xfs/045     |  1 +
 tests/xfs/048     |  1 +
 tests/xfs/066     |  1 +
 tests/xfs/073     |  1 +
 tests/xfs/078     |  1 +
 tests/xfs/080     |  1 +
 tests/xfs/084     |  1 +
 tests/xfs/134     |  1 +
 tests/xfs/164     |  1 +
 tests/xfs/165     |  1 +
 tests/xfs/195     |  1 +
 tests/xfs/197     |  1 +
 tests/xfs/206     |  1 +
 tests/xfs/222     |  1 +
 tests/xfs/229     |  1 +
 tests/xfs/242     |  1 +
 tests/xfs/250     |  1 +
 tests/xfs/252     |  1 +
 tests/xfs/253     |  1 +
 tests/xfs/259     |  1 +
 tests/xfs/290     |  1 +
 tests/xfs/292     |  1 +
 130 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/check b/check
index 5b76fab..77c6559 100755
--- a/check
+++ b/check
@@ -625,7 +625,8 @@ for section in $HOST_OPTIONS_SECTIONS; do
 	    then
 		try="$try $seqnum"
 		n_try=`expr $n_try + 1`
-		_check_test_fs
+		test -f ${RESULT_DIR}/require_test && _check_test_fs
+		rm -f ${RESULT_DIR}/require_test
 		test -f ${RESULT_DIR}/require_scratch && _check_scratch_fs
 		rm -f ${RESULT_DIR}/require_scratch
 	    fi
diff --git a/common/rc b/common/rc
index 57c4446..27a2ba7 100644
--- a/common/rc
+++ b/common/rc
@@ -989,6 +989,55 @@ _require_scratch()
     touch ${RESULT_DIR}/require_scratch
 }
 
+# this test needs a test partition - check we're ok & unmount it
+#
+_require_test()
+{
+    case "$FSTYP" in
+	nfs*)
+                 _notrun "requires a test device"
+		 ;;
+	tmpfs)
+		if [ -z "$TEST_DEV" -o ! -d "$TEST_DIR" ];
+		then
+		    _notrun "this test requires a valid \$TEST_DIR and unique $TEST_DEV"
+		fi
+		;;
+	*)
+		 if [ -z "$TEST_DEV" -o "`_is_block_dev $TEST_DEV`" = "" ]
+		 then
+		     _notrun "this test requires a valid \$TEST_DEV"
+		 fi
+		 if [ "`_is_block_dev $SCRATCH_DEV`" = "`_is_block_dev $TEST_DEV`" ]
+		 then
+		     _notrun "this test requires a valid \$TEST_DEV"
+		 fi
+		if [ ! -d "$TEST_DIR" ]
+		then
+		     _notrun "this test requires a valid \$TEST_DIR"
+		fi
+		 ;;
+    esac
+
+    # mounted?
+    if _mount | grep -q $TEST_DEV
+    then
+        # if it's mounted, make sure its on $TEST_DIR
+        if ! _mount | grep $TEST_DEV | grep -q $TEST_DIR
+        then
+            echo "\$TEST_DEV is mounted but not on \$TEST_DIR - aborting"
+            exit 1
+        fi
+    else
+	out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV $TEST_DIR`
+	if [ $? -ne 1 ]; then
+		echo $out
+		exit 1
+	fi
+    fi
+    touch ${RESULT_DIR}/require_test
+}
+
 # this test needs a logdev
 #
 _require_logdev()
diff --git a/new b/new
index f712892..f3e6fa1 100755
--- a/new
+++ b/new
@@ -129,6 +129,7 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 # if error
 exit
diff --git a/tests/btrfs/008 b/tests/btrfs/008
index 9fa36a6..019af04 100755
--- a/tests/btrfs/008
+++ b/tests/btrfs/008
@@ -50,6 +50,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 
 _scratch_mkfs > /dev/null 2>&1
diff --git a/tests/btrfs/016 b/tests/btrfs/016
index d04c21a..c8fc708 100755
--- a/tests/btrfs/016
+++ b/tests/btrfs/016
@@ -49,6 +49,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 _require_fssum
 
diff --git a/tests/btrfs/019 b/tests/btrfs/019
index 45bba5e..452d24b 100755
--- a/tests/btrfs/019
+++ b/tests/btrfs/019
@@ -50,6 +50,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 
 _scratch_mkfs > /dev/null 2>&1
diff --git a/tests/btrfs/020 b/tests/btrfs/020
index 7464bd0..5a928dd 100755
--- a/tests/btrfs/020
+++ b/tests/btrfs/020
@@ -55,6 +55,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 
 rm -f $seqres.full
 echo "Silence is golden"
diff --git a/tests/btrfs/026 b/tests/btrfs/026
index c2ac561..7559ca2 100644
--- a/tests/btrfs/026
+++ b/tests/btrfs/026
@@ -50,6 +50,7 @@ _supported_os Linux
 
 _require_xfs_io_command "fiemap"
 _require_cp_reflink
+_require_test
 
 TESTDIR1=$TEST_DIR/test-$seq
 rm -rf $TESTDIR1
diff --git a/tests/btrfs/027 b/tests/btrfs/027
index d615efd..d2b812b 100644
--- a/tests/btrfs/027
+++ b/tests/btrfs/027
@@ -50,6 +50,7 @@ _supported_os Linux
 
 _require_xfs_io_command "fiemap"
 _require_cp_reflink
+_require_test
 
 TESTDIR1=$TEST_DIR/test-$seq
 rm -rf $TESTDIR1
diff --git a/tests/btrfs/028 b/tests/btrfs/028
index 50cffd3..7193337 100644
--- a/tests/btrfs/028
+++ b/tests/btrfs/028
@@ -48,6 +48,7 @@ _supported_os Linux
 
 _require_xfs_io_command "fiemap"
 _require_cp_reflink
+_require_test
 
 rm -f $seqres.full
 
diff --git a/tests/btrfs/029 b/tests/btrfs/029
index 80c05e3..0b77b33 100644
--- a/tests/btrfs/029
+++ b/tests/btrfs/029
@@ -52,6 +52,7 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 
+_require_test
 _require_scratch
 _require_cp_reflink
 
diff --git a/tests/btrfs/031 b/tests/btrfs/031
index e158a57..bcd332c 100644
--- a/tests/btrfs/031
+++ b/tests/btrfs/031
@@ -53,6 +53,7 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 
+_require_test
 _require_scratch
 _require_cp_reflink
 
diff --git a/tests/btrfs/041 b/tests/btrfs/041
index b86e2f5..9639787 100755
--- a/tests/btrfs/041
+++ b/tests/btrfs/041
@@ -51,6 +51,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 _need_to_be_root
 
diff --git a/tests/btrfs/046 b/tests/btrfs/046
index c0d10e1..288fb7f 100644
--- a/tests/btrfs/046
+++ b/tests/btrfs/046
@@ -51,6 +51,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 _require_fssum
 _need_to_be_root
diff --git a/tests/btrfs/047 b/tests/btrfs/047
index 8b20e79..2c50bf6 100755
--- a/tests/btrfs/047
+++ b/tests/btrfs/047
@@ -57,6 +57,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 _require_fssum
 _require_xfs_io_command "fiemap"
diff --git a/tests/btrfs/048 b/tests/btrfs/048
index 2a9bfc3..dc7386d 100755
--- a/tests/btrfs/048
+++ b/tests/btrfs/048
@@ -45,6 +45,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 _require_btrfs "property"
 _need_to_be_root
diff --git a/tests/btrfs/050 b/tests/btrfs/050
index 9079408..b72408a 100755
--- a/tests/btrfs/050
+++ b/tests/btrfs/050
@@ -51,6 +51,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 _require_fssum
 _need_to_be_root
diff --git a/tests/btrfs/051 b/tests/btrfs/051
index deaa765..1ddfb74 100755
--- a/tests/btrfs/051
+++ b/tests/btrfs/051
@@ -48,6 +48,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 _require_fssum
 _need_to_be_root
diff --git a/tests/btrfs/053 b/tests/btrfs/053
index 7eef55f..43a831c 100755
--- a/tests/btrfs/053
+++ b/tests/btrfs/053
@@ -50,6 +50,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 _require_fssum
 _require_attrs
diff --git a/tests/btrfs/054 b/tests/btrfs/054
index 258eead..33241b0 100755
--- a/tests/btrfs/054
+++ b/tests/btrfs/054
@@ -58,6 +58,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
+_require_test
 _require_scratch
 _need_to_be_root
 
diff --git a/tests/ext4/001 b/tests/ext4/001
index 827d806..5409f48 100755
--- a/tests/ext4/001
+++ b/tests/ext4/001
@@ -46,6 +46,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs ext4
 _supported_os Linux
 _require_xfs_io_command "fzero"
+_require_test
 
 testfile=$TEST_DIR/001.$$
 
diff --git a/tests/ext4/002 b/tests/ext4/002
index 8cb3fd1..035ea7b 100755
--- a/tests/ext4/002
+++ b/tests/ext4/002
@@ -120,6 +120,7 @@ _check_ext4_eof_flag()
 _supported_fs ext4
 _supported_os Linux
 _require_xfs_io_command "falloc"
+_require_test
 
 # Real QA test starts here.
 rm -f $seqres.full
diff --git a/tests/generic/001 b/tests/generic/001
index 6e5f3dd..e977a01 100755
--- a/tests/generic/001
+++ b/tests/generic/001
@@ -48,6 +48,7 @@ trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 verbose=true
 verify=$here/verify_fill
diff --git a/tests/generic/002 b/tests/generic/002
index 656d29f..f63b208 100755
--- a/tests/generic/002
+++ b/tests/generic/002
@@ -43,6 +43,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 echo "Silence is goodness ..."
 
diff --git a/tests/generic/004 b/tests/generic/004
index 23ca349..c7aa473 100755
--- a/tests/generic/004
+++ b/tests/generic/004
@@ -44,6 +44,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_xfs_io_command "flink"
 
 testfile="${TEST_DIR}/tst-tmpfile-flink"
diff --git a/tests/generic/005 b/tests/generic/005
index 544af14..d78e43f 100755
--- a/tests/generic/005
+++ b/tests/generic/005
@@ -66,6 +66,7 @@ _touch()
 
 # real QA test starts here
 _supported_fs generic
+_require_test
 
 # IRIX UDF does not support symlinks
 if [ $FSTYP == 'udf' ]; then
diff --git a/tests/generic/006 b/tests/generic/006
index 481e1f1..7a38dbf 100755
--- a/tests/generic/006
+++ b/tests/generic/006
@@ -54,6 +54,7 @@ _count()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 mkdir $TEST_DIR/permname.$$
 
diff --git a/tests/generic/007 b/tests/generic/007
index abbee74..88cd6cc 100755
--- a/tests/generic/007
+++ b/tests/generic/007
@@ -48,6 +48,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 status=1 # default failure 
 sourcefile=$tmp.nametest
diff --git a/tests/generic/008 b/tests/generic/008
index 65e1661..9b70b28 100755
--- a/tests/generic/008
+++ b/tests/generic/008
@@ -44,6 +44,7 @@ trap "exit \$status" 0 1 2 3 15
 _supported_os Linux
 
 _require_xfs_io_command "fzero"
+_require_test
 
 testfile=$TEST_DIR/008.$$
 
diff --git a/tests/generic/009 b/tests/generic/009
index 08eafb9..7fbec34 100755
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -45,6 +45,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_os Linux
 _require_xfs_io_command "fzero"
+_require_test
 
 testfile=$TEST_DIR/009.$$
 
diff --git a/tests/generic/010 b/tests/generic/010
index 9d2e76a..ea8ea50 100755
--- a/tests/generic/010
+++ b/tests/generic/010
@@ -56,6 +56,7 @@ _filter_dbtest()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 rm -f $seqres.full
 
diff --git a/tests/generic/011 b/tests/generic/011
index bed23aa..f3c2f7c 100755
--- a/tests/generic/011
+++ b/tests/generic/011
@@ -46,6 +46,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 out=$TEST_DIR/dirstress.$$
 
diff --git a/tests/generic/012 b/tests/generic/012
index 730625b..6b1e20b 100755
--- a/tests/generic/012
+++ b/tests/generic/012
@@ -51,6 +51,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_xfs_io_command "fpunch"
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/013 b/tests/generic/013
index 8e76d3d..93d9904 100755
--- a/tests/generic/013
+++ b/tests/generic/013
@@ -91,6 +91,7 @@ _do_test()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 rm -f $seqres.full
 echo "brevity is wit..."
diff --git a/tests/generic/014 b/tests/generic/014
index a9c2638..7961961 100755
--- a/tests/generic/014
+++ b/tests/generic/014
@@ -45,6 +45,7 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
+_require_test
 _require_sparse_files
 
 # ensure EOF preallocation doesn't massively extend the runtime of this test
diff --git a/tests/generic/016 b/tests/generic/016
index 15a2551..b994775 100755
--- a/tests/generic/016
+++ b/tests/generic/016
@@ -51,6 +51,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_xfs_io_command "fpunch"
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/020 b/tests/generic/020
index a9bd17a..49230da 100755
--- a/tests/generic/020
+++ b/tests/generic/020
@@ -76,6 +76,7 @@ _attr_list()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_attrs
 
 rm -f $seqres.full
diff --git a/tests/generic/021 b/tests/generic/021
index eb88e01..4729400 100755
--- a/tests/generic/021
+++ b/tests/generic/021
@@ -51,6 +51,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_xfs_io_command "fpunch"
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/022 b/tests/generic/022
index 55bf8c5..1228e51 100755
--- a/tests/generic/022
+++ b/tests/generic/022
@@ -51,6 +51,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_xfs_io_command "fpunch"
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/023 b/tests/generic/023
index aaf196a..114485c 100755
--- a/tests/generic/023
+++ b/tests/generic/023
@@ -43,6 +43,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _requires_renameat2
 
 # real QA test starts here
diff --git a/tests/generic/024 b/tests/generic/024
index fa61169..8945191 100755
--- a/tests/generic/024
+++ b/tests/generic/024
@@ -43,6 +43,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _requires_renameat2
 
 rename_dir=$TEST_DIR/$$
diff --git a/tests/generic/025 b/tests/generic/025
index 251fffe..6b6c8ab 100755
--- a/tests/generic/025
+++ b/tests/generic/025
@@ -43,6 +43,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _requires_renameat2
 
 rename_dir=$TEST_DIR/$$
diff --git a/tests/generic/026 b/tests/generic/026
index 6dae966..ab75839 100755
--- a/tests/generic/026
+++ b/tests/generic/026
@@ -48,6 +48,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 _require_scratch
 _need_to_be_root
 _acl_setup_ids
diff --git a/tests/generic/028 b/tests/generic/028
index eb3c799..f181d3e 100755
--- a/tests/generic/028
+++ b/tests/generic/028
@@ -50,6 +50,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 echo "Silence is golden"
 
diff --git a/tests/generic/070 b/tests/generic/070
index f593d84..7591b25 100755
--- a/tests/generic/070
+++ b/tests/generic/070
@@ -47,6 +47,7 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
+_require_test
 _require_attrs
 
 FSSTRESS_ARGS=`_scale_fsstress_args \
diff --git a/tests/generic/074 b/tests/generic/074
index 668132e..df85d66 100755
--- a/tests/generic/074
+++ b/tests/generic/074
@@ -110,6 +110,7 @@ rm -f $seqres.full
 
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 #
 # set params
diff --git a/tests/generic/075 b/tests/generic/075
index af4f34b..a2411c6 100755
--- a/tests/generic/075
+++ b/tests/generic/075
@@ -123,6 +123,7 @@ _process_args()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 size10=`expr 10 \* 1024 \* 1024`	# 10 megabytes
 filelen=$size10
diff --git a/tests/generic/088 b/tests/generic/088
index fce6489..983de98 100755
--- a/tests/generic/088
+++ b/tests/generic/088
@@ -48,6 +48,7 @@ _link_out_file $seq.out $seqfull.out
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 path=$TEST_DIR/t_access
 src/t_access_root $path | tee $seqres.full | _filter
diff --git a/tests/generic/089 b/tests/generic/089
index fdddad4..4324f83 100755
--- a/tests/generic/089
+++ b/tests/generic/089
@@ -51,6 +51,7 @@ addentries()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 rm -f $seqres.full
 [ "X$TEST_DIR" = "X" ] && exit 1
diff --git a/tests/generic/091 b/tests/generic/091
index e7b60fe..3775016 100755
--- a/tests/generic/091
+++ b/tests/generic/091
@@ -38,6 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 rm -f $seqres.full
 
diff --git a/tests/generic/093 b/tests/generic/093
index fe20f38..8f810a6 100755
--- a/tests/generic/093
+++ b/tests/generic/093
@@ -58,6 +58,7 @@ _filefilter()
 _supported_fs generic
 _supported_os IRIX
 
+_require_test
 _require_attrs
 
 [ -x $runas ] || _notrun "$runas executable not found"
diff --git a/tests/generic/097 b/tests/generic/097
index f40d5d5..637c73b 100755
--- a/tests/generic/097
+++ b/tests/generic/097
@@ -75,6 +75,7 @@ fi
 _supported_fs generic
 _supported_os IRIX
 
+_require_test
 _require_scratch
 _require_attrs
 
diff --git a/tests/generic/099 b/tests/generic/099
index 83097e9..b544fe2 100755
--- a/tests/generic/099
+++ b/tests/generic/099
@@ -80,6 +80,7 @@ rm -f $seqres.full
 _supported_fs generic
 _supported_os IRIX
 
+_require_test
 _acl_setup_ids
 _require_acls
 
diff --git a/tests/generic/100 b/tests/generic/100
index 00ba23e..59b8e75 100755
--- a/tests/generic/100
+++ b/tests/generic/100
@@ -44,6 +44,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 # Use _populate_fs() in common/rc to create a directory structure.
 TEMP_DIR=/tmp
diff --git a/tests/generic/112 b/tests/generic/112
index 1e34d99..b59cbfa 100755
--- a/tests/generic/112
+++ b/tests/generic/112
@@ -121,6 +121,7 @@ _process_args()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 [ -x $here/ltp/aio-stress ] || \
 	_notrun "fsx not built with AIO for this platform"
diff --git a/tests/generic/113 b/tests/generic/113
index 56672f0..7208fa2 100755
--- a/tests/generic/113
+++ b/tests/generic/113
@@ -76,6 +76,7 @@ _do_test()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 [ -x $here/ltp/aio-stress ] || _notrun "aio-stress not built for this platform"
 
diff --git a/tests/generic/123 b/tests/generic/123
index 911e9d2..453ede4 100755
--- a/tests/generic/123
+++ b/tests/generic/123
@@ -48,6 +48,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux IRIX
 
+_require_test
 _require_user
 
 my_test_subdir=$TEST_DIR/123subdir
diff --git a/tests/generic/124 b/tests/generic/124
index 77f6e7d..888bbc0 100755
--- a/tests/generic/124
+++ b/tests/generic/124
@@ -48,6 +48,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_scratch
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/generic/125 b/tests/generic/125
index f4ffea5..bcf9b3e 100755
--- a/tests/generic/125
+++ b/tests/generic/125
@@ -39,6 +39,7 @@ trap "exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_user
 
 TESTDIR=$TEST_DIR/ftrunc
diff --git a/tests/generic/126 b/tests/generic/126
index 1796527..a22d587 100755
--- a/tests/generic/126
+++ b/tests/generic/126
@@ -43,6 +43,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 QA_FS_PERMS=$here/src/fs_perms
 
diff --git a/tests/generic/127 b/tests/generic/127
index f6b7f95..94d15b2 100755
--- a/tests/generic/127
+++ b/tests/generic/127
@@ -104,6 +104,7 @@ _fsx_std_mmap()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 _fsx_lite_nommap
 _fsx_lite_mmap
diff --git a/tests/generic/131 b/tests/generic/131
index ce3e490..b4e3ff0 100755
--- a/tests/generic/131
+++ b/tests/generic/131
@@ -44,6 +44,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 TESTFILE=$TEST_DIR/lock_file
 
diff --git a/tests/generic/133 b/tests/generic/133
index 7fb1695..f1d67aa 100755
--- a/tests/generic/133
+++ b/tests/generic/133
@@ -38,6 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux IRIX
+_require_test
 
 echo "Buffered writer, buffered reader"
 $XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
diff --git a/tests/generic/184 b/tests/generic/184
index dcc8b4e..d7c0eb9 100755
--- a/tests/generic/184
+++ b/tests/generic/184
@@ -44,6 +44,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 rm -f $TEST_DIR/null
 mknod $TEST_DIR/null c 1 3
diff --git a/tests/generic/192 b/tests/generic/192
index 2b4e41c..f630be9 100755
--- a/tests/generic/192
+++ b/tests/generic/192
@@ -53,6 +53,7 @@ is_noatime_set() {
 
 _supported_fs generic
 _supported_os Linux
+_require_test
 #delay=150
 #delay=75
 #delay=60
diff --git a/tests/generic/193 b/tests/generic/193
index 4fa20ff..cd3c0b0 100755
--- a/tests/generic/193
+++ b/tests/generic/193
@@ -70,6 +70,7 @@ _filter_files()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_user
 _need_to_be_root
 
diff --git a/tests/generic/198 b/tests/generic/198
index 5190d34..5978f54 100755
--- a/tests/generic/198
+++ b/tests/generic/198
@@ -44,6 +44,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 _require_aiodio aiodio_sparse2
+_require_test
 
 echo "Silence is golden."
 
diff --git a/tests/generic/207 b/tests/generic/207
index 0709061..8f22c55 100755
--- a/tests/generic/207
+++ b/tests/generic/207
@@ -44,6 +44,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 _run_aiodio aio-dio-extend-stat
 
diff --git a/tests/generic/208 b/tests/generic/208
index 58d1d08..f57e2bc 100755
--- a/tests/generic/208
+++ b/tests/generic/208
@@ -44,6 +44,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 rm -f $seqres.full
 
diff --git a/tests/generic/209 b/tests/generic/209
index 2abafcf..aface56 100755
--- a/tests/generic/209
+++ b/tests/generic/209
@@ -44,6 +44,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 _run_aiodio aio-dio-invalidate-readahead
 
diff --git a/tests/generic/210 b/tests/generic/210
index ebeb137..6abd3b4 100755
--- a/tests/generic/210
+++ b/tests/generic/210
@@ -44,6 +44,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 _run_aiodio aio-dio-subblock-eof-read
 
diff --git a/tests/generic/211 b/tests/generic/211
index d1110f5..e0afeff 100755
--- a/tests/generic/211
+++ b/tests/generic/211
@@ -44,6 +44,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 _run_aiodio aio-free-ring-with-bogus-nr-pages
 
diff --git a/tests/generic/212 b/tests/generic/212
index 23ceae0..e3b2dad 100755
--- a/tests/generic/212
+++ b/tests/generic/212
@@ -45,6 +45,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 _run_aiodio aio-io-setup-with-nonwritable-context-pointer
 
diff --git a/tests/generic/213 b/tests/generic/213
index c99520f..609fcf1 100755
--- a/tests/generic/213
+++ b/tests/generic/213
@@ -54,6 +54,7 @@ _supported_os Linux
 
 rm -f $seqres.full
 
+_require_test
 _require_xfs_io_command "falloc"
 
 # check there's enough freespace on $TEST_DIR ... (1GiB + 1MiB)
diff --git a/tests/generic/214 b/tests/generic/214
index 444c1fe..dff267e 100755
--- a/tests/generic/214
+++ b/tests/generic/214
@@ -47,6 +47,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 # only Linux supports fallocate
 _supported_os Linux
+_require_test
 
 [ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
 
diff --git a/tests/generic/215 b/tests/generic/215
index eaae8d8..6ddd1fc 100755
--- a/tests/generic/215
+++ b/tests/generic/215
@@ -45,6 +45,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 testfile=$TEST_DIR/tst.mmap
 
diff --git a/tests/generic/221 b/tests/generic/221
index e7d4740..aa42f65 100755
--- a/tests/generic/221
+++ b/tests/generic/221
@@ -39,6 +39,7 @@ status=1	# failure is the default!
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 echo "Silence is golden."
 
diff --git a/tests/generic/228 b/tests/generic/228
index 7ac0872..1856dec 100755
--- a/tests/generic/228
+++ b/tests/generic/228
@@ -47,6 +47,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15 25
 _supported_fs generic
 # only Linux supports fallocate
 _supported_os Linux
+_require_test
 
 [ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
 
diff --git a/tests/generic/236 b/tests/generic/236
index 10cf71a..12ea0bc 100755
--- a/tests/generic/236
+++ b/tests/generic/236
@@ -43,6 +43,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 # only Linux supports fallocate
 _supported_os Linux
+_require_test
 
 rm -f $TEST_DIR/ouch*
 
diff --git a/tests/generic/237 b/tests/generic/237
index 6a61ec8..ff11ed3 100755
--- a/tests/generic/237
+++ b/tests/generic/237
@@ -49,6 +49,7 @@ _cleanup()
 _supported_fs generic
 # only Linux supports fallocate
 _supported_os Linux
+_require_test
 
 [ -x $runas ] || _notrun "$runas executable not found"
 
diff --git a/tests/generic/239 b/tests/generic/239
index bf39953..4f764c2 100755
--- a/tests/generic/239
+++ b/tests/generic/239
@@ -44,6 +44,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_sparse_files
 _require_aiodio aio-dio-hole-filling-race
 
diff --git a/tests/generic/240 b/tests/generic/240
index 44ba0d3..e32f15a 100755
--- a/tests/generic/240
+++ b/tests/generic/240
@@ -50,6 +50,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_sparse_files
 _require_aiodio aiodio_sparse2
 
diff --git a/tests/generic/241 b/tests/generic/241
index 7c3f6e8..b45f5e9 100755
--- a/tests/generic/241
+++ b/tests/generic/241
@@ -42,6 +42,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 [ "$DBENCH_PROG" = "" ] && _notrun "dbench not found"
 
diff --git a/tests/generic/245 b/tests/generic/245
index 9b87fbb..4034d04 100755
--- a/tests/generic/245
+++ b/tests/generic/245
@@ -39,6 +39,7 @@ status=1	# failure is the default!
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 dir=$TEST_DIR/test-mv
 
diff --git a/tests/generic/246 b/tests/generic/246
index dd809fb..4184cfc 100755
--- a/tests/generic/246
+++ b/tests/generic/246
@@ -40,6 +40,7 @@ status=1	# failure is the default!
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 file=$TEST_DIR/mmap-writev
 
diff --git a/tests/generic/247 b/tests/generic/247
index 5f16281..c8648a2 100755
--- a/tests/generic/247
+++ b/tests/generic/247
@@ -46,6 +46,7 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 testfile=$TEST_DIR/$seq.$$
 
diff --git a/tests/generic/248 b/tests/generic/248
index 873313d..f47d47f 100755
--- a/tests/generic/248
+++ b/tests/generic/248
@@ -46,6 +46,7 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 TESTFILE=$TEST_DIR/test_file
 TEST_PROG=$here/src/pwrite_mmap_blocked
diff --git a/tests/generic/249 b/tests/generic/249
index 306e820..d8b4df4 100755
--- a/tests/generic/249
+++ b/tests/generic/249
@@ -44,6 +44,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 echo "Feel the serenity."
 
diff --git a/tests/generic/255 b/tests/generic/255
index 8419065..14de49e 100755
--- a/tests/generic/255
+++ b/tests/generic/255
@@ -46,6 +46,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic 
 _supported_os Linux
 
+_require_test
 _require_xfs_io_command "fpunch"
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/256 b/tests/generic/256
index 92c4f30..086c00a 100755
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -49,6 +49,7 @@ _supported_os Linux
 _require_xfs_io_command "fpunch"
 _require_scratch
 _require_user
+_require_test
 
 testfile=$TEST_DIR/256.$$
 
diff --git a/tests/generic/257 b/tests/generic/257
index a9ce73b..64f2100 100755
--- a/tests/generic/257
+++ b/tests/generic/257
@@ -42,6 +42,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 mkdir $TEST_DIR/ttt
 for n in {1..168}; do
diff --git a/tests/generic/258 b/tests/generic/258
index 3aeb5ce..b9b5cf9 100755
--- a/tests/generic/258
+++ b/tests/generic/258
@@ -45,6 +45,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 TESTFILE=$TEST_DIR/timestamp-test.txt
 
diff --git a/tests/generic/263 b/tests/generic/263
index 6ecb74d..6ee2165 100755
--- a/tests/generic/263
+++ b/tests/generic/263
@@ -38,6 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 rm -f $seqres.full
 
diff --git a/tests/generic/285 b/tests/generic/285
index ac34d34..d6275b5 100755
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -40,6 +40,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_seek_data_hole
 
 BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
diff --git a/tests/generic/286 b/tests/generic/286
index f4fe39a..94c22c6 100755
--- a/tests/generic/286
+++ b/tests/generic/286
@@ -38,6 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_seek_data_hole
 
 src=$TEST_DIR/seek_copy_testfile
diff --git a/tests/generic/306 b/tests/generic/306
index 04d28df..64d8cde 100755
--- a/tests/generic/306
+++ b/tests/generic/306
@@ -47,6 +47,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 _require_scratch
+_require_test
 
 DEVNULL=$SCRATCH_MNT/devnull
 DEVZERO=$SCRATCH_MNT/devzero
diff --git a/tests/generic/308 b/tests/generic/308
index 5646486..e639da1 100755
--- a/tests/generic/308
+++ b/tests/generic/308
@@ -44,6 +44,7 @@ testfile=$TEST_DIR/testfile.$seq
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 rm -f $seqres.full
 echo "Silence is golden"
diff --git a/tests/generic/309 b/tests/generic/309
index cbaf307..c6b89db 100755
--- a/tests/generic/309
+++ b/tests/generic/309
@@ -46,6 +46,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 echo "Silence is golden"
 
diff --git a/tests/generic/310 b/tests/generic/310
index 26d2d4a..9d46e87 100755
--- a/tests/generic/310
+++ b/tests/generic/310
@@ -57,6 +57,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 dmesg -c > /dev/null
 
diff --git a/tests/generic/313 b/tests/generic/313
index 623c777..a906926 100755
--- a/tests/generic/313
+++ b/tests/generic/313
@@ -45,6 +45,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
+_require_test
 
 testfile=$TEST_DIR/testfile.$seq
 
diff --git a/tests/generic/314 b/tests/generic/314
index f430b82..294fb23 100755
--- a/tests/generic/314
+++ b/tests/generic/314
@@ -43,6 +43,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs generic
+_require_test
 _require_acls
 _require_user
 _need_to_be_root
diff --git a/tests/generic/315 b/tests/generic/315
index 9c01b5e..62fdc01 100755
--- a/tests/generic/315
+++ b/tests/generic/315
@@ -48,6 +48,7 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs generic
 _supported_os Linux
+_require_test
 
 rm -f $seqres.full
 
diff --git a/tests/generic/316 b/tests/generic/316
index 29a4331..0ccf01f 100755
--- a/tests/generic/316
+++ b/tests/generic/316
@@ -45,6 +45,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_test
 _require_xfs_io_command "fpunch"
 _require_xfs_io_command "fiemap"
 
diff --git a/tests/shared/051 b/tests/shared/051
index 2b61f45..44dfd64 100755
--- a/tests/shared/051
+++ b/tests/shared/051
@@ -70,6 +70,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs xfs udf
 _supported_os Linux
+_require_test
 
 [ -x $runas ] || _notrun "$runas executable not found"
 
diff --git a/tests/shared/298 b/tests/shared/298
index c1a6316..c12e889 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -32,6 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _supported_fs ext4 xfs
 _supported_os Linux
+_require_test
 _require_loop
 _require_fstrim
 _require_xfs_io_command "fiemap"
diff --git a/tests/xfs/003 b/tests/xfs/003
index 228dd17..2eed40f 100755
--- a/tests/xfs/003
+++ b/tests/xfs/003
@@ -40,6 +40,7 @@ _need_to_be_root
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 
 [ -f core ] && rm -f core
 [ -f core ] && echo "Warning: can't nuke existing core file!"
diff --git a/tests/xfs/008 b/tests/xfs/008
index 56be923..9f22087 100755
--- a/tests/xfs/008
+++ b/tests/xfs/008
@@ -87,6 +87,7 @@ _do_test()
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/012 b/tests/xfs/012
index 4127222..7b9a54d 100755
--- a/tests/xfs/012
+++ b/tests/xfs/012
@@ -104,6 +104,7 @@ _do_test()
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/045 b/tests/xfs/045
index 84ca802..31516b3 100755
--- a/tests/xfs/045
+++ b/tests/xfs/045
@@ -44,6 +44,7 @@ _get_existing_uuid()
 _supported_fs xfs
 _supported_os Linux
 
+_require_test
 _require_scratch
 
 echo "*** get uuid"
diff --git a/tests/xfs/048 b/tests/xfs/048
index f9fb16f..3dd685f 100755
--- a/tests/xfs/048
+++ b/tests/xfs/048
@@ -44,6 +44,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 
 src/fault $TEST_DIR || exit
 
diff --git a/tests/xfs/066 b/tests/xfs/066
index db29249..736439b 100755
--- a/tests/xfs/066
+++ b/tests/xfs/066
@@ -45,6 +45,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 
 _my_stat_filter()
 {
diff --git a/tests/xfs/073 b/tests/xfs/073
index ca553ae..f955771 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -126,6 +126,7 @@ _verify_copy()
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
+_require_test
 
 [ "$USE_EXTERNAL" = yes ] && _notrun "Cannot xfs_copy with external devices"
 [ -n "$XFS_COPY_PROG" ] || _notrun "xfs_copy binary not yet installed"
diff --git a/tests/xfs/078 b/tests/xfs/078
index e04c6cc..f859efc 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -48,6 +48,7 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux
 
+_require_test
 # Must have loop device
 _require_loop
 
diff --git a/tests/xfs/080 b/tests/xfs/080
index 59c6104..e0f5b1b 100755
--- a/tests/xfs/080
+++ b/tests/xfs/080
@@ -46,6 +46,7 @@ _supported_fs xfs
 # Apparently should be able to work on IRIX,
 # but not at the moment.
 _supported_os Linux
+_require_test
 
 quiet=-q
 clean=-c
diff --git a/tests/xfs/084 b/tests/xfs/084
index 0d17cf3..7aa193b 100755
--- a/tests/xfs/084
+++ b/tests/xfs/084
@@ -51,6 +51,7 @@ pgsize=`$here/src/feature -s`
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 
 if [ $HOSTOS == "IRIX" ]; then 
     if uname -R | grep -iq debug; then 
diff --git a/tests/xfs/134 b/tests/xfs/134
index 6f092f2..adafa39 100755
--- a/tests/xfs/134
+++ b/tests/xfs/134
@@ -48,6 +48,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux IRIX
 
+_require_test
 _require_xfs_quota
 
 dir=$SCRATCH_MNT/project
diff --git a/tests/xfs/164 b/tests/xfs/164
index 33a038f..404c208 100755
--- a/tests/xfs/164
+++ b/tests/xfs/164
@@ -67,6 +67,7 @@ _filter_bmap()
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 
 testfile=$TEST_DIR/file.$seq
 
diff --git a/tests/xfs/165 b/tests/xfs/165
index bc882da..4080a88 100755
--- a/tests/xfs/165
+++ b/tests/xfs/165
@@ -64,6 +64,7 @@ _filter_bmap()
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 
 # io tests 
 testfile=$TEST_DIR/file.$seq
diff --git a/tests/xfs/195 b/tests/xfs/195
index d67ce9f..6abddbc 100755
--- a/tests/xfs/195
+++ b/tests/xfs/195
@@ -63,6 +63,7 @@ _do_dump()
 _supported_fs xfs
 _supported_os Linux
 
+_require_test
 _require_user
 
 echo "Preparing subtree"
diff --git a/tests/xfs/197 b/tests/xfs/197
index bc2de9d..7706e03 100755
--- a/tests/xfs/197
+++ b/tests/xfs/197
@@ -48,6 +48,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
+_require_test
 
 bitsperlong=`src/feature -w`
 if [ "$bitsperlong" -ne 32 ]; then
diff --git a/tests/xfs/206 b/tests/xfs/206
index f739597..f6dcca6 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -53,6 +53,7 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 _require_loop
 
 bitsperlong=`src/feature -w`
diff --git a/tests/xfs/222 b/tests/xfs/222
index 0e5aaf6..77ecfc6 100755
--- a/tests/xfs/222
+++ b/tests/xfs/222
@@ -47,6 +47,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
+_require_test
 
 [ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
 
diff --git a/tests/xfs/229 b/tests/xfs/229
index 3e02421..c057677 100755
--- a/tests/xfs/229
+++ b/tests/xfs/229
@@ -49,6 +49,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
+_require_test
 
 TDIR="${TEST_DIR}/t_holes"
 NFILES="10"
diff --git a/tests/xfs/242 b/tests/xfs/242
index 24a572a..304e69f 100755
--- a/tests/xfs/242
+++ b/tests/xfs/242
@@ -45,6 +45,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
+_require_test
 
 _test_io_zero()
 {
diff --git a/tests/xfs/250 b/tests/xfs/250
index 3b67c3f..c1622a4 100755
--- a/tests/xfs/250
+++ b/tests/xfs/250
@@ -45,6 +45,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
+_require_test
 _require_loop
 
 LOOP_DEV=$TEST_DIR/$seq.fs
diff --git a/tests/xfs/252 b/tests/xfs/252
index b2c4c08..ddafda6 100755
--- a/tests/xfs/252
+++ b/tests/xfs/252
@@ -46,6 +46,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs xfs 
 _supported_os Linux
 
+_require_test
 _require_xfs_io_command "fpunch"
 _require_xfs_io_command "fiemap"
 
diff --git a/tests/xfs/253 b/tests/xfs/253
index 4119794..91eb041 100755
--- a/tests/xfs/253
+++ b/tests/xfs/253
@@ -53,6 +53,7 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 
+_require_test
 _require_scratch
 
 # real QA test starts here
diff --git a/tests/xfs/259 b/tests/xfs/259
index 8241d94..6587a65 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -41,6 +41,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
+_require_test
 _require_loop
 _require_math
 
diff --git a/tests/xfs/290 b/tests/xfs/290
index 55322ec..adc398f 100755
--- a/tests/xfs/290
+++ b/tests/xfs/290
@@ -46,6 +46,7 @@ trap "exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux
 
+_require_test
 _require_xfs_io_command "zero"
 
 testfile=$TEST_DIR/290.$$
diff --git a/tests/xfs/292 b/tests/xfs/292
index 2910118..44aaef7 100755
--- a/tests/xfs/292
+++ b/tests/xfs/292
@@ -46,6 +46,7 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_test
 
 fsfile=$TEST_DIR/fsfile.$seq
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
