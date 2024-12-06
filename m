Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F13B212FB8
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528207; cv=none; b=FNpuuRwm0VGSwC3HnQKkKlTATOIfqgbwGKuwLlLu94vLDxvTrpP54jpwtsZnifgyE4D8KDwRg6NidISQEnBHWw51uOhfnvhWDoDQ0/DcXRtKCTcXtIw0SgHJjq8YCi9TYkkuyjEGaqdfkAbs7/+uFrtMmI0GcNmrBvBeNFUMjFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528207; c=relaxed/simple;
	bh=1d92ETI48XjwEGT6jL2iA0Jzg/O6AraTWo+HLjkSJn4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=anQiBjb+ceaFl+JqCoha/BmO3rRlBzxR+zycTAYgp0beddK7PoQyRsdEQkiT1lNl2OsxX/sjmqijdvNWkc+Qvp+P30ZG0WJl7qIGiUkCpaUWTWsbbPbHQWb2mIsyaUX0uMW8p/BA9YNYHrZp2uYfvJ5ZKCoDiz0pg76hLzEM52A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P11TlZi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P11TlZi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C61BC4CED1;
	Fri,  6 Dec 2024 23:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528207;
	bh=1d92ETI48XjwEGT6jL2iA0Jzg/O6AraTWo+HLjkSJn4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P11TlZi9tK6FqyQHBbePiK5C+DpOcb7Yom9QmRQeLnCVZlaKlORmjfs9WBJ8951Cl
	 ChWsyXTiKukVZJmEb8Mv0dfhcG1GtGJMjXfAqix2beVl667FDU2u3KkVLmjVLDNLkA
	 6w/IAuJvWAkXI7gYVelE2ha3cmrU6Wd2KRjL/bEITbV2m4saWqTlwR8ylrj5rRNKJp
	 CIBToXVO+tgkcSEUw5VzSgcueQE/3Ua53TJO0SprCVdg+nup9xdPIQ3GuFgudSmaN0
	 w/BZYl2JbrewWFAxYb+UR8x5KgE9eRS67FfBAo54qF8hulRmMx0FLRLetfnmHD5yL5
	 BdwsZJwOCDFPA==
Date: Fri, 06 Dec 2024 15:36:46 -0800
Subject: [PATCH 25/36] xfs: constify the xfs_sb predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747257.121772.14433747039015070217.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
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

