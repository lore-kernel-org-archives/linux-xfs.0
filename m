Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41716 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751189AbeCGJK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Mar 2018 04:10:27 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1etV5b-0000q6-7u
        for linux-xfs@vger.kernel.org; Wed, 07 Mar 2018 20:10:23 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1etV5b-0001eU-6l
        for linux-xfs@vger.kernel.org; Wed, 07 Mar 2018 20:10:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: fix double ijoin in xfs_reflink_cancel_cow_range
Date: Wed,  7 Mar 2018 20:10:20 +1100
Message-Id: <20180307091020.6186-3-david@fromorbit.com>
In-Reply-To: <20180307091020.6186-1-david@fromorbit.com>
References: <20180307091020.6186-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

AN inode is joined to teh same transaction twice in
xfs_reflink_cancel_cow_range() resulting in the following assert
failure:

[   30.180485] XFS: Assertion failed: !(lip->li_flags & XFS_LI_TRANS), file: fs/xfs/xfs_trans.c, line: 740
[   30.183435] ------------[ cut here ]------------
......
[   30.209264] Call Trace:
[   30.209935]  xfs_trans_add_item+0xcc/0xe0
[   30.210968]  xfs_reflink_cancel_cow_blocks+0xab/0x290
[   30.212249]  ? xfs_trans_reserve+0x1b4/0x2b0
[   30.213320]  ? kmem_zone_alloc+0x61/0xe0
[   30.214321]  xfs_reflink_cancel_cow_range+0xb2/0x1f0
[   30.215616]  xfs_fs_destroy_inode+0x1bd/0x280
[   30.216757]  dispose_list+0x35/0x40
[   30.217656]  evict_inodes+0x132/0x160
[   30.218620]  generic_shutdown_super+0x3a/0x110
[   30.219771]  kill_block_super+0x21/0x50
[   30.220762]  deactivate_locked_super+0x39/0x70
[   30.221909]  cleanup_mnt+0x3b/0x70
[   30.222819]  task_work_run+0x7f/0xa0
[   30.223762]  exit_to_usermode_loop+0x9b/0xa0
[   30.224884]  do_syscall_64+0x18f/0x1a0

Fix it and document that the callers of
xfs_reflink_cancel_cow_blocks() must have already joined the inode
to the permanent transaction passed in.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_reflink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 8c16177b33d4..6225d1ea3fdb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -552,6 +552,9 @@ xfs_reflink_trim_irec_to_next_cow(
  *
  * If cancel_real is true this function cancels all COW fork extents for the
  * inode; if cancel_real is false, real extents are not cleared.
+ *
+ * Caller must have already joined the inode to the current transaction. The
+ * inode will be joined to the transaction returned to the caller.
  */
 int
 xfs_reflink_cancel_cow_blocks(
@@ -592,7 +595,6 @@ xfs_reflink_cancel_cow_blocks(
 			if (error)
 				break;
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
-			xfs_trans_ijoin(*tpp, ip, 0);
 			xfs_defer_init(&dfops, &firstfsb);
 
 			/* Free the CoW orphan record. */
@@ -1571,6 +1573,7 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
+	xfs_trans_ijoin(*tpp, ip, 0);
 	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
 	if (error)
 		return error;
@@ -1579,7 +1582,6 @@ xfs_reflink_clear_inode_flag(
 	trace_xfs_reflink_unset_inode_flag(ip);
 	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
 	xfs_inode_clear_cowblocks_tag(ip);
-	xfs_trans_ijoin(*tpp, ip, 0);
 	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
 
 	return error;
-- 
2.16.1

