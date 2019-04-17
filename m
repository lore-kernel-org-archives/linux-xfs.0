Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38206 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbfDQBkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:40:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1ckss097381
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:10 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rusnewxmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1e91C052651
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2rv2tv320r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3H1e72U022186
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:07 GMT
Subject: [PATCH 1/3] xfs: track delayed allocation reservations across
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 16 Apr 2019 18:40:06 -0700
Message-ID: <155546520611.176278.16800498529488238281.stgit@magnolia>
In-Reply-To: <155546519998.176278.8300210828717055034.stgit@magnolia>
References: <155546519998.176278.8300210828717055034.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a percpu counter to track the number of blocks directly reserved for
delayed allocations on the data device.  This counter (in contrast to
i_delayed_blks) does not track allocated CoW staging extents or anything
going on with the realtime device.  It will be used in the upcoming
summary counter scrub function to check the free block counts without
having to freeze the filesystem or walk all the inodes to find the
delayed allocations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   17 ++++++++++++++---
 fs/xfs/xfs_mount.h       |   15 +++++++++++++++
 fs/xfs/xfs_super.c       |    9 +++++++++
 3 files changed, 38 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4637ae1ae91c..356ebd1cbe82 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2009,6 +2009,9 @@ xfs_bmap_add_extent_delay_real(
 			goto done;
 	}
 
+	if (da_new != da_old)
+		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
+
 	if (bma->cur) {
 		da_new += bma->cur->bc_private.b.allocated;
 		bma->cur->bc_private.b.allocated = 0;
@@ -2640,6 +2643,7 @@ xfs_bmap_add_extent_hole_delay(
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
+		xfs_mod_delalloc(ip->i_mount, (int64_t)newlen - oldlen);
 	}
 }
 
@@ -3352,8 +3356,10 @@ xfs_bmap_btalloc_accounting(
 		 * already have quota reservation and there's nothing to do
 		 * yet.
 		 */
-		if (ap->wasdel)
+		if (ap->wasdel) {
+			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
 			return;
+		}
 
 		/*
 		 * Otherwise, we've allocated blocks in a hole. The transaction
@@ -3372,8 +3378,10 @@ xfs_bmap_btalloc_accounting(
 	/* data/attr fork only */
 	ap->ip->i_d.di_nblocks += args->len;
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
-	if (ap->wasdel)
+	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= args->len;
+		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
+	}
 	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
 		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
 		args->len);
@@ -3969,6 +3977,7 @@ xfs_bmapi_reserve_delalloc(
 
 
 	ip->i_delayed_blks += alen;
+	xfs_mod_delalloc(ip->i_mount, alen + indlen);
 
 	got->br_startoff = aoff;
 	got->br_startblock = nullstartblock(indlen);
@@ -4840,8 +4849,10 @@ xfs_bmap_del_extent_delay(
 	da_diff = da_old - da_new;
 	if (!isrt)
 		da_diff += del->br_blockcount;
-	if (da_diff)
+	if (da_diff) {
 		xfs_mod_fdblocks(mp, da_diff, false);
+		xfs_mod_delalloc(mp, -da_diff);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 14fba76ab811..f5cf4eb22d8e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -81,6 +81,12 @@ typedef struct xfs_mount {
 	struct percpu_counter	m_icount;	/* allocated inodes counter */
 	struct percpu_counter	m_ifree;	/* free inodes counter */
 	struct percpu_counter	m_fdblocks;	/* free block counter */
+	/*
+	 * Count of data device blocks reserved for delayed allocations,
+	 * including indlen blocks.  Does not include allocated CoW staging
+	 * extents or anything related to the rt device.
+	 */
+	struct percpu_counter	m_delalloc_blks;
 
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_fsname;	/* filesystem name */
@@ -476,4 +482,13 @@ struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
 void xfs_force_summary_recalc(struct xfs_mount *mp);
 
+/* Update the in-core delayed block counter. */
+static inline void
+xfs_mod_delalloc(
+	struct xfs_mount	*mp,
+	int64_t			delta)
+{
+	percpu_counter_add(&mp->m_delalloc_blks, delta);
+}
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index df917f41ca46..3a870a194cd9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1538,8 +1538,14 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_ifree;
 
+	error = percpu_counter_init(&mp->m_delalloc_blks, 0, GFP_KERNEL);
+	if (error)
+		goto free_fdblocks;
+
 	return 0;
 
+free_fdblocks:
+	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
 	percpu_counter_destroy(&mp->m_ifree);
 free_icount:
@@ -1563,6 +1569,9 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_icount);
 	percpu_counter_destroy(&mp->m_ifree);
 	percpu_counter_destroy(&mp->m_fdblocks);
+	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
+	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
+	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
 static struct xfs_mount *
