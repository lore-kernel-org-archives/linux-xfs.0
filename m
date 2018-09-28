Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45542 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbeI1H0Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Sep 2018 03:26:24 -0400
Subject: [PATCH 6/6] libxfs: track transaction block reservation usage like
 the kernel
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Sep 2018 18:05:14 -0700
Message-ID: <153809671445.32548.14246277971450145550.stgit@magnolia>
In-Reply-To: <153809666117.32548.6836488790026631787.stgit@magnolia>
References: <153809666117.32548.6836488790026631787.stgit@magnolia>
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
index 54546da8..d0fc2a84 100644
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
index 11a2098d..5ebca844 100644
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
 
@@ -775,6 +778,15 @@ libxfs_trans_mod_sb(
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
