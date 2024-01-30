Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0554E37179
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591417; cv=none; b=Nys8xaGWEygLhqSsUKKYfa8L+6rILH1K0kJc3wsizwOL9yD0sFw/kZdaoNgfDF3u3sfZhrs5+4trG/hy1MW9DCgU3+BLyfIhOWFnZwASh250hY6o+gatxipj/QHAiN4Q6j8fM67ayFW+ldfp76QUEp+pliwGvjjcpLH9kQfxcYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591417; c=relaxed/simple;
	bh=T+/VUXFWW2yacm1Gdv2NWoaA0+2rtFjVfFlfVXnjFes=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1ahVEiZxGppRK/cTYUXyQj3cmK6ZZ2Xqpmri7y5GyacPkCPcAgkVjEUzOkJfp2EsRG3a9dwzN379FG8VobjF2l5dM6MO/jQhH6O0rY5lVJnwWkm5e79G0E/fRKItDHRIhcwB9qAceMazFI3ItX1fcVFRz490Bb1pAaR5iVZ0wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1R88ULR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1R88ULR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAACCC433F1;
	Tue, 30 Jan 2024 05:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591416;
	bh=T+/VUXFWW2yacm1Gdv2NWoaA0+2rtFjVfFlfVXnjFes=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d1R88ULRGUm03SUAuGQMgdO9Y9auqhVOfte6+OrGSAuD1ROYsrc1dshBx9yHbYFOf
	 1mlNMyimdvXyLMDgG3tZpArk6GFJ2R3S3J2T3bLdxVbRtcyjEva86qwYsnYLHx+4qK
	 44CEmh75zcDQgXZksbOChye0MeaxCY8rBfd6ccCX4z9O5jtJUcDDyA4ceC0jajudHr
	 DDT+yVNdV1HMkM3j1ddfPVLauIEYI1IwPGMJ1ZPfVCRbFEVmHS4b4EZ3OOUqxdkNsL
	 IxWS5eBaqLcNxMeUnk/dfkVM3kLk0Eljr21XDdAGFdjGUOylvq0di3cllf4Yx6w6It
	 iNNw7Nt5S9qVA==
Date: Mon, 29 Jan 2024 21:10:16 -0800
Subject: [PATCH 04/11] xfs: report block map corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063791.3353909.7178244855328161007.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
References: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter a corrupt block mapping, we should report that to
the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c   |   35 +++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_health.h |    1 +
 fs/xfs/xfs_health.c        |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c         |   15 ++++++++++++---
 fs/xfs/xfs_reflink.c       |    6 +++++-
 5 files changed, 73 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f362345467fac..2954c51febbfc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -36,6 +36,7 @@
 #include "xfs_refcount.h"
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
+#include "xfs_health.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -960,6 +961,7 @@ xfs_bmap_add_attrfork_local(
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
+	xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
 }
 
@@ -1143,6 +1145,7 @@ xfs_iread_bmbt_block(
 				(unsigned long long)ip->i_ino);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, block,
 				sizeof(*block), __this_address);
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -1158,6 +1161,7 @@ xfs_iread_bmbt_block(
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 					"xfs_iread_extents(2)", frp,
 					sizeof(*frp), fa);
+			xfs_bmap_mark_sick(ip, whichfork);
 			return xfs_bmap_complain_bad_rec(ip, whichfork, fa,
 					&new);
 		}
@@ -1213,6 +1217,8 @@ xfs_iread_extents(
 	smp_store_release(&ifp->if_needextents, 0);
 	return 0;
 out:
+	if (xfs_metadata_is_sick(error))
+		xfs_bmap_mark_sick(ip, whichfork);
 	xfs_iext_destroy(ifp);
 	return error;
 }
@@ -1292,6 +1298,7 @@ xfs_bmap_last_before(
 		break;
 	default:
 		ASSERT(0);
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -3900,12 +3907,16 @@ xfs_bmapi_read(
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
@@ -4386,6 +4397,7 @@ xfs_bmapi_write(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -4613,9 +4625,11 @@ xfs_bmapi_convert_delalloc(
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
@@ -4674,6 +4688,7 @@ xfs_bmapi_remap(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5286,8 +5301,10 @@ __xfs_bunmapi(
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
 
@@ -5758,6 +5775,7 @@ xfs_bmap_collapse_extents(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5873,6 +5891,7 @@ xfs_bmap_insert_extents(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5976,6 +5995,7 @@ xfs_bmap_split_extent(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -6158,8 +6178,10 @@ xfs_bmap_finish_one(
 			bmap->br_startoff, bmap->br_blockcount,
 			bmap->br_state);
 
-	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK))
+	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
+		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	if (XFS_TEST_ERROR(false, tp->t_mountp,
 			XFS_ERRTAG_BMAP_FINISH_ONE))
@@ -6177,6 +6199,7 @@ xfs_bmap_finish_one(
 		break;
 	default:
 		ASSERT(0);
+		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
 		error = -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index cd7a1370a1ed8..50515920c9578 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -152,6 +152,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_health_unmount(struct xfs_mount *mp);
+void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 229a51cef47ee..9a86c1491e28e 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -465,3 +465,29 @@ xfs_bulkstat_health(
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
index 18c8f168b1532..0ff46e3997e0e 100644
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
index d5ca8bcae65b6..ad1f235a3c492 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -29,6 +29,7 @@
 #include "xfs_iomap.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_health.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -1227,8 +1228,10 @@ xfs_reflink_remap_extent(
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
 
@@ -1391,6 +1394,7 @@ xfs_reflink_remap_blocks(
 		ASSERT(nimaps == 1 && imap.br_startoff == srcoff);
 		if (imap.br_startblock == DELAYSTARTBLOCK) {
 			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
+			xfs_bmap_mark_sick(src, XFS_DATA_FORK);
 			error = -EFSCORRUPTED;
 			break;
 		}

