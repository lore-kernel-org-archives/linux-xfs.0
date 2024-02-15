Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A2D12AAD0
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998981; cv=none; b=NnvJfoqppAKUi/R98T8LCn6YjNonQx1fzN+PSsaitimNNPNbgngqdd7iUP4TuOClRcjBwb8Icg6b+7FprSQ9C4lnhdRPNN6hQgclRH4AjglsCKLfx2plrMXssQ7z5rNIQmFqLFsG1YN6W6kWiSJ7ycbMabXkjL27GoA69NK/Xzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998981; c=relaxed/simple;
	bh=2xEh/EpLrzrAQCmFKqLpJt2vP+35rnPX9Dqa0wjGYww=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbqZ8f3rO/ehRZogA64n51/m3kToTruH/kYdVD6g+QFS3kgrd3xQ8PXf479o/srLtRleDbB6z+swjFAyrb9mWUca4aT2Pi82qrrHhXOvMnuAgMnOWewD6n5pb7wsr1oRXHgXR5UewuGQYPmCFiLmIVgvgOn2qU0DmsHF2CBOwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUAihS7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUAihS7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC84C433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998981;
	bh=2xEh/EpLrzrAQCmFKqLpJt2vP+35rnPX9Dqa0wjGYww=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZUAihS7AYBzQHB20nPbKA+PAkweP6grT2CmpkC3htlD/gEl3+azZ8kHrpIdntGTkq
	 dd3c/dCWRp/t+tQ1AbUFaZw2TQe8YzE1mt0blCl9T8D91ooBapl4nBz2YlW9flbhq+
	 8mQe6PTSnnGCwTW96OLzK1Kib/B265P4yozPEqrh7K1ZfxHJU1vg8Hc6MrwreSYG0Y
	 NpbXfnrBIGOYKRb8rHIJrdqUk+dOPYfvHRLgC9aFdfTi2A8hMS+z9ksCay4PwYwZSq
	 w/p+5qOdI+tTAQ7iQSJkJ5ZdZlXrIflbzXB5CHdr7e0EdxVY7Rt6LzgCHkmvSRwxV4
	 KibM6bKQE6MBg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 25/35] xfs: create helpers for rtsummary block/wordcount computations
Date: Thu, 15 Feb 2024 13:08:37 +0100
Message-ID: <20240215120907.1542854-26-cem@kernel.org>
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

Source kernel commit: bd85af280de66a946022775a876edf0c553e3f35

Create helper functions that compute the number of blocks or words
necessary to store the rt summary file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 29 +++++++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h |  7 +++++++
 2 files changed, 36 insertions(+)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index f7be9ea5f..44064b6b3 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1148,3 +1148,32 @@ xfs_rtbitmap_wordcount(
 	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
 	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
 }
+
+/* Compute the number of rtsummary blocks needed to track the given rt space. */
+xfs_filblks_t
+xfs_rtsummary_blockcount(
+	struct xfs_mount	*mp,
+	unsigned int		rsumlevels,
+	xfs_extlen_t		rbmblocks)
+{
+	unsigned long long	rsumwords;
+
+	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
+}
+
+/*
+ * Compute the number of rtsummary info words needed to populate every block of
+ * a summary file that is large enough to track the given rt space.
+ */
+unsigned long long
+xfs_rtsummary_wordcount(
+	struct xfs_mount	*mp,
+	unsigned int		rsumlevels,
+	xfs_extlen_t		rbmblocks)
+{
+	xfs_filblks_t		blocks;
+
+	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
+	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
+}
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 02ee57f87..62138df6d 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -311,6 +311,11 @@ xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
+
+xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
+		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
+		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -325,6 +330,8 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	return 0;
 }
 # define xfs_rtbitmap_wordcount(mp, r)			(0)
+# define xfs_rtsummary_blockcount(mp, l, b)		(0)
+# define xfs_rtsummary_wordcount(mp, l, b)		(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
-- 
2.43.0

