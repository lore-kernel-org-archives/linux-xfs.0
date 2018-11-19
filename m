Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55865 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730844AbeKTHbC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 02:31:02 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj7-0000XQ-2L
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj7-0002Fz-15
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] xfs: finobt AG reserves don't consider last AG can be a runt
Date: Tue, 20 Nov 2018 08:04:56 +1100
Message-Id: <20181119210459.8506-5-david@fromorbit.com>
In-Reply-To: <20181119210459.8506-1-david@fromorbit.com>
References: <20181119210459.8506-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The last AG may be very small comapred to all other AGs, and hence
AG reservations based on the superblock AG size may actually consume
more space than the AG actually has. This results on assert failures
like:

XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 319
[   48.932891]  xfs_ag_resv_init+0x1bd/0x1d0
[   48.933853]  xfs_fs_reserve_ag_blocks+0x37/0xb0
[   48.934939]  xfs_mountfs+0x5b3/0x920
[   48.935804]  xfs_fs_fill_super+0x462/0x640
[   48.936784]  ? xfs_test_remount_options+0x60/0x60
[   48.937908]  mount_bdev+0x178/0x1b0
[   48.938751]  mount_fs+0x36/0x170
[   48.939533]  vfs_kern_mount.part.43+0x54/0x130
[   48.940596]  do_mount+0x20e/0xcb0
[   48.941396]  ? memdup_user+0x3e/0x70
[   48.942249]  ksys_mount+0xba/0xd0
[   48.943046]  __x64_sys_mount+0x21/0x30
[   48.943953]  do_syscall_64+0x54/0x170
[   48.944835]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Hence we need to ensure the finobt per-ag space reservations take
into account the size of the last AG rather than treat it like all
the other full size AGs.

Note that both refcountbt and rmapbt already take the size of the AG
into account via reading the AGF length directly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 86c50208a143..7fbf8af0b159 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -538,15 +538,18 @@ xfs_inobt_rec_check_count(
 
 static xfs_extlen_t
 xfs_inobt_max_size(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
 {
+	xfs_agblock_t		agblocks = xfs_ag_block_count(mp, agno);
+
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
 	if (mp->m_inobt_mxr[0] == 0)
 		return 0;
 
 	return xfs_btree_calc_size(mp->m_inobt_mnr,
-		(uint64_t)mp->m_sb.sb_agblocks * mp->m_sb.sb_inopblock /
-				XFS_INODES_PER_CHUNK);
+				(uint64_t)agblocks * mp->m_sb.sb_inopblock /
+					XFS_INODES_PER_CHUNK);
 }
 
 static int
@@ -594,7 +597,7 @@ xfs_finobt_calc_reserves(
 	if (error)
 		return error;
 
-	*ask += xfs_inobt_max_size(mp);
+	*ask += xfs_inobt_max_size(mp, agno);
 	*used += tree_len;
 	return 0;
 }
-- 
2.19.1
