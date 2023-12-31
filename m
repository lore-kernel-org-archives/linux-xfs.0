Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188D1BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgRdQtt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860DCC433C8;
	Sun, 31 Dec 2023 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053442;
	bh=iVpvyfe2c13J23FRaCvYwS3kawDO/WpVjHm79tG6738=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GgRdQtt4ZpTVD4K8AnyIpLHZEY6lIcrT84fTPpCTM7OLnLc/NMW2z8hQX9jhFDzr1
	 M/X1L706j19vUPfH5NyGCQJ3D9V5vV1RR3q6Y1mkKEDRJYOHRdJpXGdTyj9J23En3C
	 VjmbDvTvWHbq0etgUCZb2N5Z8LxujJEwVi3lUAjoJIURARo6gHyS8ZewzFki7eXyyP
	 yHclS238J/06KIh2KNpX/wzsUpyet38LXWqs00MadFanoTYn9ZQBLNTyzg2E7TA7wx
	 2HwcIjQyQ49WHo0qhKt90zD7y2Up6UJVXRCnX+4GrF5sFy0cbTfK2tfOvVSOzY6N5k
	 L1XogR0k7zPlQ==
Date: Sun, 31 Dec 2023 12:10:42 -0800
Subject: [PATCH 04/11] xfs: report block map corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828344.1748329.4415364692513801204.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_bmap.c   |   35 +++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_health.h |    1 +
 fs/xfs/xfs_health.c        |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c         |   15 ++++++++++++---
 fs/xfs/xfs_reflink.c       |    6 +++++-
 5 files changed, 73 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 523926fe50eb0..752e424600807 100644
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
 
@@ -3885,12 +3892,16 @@ xfs_bmapi_read(
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
@@ -4371,6 +4382,7 @@ xfs_bmapi_write(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -4598,9 +4610,11 @@ xfs_bmapi_convert_delalloc(
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
@@ -4659,6 +4673,7 @@ xfs_bmapi_remap(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5271,8 +5286,10 @@ __xfs_bunmapi(
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
 
@@ -5743,6 +5760,7 @@ xfs_bmap_collapse_extents(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5858,6 +5876,7 @@ xfs_bmap_insert_extents(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5961,6 +5980,7 @@ xfs_bmap_split_extent(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -6143,8 +6163,10 @@ xfs_bmap_finish_one(
 			bmap->br_startoff, bmap->br_blockcount,
 			bmap->br_state);
 
-	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK))
+	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
+		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	if (XFS_TEST_ERROR(false, tp->t_mountp,
 			XFS_ERRTAG_BMAP_FINISH_ONE))
@@ -6162,6 +6184,7 @@ xfs_bmap_finish_one(
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

