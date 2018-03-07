Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:37631
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751036AbeCGJTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Mar 2018 04:19:45 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1etVEc-0000rF-I1
        for linux-xfs@vger.kernel.org; Wed, 07 Mar 2018 20:19:42 +1100
Date: Wed, 7 Mar 2018 20:19:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/2] xfs: fix double ijoin in xfs_reflink_clear_inode_flag()
Message-ID: <20180307091942.GN18129@dastard>
References: <20180307091020.6186-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180307091020.6186-1-david@fromorbit.com>
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
---
 fs/xfs/xfs_reflink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6225d1ea3fdb..5cf60a042e8f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1554,7 +1554,12 @@ xfs_reflink_inode_has_shared_extents(
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
@@ -1573,7 +1578,6 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
-	xfs_trans_ijoin(*tpp, ip, 0);
 	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
 	if (error)
 		return error;
