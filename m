Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB33148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529239; cv=none; b=emHesnQ1XEjSQqEJgQx2TMrm4IXDDLNSOAFcgdrjcZUI78A/RkPvd4t//ZvCtbMiHJfjdVbOxc/1BJ4p58FfgHqbRfYeuRl5KR4k54na/6pu8ds94Tr47tTvmqNSKrU1YAMZyOOAM/AtZr2GK64EWFyj4egfL7ZFjb0C/qg5nH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529239; c=relaxed/simple;
	bh=14qyJVZaC3dRDVl24qe2f4jpi1vaItgdTxbUFznKKf8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEc3njIxXEUv17z1Lcyy/UIqFYpK4kLiHngxbt+PVEOu4SFfEtgSnqs3GJsqQbK3hsUSFJylLLBbC/uMgKtEJKgpTEHUFp5xAQbJJhHSd6LS5P/xWmg2r7Wal7iNAnChY1gv05/97js7xBmwA55SRjhNq9hdLM9LQ2RMw2OYrdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXJmNipc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXJmNipc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ECCC4CED1;
	Fri,  6 Dec 2024 23:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529239;
	bh=14qyJVZaC3dRDVl24qe2f4jpi1vaItgdTxbUFznKKf8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gXJmNipciGlZ+R4wJxi0JLD4QcWYk5N7UXM8ret1GJVojElo49F7/oHaAA1lE9Lcb
	 l2wT/C4n+dwocySSysL0KywLUAbl3FATwS+Cnz/K3KykHzfVjPEWabpMsaAftEBmeB
	 +3TWLyyu9Y+R6Yc2JaYjHFpdrMZDHG1HAThCnsvsGc5dDgTaq73sB9f6N/mIVP+h8j
	 Opv6P2XjKPR9Aw1Y/cnN+Xh4+kKnY++Y5abxTXNPYfoSSU4/rmVI1xYPZiMLU8dU/a
	 Z8RjixQrtwnqq7JDIWn5TpLytxnuKCl+iBs3Os6ItumI61wTCl9HKGfuKzB8RoRZQV
	 /iOxq+u6eNo9w==
Date: Fri, 06 Dec 2024 15:53:58 -0800
Subject: [PATCH 10/46] xfs: make RT extent numbers relative to the rtgroup
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750147.124560.17175446350738147788.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f220f6da5f4ad7da538c39075cf57e829d5202f7

To prepare for adding per-rtgroup bitmap files, make the xfs_rtxnum_t
type encode the RT extent number relative to the rtgroup.  The biggest
part of this to clearly distinguish between the relative extent number
that gets masked when converting from a global block number and length
values that just have a factor applied to them when converting from
file system blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c            |    2 +
 libxfs/xfs_bmap.c     |    6 ++--
 libxfs/xfs_rtbitmap.h |   69 +++++++++++++++++++++++++++++++------------------
 3 files changed, 47 insertions(+), 30 deletions(-)


diff --git a/db/block.c b/db/block.c
index b50b2c16060ac7..f197e10cd5a08d 100644
--- a/db/block.c
+++ b/db/block.c
@@ -423,7 +423,7 @@ rtextent_f(
 		return 0;
 	}
 
-	rtbno = xfs_rtx_to_rtb(mp, rtx);
+	rtbno = xfs_rtbxlen_to_blen(mp, rtx);
 	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
 	set_rt_cur(&typtab[TYP_DATA], xfs_rtb_to_daddr(mp, rtbno),
 			mp->m_sb.sb_rextsize * blkbb, DB_RING_ADD, NULL);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cebf5479189280..48b05c40e23235 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4088,7 +4088,7 @@ xfs_bmapi_reserve_delalloc(
 
 	fdblocks = indlen;
 	if (XFS_IS_REALTIME_INODE(ip)) {
-		error = xfs_dec_frextents(mp, xfs_rtb_to_rtx(mp, alen));
+		error = xfs_dec_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
 		if (error)
 			goto out_unreserve_quota;
 	} else {
@@ -4123,7 +4123,7 @@ xfs_bmapi_reserve_delalloc(
 
 out_unreserve_frextents:
 	if (XFS_IS_REALTIME_INODE(ip))
-		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, alen));
+		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
@@ -5031,7 +5031,7 @@ xfs_bmap_del_extent_delay(
 	fdblocks = da_diff;
 
 	if (isrt)
-		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
+		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
 	else
 		fdblocks += del->br_blockcount;
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 776cca9e41bf05..b2b9e59a87a278 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -22,13 +22,37 @@ struct xfs_rtalloc_args {
 
 static inline xfs_rtblock_t
 xfs_rtx_to_rtb(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
 	xfs_rtxnum_t		rtx)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_rtblock_t		start = xfs_rgno_start_rtb(mp, rtg_rgno(rtg));
+
+	if (mp->m_rtxblklog >= 0)
+		return start + (rtx << mp->m_rtxblklog);
+	return start + (rtx * mp->m_sb.sb_rextsize);
+}
+
+/* Convert an rgbno into an rt extent number. */
+static inline xfs_rtxnum_t
+xfs_rgbno_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_rgblock_t		rgbno)
+{
+	if (likely(mp->m_rtxblklog >= 0))
+		return rgbno >> mp->m_rtxblklog;
+	return rgbno / mp->m_sb.sb_rextsize;
+}
+
+static inline uint64_t
+xfs_rtbxlen_to_blen(
+	struct xfs_mount	*mp,
+	xfs_rtbxlen_t		rtbxlen)
 {
 	if (mp->m_rtxblklog >= 0)
-		return rtx << mp->m_rtxblklog;
+		return rtbxlen << mp->m_rtxblklog;
 
-	return rtx * mp->m_sb.sb_rextsize;
+	return rtbxlen * mp->m_sb.sb_rextsize;
 }
 
 static inline xfs_extlen_t
@@ -65,16 +89,29 @@ xfs_extlen_to_rtxlen(
 	return len / mp->m_sb.sb_rextsize;
 }
 
+/* Convert an rt block count into an rt extent count. */
+static inline xfs_rtbxlen_t
+xfs_blen_to_rtbxlen(
+	struct xfs_mount	*mp,
+	uint64_t		blen)
+{
+	if (likely(mp->m_rtxblklog >= 0))
+		return blen >> mp->m_rtxblklog;
+
+	return div_u64(blen, mp->m_sb.sb_rextsize);
+}
+
 /* Convert an rt block number into an rt extent number. */
 static inline xfs_rtxnum_t
 xfs_rtb_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	if (likely(mp->m_rtxblklog >= 0))
-		return rtbno >> mp->m_rtxblklog;
+	uint64_t		__rgbno = __xfs_rtb_to_rgbno(mp, rtbno);
 
-	return div_u64(rtbno, mp->m_sb.sb_rextsize);
+	if (likely(mp->m_rtxblklog >= 0))
+		return __rgbno >> mp->m_rtxblklog;
+	return div_u64(__rgbno, mp->m_sb.sb_rextsize);
 }
 
 /* Return the offset of an rt block number within an rt extent. */
@@ -89,26 +126,6 @@ xfs_rtb_to_rtxoff(
 	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
-/*
- * Convert an rt block number into an rt extent number, rounding up to the next
- * rt extent if the rt block is not aligned to an rt extent boundary.
- */
-static inline xfs_rtxnum_t
-xfs_rtb_to_rtxup(
-	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
-{
-	if (likely(mp->m_rtxblklog >= 0)) {
-		if (rtbno & mp->m_rtxblkmask)
-			return (rtbno >> mp->m_rtxblklog) + 1;
-		return rtbno >> mp->m_rtxblklog;
-	}
-
-	if (do_div(rtbno, mp->m_sb.sb_rextsize))
-		rtbno++;
-	return rtbno;
-}
-
 /* Round this rtblock up to the nearest rt extent size. */
 static inline xfs_rtblock_t
 xfs_rtb_roundup_rtx(

