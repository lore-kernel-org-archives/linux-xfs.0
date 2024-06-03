Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC99139CF2
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441021; cv=none; b=UChoMM4IURqnoBWH0U1ZibSPuHo9o8yKS5znNyY/ZjkgPkBQjJBkAUyk3DjJxT0WumgP9C5zEz3ZizFmN7yuLVg8ABULHDJSjbRkgLHCYmgYtdmWZ2vlkgP+uAfDLAAIGEErbB5x503k83jGvwTsDSSairAaaHKJi7tAuesuPBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441021; c=relaxed/simple;
	bh=AFtVF5X6z3zrxAS9LDDHp9BNRVMmsiQZ+4qe48v3tr8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFUQbUw/9KSotG767vrX+HECPEnTyOzg6laTC7ucYzQqQ2oRmeW04JTno/Fu7ST9XdQYMo4f5UTZhC+Myzheio0QKUp+bp14GIvBgjPSBSUqs26x2Ys7DM8tN127+aYq3kiNSRRh6qhGrhhGmdlhCmdfqs4yFs2q9TPlpDYHp1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dUM8JR17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dUM8JR17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF57C2BD10;
	Mon,  3 Jun 2024 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441020;
	bh=AFtVF5X6z3zrxAS9LDDHp9BNRVMmsiQZ+4qe48v3tr8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dUM8JR17nv7hxLRHyJCQ2Eq/aVUIhmXT3urfCTr14PzlKTWFsFxo9ZRDxClvg1yni
	 +iVrA/zRCFHo/RkNDjC/aWlHhQQ4elyS96f1b93DekVthfEfo7no6n13bFcvlpGbxX
	 +7bxr9znqLBU0GuW+8NFOyW8Wbgtj9GcVE0h79tlUVU7GG49klcUsCxDUXIiBp8fDA
	 oOByKfOCVcO/tKFUpqtap5LHWUWMzoWiNew1DufPu/YH8+NhIT2g9U23dO5DLD89JQ
	 hvW7g+bVVceH+9wd+0okrYw1msCfABSpvgTg5Ar4usP7Y13tBssSbCSLFxJoonx5Zi
	 69y10N5X5dFaQ==
Date: Mon, 03 Jun 2024 11:57:00 -0700
Subject: [PATCH 019/111] xfs: report block map corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039654.1443973.4902827830033070350.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 1196f3f5abf736809cafac1696967ac318a44ca0

Whenever we encounter a corrupt block mapping, we should report that to
the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/util.c       |    1 +
 libxfs/xfs_bmap.c   |   35 +++++++++++++++++++++++++++++------
 libxfs/xfs_health.h |    1 +
 3 files changed, 31 insertions(+), 6 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index c30d83a8d..2403d64b4 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -732,3 +732,4 @@ void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask) { }
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask) { }
+void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork) { }
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4f616a547..4d21720e9 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -30,6 +30,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -954,6 +955,7 @@ xfs_bmap_add_attrfork_local(
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
+	xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
 }
 
@@ -1137,6 +1139,7 @@ xfs_iread_bmbt_block(
 				(unsigned long long)ip->i_ino);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, block,
 				sizeof(*block), __this_address);
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -1152,6 +1155,7 @@ xfs_iread_bmbt_block(
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 					"xfs_iread_extents(2)", frp,
 					sizeof(*frp), fa);
+			xfs_bmap_mark_sick(ip, whichfork);
 			return xfs_bmap_complain_bad_rec(ip, whichfork, fa,
 					&new);
 		}
@@ -1207,6 +1211,8 @@ xfs_iread_extents(
 	smp_store_release(&ifp->if_needextents, 0);
 	return 0;
 out:
+	if (xfs_metadata_is_sick(error))
+		xfs_bmap_mark_sick(ip, whichfork);
 	xfs_iext_destroy(ifp);
 	return error;
 }
@@ -1286,6 +1292,7 @@ xfs_bmap_last_before(
 		break;
 	default:
 		ASSERT(0);
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -3894,12 +3901,16 @@ xfs_bmapi_read(
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
 	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
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
@@ -4380,6 +4391,7 @@ xfs_bmapi_write(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -4607,9 +4619,11 @@ xfs_bmapi_convert_delalloc(
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
@@ -4668,6 +4682,7 @@ xfs_bmapi_remap(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5280,8 +5295,10 @@ __xfs_bunmapi(
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
 
@@ -5751,6 +5768,7 @@ xfs_bmap_collapse_extents(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5866,6 +5884,7 @@ xfs_bmap_insert_extents(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -5969,6 +5988,7 @@ xfs_bmap_split_extent(
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, whichfork);
 		return -EFSCORRUPTED;
 	}
 
@@ -6151,8 +6171,10 @@ xfs_bmap_finish_one(
 			bmap->br_startoff, bmap->br_blockcount,
 			bmap->br_state);
 
-	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK))
+	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
+		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
 		return -EFSCORRUPTED;
+	}
 
 	if (XFS_TEST_ERROR(false, tp->t_mountp,
 			XFS_ERRTAG_BMAP_FINISH_ONE))
@@ -6170,6 +6192,7 @@ xfs_bmap_finish_one(
 		break;
 	default:
 		ASSERT(0);
+		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
 		error = -EFSCORRUPTED;
 	}
 
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index fb3f2b490..3c8fd0607 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -159,6 +159,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_health_unmount(struct xfs_mount *mp);
+void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
 
 /* Now some helpers. */
 

