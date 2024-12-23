Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C89192B69
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991125; cv=none; b=undjIZsG4h4b0OpIantK0fOHMMrtthpqHSX3vATvXMX9wAiDzSxGedOY2DYkpp5rz3rWFfSCyqY7A0AoVLM6I0ji19Tn3gbJAwgpTNLI/6spN4ejRcuD3rn4B+gtpqYYAt/+s14mMd90f4ewycBD6ooWunFnQhKX/IBfVn+yEx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991125; c=relaxed/simple;
	bh=S6ddG994yt+beO0CI6KqzWMf6cKai5DRlTmNSVCSxwY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=raxAkNZpUu0O9qXO60HXDKMhDWB12YRPVcj76MepMXaKmaDC0IuaCmunNKps25gDFj4M5k5BcCxW1J28L7iszfJG/vgKLJMulNcSSFIK1a7XlELT4cxkyJaD8belcRynr1C229M+ZLHf86MjeerOv24mvVvExD/f35L/stQgE9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVJkLFaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVJkLFaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FF7C4CED3;
	Mon, 23 Dec 2024 21:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991125;
	bh=S6ddG994yt+beO0CI6KqzWMf6cKai5DRlTmNSVCSxwY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WVJkLFaSqvFUtDMIXboNKZ2gdRV3PzV0+14qm67oiPXr+fFyOa9uaMp2UGFahGYBq
	 ooiUsosPpSmhqj2lFLmQTrStCdwJYcStvQMKV7wWMTaP0DYCj2B/tkDOOPWe6a1WB5
	 dw7IL+97dtLNfkelGjYtEON6g8ATY/tDqTSSIBJh8d9njIsNtWCaCplOPatQqBIGg6
	 KyhxLWlERAPvBYfACDDCKi4dz/nrdozpDlVulZEG01PZZ67h24JDRBwagOdgn31dxa
	 0LzHIBTNQtz2XuWU5l8mUkV3Qzro+4FSoOOgaj0lLo21ugDUCFxbh+XgCBY4GO9A5H
	 pK766Q7WE8VLg==
Date: Mon, 23 Dec 2024 13:58:44 -0800
Subject: [PATCH 02/52] xfs: define locking primitives for realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942526.2295836.7129725188366826710.stgit@frogsfrogsfrogs>
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

