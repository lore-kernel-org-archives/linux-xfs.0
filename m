Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7DCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiLaBxA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiLaBw7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:52:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089F51DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:52:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C19261CCE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA12EC433EF;
        Sat, 31 Dec 2022 01:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451578;
        bh=Bd7p0pl+varYl9Kmk+tqpMiZ1+ztzbVdTLv8zWJUhwg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DhM0gWp1RdqnDtSYtUhVkp9DbbPkbpUSW7RGY2aalGnbUbDVMSjGb3heiOqKLuqx0
         tVHrN5HfY3QQ4W2nqLpUTI6rP1rilp9pw6CQf5NWsAZwNj5wxqS2u5qs5OJY3hBkYw
         dYN2loKUEzDNVh03Y4ZhdH4uj7Kvthmu3YRhRZl6l05SzhXCAa83x4Ss0DRaOycRYN
         CSU/9rdrJGdWK0RPWO92EwETXbfGVKJAu35Kc924JfFO3TjAuPQder6PFMbVGOfdnN
         g3uiTHBv8LrvFX1Yolbu9RgqM4jvcNRE3mqAXtKvQLPaN5P4SW/hRkB4gxquVREl0g
         Z5NBX1l34WGZw==
Subject: [PATCH 19/42] xfs: enable CoW for realtime data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871166.717073.11067416256842216428.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update our write paths to support copy on write on the rt volume.  This
works in more or less the same way as it does on the data device, with
the major exception that we never do delalloc on the rt volume.

Because we consider unwritten CoW fork staging extents to be incore
quota reservation, we update xfs_quota_reserve_blkres to support this
case.  Though xfs doesn't allow rt and quota together, the change is
trivial and we shouldn't leave a logic bomb here.

While we're at it, add a missing xfs_mod_delalloc call when we remove
delalloc block reservation from the inode.  This is largely irrelvant
since realtime files do not use delalloc, but we want to avoid leaving
logic bombs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c   |   61 ++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_quota.h       |    6 +----
 fs/xfs/xfs_reflink.c     |   36 +++++++++++++++++++++------
 fs/xfs/xfs_trans_dquot.c |   11 ++++++++
 4 files changed, 90 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 447c057c9331..842f472292cd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -71,6 +71,55 @@ xfs_zero_extent(
 }
 
 #ifdef CONFIG_XFS_RT
+
+/* Update all inode and quota accounting for the allocation we just did. */
+static void
+xfs_bmap_rtalloc_accounting(
+	struct xfs_bmalloca	*ap)
+{
+	if (ap->flags & XFS_BMAPI_COWFORK) {
+		/*
+		 * COW fork blocks are in-core only and thus are treated as
+		 * in-core quota reservation (like delalloc blocks) even when
+		 * converted to real blocks. The quota reservation is not
+		 * accounted to disk until blocks are remapped to the data
+		 * fork. So if these blocks were previously delalloc, we
+		 * already have quota reservation and there's nothing to do
+		 * yet.
+		 */
+		if (ap->wasdel) {
+			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+			return;
+		}
+
+		/*
+		 * Otherwise, we've allocated blocks in a hole. The transaction
+		 * has acquired in-core quota reservation for this extent.
+		 * Rather than account these as real blocks, however, we reduce
+		 * the transaction quota reservation based on the allocation.
+		 * This essentially transfers the transaction quota reservation
+		 * to that of a delalloc extent.
+		 */
+		ap->ip->i_delayed_blks += ap->length;
+		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
+				XFS_TRANS_DQ_RES_RTBLKS, -(long)ap->length);
+		return;
+	}
+
+	/* data fork only */
+	ap->ip->i_nblocks += ap->length;
+	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+	if (ap->wasdel) {
+		ap->ip->i_delayed_blks -= ap->length;
+		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+	}
+
+	/* Adjust the disk quota also. This was reserved earlier. */
+	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
+			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
+				     XFS_TRANS_DQ_RTBCOUNT, ap->length);
+}
+
 int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)
@@ -166,17 +215,7 @@ xfs_bmap_rtalloc(
 	if (rtx != NULLRTEXTNO) {
 		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
 		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
-		ap->ip->i_nblocks += ap->length;
-		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
-		if (ap->wasdel)
-			ap->ip->i_delayed_blks -= ap->length;
-		/*
-		 * Adjust the disk quota also. This was reserved
-		 * earlier.
-		 */
-		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
-					XFS_TRANS_DQ_RTBCOUNT, ap->length);
+		xfs_bmap_rtalloc_accounting(ap);
 		return 0;
 	}
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 0cb52d5be4aa..fa34d997b747 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -124,11 +124,7 @@ int xfs_qm_mount_quotas(struct xfs_mount *mp);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
-static inline int
-xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
-{
-	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
-}
+int xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks);
 bool xfs_inode_near_dquot_enforcement(struct xfs_inode *ip, xfs_dqtype_t type);
 
 # ifdef CONFIG_XFS_LIVE_HOOKS
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 455adcce994d..3b5d144bef41 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -434,20 +434,26 @@ xfs_reflink_fill_cow_hole(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	xfs_filblks_t		resaligned;
-	xfs_extlen_t		resblks;
+	unsigned int		dblocks = 0, rblocks = 0;
 	int			nimaps;
 	int			error;
 	bool			found;
 
 	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
 		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
-	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+		rblocks = resaligned;
+	} else {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+		rblocks = 0;
+	}
 
 	xfs_iunlock(ip, *lockmode);
 	*lockmode = 0;
 
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
-			false, &tp);
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
+			rblocks, false, &tp);
 	if (error)
 		return error;
 
@@ -1232,7 +1238,7 @@ xfs_reflink_remap_extent(
 	struct xfs_trans	*tp;
 	xfs_off_t		newlen;
 	int64_t			qdelta = 0;
-	unsigned int		resblks;
+	unsigned int		dblocks, rblocks, resblks;
 	bool			quota_reserved = true;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
@@ -1263,8 +1269,15 @@ xfs_reflink_remap_extent(
 	 * we're remapping.
 	 */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		dblocks = resblks;
+		rblocks = dmap->br_blockcount;
+	} else {
+		dblocks = resblks + dmap->br_blockcount;
+		rblocks = 0;
+	}
 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
-			resblks + dmap->br_blockcount, 0, false, &tp);
+			dblocks, rblocks, false, &tp);
 	if (error == -EDQUOT || error == -ENOSPC) {
 		quota_reserved = false;
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
@@ -1344,8 +1357,15 @@ xfs_reflink_remap_extent(
 	 * done.
 	 */
 	if (!quota_reserved && !smap_real && dmap_written) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip,
-				dmap->br_blockcount, 0, false);
+		if (XFS_IS_REALTIME_INODE(ip)) {
+			dblocks = 0;
+			rblocks = dmap->br_blockcount;
+		} else {
+			dblocks = dmap->br_blockcount;
+			rblocks = 0;
+		}
+		error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks,
+				false);
 		if (error)
 			goto out_cancel;
 	}
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index f5e9d76fb9a2..31ab1c5d6b13 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -1009,3 +1009,14 @@ xfs_trans_free_dqinfo(
 	kmem_cache_free(xfs_dqtrx_cache, tp->t_dqinfo);
 	tp->t_dqinfo = NULL;
 }
+
+int
+xfs_quota_reserve_blkres(
+	struct xfs_inode	*ip,
+	int64_t			blocks)
+{
+	if (XFS_IS_REALTIME_INODE(ip))
+		return xfs_trans_reserve_quota_nblks(NULL, ip, 0, blocks,
+				false);
+	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
+}

