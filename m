Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbeKEUen (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Nov 2018 15:34:43 -0500
From: fdmanana@kernel.org
Subject: [PATCH 3/3] btrfs: add new filter for file cloning error translation
Date: Mon,  5 Nov 2018 11:15:24 +0000
Message-Id: <20181105111524.11970-1-fdmanana@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>

From: Filipe Manana <fdmanana@suse.com>

A bug in file cloning/reflinking was recently found that afftected both
Btrfs and XFS, which was caused by allowing the cloning of an eof block
into the middle of a file when the eof is not aligned to the filesystem's
block size.

The fix consists of returning the errno -EINVAL to user space when the
arguments passed to the system call lead to the scenario of data
corruption. However this overlaps with some cases where the system call,
in Btrfs, returned -EOPNOTSUPP, which means we are trying to reflink
inline extents. That is unsupported in Btrfs due to the huge complexity
of supporting it (due to copying and trimming inline extents, deal with
eventual compression, etc).

We have a few btrfs test cases that verify that attempts to clone inline
extents result in a failure, and are currently expecting an -EINVAL error
message from the output of the cloner program. So create a filter that
converts error messages related to the -EOPNOTSUPP error to messages
related to the -EINVAL error, so that the test can run both on patched
and non-patched linux kernels.

The corresponding btrfs patch for the linux kernel is titled:

 "Btrfs: fix data corruption due to cloning of eof block"

And the VFS change that introduces the -EINVAL error return was introduced
by the following linux kernel commit (landed in 4.20-rc1):

 07d19dc9fbe9 ("vfs: avoid problematic remapping requests into partial EOF block")

The btrfs patch is not yet in Linus' tree (it was submitted around the
same time as this change) and the VFS change was introduced in 4.10-rc1.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 common/filter.btrfs | 17 +++++++++++++++++
 tests/btrfs/035     |  3 ++-
 tests/btrfs/035.out |  2 +-
 tests/btrfs/096     |  7 ++++---
 tests/btrfs/096.out |  2 +-
 tests/btrfs/112     | 25 +++++++++++++++++--------
 tests/btrfs/112.out | 48 ++++++++++++++++++++++++------------------------
 tests/btrfs/113     |  4 +++-
 tests/btrfs/113.out |  2 +-
 9 files changed, 70 insertions(+), 40 deletions(-)

diff --git a/common/filter.btrfs b/common/filter.btrfs
index dda85776..d4169cc6 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -97,5 +97,22 @@ _filter_btrfs_qgroup_assign_warnings()
 	    -e "/quotas may be inconsistent, rescan needed/d"
 }
 
+# Long ago we found that attempting to clone inline extents resulted in hitting
+# a BUG_ON() and then decided to not support such use cases by returning errno
+# -EOPNOTSUPP to user space. Later on, clone/reflink became a VFS API too, since
+# other filesystems (such as XFS) implemented this feature. After that we found
+# one scenario of data corruption due to allowing cloning an EOF block into the
+# middle of a file, and started to reject such scenario by returning the errno
+# -EINVAL to user space (this affected both Btrfs and XFS). Such scenario often
+# overlaps the detection of attempts to clone inline extents, since it is done
+# early on based only on the arguments passed to the clone system call (and
+# btrfs' specific ioctl) before processing the source file extents.
+# So replace error messages related to errno -EOPNOTSUPP to be the same as the
+# one we get from a -EINVAL errno.
+_filter_btrfs_cloner_error()
+{
+	sed -e "s/\(clone failed:\) Operation not supported/\1 Invalid argument/g"
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/btrfs/035 b/tests/btrfs/035
index c9c09e16..a6f67d4f 100755
--- a/tests/btrfs/035
+++ b/tests/btrfs/035
@@ -24,6 +24,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/filter.btrfs
 
 # real QA test starts here
 _supported_fs btrfs
@@ -49,7 +50,7 @@ $CLONER_PROG $SCRATCH_MNT/src $SCRATCH_MNT/src.clone2
 snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone1 | awk '{print $5}'`
 echo "attempting ioctl (src.clone1 src)"
 $CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
-	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src
+	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src | _filter_btrfs_cloner_error
 
 # The clone operation should have failed. If it did not it meant we had data
 # loss, because file "src.clone1" has an inline extent which is 10 bytes long
diff --git a/tests/btrfs/035.out b/tests/btrfs/035.out
index 3ea7d779..d810bb2b 100644
--- a/tests/btrfs/035.out
+++ b/tests/btrfs/035.out
@@ -1,6 +1,6 @@
 QA output created by 035
 attempting ioctl (src.clone1 src)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File src data after attempt to clone from src.clone1 into src:
 0000000 62 62 62 62 62 62 62 62 62 62 63 63 63 63 63 63
 0000020 63 63 63 63
diff --git a/tests/btrfs/096 b/tests/btrfs/096
index e8552947..b9188e6e 100755
--- a/tests/btrfs/096
+++ b/tests/btrfs/096
@@ -21,6 +21,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/filter.btrfs
 
 # real QA test starts here
 _supported_fs btrfs
@@ -52,11 +53,11 @@ $XFS_IO_PROG -f -s -c "pwrite -S 0xbb 0 2k" \
 # deal with in future IO operations because all inline extents are
 # supposed to start at an offset of 0, resulting in all sorts of
 # chaos.
-# So here we validate that the clone ioctl returns an EOPNOTSUPP,
-# which is what it returns for other cases dealing with inlined
+# So here we validate that the clone ioctl returns an EOPNOTSUPP or
+# EINVAL which is what it returns for other cases dealing with inlined
 # extents.
 $CLONER_PROG -s 0 -d $BLOCK_SIZE -l 2048 \
-	$SCRATCH_MNT/bar $SCRATCH_MNT/foo
+	$SCRATCH_MNT/bar $SCRATCH_MNT/foo | _filter_btrfs_cloner_error
 
 # Because of the inline extent at offset $BLOCK_SIZE, the following
 # write made the kernel crash with a BUG_ON().
diff --git a/tests/btrfs/096.out b/tests/btrfs/096.out
index 2a4251eb..2710f33e 100644
--- a/tests/btrfs/096.out
+++ b/tests/btrfs/096.out
@@ -3,5 +3,5 @@ Blocks modified: [0 - 0]
 Blocks modified: [1 - 1]
 Blocks modified: [2 - 2]
 Blocks modified: [0 - 0]
-clone failed: Operation not supported
+clone failed: Invalid argument
 Blocks modified: [1 - 1]
diff --git a/tests/btrfs/112 b/tests/btrfs/112
index 6ecb1c79..e4e9d322 100755
--- a/tests/btrfs/112
+++ b/tests/btrfs/112
@@ -23,6 +23,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/filter.btrfs
 
 # real QA test starts here
 _supported_fs btrfs
@@ -53,7 +54,8 @@ test_cloning_inline_extents()
 	# clone the inline extent from file bar into this file.
 	$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 16K" $SCRATCH_MNT/foo \
 		| _filter_xfs_io
-	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo
+	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo \
+		| _filter_btrfs_cloner_error
 
 	# Doing IO against any range in the first 4K of the file should work.
 	# Due to a past clone ioctl bug which allowed cloning the inline extent,
@@ -69,7 +71,8 @@ test_cloning_inline_extents()
 	# as well to clone the inline extent from file bar into this file.
 	$XFS_IO_PROG -f -c "pwrite -S 0xdd 4K 12K" $SCRATCH_MNT/foo2 \
 		| _filter_xfs_io
-	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo2
+	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo2 \
+		| _filter_btrfs_cloner_error
 
 	# Doing IO against any range in the first 4K of the file should work.
 	# Due to a past clone ioctl bug which allowed cloning the inline extent,
@@ -84,7 +87,8 @@ test_cloning_inline_extents()
 	# but has a prealloc extent. It should not be possible as well to clone
 	# the inline extent from file bar into this file.
 	$XFS_IO_PROG -f -c "falloc -k 0 1M" $SCRATCH_MNT/foo3 | _filter_xfs_io
-	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo3
+	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo3 \
+		| _filter_btrfs_cloner_error
 
 	# Doing IO against any range in the first 4K of the file should work.
 	# Due to a past clone ioctl bug which allowed cloning the inline extent,
@@ -101,7 +105,8 @@ test_cloning_inline_extents()
 	# It should be possible to do the extent cloning from bar to this file.
 	$XFS_IO_PROG -f -c "pwrite -S 0x01 0 40" $SCRATCH_MNT/foo4 \
 		| _filter_xfs_io
-	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo4
+	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo4 \
+		| _filter_btrfs_cloner_error
 
 	# Doing IO against any range in the first 4K of the file should work.
 	echo "File foo4 data after clone operation:"
@@ -116,7 +121,8 @@ test_cloning_inline_extents()
 	# into this file.
 	$XFS_IO_PROG -f -c "pwrite -S 0x03 0 60" $SCRATCH_MNT/foo5 \
 		| _filter_xfs_io
-	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo5
+	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo5 \
+		| _filter_btrfs_cloner_error
 
 	# Reading the file should not fail.
 	echo "File foo5 data after clone operation:"
@@ -129,7 +135,8 @@ test_cloning_inline_extents()
 	# It should not be possible to clone the inline extent from file bar
 	# into this file.
 	$XFS_IO_PROG -f -c "truncate 16K" $SCRATCH_MNT/foo6 | _filter_xfs_io
-	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo6
+	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo6 \
+		| _filter_btrfs_cloner_error
 
 	# Reading the file should not fail.
 	echo "File foo6 data after clone operation:"
@@ -142,7 +149,8 @@ test_cloning_inline_extents()
 	# It should be possible to clone the inline extent from file bar into
 	# this file.
 	$XFS_IO_PROG -f -c "truncate 30" $SCRATCH_MNT/foo7 | _filter_xfs_io
-	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo7
+	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo7 \
+		| _filter_btrfs_cloner_error
 
 	# Reading the file should not fail.
 	echo "File foo7 data after clone operation:"
@@ -156,7 +164,8 @@ test_cloning_inline_extents()
 	$XFS_IO_PROG -f -c "falloc -k 0 1M" \
 			-c "pwrite -S 0x88 0 20" \
 			$SCRATCH_MNT/foo8 | _filter_xfs_io
-	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo8
+	$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/bar $SCRATCH_MNT/foo8 \
+		| _filter_btrfs_cloner_error
 
 	echo "File foo8 data after clone operation:"
 	# Must have a size of 20 bytes, with all bytes having a value of 0x88
diff --git a/tests/btrfs/112.out b/tests/btrfs/112.out
index 23b0d097..3a95e14d 100644
--- a/tests/btrfs/112.out
+++ b/tests/btrfs/112.out
@@ -6,7 +6,7 @@ wrote 50/50 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 16384/16384 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo data after clone operation:
 0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
 *
@@ -15,7 +15,7 @@ wrote 100/100 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 12288/12288 bytes at offset 4096
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo2 data after clone operation:
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
@@ -24,7 +24,7 @@ File foo2 data after clone operation:
 0040000
 wrote 90/90 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 First 50 bytes of foo3 after clone operation:
 0000000
 wrote 90/90 bytes at offset 0
@@ -40,13 +40,13 @@ wrote 90/90 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 60/60 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo5 data after clone operation:
 0000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
 0000060 03 03 03 03 03 03 03 03 03 03 03 03
 0000074
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo6 data after clone operation:
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
@@ -58,7 +58,7 @@ File foo7 data after clone operation:
 0000062
 wrote 20/20 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo8 data after clone operation:
 0000000 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
 0000020 88 88 88 88
@@ -70,7 +70,7 @@ wrote 50/50 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 16384/16384 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo data after clone operation:
 0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
 *
@@ -79,7 +79,7 @@ wrote 100/100 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 12288/12288 bytes at offset 4096
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo2 data after clone operation:
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
@@ -88,7 +88,7 @@ File foo2 data after clone operation:
 0040000
 wrote 90/90 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 First 50 bytes of foo3 after clone operation:
 0000000
 wrote 90/90 bytes at offset 0
@@ -104,13 +104,13 @@ wrote 90/90 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 60/60 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo5 data after clone operation:
 0000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
 0000060 03 03 03 03 03 03 03 03 03 03 03 03
 0000074
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo6 data after clone operation:
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
@@ -122,7 +122,7 @@ File foo7 data after clone operation:
 0000062
 wrote 20/20 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo8 data after clone operation:
 0000000 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
 0000020 88 88 88 88
@@ -134,7 +134,7 @@ wrote 50/50 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 16384/16384 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo data after clone operation:
 0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
 *
@@ -143,7 +143,7 @@ wrote 100/100 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 12288/12288 bytes at offset 4096
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo2 data after clone operation:
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
@@ -152,7 +152,7 @@ File foo2 data after clone operation:
 0040000
 wrote 90/90 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 First 50 bytes of foo3 after clone operation:
 0000000
 wrote 90/90 bytes at offset 0
@@ -168,13 +168,13 @@ wrote 90/90 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 60/60 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo5 data after clone operation:
 0000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
 0000060 03 03 03 03 03 03 03 03 03 03 03 03
 0000074
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo6 data after clone operation:
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
@@ -186,7 +186,7 @@ File foo7 data after clone operation:
 0000062
 wrote 20/20 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo8 data after clone operation:
 0000000 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
 0000020 88 88 88 88
@@ -198,7 +198,7 @@ wrote 50/50 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 16384/16384 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo data after clone operation:
 0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
 *
@@ -207,7 +207,7 @@ wrote 100/100 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 12288/12288 bytes at offset 4096
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo2 data after clone operation:
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
@@ -216,7 +216,7 @@ File foo2 data after clone operation:
 0040000
 wrote 90/90 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 First 50 bytes of foo3 after clone operation:
 0000000
 wrote 90/90 bytes at offset 0
@@ -232,13 +232,13 @@ wrote 90/90 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 60/60 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo5 data after clone operation:
 0000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
 0000060 03 03 03 03 03 03 03 03 03 03 03 03
 0000074
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo6 data after clone operation:
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
@@ -250,7 +250,7 @@ File foo7 data after clone operation:
 0000062
 wrote 20/20 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File foo8 data after clone operation:
 0000000 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
 0000020 88 88 88 88
diff --git a/tests/btrfs/113 b/tests/btrfs/113
index 416406df..6400a7c9 100755
--- a/tests/btrfs/113
+++ b/tests/btrfs/113
@@ -25,6 +25,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/filter.btrfs
 
 # real QA test starts here
 _supported_fs btrfs
@@ -78,7 +79,8 @@ $XFS_IO_PROG -c "truncate 128" $SCRATCH_MNT/foo
 # it's normally not a very common case to clone very small files (only case
 # where we get inline extents) and copying inline extents does not save any
 # space (unlike for normal, non-inlined extents).
-$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+$CLONER_PROG -s 0 -d 0 -l 0 $SCRATCH_MNT/foo $SCRATCH_MNT/bar \
+	| _filter_btrfs_cloner_error
 
 # Now because the above clone operation used to succeed, and due to foo's inline
 # extent not being shinked by the truncate operation, our file bar got the whole
diff --git a/tests/btrfs/113.out b/tests/btrfs/113.out
index 3847b35f..ed2688db 100644
--- a/tests/btrfs/113.out
+++ b/tests/btrfs/113.out
@@ -5,7 +5,7 @@ wrote 384/384 bytes at offset 128
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 256/256 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-clone failed: Operation not supported
+clone failed: Invalid argument
 File bar's content after the clone operation:
 0000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
 *
-- 
2.11.0
