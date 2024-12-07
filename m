Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C0217FE
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529661; cv=none; b=tgyUJo1zUi72c/vd9bOgaWRt4PMCD/quwzVUUf5e4i/D2DFbCLYI9OHTETswpDPjgIqzWkjm8U8ude/KovttNC2SAYo9csv8JGGEjLK+E0Dr75AHt6q6jR49woza+ZFFoZEJqulNFSvgM0U/SBElYkpnQOcMp+rygmTZHUMlboE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529661; c=relaxed/simple;
	bh=E72fAjgI2CfHaWZJDt2ki9/exOap9xdRFYDIxFhgfpI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IwG6Nn0OCDanTkVK6yaFWSz+uInJX94vUWTRZ026qlrPtzFNQ0Pf8TwSJwfprQ1TwAVFA24e8pjxQh0GybB4uf8gSmJXkrZFVyxrkSu5t2MB45bU91/k9NYvXgdl46fMN/iqOmsS1/6T5thjEMMmCO9EcvwgeIv+YVcfRT5en6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=banP+iU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="banP+iU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78972C4CED1;
	Sat,  7 Dec 2024 00:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529661;
	bh=E72fAjgI2CfHaWZJDt2ki9/exOap9xdRFYDIxFhgfpI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=banP+iU3u8nNXAL3R3iBQ2Ev8+Il1+ljR20Wdtm/Dts1iFpJ8bAB6R10G1gt7oX+J
	 JGH+t+T4EfCjdP9vGUKjEc7Ujc3d6pONOcKPLAHbto2Pm4K46oAxGUd1SYGd5x04pt
	 YWpTYHsPlhpqcVC7fjr9YWxirePrXntNHCFW4Y+O6QMVLvMBYTokd2ih65lsfKwMDr
	 8gso1HdZS4YOzhl5f0qMZz0Dlol6l7FZ8lXDQQ6RHw4KMrClzHH1MlNEwao3+3lYKI
	 Y9+QlZ5AJWWki1ZOaakgn+r7HoBPMaW3oVvlgOm+KdRkH7P62zN3uFcM3JXkmWAvMJ
	 M5um1uYYUBFzA==
Date: Fri, 06 Dec 2024 16:01:01 -0800
Subject: [PATCH 37/46] xfs: implement busy extent tracking for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750560.124560.15845919014551479048.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 7e85fc2394115db56be678b617ed646563926581

For rtgroups filesystems, track newly freed (rt) space through the log
until the rt EFIs have been committed to disk.  This way we ensure that
space cannot be reused until all traces of the old owner are gone.

As a fringe benefit, we now support -o discard on the realtime device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.c |   11 ++++++++++-
 libxfs/xfs_rtgroup.h  |   13 +++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index e304f07189d3c9..b439fb3c20709f 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1116,6 +1116,7 @@ xfs_rtfree_blocks(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	xfs_extlen_t		mod;
+	int			error;
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
@@ -1131,8 +1132,16 @@ xfs_rtfree_blocks(
 		return -EIO;
 	}
 
-	return xfs_rtfree_extent(tp, rtg, xfs_rtb_to_rtx(mp, rtbno),
+	error = xfs_rtfree_extent(tp, rtg, xfs_rtb_to_rtx(mp, rtbno),
 			xfs_extlen_to_rtxlen(mp, rtlen));
+	if (error)
+		return error;
+
+	if (xfs_has_rtgroups(mp))
+		xfs_extent_busy_insert(tp, rtg_group(rtg),
+				xfs_rtb_to_rgbno(mp, rtbno), rtlen, 0);
+
+	return 0;
 }
 
 /* Find all the free records within a given range. */
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 1e51dc62d1143e..7e7e491ff06fa5 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -155,6 +155,19 @@ xfs_rtbno_is_group_start(
 	return (rtbno & mp->m_groups[XG_TYPE_RTG].blkmask) == 0;
 }
 
+/* Convert an rtgroups rt extent number into an rgbno. */
+static inline xfs_rgblock_t
+xfs_rtx_to_rgbno(
+	struct xfs_rtgroup	*rtg,
+	xfs_rtxnum_t		rtx)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	if (likely(mp->m_rtxblklog >= 0))
+		return rtx << mp->m_rtxblklog;
+	return rtx * mp->m_sb.sb_rextsize;
+}
+
 static inline xfs_daddr_t
 xfs_rtb_to_daddr(
 	struct xfs_mount	*mp,

