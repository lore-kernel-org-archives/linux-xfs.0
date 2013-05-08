Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E7B929E0E
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 21:35:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00D9D8F8065
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 19:35:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8m5yN47tE79XOwF0 for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 19:35:07 -0700 (PDT)
Message-ID: <5189B9DA.7010807@sandeen.net>
Date: Tue, 07 May 2013 21:35:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: automatically add -F to xfs_io on non-xfs
References: <51850BED.6050109@redhat.com>
In-Reply-To: <51850BED.6050109@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jan Kara <jack@suse.cz>, xfs-oss <xfs@oss.sgi.com>

The -F flag to xfs_io originally enabled it to operate on non-xfs
filesystems.  This restriction was removed upstream in favor of
gracefully failing on the handful of operations that actually
required xfs, and the option was deprecated.

However, xfstests is still used on distros with older xfsprogs, and
so "xfs_io -F" was necessary throughout xfstests.

Simplify this by appending -F to XFS_IO_PROG when it's needed -
i.e. if we're using old xfsprogs on a non-xfs filesystem.

This will eliminate errors when new tests leave out the -F, and
if and when -F is finally removed, there will be one central
location in xfstests to update.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: test for necessity of -F in all cases, and convert
a bunch more direct callers of xfs_io to $XFS_IO_PROG

diff --git a/common/punch b/common/punch
index b9f9acd..d8f73d0 100644
--- a/common/punch
+++ b/common/punch
@@ -311,13 +311,12 @@ _test_generic_punch()
 	map_cmd=$4
 	filter_cmd=$5
 	testfile=$6
-	xfs_io_opt=$7	#needs to be -F if not testing xfs
 
 	echo "	1. into a hole"
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
@@ -327,7 +326,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "pwrite 0 20k" $sync_cmd \
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
@@ -338,7 +337,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "$alloc_cmd 0 20k" \
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
@@ -349,7 +348,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "pwrite 8k 8k" $sync_cmd \
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
@@ -360,7 +359,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "$alloc_cmd 8k 8k" \
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
@@ -371,7 +370,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "pwrite 0 8k" $sync_cmd \
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
@@ -382,7 +381,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "pwrite 0 8k" $sync_cmd \
 		-c "$alloc_cmd 8k 8k" \
 		-c "$zero_cmd 4k 8k" \
@@ -394,7 +393,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "$alloc_cmd 0 8k" \
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
@@ -405,7 +404,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "$alloc_cmd 0 8k" \
 		-c "pwrite 8k 8k" $sync_cmd \
 		-c "$zero_cmd 4k 8k" \
@@ -417,7 +416,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "pwrite 8k 4k" $sync_cmd \
 		-c "$zero_cmd 4k 12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
@@ -428,7 +427,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "$alloc_cmd 0 20k" \
 		-c "pwrite 0 8k" \
 		-c "pwrite 12k 8k" $sync_cmd \
@@ -442,7 +441,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "$alloc_cmd 0 20k" \
 		-c "pwrite 8k 4k" $sync_cmd \
 		-c "$zero_cmd 4k 12k" \
@@ -454,7 +453,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "$alloc_cmd 0 20k" \
 		-c "pwrite 0k 8k" $sync_cmd \
 		-c "pwrite 12k 8k" -c "fsync" \
@@ -465,7 +464,7 @@ _test_generic_punch()
 
 	echo "	14. data -> hole @ EOF"
 	rm -f $testfile
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "pwrite 0 20k" $sync_cmd \
 		-c "$zero_cmd 12k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
@@ -476,7 +475,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "pwrite 0 20k" $sync_cmd \
 		-c "$zero_cmd 0k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
@@ -490,10 +489,10 @@ _test_generic_punch()
 	else
 		cp $testfile $testfile.2
 	fi
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "pwrite 8k 12k" -c "fsync" $testfile.2 \
 		> /dev/null
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
+	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "pwrite 0 20k" $sync_cmd \
 		-c "$zero_cmd 0k 8k" \
 		-c "fadvise -d" \
@@ -508,7 +507,7 @@ _test_generic_punch()
 		rm -f $testfile
 	fi
 	block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
-	$XFS_IO_PROG $xfs_io_opt -f -c "truncate $block_size" \
+	$XFS_IO_PROG -f -c "truncate $block_size" \
 		-c "pwrite 0 $block_size" $sync_cmd \
 		-c "$zero_cmd 128 128" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
diff --git a/common/rc b/common/rc
index f97924a..3f38a69 100644
--- a/common/rc
+++ b/common/rc
@@ -2150,6 +2150,11 @@ then
         $DF_PROG $TEST_DEV
         exit 1
     fi
+
+    # Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
+    xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
+	export XFS_IO_PROG="$XFS_IO_PROG -F"
+
 fi
 
 # make sure this script returns success
diff --git a/tests/ext4/271 b/tests/ext4/271
index dfb1ec9..274e904 100755
--- a/tests/ext4/271
+++ b/tests/ext4/271
@@ -54,7 +54,7 @@ do
     dd if=/dev/zero of=$SCRATCH_MNT/file bs=4k count=1 seek=$((i*10))
 done
 # truncate last extent
-$XFS_IO_PROG -F -f -c "truncate $((4096*200))" $SCRATCH_MNT/file
+$XFS_IO_PROG -f -c "truncate $((4096*200))" $SCRATCH_MNT/file
 
 if ! _scratch_unmount; then
 	echo "failed to umount"
diff --git a/tests/generic/130 b/tests/generic/130
index 6870606..cfc2c32 100755
--- a/tests/generic/130
+++ b/tests/generic/130
@@ -63,7 +63,7 @@ _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
 echo "End-of-file zeroing with direct I/O"
-xfs_io -F -f -d -t -c "pwrite -S 0x63 0 65536" \
+$XFS_IO_PROG -f -d -t -c "pwrite -S 0x63 0 65536" \
     -c "truncate 1" \
     -c "pwrite -S 0x41 65536 65536" \
     -c "pread -v 0 131072" \
@@ -71,46 +71,46 @@ xfs_io -F -f -d -t -c "pwrite -S 0x63 0 65536" \
 
 echo
 echo "Basic Block Hole test"
-xfs_io -F -f -t -c "truncate 8192" \
+$XFS_IO_PROG -f -t -c "truncate 8192" \
     -c "pread -v 5000 3000" \
     $SCRATCH_MNT/blackhole | _filter_xfs_io_unique
 
 echo
 echo "Test buffered and direct IO coherency"
-xfs_io -F -f -t -c "pwrite -S 0x41 8000 1000" \
+$XFS_IO_PROG -f -t -c "pwrite -S 0x41 8000 1000" \
     -c "pwrite -S 0x57 4000 1000" \
     $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io_unique
 
-xfs_io -F -d -c "pwrite -S 0x78 20480 4096"\
+$XFS_IO_PROG -d -c "pwrite -S 0x78 20480 4096"\
     -c "pwrite -S 0x79 4096 4096"\
     $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io_unique
 
-xfs_io -F -c "pread -v 0 9000"\
+$XFS_IO_PROG -c "pread -v 0 9000"\
     $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io_unique
 
 echo
 echo "Test direct read and write"
-xfs_io -F -f -d -t -c "pwrite -S 0x78 0 65536"\
+$XFS_IO_PROG -f -d -t -c "pwrite -S 0x78 0 65536"\
     -c "pread -v 0 65536"\
     -c "pwrite -S 0x46 65536 6553600"\
     -c "pread -v 0 6619136"\
     $SCRATCH_MNT/direct_io | _filter_xfs_io_unique
 
-xfs_io -F -d -c "pread -v 0 6619136"\
+$XFS_IO_PROG -d -c "pread -v 0 6619136"\
     $SCRATCH_MNT/direct_io | _filter_xfs_io_unique
 
-xfs_io -F -f -d -t -c "pwrite -S 0x61 0 65536"\
+$XFS_IO_PROG -f -d -t -c "pwrite -S 0x61 0 65536"\
     -c "pread -v 0 65536"\
     -c "pwrite -S 0x62 65536 131072"\
     -c "pread -v 0 131072"\
     $SCRATCH_MNT/async_direct_io | _filter_xfs_io_unique
 
-xfs_io -F -d -c "pread -v 0 131072"\
+$XFS_IO_PROG -d -c "pread -v 0 131072"\
     $SCRATCH_MNT/async_direct_io | _filter_xfs_io_unique
 
 echo
 echo "FSB Edge test"
-xfs_io -F -f -t -c "truncate 131072"\
+$XFS_IO_PROG -f -t -c "truncate 131072"\
     -c "pwrite -S 0x5F 0 131072"\
     -c "truncate 0"\
     -c "truncate 131072"\
@@ -122,10 +122,10 @@ echo
 echo "Open Trunk test (O_TRUNC)"
 for n in 0 1 2 3 4
 do
-    xfs_io -F -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io_unique
+    $XFS_IO_PROG -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io_unique
 
     echo "Test" > $SCRATCH_MNT/$n
-    xfs_io -F -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io_unique
+    $XFS_IO_PROG -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io_unique
     cat $SCRATCH_MNT/$n
 done
 echo "DONE"
@@ -133,14 +133,14 @@ echo "DONE"
 echo
 echo "Append test"
 echo "append to me" > $SCRATCH_MNT/append
-xfs_io -F -a -c "pwrite -S 0x61 0 10" \
+$XFS_IO_PROG -a -c "pwrite -S 0x61 0 10" \
     -c "pread -v 0 24"\
     $SCRATCH_MNT/append | _filter_xfs_io_unique
 
 echo
 echo "Small Vector Async"
 echo "abcdefghijklmnopqrstuvwxyz" > $SCRATCH_MNT/small_vector_async
-xfs_io -F -f -c "pread -v 0 1"\
+$XFS_IO_PROG -f -c "pread -v 0 1"\
     -c "pread -v 1 1"\
     -c "pread -v 2 1"\
     -c "pread -v 3 1"\
@@ -199,7 +199,7 @@ xfs_io -F -f -c "pread -v 0 1"\
 echo
 echo "Small Vector Sync"
 echo "abcdefghijklmnopqrstuvwxyz" > $SCRATCH_MNT/small_vector_async
-xfs_io -F -f -s -c "pread -v 0 1"\
+$XFS_IO_PROG -f -s -c "pread -v 0 1"\
     -c "pread -v 1 1"\
     -c "pread -v 2 1"\
     -c "pread -v 3 1"\
diff --git a/tests/generic/132 b/tests/generic/132
index 28c8b9a..42ab909 100755
--- a/tests/generic/132
+++ b/tests/generic/132
@@ -52,7 +52,7 @@ _require_scratch
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-xfs_io -F -f -t -c "pwrite -S 0x63 0 512" \
+$XFS_IO_PROG -f -t -c "pwrite -S 0x63 0 512" \
     -c "pwrite -S 0x64 512 512" \
     -c "pwrite -S 0x65 1024 512" \
     -c "pwrite -S 0x66 1536 512" \
@@ -70,7 +70,7 @@ xfs_io -F -f -t -c "pwrite -S 0x63 0 512" \
     -c "pread -v 3584 512" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x63 4096 1024" \
+$XFS_IO_PROG -f -c "pwrite -S 0x63 4096 1024" \
     -c "pwrite -S 0x6B 5120 1024" \
     -c "pwrite -S 0x6C 6144 1024" \
     -c "pwrite -S 0x6D 7168 1024" \
@@ -84,7 +84,7 @@ xfs_io -F -f -c "pwrite -S 0x63 4096 1024" \
     -c "pread -v 7168 1024" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x6E 8192 2048" \
+$XFS_IO_PROG -f -c "pwrite -S 0x6E 8192 2048" \
     -c "pwrite -S 0x6F 10240 2048" \
     -c "pread -v 0 2048" \
     -c "pread -v 2048 2048" \
@@ -94,14 +94,14 @@ xfs_io -F -f -c "pwrite -S 0x6E 8192 2048" \
     -c "pread -v 10240 2048" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x70 12288 4096" \
+$XFS_IO_PROG -f -c "pwrite -S 0x70 12288 4096" \
     -c "pread -v 0 4096" \
     -c "pread -v 4096 4096" \
     -c "pread -v 8192 4096" \
     -c "pread -v 12288 4096" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x71 16384 8192" \
+$XFS_IO_PROG -f -c "pwrite -S 0x71 16384 8192" \
     -c "pwrite -S 0x72 24576 8192" \
     -c "pread -v 0 8192" \
     -c "pread -v 8192 8192" \
@@ -109,7 +109,7 @@ xfs_io -F -f -c "pwrite -S 0x71 16384 8192" \
     -c "pread -v 16384 8192" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x73 32768 16384" \
+$XFS_IO_PROG -f -c "pwrite -S 0x73 32768 16384" \
     -c "pwrite -S 0x74 49152 16384" \
     -c "pread -v 0 16384" \
     -c "pread -v 16384 16384" \
@@ -117,7 +117,7 @@ xfs_io -F -f -c "pwrite -S 0x73 32768 16384" \
     -c "pread -v 49152 16384" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x75 65536 32768" \
+$XFS_IO_PROG -f -c "pwrite -S 0x75 65536 32768" \
     -c "pwrite -S 0x76 98304 32768" \
     -c "pread -v 0 32768" \
     -c "pread -v 32768 32768" \
@@ -125,7 +125,7 @@ xfs_io -F -f -c "pwrite -S 0x75 65536 32768" \
     -c "pread -v 98304 32768" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x76 131072 65536" \
+$XFS_IO_PROG -f -c "pwrite -S 0x76 131072 65536" \
     -c "pwrite -S 0x77 196608 65536" \
     -c "pread -v 0 65536" \
     -c "pread -v 65536 65536" \
@@ -133,7 +133,7 @@ xfs_io -F -f -c "pwrite -S 0x76 131072 65536" \
     -c "pread -v 196608 65536" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x76 262144 131072" \
+$XFS_IO_PROG -f -c "pwrite -S 0x76 262144 131072" \
     -c "pwrite -S 0x77 393216 131072" \
     -c "pread -v 0 131072" \
     -c "pread -v 131072 131072" \
@@ -141,14 +141,14 @@ xfs_io -F -f -c "pwrite -S 0x76 262144 131072" \
     -c "pread -v 393216 131072" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x76 524288 524288" \
+$XFS_IO_PROG -f -c "pwrite -S 0x76 524288 524288" \
     -c "pwrite -S 0x77 1048576 524288" \
     -c "pread -v 0 524288" \
     -c "pread -v 524288 524288" \
     -c "pread -v 1048576 524288" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
+$XFS_IO_PROG -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pwrite -S 0x33 2097152 1048576" \
     -c "pwrite -S 0x34 3145728 1048576" \
     -c "pwrite -S 0x35 4194304 1048576" \
@@ -167,7 +167,7 @@ xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pread -v 8388608 1048576" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
+$XFS_IO_PROG -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pwrite -S 0x33 2097152 1048576" \
     -c "pwrite -S 0x34 3145728 1048576" \
     -c "pwrite -S 0x35 4194304 1048576" \
@@ -188,7 +188,7 @@ xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pread -v 9437184 1048576" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
-xfs_io -F -f -c "pwrite -S 0x92 10485760 10485760" \
+$XFS_IO_PROG -f -c "pwrite -S 0x92 10485760 10485760" \
     -c "pwrite -S 0x93 20971520 10485760" \
     -c "pwrite -S 0x94 31457280 10485760" \
     -c "pwrite -S 0x95 41943040 10485760" \
diff --git a/tests/generic/133 b/tests/generic/133
index ba386dc..65ab822 100755
--- a/tests/generic/133
+++ b/tests/generic/133
@@ -47,30 +47,30 @@ _supported_os Linux IRIX
 _setup_testdir
 
 echo "Buffered writer, buffered reader"
-xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-xfs_io -F -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-xfs_io -F -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
+$XFS_IO_PROG -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
 wait
 rm $testdir/io_test
 
 echo "Direct writer, buffered reader"
-xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-xfs_io -F -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
+$XFS_IO_PROG -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
 wait
 rm $testdir/io_test
 
 echo "Buffered writer, direct reader"
-xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-xfs_io -F -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-xfs_io -F -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
+$XFS_IO_PROG -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
 wait
 rm $testdir/io_test
 
 echo "Direct writer, direct reader"
-xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-xfs_io -F -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
+$XFS_IO_PROG -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
 wait
 rm $testdir/io_test
 
diff --git a/tests/generic/135 b/tests/generic/135
index fed0cd9..783a106 100755
--- a/tests/generic/135
+++ b/tests/generic/135
@@ -64,18 +64,18 @@ _umount_mount
 cd $SCRATCH_MNT
 
 # create file with async I/O
-xfs_io -F -f -c 'pwrite -b 4k -S 0x12 0 4k' async_file > /dev/null
+$XFS_IO_PROG -f -c 'pwrite -b 4k -S 0x12 0 4k' async_file > /dev/null
 
 # create file with sync I/O
-xfs_io -F -f -s -c 'pwrite -b 4k -S 0x34 0 4k' sync_file > /dev/null
+$XFS_IO_PROG -f -s -c 'pwrite -b 4k -S 0x34 0 4k' sync_file > /dev/null
 
 # create file with sync I/O
-xfs_io -F -f -d -c 'pwrite -b 4k -S 0x56 0 4k' direct_file > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 4k -S 0x56 0 4k' direct_file > /dev/null
 
 # create file, truncate and then dirty again
-xfs_io -F -f -c 'pwrite -b 4k -S 0x78 0 4k' trunc_file > /dev/null
-xfs_io -F -f -c 'truncate 2k' trunc_file > /dev/null
-xfs_io -F -c 'pwrite 1k 0 1k' trunc_file > /dev/null
+$XFS_IO_PROG -f -c 'pwrite -b 4k -S 0x78 0 4k' trunc_file > /dev/null
+$XFS_IO_PROG -f -c 'truncate 2k' trunc_file > /dev/null
+$XFS_IO_PROG -c 'pwrite 1k 0 1k' trunc_file > /dev/null
 
 _umount_mount
 
diff --git a/tests/generic/141 b/tests/generic/141
index 39400de..83b5486 100755
--- a/tests/generic/141
+++ b/tests/generic/141
@@ -52,7 +52,7 @@ _scratch_mount
 # create file, mmap a region and mmap read it
 file=$SCRATCH_MNT/mmap
 
-xfs_io -F -f -c "pwrite 0 1024k" -c "mmap 64k 64k" -c "mread -r" $file > /dev/null
+$XFS_IO_PROG -f -c "pwrite 0 1024k" -c "mmap 64k 64k" -c "mread -r" $file > /dev/null
 
 rm -f $file
 
diff --git a/tests/generic/169 b/tests/generic/169
index 0a07053..ebeffa7 100755
--- a/tests/generic/169
+++ b/tests/generic/169
@@ -67,7 +67,7 @@ echo "# creating new file for io"
 touch $SCRATCH_MNT/testfile
 
 echo "# appending 15k to new file, sync every 5k"
-xfs_io -F -a -c "pwrite 0 5k" -c "fsync" \
+$XFS_IO_PROG -a -c "pwrite 0 5k" -c "fsync" \
 	-c "pwrite 5k 5k" -c "fsync" \
 	-c "pwrite 10k 5k" -c "fsync" -c "stat" \
 	$SCRATCH_MNT/testfile \
@@ -82,11 +82,11 @@ _scratch_mount >>$seqres.full 2>&1 \
     || _fail "mount failed: $MOUNT_OPTIONS"
 
 echo "# stating file to confirm correct size"
-xfs_io -F -r -c "stat" $SCRATCH_MNT/testfile \
+$XFS_IO_PROG -r -c "stat" $SCRATCH_MNT/testfile \
 	| _show_wrote_and_stat_only
 
 echo "# appending 10 bytes to new file, sync at 5 bytes"
-xfs_io -F -f -c "pwrite 0 5" -c s -c "pwrite 5 5" \
+$XFS_IO_PROG -f -c "pwrite 0 5" -c s -c "pwrite 5 5" \
 	-c "stat" $SCRATCH_MNT/nextfile \
 	| _show_wrote_and_stat_only
 
@@ -99,7 +99,7 @@ _scratch_mount >>$seqres.full 2>&1 \
     || _fail "mount failed: $MOUNT_OPTIONS"
 
 echo "# stating file to confirm correct size"
-xfs_io -F -r -c "stat" $SCRATCH_MNT/nextfile \
+$XFS_IO_PROG -r -c "stat" $SCRATCH_MNT/nextfile \
     | _show_wrote_and_stat_only
 
 # success, all done
diff --git a/tests/generic/213 b/tests/generic/213
index a0bfd16..3c8a304 100755
--- a/tests/generic/213
+++ b/tests/generic/213
@@ -61,19 +61,19 @@ avail=`df -P $TEST_DIR | awk 'END {print $4}'`
 [ "$avail" -ge 1049600 ] || _notrun "Test device is too small ($avail KiB)"
 
 # reserve 1GiB, truncate at 100bytes
-$XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'truncate 100' $TEST_DIR/ouch
+$XFS_IO_PROG -f -c 'falloc 0 1g' -c 'truncate 100' $TEST_DIR/ouch
 rm -f $TEST_DIR/ouch
 
 # reserve 1GiB, truncate at 1GiB
-$XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'truncate 1g' $TEST_DIR/ouch
+$XFS_IO_PROG -f -c 'falloc 0 1g' -c 'truncate 1g' $TEST_DIR/ouch
 rm -f $TEST_DIR/ouch
 
 # reserve 1GiB, truncate at 2GiB
-$XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'truncate 2g' $TEST_DIR/ouch
+$XFS_IO_PROG -f -c 'falloc 0 1g' -c 'truncate 2g' $TEST_DIR/ouch
 rm -f $TEST_DIR/ouch
 
 # reserve 1GiB, 1GiB hole, reserve 1MiB, truncate at 3GiB
-$XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'falloc 2g 1m' -c 'truncate 3g' $TEST_DIR/ouch
+$XFS_IO_PROG -f -c 'falloc 0 1g' -c 'falloc 2g 1m' -c 'truncate 3g' $TEST_DIR/ouch
 rm -f $TEST_DIR/ouch
 
 # Try to reserve more space than we have
@@ -81,7 +81,7 @@ echo "We should get: fallocate: No space left on device"
 echo "Strangely, xfs_io sometimes says \"Success\" when something went wrong, FYI"
 
 let toobig=$avail*2
-$XFS_IO_PROG -F -f -c "falloc 0 ${toobig}k" $TEST_DIR/ouch
+$XFS_IO_PROG -f -c "falloc 0 ${toobig}k" $TEST_DIR/ouch
 rm -f $TEST_DIR/ouch
 
 # success, all done
diff --git a/tests/generic/214 b/tests/generic/214
index f1257ee..1885534 100755
--- a/tests/generic/214
+++ b/tests/generic/214
@@ -63,7 +63,7 @@ rm -f $TEST_DIR/test214-*
 
 # Super-trivial; preallocate a region and read it; get 0s.
 echo "=== falloc & read  ==="
-$XFS_IO_PROG -F -f 		\
+$XFS_IO_PROG -f 		\
 	-c 'falloc 0 4096'	\
 	-c 'pread -v 0 4096'	\
 	$TEST_DIR/test214-1 | _filter_xfs_io_unique
@@ -72,7 +72,7 @@ $XFS_IO_PROG -F -f 		\
 # Should get no stale data.  Early ext4 bug.
 
 echo "=== falloc, write beginning, read ==="
-$XFS_IO_PROG -F -f 		\
+$XFS_IO_PROG -f 		\
 	-c 'falloc 0 512'	\
 	-c 'pwrite 0 1'		\
 	-c 'pread -v 0 512'	\
@@ -80,7 +80,7 @@ $XFS_IO_PROG -F -f 		\
 
 # Same but write in the middle of the region
 echo "=== falloc, write middle, read ==="
-$XFS_IO_PROG -F -f 		\
+$XFS_IO_PROG -f 		\
 	-c 'falloc 0 512'	\
 	-c 'pwrite 256 1'	\
 	-c 'pread -v 0 512'	\
@@ -88,7 +88,7 @@ $XFS_IO_PROG -F -f 		\
 
 # Same but write the end of the region
 echo "=== falloc, write end, read ==="
-$XFS_IO_PROG -F -f		\
+$XFS_IO_PROG -f			\
 	-c 'falloc 0 512'	\
 	-c 'pwrite 511 1'	\
 	-c 'pread -v 0 512'	\
@@ -106,7 +106,7 @@ $XFS_IO_PROG -F -f		\
 
 echo "=== falloc, write, sync, truncate, read ==="
 # Allocate, write, sync, truncate (buffered)
-$XFS_IO_PROG -F -f				\
+$XFS_IO_PROG -f					\
 	-c 'falloc         0x0     0x65C00'	\
 	-c 'pwrite -S 0xAA 0x12000 0x10000'	\
 	-c 'fsync'				\
@@ -114,7 +114,7 @@ $XFS_IO_PROG -F -f				\
 	$TEST_DIR/test214-5 | _filter_xfs_io_unique
 
 # now do a direct read and see what's on-disk
-$XFS_IO_PROG -F -f -d				\
+$XFS_IO_PROG -f -d				\
 	-c 'pread -v 0 0x16000'			\
 	$TEST_DIR/test214-5 | _filter_xfs_io_unique
 
@@ -126,7 +126,7 @@ echo "=== delalloc write 16k; fallocate same range ==="
 # delalloc write 16k, fallocate same range.
 # Should get caught on fsck when we're done.
 
-$XFS_IO_PROG -F -f				\
+$XFS_IO_PROG -f					\
 	-c "pwrite 0 16k"			\
 	-c "falloc 0 16k"			\
 	-c "fsync"				\
@@ -136,8 +136,8 @@ $XFS_IO_PROG -F -f				\
 
 echo "=== ext4 testcase 2 ==="
 
-$XFS_IO_PROG -F -f \
-        -c "fsync"              \
+$XFS_IO_PROG -f \
+        -c "fsync"                      \
         -c "pwrite 551917 41182"        \
         -c "falloc 917633 392230"       \
         -c "pwrite 285771 77718"        \
diff --git a/tests/generic/215 b/tests/generic/215
index 6e75645..eaae8d8 100755
--- a/tests/generic/215
+++ b/tests/generic/215
@@ -59,7 +59,7 @@ sleep 2
 
 echo
 echo "writing via mmap"
-$XFS_IO_PROG -F -f 		\
+$XFS_IO_PROG -f 		\
 	-c 'mmap 0 4096'	\
 	-c 'mwrite 0 4096'	\
 	$testfile | _filter_xfs_io_unique
diff --git a/tests/generic/219 b/tests/generic/219
index 071d798..2b75b89 100755
--- a/tests/generic/219
+++ b/tests/generic/219
@@ -82,11 +82,11 @@ test_accounting()
 	echo "--- initiating parallel IO..." >>$seqres.full
 	# Small ios here because ext3 will account for indirect blocks too ...
 	# 48k will fit w/o indirect for 4k blocks (default blocksize)
-	$XFS_IO_PROG -F -c 'pwrite 0 48k' -c 'fsync' \
+	$XFS_IO_PROG -c 'pwrite 0 48k' -c 'fsync' \
 					$SCRATCH_MNT/buffer >>$seqres.full 2>&1 &
-	$XFS_IO_PROG -F -c 'pwrite 0 48k' -d \
+	$XFS_IO_PROG -c 'pwrite 0 48k' -d \
 					$SCRATCH_MNT/direct >>$seqres.full 2>&1 &
-	$XFS_IO_PROG -F -c 't 48k' -c 'mm -rw 0 48k' -c 'mw 0 48k' -c 'ms -s' \
+	$XFS_IO_PROG -c 't 48k' -c 'mm -rw 0 48k' -c 'mw 0 48k' -c 'ms -s' \
 					$SCRATCH_MNT/mmap   >>$seqres.full 2>&1 &
 	wait
 	echo "--- completed parallel IO ($type)" >>$seqres.full
diff --git a/tests/generic/223 b/tests/generic/223
index 416a14a..7b0e584 100755
--- a/tests/generic/223
+++ b/tests/generic/223
@@ -66,10 +66,10 @@ for SUNIT_K in 8 16 32 64 128; do
 
 		echo "=== Testing size ${SIZE_MULT}*${SUNIT_K}k on ${SUNIT_K}k stripe ==="
 		for FILE in 1 2 3 4; do
-			xfs_io -F -f -c "falloc 0 $SIZE" \
+			$XFS_IO_PROG -f -c "falloc 0 $SIZE" \
 				$SCRATCH_MNT/file-$FILE-$SIZE-falloc \
 					>> $seqres.full 2>&1
-			xfs_io -F -f -c "pwrite 0 $SIZE" \
+			$XFS_IO_PROG -f -c "pwrite 0 $SIZE" \
 				$SCRATCH_MNT/file-$FILE-$SIZE-write \
 					>> $seqres.full 2>&1
 			src/t_stripealign $SCRATCH_MNT/file-$FILE-$SIZE-falloc \
@@ -80,7 +80,7 @@ for SUNIT_K in 8 16 32 64 128; do
 	done
 
 	echo "=== Testing size 1g falloc on ${SUNIT_K}k stripe ==="
-	xfs_io -F -f -c "falloc 0 1g" \
+	$XFS_IO_PROG -f -c "falloc 0 1g" \
 	    $SCRATCH_MNT/file-1g-falloc >> $seqres.full 2>&1
 	src/t_stripealign $SCRATCH_MNT/file-1g-falloc $SUNIT_BLOCKS \
 	    | _filter_scratch
@@ -88,7 +88,7 @@ for SUNIT_K in 8 16 32 64 128; do
 	rm -f $SCRATCH_MNT/file-1g-falloc | _filter_scratch
 
 	echo "=== Testing size 1073745920 falloc on ${SUNIT_K}k stripe ==="
-	xfs_io -F -f -c "falloc 0 1073745920" \
+	$XFS_IO_PROG -f -c "falloc 0 1073745920" \
 		$SCRATCH_MNT/file-1073745920-falloc >> $seqres.full 2>&1
 	src/t_stripealign $SCRATCH_MNT/file-1073745920-falloc \
 		$SUNIT_BLOCKS | _filter_scratch
diff --git a/tests/generic/226 b/tests/generic/226
index 8b8f101..b98e889 100755
--- a/tests/generic/226
+++ b/tests/generic/226
@@ -54,7 +54,7 @@ buffer="-b $(expr 512 \* 1024)"
 echo "--> $loops buffered 64m writes in a loop"
 for I in `seq 1 $loops`; do
 	echo -n "$I "
-	xfs_io -F -f \
+	$XFS_IO_PROG -f \
 		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seqres.full
 	rm -f $SCRATCH_MNT/test
 done
@@ -66,7 +66,7 @@ _scratch_mount
 echo "--> $loops direct 64m writes in a loop"
 for I in `seq 1 $loops`; do
 	echo -n "$I "
-	xfs_io -F -f -d \
+	$XFS_IO_PROG -f -d \
 		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seqres.full
 	rm -f $SCRATCH_MNT/test 
 done
diff --git a/tests/generic/228 b/tests/generic/228
index ca375f4..03d4491 100755
--- a/tests/generic/228
+++ b/tests/generic/228
@@ -73,11 +73,11 @@ flim=`ulimit -f`
 
 echo "File size limit is now set to 100 MB."
 echo "Let us try to preallocate 101 MB. This should fail."
-$XFS_IO_PROG -F -f -c 'falloc 0 101m' $TEST_DIR/ouch
+$XFS_IO_PROG -f -c 'falloc 0 101m' $TEST_DIR/ouch
 rm -f $TEST_DIR/ouch
 
 echo "Let us now try to preallocate 50 MB. This should succeed."
-$XFS_IO_PROG -F -f -c 'falloc 0 50m' $TEST_DIR/ouch
+$XFS_IO_PROG -f -c 'falloc 0 50m' $TEST_DIR/ouch
 rm -f $TEST_DIR/ouch
 
 echo "Test over."
diff --git a/tests/generic/230 b/tests/generic/230
index 797755b..b77210f 100755
--- a/tests/generic/230
+++ b/tests/generic/230
@@ -62,23 +62,23 @@ test_enforcement()
 	echo "--- initiating IO..." >>$seqres.full
 	# Firstly fit below block soft limit
 	echo "Write 900k..."
-	su $qa_user -c "$XFS_IO_PROG -F -c 'pwrite 0 900k' -c fsync \
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 900k' -c fsync \
 		$SCRATCH_MNT/file1" 2>&1 >>$seqres.full | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
 	# Secondly overcome block soft limit
 	echo "Rewrite 1001k..."
-	su $qa_user -c "$XFS_IO_PROG -F -c 'pwrite 0 1001k' -c fsync \
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 1001k' -c fsync \
 		$SCRATCH_MNT/file1" 2>&1 >>$seqres.full | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
 	# Now try to overcome block hardlimit
 	echo "Write 1000k..."
-	su $qa_user -c "$XFS_IO_PROG -F -c 'pwrite 0 1000k' -c fsync \
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 1000k' -c fsync \
 		$SCRATCH_MNT/file2" 2>&1 >>$seqres.full | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
 	# Now sleep for grace time and check that softlimit got enforced
 	sleep $((grace+1))
 	echo "Write 4096..."
-	su $qa_user -c "$XFS_IO_PROG -F -c 'truncate 0' -c 'pwrite 0 4096' \
+	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 4096' \
 		$SCRATCH_MNT/file2" 2>&1 >>$seqres.full | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
 	# And now the softlimit test for inodes
diff --git a/tests/generic/231 b/tests/generic/231
index b50412c..a7cff35 100755
--- a/tests/generic/231
+++ b/tests/generic/231
@@ -57,7 +57,7 @@ _fsx()
 			wait
 			return 1
 		fi
-		$XFS_IO_PROG -F -c 'fsync' $SCRATCH_MNT/fsx_file$i
+		$XFS_IO_PROG -c 'fsync' $SCRATCH_MNT/fsx_file$i
 		cat $tmp.output$i | tee -a $seqres.full
 	done
 	return 0
diff --git a/tests/generic/235 b/tests/generic/235
index f430ba2..237da5e 100755
--- a/tests/generic/235
+++ b/tests/generic/235
@@ -69,7 +69,7 @@ mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seqres.full | _filter_scratch
 touch $SCRATCH_MNT/failed 2>&1 | tee -a $seqres.full | _filter_scratch
 mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seqres.full | _filter_scratch
 
-$XFS_IO_PROG -F -c 'pwrite 0 8k' -c 'fsync' \
+$XFS_IO_PROG -c 'pwrite 0 8k' -c 'fsync' \
 			$SCRATCH_MNT/testfile >>$seqres.full 2>&1
 repquota -u -g $SCRATCH_MNT  | grep -v "^root" | _filter_scratch
 
diff --git a/tests/generic/247 b/tests/generic/247
index 295259f..5f16281 100755
--- a/tests/generic/247
+++ b/tests/generic/247
@@ -66,7 +66,7 @@ start=`expr $loops - 1`
 for i in `seq $start -1 0`
 do
 	offset=`expr $i \* $iosize`
-	$XFS_IO_PROG -F -f -c "mmap -w $offset $iosize" -c "mwrite $offset $iosize" $testfile
+	$XFS_IO_PROG -f -c "mmap -w $offset $iosize" -c "mwrite $offset $iosize" $testfile
 	[ $? -ne 0 ] && exit
 done
 
diff --git a/tests/generic/249 b/tests/generic/249
index 6ba7ddb..1f25edb 100755
--- a/tests/generic/249
+++ b/tests/generic/249
@@ -53,9 +53,9 @@ SRC=$TEST_DIR/$seq.src
 DST=$TEST_DIR/$seq.dst
 rm -f $seqres.full
 
-$XFS_IO_PROG -F -f -c "pwrite -S 0xa5a55a5a 0 32768k" -c fsync $SRC >> $seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0xa5a55a5a 0 32768k" -c fsync $SRC >> $seqres.full 2>&1
 [ $? -ne 0 ] && _fail "xfs_io pwrite failed"
-$XFS_IO_PROG -F -f -c "sendfile -i $SRC 0 32768k" -c fsync $DST >> $seqres.full 2>&1
+$XFS_IO_PROG -f -c "sendfile -i $SRC 0 32768k" -c fsync $DST >> $seqres.full 2>&1
 [ $? -ne 0 ] && _fail "xfs_io sendfile failed"
 
 diff -q $SRC $DST
diff --git a/tests/generic/255 b/tests/generic/255
index 2e8ddef..dd329b4 100755
--- a/tests/generic/255
+++ b/tests/generic/255
@@ -53,15 +53,15 @@ _require_xfs_io_fiemap
 testfile=$TEST_DIR/255.$$
 
 # Standard punch hole tests
-_test_generic_punch falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+_test_generic_punch falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile
 
 # Delayed allocation punch hole tests
-_test_generic_punch -d falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+_test_generic_punch -d falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile
 
 # Multi hole punch tests
-_test_generic_punch -k falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+_test_generic_punch -k falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile
 
 # Delayed allocation multi punch hole tests
-_test_generic_punch -d -k falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+_test_generic_punch -d -k falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile
 
 status=0 ; exit
diff --git a/tests/generic/256 b/tests/generic/256
index 18ab819..4a53da8 100755
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -92,11 +92,11 @@ _fill_fs() {
 	while [ $file_size -ge $block_size ]
 	do
 		bytes_written=0
-		_user_do "$XFS_IO_PROG -F -f -c \"pwrite 0 $file_size\" $dir/$file_count.bin &> /dev/null"
+		_user_do "$XFS_IO_PROG -f -c \"pwrite 0 $file_size\" $dir/$file_count.bin &> /dev/null"
 
 		if [ -f $dir/$file_count.bin ]
 		then
-			bytes_written=`$XFS_IO_PROG -F -c "stat"  $dir/$file_count.bin | grep stat.size | cut -d ' ' -f3`
+			bytes_written=`$XFS_IO_PROG -c "stat"  $dir/$file_count.bin | grep stat.size | cut -d ' ' -f3`
 		fi
 
 		# If there was no room to make the file,
@@ -139,7 +139,7 @@ _test_full_fs_punch()
 
 	rm -f $file_name &> /dev/null
 
-	$XFS_IO_PROG -F -f -c "pwrite 0 $file_len" \
+	$XFS_IO_PROG -f -c "pwrite 0 $file_len" \
 		-c "fsync" $file_name &> /dev/null
 	chmod 666 $file_name
 
@@ -149,7 +149,7 @@ _test_full_fs_punch()
 	do
 		# This part must not be done as root in order to
 		# test that reserved blocks are used when needed
-		_user_do "$XFS_IO_PROG -F -f -c \"fpunch $hole_offset $hole_len\" $file_name"
+		_user_do "$XFS_IO_PROG -f -c \"fpunch $hole_offset $hole_len\" $file_name"
 		rc=$?
 		if [ $? -ne 0 ] ; then
 			echo Punch hole failed
diff --git a/tests/generic/274 b/tests/generic/274
index 5f3a51c..da45fab 100755
--- a/tests/generic/274
+++ b/tests/generic/274
@@ -61,7 +61,7 @@ _scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
 # Create a 4k file and Allocate 4M past EOF on that file
-xfs_io -F -f -c "pwrite 0 4k" -c "falloc -k 4k 4m" $SCRATCH_MNT/test \
+$XFS_IO_PROG -f -c "pwrite 0 4k" -c "falloc -k 4k 4m" $SCRATCH_MNT/test \
 	>>$seqres.full 2>&1 || _fail "failed to create test file"
 
 # Fill the rest of the fs completely
diff --git a/tests/generic/286 b/tests/generic/286
old mode 100644
new mode 100755
index a0d4df9..0652fd4
--- a/tests/generic/286
+++ b/tests/generic/286
@@ -63,7 +63,7 @@ test01()
 	done
 
 	echo "*** test01() create sparse file ***" >>$seqres.full
-	eval ${XFS_IO_PROG} -F -f "${write_cmd}" $src >>$seqres.full 2>&1 ||
+	eval ${XFS_IO_PROG} -f "${write_cmd}" $src >>$seqres.full 2>&1 ||
 		_fail "create sparse file failed!"
 	echo "*** test01() create sparse file done ***" >>$seqres.full
 	echo >>$seqres.full
@@ -91,7 +91,7 @@ test02()
 	done
 
 	echo "*** test02() create sparse file ***" >>$seqres.full
-	eval ${XFS_IO_PROG} -F -f "${write_cmd}" $src >>$seqres.full 2>&1 ||
+	eval ${XFS_IO_PROG} -f "${write_cmd}" $src >>$seqres.full 2>&1 ||
 		_fail "create sparse file failed!"
 	echo "*** test02() create sparse file done ***" >>$seqres.full
 	echo >>$seqres.full
@@ -134,7 +134,7 @@ test03()
 	done
 
 	echo "*** test03() create sparse file ***" >>$seqres.full
-	eval ${XFS_IO_PROG} -F -f "${write_cmd}" $src >>$seqres.full 2>&1 ||
+	eval ${XFS_IO_PROG} -f "${write_cmd}" $src >>$seqres.full 2>&1 ||
 		_fail "create sparse file failed!"
 	echo "*** test03() create sparse file done ***" >>$seqres.full
 	echo >>$seqres.full
@@ -176,7 +176,7 @@ test04()
 	done
 
 	echo "*** test04() create sparse file ***" >>$seqres.full
-	eval ${XFS_IO_PROG} -F -f "${write_cmd}" $src >>$seqres.full 2>&1 ||
+	eval ${XFS_IO_PROG} -f "${write_cmd}" $src >>$seqres.full 2>&1 ||
 		_fail "create sparse file failed!"
 	echo "*** test04() create sparse file done ***" >>$seqres.full
 	echo >>$seqres.full
diff --git a/tests/generic/306 b/tests/generic/306
old mode 100644
new mode 100755
index e8e0fc0..d225af5
--- a/tests/generic/306
+++ b/tests/generic/306
@@ -73,9 +73,9 @@ _scratch_mount -o ro || _fail "Could not mount scratch readonly"
 echo "== try to create new file"
 touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
 echo "== pwrite to null device"
-$XFS_IO_PROG -F -c "pwrite 0 512" /dev/null | _filter_xfs_io
+$XFS_IO_PROG -c "pwrite 0 512" /dev/null | _filter_xfs_io
 echo "== pread from zero device"
-$XFS_IO_PROG -F -c "pread 0 512" /dev/zero | _filter_xfs_io
+$XFS_IO_PROG -c "pread 0 512" /dev/zero | _filter_xfs_io
 
 echo "== truncating write to null device"
 echo foo > $DEVNULL 2>&1 | _filter_scratch
@@ -84,16 +84,16 @@ echo foo >> $DEVNULL 2>&1 | _filter_scratch
 
 echo "== writing to symlink from ro fs to rw fs"
 # Various combinations of O_CREAT & O_TRUNC
-$XFS_IO_PROG -F -c "pwrite 0 512" $SYMLINK | _filter_xfs_io
-$XFS_IO_PROG -F -f -c "pwrite 0 512" $SYMLINK | _filter_xfs_io
-$XFS_IO_PROG -F -t -c "pwrite 0 512" $SYMLINK | _filter_xfs_io
+$XFS_IO_PROG -c "pwrite 0 512" $SYMLINK | _filter_xfs_io
+$XFS_IO_PROG -f -c "pwrite 0 512" $SYMLINK | _filter_xfs_io
+$XFS_IO_PROG -t -c "pwrite 0 512" $SYMLINK | _filter_xfs_io
 
 echo "== write to bind-mounted rw file on ro fs"
 mount --bind $TARGET $BINDFILE
 # with and without -f (adds O_CREAT)
-$XFS_IO_PROG -F -c "pwrite 0 512" $BINDFILE | _filter_xfs_io
-$XFS_IO_PROG -F -f -c "pwrite 0 512" $BINDFILE | _filter_xfs_io
-$XFS_IO_PROG -F -t -c "pwrite 0 512" $BINDFILE | _filter_xfs_io
+$XFS_IO_PROG -c "pwrite 0 512" $BINDFILE | _filter_xfs_io
+$XFS_IO_PROG -f -c "pwrite 0 512" $BINDFILE | _filter_xfs_io
+$XFS_IO_PROG -t -c "pwrite 0 512" $BINDFILE | _filter_xfs_io
 
 # success, all done
 status=0
diff --git a/tests/shared/218 b/tests/shared/218
index c8b3f7d..f21b8b2 100755
--- a/tests/shared/218
+++ b/tests/shared/218
@@ -65,7 +65,7 @@ touch $fragfile
 _defrag $fragfile
 
 echo "Sparse file (no blocks):" | tee -a $seqres.full
-xfs_io -F -f -c "truncate 1m" $fragfile
+$XFS_IO_PROG -f -c "truncate 1m" $fragfile
 _defrag $fragfile
 
 echo "Contiguous file:" | tee -a $seqres.full
diff --git a/tests/shared/243 b/tests/shared/243
index 05edc1e..e0f2db2 100755
--- a/tests/shared/243
+++ b/tests/shared/243
@@ -130,7 +130,7 @@ rm -f ${TEST_DIR}/test_?
 # Begin test cases.
 echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)." \
     >> $seqres.full
-${XFS_IO_PROG} -F -f                    \
+${XFS_IO_PROG} -f                       \
     -c 'falloc -k 0 40960'              \
     -c 'pwrite 0 4096'                  \
     ${TEST_DIR}/test_1 | _filter_xfs_io_unique
@@ -138,7 +138,7 @@ _check_ext4_eof_flag test_1 ${BIT_SET}
 
 echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)." \
     >> $seqres.full
-${XFS_IO_PROG} -F -f -d                 \
+${XFS_IO_PROG} -f -d                    \
     -c 'falloc -k 0 40960'              \
     -c 'pwrite 0 4096'                  \
     ${TEST_DIR}/test_2 | _filter_xfs_io_unique
@@ -146,7 +146,7 @@ _check_ext4_eof_flag test_2 ${BIT_SET}
 
 echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)." \
     >> $seqres.full
-${XFS_IO_PROG} -F -f                    \
+${XFS_IO_PROG} -f                       \
     -c 'falloc -k 0 40960'              \
     -c 'pwrite 0 40960'                 \
     ${TEST_DIR}/test_3 | _filter_xfs_io_unique
@@ -154,7 +154,7 @@ _check_ext4_eof_flag test_3 ${BIT_NOT_SET}
 
 echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)." \
     >> $seqres.full
-${XFS_IO_PROG} -F -f -d                 \
+${XFS_IO_PROG} -f -d                    \
     -c 'falloc -k 0 40960'              \
     -c 'pwrite 0 40960'                 \
     ${TEST_DIR}/test_4 | _filter_xfs_io_unique
@@ -162,7 +162,7 @@ _check_ext4_eof_flag test_4 ${BIT_NOT_SET}
 
 echo "Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io)." \
     >> $seqres.full
-${XFS_IO_PROG} -F -f                    \
+${XFS_IO_PROG} -f                       \
     -c 'falloc -k 0 128k'               \
     -c 'pwrite 256k 4k'                 \
     ${TEST_DIR}/test_5 | _filter_xfs_io_unique
@@ -170,7 +170,7 @@ _check_ext4_eof_flag test_5 ${BIT_NOT_SET}
 
 echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io)." \
     >> $seqres.full
-${XFS_IO_PROG} -F -f -d                 \
+${XFS_IO_PROG} -f -d                    \
     -c 'falloc -k 0 128k'               \
     -c 'pwrite 256k 4k'                 \
     ${TEST_DIR}/test_6 | _filter_xfs_io_unique
diff --git a/tests/shared/298 b/tests/shared/298
old mode 100644
new mode 100755
diff --git a/tests/xfs/252 b/tests/xfs/252
index 7015f87..00be41a 100755
--- a/tests/xfs/252
+++ b/tests/xfs/252
@@ -52,15 +52,15 @@ _require_xfs_io_fiemap
 testfile=$TEST_DIR/252.$$
 
 # Standard punch hole tests
-_test_generic_punch falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
+_test_generic_punch falloc fpunch fpunch fiemap _filter_fiemap $testfile
 
 # Delayed allocation punch hole tests
-_test_generic_punch -d falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
+_test_generic_punch -d falloc fpunch fpunch fiemap _filter_fiemap $testfile
 
 # Multi hole punch tests
-_test_generic_punch -k falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
+_test_generic_punch -k falloc fpunch fpunch fiemap _filter_fiemap $testfile
 
 # Delayed allocation multi punch hole tests
-_test_generic_punch -d -k falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
+_test_generic_punch -d -k falloc fpunch fpunch fiemap _filter_fiemap $testfile
 
 status=0 ; exit

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
