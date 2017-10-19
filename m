Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59903 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753989AbdJSOWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:22:10 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/18] xfs: handle error if xfs_btree_get_bufs fails
Date: Thu, 19 Oct 2017 16:21:20 +0200
Message-Id: <20171019142123.18109-16-hch@lst.de>
In-Reply-To: <20171019142123.18109-1-hch@lst.de>
References: <20171019142123.18109-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Eric Sandeen <sandeen@sandeen.net>

commit 93e8befc17f6d6ea92b0aee3741ceac8bca4590f upstream.

Jason reported that a corrupted filesystem failed to replay
the log with a metadata block out of bounds warning:

XFS (dm-2): _xfs_buf_find: Block out of range: block 0x80270fff8, EOFS 0x9c40000

_xfs_buf_find() and xfs_btree_get_bufs() return NULL if
that happens, and then when xfs_alloc_fix_freelist() calls
xfs_trans_binval() on that NULL bp, we oops with:

BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8

We don't handle _xfs_buf_find errors very well, every
caller higher up the stack gets to guess at why it failed.
But we should at least handle it somehow, so return
EFSCORRUPTED here.

Reported-by: Jason L Tibbitts III <tibbs@math.uh.edu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 744dcaec34cc..f965ce832bc0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1584,6 +1584,10 @@ xfs_alloc_ag_vextent_small(
 
 				bp = xfs_btree_get_bufs(args->mp, args->tp,
 					args->agno, fbno, 0);
+				if (!bp) {
+					error = -EFSCORRUPTED;
+					goto error0;
+				}
 				xfs_trans_binval(args->tp, bp);
 			}
 			args->len = 1;
@@ -2141,6 +2145,10 @@ xfs_alloc_fix_freelist(
 		if (error)
 			goto out_agbp_relse;
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
+		if (!bp) {
+			error = -EFSCORRUPTED;
+			goto out_agbp_relse;
+		}
 		xfs_trans_binval(tp, bp);
 	}
 
-- 
2.14.2

