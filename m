Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782802;
	b=KC76Px1KRQsn3N3eWLX258ZRjxoYaniJZw11XZ9Yyuq1jY6KMNHOHhrU3kmcgUZeTwsM
	 hdgjHh4VTt+H2QSXcJv27ndXnChKuSQP6LNPXv/1lwogKYeEnzSQsS6gCNjIsTiewVaeG
	 c0uKL05lJbOTbfHGRZgYaChmrNfZcqGhw+++RIEgdsIw8bFAxTkM/rl3LZTNRQmnZVtOL
	 UuBreL/Oc3jTOnYil9KW4+Uwr9XdwX+tOjTb7ZJUMv/hSP4tGSn9bS7EIDfjjsTOJOKIv
	 /VnYwNOYrTl3lBljPzWg8QRXNwSnEl2Dl83yUBFHkPSUQ8uxrJhoDVMDEsr4GraRn9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782802;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=x+j+WI3BR/K3/KZU3VBaB+r29OkwfVCBrpLpfp7v488=;
	b=Xu5zuGlOGnnyOkG/pNuwC+f3XZv2dbIS7VM/pFi5yxuZrenqB38EyMkMVfhPBVuYBZxf
	 J9pP79HTPzQi9dBE8Kh4kygdF/jjQI1ve5YAFRBd12zxRMJ2AMSzI9/R3PS3gsr/OkAt9
	 drkHysyAttcnVB7iOCHtOyIGocJODiUYBNoLpvzf88zEw+Jm8cj3E/0If07vnW7Fl778f
	 SmMfze4eJm/Z1EPA1Iz674Ed/iWDc7MaSgQCyfoATMq3YBZOTW4zL+7qwkofu+NQFwpQ/
	 P/egSTiANvfBogxUc9ontB6P7Nb+Ltb5nKW5dcFs2Xw+YC0QnvTWLerlDlDeyCEWsgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=GeAL9Cvl;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C47606A333;
	Wed,  4 Nov 2026 09:00:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9C47606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=GeAL9Cvl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=x+j+WI3BR/K3/KZU3VBaB+r29OkwfVCBrpLpfp7v488=; b=GeAL9Cvl+Ja37nedPVXZbK3vev
	MQP5Y0KRvHwWEtX33msw2gy7ISit5EyuYEa2vr14qIeB3wYGseUZ59MrWQtUw/OCqI6igqUH6jJuk
	60iI4cZ61Ge3UVTnCKEa2uA15EfXmca4aYDnibMYIbACPEZVKlUCrl5VcXXGdrWmpqu2w/4oazoji
	CE5LmoeXO/TatMFB8kpdep1q66TKR11zCbWkcU6wrVMGJN73MJQrCk/qZKtw65IE/1rvBvtbFw0VA
	q+gpn01BCmc6M7hLzLpwsE+ktMLTRk1oP3hZpivx8Y/LUoVa0NVkp4N1kRuLnV1Cyr9F05KhwNzf/
	o9vW8GNQ==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqf-00000004oOa-191E;
	Wed, 04 Nov 2026 09:00:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 10/25] xfs: define the RT data checksum on-disk format
Date: Wed,  4 Nov 2026 09:57:14 +0100
Message-ID: <20261104085929.317544-11-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add the on-disk format for the new RT data checksum format.

Keyed off a new read-only compat feature flag, this adds new fields to
the superblock to indicate the checksum algorithm used and the size of
the blocks containing the checksums.  These new fields reuse the
previously reserved padding to make efficient use of the space in the
on-disk superblock.

Data checksums are only supported on zoned RT devices, because they
require out of places writes to safely update the checksums for file
overwrites and a data/metadata split to be able to store the checksums
for a group in a file without causing recursion.  This means they can't
be supported directly on the data device at all, and only when using
the always_cow mode on regular RT devices, but that has no benefit
over the zoned allocator which is designed for out of place writes.

The initially supported data checksum algorithms are crc32c and crc64 as
specified by NVMe.  Both have extremely fast kernel implementations and
the strong data protection guarantees offered by CRC-style algorithms.
Both also happen to be support by NVMe for protection information so that
the userspace PI passthrough support (once extended to files on file
systems) can be reused to expose the checksums to applications and thus
provide true end-to-end data integrity.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h     | 43 +++++++++++++++--
 fs/xfs/libxfs/xfs_log_format.h |  1 +
 fs/xfs/libxfs/xfs_ondisk.h     |  4 +-
 fs/xfs/libxfs/xfs_sb.c         | 86 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.h         |  1 +
 fs/xfs/scrub/agheader.c        |  5 ++
 fs/xfs/xfs_mount.h             |  4 ++
 7 files changed, 140 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 469e879149ac..3d794a2eb497 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -179,7 +179,9 @@ typedef struct xfs_sb {
 	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
 	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
 	uint8_t		sb_rgblklog;    /* rt group number shift */
-	uint8_t		sb_pad[7];	/* zeroes */
+	uint8_t		sb_rtcsum_type;	/* RT device data checksum type */
+	uint8_t		sb_rtcsum_blklog; /* log2 of rtcsum bsize */
+	uint8_t		sb_pad[5];	/* zero */
 	xfs_rfsblock_t	sb_rtstart;	/* start of internal RT section (FSB) */
 	xfs_filblks_t	sb_rtreserved;	/* reserved (zoned) RT blocks */
 
@@ -272,7 +274,9 @@ struct xfs_dsb {
 	__be32		sb_rgcount;	/* # of realtime groups */
 	__be32		sb_rgextents;	/* size of rtgroup in rtx */
 	__u8		sb_rgblklog;    /* rt group number shift */
-	__u8		sb_pad[7];	/* zeroes */
+	__u8		sb_rtcsum_type;	/* RT device data checksum type */
+	__u8		sb_rtcsum_blklog; /* log2 of rtcsum bsize */
+	__u8		sb_pad[5];	/* zero */
 	__be64		sb_rtstart;	/* start of internal RT section (FSB) */
 	__be64		sb_rtreserved;	/* reserved (zoned) RT blocks */
 
@@ -374,6 +378,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
@@ -399,6 +404,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 8)  /* metadata dir tree */
 #define XFS_SB_FEAT_INCOMPAT_ZONED	(1 << 9)  /* zoned RT allocator */
 #define XFS_SB_FEAT_INCOMPAT_ZONE_GAPS	(1 << 10) /* RTGs have LBA gaps */
+#define XFS_SB_FEAT_INCOMPAT_RTCSUM     (1 << 11) /* RT data checksums */
 
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
@@ -866,6 +872,7 @@ enum xfs_metafile_type {
 	XFS_METAFILE_RTSUMMARY,		/* rt summary */
 	XFS_METAFILE_RTRMAP,		/* rt rmap */
 	XFS_METAFILE_RTREFCOUNT,	/* rt refcount */
+	XFS_METAFILE_RTCSUM,		/* rt data checksums */
 
 	XFS_METAFILE_MAX
 } __packed;
@@ -879,7 +886,8 @@ enum xfs_metafile_type {
 	{ XFS_METAFILE_RTBITMAP,	"rtbitmap" }, \
 	{ XFS_METAFILE_RTSUMMARY,	"rtsummary" }, \
 	{ XFS_METAFILE_RTRMAP,		"rtrmap" }, \
-	{ XFS_METAFILE_RTREFCOUNT,	"rtrefcount" }
+	{ XFS_METAFILE_RTREFCOUNT,	"rtrefcount" }, \
+	{ XFS_METAFILE_RTCSUM,		"rtcsum", }
 
 /*
  * On-disk inode structure.
@@ -1322,6 +1330,7 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
  */
 #define XFS_RTBITMAP_MAGIC	0x424D505A	/* BMPZ */
 #define XFS_RTSUMMARY_MAGIC	0x53554D59	/* SUMY */
+#define XFS_RTCSUM_MAGIC	0x4353554D	/* CSUM */
 
 struct xfs_rtbuf_blkinfo {
 	__be32		rt_magic;	/* validity check on block */
@@ -2031,4 +2040,32 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
+/*
+ * Size of a RT data checksum block.  Data reads must be contained in a single
+ * block, so this should be fairly large.
+ *
+ * The default is 32k, matching the default inode cluster size and the maximum
+ * memory allocation the Linux MM can handle in the fast path.  64k is primarily
+ * there so that this value never needs to be below the FSB size, even for 64k
+ * blocks.
+ */
+#define XFS_RTCSUM_BSIZE_LOG_MIN	15
+#define XFS_RTCSUM_BSIZE_LOG_MAX	16
+
+/*
+ * Data checksum types.
+ */
+#define XFS_CSUM_TYPE_NONE	0u
+#define XFS_CSUM_TYPE_CRC32C	1u
+#define XFS_CSUM_TYPE_CRC64	2u
+#define XFS_CSUM_TYPE_MAX	3u
+
+/*
+ * On-disk data checksums.
+ */
+union xfs_disk_csum {
+	__le32			crc32c;
+	__le64			crc64;
+};
+
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 6e620380d5dc..c6f0edb4bf0a 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -581,6 +581,7 @@ enum xfs_blft {
 	XFS_BLFT_SB_BUF,
 	XFS_BLFT_RTBITMAP_BUF,
 	XFS_BLFT_RTSUMMARY_BUF,
+	XFS_BLFT_RTCSUM_BUF,
 	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
 };
 
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 23cde1248f01..17ab9366b3b9 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -284,7 +284,9 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_SB_OFFSET(sb_rgcount,			272);
 	XFS_CHECK_SB_OFFSET(sb_rgextents,		276);
 	XFS_CHECK_SB_OFFSET(sb_rgblklog,		280);
-	XFS_CHECK_SB_OFFSET(sb_pad,			281);
+	XFS_CHECK_SB_OFFSET(sb_rtcsum_type,		281);
+	XFS_CHECK_SB_OFFSET(sb_rtcsum_blklog,		282);
+	XFS_CHECK_SB_OFFSET(sb_pad,			283);
 	XFS_CHECK_SB_OFFSET(sb_rtstart,			288);
 	XFS_CHECK_SB_OFFSET(sb_rtreserved,		296);
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ce44123c98ce..8096706ed78a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -184,6 +184,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_METADIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)
 		features |= XFS_FEAT_ZONED;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTCSUM)
+		features |= XFS_FEAT_RTCSUM;
+
 
 	return features;
 }
@@ -486,6 +489,42 @@ xfs_validate_sb_zoned(
 	return 0;
 }
 
+static int
+xfs_validate_sb_csum(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	if (!(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
+		xfs_warn(mp, "data checksum required the zone allocator");
+		return -EINVAL;
+	}
+	if (sbp->sb_rtcsum_blklog < XFS_RTCSUM_BSIZE_LOG_MIN ||
+	    sbp->sb_rtcsum_blklog > XFS_RTCSUM_BSIZE_LOG_MAX) {
+		xfs_warn(mp,
+"invalid data checksum block log: %u (min %u/max %u)",
+			sbp->sb_rtcsum_blklog,
+			XFS_RTCSUM_BSIZE_LOG_MIN,
+			XFS_RTCSUM_BSIZE_LOG_MAX);
+		return -EINVAL;
+	}
+	if ((1U << sbp->sb_rtcsum_blklog) < sbp->sb_blocksize) {
+		xfs_warn(mp,
+"checksum block size must not be smaller than file system block size: %u/%u",
+			1U << sbp->sb_rtcsum_blklog, sbp->sb_blocksize);
+		return -EINVAL;
+	}
+	switch (sbp->sb_rtcsum_type) {
+	case XFS_CSUM_TYPE_CRC32C:
+	case XFS_CSUM_TYPE_CRC64:
+		break;
+	default:
+		xfs_warn(mp, "invalid data checksum type: 0x%x",
+			sbp->sb_rtcsum_type);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /* Check the validity of the SB. */
 STATIC int
 xfs_validate_sb_common(
@@ -579,6 +618,17 @@ xfs_validate_sb_common(
 			if (error)
 				return error;
 		}
+		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTCSUM) {
+			error = xfs_validate_sb_csum(mp, sbp);
+			if (error)
+				return error;
+		} else {
+			if (sbp->sb_rtcsum_type || sbp->sb_rtcsum_blklog) {
+				xfs_warn(mp,
+"rtcsum superblock fields must be zero for non-RTCSUM file systems.");
+				return -EINVAL;
+			}
+		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
@@ -886,10 +936,20 @@ __xfs_sb_from_disk(
 		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
 		to->sb_rbmino = NULLFSINO;
 		to->sb_rsumino = NULLFSINO;
+
+		/*
+		 * The checksum fields are in space that was padding originally
+		 * added with the metadir feature.  Always copy the values and
+		 * later validate that they are zero for non-csum file systems.
+		 */
+		to->sb_rtcsum_type = from->sb_rtcsum_type;
+		to->sb_rtcsum_blklog = from->sb_rtcsum_blklog;
 	} else {
 		to->sb_metadirino = NULLFSINO;
 		to->sb_rgcount = 1;
 		to->sb_rgextents = 0;
+		to->sb_rtcsum_type = XFS_CSUM_TYPE_NONE;
+		to->sb_rtcsum_blklog = 0;
 	}
 
 	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
@@ -1066,6 +1126,15 @@ xfs_sb_to_disk(
 		to->sb_rsumino = cpu_to_be64(0);
 	}
 
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTCSUM) {
+		to->sb_rtcsum_type = from->sb_rtcsum_type;
+		to->sb_rtcsum_blklog = from->sb_rtcsum_blklog;
+	} else {
+		/* these are in previou padding and must always be written */
+		to->sb_rtcsum_type = 0;
+		to->sb_rtcsum_blklog = 0;
+	}
+
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
 		to->sb_rtstart = cpu_to_be64(from->sb_rtstart);
 		to->sb_rtreserved = cpu_to_be64(from->sb_rtreserved);
@@ -1242,6 +1311,20 @@ xfs_mount_sb_set_rextsize(
 	xfs_sb_mount_rextsize(mp, sbp);
 }
 
+uint8_t
+xfs_data_csum_shift(
+	uint8_t			csum)
+{
+	switch (csum) {
+	case XFS_CSUM_TYPE_CRC32C:
+		return 2;
+	case XFS_CSUM_TYPE_CRC64:
+		return 3;
+	default:
+		return 0;
+	}
+}
+
 /*
  * xfs_mount_common
  *
@@ -1310,6 +1393,9 @@ xfs_sb_mount_common(
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
+
+	mp->m_rtcsum_shift = xfs_data_csum_shift(mp->m_sb.sb_rtcsum_type);
+	mp->m_rtcsum_bsize = 1U << mp->m_sb.sb_rtcsum_blklog;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 77de65922213..298d70f2a72e 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -19,6 +19,7 @@ extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 void		xfs_sb_mount_rextsize(struct xfs_mount *mp, struct xfs_sb *sbp);
 void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
 			struct xfs_sb *sbp, xfs_agblock_t rextsize);
+uint8_t		xfs_data_csum_shift(uint8_t csum);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index be59b0b49547..b074212fbfff 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -445,6 +445,11 @@ xchk_superblock(
 
 		if (memchr_inv(sb->sb_pad, 0, sizeof(sb->sb_pad)))
 			xchk_block_set_corrupt(sc, bp);
+
+		if (sb->sb_rtcsum_type != mp->m_sb.sb_rtcsum_type)
+			xchk_block_set_corrupt(sc, bp);
+		if (sb->sb_rtcsum_blklog != mp->m_sb.sb_rtcsum_blklog)
+			xchk_block_set_corrupt(sc, bp);
 	}
 
 	if (xfs_has_zoned(mp)) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cbcfb89c67a4..0e60d5c29c9d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -191,6 +191,8 @@ typedef struct xfs_mount {
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	uint8_t			m_rtcsum_shift;	/* log2 of RT data csum size */
+	uint32_t		m_rtcsum_bsize;	/* rtcsum block size in bytes */
 
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
@@ -403,6 +405,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
 #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
 #define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
+#define XFS_FEAT_RTCSUM		(1ULL << 30)	/* RT data checksums */
 
 /* Mount features */
 #define XFS_FEAT_NOLIFETIME	(1ULL << 47)	/* disable lifetime hints */
@@ -460,6 +463,7 @@ __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(zoned, ZONED)
 __XFS_HAS_FEAT(nolifetime, NOLIFETIME)
+__XFS_HAS_FEAT(rtcsum, RTCSUM)
 
 static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {
-- 
2.53.0

