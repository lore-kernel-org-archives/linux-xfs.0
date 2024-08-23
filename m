Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F8FB653
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372267; cv=none; b=OfGNXBeVzUQrRjkP6pdwoGpqnj9rkTVKsxkSiLdfHGLz/yyh9P9pMCiTY4sqZkj7xBfqlVWY5zss7hHrQ6L4mcRzxUyz6VwojqG33Em+dJeKHCodK7TzTkPGEcVxZOIt05/+7za+hZMVkSUpZ+lkUjAV+fe+lSq2LdvobNo+99A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372267; c=relaxed/simple;
	bh=sB6tRoLmmWP0MZVCKWyGNlT8hqw3pXXpHcs4QrfsEl4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PvSUAUSXvKioYRNCBkoUNgGjJwKxgeTjJZTnn4UhdhuaLCKoVdzbNJMYfjmFxX/YIgydHyj+/Psbn7Si+3eYgO9ThC7y7cmQSFBSOLc9s4rFi229QbYzy++IkN7W8EgmgZHRBLPvyj7S6yrnilKc0Uo/cQfSb8yT4Mh3VbAutGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tkXsVsIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tkXsVsIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804B9C32782;
	Fri, 23 Aug 2024 00:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372267;
	bh=sB6tRoLmmWP0MZVCKWyGNlT8hqw3pXXpHcs4QrfsEl4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tkXsVsIJiRvPHMkf8jZC34ciSJEQk4vFCKG1sTH00q4T4NytuHTkKv0uBu5gK4g2X
	 Al4HUSddDHSPvPE/0mWycbgvFdqBnYGFkb4rDiE29OE0x1cL2AIHzO59z2gJ74UNI5
	 pbxEQCoH8QluspjO9dibpNL7lUDBHutl/cO314uTFY2dhCV/yYmSpFBPSOrGbZ1aIW
	 +nuwF3bg5y0eV2P9TWiYFGX17vHsay8AjaW/uHFEF/ggLVPxuX6kgjzS6TiLXjhTPB
	 KcXBUBkkxaXDOZYHX9W6kWBOhQY2qLzdlHeIKp7uQUKh7te4pBqlr+GAVinvrZCXnh
	 QyLP68VG51A5w==
Date: Thu, 22 Aug 2024 17:17:47 -0700
Subject: [PATCH 12/24] xfs: define locking primitives for realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087452.59588.12210244336745998210.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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

Define helper functions to lock all metadata inodes related to a
realtime group.  There's not much to look at now, but this will become
important when we add per-rtgroup metadata files and online fsck code
for them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.c |   49 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |   16 ++++++++++++++
 2 files changed, 65 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 2bad1ecb811eb..51f04cad5227c 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -194,3 +194,52 @@ xfs_rtgroup_extents(
 	ASSERT(xfs_has_rtgroups(mp));
 	return mp->m_sb.sb_rgextents;
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
+		xfs_rtbitmap_lock(rtg->rtg_mount);
+	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
+		xfs_rtbitmap_lock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
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
+		xfs_rtbitmap_unlock(rtg->rtg_mount);
+	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
+		xfs_rtbitmap_unlock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
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
index 2c09ecfc50328..d2eb2cd5775dd 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -205,8 +205,24 @@ xfs_daddr_to_rtb(
 
 #ifdef CONFIG_XFS_RT
 xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
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
 # define xfs_rtgroup_extents(mp, rgno)		(0)
+# define xfs_rtgroup_lock(rtg, gf)		((void)0)
+# define xfs_rtgroup_unlock(rtg, gf)		((void)0)
+# define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */

