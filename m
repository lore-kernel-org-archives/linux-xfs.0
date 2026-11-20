Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190298;
	b=Emsg7t+lFIX+msheOB869yuBI7phTBsofwEQjDiQdFTeGLWIwTVHWA/P3SIA2gltYKpO
	 U7wosyy+sZaSbO/2l2yi4pU3vn7FXaif2axiX+eWrwCNSNd5v0gN3a3Ogbi6BjdlAkmMh
	 KA9ozhZ7tMVlshP1mWLlDH1SMndPgoUALUSUcAgHxoGdgjCKdE1E9QzFmyTC7qmgpJnZf
	 434dH2ieyY96fuCd9xh6XblGZOZfYNWoG7IDyjYMeWZ+QTg1Z3KBeztoWtEx1wvfQelXc
	 5Qw1f1/Lcpnyrqe4Ls7LBcBMA2nXslOIuBqV1NA27+RjLRwFsTKdS2IHaiwQOTzHycw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=T/laNxDbfkS+o+OahW2vPmA96aPqSfbRefsAy8S936k=;
	b=UetD6vdvEBoeWMiYIhXTKe9fNZcL4wXcZJl3GvTrItjY0DhkzVehdoHXM1DKoUnOq1sA
	 5ggShfQMbDMPupK4icTZrkbSLNVTibT8LMkrhFGICmrQi6GcdACdoS5Ctmyx+ajKn94aV
	 xPkQis9qhVZpzHu9DV1nTdPW9uEH4jVL3by7VifLvHeiC7CSIflubUYn/A0+GWIA7q29X
	 dEEUNPSQ/hoLLcTMuRqKL5rXB/qH7rpM7J7ZBK9PkhBYEJ/0LxL5HL9JLRkOUWehJ9rgT
	 3iq3zcHIQ4J6zPDJ+QI3sj3Vkhuee6HgpdYJNY6LT9yL4vnVBr5Sm37K474sI3IS/Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=crCzT8Tg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60F9606A338;
	Fri, 20 Nov 2026 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=crCzT8Tg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DD71F000D8;
	Fri, 20 Nov 2026 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190298;
	bh=T/laNxDbfkS+o+OahW2vPmA96aPqSfbRefsAy8S936k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crCzT8TgbQuILsNeJe+XAKQlRkOWy1lEMktbiPMTYEap/leTFTY68eC+Qt49deTRt
	 L7X2ox6QejPV7/Nu6tX/4bIZcVJ0GFmXnlSAXf4Ov4FUwyBHMmxQL5EG6Rtl1iBYDb
	 m6Om5pAB172rDOow+9XdyqGj0GME1aB8+HbuTrKCXq3gmLCfe+c/oG+5BEEJnvl9ge
	 O/wMsKLadpIPciz810Y/l4CqloDK1A3YzNgzDoquq87vyieBR1KEiLHs3U+3cgh84v
	 sJShnUW327xfHdOaK35sU+RiDZ3hFghYtOmUn3hauGVdfbv85p8gym6WaprHKMOYXl
	 piA7dZPvsOA8g==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v19 01/15] xfs: introduce fsverity on-disk changes
Date: Fri, 20 Nov 2026 16:57:35 +0100
Message-ID: <20261120155752.192025-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
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
 fs/xfs/libxfs/xfs_format.h     | 26 +++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_inode_buf.c  |  8 ++++++++
 fs/xfs/libxfs/xfs_inode_util.c |  5 ++++-
 fs/xfs/libxfs/xfs_sb.c         |  2 ++
 fs/xfs/xfs_iops.c              |  5 ++++-
 fs/xfs/xfs_mount.h             |  2 ++
 6 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 469e879149ac..2cb375bdbd76 100644
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
@@ -1234,16 +1235,21 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
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
@@ -2031,4 +2037,22 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
+/*
+ * fs-verity stores the Merkle tree in the data fork past EOF, so the file data
+ * blocks and the tree blocks share the inode's xfs_fileoff_t address space.
+ * Cap a verity file at half of the addressable file-offset range (in filesystem
+ * blocks) so the Merkle tree always fits in the other half.
+ */
+#define XFS_FSVERITY_LARGEST_FILE_FSB(mp) \
+	(XFS_B_TO_FSBT((mp), MAX_LFS_FILESIZE) >> 1)
+
+/*
+ * Alignment of the fsverity metadata placement. This is largest supported PAGE
+ * SIZE for fsverity. This is used to space out data and metadata in page cache.
+ * The spacing is necessary for non-exposure of metadata to userspace and
+ * correct merkle tree synthesis in the iomap.
+ */
+#define XFS_FSVERITY_START_ALIGN	(65536)
+
+
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 8c9d296ebfe9..13042e1eaf35 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -758,6 +758,14 @@ xfs_dinode_verify(
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
index f486b23a9b52..a717b19558af 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -73,7 +73,8 @@ xfs_flags2diflags2(
 	uint64_t		di_flags2 =
 		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
 				   XFS_DIFLAG2_BIGTIME |
-				   XFS_DIFLAG2_NREXT64));
+				   XFS_DIFLAG2_NREXT64 |
+				   XFS_DIFLAG2_VERITY));
 
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;
@@ -125,6 +126,8 @@ xfs_ip2xflags(
 			flags |= FS_XFLAG_DAX;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
+		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+			flags |= FS_XFLAG_VERITY;
 	}
 
 	if (xfs_inode_has_attr_fork(ip))
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ce44123c98ce..7629fc3f499f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -164,6 +164,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_REFLINK;
 	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
 		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_VERITY)
+		features |= XFS_FEAT_VERITY;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
 		features |= XFS_FEAT_FTYPE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6c5633db30da..ff12b7ac446e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1415,12 +1415,15 @@ xfs_diflags_to_iflags(
 		flags |= S_NOATIME;
 	if (init && xfs_inode_should_enable_dax(ip))
 		flags |= S_DAX;
+	if (xflags & FS_XFLAG_VERITY)
+		flags |= S_VERITY;
 
 	/*
 	 * S_DAX can only be set during inode initialization and is never set by
 	 * the VFS, so we cannot mask off S_DAX in i_flags.
 	 */
-	inode->i_flags &= ~(S_IMMUTABLE | S_APPEND | S_SYNC | S_NOATIME);
+	inode->i_flags &=
+		~(S_IMMUTABLE | S_APPEND | S_SYNC | S_NOATIME | S_VERITY);
 	inode->i_flags |= flags;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cbcfb89c67a4..700964048587 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -403,6 +403,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
 #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
 #define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
+#define XFS_FEAT_VERITY		(1ULL << 30)	/* fs-verity */
 
 /* Mount features */
 #define XFS_FEAT_NOLIFETIME	(1ULL << 47)	/* disable lifetime hints */
@@ -460,6 +461,7 @@ __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(zoned, ZONED)
 __XFS_HAS_FEAT(nolifetime, NOLIFETIME)
+__XFS_HAS_FEAT(verity, VERITY)
 
 static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {
-- 
2.54.0

