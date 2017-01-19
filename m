Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754213AbdASTAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jan 2017 14:00:13 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 619EE85545
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2017 19:00:14 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0JJ0EEp014673
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2017 14:00:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/3] xfs: fix eofblocks race with file extending async dio writes
Date: Thu, 19 Jan 2017 14:00:11 -0500
Message-Id: <1484852411-1137-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1484852411-1137-1-git-send-email-bfoster@redhat.com>
References: <1484852411-1137-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

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
---
 fs/xfs/xfs_bmap_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 81fac29..8170e30 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -951,6 +951,9 @@ xfs_free_eofblocks(
 		if (error)
 			return error;
 
+		/* wait on dio to ensure i_size has settled */
+		inode_dio_wait(VFS_I(ip));
+
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
 				&tp);
 		if (error) {
-- 
2.7.4

