Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:29054 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754217AbeEHDmO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 23:42:14 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVt-0002Km-4M
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:05 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVt-0002i0-3V
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] xfs: fix double ijoin in xfs_reflink_clear_inode_flag()
Date: Tue,  8 May 2018 13:42:00 +1000
Message-Id: <20180508034202.10136-8-david@fromorbit.com>
In-Reply-To: <20180508034202.10136-1-david@fromorbit.com>
References: <20180508034202.10136-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Another assert failure:

XFS: Assertion failed: !(lip->li_flags & XFS_LI_TRANS), file: fs/xfs/xfs_trans.c, line: 740
....
xfs_trans_add_item+0xcc/0xe0
xfs_reflink_clear_inode_flag+0x53/0x120
xfs_reflink_try_clear_inode_flag+0x5b/0xa0
? filemap_write_and_wait+0x4f/0x70
xfs_reflink_unshare+0x18e/0x19d
xfs_file_fallocate+0x241/0x310
? selinux_file_permission+0xd4/0x140
vfs_fallocate+0x13d/0x260
SyS_fallocate+0x43/0x80

Another fix.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index bce2b5351d64..12d441a73b53 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1553,7 +1553,12 @@ xfs_reflink_inode_has_shared_extents(
 	return 0;
 }
 
-/* Clear the inode reflink flag if there are no shared extents. */
+/*
+ * Clear the inode reflink flag if there are no shared extents.
+ *
+ * The caller is responsible for joining the inode to the transaction passed in.
+ * The inode will be joined to the transaction that is returned to the caller.
+ */
 int
 xfs_reflink_clear_inode_flag(
 	struct xfs_inode	*ip,
@@ -1572,7 +1577,6 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
-	xfs_trans_ijoin(*tpp, ip, 0);
 	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
 	if (error)
 		return error;
-- 
2.17.0

