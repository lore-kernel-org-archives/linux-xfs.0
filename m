Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257D81FC7E9
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191289; cv=none; b=CjgrVtpEMez75XVaBGbQrPvrjEMHk4u27GwlGOxRCfUBL8RXipLry2GLr7K60+TLx0PE97ZXRWb+1ZJV8m8oXNsOZ9s0U4mUtYJ05+LlAUBig/Sql3nigCZmPFntPUs3+J+e0GfbPAH3OXjy6T+hzCSEHZdpJMTp0IEH9u7JLkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191289; c=relaxed/simple;
	bh=fQbc9Hm97bfXL4i4dCDUavAwYd6sQ5+xGNBqNeU6W4c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/nMbEpmBc9TmXbb2JBYSbMj8UUudJqlY8EaXaByu1xTlJAypWVRrV/DfSJLjGvWE8Vgxocu3SUonHhKAlgcp6ah6v4KUb8ibRd8cA5YDEX5xdDo5z4iTseV+cfJfVCgXg8FuyvaYmUl10VqP56xFIyh/1xSOuq79+sewPTuPMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHrGGXmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHrGGXmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F152AC4CEC3;
	Thu, 17 Oct 2024 18:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191289;
	bh=fQbc9Hm97bfXL4i4dCDUavAwYd6sQ5+xGNBqNeU6W4c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GHrGGXmRLHvkTKOlXZgofZln61yENPVoTrARHN5FFi5lLF9DcULCJdJah/FPxAc+b
	 3a1BItm3OohjAPeR6wX6S/+33FAUoBXjdZrBZfDJoQj88yj36dTKy1bma5V6onRWF/
	 6rzElxf/q5B/tPHbQICYX6wwnuE8U2/6drdIivCipDJLxr2bIcLl/e1tHRk3eUZC5W
	 wlA+5REeqqjeZEVMmZPl4x0FEnl9c8i9YHtXySIEEPDL4FUzTOPJuZxJQEyqoFVUUc
	 Pz48krb1wZq3uTl+ziSaUgBt3eiURVODwTz86LEl6SlffEczo79X6vOLaaE+7IXu8i
	 tXmlBtRcbVU+w==
Date: Thu, 17 Oct 2024 11:54:48 -0700
Subject: [PATCH 01/29] xfs: constify the xfs_sb predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069461.3451313.5904109209563595140.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Change the xfs_sb predicates to take a const struct xfs_sb pointer
because they do not change the superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e1bfee0c3b1a8c..a24ab46aaebc7e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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

