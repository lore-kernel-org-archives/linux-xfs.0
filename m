Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbeJAXn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:43:27 -0400
Subject: [PATCH 3/8] xfs_repair: fix block reservation in mk_rsumino
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 10:04:36 -0700
Message-ID: <153841347645.27952.16962096446253318054.stgit@magnolia>
In-Reply-To: <153841345236.27952.5050172703525712660.stgit@magnolia>
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The functions mk_rsumino and rtinit both allocate transactions to create
the realtime summary inode.  In order to allocate and map blocks to the
rtsummary file, these transactions require a block reservation.
However, despite the comments in mk_rsumino about lifting the code from
mkfs, it doesn't actually copy the same reservation calculation that
mkfs uses in rtinit().  Practically speaking this has no effect since
userspace doesn't care about transaction block reservations, but fix
this logic bomb anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index d4b6a5cf..afa65c51 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -815,7 +815,7 @@ mk_rsumino(xfs_mount_t *mp)
 	tres.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	error = -libxfs_trans_alloc(mp, &tres,
-		mp->m_sb.sb_rbmblocks + (XFS_BM_MAXLEVELS(mp,XFS_DATA_FORK) - 1),
+		nsumblocks + (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
 				    0, 0, &tp);
 	if (error)
 		res_failed(error);
