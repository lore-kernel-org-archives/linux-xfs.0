Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8SJdkKG144487 for <xfs@oss.sgi.com>; Mon, 28 Sep 2009 14:39:46 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBD14B94F5B
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2009 12:41:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kTJCbGGODZK1RweI for
	<xfs@oss.sgi.com>; Mon, 28 Sep 2009 12:41:06 -0700 (PDT)
Message-ID: <4AC1114C.2070802@redhat.com>
Date: Mon, 28 Sep 2009 14:41:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: enable generic filesystems on some ENOSPC tests
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, ext4 development <linux-ext4@vger.kernel.org>

Make tests 083, 109, and 204 generic.

This adds a new _scratch_mkfs_sized which can create a filesystem
of a specific size (and optionally with a specific blocksize), which
lets the various small-filesystem ENOSPC tests run.

It also adds an "enospc" group which seemed useful to me.

There are still xfs filesystem specific calls in some of these
tests; they specified an agcount and that doesn't translate into
something generic, so left it there for now.

Right now 083 fails on ext4 with fileystem corruption, and
204 fails due to ENOSPC apparently not flushing delalloc/prealloc, which
leads to premature ENOSPC (after the test completes, 38M is free again
after a manual sync).

test 205 is too xfs-geometry-specific to be generic; it carefully
calculates freespace of a very specific xfs geometry.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/083 b/083
index a61aa66..49598f7 100755
--- a/083
+++ b/083
@@ -54,7 +54,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
@@ -70,10 +70,15 @@ workout()
 	nops=$4
 
 	umount $SCRATCH_DEV >/dev/null 2>&1
-	echo "*** mkfs -dsize=$fsz,agcount=$ags"    >>$seq.full
-	echo ""                                     >>$seq.full
-	_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seq.full 2>&1 \
-		|| _fail "size=$fsz,agcount=$ags mkfs failed"
+	if [ "$FSTYP" == "xfs" ]; then
+		echo "*** mkfs -dsize=$fsz,agcount=$ags"    >>$seq.full
+		echo ""                                     >>$seq.full
+		_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seq.full 2>&1 \
+			|| _fail "size=$fsz,agcount=$ags mkfs failed"
+	else
+		_scratch_mkfs_sized $fsz                    >>$seq.full 2>&1 \
+			|| _fail "size=$fsz mkfs failed"
+	fi
 	_scratch_mount                              >>$seq.full 2>&1 \
 		|| _fail "mount failed"
 
@@ -85,12 +90,13 @@ workout()
 
 echo "*** test out-of-space handling for random write operations"
 
-filesize=100m
+# 100m
+let fssize=100*1024*1024
 agcount=6
 numprocs=15
 numops=1500
 
-workout $filesize $agcount $numprocs $numops
+workout $fssize $agcount $numprocs $numops
 
 echo "*** done"
 status=0
diff --git a/109 b/109
index 1ec25ea..6d6a0f3 100755
--- a/109
+++ b/109
@@ -3,6 +3,8 @@
 #
 # ENOSPC deadlock case from Asano Masahiro.
 #
+# Originally for xfs, expanded to test ENOSPC on other filesystems
+#
 #-----------------------------------------------------------------------
 # Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -37,7 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux XFS
 _require_scratch
 
@@ -51,7 +53,7 @@ populate()
 	i=0
 	while [ $i -le $files -a "X$faststart" = "X" ]; do
 		file=$SCRATCH_MNT/f$i
-		xfs_io -f -d -c 'pwrite -b 64k 0 64k' $file >/dev/null
+		xfs_io -F -f -d -c 'pwrite -b 64k 0 64k' $file >/dev/null
 		let i=$i+1
 	done
 
@@ -78,7 +80,7 @@ allocate()
 		{
 			j=0
 			while [ $j -lt 100 ]; do
-				xfs_io -f -c 'pwrite -b 64k 0 16m' $file \
+				xfs_io -F -f -c 'pwrite -b 64k 0 16m' $file \
 					>/dev/null 2>&1
 				rm $file
 				let j=$j+1
@@ -97,13 +99,21 @@ _scratch_mount
 
 # see if faststart is possible (and requested)
 files=2000
+# 160m
+let fssize=160*1024*1024
+
 faststart=""
 if [ -n "$FASTSTART" -a -f $SCRATCH_MNT/f0 ]; then
 	faststart="-N"	# causes us to skip the mkfs step
 fi
 umount $SCRATCH_DEV
 
-_scratch_mkfs_xfs -dsize=160m,agcount=4 $faststart | _filter_mkfs 2>$tmp.mkfs
+if [ "$FSTYP" == "xfs" ]; then
+	_scratch_mkfs_xfs -dsize=$fssize,agcount=4 $faststart 2>$tmp.mkfs
+else
+	_scratch_mkfs_sized $fssize 2>$tmp.mkfs
+fi
+
 cat $tmp.mkfs >>$seq.full
 _scratch_mount
 
diff --git a/109.out b/109.out
index 7041e6d..8ee825f 100644
--- a/109.out
+++ b/109.out
@@ -1,10 +1,4 @@
 QA output created by 109
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 creating small files...
 removing small files...
 flushing changes via umount/mount.
diff --git a/204 b/204
index 8c4e91e..071bbe7 100755
--- a/204
+++ b/204
@@ -35,12 +35,14 @@ status=1	# failure is the default!
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _require_scratch
 
-_scratch_mkfs_xfs -d size=104m >/dev/null
+let fssize=104*1024*1024
+
+_scratch_mkfs_sized $fssize >/dev/null
 _scratch_mount
 
 for i in `seq 1 22500`; do
diff --git a/common.rc b/common.rc
index 761170d..47c0839 100644
--- a/common.rc
+++ b/common.rc
@@ -237,6 +237,27 @@ _scratch_mkfs_options()
     echo $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV
 }
 
+# arg 1 is size in bytes, arg 2 is (optional) blocksize
+_scratch_mkfs_sized()
+{
+    fssz=$1
+    bsz=$2
+    [ -z "$bsz" ] && bsz=4096
+    let blocks=$fssz/$bsz
+
+    case $FSTYP in
+    xfs)
+        _scratch_mkfs_xfs -d size=$fssz -b size=$bsz
+	;;
+    ext2|ext3|ext4)
+	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS -b $bsz $SCRATCH_DEV $blocks > /dev/null
+	;;
+    *)
+	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
+	;;
+    esac
+}
+
 _scratch_mkfs_xfs()
 {
     # extra mkfs options can be added by tests
diff --git a/group b/group
index 7cea01d..8647d89 100644
--- a/group
+++ b/group
@@ -189,7 +189,7 @@ prealloc
 080 rw ioctl
 081 log logprint quota auto quick
 082 log logprint v2log auto quick
-083 rw auto
+083 rw enospc auto
 084 ioctl rw auto
 085 log auto quick
 086 log v2log auto
@@ -215,7 +215,7 @@ prealloc
 106 quota
 107 quota
 108 quota
-109 metadata auto
+109 metadata enospc auto
 110 repair auto
 111 ioctl
 112 rw aio auto quick
@@ -280,7 +280,7 @@ prealloc
 # the next three tests are not deterministic enough to get the
 # "right" result on all platforms/configuration, so don't run
 # them by default.
-171 rw filestreams
+171 rw filestreams enospc
 172 rw filestreams
 173 rw filestreams
 174 rw filestreams auto
@@ -313,8 +313,8 @@ prealloc
 201 metadata auto quick
 202 repair auto quick
 203 ioctl auto
-204 metadata rw auto
-205 metadata rw auto
+204 metadata rw enospc auto
+205 metadata rw enospc auto
 206 growfs auto quick
 207 auto aio quick
 208 auto aio

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
