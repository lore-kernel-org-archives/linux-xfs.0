Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327DC18052
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990219; cv=none; b=acGUX/3bR7QlYKyTK7JuXXVRB9MCGeZhxt6Ro6AcbAWT7Ns1tvvlpC2qdwqGboJ9jeeKuIkxNEIMdItuCjPd94xl6+DVmgn7ugBZH3C+SC2Zj222iD3/r6VPggsNO+1U5Epjq8PvqhzkLXtk9PP3WhBtr0mUNNUfugpov+zv+Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990219; c=relaxed/simple;
	bh=1d92ETI48XjwEGT6jL2iA0Jzg/O6AraTWo+HLjkSJn4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MPFr9nucw9UN0xYMjTP0VRFIZnOorUEnrXSqSS18S7fdiUPWOpgcx/iWC+RWJpGcl7c+eUafBG/sQXmpqCz32aGppBovPA/XMLWQrGWRA0eIH3Uj9DEAimXJB4JV1H/cFsEfQTMZwuV7cnvQ8UNi/RIVWHdiqvzIdaoTlQmWyjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZcRWGe0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZcRWGe0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C05C4CED3;
	Mon, 23 Dec 2024 21:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990218;
	bh=1d92ETI48XjwEGT6jL2iA0Jzg/O6AraTWo+HLjkSJn4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZcRWGe0/u7Cj6BtOrjE5JtUMBUU5gP7bs6nBhcu7+Dj3cCa/p+OoNmFt2r6lD1FUv
	 XXaa4Qd0/HoQ8qSJ/s7qaV6o2jLJootIgKoBn9TCI5NUYXft/d4XCXRinxJ3YKG5CF
	 Xe2rJdjw6nQyphZ0PIfMndA0udIIkTHFahNo9ZuVxSgY/GPHSpsktKxJduOPuICF6u
	 6PHqrHun67g9gCBDqGCgF29cFWuREvIv6gKhbREhw6Q3r7vW8kqdLTHgE2ryLFEj2w
	 2pIBM5V4oGP9HLRy2jfXWwdEn10k3rxZmof9eLHNiB2Slfrlbt1UmVUtQuOC6di5p0
	 09YtAB4ruQEMw==
Date: Mon, 23 Dec 2024 13:43:38 -0800
Subject: [PATCH 25/36] xfs: constify the xfs_sb predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940325.2293042.16990305927580033879.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 8d939f4bd7b225d8b157b1329881d2719c0ecb29

Change the xfs_sb predicates to take a const struct xfs_sb pointer
because they do not change the superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index e1bfee0c3b1a8c..a24ab46aaebc7e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -278,7 +278,7 @@ struct xfs_dsb {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-static inline bool xfs_sb_is_v5(struct xfs_sb *sbp)
+static inline bool xfs_sb_is_v5(const struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
@@ -287,12 +287,12 @@ static inline bool xfs_sb_is_v5(struct xfs_sb *sbp)
  * Detect a mismatched features2 field.  Older kernels read/wrote
  * this into the wrong slot, so to be safe we keep them in sync.
  */
-static inline bool xfs_sb_has_mismatched_features2(struct xfs_sb *sbp)
+static inline bool xfs_sb_has_mismatched_features2(const struct xfs_sb *sbp)
 {
 	return sbp->sb_bad_features2 != sbp->sb_features2;
 }
 
-static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_hasmorebits(const struct xfs_sb *sbp)
 {
 	return xfs_sb_is_v5(sbp) ||
 	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
@@ -342,8 +342,8 @@ static inline void xfs_sb_version_addprojid32(struct xfs_sb *sbp)
 #define XFS_SB_FEAT_COMPAT_UNKNOWN	~XFS_SB_FEAT_COMPAT_ALL
 static inline bool
 xfs_sb_has_compat_feature(
-	struct xfs_sb	*sbp,
-	uint32_t	feature)
+	const struct xfs_sb	*sbp,
+	uint32_t		feature)
 {
 	return (sbp->sb_features_compat & feature) != 0;
 }
@@ -360,8 +360,8 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-	struct xfs_sb	*sbp,
-	uint32_t	feature)
+	const struct xfs_sb	*sbp,
+	uint32_t		feature)
 {
 	return (sbp->sb_features_ro_compat & feature) != 0;
 }
@@ -387,8 +387,8 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
 xfs_sb_has_incompat_feature(
-	struct xfs_sb	*sbp,
-	uint32_t	feature)
+	const struct xfs_sb	*sbp,
+	uint32_t		feature)
 {
 	return (sbp->sb_features_incompat & feature) != 0;
 }
@@ -399,8 +399,8 @@ xfs_sb_has_incompat_feature(
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
-	struct xfs_sb	*sbp,
-	uint32_t	feature)
+	const struct xfs_sb	*sbp,
+	uint32_t		feature)
 {
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
@@ -420,7 +420,7 @@ xfs_sb_add_incompat_log_features(
 	sbp->sb_features_log_incompat |= features;
 }
 
-static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_haslogxattrs(const struct xfs_sb *sbp)
 {
 	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
 		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);

