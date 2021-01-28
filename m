Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE579C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8526364DDA
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhA1GCm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhA1GCk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:02:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FE6064DDD;
        Thu, 28 Jan 2021 06:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813719;
        bh=WnRNUO89uyjnlnR1SiZPGtrhXeWx306ThwDGEcPnZ7E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DZExTsbPZkgvI5uVTuj+7kij9maugwDWZMHPwB6q/FfETvjT9KsUDOydMgmAWx5xZ
         wg8a9Y2h2R8nb/v13EeMVTrzeB3Lx4cBYfIzKD1l8w0MELFPxEgHMj2FXjaoWiDr2y
         THopNL3kenBAMn0UZpNm6LWmBooM97qIz04Fhj9oKRX5om5QwZjDoiXRzcNmVENjQb
         5RganP/T6aH0Bk2fKD2Y+C3zjUW1g91xXf1/lblDHunTF+nfxubGDIZB6HPYQ5pQqE
         Dku5Qv907ptYk7by4dGUCKKBr/QInQUkGBtfJ/WDkumPk5nisfx91ZBvnRvR5DIjlJ
         aGMKfk2bHGXzw==
Subject: [PATCH 09/13] xfs: refactor reflink functions to use
 xfs_trans_alloc_inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:01:55 -0800
Message-ID: <161181371557.1523592.14364313318301403930.stgit@magnolia>
In-Reply-To: <161181366379.1523592.9213241916555622577.stgit@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The two remaining callers of xfs_trans_reserve_quota_nblks are in the
reflink code.  These conversions aren't as uniform as the previous
conversions, so call that out in a separate patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   58 +++++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0778b5810c26..ded86cc4764c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -376,16 +376,15 @@ xfs_reflink_allocate_cow(
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 
 	xfs_iunlock(ip, *lockmode);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
-	*lockmode = XFS_ILOCK_EXCL;
-	xfs_ilock(ip, *lockmode);
 
-	if (error)
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
+			false, &tp);
+	if (error) {
+		/* This function must return with ILOCK_EXCL held. */
+		*lockmode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, *lockmode);
 		return error;
-
-	error = xfs_qm_dqattach_locked(ip, false);
-	if (error)
-		goto out_trans_cancel;
+	}
 
 	/*
 	 * Check for an overlapping extent again now that we dropped the ilock.
@@ -398,12 +397,6 @@ xfs_reflink_allocate_cow(
 		goto convert;
 	}
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, false);
-	if (error)
-		goto out_trans_cancel;
-
-	xfs_trans_ijoin(tp, ip, 0);
-
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
@@ -997,7 +990,7 @@ xfs_reflink_remap_extent(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	xfs_off_t		newlen;
-	int64_t			qres, qdelta;
+	int64_t			qdelta = 0;
 	unsigned int		resblks;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
@@ -1005,15 +998,22 @@ xfs_reflink_remap_extent(
 	int			nimaps;
 	int			error;
 
-	/* Start a rolling transaction to switch the mappings */
+	/*
+	 * Start a rolling transaction to switch the mappings.
+	 *
+	 * Adding a written extent to the extent map can cause a bmbt split,
+	 * and removing a mapped extent from the extent can cause a bmbt split.
+	 * The two operations cannot both cause a split since they operate on
+	 * the same index in the bmap btree, so we only need a reservation for
+	 * one bmbt split if either thing is happening.  However, we haven't
+	 * locked the inode yet, so we reserve assuming this is the case.
+	 */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
+			false, &tp);
 	if (error)
 		goto out;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
-
 	/*
 	 * Read what's currently mapped in the destination file into smap.
 	 * If smap isn't a hole, we will have to remove it before we can add
@@ -1061,15 +1061,9 @@ xfs_reflink_remap_extent(
 	}
 
 	/*
-	 * Compute quota reservation if we think the quota block counter for
+	 * Increase quota reservation if we think the quota block counter for
 	 * this file could increase.
 	 *
-	 * Adding a written extent to the extent map can cause a bmbt split,
-	 * and removing a mapped extent from the extent can cause a bmbt split.
-	 * The two operations cannot both cause a split since they operate on
-	 * the same index in the bmap btree, so we only need a reservation for
-	 * one bmbt split if either thing is happening.
-	 *
 	 * If we are mapping a written extent into the file, we need to have
 	 * enough quota block count reservation to handle the blocks in that
 	 * extent.  We log only the delta to the quota block counts, so if the
@@ -1083,13 +1077,9 @@ xfs_reflink_remap_extent(
 	 * before we started.  That should have removed all the delalloc
 	 * reservations, but we code defensively.
 	 */
-	qres = qdelta = 0;
-	if (smap_real || dmap_written)
-		qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	if (!smap_real && dmap_written)
-		qres += dmap->br_blockcount;
-	if (qres > 0) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0, false);
+	if (!smap_real && dmap_written) {
+		error = xfs_trans_reserve_quota_nblks(tp, ip,
+				dmap->br_blockcount, 0, false);
 		if (error)
 			goto out_cancel;
 	}

