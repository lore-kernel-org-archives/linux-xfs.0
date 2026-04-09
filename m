Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA863D332E;
	Thu,  9 Apr 2026 13:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740481; cv=none; b=b9eNOKDigaxKrTe9XFA86tcI6Z7L6KCkdh+rt+QdyV1cR1YhUW6s7rdQNGY8ieHP66DKS4g0mQWuGpxEwr25ATrGzssYDuzp1ddBbPxYosiSUg54XEJyKRhwYTio8L4LaToGPcXK0hoC4HeNglkZPn4CxiFXVYHkEh9oH7I0Y3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740481; c=relaxed/simple;
	bh=RZTePcZL49YR0MAouenDsHNhMRyMiw3LC4VY3V7qjps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptNsJGIofcE0NMnBfHg8ZqjIUqtfydLYy8cbpjLudhOgaWIZvHOZ6kK0FJ6L5EOiBngyfUHyJKIVdto8dMSBHXqaldpsrpLwGS/yZ11T6ypv4DEurTHclbYaW7xwl/Cp9cme1KIL0PnHqQyJAIQlev9n4QFsoLdP4F5RUu1wSb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9A8HZ/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9A8HZ/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3191EC4CEF7;
	Thu,  9 Apr 2026 13:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740480;
	bh=RZTePcZL49YR0MAouenDsHNhMRyMiw3LC4VY3V7qjps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9A8HZ/zF58xY1fXzQPPIPs5036vmr+EULEUuKCo+xoifAgEhbWXC3g62ljYJDfci
	 E77OJTvfNkaQN+hEPkqolF/rMP03dMPDgKQVV5r0oH8rFBX0MiBARPLxr0MM9rzY1p
	 89dFyVFTI5fl33vura+8RcwGnztuPanw8TB5Od2xqyv7f9INvyOYlnVgE6xLu8/2Fj
	 y1JqMVRML4er53qnGsDNbuF8oIEHVYHFFEH24aePeGiY8s+wEI6GLt8x+x4Yu1x28u
	 eoLcv471l+Y1Wzbcr/Dg0fbxfm2C4oIz+Ctk+n5i6FKowqMj5jBoo9OToj1mfyxhLW
	 E1EMyPio+/OrQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v7 10/22] xfs: introduce fsverity on-disk changes
Date: Thu,  9 Apr 2026 15:13:42 +0200
Message-ID: <20260409131404.1545834-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Introduce XFS_DIFLAG2_VERITY for inodes with fsverity. This flag
indicates that inode has fs-verity enabled (i.e. descriptor exist,
tree is built and file is read-only).

Introduce XFS_SB_FEAT_RO_COMPAT_VERITY for filesystems having
fsverity inodes. As on-disk changes applies to fsverity inodes only, let
older kernels read-only access. This will be enabled in the further
patch after full fsverity support.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     | 30 +++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_inode_buf.c  |  8 ++++++++
 fs/xfs/libxfs/xfs_inode_util.c |  2 ++
 fs/xfs/libxfs/xfs_sb.c         |  2 ++
 fs/xfs/xfs_iops.c              |  2 ++
 fs/xfs/xfs_mount.h             |  2 ++
 6 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 779dac59b1f3..4dff29659e40 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -374,6 +374,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+#define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
@@ -1230,16 +1231,21 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DIFLAG2_METADATA_BIT	5
 
+/* inodes sealed with fs-verity */
+#define XFS_DIFLAG2_VERITY_BIT		6
+
 #define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
 #define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
 #define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
+#define XFS_DIFLAG2_VERITY	(1ULL << XFS_DIFLAG2_VERITY_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA | \
+	 XFS_DIFLAG2_VERITY)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -2021,4 +2027,26 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
+/*
+ * At maximum of 8 levels with 128 hashes per block (32 bytes SHA-256) maximum
+ * tree size is ((128^8 − 1)/(128 − 1)) = 567*10^12 blocks. This should fit in
+ * 53 bits address space.
+ *
+ * At this Merkle tree size we can cover 295EB large file. This is much larger
+ * than the currently supported file size.
+ *
+ * For sha512 the largest file we can cover ends at 1 << 50 offset, this is also
+ * good.
+ */
+#define XFS_FSVERITY_LARGEST_FILE	((loff_t)1ULL << 53)
+
+/*
+ * Alignment of the fsverity metadata placement. This is largest supported PAGE
+ * SIZE for fsverity. This is used to space out data and metadata in page cache.
+ * The spacing is necessary for non-exposure of metadata to userspace and
+ * correct merkle tree synethesis in the iomap.
+ */
+#define XFS_FSVERITY_START_ALIGN	(65536)
+
+
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3794e5412eba..f2181c1bed54 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -760,6 +760,14 @@ xfs_dinode_verify(
 	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
+	/* only regular files can have fsverity */
+	if (flags2 & XFS_DIFLAG2_VERITY) {
+		if (!xfs_has_verity(mp))
+			return __this_address;
+		if (!S_ISREG(mode))
+			return __this_address;
+	}
+
 	if (xfs_has_zoned(mp) &&
 	    dip->di_metatype == cpu_to_be16(XFS_METAFILE_RTRMAP)) {
 		if (be32_to_cpu(dip->di_used_blocks) > mp->m_sb.sb_rgextents)
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 551fa51befb6..6b1e20a4bb9b 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -126,6 +126,8 @@ xfs_ip2xflags(
 			flags |= FS_XFLAG_DAX;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
+		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+			flags |= FS_XFLAG_VERITY;
 	}
 
 	if (xfs_inode_has_attr_fork(ip))
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 47322adb7690..a15510ebd2f1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -165,6 +165,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_REFLINK;
 	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
 		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_VERITY)
+		features |= XFS_FEAT_VERITY;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
 		features |= XFS_FEAT_FTYPE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 208543e57eda..ca369eb96561 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1415,6 +1415,8 @@ xfs_diflags_to_iflags(
 		flags |= S_NOATIME;
 	if (init && xfs_inode_should_enable_dax(ip))
 		flags |= S_DAX;
+	if (xflags & FS_XFLAG_VERITY)
+		flags |= S_VERITY;
 
 	/*
 	 * S_DAX can only be set during inode initialization and is never set by
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ddd4028be8d6..07f6aa3c3f26 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -385,6 +385,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
 #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
 #define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
+#define XFS_FEAT_VERITY		(1ULL << 30)	/* fs-verity */
 
 /* Mount features */
 #define XFS_FEAT_NOLIFETIME	(1ULL << 47)	/* disable lifetime hints */
@@ -442,6 +443,7 @@ __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(zoned, ZONED)
 __XFS_HAS_FEAT(nolifetime, NOLIFETIME)
+__XFS_HAS_FEAT(verity, VERITY)
 
 static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {
-- 
2.51.2

