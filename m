Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43737 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbfBRJTw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Feb 2019 04:19:52 -0500
Date: Mon, 18 Feb 2019 10:19:51 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: xfs/420 and xfs/421: don't disturb unwritten status with md5sum
Message-ID: <20190218091951.GA5171@lst.de>
References: <20190218091827.12619-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218091827.12619-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

The way we decided if an unwritten extent is considered a hole or data
is by checking if the page and/or blocks are marked uptodate, that is
contain valid data in the page cache.

xfs/420 and xfs/421 try to exercise SEEK_HOLE / SEEK_DATA in the
presence of cowextsize preallocations over holes in the data fork.  The
current XFS code never actually uses those for buffer writes, but a
pending patch changes that.  For SEEK_HOLE / SEEK_DATA to work properly
in that case we also need to look at the COW fork in their
implementations and thus have to rely on the unwritten extent page cache
probing.  But the tests for it ensure we do have valid data in the
pagecache by calling md5sum on the test files, and thus reading their
contents (including the zero-filled holes) in, and thus making them
all valid data.

Fix that by dropping the page cache content after the md5sum calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/420 | 6 ++++++
 tests/xfs/421 | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/tests/xfs/420 b/tests/xfs/420
index a083a12b..34199637 100755
--- a/tests/xfs/420
+++ b/tests/xfs/420
@@ -83,6 +83,8 @@ echo "Compare files"
 md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 md5sum $testdir/file3 | _filter_scratch
+# drop caches to make sure the page cache for the unwritten extents is clean
+echo 1 > /proc/sys/vm/drop_caches
 
 echo "CoW the shared part then write into the empty part" | tee -a $seqres.full
 $XFS_IO_PROG -c "cowextsize" $testdir/file1 >> $seqres.full
@@ -106,6 +108,8 @@ echo "Compare files"
 md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 md5sum $testdir/file3 | _filter_scratch
+# drop caches to make sure the page cache for the unwritten extents is clean
+echo 1 > /proc/sys/vm/drop_caches
 
 echo "sync filesystem" | tee -a $seqres.full
 sync
@@ -123,6 +127,8 @@ echo "Compare files"
 md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 md5sum $testdir/file3 | _filter_scratch
+# drop caches to make sure the page cache for the unwritten extents is clean
+echo 1 > /proc/sys/vm/drop_caches
 
 echo "Remount" | tee -a $seqres.full
 _scratch_cycle_mount
diff --git a/tests/xfs/421 b/tests/xfs/421
index a2734aba..374389bd 100755
--- a/tests/xfs/421
+++ b/tests/xfs/421
@@ -83,6 +83,8 @@ echo "Compare files"
 md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 md5sum $testdir/file3 | _filter_scratch
+# drop caches to make sure the page cache for the unwritten extents is clean
+echo 1 > /proc/sys/vm/drop_caches
 
 echo "CoW the shared part then write into the empty part" | tee -a $seqres.full
 $XFS_IO_PROG -c "cowextsize" $testdir/file1 >> $seqres.full
@@ -106,6 +108,8 @@ echo "Compare files"
 md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 md5sum $testdir/file3 | _filter_scratch
+# drop caches to make sure the page cache for the unwritten extents is clean
+echo 1 > /proc/sys/vm/drop_caches
 
 echo "sync filesystem" | tee -a $seqres.full
 sync
@@ -123,6 +127,8 @@ echo "Compare files"
 md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 md5sum $testdir/file3 | _filter_scratch
+# drop caches to make sure the page cache for the unwritten extents is clean
+echo 1 > /proc/sys/vm/drop_caches
 
 echo "Remount" | tee -a $seqres.full
 _scratch_cycle_mount
-- 
2.20.1
