Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83370C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjEZBBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZBBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:01:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71035194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AD86649F2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E65C433EF;
        Fri, 26 May 2023 01:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062872;
        bh=VlfoWiCpPMT3oxYNrfkgIqBwMGO3t3Zf9JMqS+Wutp4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ST4vrExqMyXwlaRhFHGS0Nh3sGq0f6YoVZL9RqMayOeJvup87QdvtqSWxBAUgRaFB
         U6tTQ0RzKwYP9uvH2VdsjapAA+TFzxxOfj3TB3MmVdAcjGktqJENglhHgBL2Z2USjj
         MyVaUFs/05FUT6bS040vw8accOTvgoNjGqqhGwhPfYNNIqTueD5T21+0NbYVsxU8A4
         2bSoBzQwrJJpqbtCAA3LjWLSSC1nlSbO9VjEPZH8nNKqE2IpMzuaCr3Z7TFFtCqgid
         qh5dOtbhrElNFbQqM7uab9g9aG1UPaOCb2FuL4gUdJ+pA3Xbnl2DrQqvJDJaRbdtMe
         Tuy2ze/Hba25w==
Date:   Thu, 25 May 2023 18:01:11 -0700
Subject: [PATCH 04/11] xfs: report block map corruption errors to the health
 tracking system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506060732.3732173.14981635294993549736.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
References: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter a corrupt block mapping, we should report that to
the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c   |   35 +++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_health.h |    1 +
 fs/xfs/xfs_health.c        |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c         |   15 ++++++++++++---
 fs/xfs/xfs_reflink.c       |    6 +++++-
 5 files changed, 73 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 18bfa70a90b3..a1d2ce9adb32 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -36,6 +36,7 @@
 #include "xfs_refcount.h"
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
+#include "xfs_health.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -955,6 +956,7 @@ xfs_bmap_add_attrfork_local(
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
+	xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
 }
 
@@ -1138,6 +1140,7 @@ xfs_iread_bmbt_block(
 				(unsigned long long)ip->i_ino);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, block,
 				sizeof(*block), __this_address);
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -1153,6 +1156,7 @@ xfs_iread_bmbt_block(
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 					"xfs_iread_extents(2)", frp,
 					sizeof(*frp), fa);
+			xfs_bmap_mark_sick(ip, whichfork);
 			return xfs_bmap_complain_bad_rec(ip, whichfork, fa,
 					&new);
 		}
@@ -1208,6 +1212,8 @@ xfs_iread_extents(
 	smp_store_release(&ifp->if_needextents, 0);
 	return 0;
 out:
+	if (xfs_metadata_is_sick(error))
+		xfs_bmap_mark_sick(ip, whichfork);
 	xfs_iext_destroy(ifp);
 	return error;
 }
@@ -1287,6 +1293,7 @@ xfs_bmap_last_before(
 		break;
 	default:
 		ASSERT(0);
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -3880,12 +3887,16 @@ xfs_bmapi_read(
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
-	if (WARN_ON_ONCE(!ifp))
+	if (WARN_ON_ONCE(!ifp)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT))
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -4366,6 +4377,7 @@ xfs_bmapi_write(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -4593,9 +4605,11 @@ xfs_bmapi_convert_delalloc(
 	error = -ENOSPC;
 	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
 		goto out_finish;
-	error = -EFSCORRUPTED;
-	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
+	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
+		xfs_bmap_mark_sick(ip, whichfork);
+		error = -EFSCORRUPTED;
 		goto out_finish;
+	}
 
 	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
 	XFS_STATS_INC(mp, xs_xstrat_quick);
@@ -4654,6 +4668,7 @@ xfs_bmapi_remap(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5292,8 +5307,10 @@ __xfs_bunmapi(
 	whichfork = xfs_bmapi_whichfork(flags);
 	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = xfs_ifork_ptr(ip, whichfork);
-	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)))
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp))) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
+	}
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
@@ -5763,6 +5780,7 @@ xfs_bmap_collapse_extents(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5878,6 +5896,7 @@ xfs_bmap_insert_extents(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5981,6 +6000,7 @@ xfs_bmap_split_extent(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -6163,8 +6183,10 @@ xfs_bmap_finish_one(
 			bmap->br_startoff, bmap->br_blockcount,
 			bmap->br_state);
 
-	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK))
+	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
+		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	if (XFS_TEST_ERROR(false, tp->t_mountp,
 			XFS_ERRTAG_BMAP_FINISH_ONE))
@@ -6182,6 +6204,7 @@ xfs_bmap_finish_one(
 		break;
 	default:
 		ASSERT(0);
+		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
 		error = -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 5a4995391ae7..8936176c38f1 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -142,6 +142,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_health_unmount(struct xfs_mount *mp);
+void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index ec987aebb042..c60decd40e5e 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -461,3 +461,29 @@ xfs_bulkstat_health(
 			bs->bs_sick |= m->ioctl_mask;
 	}
 }
+
+/* Mark a block mapping sick. */
+void
+xfs_bmap_mark_sick(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	unsigned int		mask;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		mask = XFS_SICK_INO_BMBTD;
+		break;
+	case XFS_ATTR_FORK:
+		mask = XFS_SICK_INO_BMBTA;
+		break;
+	case XFS_COW_FORK:
+		mask = XFS_SICK_INO_BMBTC;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	xfs_inode_mark_sick(ip, mask);
+}
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 18c8f168b153..0ff46e3997e0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -27,6 +27,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -45,6 +46,7 @@ xfs_alert_fsblock_zero(
 		(unsigned long long)imap->br_startoff,
 		(unsigned long long)imap->br_blockcount,
 		imap->br_state);
+	xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 	return -EFSCORRUPTED;
 }
 
@@ -99,8 +101,10 @@ xfs_bmbt_to_iomap(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
 
-	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
+	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
+		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 		return xfs_alert_fsblock_zero(ip, imap);
+	}
 
 	if (imap->br_startblock == HOLESTARTBLOCK) {
 		iomap->addr = IOMAP_NULL_ADDR;
@@ -325,8 +329,10 @@ xfs_iomap_write_direct(
 		goto out_unlock;
 	}
 
-	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
+	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
+		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 		error = xfs_alert_fsblock_zero(ip, imap);
+	}
 
 out_unlock:
 	*seq = xfs_iomap_inode_sequence(ip, 0);
@@ -639,8 +645,10 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock)))
+		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
+			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 			return xfs_alert_fsblock_zero(ip, &imap);
+		}
 
 		if ((numblks_fsb = imap.br_blockcount) == 0) {
 			/*
@@ -986,6 +994,7 @@ xfs_buffered_write_iomap_begin(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 		error = -EFSCORRUPTED;
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f5dc46ce9803..381847db46f4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -29,6 +29,7 @@
 #include "xfs_iomap.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_health.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -1223,8 +1224,10 @@ xfs_reflink_remap_extent(
 	 * extent if they're both holes or both the same physical extent.
 	 */
 	if (dmap->br_startblock == smap.br_startblock) {
-		if (dmap->br_state != smap.br_state)
+		if (dmap->br_state != smap.br_state) {
+			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 			error = -EFSCORRUPTED;
+		}
 		goto out_cancel;
 	}
 
@@ -1387,6 +1390,7 @@ xfs_reflink_remap_blocks(
 		ASSERT(nimaps == 1 && imap.br_startoff == srcoff);
 		if (imap.br_startblock == DELAYSTARTBLOCK) {
 			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
+			xfs_bmap_mark_sick(src, XFS_DATA_FORK);
 			error = -EFSCORRUPTED;
 			break;
 		}

