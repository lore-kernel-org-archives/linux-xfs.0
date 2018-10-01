Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47852 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeJAXnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:43:55 -0400
Subject: [PATCH 7/8] libxfs: track transaction block reservation usage like
 the kernel
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 10:05:05 -0700
Message-ID: <153841350523.27952.11171629461645481206.stgit@magnolia>
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

Currently, block reservations in userspace transactions are not carried
over across transaction rolls.  This will lead to ENOSPC failures inside
libxfs code which checks for reservation overruns in an upcoming patch
that borrows the bmbt repair code from the kernel because it makes
extensive use of transaction rolling.

Therefore, port t_blk_res_used from the kernel so that block
reservations work the same way in userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h |    1 +
 libxfs/trans.c      |   12 ++++++++++++
 2 files changed, 13 insertions(+)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index eda2f894..31df1172 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -71,6 +71,7 @@ typedef struct xfs_trans {
 	unsigned int	t_blk_res;		/* # of blocks resvd */
 	xfs_fsblock_t	t_firstblock;		/* first block allocated */
 	struct xfs_mount *t_mountp;		/* ptr to fs mount struct */
+	unsigned int	t_blk_res_used;		/* # of resvd blocks used */
 	unsigned int	t_flags;		/* misc flags */
 	long		t_icount_delta;		/* superblock icount change */
 	long		t_ifree_delta;		/* superblock ifree change */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 508d12d7..7058ecef 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -158,6 +158,9 @@ xfs_trans_dup(
 	/* We gave our writer reference to the new transaction */
 	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 
+	ntp->t_blk_res = tp->t_blk_res - tp->t_blk_res_used;
+	tp->t_blk_res = tp->t_blk_res_used;
+
 	/* move deferred ops over to the new tp */
 	xfs_defer_move(ntp, tp);
 
@@ -790,6 +793,15 @@ libxfs_trans_mod_sb(
 	case XFS_TRANS_SB_RES_FDBLOCKS:
 		return;
 	case XFS_TRANS_SB_FDBLOCKS:
+		if (delta < 0) {
+			tp->t_blk_res_used += (uint)-delta;
+			if (tp->t_blk_res_used > tp->t_blk_res) {
+				fprintf(stderr,
+_("Transaction block reservation exceeded! %u > %u\n"),
+					tp->t_blk_res_used, tp->t_blk_res);
+				ASSERT(0);
+			}
+		}
 		tp->t_fdblocks_delta += delta;
 		break;
 	case XFS_TRANS_SB_ICOUNT:
