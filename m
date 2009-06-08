Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n58Hnt71240767 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 12:49:55 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DC9812354B5
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 10:50:13 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id AqTGgmF5RgJ5cGyF for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2009 10:50:13 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n58HoD26011745
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 13:50:13 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n58HoBIH011327
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 13:50:11 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n58Ho9ha014801
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 13:50:10 -0400
Message-ID: <4A2D4F51.5050906@redhat.com>
Date: Mon, 08 Jun 2009 12:50:09 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: allow more xfs_io tests to be generic
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

What do folks think of this?  These tests just do generic
reads & writes with xfs_io; if we add a "-F" they will run
on other filesystems.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/130 b/130
index 9d44756..4c1aeaf 100755
--- a/130
+++ b/130
@@ -69,7 +69,7 @@ _filter_xfs_io()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _setup_testdir
@@ -79,7 +79,7 @@ _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
 echo "End-of-file zeroing with direct I/O"
-xfs_io -f -d -t -c "pwrite -S 0x63 0 65536" \
+xfs_io -F -f -d -t -c "pwrite -S 0x63 0 65536" \
     -c "truncate 1" \
     -c "pwrite -S 0x41 65536 65536" \
     -c "pread -v 0 131072" \
@@ -87,46 +87,46 @@ xfs_io -f -d -t -c "pwrite -S 0x63 0 65536" \
 
 echo
 echo "Basic Block Hole test"
-xfs_io -f -t -c "truncate 8192" \
+xfs_io -F -f -t -c "truncate 8192" \
     -c "pread -v 5000 3000" \
     $SCRATCH_MNT/blackhole | _filter_xfs_io
 
 echo
 echo "Test buffered and direct IO coherency"
-xfs_io -f -t -c "pwrite -S 0x41 8000 1000" \
+xfs_io -F -f -t -c "pwrite -S 0x41 8000 1000" \
     -c "pwrite -S 0x57 4000 1000" \
     $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io
 
-xfs_io -d -c "pwrite -S 0x78 20480 4096"\
+xfs_io -F -d -c "pwrite -S 0x78 20480 4096"\
     -c "pwrite -S 0x79 4096 4096"\
     $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io
 
-xfs_io -c "pread -v 0 9000"\
+xfs_io -F -c "pread -v 0 9000"\
     $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io
 
 echo
 echo "Test direct read and write"
-xfs_io -f -d -t -c "pwrite -S 0x78 0 65536"\
+xfs_io -F -f -d -t -c "pwrite -S 0x78 0 65536"\
     -c "pread -v 0 65536"\
     -c "pwrite -S 0x46 65536 6553600"\
     -c "pread -v 0 6619136"\
     $SCRATCH_MNT/direct_io | _filter_xfs_io
 
-xfs_io -d -c "pread -v 0 6619136"\
+xfs_io -F -d -c "pread -v 0 6619136"\
     $SCRATCH_MNT/direct_io | _filter_xfs_io
 
-xfs_io -f -d -t -c "pwrite -S 0x61 0 65536"\
+xfs_io -F -f -d -t -c "pwrite -S 0x61 0 65536"\
     -c "pread -v 0 65536"\
     -c "pwrite -S 0x62 65536 131072"\
     -c "pread -v 0 131072"\
     $SCRATCH_MNT/async_direct_io | _filter_xfs_io
 
-xfs_io -d -c "pread -v 0 131072"\
+xfs_io -F -d -c "pread -v 0 131072"\
     $SCRATCH_MNT/async_direct_io | _filter_xfs_io
 
 echo
 echo "FSB Edge test"
-xfs_io -f -t -c "truncate 131072"\
+xfs_io -F -f -t -c "truncate 131072"\
     -c "pwrite -S 0x5F 0 131072"\
     -c "truncate 0"\
     -c "truncate 131072"\
@@ -138,10 +138,10 @@ echo
 echo "Open Trunk test (O_TRUNC)"
 for n in 0 1 2 3 4
 do
-    xfs_io -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io
+    xfs_io -F -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io
 
     echo "Test" > $SCRATCH_MNT/$n
-    xfs_io -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io
+    xfs_io -F -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io
     cat $SCRATCH_MNT/$n
 done
 echo "DONE"
@@ -149,14 +149,14 @@ echo "DONE"
 echo
 echo "Append test"
 echo "append to me" > $SCRATCH_MNT/append
-xfs_io -a -c "pwrite -S 0x61 0 10" \
+xfs_io -F -a -c "pwrite -S 0x61 0 10" \
     -c "pread -v 0 24"\
     $SCRATCH_MNT/append | _filter_xfs_io
 
 echo
 echo "Small Vector Async"
 echo "abcdefghijklmnopqrstuvwxyz" > $SCRATCH_MNT/small_vector_async
-xfs_io -f -c "pread -v 0 1"\
+xfs_io -F -f -c "pread -v 0 1"\
     -c "pread -v 1 1"\
     -c "pread -v 2 1"\
     -c "pread -v 3 1"\
@@ -215,7 +215,7 @@ xfs_io -f -c "pread -v 0 1"\
 echo
 echo "Small Vector Sync"
 echo "abcdefghijklmnopqrstuvwxyz" > $SCRATCH_MNT/small_vector_async
-xfs_io -f -s -c "pread -v 0 1"\
+xfs_io -F -f -s -c "pread -v 0 1"\
     -c "pread -v 1 1"\
     -c "pread -v 2 1"\
     -c "pread -v 3 1"\
diff --git a/132 b/132
index 02031bd..4aff11c 100755
--- a/132
+++ b/132
@@ -61,7 +61,7 @@ _filter_xfs_io()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _setup_testdir
@@ -70,7 +70,7 @@ _require_scratch
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-xfs_io -f -t -c "pwrite -S 0x63 0 512" \
+xfs_io -F -f -t -c "pwrite -S 0x63 0 512" \
     -c "pwrite -S 0x64 512 512" \
     -c "pwrite -S 0x65 1024 512" \
     -c "pwrite -S 0x66 1536 512" \
@@ -88,7 +88,7 @@ xfs_io -f -t -c "pwrite -S 0x63 0 512" \
     -c "pread -v 3584 512" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x63 4096 1024" \
+xfs_io -F -f -c "pwrite -S 0x63 4096 1024" \
     -c "pwrite -S 0x6B 5120 1024" \
     -c "pwrite -S 0x6C 6144 1024" \
     -c "pwrite -S 0x6D 7168 1024" \
@@ -102,7 +102,7 @@ xfs_io -f -c "pwrite -S 0x63 4096 1024" \
     -c "pread -v 7168 1024" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x6E 8192 2048" \
+xfs_io -F -f -c "pwrite -S 0x6E 8192 2048" \
     -c "pwrite -S 0x6F 10240 2048" \
     -c "pread -v 0 2048" \
     -c "pread -v 2048 2048" \
@@ -112,14 +112,14 @@ xfs_io -f -c "pwrite -S 0x6E 8192 2048" \
     -c "pread -v 10240 2048" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x70 12288 4096" \
+xfs_io -F -f -c "pwrite -S 0x70 12288 4096" \
     -c "pread -v 0 4096" \
     -c "pread -v 4096 4096" \
     -c "pread -v 8192 4096" \
     -c "pread -v 12288 4096" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x71 16384 8192" \
+xfs_io -F -f -c "pwrite -S 0x71 16384 8192" \
     -c "pwrite -S 0x72 24576 8192" \
     -c "pread -v 0 8192" \
     -c "pread -v 8192 8192" \
@@ -127,7 +127,7 @@ xfs_io -f -c "pwrite -S 0x71 16384 8192" \
     -c "pread -v 16384 8192" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x73 32768 16384" \
+xfs_io -F -f -c "pwrite -S 0x73 32768 16384" \
     -c "pwrite -S 0x74 49152 16384" \
     -c "pread -v 0 16384" \
     -c "pread -v 16384 16384" \
@@ -135,7 +135,7 @@ xfs_io -f -c "pwrite -S 0x73 32768 16384" \
     -c "pread -v 49152 16384" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x75 65536 32768" \
+xfs_io -F -f -c "pwrite -S 0x75 65536 32768" \
     -c "pwrite -S 0x76 98304 32768" \
     -c "pread -v 0 32768" \
     -c "pread -v 32768 32768" \
@@ -143,7 +143,7 @@ xfs_io -f -c "pwrite -S 0x75 65536 32768" \
     -c "pread -v 98304 32768" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x76 131072 65536" \
+xfs_io -F -f -c "pwrite -S 0x76 131072 65536" \
     -c "pwrite -S 0x77 196608 65536" \
     -c "pread -v 0 65536" \
     -c "pread -v 65536 65536" \
@@ -151,7 +151,7 @@ xfs_io -f -c "pwrite -S 0x76 131072 65536" \
     -c "pread -v 196608 65536" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x76 262144 131072" \
+xfs_io -F -f -c "pwrite -S 0x76 262144 131072" \
     -c "pwrite -S 0x77 393216 131072" \
     -c "pread -v 0 131072" \
     -c "pread -v 131072 131072" \
@@ -159,14 +159,14 @@ xfs_io -f -c "pwrite -S 0x76 262144 131072" \
     -c "pread -v 393216 131072" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x76 524288 524288" \
+xfs_io -F -f -c "pwrite -S 0x76 524288 524288" \
     -c "pwrite -S 0x77 1048576 524288" \
     -c "pread -v 0 524288" \
     -c "pread -v 524288 524288" \
     -c "pread -v 1048576 524288" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x32 1048576 1048576" \
+xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pwrite -S 0x33 2097152 1048576" \
     -c "pwrite -S 0x34 3145728 1048576" \
     -c "pwrite -S 0x35 4194304 1048576" \
@@ -185,7 +185,7 @@ xfs_io -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pread -v 8388608 1048576" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x32 1048576 1048576" \
+xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pwrite -S 0x33 2097152 1048576" \
     -c "pwrite -S 0x34 3145728 1048576" \
     -c "pwrite -S 0x35 4194304 1048576" \
@@ -206,7 +206,7 @@ xfs_io -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pread -v 9437184 1048576" \
     $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
 
-xfs_io -f -c "pwrite -S 0x92 10485760 10485760" \
+xfs_io -F -f -c "pwrite -S 0x92 10485760 10485760" \
     -c "pwrite -S 0x93 20971520 10485760" \
     -c "pwrite -S 0x94 31457280 10485760" \
     -c "pwrite -S 0x95 41943040 10485760" \
diff --git a/133 b/133
index 88da691..26d16fe 100755
--- a/133
+++ b/133
@@ -42,36 +42,36 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _setup_testdir
 
 echo "Buffered writer, buffered reader"
-xfs_io -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-xfs_io -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-xfs_io -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
+xfs_io -F -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
+xfs_io -F -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
 wait
 rm $testdir/io_test
 
 echo "Direct writer, buffered reader"
-xfs_io -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-xfs_io -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-xfs_io -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
+xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
+xfs_io -F -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
 wait
 rm $testdir/io_test
 
 echo "Buffered writer, direct reader"
-xfs_io -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-xfs_io -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-xfs_io -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
+xfs_io -F -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
+xfs_io -F -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
 wait
 rm $testdir/io_test
 
 echo "Direct writer, direct reader"
-xfs_io -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-xfs_io -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-xfs_io -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
+xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
+xfs_io -F -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
 wait
 rm $testdir/io_test
 
diff --git a/135 b/135
index 772eff2..a3a8ac9 100755
--- a/135
+++ b/135
@@ -42,12 +42,12 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _setup_testdir
 _require_scratch
-_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mkfs >/dev/null 2>&1
 
 _umount_mount()
 {
@@ -66,18 +66,18 @@ _umount_mount
 cd $SCRATCH_MNT
 
 # create file with async I/O
-xfs_io -f -c 'pwrite -b 4k -S 0x12 0 4k' async_file > /dev/null
+xfs_io -F -f -c 'pwrite -b 4k -S 0x12 0 4k' async_file > /dev/null
 
 # create file with sync I/O
-xfs_io -f -s -c 'pwrite -b 4k -S 0x34 0 4k' sync_file > /dev/null
+xfs_io -F -f -s -c 'pwrite -b 4k -S 0x34 0 4k' sync_file > /dev/null
 
 # create file with sync I/O
-xfs_io -f -d -c 'pwrite -b 4k -S 0x56 0 4k' direct_file > /dev/null
+xfs_io -F -f -d -c 'pwrite -b 4k -S 0x56 0 4k' direct_file > /dev/null
 
 # create file, truncate and then dirty again
-xfs_io -f -c 'pwrite -b 4k -S 0x78 0 4k' trunc_file > /dev/null
-xfs_io -c 'truncate 2k' trunc_file > /dev/null
-xfs_io -c 'pwrite 1k 0 1k' trunc_file > /dev/null
+xfs_io -F -f -c 'pwrite -b 4k -S 0x78 0 4k' trunc_file > /dev/null
+xfs_io -F -f -c 'truncate 2k' trunc_file > /dev/null
+xfs_io -F -c 'pwrite 1k 0 1k' trunc_file > /dev/null
 
 _umount_mount
 
diff --git a/141 b/141
index 1c71e31..9ee27e4 100755
--- a/141
+++ b/141
@@ -42,18 +42,18 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
 _require_scratch
-_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
 # create file, mmap a region and mmap read it
 file=$SCRATCH_MNT/mmap
 
-xfs_io -f -c "pwrite 0 1024k" -c "mmap 64k 64k" -c "mread -r" $file > /dev/null
+xfs_io -F -f -c "pwrite 0 1024k" -c "mmap 64k 64k" -c "mread -r" $file > /dev/null
 
 rm -f $file
 
diff --git a/169 b/169
index 9e321e3..ac0ecad 100755
--- a/169
+++ b/169
@@ -53,12 +53,12 @@ _show_wrote_and_stat_only()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _require_scratch
 
-_scratch_mkfs_xfs >>$seq.full 2>&1 \
+_scratch_mkfs >>$seq.full 2>&1 \
 	|| _fail "mkfs scratch failed"
 
 _scratch_mount >>$seq.full 2>&1 \
@@ -68,7 +68,7 @@ echo "# creating new file for io"
 touch $SCRATCH_MNT/testfile
 
 echo "# appending 15k to new file, sync every 5k"
-xfs_io -a -c "pwrite 0 5k" -c "fsync" \
+xfs_io -F -a -c "pwrite 0 5k" -c "fsync" \
 	-c "pwrite 5k 5k" -c "fsync" \
 	-c "pwrite 10k 5k" -c "fsync" -c "stat" \
 	$SCRATCH_MNT/testfile \
@@ -83,11 +83,11 @@ _scratch_mount >>$seq.full 2>&1 \
     || _fail "mount failed: $MOUNT_OPTIONS"
 
 echo "# stating file to confirm correct size"
-xfs_io -r -c "stat" $SCRATCH_MNT/testfile \
+xfs_io -F -r -c "stat" $SCRATCH_MNT/testfile \
 	| _show_wrote_and_stat_only
 
 echo "# appending 10 bytes to new file, sync at 5 bytes"
-xfs_io -f -c "pwrite 0 5" -c s -c "pwrite 5 5" \
+xfs_io -F -f -c "pwrite 0 5" -c s -c "pwrite 5 5" \
 	-c "stat" $SCRATCH_MNT/nextfile \
 	| _show_wrote_and_stat_only
 
@@ -100,7 +100,7 @@ _scratch_mount >>$seq.full 2>&1 \
     || _fail "mount failed: $MOUNT_OPTIONS"
 
 echo "# stating file to confirm correct size"
-xfs_io -r -c "stat" $SCRATCH_MNT/nextfile \
+xfs_io -F -r -c "stat" $SCRATCH_MNT/nextfile \
     | _show_wrote_and_stat_only
 
 # success, all done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
