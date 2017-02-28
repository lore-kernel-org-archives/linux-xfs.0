Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752101AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/12] xfs: cleanup is_reflink checks
Date: Tue, 28 Feb 2017 06:57:31 -0800
Message-Id: <20170228145737.19016-7-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

We'll soon need to distinguish between inodes that actually are reflinked,
and those that just use the COW fork for atomic write operations.  Switch
a few places to check for the existance of a COW for instead of the
reflink to prepare for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c    | 2 +-
 fs/xfs/xfs_icache.c  | 2 +-
 fs/xfs/xfs_reflink.c | 7 +++----
 fs/xfs/xfs_super.c   | 2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index fe244648fff0..c78b585b3d84 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -885,7 +885,7 @@ xfs_writepage_map(
 			continue;
 		}
 
-		if (xfs_is_reflink_inode(XFS_I(inode))) {
+		if (XFS_I(inode)->i_cowfp) {
 			error = xfs_map_cow(wpc, inode, offset, &new_type);
 			if (error)
 				goto out;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1f7d158266c1..1673a41db731 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1574,7 +1574,7 @@ xfs_inode_free_cowblocks(
 	 * Just clear the tag if we have an empty cow fork or none at all. It's
 	 * possible the inode was fully unshared since it was originally tagged.
 	 */
-	if (!xfs_is_reflink_inode(ip) || !ifp->if_bytes) {
+	if (!ifp || !ifp->if_bytes) {
 		trace_xfs_inode_free_cowblocks_invalid(ip);
 		xfs_inode_clear_cowblocks_tag(ip);
 		return 0;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 83605af3b135..4225b5e67b17 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -496,7 +496,6 @@ xfs_reflink_find_cow_mapping(
 	xfs_extnum_t			idx;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
-	ASSERT(xfs_is_reflink_inode(ip));
 
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
@@ -523,7 +522,7 @@ xfs_reflink_trim_irec_to_next_cow(
 	struct xfs_bmbt_irec		got;
 	xfs_extnum_t			idx;
 
-	if (!xfs_is_reflink_inode(ip))
+	if (!ifp)
 		return;
 
 	/* Find the extent in the CoW fork. */
@@ -561,7 +560,7 @@ xfs_reflink_cancel_cow_blocks(
 	struct xfs_defer_ops		dfops;
 	int				error = 0;
 
-	if (!xfs_is_reflink_inode(ip))
+	if (!ifp)
 		return 0;
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
 		return 0;
@@ -634,7 +633,7 @@ xfs_reflink_cancel_cow_range(
 	int			error;
 
 	trace_xfs_reflink_cancel_cow_range(ip, offset, count);
-	ASSERT(xfs_is_reflink_inode(ip));
+	ASSERT(ip->i_cowfp);
 
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
 	if (count == NULLFILEOFF)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9136854030d5..868860354f09 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -952,7 +952,7 @@ xfs_fs_destroy_inode(
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
 
-	if (xfs_is_reflink_inode(ip)) {
+	if (ip->i_cowfp) {
 		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, 0);
 		if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
 			xfs_warn(ip->i_mount,
-- 
2.11.0

