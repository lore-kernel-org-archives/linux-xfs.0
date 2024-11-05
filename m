Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3855F216203
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845483; cv=none; b=Usf7XQqpkO3yRXGpvw1sc9yUwH8Av1Wc97zgaNjACaKwi7H+h4Z1SL65XTUGL6KT1ISbmg/IZSREwPPcJIBTtIVQyI8d3SjubmIAWt+dPYc6ljaxd2JTUfSZCJBQbKSQ9xWCq1x1RDarqIFRjv27J80bbAoRVE0zvqgoVNOWt7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845483; c=relaxed/simple;
	bh=DtFIAKKXB9vJdADfLjkG594GxD3LP3Iat3kRBf+34Sc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nbLjWZNenjNbvJ2n/ZMrQK4m4CpACvuN6e2k143cmcC+mHfV/ZXd6umwjT7tIqQack+XmyeSL/0J8pt0EFAcW3+hPx7pT+Zgh33MJzB3X8MEM9BFSzVlshY8kWXLcKLgJu2B4ECEZee6CiiIhIRYA826+PepbH1mXBR18jXalNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUzfWFeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUzfWFeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD28C4CECF;
	Tue,  5 Nov 2024 22:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845482;
	bh=DtFIAKKXB9vJdADfLjkG594GxD3LP3Iat3kRBf+34Sc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DUzfWFeKOEAlJWPBMETFxizT3PJUB4sG9RlejuAIpYjz//TJOfJYljnEIu7FlSnQe
	 GMTrReCYS934RIjY+tiSdkruITq77Odgn/98Y4zEyoHSdVcAAO6yLoiPwAVltHcPdt
	 PhZKE/fi2wlYas5Jm6wUA0TpY9yRefS5/HwolVSbFoFM9Aa7Eek5qAJGyP9rL8f7fg
	 vxNSGMSI6HB/ZgS6m9+02CG3KqpZsNNFj+yuVOEoz1+TMnBRwcMr0lHCOXCX5Mn/y1
	 H2nUGTnwkfVp1kLbLfwIi/eI2CNHXAVkYAq2v/CaPQc6aIU7KsIQTv+3Jpq+OXZjAA
	 YupULFAmBbKXg==
Date: Tue, 05 Nov 2024 14:24:42 -0800
Subject: [PATCH 03/21] xfs: define locking primitives for realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396991.1871025.1129084785665818119.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Define helper functions to lock all metadata inodes related to a
realtime group.  There's not much to look at now, but this will become
important when we add per-rtgroup metadata files and online fsck code
for them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c |   49 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |   16 ++++++++++++++
 2 files changed, 65 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 9d3842e83c9366..e3f167ce54793a 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -149,3 +149,52 @@ xfs_update_last_rtgroup_size(
 	xfs_rtgroup_rele(rtg);
 	return 0;
 }
+
+/* Lock metadata inodes associated with this rt group. */
+void
+xfs_rtgroup_lock(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		rtglock_flags)
+{
+	ASSERT(!(rtglock_flags & ~XFS_RTGLOCK_ALL_FLAGS));
+	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
+	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
+
+	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
+		xfs_rtbitmap_lock(rtg_mount(rtg));
+	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
+		xfs_rtbitmap_lock_shared(rtg_mount(rtg), XFS_RBMLOCK_BITMAP);
+}
+
+/* Unlock metadata inodes associated with this rt group. */
+void
+xfs_rtgroup_unlock(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		rtglock_flags)
+{
+	ASSERT(!(rtglock_flags & ~XFS_RTGLOCK_ALL_FLAGS));
+	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
+	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
+
+	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
+		xfs_rtbitmap_unlock(rtg_mount(rtg));
+	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
+		xfs_rtbitmap_unlock_shared(rtg_mount(rtg), XFS_RBMLOCK_BITMAP);
+}
+
+/*
+ * Join realtime group metadata inodes to the transaction.  The ILOCKs will be
+ * released on transaction commit.
+ */
+void
+xfs_rtgroup_trans_join(
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	unsigned int		rtglock_flags)
+{
+	ASSERT(!(rtglock_flags & ~XFS_RTGLOCK_ALL_FLAGS));
+	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED));
+
+	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
+		xfs_rtbitmap_trans_join(tp);
+}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 8872c27a9585fd..7d82eb753fd097 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -197,6 +197,19 @@ xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
 
 int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
 		xfs_rgnumber_t prev_rgcount);
+
+/* Lock the rt bitmap inode in exclusive mode */
+#define XFS_RTGLOCK_BITMAP		(1U << 0)
+/* Lock the rt bitmap inode in shared mode */
+#define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
+
+#define XFS_RTGLOCK_ALL_FLAGS	(XFS_RTGLOCK_BITMAP | \
+				 XFS_RTGLOCK_BITMAP_SHARED)
+
+void xfs_rtgroup_lock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
+void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
+void xfs_rtgroup_trans_join(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
+		unsigned int rtglock_flags);
 #else
 static inline void xfs_free_rtgroups(struct xfs_mount *mp,
 		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
@@ -212,6 +225,9 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 
 # define xfs_rtgroup_extents(mp, rgno)		(0)
 # define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
+# define xfs_rtgroup_lock(rtg, gf)		((void)0)
+# define xfs_rtgroup_unlock(rtg, gf)		((void)0)
+# define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */

