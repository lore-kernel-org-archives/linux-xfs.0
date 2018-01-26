Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45984 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbeAZCR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 21:17:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0Q2HQXl151223
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:17:28 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2fqu8f01dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:17:26 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q2517n014418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:02 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0Q251WQ027286
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:01 GMT
Subject: [PATCH 2/6] xfs: CoW fork operations should only update quota
 reservations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jan 2018 18:05:00 -0800
Message-ID: <151693230033.7395.7231908899619118352.stgit@magnolia>
In-Reply-To: <151693228803.7395.12526880865470882359.stgit@magnolia>
References: <151693228803.7395.12526880865470882359.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the CoW fork only exists in memory, it is incorrect to update the
on-disk quota block counts when we modify the CoW fork.  Unlike the data
fork, even real extents in the CoW fork are only reservations (on-disk
they're owned by the refcountbt) so they must not be tracked in the on
disk quota info.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   33 ++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_bmap.h |    2 +-
 fs/xfs/xfs_reflink.c     |   12 ++++++------
 3 files changed, 37 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6ad79ea..a59d5be 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3343,8 +3343,26 @@ xfs_bmap_btalloc_accounting(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args)
 {
-	if (!(ap->flags & XFS_BMAPI_COWFORK))
-		ap->ip->i_d.di_nblocks += args->len;
+	if (ap->flags & XFS_BMAPI_COWFORK) {
+		/* Filling a previously reserved extent; nothing to do here. */
+		if (ap->wasdel)
+			return;
+
+		/*
+		 * If we get here, we're filling a CoW hole with a real
+		 * (non-delalloc) CoW extent having reserved enough blocks
+		 * from both q_res_bcount and qt_blk_res to guarantee that we
+		 * won't run out of space.  The unused qt_blk_res is given
+		 * back to q_res_bcount when the transaction commits, so we
+		 * must decrease qt_blk_res without decreasing q_res_bcount.
+		 */
+		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
+				-(long)args->len);
+		return;
+	}
+
+	/* data/attr fork only */
+	ap->ip->i_d.di_nblocks += args->len;
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel)
 		ap->ip->i_delayed_blks -= args->len;
@@ -4761,13 +4779,15 @@ xfs_bmap_del_extent_cow(
 	struct xfs_inode	*ip,
 	struct xfs_iext_cursor	*icur,
 	struct xfs_bmbt_irec	*got,
-	struct xfs_bmbt_irec	*del)
+	struct xfs_bmbt_irec	*del,
+	bool			free_quotares)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec	new;
 	xfs_fileoff_t		del_endoff, got_endoff;
 	int			state = BMAP_COWFORK;
+	int			error;
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
@@ -4824,6 +4844,13 @@ xfs_bmap_del_extent_cow(
 		xfs_iext_insert(ip, icur, &new, state);
 		break;
 	}
+
+	/* Remove the quota reservation */
+	if (!free_quotares)
+		return;
+	error = xfs_trans_reserve_quota_nblks(NULL, ip,
+			-(long)del->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
+	ASSERT(error == 0);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e36d757..e99f28f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -224,7 +224,7 @@ int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *del);
 void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
-		struct xfs_bmbt_irec *del);
+		struct xfs_bmbt_irec *del, bool free_quotares);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 82abff6..3644a08 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -599,10 +599,6 @@ xfs_reflink_cancel_cow_blocks(
 					del.br_startblock, del.br_blockcount,
 					NULL);
 
-			/* Update quota accounting */
-			xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
-					-(long)del.br_blockcount);
-
 			/* Roll the transaction */
 			xfs_defer_ijoin(&dfops, ip);
 			error = xfs_defer_finish(tpp, &dfops);
@@ -612,7 +608,7 @@ xfs_reflink_cancel_cow_blocks(
 			}
 
 			/* Remove the mapping from the CoW fork. */
-			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
+			xfs_bmap_del_extent_cow(ip, &icur, &got, &del, true);
 		} else {
 			/* Didn't do anything, push cursor back. */
 			xfs_iext_prev(ifp, &icur);
@@ -795,8 +791,12 @@ xfs_reflink_end_cow(
 		if (error)
 			goto out_defer;
 
+		/* Charge this new data fork mapping to the on-disk quota. */
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
+				(long)del.br_blockcount);
+
 		/* Remove the mapping from the CoW fork. */
-		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
+		xfs_bmap_del_extent_cow(ip, &icur, &got, &del, false);
 
 		xfs_defer_ijoin(&dfops, ip);
 		error = xfs_defer_finish(&tp, &dfops);

