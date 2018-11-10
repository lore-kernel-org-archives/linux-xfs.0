Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35942 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729060AbeKJVgt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 16:36:49 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] xfs/420: only check the extent layout after syncing
Date: Sat, 10 Nov 2018 12:51:45 +0100
Message-Id: <20181110115145.30356-6-hch@lst.de>
In-Reply-To: <20181110115145.30356-1-hch@lst.de>
References: <20181110115145.30356-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

This tests validates the correct extent layout for some hairy reflink
related issues.  But until we called sync or fsync we have no gurantee
of any data fork layout, as only writeback moves the extents from the
COW for to the data fork.

Without this we'll see an error if we use COW fork speculative
preallocations for non-overwrites, which is useful to reduce
fragmentation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/420 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/xfs/420 b/tests/xfs/420
index a083a12b..aea95c7b 100755
--- a/tests/xfs/420
+++ b/tests/xfs/420
@@ -93,6 +93,8 @@ $XFS_IO_PROG -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file2 >> $seqres
 $XFS_IO_PROG -c "pwrite -S 0x63 0 $blksz" $testdir/file3 >> $seqres.full
 $XFS_IO_PROG -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file3 >> $seqres.full
 
+sync
+
 $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
 $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
 $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
-- 
2.19.1
