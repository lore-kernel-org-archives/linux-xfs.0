Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17011 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750794AbeEaXqe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 19:46:34 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fOXGz-0004FA-La
        for linux-xfs@vger.kernel.org; Fri, 01 Jun 2018 09:46:25 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fOXGz-0008Jc-II
        for linux-xfs@vger.kernel.org; Fri, 01 Jun 2018 09:46:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix error handling in xfs_refcount_insert()
Date: Fri,  1 Jun 2018 09:46:25 +1000
Message-Id: <20180531234625.31925-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

generic/475 fired an assert failure just after the filesystem was
shut down:

XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_refcount.c, line: 182
.....
Call Trace:
 xfs_refcount_insert+0x151/0x190
 xfs_refcount_adjust_extents.constprop.11+0x9c/0x470
 xfs_refcount_adjust.constprop.10+0xb0/0x270
 xfs_refcount_finish_one+0x25a/0x420
 xfs_trans_log_finish_refcount_update+0x2a/0x40
 xfs_refcount_update_finish_item+0x35/0xa0
 xfs_defer_finish+0x15e/0x4d0
 xfs_reflink_remap_extent+0x1bc/0x610
 xfs_reflink_remap_blocks+0x6e/0x280
 xfs_reflink_remap_range+0x311/0x530
 vfs_clone_file_range+0x119/0x200
 ....

If xfs_btree_insert() returns an error, the corruption check fires
instead of passing the error back the caller. The corruption check
should be after we've checked for an error, not before, thereby
avoiding assert failures if the filesystem shuts down during a
refcount btree record insert.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ae07a85d9bd5..235a9cf7265f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -165,7 +165,10 @@ xfs_refcount_insert(
 	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
 	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
 	error = xfs_btree_insert(cur, i);
+	if (error)
+		goto out_error;
 	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, *i == 1, out_error);
+
 out_error:
 	if (error)
 		trace_xfs_refcount_insert_error(cur->bc_mp,
-- 
2.17.0

