Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8NJNSt8026982 for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 14:23:28 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	UTxacyVQFzYkL7uL (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Sep 2012 12:24:43 -0700 (PDT)
Received: by mail-lb0-f181.google.com with SMTP id gg6so1076235lbb.26
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 12:24:43 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/6] xfstest: allow fsstress to use load factor where
	appropriate
Date: Sun, 23 Sep 2012 23:24:33 +0400
Message-Id: <1348428276-13161-3-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
References: <a>
 <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, hch@lst.de, xfs@oss.sgi.com


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 017 |    5 ++++-
 068 |    4 ++--
 070 |    4 +++-
 076 |    5 ++++-
 083 |    4 ++--
 087 |   10 ++++++----
 104 |    4 ++--
 114 |    5 +++--
 167 |    4 ++--
 232 |    5 +++--
 233 |    5 +++--
 269 |    7 ++++---
 270 |    7 ++++---
 276 |   11 ++++++-----
 14 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/017 b/017
index 9ca0e72..8d35ee8 100755
--- a/017
+++ b/017
@@ -67,7 +67,10 @@ echo "*** test"
 for l in 0 1 2 3 4
 do
         echo "    *** test $l"
-        $FSSTRESS_PROG -d $SCRATCH_MNT -n 1000 $FSSTRESS_AVOID >>$seq.full
+	NUM=$((1000 * TIME_FACTOR))
+	CPU=$((1 * LOAD_FACTOR))
+        $FSSTRESS_PROG -d $SCRATCH_MNT -n $NUM -p $CPU \
+	    $FSSTRESS_AVOID >>$seq.full
 
         _scratch_mount -o remount,ro \
             || _fail "remount ro failed"
diff --git a/068 b/068
index b595d1d..9a01100 100755
--- a/068
+++ b/068
@@ -75,8 +75,8 @@ touch $tmp.running
     STRESS_DIR="$SCRATCH_MNT/fsstress_test_dir"
     mkdir "$STRESS_DIR"
 
-    procs=2
-    nops=200
+    procs=$((2 * LOAD_FACTOR))
+    nops=$((200 * TIME_FACTOR))
     while [ -f "$tmp.running" ]
       do
       # We do both read & write IO - not only is this more realistic,
diff --git a/070 b/070
index f48c33c..286ae90 100755
--- a/070
+++ b/070
@@ -62,7 +62,9 @@ $FSSTRESS_PROG \
 	-f unresvsp=0 \
 	-f attr_set=100 \
 	-f attr_remove=100 \
-        -p 1 -n 10000 -S c >$seq.full 2>&1
+        -p $((LOAD_FACTOR)) \
+    	-n $((10000 * TIME_FACTOR)) \
+    	-S c >$seq.full 2>&1
 
 status=$?
 exit
diff --git a/076 b/076
index e472b26..fa1a916 100755
--- a/076
+++ b/076
@@ -74,7 +74,10 @@ echo "*** test concurrent block/fs access"
 cat $SCRATCH_DEV >/dev/null &
 pid=$!
 
-$FSSTRESS_PROG -d $SCRATCH_MNT -p 2 -n 2000 $FSSTRESS_AVOID >>$seq.full
+num=$((2000 * TIME_FACTOR))
+proc=$((2 * LOAD_FACTOR))
+
+$FSSTRESS_PROG -d $SCRATCH_MNT -p $proc -n $num $FSSTRESS_AVOID >>$seq.full
 
 _lets_get_pidst
 _check_scratch_fs
diff --git a/083 b/083
index e0670b9..7af7c08 100755
--- a/083
+++ b/083
@@ -66,8 +66,8 @@ workout()
 {
 	fsz=$1
 	ags=$2
-	procs=$3
-	nops=$4
+	procs=$(($3 * LOAD_FACTOR))
+	nops=$(($4 * TIME_FACTOR))
 
 	umount $SCRATCH_DEV >/dev/null 2>&1
 	echo "*** mkfs -dsize=$fsz,agcount=$ags"    >>$seq.full
diff --git a/087 b/087
index 48e5eaa..5c67f5e 100755
--- a/087
+++ b/087
@@ -43,11 +43,13 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 _do_meta()
 {
     out=$SCRATCH_MNT/fsstress
-    count=10000
-    param="-p 4 -z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10 \
+    count=$((10000 * TIME_FACTOR))
+    proc=$((4 * LOAD_FACTOR))
+    param="-z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10 \
            -f rename=30 -f stat=30 -f unlink=30 -f truncate=20"
-    _echofull "calling fsstress $param -m8 -n $count"
-    if ! $FSSTRESS_PROG $param $FSSTRESS_AVOID -m 8 -n $count -d $out >>$seq.full 2>&1
+    _echofull "calling fsstress $param -m8 -p $proc -n $count"
+    if ! $FSSTRESS_PROG $param $FSSTRESS_AVOID -m 8 -p $proc \
+		-n $count -d $out >>$seq.full 2>&1
     then
 	_echofull "fsstress failed"
     fi
diff --git a/104 b/104
index 14f2669..abc9705 100755
--- a/104
+++ b/104
@@ -61,8 +61,8 @@ _fill_scratch()
 
 _stress_scratch()
 {
-	procs=3
-	nops=1000
+	procs=$((3 * LOAD_FACTOR))
+	nops=$((1000 * TIME_FACTOR))
 	# -w ensures that the only ops are ones which cause write I/O
 	$FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n $nops $FSSTRESS_AVOID > /dev/null &
 }
diff --git a/114 b/114
index 7679222..348f992 100755
--- a/114
+++ b/114
@@ -245,12 +245,13 @@ _test_fsstress()
 	echo ""
 
 	out=$SCRATCH_MNT/fsstress.$$
-	count=1000
+	count=$((1000 * TIME_FACTOR))
+	proc=$((3 * LOAD_FACTOR))
 	args="-z \
 -f rmdir=10 -f link=10 -f creat=10 \
 -f mkdir=10 -f rename=30 -f unlink=10 \
 -f symlink=10 \
--n $count -d $out -p 3"
+-n $count -d $out -p $proc"
 
 	echo "fsstress $args" | sed -e "s#$out#outdir#"
 	if ! $FSSTRESS_PROG $args | _filter_num
diff --git a/167 b/167
index ccb6c2a..ad5fcd0 100755
--- a/167
+++ b/167
@@ -42,8 +42,8 @@ _cleanup()
 
 workout()
 {
-	procs=100
-	nops=15000
+	procs=$((100 * LOAD_FACTOR))
+	nops=$((15000 * TIME_FACTOR))
 	$FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n $nops $FSSTRESS_AVOID \
 		>>$seq.full &
 	sleep 2
diff --git a/232 b/232
index 2795da7..6cd0171 100755
--- a/232
+++ b/232
@@ -53,8 +53,9 @@ _fsstress()
 	echo ""
 
 	out=$SCRATCH_MNT/fsstress.$$
-	count=2000
-	args="-n $count -d $out -p 7"
+	count=$((2000*TIME_FACTOR))
+	CPU=$((7 * LOAD_FACTOR))
+	args="-n $count -d $out -p $CPU"
 
 	echo "fsstress $args" | tee -a $here/$seq.full | sed -e "s#$out#outdir#"
 	if ! $FSSTRESS_PROG $args | tee -a $here/$seq.full | _filter_num
diff --git a/233 b/233
index 28e6ac7..e30d9cc 100755
--- a/233
+++ b/233
@@ -57,11 +57,12 @@ _fsstress()
 	echo ""
 
 	out=$SCRATCH_MNT/fsstress.$$
-	count=5000
+	count=$((5000 * TIME_FACTOR))
+	proc=$((7 * LOAD_FACTOR))
 	args="-z \
 -f rmdir=20 -f link=10 -f creat=10 -f mkdir=10 -f unlink=20 -f symlink=10 \
 -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 \
--n $count -d $out -p 7"
+-n $count -d $out -p $proc"
 
 	echo "fsstress $args" | tee -a $here/$seq.full | sed -e "s#$out#outdir#"
 	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $here/$seq.full | _filter_num
diff --git a/269 b/269
index 7e13ed9..ca2700c 100755
--- a/269
+++ b/269
@@ -42,10 +42,11 @@ _workout()
 	echo ""
 	echo "Run fsstress"
 	echo ""
-	num_iterations=10
-	enospc_time=2
+	num_iterations=$((10 * TIME_FACTOR))
+	enospc_time=$((2 * TIME_FACTOR))
+	proc=$((128 * LOAD_FACTOR))
 	out=$SCRATCH_MNT/fsstress.$$
-	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
+	args="-p $proc -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
 	echo "fsstress $args" >> $here/$seq.full
 	$FSSTRESS_PROG $args > /dev/null 2>&1 &
 	pid=$!
diff --git a/270 b/270
index b9ada27..5197910 100755
--- a/270
+++ b/270
@@ -45,10 +45,11 @@ _workout()
 	echo ""
 	echo "Run fsstress"
 	echo ""
-	num_iterations=10
-	enospc_time=2
+	num_iterations=$((10 * TIME_FACTOR))
+	enospc_time=$((2 * TIME_FACTOR))
+	proc=$((128 * LOAD_FACTOR))
 	out=$SCRATCH_MNT/fsstress.$$
-	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
+	args="-p$proc -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
 	echo "fsstress $args" >> $here/$seq.full
 	# Grant chown capability 
 	cp $FSSTRESS_PROG  $tmp.fsstress.bin
diff --git a/276 b/276
index 082f943..551bef7 100755
--- a/276
+++ b/276
@@ -175,7 +175,8 @@ workout()
 {
 	fsz=$1
 	nfiles=$2
-	procs=$3
+	procs=$(($3 * LOAD_FACTOR))
+	num=$((1000* TIME_FACTOR))
 	snap_name=$4
 
 	umount $SCRATCH_DEV >/dev/null 2>&1
@@ -185,8 +186,8 @@ workout()
 		|| _fail "size=$fsz mkfs failed"
 	run_check _scratch_mount
 	# -w ensures that the only ops are ones which cause write I/O
-	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 1000 \
-		$FSSTRESS_AVOID
+	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n $num \
+	    	$FSSTRESS_AVOID
 
 	run_check $BTRFS_UTIL_PROG subvol snap $SCRATCH_MNT \
 		$SCRATCH_MNT/$snap_name
@@ -196,13 +197,13 @@ workout()
 
 	# make some noise but ensure we're not touching existing data
 	# extents.
-	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n 2000 \
+	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n $((num*2)) \
 		-z -f chown=3 -f link=1 -f mkdir=2 -f mknod=2 \
 		-f rename=2 -f setxattr=1 -f symlink=2
 	clean_dir="$SCRATCH_MNT/next"
 	mkdir $clean_dir
 	# now make more files to get a higher tree
-	run_check $FSSTRESS_PROG -d $clean_dir -w -p $procs -n 2000 \
+	run_check $FSSTRESS_PROG -d $clean_dir -w -p $procs -n $((num*2)) \
 		$FSSTRESS_AVOID
 	run_check umount $SCRATCH_DEV >/dev/null 2>&1
 	run_check _scratch_mount "-o atime"
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
