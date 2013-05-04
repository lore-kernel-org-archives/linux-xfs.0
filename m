Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E299629DF8
	for <xfs@oss.sgi.com>; Sat,  4 May 2013 08:24:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB7DC304043
	for <xfs@oss.sgi.com>; Sat,  4 May 2013 06:24:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3yW28ucerwTEUzeQ for
	<xfs@oss.sgi.com>; Sat, 04 May 2013 06:23:59 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r44DNwZa010209
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 4 May 2013 09:23:58 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r44DNvul008292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 4 May 2013 09:23:58 -0400
Message-ID: <51850BED.6050109@redhat.com>
Date: Sat, 04 May 2013 08:23:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: automatically add -F to xfs_io on non-xfs
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

The -F flag to xfs_io originally enabled it to operate on non-xfs
filesystems.  This restriction was removed upstream in favor of
gracefully failing on the handful of operations that actually
required xfs, and the option was deprecated.

However, xfstests is still used on distros with older xfsprogs, and
so "xfs_io -F" was necessary throughout xfstests.

Simplify this by appending -F to XFS_IO_PROG when it's exported,
if we're not running on an xfs filesystem.

This will eliminate errors when new tests leave out the -F, and
if and when -F is finally removed, there will be one central location
in xfstests to update.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/config b/common/config
index 67c1498..554a2c2 100644
--- a/common/config
+++ b/common/config
@@ -157,6 +157,8 @@ export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
 export XFS_DB_PROG="`set_prog_path xfs_db`"
 export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
 export XFS_IO_PROG="`set_prog_path xfs_io`"
+# Older xfs_io refuses to run w/o -F on non-xfs
+[ "$FSTYP" != "xfs" ] && export XFS_IO_PROG="$XFS_IO_PROG -F"
 export XFS_PARALLEL_REPAIR_PROG="`set_prog_path xfs_prepair`"
 export XFS_PARALLEL_REPAIR64_PROG="`set_prog_path xfs_prepair64`"
 export __XFSDUMP_PROG="`set_prog_path xfsdump`"
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
index e8e0fc0..d225af5 100755
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
