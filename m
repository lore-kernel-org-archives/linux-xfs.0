Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDE5C3F2CE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E02EF20848
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgCECDd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 21:03:33 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48031 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbgCECDd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 21:03:33 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DB9CC3A2A5E
        for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2020 13:03:29 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9fZx-0005xJ-Hz
        for linux-xfs@vger.kernel.org; Thu, 05 Mar 2020 12:45:37 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9fZx-0002w8-G5
        for linux-xfs@vger.kernel.org; Thu, 05 Mar 2020 12:45:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: rename btree cursur private btree member flags
Date:   Thu,  5 Mar 2020 12:45:34 +1100
Message-Id: <20200305014537.11236-5-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200305014537.11236-1-david@fromorbit.com>
References: <20200305014537.11236-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=qaM85UAT3d_EtL8BdagA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

BPRV is not longer appropriate because bc_private is going away.
Script:

$ sed -i 's/BTCUR_BPRV/BC_BT/g' fs/xfs/*[ch] fs/xfs/*/*[ch]

With manual cleanup to the definitions in fs/xfs/libxfs/xfs_btree.h

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 8 ++++----
 fs/xfs/libxfs/xfs_bmap_btree.c | 4 ++--
 fs/xfs/libxfs/xfs_btree.c      | 2 +-
 fs/xfs/libxfs/xfs_btree.h      | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 81a8e70c6957..c5d0cbff3780 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -690,7 +690,7 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-	cur->bc_bt.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
+	cur->bc_bt.flags = wasdel ? XFS_BC_BT_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
 	 */
@@ -1528,7 +1528,7 @@ xfs_bmap_add_extent_delay_real(
 
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
-	       (bma->cur->bc_bt.flags & XFS_BTCUR_BPRV_WASDEL));
+	       (bma->cur->bc_bt.flags & XFS_BC_BT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -2752,7 +2752,7 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_bmbt_irec	old;
 
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!cur || !(cur->bc_bt.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(!cur || !(cur->bc_bt.flags & XFS_BC_BT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -4188,7 +4188,7 @@ xfs_bmapi_allocate(
 
 	if (bma->cur)
 		bma->cur->bc_bt.flags =
-			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
+			bma->wasdel ? XFS_BC_BT_WASDEL : 0;
 
 	bma->got.br_startoff = bma->offset;
 	bma->got.br_startblock = bma->blkno;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 909cc02256f5..bcf0e19f57d6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -230,7 +230,7 @@ xfs_bmbt_alloc_block(
 	}
 
 	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_bt.flags & XFS_BTCUR_BPRV_WASDEL;
+	args.wasdel = cur->bc_bt.flags & XFS_BC_BT_WASDEL;
 	if (!args.wasdel && args.tp->t_blk_res == 0) {
 		error = -ENOSPC;
 		goto error0;
@@ -644,7 +644,7 @@ xfs_bmbt_change_owner(
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	if (!cur)
 		return -ENOMEM;
-	cur->bc_bt.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
+	cur->bc_bt.flags |= XFS_BC_BT_INVALID_OWNER;
 
 	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
 	xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 142497032df4..d54b4a3273a4 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1743,7 +1743,7 @@ xfs_btree_lookup_get_block(
 
 	/* Check the inode owner since the verifiers don't. */
 	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
-	    !(cur->bc_bt.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
+	    !(cur->bc_bt.flags & XFS_BC_BT_INVALID_OWNER) &&
 	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
 			cur->bc_bt.ip->i_ino)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index bd5a2bfca64e..93063479264c 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -220,8 +220,8 @@ typedef struct xfs_btree_cur
 			short		forksize;	/* fork's inode space */
 			char		whichfork;	/* data or attr fork */
 			char		flags;		/* flags */
-#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)		/* was delayed */
-#define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
+#define	XFS_BC_BT_WASDEL	(1 << 0)		/* was delayed */
+#define	XFS_BC_BT_INVALID_OWNER	(1 << 1)		/* for ext swap */
 		} b;
 	}		bc_private;	/* per-btree type data */
 #define bc_ag	bc_private.a
-- 
2.24.0.rc0

