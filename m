Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003862107
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607719; cv=none; b=uibL6+BH+mXyXW13kCXar/x2jdAjvmK6TiR60KFVk3zw44k/BzhkimjKt5RiTq8KIznnFgY8yMGOs30U9BRrxY2b9ass1Tk9A7XTJ8RPFq4OA/Wkjl0ICsTp1sgRUGRsEbYBYMycfsTG0taTpb23F46HMnOWJ+syvh0Emwlqr5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607719; c=relaxed/simple;
	bh=MOCENxklL0NCYiTyOYMnZfq/OlGDAp1rb6DEmVgWnc4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJIMJHLz5pZUy5ZOWqoOSRwa78egJ1whSJ0eBpRIbJKU4vkg6Nli1CUvY/OPqSlp3EyXkh5VF7eg9JrIx+T/UP/D6YCUaRSG6fCSIN4qxtczIPrt/oww2mFt8mppz20CC51kYw2ahIVTQ8FjxbERDdVBt036lRuX/PS5NE116W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+AkjlHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+AkjlHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0F0C4CEC5;
	Fri, 11 Oct 2024 00:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607718;
	bh=MOCENxklL0NCYiTyOYMnZfq/OlGDAp1rb6DEmVgWnc4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T+AkjlHkGWmtLXwzIo2yVHSY+o/9noWeLRcALEpkRxbzOYoEIUj1KhgzLx0Z0yNeR
	 raHLOCPDZr6H3JPs9yVQm5JbVBCc0e5W5skbA4kR1qdXVBJBPEQOQ2LSx1UOhF4736
	 Eq6H3bxWdD3FjE1hwDr4IJKQ7bv7Mzy/lzfuZCiaJ/BR5ml8bXd/pf2g1jCr6rkSKO
	 qV5hX0Kj2LKKZVKFruD0pqpafGKqpbvRws0uopL40bXF8wl38TXGCPop4lfOesYZqb
	 LaRgjhK3QUgtYYajZmqAXBMotO46Isj2bNtWyH0ukzcB0T5z1n0YR0FDHh5hYgyhwc
	 eb7xYeo2LLtfg==
Date: Thu, 10 Oct 2024 17:48:38 -0700
Subject: [PATCH 01/28] xfs: constify the xfs_sb predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642030.4176876.2795384731737477942.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

Change the xfs_sb predicates to take a const struct xfs_sb pointer
because they do not change the superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

