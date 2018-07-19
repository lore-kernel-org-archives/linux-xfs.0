Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731477AbeGSOcg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:32:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F86F40201CA
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B7B21C5B0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 07/14] xfs: pack holes in xfs_defer_ops and xfs_trans
Date: Thu, 19 Jul 2018 09:49:12 -0400
Message-Id: <20180719134919.29939-8-bfoster@redhat.com>
In-Reply-To: <20180719134919.29939-1-bfoster@redhat.com>
References: <20180719134919.29939-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Both structures have holes due to member alignment. Move dop_low to
the end of xfs_defer ops to sanitize the cache line alignment and
move t_flags to save 8 bytes in xfs_trans.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.h | 3 ++-
 fs/xfs/xfs_trans.h        | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 58c979c9f3fa..8f58f217fdff 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -49,13 +49,14 @@ enum xfs_defer_ops_type {
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 struct xfs_defer_ops {
-	bool			dop_low;	/* alloc in low mode */
 	struct list_head	dop_intake;	/* unlogged pending work */
 	struct list_head	dop_pending;	/* logged pending work */
 
 	/* relog these with each roll */
 	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
 	struct xfs_buf		*dop_bufs[XFS_DEFER_OPS_NR_BUFS];
+
+	bool			dop_low;	/* alloc in low mode */
 };
 
 void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 37fdacc690c7..6f857af61455 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -102,12 +102,12 @@ typedef struct xfs_trans {
 	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
+	unsigned int		t_flags;	/* misc flags */
 	xfs_fsblock_t		t_firstblock;	/* first block allocated */
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
 	struct xfs_defer_ops	*t_dfops;	/* dfops reference */
-	unsigned int		t_flags;	/* misc flags */
 	int64_t			t_icount_delta;	/* superblock icount change */
 	int64_t			t_ifree_delta;	/* superblock ifree change */
 	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
-- 
2.17.1

