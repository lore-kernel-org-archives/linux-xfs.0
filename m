Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBD513FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991672; cv=none; b=YLoM0jrYXXm8aMp+TXN+vTAClxEdgJ0BVFhyen1gFEZ131rdyQABZWh1rZNdcTTmEASoguTqvBhzgBSs5A/hp703n4bl1fDX1QQAWXluQGASgoLjJBxRy5LkSkUBHrWUAnrQmlmuCdUjdS35csNo0WLgoILcxM+QnfirVCsIbKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991672; c=relaxed/simple;
	bh=E72fAjgI2CfHaWZJDt2ki9/exOap9xdRFYDIxFhgfpI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o2C1xDODQdkVPepydgfYXASiMT6E3+Vqkm9mDylpvxZSgm+0uN4bq3KU8KC4xQ1qEmU+P0m8fe9hUHMO/t6dm38DPUlpmcyQdogKpaHkw/cGBBo87L5lLSfKtjrK6pFS/KE1SFXuhyuTuI9BZDqwZKSW4gCjqdfmly90N221Ohw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9Ac+wKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9Ac+wKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD78C4CED3;
	Mon, 23 Dec 2024 22:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991672;
	bh=E72fAjgI2CfHaWZJDt2ki9/exOap9xdRFYDIxFhgfpI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y9Ac+wKcxsiTX9I2QDlArZ0l7JEky25yNlTkO+n8yOClCyg/ij6uN770GsGOYeLpg
	 j9Hhk9gmobhY5YmIX2OVdonUDMEEHBOV2fJgoQjp660wPJL9A9wm7pmz4KmLERwUxN
	 kvogFARqzM0VcX5OBG+NYCHsFWjMPJwMX3T2Bu6+n1AELEHEI8A9n20QoU9TJ93RMf
	 7MmPXb2sYZe4HJq7iIYszH8ON+gG6WVs4B9nnPa7UsdHQYzMCM4m8SiXbr0Jz9CsVt
	 gmAHPjhw9FdtfJjO7SBuCVODCb1VbGFdVN/CVUa6P6rjKqbUhrJeZFfEAjVA84sY7E
	 9H7oGPRf6aq2Q==
Date: Mon, 23 Dec 2024 14:07:51 -0800
Subject: [PATCH 37/52] xfs: implement busy extent tracking for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943064.2295836.11624009989431510325.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
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

