Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43613 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdDAGkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 02:40:55 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/27] xfs: fix eofblocks race with file extending async dio writes
Date: Sat,  1 Apr 2017 08:40:04 +0200
Message-Id: <20170401064026.5783-6-hch@lst.de>
In-Reply-To: <20170401064026.5783-1-hch@lst.de>
References: <20170401064026.5783-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit e4229d6b0bc9280f29624faf170cf76a9f1ca60e upstream.

It's possible for post-eof blocks to end up being used for direct I/O
writes. dio write performs an upfront unwritten extent allocation, sends
the dio and then updates the inode size (if necessary) on write
completion. If a file release occurs while a file extending dio write is
in flight, it is possible to mistake the post-eof blocks for speculative
preallocation and incorrectly truncate them from the inode. This means
that the resulting dio write completion can discover a hole and allocate
new blocks rather than perform unwritten extent conversion.

This requires a strange mix of I/O and is thus not likely to reproduce
in real world workloads. It is intermittently reproduced by generic/299.
The error manifests as an assert failure due to transaction overrun
because the aforementioned write completion transaction has only
reserved enough blocks for btree operations:

  XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, \
   file: fs/xfs//xfs_trans.c, line: 309

The root cause is that xfs_free_eofblocks() uses i_size to truncate
post-eof blocks from the inode, but async, file extending direct writes
do not update i_size until write completion, long after inode locks are
dropped. Therefore, xfs_free_eofblocks() effectively truncates the inode
to the incorrect size.

Update xfs_free_eofblocks() to serialize against dio similar to how
extending writes are serialized against i_size updates before post-eof
block zeroing. Specifically, wait on dio while under the iolock. This
ensures that dio write completions have updated i_size before post-eof
blocks are processed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d8ac76ca05a2..fd459b69161e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -959,6 +959,9 @@ xfs_free_eofblocks(
 		if (error)
 			return error;
 
+		/* wait on dio to ensure i_size has settled */
+		inode_dio_wait(VFS_I(ip));
+
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
 				&tp);
 		if (error) {
-- 
2.11.0

