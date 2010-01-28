Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0SMpLxN057147 for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 16:51:21 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA9ED1C87885
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 14:52:25 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id ySget6ugksLjFM6f for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2010 14:52:25 -0800 (PST)
Message-ID: <4B621529.20708@sandeen.net>
Date: Thu, 28 Jan 2010 16:52:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: 223 - test file alignment on stripe geometry
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

A first-cut test to ensure that files are well-aligned on filesystems
with stripe geometry.

Several sizes of stripe units are mkfs'd, and then files are written
and fallocated in various multiples of those stripe sizes.
Each file is checked to ensure that the first block is
stripe-aligned.

(Ideally, for any fragmented files, we should ensure that each
fragment start is well-aligned, but this does not do that yet)

(slightly unrelated: don't send scratch mkfs output to /dev/null)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/223 b/223
new file mode 100755
index 0000000..f679397
--- /dev/null
+++ b/223
@@ -0,0 +1,120 @@
+#! /bin/bash
+# FS QA Test No. 223
+#
+# File alignment tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Eric Sandeen.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs ext4
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_falloc
+
+rm -f $seq.full
+
+_filter_scratch()
+{
+	sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
+}
+
+BLOCKSIZE=4096
+
+scratch_mkfs_geom()
+{
+	sunit_bytes=$1
+	swidth_mult=$2
+
+	let sunit_blocks=$sunit_bytes/$BLOCKSIZE
+	let swidth_blocks=$sunit_blocks*$swidth_mult
+
+	case $FSTYP in
+	    xfs)
+		MKFS_OPTIONS="-b size=$BLOCKSIZE, -d su=$sunit_bytes,sw=$swidth_mult"
+		;;
+	    ext4)
+		MKFS_OPTIONS="-b $BLOCKSIZE -E stride=$sunit_blocks,stripe_width=$swidth_blocks"
+		;;
+	    *)
+		_notrun "can't mkfs $FSTYP with geometry"
+		;;
+	esac
+	echo "=== mkfs with su $sunit_blocks blocks x $swidth_mult ==="
+	_scratch_mkfs &>> $seq.full
+}
+
+# Emulate a 4-data-disk stripe w/ various stripe units
+
+for SUNIT_K in 8 16 32 64 128; do
+	let SUNIT_BYTES=$SUNIT_K*1024
+	let SUNIT_BLOCKS=$SUNIT_BYTES/$BLOCKSIZE
+
+	scratch_mkfs_geom $SUNIT_BYTES 4
+	_scratch_mount
+
+	for SIZE_MULT in 1 2 8 64 256; do
+		let SIZE=$SIZE_MULT*$SUNIT_BYTES
+
+		echo "=== Testing size ${SIZE_MULT}*${SUNIT_K}k on ${SUNIT_K}k stripe ==="
+		for FILE in 1 2 3 4; do
+			xfs_io -F -f -c "falloc 0 $SIZE" $SCRATCH_MNT/file-$FILE-$SIZE-falloc &>> $seq.full
+			xfs_io -F -f -c "pwrite 0 $SIZE" $SCRATCH_MNT/file-$FILE-$SIZE-write &>> $seq.full
+			src/fibmap $SCRATCH_MNT/file-$FILE-$SIZE-falloc $SUNIT_BLOCKS | \
+				_filter_scratch
+			src/fibmap $SCRATCH_MNT/file-$FILE-$SIZE-write $SUNIT_BLOCKS | \
+				_filter_scratch
+		done
+	done
+
+	echo "=== Testing size 1g falloc on ${SUNIT_K}k stripe ==="
+	xfs_io -F -f -c "falloc 0 1g" $SCRATCH_MNT/file-1g-falloc &>> $seq.full
+	src/fibmap $SCRATCH_MNT/file-1g-falloc $SUNIT_BLOCKS
+
+	rm -f $SCRATCH_MNT/file-1g-falloc | _filter_scratch
+
+	echo "=== Testing size 1073745920 falloc on ${SUNIT_K}k stripe ==="
+	xfs_io -F -f -c "falloc 0 1073745920" $SCRATCH_MNT/file-1073745920-falloc &>> $seq.full
+	src/fibmap $SCRATCH_MNT/file-1073745920-falloc $SUNIT_BLOCKS | _filter_scratch
+
+	_scratch_unmount
+done
+
+status=0 ; exit
diff --git a/223.out b/223.out
new file mode 100644
index 0000000..c9588ef
--- /dev/null
+++ b/223.out
@@ -0,0 +1,251 @@
+QA output created by 223
+=== mkfs with su 2 blocks x 4 ===
+=== Testing size 1*8k on 8k stripe ===
+SCRATCH_MNT/file-1-8192-falloc: well-aligned
+SCRATCH_MNT/file-1-8192-write: well-aligned
+SCRATCH_MNT/file-2-8192-falloc: well-aligned
+SCRATCH_MNT/file-2-8192-write: well-aligned
+SCRATCH_MNT/file-3-8192-falloc: well-aligned
+SCRATCH_MNT/file-3-8192-write: well-aligned
+SCRATCH_MNT/file-4-8192-falloc: well-aligned
+SCRATCH_MNT/file-4-8192-write: well-aligned
+=== Testing size 2*8k on 8k stripe ===
+SCRATCH_MNT/file-1-16384-falloc: well-aligned
+SCRATCH_MNT/file-1-16384-write: well-aligned
+SCRATCH_MNT/file-2-16384-falloc: well-aligned
+SCRATCH_MNT/file-2-16384-write: well-aligned
+SCRATCH_MNT/file-3-16384-falloc: well-aligned
+SCRATCH_MNT/file-3-16384-write: well-aligned
+SCRATCH_MNT/file-4-16384-falloc: well-aligned
+SCRATCH_MNT/file-4-16384-write: well-aligned
+=== Testing size 8*8k on 8k stripe ===
+SCRATCH_MNT/file-1-65536-falloc: well-aligned
+SCRATCH_MNT/file-1-65536-write: well-aligned
+SCRATCH_MNT/file-2-65536-falloc: well-aligned
+SCRATCH_MNT/file-2-65536-write: well-aligned
+SCRATCH_MNT/file-3-65536-falloc: well-aligned
+SCRATCH_MNT/file-3-65536-write: well-aligned
+SCRATCH_MNT/file-4-65536-falloc: well-aligned
+SCRATCH_MNT/file-4-65536-write: well-aligned
+=== Testing size 64*8k on 8k stripe ===
+SCRATCH_MNT/file-1-524288-falloc: well-aligned
+SCRATCH_MNT/file-1-524288-write: well-aligned
+SCRATCH_MNT/file-2-524288-falloc: well-aligned
+SCRATCH_MNT/file-2-524288-write: well-aligned
+SCRATCH_MNT/file-3-524288-falloc: well-aligned
+SCRATCH_MNT/file-3-524288-write: well-aligned
+SCRATCH_MNT/file-4-524288-falloc: well-aligned
+SCRATCH_MNT/file-4-524288-write: well-aligned
+=== Testing size 256*8k on 8k stripe ===
+SCRATCH_MNT/file-1-2097152-falloc: well-aligned
+SCRATCH_MNT/file-1-2097152-write: well-aligned
+SCRATCH_MNT/file-2-2097152-falloc: well-aligned
+SCRATCH_MNT/file-2-2097152-write: well-aligned
+SCRATCH_MNT/file-3-2097152-falloc: well-aligned
+SCRATCH_MNT/file-3-2097152-write: well-aligned
+SCRATCH_MNT/file-4-2097152-falloc: well-aligned
+SCRATCH_MNT/file-4-2097152-write: well-aligned
+=== Testing size 1g falloc on 8k stripe ===
+/mnt/scratch/file-1g-falloc: well-aligned
+=== Testing size 1073745920 falloc on 8k stripe ===
+SCRATCH_MNT/file-1073745920-falloc: well-aligned
+=== mkfs with su 4 blocks x 4 ===
+=== Testing size 1*16k on 16k stripe ===
+SCRATCH_MNT/file-1-16384-falloc: well-aligned
+SCRATCH_MNT/file-1-16384-write: well-aligned
+SCRATCH_MNT/file-2-16384-falloc: well-aligned
+SCRATCH_MNT/file-2-16384-write: well-aligned
+SCRATCH_MNT/file-3-16384-falloc: well-aligned
+SCRATCH_MNT/file-3-16384-write: well-aligned
+SCRATCH_MNT/file-4-16384-falloc: well-aligned
+SCRATCH_MNT/file-4-16384-write: well-aligned
+=== Testing size 2*16k on 16k stripe ===
+SCRATCH_MNT/file-1-32768-falloc: well-aligned
+SCRATCH_MNT/file-1-32768-write: well-aligned
+SCRATCH_MNT/file-2-32768-falloc: well-aligned
+SCRATCH_MNT/file-2-32768-write: well-aligned
+SCRATCH_MNT/file-3-32768-falloc: well-aligned
+SCRATCH_MNT/file-3-32768-write: well-aligned
+SCRATCH_MNT/file-4-32768-falloc: well-aligned
+SCRATCH_MNT/file-4-32768-write: well-aligned
+=== Testing size 8*16k on 16k stripe ===
+SCRATCH_MNT/file-1-131072-falloc: well-aligned
+SCRATCH_MNT/file-1-131072-write: well-aligned
+SCRATCH_MNT/file-2-131072-falloc: well-aligned
+SCRATCH_MNT/file-2-131072-write: well-aligned
+SCRATCH_MNT/file-3-131072-falloc: well-aligned
+SCRATCH_MNT/file-3-131072-write: well-aligned
+SCRATCH_MNT/file-4-131072-falloc: well-aligned
+SCRATCH_MNT/file-4-131072-write: well-aligned
+=== Testing size 64*16k on 16k stripe ===
+SCRATCH_MNT/file-1-1048576-falloc: well-aligned
+SCRATCH_MNT/file-1-1048576-write: well-aligned
+SCRATCH_MNT/file-2-1048576-falloc: well-aligned
+SCRATCH_MNT/file-2-1048576-write: well-aligned
+SCRATCH_MNT/file-3-1048576-falloc: well-aligned
+SCRATCH_MNT/file-3-1048576-write: well-aligned
+SCRATCH_MNT/file-4-1048576-falloc: well-aligned
+SCRATCH_MNT/file-4-1048576-write: well-aligned
+=== Testing size 256*16k on 16k stripe ===
+SCRATCH_MNT/file-1-4194304-falloc: well-aligned
+SCRATCH_MNT/file-1-4194304-write: well-aligned
+SCRATCH_MNT/file-2-4194304-falloc: well-aligned
+SCRATCH_MNT/file-2-4194304-write: well-aligned
+SCRATCH_MNT/file-3-4194304-falloc: well-aligned
+SCRATCH_MNT/file-3-4194304-write: well-aligned
+SCRATCH_MNT/file-4-4194304-falloc: well-aligned
+SCRATCH_MNT/file-4-4194304-write: well-aligned
+=== Testing size 1g falloc on 16k stripe ===
+/mnt/scratch/file-1g-falloc: well-aligned
+=== Testing size 1073745920 falloc on 16k stripe ===
+SCRATCH_MNT/file-1073745920-falloc: well-aligned
+=== mkfs with su 8 blocks x 4 ===
+=== Testing size 1*32k on 32k stripe ===
+SCRATCH_MNT/file-1-32768-falloc: well-aligned
+SCRATCH_MNT/file-1-32768-write: well-aligned
+SCRATCH_MNT/file-2-32768-falloc: well-aligned
+SCRATCH_MNT/file-2-32768-write: well-aligned
+SCRATCH_MNT/file-3-32768-falloc: well-aligned
+SCRATCH_MNT/file-3-32768-write: well-aligned
+SCRATCH_MNT/file-4-32768-falloc: well-aligned
+SCRATCH_MNT/file-4-32768-write: well-aligned
+=== Testing size 2*32k on 32k stripe ===
+SCRATCH_MNT/file-1-65536-falloc: well-aligned
+SCRATCH_MNT/file-1-65536-write: well-aligned
+SCRATCH_MNT/file-2-65536-falloc: well-aligned
+SCRATCH_MNT/file-2-65536-write: well-aligned
+SCRATCH_MNT/file-3-65536-falloc: well-aligned
+SCRATCH_MNT/file-3-65536-write: well-aligned
+SCRATCH_MNT/file-4-65536-falloc: well-aligned
+SCRATCH_MNT/file-4-65536-write: well-aligned
+=== Testing size 8*32k on 32k stripe ===
+SCRATCH_MNT/file-1-262144-falloc: well-aligned
+SCRATCH_MNT/file-1-262144-write: well-aligned
+SCRATCH_MNT/file-2-262144-falloc: well-aligned
+SCRATCH_MNT/file-2-262144-write: well-aligned
+SCRATCH_MNT/file-3-262144-falloc: well-aligned
+SCRATCH_MNT/file-3-262144-write: well-aligned
+SCRATCH_MNT/file-4-262144-falloc: well-aligned
+SCRATCH_MNT/file-4-262144-write: well-aligned
+=== Testing size 64*32k on 32k stripe ===
+SCRATCH_MNT/file-1-2097152-falloc: well-aligned
+SCRATCH_MNT/file-1-2097152-write: well-aligned
+SCRATCH_MNT/file-2-2097152-falloc: well-aligned
+SCRATCH_MNT/file-2-2097152-write: well-aligned
+SCRATCH_MNT/file-3-2097152-falloc: well-aligned
+SCRATCH_MNT/file-3-2097152-write: well-aligned
+SCRATCH_MNT/file-4-2097152-falloc: well-aligned
+SCRATCH_MNT/file-4-2097152-write: well-aligned
+=== Testing size 256*32k on 32k stripe ===
+SCRATCH_MNT/file-1-8388608-falloc: well-aligned
+SCRATCH_MNT/file-1-8388608-write: well-aligned
+SCRATCH_MNT/file-2-8388608-falloc: well-aligned
+SCRATCH_MNT/file-2-8388608-write: well-aligned
+SCRATCH_MNT/file-3-8388608-falloc: well-aligned
+SCRATCH_MNT/file-3-8388608-write: well-aligned
+SCRATCH_MNT/file-4-8388608-falloc: well-aligned
+SCRATCH_MNT/file-4-8388608-write: well-aligned
+=== Testing size 1g falloc on 32k stripe ===
+/mnt/scratch/file-1g-falloc: well-aligned
+=== Testing size 1073745920 falloc on 32k stripe ===
+SCRATCH_MNT/file-1073745920-falloc: well-aligned
+=== mkfs with su 16 blocks x 4 ===
+=== Testing size 1*64k on 64k stripe ===
+SCRATCH_MNT/file-1-65536-falloc: well-aligned
+SCRATCH_MNT/file-1-65536-write: well-aligned
+SCRATCH_MNT/file-2-65536-falloc: well-aligned
+SCRATCH_MNT/file-2-65536-write: well-aligned
+SCRATCH_MNT/file-3-65536-falloc: well-aligned
+SCRATCH_MNT/file-3-65536-write: well-aligned
+SCRATCH_MNT/file-4-65536-falloc: well-aligned
+SCRATCH_MNT/file-4-65536-write: well-aligned
+=== Testing size 2*64k on 64k stripe ===
+SCRATCH_MNT/file-1-131072-falloc: well-aligned
+SCRATCH_MNT/file-1-131072-write: well-aligned
+SCRATCH_MNT/file-2-131072-falloc: well-aligned
+SCRATCH_MNT/file-2-131072-write: well-aligned
+SCRATCH_MNT/file-3-131072-falloc: well-aligned
+SCRATCH_MNT/file-3-131072-write: well-aligned
+SCRATCH_MNT/file-4-131072-falloc: well-aligned
+SCRATCH_MNT/file-4-131072-write: well-aligned
+=== Testing size 8*64k on 64k stripe ===
+SCRATCH_MNT/file-1-524288-falloc: well-aligned
+SCRATCH_MNT/file-1-524288-write: well-aligned
+SCRATCH_MNT/file-2-524288-falloc: well-aligned
+SCRATCH_MNT/file-2-524288-write: well-aligned
+SCRATCH_MNT/file-3-524288-falloc: well-aligned
+SCRATCH_MNT/file-3-524288-write: well-aligned
+SCRATCH_MNT/file-4-524288-falloc: well-aligned
+SCRATCH_MNT/file-4-524288-write: well-aligned
+=== Testing size 64*64k on 64k stripe ===
+SCRATCH_MNT/file-1-4194304-falloc: well-aligned
+SCRATCH_MNT/file-1-4194304-write: well-aligned
+SCRATCH_MNT/file-2-4194304-falloc: well-aligned
+SCRATCH_MNT/file-2-4194304-write: well-aligned
+SCRATCH_MNT/file-3-4194304-falloc: well-aligned
+SCRATCH_MNT/file-3-4194304-write: well-aligned
+SCRATCH_MNT/file-4-4194304-falloc: well-aligned
+SCRATCH_MNT/file-4-4194304-write: well-aligned
+=== Testing size 256*64k on 64k stripe ===
+SCRATCH_MNT/file-1-16777216-falloc: well-aligned
+SCRATCH_MNT/file-1-16777216-write: well-aligned
+SCRATCH_MNT/file-2-16777216-falloc: well-aligned
+SCRATCH_MNT/file-2-16777216-write: well-aligned
+SCRATCH_MNT/file-3-16777216-falloc: well-aligned
+SCRATCH_MNT/file-3-16777216-write: well-aligned
+SCRATCH_MNT/file-4-16777216-falloc: well-aligned
+SCRATCH_MNT/file-4-16777216-write: well-aligned
+=== Testing size 1g falloc on 64k stripe ===
+/mnt/scratch/file-1g-falloc: well-aligned
+=== Testing size 1073745920 falloc on 64k stripe ===
+SCRATCH_MNT/file-1073745920-falloc: well-aligned
+=== mkfs with su 32 blocks x 4 ===
+=== Testing size 1*128k on 128k stripe ===
+SCRATCH_MNT/file-1-131072-falloc: well-aligned
+SCRATCH_MNT/file-1-131072-write: well-aligned
+SCRATCH_MNT/file-2-131072-falloc: well-aligned
+SCRATCH_MNT/file-2-131072-write: well-aligned
+SCRATCH_MNT/file-3-131072-falloc: well-aligned
+SCRATCH_MNT/file-3-131072-write: well-aligned
+SCRATCH_MNT/file-4-131072-falloc: well-aligned
+SCRATCH_MNT/file-4-131072-write: well-aligned
+=== Testing size 2*128k on 128k stripe ===
+SCRATCH_MNT/file-1-262144-falloc: well-aligned
+SCRATCH_MNT/file-1-262144-write: well-aligned
+SCRATCH_MNT/file-2-262144-falloc: well-aligned
+SCRATCH_MNT/file-2-262144-write: well-aligned
+SCRATCH_MNT/file-3-262144-falloc: well-aligned
+SCRATCH_MNT/file-3-262144-write: well-aligned
+SCRATCH_MNT/file-4-262144-falloc: well-aligned
+SCRATCH_MNT/file-4-262144-write: well-aligned
+=== Testing size 8*128k on 128k stripe ===
+SCRATCH_MNT/file-1-1048576-falloc: well-aligned
+SCRATCH_MNT/file-1-1048576-write: well-aligned
+SCRATCH_MNT/file-2-1048576-falloc: well-aligned
+SCRATCH_MNT/file-2-1048576-write: well-aligned
+SCRATCH_MNT/file-3-1048576-falloc: well-aligned
+SCRATCH_MNT/file-3-1048576-write: well-aligned
+SCRATCH_MNT/file-4-1048576-falloc: well-aligned
+SCRATCH_MNT/file-4-1048576-write: well-aligned
+=== Testing size 64*128k on 128k stripe ===
+SCRATCH_MNT/file-1-8388608-falloc: well-aligned
+SCRATCH_MNT/file-1-8388608-write: well-aligned
+SCRATCH_MNT/file-2-8388608-falloc: well-aligned
+SCRATCH_MNT/file-2-8388608-write: well-aligned
+SCRATCH_MNT/file-3-8388608-falloc: well-aligned
+SCRATCH_MNT/file-3-8388608-write: well-aligned
+SCRATCH_MNT/file-4-8388608-falloc: well-aligned
+SCRATCH_MNT/file-4-8388608-write: well-aligned
+=== Testing size 256*128k on 128k stripe ===
+SCRATCH_MNT/file-1-33554432-falloc: well-aligned
+SCRATCH_MNT/file-1-33554432-write: well-aligned
+SCRATCH_MNT/file-2-33554432-falloc: well-aligned
+SCRATCH_MNT/file-2-33554432-write: well-aligned
+SCRATCH_MNT/file-3-33554432-falloc: well-aligned
+SCRATCH_MNT/file-3-33554432-write: well-aligned
+SCRATCH_MNT/file-4-33554432-falloc: well-aligned
+SCRATCH_MNT/file-4-33554432-write: well-aligned
+=== Testing size 1g falloc on 128k stripe ===
+/mnt/scratch/file-1g-falloc: well-aligned
+=== Testing size 1073745920 falloc on 128k stripe ===
+SCRATCH_MNT/file-1073745920-falloc: well-aligned
diff --git a/common.rc b/common.rc
index 6424871..97513cc 100644
--- a/common.rc
+++ b/common.rc
@@ -292,7 +292,7 @@ _scratch_mkfs()
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
     *)
-	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
+	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
 	;;
     esac
 }
diff --git a/group b/group
index 342ac89..6b8528f 100644
--- a/group
+++ b/group
@@ -336,3 +336,4 @@ deprecated
 220 auto quota quick
 221 auto metadata quick
 222 auto fsr ioctl quick
+223 auto quick
diff --git a/src/Makefile b/src/Makefile
index baa2e94..619a752 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -14,7 +14,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
-	locktest unwritten_mmap bulkstat_unlink_test \
+	locktest unwritten_mmap bulkstat_unlink_test fibmap \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable
 
 SUBDIRS =
diff --git a/src/fibmap.c b/src/fibmap.c
new file mode 100644
index 0000000..fa005b2
--- /dev/null
+++ b/src/fibmap.c
@@ -0,0 +1,76 @@
+/*
+ * fibmap.c
+ *
+ * Print first physical block of a file, or if stripe unit is
+ * given, print whether the file start is stripe-aligned.
+ *
+ * Copyright (c) 2010 Eric Sandeen <sandeen@sandeen.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ */
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <sys/ioctl.h>
+
+#define FIBMAP          _IO(0x00, 1)    /* bmap access */
+
+/*
+ * If only filename given, print first block.
+ *
+ * If filename & sunit (in blocks) given, print whether we are well-aligned
+ */
+
+int main(int argc, char ** argv)
+{
+	int	fd;
+	int	ret;
+	int	sunit = 0;	/* in blocks */
+	char	*filename;
+	unsigned int	block = 0;
+
+        if (argc < 2) {
+                printf("Usage: %s <filename> [sunit in blocks]\n", argv[0]);
+                return 1;
+        }
+
+        filename = argv[1];
+	if (argc > 2)
+		sunit = atoi(argv[2]);
+
+        fd = open(filename, O_RDONLY);
+        if (fd < 0) {
+                perror("can't open file\n");
+                return 1;
+        }
+
+	ret = ioctl(fd, FIBMAP, &block);
+	if (ret < 0) {
+		close(fd);
+		perror("fibmap");
+		return 1;
+	}
+
+	close(fd);
+	if (sunit) {
+		if (block % sunit) {
+			printf("%s: Block %u not multiple of sunit %u\n",
+				filename, block, sunit);
+			return 1;
+		} else
+			printf("%s: well-aligned\n", filename);
+	} else
+		printf("%s: First block %u\n", filename, block);
+
+	return 0;
+}
+
+
+
+

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
