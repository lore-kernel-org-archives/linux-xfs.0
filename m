Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGiB2Z006537 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 107623F8DC
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0yG8LcosiS6Wz1xa for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:09 -0800 (PST)
Message-Id: <20081222164409.160109000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/20] xfstests: test 194,
	test tricky mapping/conversion around holes
Content-Disposition: inline; filename=xfstests-add-corruption-test
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com

From: Eric Sandeen <sandeen@sandeen.net>                                           


Related to 
http://oss.sgi.com/bugzilla/show_bug.cgi?id=801

Latest patch posted on that bug makes this testcase pass...

(are we at 194 now?)

first 2 tests are simple buffred writ tests making sure stale
data isn't exposed, and hole-blocks aren't mapped.

2nd 2 tests are more related to the above bug, tricky testcase
uncovered by fsx on ppc64 which actually re-maps a block
which should be a hole, bringing stale data back into existence.


Reviewed-by: Christoph Hellwig <hch@lst.de>

--- /dev/null	2008-12-01 16:01:41.522110504 -0600
+++ xfs-cmds/xfstests/194	2008-12-12 13:57:13.000000000 -0600
@@ -0,0 +1,200 @@
+#! /bin/sh
+# FS QA Test No. 194
+#
+# Test mapping around/over holes for sub-page blocks
+# http://oss.sgi.com/bugzilla/show_bug.cgi?id=801
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2008 Eric Sandeen.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# only xfs supported due to use of xfs_bmap
+_supported_fs xfs
+_supported_os IRIX Linux
+
+# real QA test starts here
+rm -f $seq.full
+
+# For this test we use block size = 1/8 page size
+pgsize=`$here/src/feature -s`
+blksize=`expr $pgsize / 8`
+
+#  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
+#  0: [0..63]:         160..223          0 (160..223)          64
+#  1: [64..127]:       hole                                    64
+
+# Filter out file mountpoint and physical location info
+_filter_bmap()
+{
+    tee -a $seq.full | \
+    sed "s#$SCRATCH_MNT#SCRATCH_MNT#g" | \
+    awk --assign blksize=$blksize \
+        '$3 ~ /hole/   { print $1 "\t" $3 "\t" ($4 * 512) / blksize; next }
+         $1 ~ /^[0-9]/ { print $1 "\tblocks\t" ($6 * 512) / blksize; next }
+         	       { print $1 "\tTYPE\t" $6 }' 
+}
+
+# Filter out offsets, which vary by blocksize
+_filter_od()
+{
+    tee -a $seq.full | \
+    sed -e "s/^[0-9A-Fa-f ]\{7,8\}//"
+}
+
+_require_scratch
+unset MKFS_OPTIONS
+unset XFS_MKFS_OPTIONS
+_scratch_mkfs_xfs -b size=$blksize >/dev/null 2>&1
+_scratch_mount
+
+# 512b block / 4k page example:
+#
+#1) Write 1k of data (buffered):
+#
+# |1111|1111|
+#
+# 2) ftruncate back to 256 bytes:
+#
+# |1100|
+#
+# 3) ftruncate out to 4k: ("H" means hole (expected))
+#
+# |1100|HHHH|HHHH|HHHH|HHHH|HHHH|HHHH|HHHH|
+#
+# So we should have 1 block of data/0, 7 blocks of holes.
+#
+# 4) check what's there with a direct IO read
+#
+# In fact what I get is 1 block of data/0, 1 block of 0's, and 7 blocks of
+# garbage:
+#
+# |1100|0000|GGGG|GGGG|GGGG|GGGG|GGGG|GGGG|
+#
+# The garbage is in fact stale data from the disk. 
+#
+# Check that we don't get stale data and that the hole is a hole:
+
+echo "== Test 1 =="
+# Write, truncate in, truncate out
+xfs_io \
+-c "pwrite -S 0x11 -b `expr $pgsize / 2`  0 `expr $pgsize / 2`" \
+-c "truncate `expr $blksize / 2`" \
+-c "truncate $pgsize" \
+-t -f $SCRATCH_MNT/testfile1 >> $seq.full
+
+# directio read of entire file
+xfs_io \
+-c "pread 0 $pgsize" \
+-d $SCRATCH_MNT/testfile1 >> $seq.full
+
+xfs_bmap -v $SCRATCH_MNT/testfile1 | _filter_bmap
+od -x $SCRATCH_MNT/testfile1 | _filter_od
+
+# Similar but write another block to create block/hole/block/hole
+
+echo "== Test 2 =="
+# Write, truncate in, truncate out, write to middle
+xfs_io \
+-c "pwrite -S 0x11 -b `expr $pgsize / 2`  0 `expr $pgsize / 2`" \
+-c "truncate `expr $blksize / 2`" \
+-c "truncate $pgsize" \
+-c "pwrite -S 0x22 -b $blksize `expr $blksize \* 4` $blksize" \
+-t -f $SCRATCH_MNT/testfile2 >> $seq.full
+
+# directio read of entire file
+xfs_io \
+-c "pread 0 $pgsize" \
+-d $SCRATCH_MNT/testfile2 >> $seq.full
+
+xfs_bmap -v $SCRATCH_MNT/testfile2 | _filter_bmap
+od -x $SCRATCH_MNT/testfile2 | _filter_od
+
+# 512 byte block / 4k page example:
+
+# direct write 1 page (8 blocks) of "0x11" to 0x1000
+# map read 1 block, 512 (0x200) at 0
+# truncate to half a block, 256 (0x100)
+# truncate to block+1, 513 (0x201)
+# direct write "0x22" for 1 block at offset 2048 (0x800)
+
+# |1111|1111|1111|1111|1111|1111|1111|1111|     Write 1's
+# |MRMR|1111|1111|1111|1111|1111|1111|1111|     mapread
+# |11--|                                        truncate down
+# |1100|0---|                                   truncate up, block+1
+# |    |    |HHHH|HHHH|2222|                    Write 2's (extending)
+
+#           |uptodate?|
+# |1100|0000|1111|1111|2222|----|----|----| 	<- potential badness
+
+# We're looking for this badness due to mapping over a hole:
+# Exposes stale data from 0x400 (1024) through 0x800 (2048)
+
+# 00000000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................|
+# *
+# 00000100  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
+# *
+# 00000400  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................| <- BAD
+# *
+# 00000800  22 22 22 22 22 22 22 22  22 22 22 22 22 22 22 22  |""""""""""""""""|
+# *
+# 00000a00
+
+# We *should* get:
+# |1100|HHHH|HHHH|HHHH|2222|----|----|----|
+
+echo "== Test 3 =="
+xfs_io \
+-c "pwrite -S 0x11 -b $pgsize 0 $pgsize" \
+-c "mmap -r 0 $blksize" -c "mread 0 $blksize" -c "munmap" \
+-c "truncate `expr $blksize / 2`" \
+-c "truncate `expr $blksize + 1`" \
+-c "pwrite -S 0x22 -b $blksize `expr $pgsize / 2` $blksize" \
+-t -d -f $SCRATCH_MNT/testfile3 >> $seq.full
+
+xfs_bmap -v $SCRATCH_MNT/testfile3 | _filter_bmap
+od -x $SCRATCH_MNT/testfile3 | _filter_od
+
+# Now try the same thing but write a sector in the middle of that hole
+# If things go badly stale data will be exposed either side.
+# This is most interesting for block size > 512 (page size > 4096)
+
+# We *should* get:
+# |1100|HHHH|33HH|HHHH|2222|----|----|----|
+
+echo "== Test 4 =="
+xfs_io \
+-c "pwrite -S 0x11 -b $pgsize 0 $pgsize" \
+-c "mmap -r 0 $blksize" -c "mread 0 $blksize" -c "munmap" \
+-c "truncate `expr $blksize / 2`" \
+-c "truncate `expr $blksize + 1`" \
+-c "pwrite -S 0x22 -b $blksize `expr $pgsize / 2` $blksize" \
+-c "pwrite -S 0x33 -b 512 `expr $blksize \* 2` 512" \
+-t -d -f $SCRATCH_MNT/testfile4 >> $seq.full
+
+xfs_bmap -v $SCRATCH_MNT/testfile4 | _filter_bmap
+od -x $SCRATCH_MNT/testfile4 | _filter_od
+
+# success, all done
+status=0
+exit


--- /dev/null	2008-12-01 16:01:41.522110504 -0600
+++ xfs-cmds/xfstests/194.out	2008-12-12 13:57:14.000000000 -0600
@@ -0,0 +1,59 @@
+QA output created by 194
+== Test 1 ==
+SCRATCH_MNT/testfile1:	TYPE	
+EXT:	TYPE	TOTAL
+0:	blocks	1
+1:	hole	7
+1111 1111 1111 1111 1111 1111 1111 1111
+*
+0000 0000 0000 0000 0000 0000 0000 0000
+*
+
+== Test 2 ==
+SCRATCH_MNT/testfile2:	TYPE	
+EXT:	TYPE	TOTAL
+0:	blocks	1
+1:	hole	3
+2:	blocks	1
+3:	hole	3
+1111 1111 1111 1111 1111 1111 1111 1111
+*
+0000 0000 0000 0000 0000 0000 0000 0000
+*
+2222 2222 2222 2222 2222 2222 2222 2222
+*
+0000 0000 0000 0000 0000 0000 0000 0000
+*
+
+== Test 3 ==
+SCRATCH_MNT/testfile3:	TYPE	
+EXT:	TYPE	TOTAL
+0:	blocks	1
+1:	hole	3
+2:	blocks	1
+1111 1111 1111 1111 1111 1111 1111 1111
+*
+0000 0000 0000 0000 0000 0000 0000 0000
+*
+2222 2222 2222 2222 2222 2222 2222 2222
+*
+
+== Test 4 ==
+SCRATCH_MNT/testfile4:	TYPE	
+EXT:	TYPE	TOTAL
+0:	blocks	1
+1:	hole	1
+2:	blocks	1
+3:	hole	1
+4:	blocks	1
+1111 1111 1111 1111 1111 1111 1111 1111
+*
+0000 0000 0000 0000 0000 0000 0000 0000
+*
+3333 3333 3333 3333 3333 3333 3333 3333
+*
+0000 0000 0000 0000 0000 0000 0000 0000
+*
+2222 2222 2222 2222 2222 2222 2222 2222
+*
+



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
