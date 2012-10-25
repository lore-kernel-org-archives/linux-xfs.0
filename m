Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PHHgKX132902 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 12:17:42 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UVZOuXGRx9loVkEU for
	<xfs@oss.sgi.com>; Thu, 25 Oct 2012 10:19:26 -0700 (PDT)
Message-ID: <5089749C.4050003@redhat.com>
Date: Thu, 25 Oct 2012 12:19:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: test ext4 statfs
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
To: xfs-oss <xfs@oss.sgi.com>, ext4 development <linux-ext4@vger.kernel.org>

Calculating free blocks in ext[234] is surprisingly hard, since
by default we report "bsd" style df which doesn't count filesystem
"overhead" blocks as used.

With a lot of code dedicated to sorting out what to report as
free, things tend to go wrong surprisingly often.

Here's a test to actually try to stop the next regression.  ;)

NB: For bsddf, the kernel currently does not count journal blocks
as overhead; it probably should.  But the test below looks to have
the result within 1% of perfection, so it still passes even if
the kernel doesn't count the journal against free blocks.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/289 b/289
new file mode 100755
index 0000000..bf0e897
--- /dev/null
+++ b/289
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 286
+#
+# Test overhead & df output for extN filesystems
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
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
+#-----------------------------------------------------------------------
+#
+# creator
+owner=sandeen@redhat.com
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
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs ext2 ext3 ext4
+_supported_os Linux
+_require_scratch
+
+rm -f $seq.full
+
+_scratch_mkfs >> $seq.full 2>&1
+
+# Get the honest truth about block counts straight from metadata on disk
+TOTAL_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
+		| awk '/Block count:/{print $3}'`
+
+FREE_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
+		| awk '/Free blocks:/{print $3}'`
+
+# nb: kernels today don't count journal blocks  as overhead, but should.
+# For most filesystems this will still be within tolerance.
+# Overhead is all the blocks (already) used by the fs itself:
+OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS))
+
+#  bsddf|minixdf
+#         Set the behaviour  for  the  statfs  system  call.  The  minixdf
+#         behaviour is to return in the f_blocks field the total number of
+#         blocks of the filesystem, while the bsddf  behaviour  (which  is
+#         the default) is to subtract the overhead blocks used by the ext2
+#         filesystem and not available for file storage.
+
+# stat -f output looks like this; we get f_blocks from that, which
+# varies depending on the df mount options used below:
+
+#   File: "/mnt/test"
+#    ID: affc5f2b2f57652 Namelen: 255     Type: ext2/ext3
+# Block size: 4096       Fundamental block size: 4096
+# Blocks: Total: 5162741    Free: 5118725    Available: 4856465
+# Inodes: Total: 1313760    Free: 1313749
+
+_scratch_mount "-o minixdf"
+MINIX_F_BLOCKS=`stat -f $SCRATCH_MNT | awk '/^Blocks/{print $3}'`
+umount $SCRATCH_MNT
+
+_scratch_mount "-o bsddf"
+BSD_F_BLOCKS=`stat -f $SCRATCH_MNT | awk '/^Blocks/{print $3}'`
+umount $SCRATCH_MNT
+
+# Echo data to $seq.full for analysis
+echo "Overhead is $OVERHEAD blocks out of $TOTAL_BLOCKS ($FREE_BLOCKS free)" >> $seq.full
+echo "MINIX free blocks $MINIX_F_BLOCKS" >> $seq.full
+echo "BSD free blocks $BSD_F_BLOCKS" >> $seq.full
+
+# minix should be exactly equal (hence tolerance of 0)
+_within_tolerance "minix f_blocks" $MINIX_F_BLOCKS $TOTAL_BLOCKS 0 -v
+# bsd should be within ... we'll say 1% for some slop
+_within_tolerance "bsd f_blocks" $BSD_F_BLOCKS $(($TOTAL_BLOCKS-$OVERHEAD)) 1% -v
+
+# success, all done
+status=0
+exit
diff --git a/289.out b/289.out
new file mode 100644
index 0000000..a4de760
--- /dev/null
+++ b/289.out
@@ -0,0 +1,3 @@
+QA output created by 289
+minix f_blocks is in range
+bsd f_blocks is in range
diff --git a/group b/group
index fb0f8eb..a846b60 100644
--- a/group
+++ b/group
@@ -407,3 +407,4 @@ deprecated
 286 other
 287 auto dump quota quick
 288 auto quick ioctl trim
+289 auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
