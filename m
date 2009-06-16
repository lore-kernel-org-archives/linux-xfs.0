Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5G39Oxw140047 for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 22:09:25 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7268169719
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 20:17:27 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id qw92HgmdtgpMGzSx for
	<xfs@oss.sgi.com>; Mon, 15 Jun 2009 20:17:27 -0700 (PDT)
Message-ID: <4A370D00.7030309@sandeen.net>
Date: Mon, 15 Jun 2009 22:09:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfstests: move xfs_io filters to common.filter
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>

Move duplicated xfs_io filters to common.filter

Also fix up 132 output, which was misfiltered due
to a bug in the filtering.

Doing this because I need this same filter for the next
added test.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---


diff --git a/071 b/071

index 15067b9..303498e 100755
--- a/071
+++ b/071
@@ -53,11 +53,6 @@ _filter_off()
     sed -e "s/$1/<OFFSET>/g" | _filter_io
 }
 
-_filter_xfs_io()
-{
-    sed -e "s/[0-9/.]* bytes, [0-9] ops\; [0-9/.]* sec ([0-9/.]* [MKiBbytes]*\/sec and [0-9/.]* ops\/sec)/XXX bytes, X ops\; XXX sec (X YYY\/sec and XXX ops\/sec/"
-}
-
 write_block()
 {
     location=$1
diff --git a/130 b/130
index 4c1aeaf..816f4bc 100755
--- a/130
+++ b/130
@@ -51,23 +51,6 @@ _cleanup()
 . ./common.rc
 . ./common.filter
 
-common_line_filter()
-{
-    perl -ne 'if (/.*:(.*)/) {
-        if ( "$last_line" ne "$1" ) { print "$_"; $first_match=1; }
-        elsif ( $first_match==1 ) { print "*\n"; $first_match=0; }
-        $last_line="$1";
-    }
-    else {
-        print $_; $last_line=$_;
-    }'
-}
-
-_filter_xfs_io()
-{
-    common_line_filter | sed -e "s/[0-9/.]* [GMKiBbytes]*, [0-9]* ops\; [0-9/:. sec]* ([inf0-9/.]* [EPGMKiBbytes]*\/sec and [inf0-9/.]* ops\/sec)/XXX Bytes, X ops\; XX:XX:XX.X (XXX YYY\/sec and XXX ops\/sec)/"
-}
-
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux IRIX
@@ -83,26 +66,26 @@ xfs_io -F -f -d -t -c "pwrite -S 0x63 0 65536" \
     -c "truncate 1" \
     -c "pwrite -S 0x41 65536 65536" \
     -c "pread -v 0 131072" \
-    $SCRATCH_MNT/eof-zeroing_direct | _filter_xfs_io
+    $SCRATCH_MNT/eof-zeroing_direct | _filter_xfs_io_unique
 
 echo
 echo "Basic Block Hole test"
 xfs_io -F -f -t -c "truncate 8192" \
     -c "pread -v 5000 3000" \
-    $SCRATCH_MNT/blackhole | _filter_xfs_io
+    $SCRATCH_MNT/blackhole | _filter_xfs_io_unique
 
 echo
 echo "Test buffered and direct IO coherency"
 xfs_io -F -f -t -c "pwrite -S 0x41 8000 1000" \
     -c "pwrite -S 0x57 4000 1000" \
-    $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io
+    $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io_unique
 
 xfs_io -F -d -c "pwrite -S 0x78 20480 4096"\
     -c "pwrite -S 0x79 4096 4096"\
-    $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io
+    $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io_unique
 
 xfs_io -F -c "pread -v 0 9000"\
-    $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io
+    $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io_unique
 
 echo
 echo "Test direct read and write"
@@ -110,19 +93,19 @@ xfs_io -F -f -d -t -c "pwrite -S 0x78 0 65536"\
     -c "pread -v 0 65536"\
     -c "pwrite -S 0x46 65536 6553600"\
     -c "pread -v 0 6619136"\
-    $SCRATCH_MNT/direct_io | _filter_xfs_io
+    $SCRATCH_MNT/direct_io | _filter_xfs_io_unique
 
 xfs_io -F -d -c "pread -v 0 6619136"\
-    $SCRATCH_MNT/direct_io | _filter_xfs_io
+    $SCRATCH_MNT/direct_io | _filter_xfs_io_unique
 
 xfs_io -F -f -d -t -c "pwrite -S 0x61 0 65536"\
     -c "pread -v 0 65536"\
     -c "pwrite -S 0x62 65536 131072"\
     -c "pread -v 0 131072"\
-    $SCRATCH_MNT/async_direct_io | _filter_xfs_io
+    $SCRATCH_MNT/async_direct_io | _filter_xfs_io_unique
 
 xfs_io -F -d -c "pread -v 0 131072"\
-    $SCRATCH_MNT/async_direct_io | _filter_xfs_io
+    $SCRATCH_MNT/async_direct_io | _filter_xfs_io_unique
 
 echo
 echo "FSB Edge test"
@@ -132,16 +115,16 @@ xfs_io -F -f -t -c "truncate 131072"\
     -c "truncate 131072"\
     -c "pwrite -S 0x61 65535 2"\
     -c "pread -v 0 131072"\
-    $SCRATCH_MNT/fsb_edge_test | _filter_xfs_io
+    $SCRATCH_MNT/fsb_edge_test | _filter_xfs_io_unique
 
 echo
 echo "Open Trunk test (O_TRUNC)"
 for n in 0 1 2 3 4
 do
-    xfs_io -F -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io
+    xfs_io -F -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io_unique
 
     echo "Test" > $SCRATCH_MNT/$n
-    xfs_io -F -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io
+    xfs_io -F -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io_unique
     cat $SCRATCH_MNT/$n
 done
 echo "DONE"
@@ -151,7 +134,7 @@ echo "Append test"
 echo "append to me" > $SCRATCH_MNT/append
 xfs_io -F -a -c "pwrite -S 0x61 0 10" \
     -c "pread -v 0 24"\
-    $SCRATCH_MNT/append | _filter_xfs_io
+    $SCRATCH_MNT/append | _filter_xfs_io_unique
 
 echo
 echo "Small Vector Async"
@@ -210,7 +193,7 @@ xfs_io -F -f -c "pread -v 0 1"\
     -c "pread -v 10000000004 4"\
     -c "pread -v 10000000008 4"\
     -c "pread -v 10000000012 4"\
-    $SCRATCH_MNT/small_vector_async | _filter_xfs_io
+    $SCRATCH_MNT/small_vector_async | _filter_xfs_io_unique
 
 echo
 echo "Small Vector Sync"
@@ -269,7 +252,7 @@ xfs_io -F -f -s -c "pread -v 0 1"\
     -c "pread -v 10000000004 4"\
     -c "pread -v 10000000008 4"\
     -c "pread -v 10000000012 4"\
-    $SCRATCH_MNT/small_vector_async | _filter_xfs_io
+    $SCRATCH_MNT/small_vector_async | _filter_xfs_io_unique
 
 status=0
 exit
diff --git a/132 b/132
index 4aff11c..760315c 100755
--- a/132
+++ b/132
@@ -43,23 +43,6 @@ _cleanup()
 . ./common.rc
 . ./common.filter
 
-common_line_filter()
-{
-    perl -ne 'if (/.*:(.*)/) {
-        if ( "$last_line" ne "$1" ) { print $_; $first_match=1; }
-        elsif ( $first_match==1 ) { print "*\n"; $first_match=0; }
-        $last_line="$1";
-    }
-    else {
-        print $_
-    }'
-}
-
-_filter_xfs_io()
-{
-    common_line_filter | sed -e "s/[0-9/.]* [GMKiBbytes]*, [0-9]* ops\; [0-9/:. sec]* ([inf0-9/.]* [EPGMKiBbytes]*\/sec and [inf0-9/.]* ops\/sec)/XXX Bytes, X ops\; XX:XX:XX.X (XXX YYY\/sec and XXX ops\/sec)/"
-}
-
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux IRIX
@@ -86,7 +69,7 @@ xfs_io -F -f -t -c "pwrite -S 0x63 0 512" \
     -c "pread -v 2560 512" \
     -c "pread -v 3072 512" \
     -c "pread -v 3584 512" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x63 4096 1024" \
     -c "pwrite -S 0x6B 5120 1024" \
@@ -100,7 +83,7 @@ xfs_io -F -f -c "pwrite -S 0x63 4096 1024" \
     -c "pread -v 5120 1024" \
     -c "pread -v 6144 1024" \
     -c "pread -v 7168 1024" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x6E 8192 2048" \
     -c "pwrite -S 0x6F 10240 2048" \
@@ -110,14 +93,14 @@ xfs_io -F -f -c "pwrite -S 0x6E 8192 2048" \
     -c "pread -v 6144 2048" \
     -c "pread -v 8192 2048" \
     -c "pread -v 10240 2048" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x70 12288 4096" \
     -c "pread -v 0 4096" \
     -c "pread -v 4096 4096" \
     -c "pread -v 8192 4096" \
     -c "pread -v 12288 4096" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x71 16384 8192" \
     -c "pwrite -S 0x72 24576 8192" \
@@ -125,7 +108,7 @@ xfs_io -F -f -c "pwrite -S 0x71 16384 8192" \
     -c "pread -v 8192 8192" \
     -c "pread -v 8192 8192" \
     -c "pread -v 16384 8192" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x73 32768 16384" \
     -c "pwrite -S 0x74 49152 16384" \
@@ -133,7 +116,7 @@ xfs_io -F -f -c "pwrite -S 0x73 32768 16384" \
     -c "pread -v 16384 16384" \
     -c "pread -v 32768 16384" \
     -c "pread -v 49152 16384" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x75 65536 32768" \
     -c "pwrite -S 0x76 98304 32768" \
@@ -141,7 +124,7 @@ xfs_io -F -f -c "pwrite -S 0x75 65536 32768" \
     -c "pread -v 32768 32768" \
     -c "pread -v 65536 32768" \
     -c "pread -v 98304 32768" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x76 131072 65536" \
     -c "pwrite -S 0x77 196608 65536" \
@@ -149,7 +132,7 @@ xfs_io -F -f -c "pwrite -S 0x76 131072 65536" \
     -c "pread -v 65536 65536" \
     -c "pread -v 131072 65536" \
     -c "pread -v 196608 65536" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x76 262144 131072" \
     -c "pwrite -S 0x77 393216 131072" \
@@ -157,14 +140,14 @@ xfs_io -F -f -c "pwrite -S 0x76 262144 131072" \
     -c "pread -v 131072 131072" \
     -c "pread -v 262144 131072" \
     -c "pread -v 393216 131072" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x76 524288 524288" \
     -c "pwrite -S 0x77 1048576 524288" \
     -c "pread -v 0 524288" \
     -c "pread -v 524288 524288" \
     -c "pread -v 1048576 524288" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pwrite -S 0x33 2097152 1048576" \
@@ -183,7 +166,7 @@ xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pread -v 6291456 1048576" \
     -c "pread -v 7340032 1048576" \
     -c "pread -v 8388608 1048576" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pwrite -S 0x33 2097152 1048576" \
@@ -204,7 +187,7 @@ xfs_io -F -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pread -v 7340032 1048576" \
     -c "pread -v 8388608 1048576" \
     -c "pread -v 9437184 1048576" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 xfs_io -F -f -c "pwrite -S 0x92 10485760 10485760" \
     -c "pwrite -S 0x93 20971520 10485760" \
@@ -225,7 +208,7 @@ xfs_io -F -f -c "pwrite -S 0x92 10485760 10485760" \
     -c "pread -v 73400320 10485760" \
     -c "pread -v 83886080 10485760" \
     -c "pread -v 94371840 10485760" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io
+    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
 
 status=0
 exit
diff --git a/132.out b/132.out
index db8a3f9..ab04044 100644
--- a/132.out
+++ b/132.out
@@ -383,6 +383,8 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 65536/65536 bytes at offset 65536
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00020000:  76 76 76 76 76 76 76 76 76 76 76 76 76 76 76 76  vvvvvvvvvvvvvvvv
+*
 read 65536/65536 bytes at offset 131072
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00030000:  77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77  wwwwwwwwwwwwwwww
@@ -437,6 +439,8 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 131072/131072 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00020000:  76 76 76 76 76 76 76 76 76 76 76 76 76 76 76 76  vvvvvvvvvvvvvvvv
+*
 00030000:  77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77  wwwwwwwwwwwwwwww
 *
 read 131072/131072 bytes at offset 131072
diff --git a/common.filter b/common.filter
index a30bac4..802aac2 100644
--- a/common.filter
+++ b/common.filter
@@ -192,5 +192,27 @@ _filter_dd()
     '
 }
 
+common_line_filter()
+{
+    perl -ne 'if (/.*:(.*)/) {
+        if ( "$last_line" ne "$1" ) { print "$_"; $first_match=1; }
+        elsif ( $first_match==1 ) { print "*\n"; $first_match=0; }
+        $last_line="$1";
+    }
+    else {
+        print $_; $last_line=$_;
+    }'
+}
+
+_filter_xfs_io()
+{
+    sed -e "s/[0-9/.]* [GMKiBbytes]*, [0-9]* ops\; [0-9/:. sec]* ([inf0-9/.]* [EPGMKiBbytes]*\/sec and [inf0-9/.]* ops\/sec)/XXX Bytes, X ops\; XX:XX:XX.X (XXX YYY\/sec and XXX ops\/sec)/"
+}
+
+_filter_xfs_io_unique()
+{
+    common_line_filter | _filter_xfs_io
+}
+
 # make sure this script returns success
 /bin/true

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
