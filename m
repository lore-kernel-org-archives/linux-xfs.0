Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B5DF329E06
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 08:36:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D685304039
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:36:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h7eEUmoz1mCBdia8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:36:25 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id C0CCF486D7
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 14:36:24 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-22.bos.redhat.com [10.18.41.22])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u1TEaOc8001438
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 09:36:24 -0500
Date: Mon, 29 Feb 2016 09:36:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/3] fix up indlen reservations on extent split
Message-ID: <20160229143621.GA47880@bfoster.bfoster>
References: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 29, 2016 at 09:29:27AM -0500, Brian Foster wrote:
> Hi all,
> 
> This is a resurrection of an old fix for the indirect delalloc
> reservation split problem. The last version apparently fell through the
> cracks. The core problem and fix is the same and is described in patch
> 3.
> 
> The original problem is not as reproducible as it was since the last
> version of this patch. The original zero range reproducer doesn't work
> because zero range has since been updated to flush and invalidate the
> affected range rather than kill any delayed allocation blocks in the in
> core extent tree. The side effect of this is that the problem does not
> currently have a clear reproducer, but the indirect reservation
> management code is still incorrect nonetheless.
> 
> As a result, I've prepended an RFC test instrumentation patch that can
> help induce the problem[1]. I've marked the patch RFC simply because it
> is hacky and probably up in the air as to whether it is merge worthy. I
> wanted to have _something_ to help reproduce the problem and verify the
> fix, however, hence it is included here. I'm fine with either merging it
> or using it as a one-off verification and dropping it. Also, any other
> ideas for a more simple/elegant reproducer are welcome.
> 
> Thoughts, reviews, flames appreciated.
> 
> Brian
> 
> [1] An update to the original xfstests test is also required. I'll send
> that update in a reply to this cover letter shortly.
> 

Attached are a couple patches to update the test as described here. I'm
sending them as attachments because they aren't worth reviewing unless
patch 1/3 is merged as is. I'll send the test updates separately
(properly) depending on what results on the kernel side of things. In
the meantime, these are useful to demonstrate the problem on a current
kernel and test the fix.

Brian

> v2:
> - Rebase to latest for-next branch.
> - Include RFC test instrumentation patch.
> v1: http://oss.sgi.com/archives/xfs/2014-10/msg00294.html
> - xfs_bunmapi() code into independent patch.
> - Refactor fix into separate helper function.
> rfc: http://oss.sgi.com/archives/xfs/2014-09/msg00337.html
> 
> Brian Foster (3):
>   xfs: debug mode forced buffered write failure
>   xfs: update icsb freeblocks counter after extent deletion
>   xfs: borrow indirect blocks from freed extent when available
> 
>  fs/xfs/libxfs/xfs_bmap.c | 158 ++++++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_aops.c        |   9 ++-
>  fs/xfs/xfs_mount.h       |   9 +++
>  fs/xfs/xfs_sysfs.c       |  78 ++++++++++++++++++++---
>  4 files changed, 200 insertions(+), 54 deletions(-)
> 
> -- 
> 2.4.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-xfstests-move-generic-indlen-reservation-test-to-xfs.patch"

>From ecb696160da6b38288ca7a339c2c386bf4955fba Mon Sep 17 00:00:00 2001
From: Brian Foster <bfoster@redhat.com>
Date: Mon, 29 Feb 2016 09:00:36 -0500
Subject: [PATCH 1/2] xfstests: move generic indlen reservation test to xfs dir

This test was originally designed to reproduce the split indlen
reservation depletion problem in XFS. It was included as a generic test
simply because it had no hard dependencies on XFS or associated tools.

This test is no longer effective in its current form. Fixing it requires
use of XFS specific mechanisms. Therefore, move the test to the XFS
specific test directory. No other changes are made in this patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/033     | 84 ---------------------------------------------------
 tests/generic/033.out |  4 ---
 tests/generic/group   |  1 -
 tests/xfs/289         | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/289.out     |  4 +++
 tests/xfs/group       |  1 +
 6 files changed, 89 insertions(+), 89 deletions(-)
 delete mode 100755 tests/generic/033
 delete mode 100644 tests/generic/033.out
 create mode 100755 tests/xfs/289
 create mode 100644 tests/xfs/289.out

diff --git a/tests/generic/033 b/tests/generic/033
deleted file mode 100755
index 4f8bb92..0000000
--- a/tests/generic/033
+++ /dev/null
@@ -1,84 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 033
-#
-# This test stresses indirect block reservation for delayed allocation extents.
-# XFS reserves extra blocks for deferred allocation of delalloc extents. These
-# reserved blocks can be divided among more extents than anticipated if the
-# original extent for which the blocks were reserved is split into multiple
-# delalloc extents. If this scenario repeats, eventually some extents are left
-# without any indirect block reservation whatsoever. This leads to assert
-# failures and possibly other problems in XFS.
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-	cd /
-	rm -f $tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-
-# real QA test starts here
-rm -f $seqres.full
-
-# Modify as appropriate.
-_supported_fs generic
-_supported_os Linux
-_require_scratch
-_require_xfs_io_command "fzero"
-
-_scratch_mkfs >/dev/null 2>&1
-_scratch_mount
-
-file=$SCRATCH_MNT/file.$seq
-bytes=$((64 * 1024))
-
-# create sequential delayed allocation
-$XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
-
-# Zero every other 4k range to split the larger delalloc extent into many more
-# smaller extents. Use zero instead of hole punch because the former does not
-# force writeback (and hence delalloc conversion). It can simply discard
-# delalloc blocks and convert the ranges to unwritten.
-endoff=$((bytes - 4096))
-for i in $(seq 0 8192 $endoff); do
-	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
-done
-
-# now zero the opposite set to remove remaining delalloc extents
-for i in $(seq 4096 8192 $endoff); do
-	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
-done
-
-_scratch_cycle_mount
-hexdump $file
-
-status=0
-exit
diff --git a/tests/generic/033.out b/tests/generic/033.out
deleted file mode 100644
index 419d831..0000000
--- a/tests/generic/033.out
+++ /dev/null
@@ -1,4 +0,0 @@
-QA output created by 033
-0000000 0000 0000 0000 0000 0000 0000 0000 0000
-*
-0010000
diff --git a/tests/generic/group b/tests/generic/group
index 727648c..47638c3 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -35,7 +35,6 @@
 030 auto quick rw
 031 auto quick prealloc rw
 032 auto quick rw
-033 auto quick rw
 034 auto quick metadata log
 035 auto quick
 036 auto aio rw stress
diff --git a/tests/xfs/289 b/tests/xfs/289
new file mode 100755
index 0000000..33cf060
--- /dev/null
+++ b/tests/xfs/289
@@ -0,0 +1,84 @@
+#! /bin/bash
+# FS QA Test No. 289
+#
+# This test stresses indirect block reservation for delayed allocation extents.
+# XFS reserves extra blocks for deferred allocation of delalloc extents. These
+# reserved blocks can be divided among more extents than anticipated if the
+# original extent for which the blocks were reserved is split into multiple
+# delalloc extents. If this scenario repeats, eventually some extents are left
+# without any indirect block reservation whatsoever. This leads to assert
+# failures and possibly other problems in XFS.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "fzero"
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+file=$SCRATCH_MNT/file.$seq
+bytes=$((64 * 1024))
+
+# create sequential delayed allocation
+$XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
+
+# Zero every other 4k range to split the larger delalloc extent into many more
+# smaller extents. Use zero instead of hole punch because the former does not
+# force writeback (and hence delalloc conversion). It can simply discard
+# delalloc blocks and convert the ranges to unwritten.
+endoff=$((bytes - 4096))
+for i in $(seq 0 8192 $endoff); do
+	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+done
+
+# now zero the opposite set to remove remaining delalloc extents
+for i in $(seq 4096 8192 $endoff); do
+	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+done
+
+_scratch_cycle_mount
+hexdump $file
+
+status=0
+exit
diff --git a/tests/xfs/289.out b/tests/xfs/289.out
new file mode 100644
index 0000000..bdcf195
--- /dev/null
+++ b/tests/xfs/289.out
@@ -0,0 +1,4 @@
+QA output created by 289
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0010000
diff --git a/tests/xfs/group b/tests/xfs/group
index e0c4553..b4cc1c0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -269,6 +269,7 @@
 282 dump ioctl auto quick
 283 dump ioctl auto quick
 287 auto dump quota quick
+289 auto quick rw
 290 auto rw prealloc quick ioctl
 291 auto repair
 292 auto mkfs quick
-- 
2.4.3


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-tests-xfs-update-indlen-res.-test-to-use-fail-writes.patch"

>From 82ca2acf976736b5dc638d6a5ab31a82a76364ae Mon Sep 17 00:00:00 2001
From: Brian Foster <bfoster@redhat.com>
Date: Mon, 29 Feb 2016 09:04:25 -0500
Subject: [PATCH 2/2] tests/xfs: update indlen res. test to use fail writes
 mechanism

This test originally used zero range operations to reproduce problematic
indirect delalloc reservations on XFS. Zero range has since been updated
such that it cannot be used to reproduce the problem. Instead, a
buffered write failure mechanism has been added to XFS to facilitate
reproducing this problem.

Update the test to use the buffered write failure mechanism to split
delalloc extents and reproduce the original indlen reservation problem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/289     | 28 +++++++++++++++++++---------
 tests/xfs/289.out |  4 +---
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tests/xfs/289 b/tests/xfs/289
index 33cf060..5da332b 100755
--- a/tests/xfs/289
+++ b/tests/xfs/289
@@ -44,6 +44,7 @@ _cleanup()
 
 # get standard environment, filters and checks
 . ./common/rc
+. ./common/punch
 
 # real QA test starts here
 rm -f $seqres.full
@@ -52,33 +53,42 @@ rm -f $seqres.full
 _supported_fs generic
 _supported_os Linux
 _require_scratch
-_require_xfs_io_command "fzero"
+_require_xfs_sysfs $(_short_dev $TEST_DEV)/fail_writes
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
+sdev=$(_short_dev $SCRATCH_DEV)
 file=$SCRATCH_MNT/file.$seq
 bytes=$((64 * 1024))
 
 # create sequential delayed allocation
 $XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
 
-# Zero every other 4k range to split the larger delalloc extent into many more
-# smaller extents. Use zero instead of hole punch because the former does not
-# force writeback (and hence delalloc conversion). It can simply discard
-# delalloc blocks and convert the ranges to unwritten.
+# Enable write failures. All buffered writes fail from this point on.
+echo 1 > /sys/fs/xfs/$sdev/fail_writes
+
+# Write every other 4k range to split the larger delalloc extent into many more
+# smaller extents. Use pwrite because with write failures enabled, all
+# preexisting delalloc blocks in the range of the I/O are tossed without
+# discretion. This allows manipulation of the delalloc extent without conversion
+# to real blocks (and thus releasing the indirect reservation).
 endoff=$((bytes - 4096))
 for i in $(seq 0 8192 $endoff); do
-	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "pwrite $i 4k" $file >> $seqres.full 2>&1
 done
 
-# now zero the opposite set to remove remaining delalloc extents
+# now pwrite the opposite set to remove remaining delalloc extents
 for i in $(seq 4096 8192 $endoff); do
-	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "pwrite $i 4k" $file >> $seqres.full 2>&1
 done
 
+echo 0 > /sys/fs/xfs/$sdev/fail_writes
+
+echo "Silence is golden."
+
 _scratch_cycle_mount
-hexdump $file
+$XFS_IO_PROG -c 'bmap -vp' $file | _filter_bmap
 
 status=0
 exit
diff --git a/tests/xfs/289.out b/tests/xfs/289.out
index bdcf195..72e60f9 100644
--- a/tests/xfs/289.out
+++ b/tests/xfs/289.out
@@ -1,4 +1,2 @@
 QA output created by 289
-0000000 0000 0000 0000 0000 0000 0000 0000 0000
-*
-0010000
+Silence is golden.
-- 
2.4.3


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--5/uDoXvLw7AC5HRs--
