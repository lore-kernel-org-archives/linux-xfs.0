Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F14657872
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998957; cv=none; b=dXvyUiHoVWPgRjSzhHGL7NlKeWLsC/iGR8MpMEfp6ZequBL0cL64oJ99GGnvnnY73VSA/pw1H5SCLTMqotUzDZkDE0ARRarWZvW+0GWqe2CWJNJjpNF1/QLeK8iXsFanzUOBGARDB1WKtB6d31qmAiZwauKZZO2I1GDexIQwuiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998957; c=relaxed/simple;
	bh=P6dT2IrOzvHkh0DUIgtUXOIUjL8DP7i7+uZNjtnqZio=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8Pbkfgl+dK8qu3uR38C36zWbf/yHVPgYYAvBhXg1XYBYDP7Gh9ZFG3CHp9Ap11MuyGRozDh15pjb4SYUtmfMsrF8bznhhaV5SHmdwOJgH336b1Gm36QLf4/BXypAQQxzl0GPzO7aaduuUM0U0I/KxotkkgWoURuaCQzedIiSRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=guch9t/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="guch9t/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF36C433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998956;
	bh=P6dT2IrOzvHkh0DUIgtUXOIUjL8DP7i7+uZNjtnqZio=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=guch9t/X06Fr5ea/azhETxeLmuOGryBHyN2ACH3eWvpsoHEsjkPOTydZl+NjJlZpU
	 9a/JAOkaNf0Cm7nbuGg0nqisJ+rEVE7j8/mVZYvk0e6KHTrSSTDWb3wOaUfB9yGQRS
	 ClPcivDJkVc/6RV/Hq/28dgIAUU1HeZmGnFSw5ukVC+piAIJXA0iPV36Dxv1SBmAUY
	 SQM9f7l8g63KCra4AqiMePk09lIRP/YPW+2WHoFe+WbogDdlJl/4iT4pB5PgClMvp5
	 bNpDURCVJxAbjS/E/s7Kvijec3qFUsFYZB4pWU5wWKFDPD/+5NP8AEMRoSR2Umi3zo
	 OYXgSZn3f4/Hw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 02/35] xfs: hoist freeing of rt data fork extent mappings
Date: Thu, 15 Feb 2024 13:08:14 +0100
Message-ID: <20240215120907.1542854-3-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 6c664484337b37fa0cf6e958f4019623e30d40f7

Currently, xfs_bmap_del_extent_real contains a bunch of code to convert
the physical extent of a data fork mapping for a realtime file into rt
extents and pass that to the rt extent freeing function.  Since the
details of this aren't needed when CONFIG_XFS_REALTIME=n, move it to
xfs_rtbitmap.c to reduce code size when realtime isn't enabled.

This will (one day) enable realtime EFIs to reuse the same
unit-converting call with less code duplication.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/libxfs_api_defs.h |  1 +
 libxfs/libxfs_priv.h     |  1 +
 libxfs/xfs_bmap.c        | 19 +++----------------
 libxfs/xfs_rtbitmap.c    | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 04277c009..a16efa007 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -176,6 +176,7 @@
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
+#define xfs_rtfree_blocks		libxfs_rtfree_blocks
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
 #define xfs_sb_read_secondary		libxfs_sb_read_secondary
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 5a7decf97..21d772cf4 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -497,6 +497,7 @@ xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
 /* XXX: this is clearly a bug - a shared header needs to export this */
 /* xfs_rtalloc.c */
 int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
+int libxfs_rtfree_blocks(struct xfs_trans *, xfs_fsblock_t, xfs_filblks_t);
 bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 
 struct xfs_rtalloc_rec {
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 2bd23d40e..5744b882b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5050,33 +5050,20 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-		xfs_filblks_t	len;
-		xfs_extlen_t	mod;
-
-		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
-
 		if (!(bflags & XFS_BMAPI_REMAP)) {
-			xfs_fsblock_t	bno;
-
-			bno = div_u64_rem(del->br_startblock,
-					mp->m_sb.sb_rextsize, &mod);
-			ASSERT(mod == 0);
-
-			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			error = xfs_rtfree_blocks(tp, del->br_startblock,
+					del->br_blockcount);
 			if (error)
 				goto done;
 		}
 
 		do_fx = 0;
-		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
 	} else {
 		do_fx = 1;
-		nblks = del->br_blockcount;
 		qfield = XFS_TRANS_DQ_BCOUNT;
 	}
+	nblks = del->br_blockcount;
 
 	del_endblock = del->br_startblock + del->br_blockcount;
 	if (cur) {
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index bc8312caf..2c20c6538 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1003,6 +1003,39 @@ xfs_rtfree_extent(
 	return 0;
 }
 
+/*
+ * Free some blocks in the realtime subvolume.  rtbno and rtlen are in units of
+ * rt blocks, not rt extents; must be aligned to the rt extent size; and rtlen
+ * cannot exceed XFS_MAX_BMBT_EXTLEN.
+ */
+int
+xfs_rtfree_blocks(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		rtbno,
+	xfs_filblks_t		rtlen)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rtblock_t		bno;
+	xfs_filblks_t		len;
+	xfs_extlen_t		mod;
+
+	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
+
+	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	bno = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	return xfs_rtfree_extent(tp, bno, len);
+}
+
 /* Find all the free records within a given range. */
 int
 xfs_rtalloc_query_range(
-- 
2.43.0

