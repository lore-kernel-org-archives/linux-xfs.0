Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937654AbdAKRmw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 12:42:52 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDFB2C04D2EC
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 17:42:52 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0BHgqOG000976
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 12:42:52 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix eofblocks race with file extending async dio writes
Date: Wed, 11 Jan 2017 12:42:51 -0500
Message-Id: <1484156571-65403-1-git-send-email-bfoster@redhat.com>
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

Update xfs_free_eoflbocks() to serialize against dio similar to how
extending writes are serialized against i_size updates before post-eof
block zeroing. Specifically, wait on dio once the iolock is acquired.
This ensures that dio write completions have updated i_size before
post-eof blocks are processed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b9abce5..5844549 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -936,6 +936,10 @@ xfs_free_eofblocks(
 	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
+	/*
+	 * If there are blocks after the end of file, truncate the file to its
+	 * current size to free them up.
+	 */
 	if (!error && (nimaps != 0) &&
 	    (imap.br_startblock != HOLESTARTBLOCK ||
 	     ip->i_delayed_blks)) {
@@ -947,14 +951,14 @@ xfs_free_eofblocks(
 			return error;
 
 		/*
-		 * There are blocks after the end of file.
-		 * Free them up now by truncating the file to
-		 * its current size.
+		 * Grab the iolock if the caller hasn't done so and wait on
+		 * direct I/O to ensure i_size has settled.
 		 */
 		if (need_iolock) {
 			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
 				return -EAGAIN;
 		}
+		inode_dio_wait(VFS_I(ip));
 
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
 				&tp);
-- 
2.7.4

