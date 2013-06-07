Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0F8197F37
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 08:06:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74ED8AC002
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 06:06:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9Bbhh6lte6XY5U2g for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 06:06:46 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkwNN-0005a6-7j
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkwNN-0003oq-4Z
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfstests: ensure all mkfs output is redirected properly
Date: Fri,  7 Jun 2013 23:06:34 +1000
Message-Id: <1370610398-14630-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1370610398-14630-1-git-send-email-david@fromorbit.com>
References: <1370610398-14630-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

mkfs.xfs with experimental CRC support outputs extra warnings about
being experimental on stderr, and so some tests do not redirect the
output correctly. These tests fail with a golden output mismatch due
to this. Fix these tests by redirecting stderr to either seqres.full
or /dev/null.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/dump   |    4 ++--
 common/rc     |    2 +-
 common/repair |    2 ++
 tests/xfs/004 |    3 ++-
 tests/xfs/021 |    2 +-
 tests/xfs/029 |    2 +-
 tests/xfs/030 |    5 +++--
 tests/xfs/031 |   10 +++++++---
 tests/xfs/033 |    6 ++++--
 tests/xfs/041 |    5 +++--
 tests/xfs/042 |    2 +-
 tests/xfs/050 |    3 ++-
 tests/xfs/052 |    3 ++-
 tests/xfs/067 |    4 ++--
 tests/xfs/071 |    3 ++-
 tests/xfs/072 |    3 +--
 tests/xfs/073 |   17 +++++++++++------
 tests/xfs/092 |    2 +-
 tests/xfs/104 |    7 +++++--
 tests/xfs/106 |    3 ++-
 tests/xfs/107 |    3 ++-
 tests/xfs/108 |    3 ++-
 tests/xfs/109 |    3 ++-
 tests/xfs/110 |    3 ++-
 tests/xfs/118 |    2 +-
 tests/xfs/178 |    2 +-
 tests/xfs/189 |    3 ++-
 tests/xfs/244 |    6 ++++--
 tests/xfs/287 |    4 ++--
 29 files changed, 73 insertions(+), 44 deletions(-)

diff --git a/common/dump b/common/dump
index 7fe50f6..9c998e5 100644
--- a/common/dump
+++ b/common/dump
@@ -236,8 +236,8 @@ _wipe_fs()
 {
     _require_scratch
 
-    _scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
-    _scratch_mount >>$seqres.full || _fail "mount failed"
+    _scratch_mkfs_xfs >>$seqres.full 2>&1 || _fail "mkfs failed"
+    _scratch_mount >>$seqres.full 2>&1 || _fail "mount failed"
 }
 
 #
diff --git a/common/rc b/common/rc
index fe6bbfc..88d38ef 100644
--- a/common/rc
+++ b/common/rc
@@ -1078,7 +1078,7 @@ _require_dm_flakey()
 #
 _require_projid32bit()
 {
-        _scratch_mkfs_xfs -f -i projid32bit=0 2>&1 >/dev/null \
+        _scratch_mkfs_xfs -f -i projid32bit=0 >/dev/null 2>&1 \
 	   || _notrun "mkfs.xfs doesn't have projid32bit feature"
 }
 
diff --git a/common/repair b/common/repair
index db160bb..243f70f 100644
--- a/common/repair
+++ b/common/repair
@@ -80,6 +80,8 @@ s/\s+- \d+:\d\d:\d\d:.*\n//g;
 # crc enabled filesystem output
 /XFS_CORRUPTION_ERROR/ && next;
 /^bad uuid/ && next;
+/^Version 5 superblock detected./ && next;
+/^Use of these features/ && next;
 	print;'
 }
 
diff --git a/tests/xfs/004 b/tests/xfs/004
index 978943d..e491b5f 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -41,7 +41,8 @@ trap "_cleanup" 0 1 2 3 15
 _populate_scratch()
 {
 	echo "=== mkfs output ===" >>$seqres.full
-	_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+	_scratch_mkfs_xfs 2> /dev/null | tee -a $seqres.full \
+			| _filter_mkfs 2>$tmp.mkfs || _fail "mkfs failed"
 	. $tmp.mkfs
 	_scratch_mount
 	dd if=/dev/zero of=$SCRATCH_MNT/foo count=200 bs=4096 >/dev/null 2>&1 &
diff --git a/tests/xfs/021 b/tests/xfs/021
index a727b51..46a3f1b 100755
--- a/tests/xfs/021
+++ b/tests/xfs/021
@@ -83,7 +83,7 @@ rm -f $seqres.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 
 echo "*** mkfs"
-_scratch_mkfs_xfs >/dev/null \
+_scratch_mkfs_xfs >/dev/null 2>&1 \
 	|| _fail "mkfs failed"
 
 echo "*** mount FS"
diff --git a/tests/xfs/029 b/tests/xfs/029
index 0709fce..3992c94 100755
--- a/tests/xfs/029
+++ b/tests/xfs/029
@@ -58,7 +58,7 @@ _supported_os Linux
 _require_scratch
 
 echo
-_scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
+_scratch_mkfs_xfs > /dev/null 2>&1 || _fail "mkfs failed"
 
 echo
 _scratch_xfs_logprint | _filter_logprint
diff --git a/tests/xfs/030 b/tests/xfs/030
index af03166..2321da4 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -74,7 +74,7 @@ DSIZE="-dsize=100m,agcount=6"
 # superblock (hanging around from earlier tests)...
 #
 
-_scratch_mkfs_xfs $DSIZE >/dev/null 2>&1
+_scratch_mkfs_xfs $DSIZE >/dev/null 2>&1 || _fail "mkfs failed"
 if [ $? -ne 0 ]		# probably don't have a big enough scratch
 then
 	_notrun "SCRATCH_DEV too small, results would be non-deterministic"
@@ -98,7 +98,8 @@ src/devzero -v -1 -n "$clear" $SCRATCH_DEV >/dev/null
 
 # now kick off the real repair test...
 #
-_scratch_mkfs_xfs $DSIZE | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs $DSIZE 2>/dev/null | _filter_mkfs 2>$tmp.mkfs\
+		|| _fail "mkfs failed"
 . $tmp.mkfs
 _check_ag 0
 _check_ag -1
diff --git a/tests/xfs/031 b/tests/xfs/031
index 48a97e1..3fd5b3a 100755
--- a/tests/xfs/031
+++ b/tests/xfs/031
@@ -56,6 +56,8 @@ _check_repair()
 		fi
 		# echo all interesting stuff...
 		perl -ne '
+			/EXPERIMENTAL/d;
+			/Use of these features/d;
 			s/(rebuilding directory inode) (\d+)/\1 INO/g;
 			s/internal log/<TYPEOF> log/g;
 			s/external log on \S+/<TYPEOF> log/g;
@@ -104,7 +106,7 @@ _require_no_large_scratch_dev
 # Note: must do this proto/mkfs now for later inode size calcs
 _create_proto 0
 echo "=== one entry (shortform)"
-_scratch_mkfs_xfs -p $tmp.proto >$tmp.mkfs0 2>&1
+_scratch_mkfs_xfs -p $tmp.proto >$tmp.mkfs0 2>&1 || _fail "mkfs failed"
 _filter_mkfs <$tmp.mkfs0 >/dev/null 2>$tmp.mkfs
 . $tmp.mkfs
 _check_repair
@@ -112,13 +114,15 @@ _check_repair
 # block-form root directory & repeat
 _create_proto 20
 echo "=== twenty entries (block form)"
-_scratch_mkfs_xfs -p $tmp.proto | _filter_mkfs >/dev/null 2>&1
+_scratch_mkfs_xfs -p $tmp.proto 2> /dev/null | _filter_mkfs >/dev/null 2>&1 \
+		|| _fail "mkfs failed"
 _check_repair
 
 # leaf-form root directory & repeat
 _create_proto 1000
 echo "=== thousand entries (leaf form)"
-_scratch_mkfs_xfs -p $tmp.proto | _filter_mkfs >/dev/null 2>&1
+_scratch_mkfs_xfs -p $tmp.proto | _filter_mkfs >/dev/null 2>&1 \
+		|| _fail "mkfs failed"
 _check_repair
 
 # success, all done
diff --git a/tests/xfs/033 b/tests/xfs/033
index bf906e0..3b69018 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -81,10 +81,12 @@ _require_scratch
 _require_no_large_scratch_dev
 
 # devzero blows away 512byte blocks, so make 512byte inodes (at least)
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>$tmp.mkfs \
+		|| _fail "mkfs failed"
 . $tmp.mkfs
 [ $isize -lt 512 ] && \
-	_scratch_mkfs_xfs -isize=512 | _filter_mkfs >/dev/null 2>&1
+	_scratch_mkfs_xfs -isize=512 2> /dev/null \
+		| _filter_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 
 `xfs_db -r -c sb -c p $SCRATCH_DEV | grep 'ino = ' | \
 	sed -e 's/ //g' -e 's/^/export /'`
diff --git a/tests/xfs/041 b/tests/xfs/041
index 8b109fc..f25975a 100755
--- a/tests/xfs/041
+++ b/tests/xfs/041
@@ -63,8 +63,9 @@ _do_die_on_error=message_only
 rm -f $seqres.full
 agsize=32
 echo -n "Make $agsize megabyte filesystem on SCRATCH_DEV and mount... "
-_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 >/dev/null || _fail "mkfs failed"
-bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 | _filter_mkfs 2>&1 \
+_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 >/dev/null 2>&1 || _fail "mkfs failed"
+bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2> /dev/null \
+		|_filter_mkfs 2>&1 \
 		| perl -ne 'if (/dbsize=(\d+)/) {print $1;}'`
 onemeginblocks=`expr 1048576 / $bsize`
 _scratch_mount || _fail "mount failed"
diff --git a/tests/xfs/042 b/tests/xfs/042
index db0fa28..bb9ab03 100755
--- a/tests/xfs/042
+++ b/tests/xfs/042
@@ -91,7 +91,7 @@ rm -f $seqres.full
 _do_die_on_error=message_only
 
 echo -n "Make a 48 megabyte filesystem on SCRATCH_DEV and mount... "
-_scratch_mkfs_xfs -dsize=48m,agcount=3 2>&1 >/dev/null || _fail "mkfs failed"
+_scratch_mkfs_xfs -dsize=48m,agcount=3 >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed" 
 
 echo "done"
diff --git a/tests/xfs/050 b/tests/xfs/050
index 6641e7d..6339042 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -116,7 +116,8 @@ _qsetup()
 
 _exercise()
 {
-	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+	_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>$tmp.mkfs \
+			|| _fail "mkfs failed"
 	cat $tmp.mkfs >>$seqres.full
 
 	# keep the blocksize and data size for dd later
diff --git a/tests/xfs/052 b/tests/xfs/052
index c2cf596..f2dec2c 100755
--- a/tests/xfs/052
+++ b/tests/xfs/052
@@ -59,7 +59,8 @@ _require_nobody
 # setup a default run
 _qmount_option uquota
 
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>$tmp.mkfs \
+		|| _fail "mkfs failed"
 cat $tmp.mkfs >>$seqres.full
 chmod a+w $seqres.full     # arbitrary users will write here
 
diff --git a/tests/xfs/067 b/tests/xfs/067
index 27f5713..fd664b6 100755
--- a/tests/xfs/067
+++ b/tests/xfs/067
@@ -47,10 +47,10 @@ _require_scratch
 
 # set up fs for 1K inodes
 isize=0
-_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+_scratch_mkfs_xfs 2>&1 | _filter_mkfs >$seqres.full 2>$tmp.mkfs
 [ $? -eq 0 ] && source $tmp.mkfs
 if [ "$isize" -lt 1024 ]; then
-    _scratch_mkfs_xfs -i size=1024 >>$seqres.full \
+    _scratch_mkfs_xfs -i size=1024 >>$seqres.full 2>&1 \
 	|| _notrun "Cannot mkfs for this test using MKFS_OPTIONS specified"
 fi
 _scratch_mount >>$seqres.full || _fail "mount failed"
diff --git a/tests/xfs/071 b/tests/xfs/071
index 86c6899..0aeb8d6 100755
--- a/tests/xfs/071
+++ b/tests/xfs/071
@@ -105,7 +105,8 @@ _supported_os IRIX Linux
 [ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
 
 _require_scratch
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>$tmp.mkfs \
+		|| _fail "mkfs failed"
 . $tmp.mkfs
 echo
 _scratch_mount
diff --git a/tests/xfs/072 b/tests/xfs/072
index 9949749..e71bb08 100755
--- a/tests/xfs/072
+++ b/tests/xfs/072
@@ -51,9 +51,8 @@ _supported_os IRIX Linux
 _require_scratch
 
 rm -f $seqres.full
-umount $SCRATCH_DEV >/dev/null 2>&1
 
-_scratch_mkfs_xfs >/dev/null	|| _fail "mkfs failed"
+_scratch_mkfs_xfs >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount >/dev/null	|| _fail "mount failed"
 
 # check there's enough freespace on $SCRATCH_MNT ... (1GiB + 1MiB)
diff --git a/tests/xfs/073 b/tests/xfs/073
index ad38059..caffd13 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -133,7 +133,8 @@ _supported_os Linux
 _require_scratch
 _require_loop
 
-_scratch_mkfs_xfs -dsize=41m,agcount=2 | _filter_mkfs 2>/dev/null
+_scratch_mkfs_xfs -dsize=41m,agcount=2 2> /dev/null | _filter_mkfs 2>/dev/null \
+		|| _fail "mkfs failed"
 _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"
 
 echo
@@ -143,17 +144,20 @@ umount $SCRATCH_MNT 2>/dev/null
 
 echo
 echo === copying scratch device to single target
-$XFS_COPY_PROG $SCRATCH_DEV $imgs.image | _filter_copy '#' $imgs.image '#' '#'
+$XFS_COPY_PROG $SCRATCH_DEV $imgs.image 2> /dev/null \
+	| _filter_copy '#' $imgs.image '#' '#'
 _verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
 
 echo
 echo === copying scratch device to single target, duplicate UUID
-$XFS_COPY_PROG -d $SCRATCH_DEV $imgs.image | _filter_copy '#' $imgs.image '#' '#'
+$XFS_COPY_PROG -d $SCRATCH_DEV $imgs.image 2> /dev/null \
+	| _filter_copy '#' $imgs.image '#' '#'
 _verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
 
 echo 
 echo === copying scratch device to single target, large ro device
-${MKFS_PROG}.xfs -dfile,name=$imgs.source,size=100g | _filter_mkfs 2>/dev/null
+${MKFS_PROG}.xfs -dfile,name=$imgs.source,size=100g 2> /dev/null \
+		| _filter_mkfs 2>/dev/null
 rmdir $imgs.source_dir 2>/dev/null
 mkdir $imgs.source_dir
 
@@ -161,7 +165,8 @@ mount -t xfs -o loop $imgs.source $imgs.source_dir
 loop2=`mount | grep $imgs.source | grep -o -e 'loop=.*[^),]' | grep -o -e '/.*$'`
 cp -a $here $imgs.source_dir
 mount -t xfs -o remount,ro $imgs.source $imgs.source_dir
-$XFS_COPY_PROG $imgs.source $imgs.image | _filter_copy '#' $imgs.image '#' '#'
+$XFS_COPY_PROG $imgs.source $imgs.image 2> /dev/null \
+	| _filter_copy '#' $imgs.image '#' '#'
 _verify_copy $imgs.image $imgs.source $imgs.source_dir
 
 # HACK WARNING:
@@ -173,7 +178,7 @@ losetup -d $loop2 > /dev/null 2>&1
 echo
 echo === copying scratch device to multiple targets
 $XFS_COPY_PROG -L$imgs.log -b $SCRATCH_DEV $imgs.image1 $imgs.image2 \
-	| _filter_copy '#' $imgs.image1 '#' $imgs.image2
+	2> /dev/null | _filter_copy '#' $imgs.image1 '#' $imgs.image2
 _verify_copy $imgs.image1 $SCRATCH_DEV $SCRATCH_MNT
 _verify_copy $imgs.image2 $SCRATCH_DEV $SCRATCH_MNT
 
diff --git a/tests/xfs/092 b/tests/xfs/092
index f195077..0268785 100755
--- a/tests/xfs/092
+++ b/tests/xfs/092
@@ -50,7 +50,7 @@ _require_scratch
 _require_no_large_scratch_dev
 
 MOUNT_OPTIONS="$MOUNT_OPTIONS -o inode64"
-_scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>/dev/null || _fail "mkfs failed"
 echo Silence is golden
 
 _scratch_mount
diff --git a/tests/xfs/104 b/tests/xfs/104
index d31cf16..a8d7535 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -38,7 +38,8 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 _create_scratch()
 {
 	echo "*** mkfs"
-	_scratch_mkfs_xfs $@ | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+	_scratch_mkfs_xfs $@ 2> /dev/null | tee -a $seqres.full \
+			  | _filter_mkfs 2>$tmp.mkfs || _fail "mkfs failed"
 	. $tmp.mkfs
 
 	echo "*** mount"
@@ -71,7 +72,9 @@ _stress_scratch()
 # real QA test starts here
 _supported_fs xfs
 _require_scratch
-_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs 2> /dev/null | tee -a $seqres.full \
+		| _filter_mkfs 2>$tmp.mkfs || _fail "mkfs failed"
+
 . $tmp.mkfs	# extract blocksize and data size for scratch device
 
 endsize=`expr 550 \* 1048576`	# stop after growing this big
diff --git a/tests/xfs/106 b/tests/xfs/106
index 7f97722..421c6cb 100755
--- a/tests/xfs/106
+++ b/tests/xfs/106
@@ -44,7 +44,8 @@ _require_scratch
 _require_xfs_quota
 
 # real QA test starts here
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>$tmp.mkfs \
+		|| _fail "mkfs failed"
 cat $tmp.mkfs >$seqres.full
 . $tmp.mkfs
 
diff --git a/tests/xfs/107 b/tests/xfs/107
index 2bd20a3..87f93e9 100755
--- a/tests/xfs/107
+++ b/tests/xfs/107
@@ -56,7 +56,8 @@ _require_scratch
 _require_xfs_quota
 
 # real QA test starts here
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>$tmp.mkfs \
+		|| _fail "mkfs failed"
 cat $tmp.mkfs >$seqres.full
 . $tmp.mkfs
 
diff --git a/tests/xfs/108 b/tests/xfs/108
index 5a47009..81f7527 100755
--- a/tests/xfs/108
+++ b/tests/xfs/108
@@ -83,7 +83,8 @@ _require_prjquota $SCRATCH_DEV
 # real QA test starts here
 rm -f $tmp.projects $seqres.full
 umount $SCRATCH_DEV 2>/dev/null
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>$tmp.mkfs \
+		|| _fail "mkfs failed"
 cat $tmp.mkfs >>$seqres.full
 _scratch_mount
 
diff --git a/tests/xfs/109 b/tests/xfs/109
index 5578c90..55282f9 100755
--- a/tests/xfs/109
+++ b/tests/xfs/109
@@ -102,7 +102,8 @@ if [ -n "$FASTSTART" -a -f $SCRATCH_MNT/f0 ]; then
 fi
 umount $SCRATCH_DEV
 
-_scratch_mkfs_xfs -dsize=160m,agcount=4 $faststart | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs -dsize=160m,agcount=4 $faststart 2> /dev/null \
+			| _filter_mkfs 2>$tmp.mkfs || _fail "mkfs failed"
 cat $tmp.mkfs >>$seqres.full
 _scratch_mount
 
diff --git a/tests/xfs/110 b/tests/xfs/110
index 48bea45..36497e7 100755
--- a/tests/xfs/110
+++ b/tests/xfs/110
@@ -42,7 +42,8 @@ _require_scratch
 
 # real QA test starts here
 umount $SCRATCH_DEV 2>/dev/null
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>$tmp.mkfs \
+		|| _fail "mkfs failed"
 
 STR1=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
 STR2=BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
diff --git a/tests/xfs/118 b/tests/xfs/118
index 8414594..9e9b173 100755
--- a/tests/xfs/118
+++ b/tests/xfs/118
@@ -72,7 +72,7 @@ _chowning_file()
 }
 
 echo "mkfs on scratch"
-_scratch_mkfs_xfs >$seqres.full
+_scratch_mkfs_xfs >$seqres.full 2> /dev/null || _fail "mkfs failed"
 
 echo "mount with quotas"
 export MOUNT_OPTIONS="-o uquota"
diff --git a/tests/xfs/178 b/tests/xfs/178
index 9db8d05..4efba35 100755
--- a/tests/xfs/178
+++ b/tests/xfs/178
@@ -74,7 +74,7 @@ _supported_os Linux
 #             fix filesystem, new mkfs.xfs will be fine.
 
 _require_scratch
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs \
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>$tmp.mkfs \
         || _fail "mkfs failed!"
 
 # By executing the followint tmp file, will get on the mkfs options stored in
diff --git a/tests/xfs/189 b/tests/xfs/189
index 27bfb63..81139b2 100755
--- a/tests/xfs/189
+++ b/tests/xfs/189
@@ -241,7 +241,8 @@ _require_scratch
 unset SCRATCH_RTDEV
 unset SCRATCH_LOGDEV
 
-_scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
+_scratch_mkfs_xfs 2> /dev/null | _filter_mkfs 2>/dev/null \
+	|| _fail "mkfs failed"
 
 _add_scratch_fstab
 _test_remount_rw
diff --git a/tests/xfs/244 b/tests/xfs/244
index d899a3d..7d2a2d3 100755
--- a/tests/xfs/244
+++ b/tests/xfs/244
@@ -52,7 +52,8 @@ _require_projid32bit
 export MOUNT_OPTIONS="-opquota"
 
 # make fs with no projid32bit
-_scratch_mkfs_xfs -i projid32bit=0 >> $seqres.full || _fail "mkfs failed"
+_scratch_mkfs_xfs -i projid32bit=0 2> /dev/null >> $seqres.full \
+		|| _fail "mkfs failed"
 _qmount
 # make sure project quota is supported
 _require_prjquota ${SCRATCH_DEV}
@@ -96,7 +97,8 @@ fi
 
 #  Do testing on filesystem with projid32bit feature enabled
 umount $SCRATCH_DEV 2>/dev/null
-_scratch_mkfs_xfs -i projid32bit=1 >> $seqres.full || _fail "mkfs failed"
+_scratch_mkfs_xfs -i projid32bit=1 >> $seqres.full 2> /dev/null \
+		|| _fail "mkfs failed"
 _qmount
 mkdir $dir
 
diff --git a/tests/xfs/287 b/tests/xfs/287
index 10853d1..9de0b3d 100755
--- a/tests/xfs/287
+++ b/tests/xfs/287
@@ -58,8 +58,8 @@ _require_scratch
 _require_projid32bit
 
 # create xfs fs without projid32bit ability, will be gained by xfs_admin
-_scratch_mkfs_xfs -i projid32bit=0 -d size=200m >> $seqres.full \
-		|| _fail "mkfs failed"
+_scratch_mkfs_xfs -i projid32bit=0 -d size=200m 2> /dev/null >> $seqres.full \
+		 || _fail "mkfs failed"
 _qmount_option "pquota"
 _qmount
 # require project quotas
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
