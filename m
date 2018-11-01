Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeKBIYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 04:24:21 -0400
Subject: [PATCH 2/8] xfs: force unlink metadata updates to disk
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Nov 2018 16:19:15 -0700
Message-ID: <154111435522.6577.18438780918971479613.stgit@magnolia>
In-Reply-To: <154111434286.6577.15010861884505931015.stgit@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs/318 and xfs/325 we inject errors on extent freeing then delete
some files to see if we can make the filesystem go offline.  However,
with the advent of deferred inode inactivation, sync won't guarantee
that unlinked inodes removal is actually pushed to disk since the "inode
needs to be deallocated" state is persisted to disk.  Freeze achieves
this, however, so inject a freeze/thaw cycle to make sure we hit the
injected error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/318 |    1 +
 tests/xfs/325 |    1 +
 2 files changed, 2 insertions(+)


diff --git a/tests/xfs/318 b/tests/xfs/318
index 2f2a34b0..83b858ea 100755
--- a/tests/xfs/318
+++ b/tests/xfs/318
@@ -59,6 +59,7 @@ _scratch_inject_error "free_extent"
 echo "Remove files"
 rm -rf $SCRATCH_MNT/file1
 sync
+$XFS_IO_PROG -x -c 'freeze' -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
 
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
diff --git a/tests/xfs/325 b/tests/xfs/325
index 67959015..eafb4ae0 100755
--- a/tests/xfs/325
+++ b/tests/xfs/325
@@ -62,6 +62,7 @@ _scratch_inject_error "free_extent"
 
 rm $SCRATCH_MNT/file1
 sync
+$XFS_IO_PROG -x -c 'freeze' -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
 
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
