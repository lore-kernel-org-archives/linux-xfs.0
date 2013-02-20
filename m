Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA7457F50
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 04:42:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 449CEAC003
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 02:42:29 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id 02ftir64rSONF2AA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 02:42:26 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 05/10] xfstest: allow fsstress to use load factor where
	appropriate
Date: Wed, 20 Feb 2013 14:42:10 +0400
Message-Id: <1361356935-29153-6-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com

1) Add _scale_fsstress_args function which transform argumets according
   to load factors
2) Let all non deterministic fsstress tests to use scaled arguments

I've able to trigger OOPS on xfs see:https://gist.github.com/dmonakhov/4762653

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 017       |    3 ++-
 068       |    4 ++--
 070       |    5 +++--
 076       |    5 +++--
 083       |    4 ++--
 087       |    3 ++-
 104       |    4 +++-
 114       |    4 ++--
 167       |    5 +++--
 232       |    4 ++--
 232.out   |    1 -
 233       |    6 +++---
 233.out   |    1 -
 269       |    2 +-
 270       |    2 +-
 common.rc |   14 ++++++++++++++
 group     |   26 +++++++++++++-------------
 17 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/017 b/017
index 9ca0e72..7db4667 100755
--- a/017
+++ b/017
@@ -67,7 +67,8 @@ echo "*** test"
 for l in 0 1 2 3 4
 do
         echo "    *** test $l"
-        $FSSTRESS_PROG -d $SCRATCH_MNT -n 1000 $FSSTRESS_AVOID >>$seq.full
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -n 1000 $FSSTRESS_AVOID`
+        $FSSTRESS_PROG  $FSSTRESS_ARGS >>$seq.full
 
         _scratch_mount -o remount,ro \
             || _fail "remount ro failed"
diff --git a/068 b/068
index a641e2f..cbfea95 100755
--- a/068
+++ b/068
@@ -82,8 +82,8 @@ touch $tmp.running
       do
       # We do both read & write IO - not only is this more realistic,
       # but it also potentially tests atime updates
-      $FSSTRESS_PROG -d $STRESS_DIR -p $procs -n $nops $FSSTRESS_AVOID \
-	  > /dev/null 2>&1
+      FSSTRESS_ARGS=`_scale_fsstress_args -d $STRESS_DIR -p $procs -n $nops $FSSTRESS_AVOID`
+      $FSSTRESS_PROG $FSSTRESS_ARGS > /dev/null 2>&1
     done
 
     rm -r $STRESS_DIR/*
diff --git a/070 b/070
index f48c33c..334cce7 100755
--- a/070
+++ b/070
@@ -52,7 +52,7 @@ _require_attrs
 
 _setup_testdir
 
-$FSSTRESS_PROG \
+FSSTRESS_ARGS=`_scale_fsstress_args \
 	-d $testdir/fsstress \
 	-f allocsp=0 \
 	-f freesp=0 \
@@ -62,7 +62,8 @@ $FSSTRESS_PROG \
 	-f unresvsp=0 \
 	-f attr_set=100 \
 	-f attr_remove=100 \
-        -p 1 -n 10000 -S c >$seq.full 2>&1
+        -p 1 -n 10000 -S c`
+$FSSTRESS_PROG $FSSTRESS_ARGS >$seq.full 2>&1
 
 status=$?
 exit
diff --git a/076 b/076
index e472b26..793b869 100755
--- a/076
+++ b/076
@@ -74,8 +74,9 @@ echo "*** test concurrent block/fs access"
 cat $SCRATCH_DEV >/dev/null &
 pid=$!
 
-$FSSTRESS_PROG -d $SCRATCH_MNT -p 2 -n 2000 $FSSTRESS_AVOID >>$seq.full
-
+FSSTRESS_ARGS=`_scale_fsstress_args -p 2 -n 2000 $FSSTRESS_AVOID`
+echo "run fsstress with args: $FSSTRESS_ARGS" >>$seq.full
+$FSSTRESS_PROG $FSSTRESS_ARGS >>$seq.full
 _lets_get_pidst
 _check_scratch_fs
 
diff --git a/083 b/083
index e0670b9..f5349a9 100755
--- a/083
+++ b/083
@@ -84,8 +84,8 @@ workout()
 		|| _fail "mount failed"
 
 	# -w ensures that the only ops are ones which cause write I/O
-	$FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n $nops $FSSTRESS_AVOID \
-		>>$seq.full
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs -n $nops $FSSTRESS_AVOID`
+	$FSSTRESS_PROG $FSSTRESS_ARGS >>$seq.full
 	_check_scratch_fs
 }
 
diff --git a/087 b/087
index 48e5eaa..e7be9a0 100755
--- a/087
+++ b/087
@@ -47,7 +47,8 @@ _do_meta()
     param="-p 4 -z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10 \
            -f rename=30 -f stat=30 -f unlink=30 -f truncate=20"
     _echofull "calling fsstress $param -m8 -n $count"
-    if ! $FSSTRESS_PROG $param $FSSTRESS_AVOID -m 8 -n $count -d $out >>$seq.full 2>&1
+    FSSTRESS_ARGS=`_scale_fsstress_args $param $FSSTRESS_AVOID -m 8 -n $count -d $out`
+    if ! $FSSTRESS_PROG $FSSTRESS_ARGS >>$seq.full 2>&1
     then
 	_echofull "fsstress failed"
     fi
diff --git a/104 b/104
index 14f2669..8db6d88 100755
--- a/104
+++ b/104
@@ -64,7 +64,9 @@ _stress_scratch()
 	procs=3
 	nops=1000
 	# -w ensures that the only ops are ones which cause write I/O
-	$FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n $nops $FSSTRESS_AVOID > /dev/null &
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
+	    -n $nops $FSSTRESS_AVOID`
+	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seq.full &
 }
 
 # real QA test starts here
diff --git a/114 b/114
index 7679222..edce0f4 100755
--- a/114
+++ b/114
@@ -246,11 +246,11 @@ _test_fsstress()
 
 	out=$SCRATCH_MNT/fsstress.$$
 	count=1000
-	args="-z \
+	args=`_scale_fsstress_args -z \
 -f rmdir=10 -f link=10 -f creat=10 \
 -f mkdir=10 -f rename=30 -f unlink=10 \
 -f symlink=10 \
--n $count -d $out -p 3"
+-n $count -d $out -p 3`
 
 	echo "fsstress $args" | sed -e "s#$out#outdir#"
 	if ! $FSSTRESS_PROG $args | _filter_num
diff --git a/167 b/167
index ccb6c2a..5fb95e8 100755
--- a/167
+++ b/167
@@ -44,8 +44,9 @@ workout()
 {
 	procs=100
 	nops=15000
-	$FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n $nops $FSSTRESS_AVOID \
-		>>$seq.full &
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -p $procs -n $nops \
+	    $FSSTRESS_AVOID`
+	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seq.full &
 	sleep 2
 }
 
diff --git a/232 b/232
index 2795da7..d915d42 100755
--- a/232
+++ b/232
@@ -54,9 +54,9 @@ _fsstress()
 
 	out=$SCRATCH_MNT/fsstress.$$
 	count=2000
-	args="-n $count -d $out -p 7"
+	args=`_scale_fsstress_args -d $out -n $count -p 7`
 
-	echo "fsstress $args" | tee -a $here/$seq.full | sed -e "s#$out#outdir#"
+	echo "fsstress $args" >> tee -a $here/$seq.full
 	if ! $FSSTRESS_PROG $args | tee -a $here/$seq.full | _filter_num
 	then
 		echo "    fsstress $args returned $?"
diff --git a/232.out b/232.out
index ef82a89..5da53d4 100644
--- a/232.out
+++ b/232.out
@@ -2,7 +2,6 @@ QA output created by 232
 
 Testing fsstress
 
-fsstress -n 2000 -d outdir -p 7
 seed = S
 Comparing user usage
 Comparing group usage
diff --git a/233 b/233
index 28e6ac7..649de51 100755
--- a/233
+++ b/233
@@ -58,12 +58,12 @@ _fsstress()
 
 	out=$SCRATCH_MNT/fsstress.$$
 	count=5000
-	args="-z \
+	args=`_scale_fsstress_args -z \
 -f rmdir=20 -f link=10 -f creat=10 -f mkdir=10 -f unlink=20 -f symlink=10 \
 -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 \
--n $count -d $out -p 7"
+-n $count -d $out -p 7`
 
-	echo "fsstress $args" | tee -a $here/$seq.full | sed -e "s#$out#outdir#"
+	echo "fsstress $args" >> tee -a $here/$seq.full
 	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $here/$seq.full | _filter_num
 	then
 		echo "    fsstress $args returned $?"
diff --git a/233.out b/233.out
index fa36ca3..91c1a30 100644
--- a/233.out
+++ b/233.out
@@ -2,7 +2,6 @@ QA output created by 233
 
 Testing fsstress
 
-fsstress -z -f rmdir=20 -f link=10 -f creat=10 -f mkdir=10 -f unlink=20 -f symlink=10 -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 -n 5000 -d outdir -p 7
 seed = S
 Comparing user usage
 Comparing group usage
diff --git a/269 b/269
index 7e13ed9..7d63b87 100755
--- a/269
+++ b/269
@@ -45,7 +45,7 @@ _workout()
 	num_iterations=10
 	enospc_time=2
 	out=$SCRATCH_MNT/fsstress.$$
-	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
+	args=`_scale_fsstress_args -p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out`
 	echo "fsstress $args" >> $here/$seq.full
 	$FSSTRESS_PROG $args > /dev/null 2>&1 &
 	pid=$!
diff --git a/270 b/270
index b9ada27..b753923 100755
--- a/270
+++ b/270
@@ -48,7 +48,7 @@ _workout()
 	num_iterations=10
 	enospc_time=2
 	out=$SCRATCH_MNT/fsstress.$$
-	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
+	args=`_scale_fsstress_args -p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out`
 	echo "fsstress $args" >> $here/$seq.full
 	# Grant chown capability 
 	cp $FSSTRESS_PROG  $tmp.fsstress.bin
diff --git a/common.rc b/common.rc
index 14de47b..3635a45 100644
--- a/common.rc
+++ b/common.rc
@@ -1841,6 +1841,20 @@ _test_batched_discard()
 	$FSTRIM_PROG ${1} &>/dev/null
 }
 
+_scale_fsstress_args()
+{
+    args=""                                                                                                         
+    while [ $# -gt 0 ]; do
+        case "$1" in
+            -n) args="$args $1 $(($2 * $TIME_FACTOR))"; shift ;;
+            -p) args="$args $1 $(($2 * $LOAD_FACTOR))"; shift ;;
+            *) args="$args $1" ;;
+        esac                                                                                                    
+        shift
+    done
+    echo $args                                                                                            
+}
+  
 ################################################################################
 
 if [ "$iam" != new -a "$iam" != bench ]
diff --git a/group b/group
index 5504557..1fb2feb 100644
--- a/group
+++ b/group
@@ -137,7 +137,7 @@ stress
 014 rw udf auto quick
 015 other auto quick
 016 rw auto quick
-017 mount auto quick
+017 mount auto quick stress
 018 deprecated # log logprint v2log
 019 mkfs auto quick
 020 metadata attr udf auto quick
@@ -188,26 +188,26 @@ stress
 065 dump auto
 066 dump ioctl auto quick
 067 acl attr auto quick
-068 other auto freeze dangerous
+068 other auto freeze dangerous stress
 069 rw udf auto quick
-070 attr udf auto quick
+070 attr udf auto quick stress
 071 rw auto
 072 rw auto prealloc quick
 073 copy auto
 074 rw udf auto
 075 rw udf auto quick
-076 metadata rw udf auto quick
+076 metadata rw udf auto quick stress
 077 acl attr auto enospc
 078 growfs auto quick
 079 acl attr ioctl metadata auto quick
 080 rw ioctl
 081 deprecated # log logprint quota
 082 deprecated # log logprint v2log
-083 rw auto
+083 rw auto enospc stress
 084 ioctl rw auto
 085 log auto quick
 086 log v2log auto
-087 log v2log auto quota
+087 log v2log auto quota stress
 088 perms auto quick
 089 metadata auto
 090 rw auto
@@ -224,7 +224,7 @@ stress
 101 udf
 102 udf
 103 metadata dir ioctl auto quick
-104 growfs ioctl prealloc auto
+104 growfs ioctl prealloc auto stress
 105 acl auto quick
 106 quota
 107 quota
@@ -234,7 +234,7 @@ stress
 111 ioctl
 112 rw aio auto quick
 113 rw aio auto quick
-114 parent attr
+114 parent attr stress
 115 parent attr
 116 quota auto quick
 117 attr auto quick
@@ -287,7 +287,7 @@ stress
 164 rw pattern auto prealloc quick
 165 rw pattern auto prealloc quick
 166 rw metadata auto quick
-167 rw metadata auto
+167 rw metadata auto stress
 168 dmapi auto
 169 rw metadata auto quick
 170 rw filestreams auto quick
@@ -355,8 +355,8 @@ stress
 229 auto rw
 230 auto quota quick
 231 auto quota
-232 auto quota
-233 auto quota
+232 auto quota stress
+233 auto quota stress
 234 auto quota
 235 auto quota quick
 236 auto quick metadata
@@ -392,8 +392,8 @@ stress
 266 dump ioctl auto quick
 267 dump ioctl tape
 268 dump ioctl tape
-269 auto rw prealloc ioctl enospc
-270 auto quota rw prealloc ioctl enospc
+269 auto rw prealloc ioctl enospc stress
+270 auto quota rw prealloc ioctl enospc stress
 271 auto rw quick
 272 auto enospc rw
 273 auto rw
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
