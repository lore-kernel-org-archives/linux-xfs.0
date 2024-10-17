Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259A613C816
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191618; cv=none; b=Gc3hDDC2NI5MwrulXtSZyFyszazD2tb7Y4IZ5K+TtV24sVFgUcylPjuobHaLk9ff715byYCnBemHBDRO5mNRq4NZgWG6YESRgUgt/jaZplMOV9qQvo0NsOIw9ondzLi/ClFuoVK/1dfVkc32apDsJSUQEB7ZTFgcQrnI1goMq6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191618; c=relaxed/simple;
	bh=xBdaex7PjEDm3oXCeICK/0fU02ipRbIwueO+KvyDAJI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fp32HwlEf+7SEJEUdlxZ4Z04rNxxji5NtlHLXz5eZ0Wn8u7lflFharWJuxRp0hFcqDGdS0GW/ZmslNbNOhip1KM6N+A17AvrDRbF+tlwluXNjnylIbd7KbnfRjr736F6s6f+rpCgHi5gD4y4fR+oz9CEcTtTr2VWfwYnqdFxbs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gky05b5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gky05b5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CC6C4CEC3;
	Thu, 17 Oct 2024 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191617;
	bh=xBdaex7PjEDm3oXCeICK/0fU02ipRbIwueO+KvyDAJI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gky05b5IfR6VYGhdpAjcnoSbJaG8tBtSeo/Sprs7IcAdOv0SFDxY+NmbFoMcswfW6
	 tg3kMEh1gvBspNRD/yHP/fhFshtDZUsBbgs+Ck0Tp75dA/FyJezVOc9GGyRrqZ6TOQ
	 WNS6GF05GF6Ef/pTyeuQL89+aTKyF7kkOoZOKBNIL65RZjfKmlYQwmIdJqOE6nPWYa
	 YI65rbYOxde+Lw8udn/ez+lPnYF0w/nkAYdFZv591CgeOCvKeKk1QuQa8VJt+ylrho
	 Si2Vv9e+7hYd9a88KdzdM4SPTazndXDouShq1W4NR34c9VdPI/baXUAorFkYBhvxgL
	 TFRnvuKV9Pg0A==
Date: Thu, 17 Oct 2024 12:00:17 -0700
Subject: [PATCH 03/21] xfs: define locking primitives for realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070448.3452315.16472809720729059537.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rtgroup.c |   48 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |   16 ++++++++++++++
 2 files changed, 64 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index d91b6a3b091c9a..e3f167ce54793a 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -150,3 +150,51 @@ xfs_update_last_rtgroup_size(
 	return 0;
 }
 
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

