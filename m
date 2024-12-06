Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022F7148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529114; cv=none; b=WD0N+bUMRVcLVaYkIJhdo+o6W0bwvQI5impRtLm5AvxC08InGWQCyN+zDK0o3T22xWv+XygU3CLpHXuC3dBIgPRz+oeWpmP5Cb+u1RgSw5hKdV6h2u3QSvPXroXaET/+czxS5BFKw+icFm9v1hbrMZJWiujzkqkem241ic75dQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529114; c=relaxed/simple;
	bh=S6ddG994yt+beO0CI6KqzWMf6cKai5DRlTmNSVCSxwY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0qb+qQ35lFymRfS+5zXsmz/yAySddTDD/oOSGgtFA7b7pU1UISBvL3qOHG2MkaqJPkpaOfFaFQgs0wwWWmhp6R5fToY/15OJU74SKbKtWxzCdNA054gk15Lm9joLSfyvyh3IK1apXMV6OM4a4ZoQa+M0czLheEUxAhBm0itDtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=swyNB0xZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="swyNB0xZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7CFC4CED1;
	Fri,  6 Dec 2024 23:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529113;
	bh=S6ddG994yt+beO0CI6KqzWMf6cKai5DRlTmNSVCSxwY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=swyNB0xZeOn4zts4gJmagTpGI08vKsw4ooNZiRVaBzrbrnHLHtjMPrjDCLpBr5cyO
	 2lOT5nvGFpIq19IJcO1Ym8x+/swa5TujqfG4UrCro0YePIee3aHq+wLeHPtTrclRoj
	 JnPHknIQ3I6aaR57bcnN43Andw/d+I/U7yRfzp/bEh/txjWPD8TbtSzkWtO0AuvCO7
	 lTheTsE0bEiFhRolgjQ6JU0cGbFsQnnlTgPL/RbwoSfA595Ui1HMMtR6VWFf/tFFf6
	 IcG421uJdxKA9/A0uxucE1QHh8DVPd+bv76dQ4+CFdKga1rROOsb5WVZ2REzcl649c
	 2npUv27GhhCPg==
Date: Fri, 06 Dec 2024 15:51:53 -0800
Subject: [PATCH 02/46] xfs: define locking primitives for realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750025.124560.3938992792228394642.stgit@frogsfrogsfrogs>
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

Source kernel commit: 0e4875b3fb24c5bfdf685876c76713cda5a23b65

Define helper functions to lock all metadata inodes related to a
realtime group.  There's not much to look at now, but this will become
important when we add per-rtgroup metadata files and online fsck code
for them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h |   16 ++++++++++++++++
 2 files changed, 65 insertions(+)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 88f31384bf6961..5c8e269b62dbc4 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -147,3 +147,52 @@ xfs_update_last_rtgroup_size(
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
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 8872c27a9585fd..7d82eb753fd097 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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

