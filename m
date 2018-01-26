Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50472 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbeAZCTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 21:19:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0Q2HQbp151225
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:19:11 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2fqu8f01vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:19:09 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q257YB014737
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:08 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0Q257ni027314
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:07 GMT
Subject: [PATCH 3/6] xfs: track CoW blocks separately in the inode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jan 2018 18:05:06 -0800
Message-ID: <151693230662.7395.17437996000784460142.stgit@magnolia>
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

Track the number of blocks reserved in the CoW fork so that we can
move the quota reservations whenever we chown, and don't account for
CoW fork delalloc reservations in i_delayed_blks.  This should make
chown work properly for quota reservations, enables us to fully
account for real extents in the cow fork in the file stat info, and
improves the post-eof scanning decisions because we're no longer
confusing data fork delalloc extents with cow fork delalloc extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c      |   12 ++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c |    1 +
 fs/xfs/xfs_bmap_util.c        |    5 +++++
 fs/xfs/xfs_icache.c           |    3 ++-
 fs/xfs/xfs_inode.c            |   11 +++++------
 fs/xfs/xfs_inode.h            |    1 +
 fs/xfs/xfs_iops.c             |    3 ++-
 fs/xfs/xfs_itable.c           |    3 ++-
 fs/xfs/xfs_qm.c               |    2 +-
 fs/xfs/xfs_reflink.c          |    4 ++--
 fs/xfs/xfs_super.c            |    1 +
 11 files changed, 32 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a59d5be..032befb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3356,6 +3356,7 @@ xfs_bmap_btalloc_accounting(
 		 * back to q_res_bcount when the transaction commits, so we
 		 * must decrease qt_blk_res without decreasing q_res_bcount.
 		 */
+		ap->ip->i_cow_blocks += args->len;
 		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
 				-(long)args->len);
 		return;
@@ -3954,7 +3955,10 @@ xfs_bmapi_reserve_delalloc(
 		goto out_unreserve_blocks;
 
 
-	ip->i_delayed_blks += alen;
+	if (whichfork == XFS_COW_FORK)
+		ip->i_cow_blocks += alen;
+	else
+		ip->i_delayed_blks += alen;
 
 	got->br_startoff = aoff;
 	got->br_startblock = nullstartblock(indlen);
@@ -4694,7 +4698,10 @@ xfs_bmap_del_extent_delay(
 			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		return error;
-	ip->i_delayed_blks -= del->br_blockcount;
+	if (whichfork == XFS_COW_FORK)
+		ip->i_cow_blocks -= del->br_blockcount;
+	else
+		ip->i_delayed_blks -= del->br_blockcount;
 
 	if (got->br_startoff == del->br_startoff)
 		state |= BMAP_LEFT_FILLING;
@@ -4846,6 +4853,7 @@ xfs_bmap_del_extent_cow(
 	}
 
 	/* Remove the quota reservation */
+	ip->i_cow_blocks -= del->br_blockcount;
 	if (!free_quotares)
 		return;
 	error = xfs_trans_reserve_quota_nblks(NULL, ip,
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d7e7e58..d73ded3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -622,6 +622,7 @@ xfs_iread(
 
 	ASSERT(ip->i_d.di_version >= 2);
 	ip->i_delayed_blks = 0;
+	ip->i_cow_blocks = 0;
 
 	/*
 	 * Mark the buffer containing the inode as something to keep
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6d37ab4..c572789 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1991,6 +1991,7 @@ xfs_swap_extents(
 	/* Swap the cow forks. */
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 		xfs_extnum_t	extnum;
+		unsigned int	cowblocks;
 
 		ASSERT(ip->i_cformat == XFS_DINODE_FMT_EXTENTS);
 		ASSERT(tip->i_cformat == XFS_DINODE_FMT_EXTENTS);
@@ -2011,6 +2012,10 @@ xfs_swap_extents(
 			xfs_inode_set_cowblocks_tag(tip);
 		else
 			xfs_inode_clear_cowblocks_tag(tip);
+
+		cowblocks = tip->i_cow_blocks;
+		tip->i_cow_blocks = ip->i_cow_blocks;
+		ip->i_cow_blocks = cowblocks;
 	}
 
 	xfs_trans_log_inode(tp, ip,  src_log_flags);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2da7a2e..1344206 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -80,6 +80,7 @@ xfs_inode_alloc(
 	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
+	ip->i_cow_blocks = 0;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	return ip;
@@ -1668,7 +1669,7 @@ xfs_prep_free_cowblocks(
 	 * Just clear the tag if we have an empty cow fork or none at all. It's
 	 * possible the inode was fully unshared since it was originally tagged.
 	 */
-	if (!xfs_is_reflink_inode(ip) || !ifp->if_bytes) {
+	if (!xfs_is_reflink_inode(ip) || ip->i_cow_blocks == 0) {
 		trace_xfs_inode_free_cowblocks_invalid(ip);
 		xfs_inode_clear_cowblocks_tag(ip);
 		return false;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f8e8802..57ebc60 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1508,15 +1508,13 @@ xfs_itruncate_clear_reflink_flags(
 	struct xfs_inode	*ip)
 {
 	struct xfs_ifork	*dfork;
-	struct xfs_ifork	*cfork;
 
 	if (!xfs_is_reflink_inode(ip))
 		return;
 	dfork = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	cfork = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	if (dfork->if_bytes == 0 && cfork->if_bytes == 0)
+	if (dfork->if_bytes == 0 && ip->i_cow_blocks == 0)
 		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
-	if (cfork->if_bytes == 0)
+	if (ip->i_cow_blocks == 0)
 		xfs_inode_clear_cowblocks_tag(ip);
 }
 
@@ -1669,7 +1667,7 @@ xfs_release(
 		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
 		if (truncated) {
 			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
-			if (ip->i_delayed_blks > 0) {
+			if (ip->i_delayed_blks > 0 || ip->i_cow_blocks > 0) {
 				error = filemap_flush(VFS_I(ip)->i_mapping);
 				if (error)
 					return error;
@@ -1909,7 +1907,8 @@ xfs_inactive(
 
 	if (S_ISREG(VFS_I(ip)->i_mode) &&
 	    (ip->i_d.di_size != 0 || XFS_ISIZE(ip) != 0 ||
-	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
+	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0 ||
+	     ip->i_cow_blocks > 0))
 		truncate = 1;
 
 	error = xfs_qm_dqattach(ip, 0);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ff56486..6feee8a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -62,6 +62,7 @@ typedef struct xfs_inode {
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
+	unsigned int		i_cow_blocks;	/* count of cow fork blocks */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 56475fc..6c3381c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -513,7 +513,8 @@ xfs_vn_getattr(
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
 	stat->blocks =
-		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
+		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks +
+				  ip->i_cow_blocks);
 
 	if (ip->i_d.di_version == 3) {
 		if (request_mask & STATX_BTIME) {
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index d583105..412d7eb 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -122,7 +122,8 @@ xfs_bulkstat_one_int(
 	case XFS_DINODE_FMT_BTREE:
 		buf->bs_rdev = 0;
 		buf->bs_blksize = mp->m_sb.sb_blocksize;
-		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks;
+		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks +
+				 ip->i_cow_blocks;
 		break;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5b848f4..28f12f8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1847,7 +1847,7 @@ xfs_qm_vop_chown_reserve(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	delblks = ip->i_delayed_blks;
+	delblks = ip->i_delayed_blks + ip->i_cow_blocks;
 	blkflags = XFS_IS_REALTIME_INODE(ip) ?
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3644a08..9a6c545 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -619,7 +619,7 @@ xfs_reflink_cancel_cow_blocks(
 	}
 
 	/* clear tag if cow fork is emptied */
-	if (!ifp->if_bytes)
+	if (ip->i_cow_blocks == 0)
 		xfs_inode_clear_cowblocks_tag(ip);
 
 	return error;
@@ -704,7 +704,7 @@ xfs_reflink_end_cow(
 	trace_xfs_reflink_end_cow(ip, offset, count);
 
 	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0)
+	if (ip->i_cow_blocks == 0)
 		return 0;
 
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f3e0001..9d04cfb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -989,6 +989,7 @@ xfs_fs_destroy_inode(
 	xfs_inactive(ip);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_cow_blocks == 0);
 	XFS_STATS_INC(ip->i_mount, vn_reclaim);
 
 	/*

