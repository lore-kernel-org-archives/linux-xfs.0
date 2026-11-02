Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630566;
	b=lhc4yCWLNSmF6tRUSjeT6DxOuPnszsDSvtfstqYjs2d8xXfPSderSL9EHoxGRS7uk5sp
	 opABPRC5lCMImzp//7evE8drJLY4mZIh2zmQYjzsIW+B0OrIkeMjskYTK+TgLiA9Bqh4p
	 CV9got12xmiwTWFR0n9425D4wDdWzp0+BnukryLqH7YBaKK8DkDQxcHRQ8G6X35CpsWT0
	 8u9pshwftHkGZ4bmqIBl7V8SkSeAbNEuHsxcdmDWvzLYN13r/fMA92UH9NrjFenEmzb89
	 ErkSpbM2+5jiQCLW3Hk8oNtdyA0nh8CfilbYTaJGt6BUGakRGljHX+MnjRwO6KUFhAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=84a1TUwT5CfvLKlYCqTDixbPk9CE31NUcTVunVWGd+c=;
	b=k78Q6iHdophzAQtYTyOBF+TVnh/6DdKz9jYpC98HgukXdpffaUd8yHIOXloh2U6oE4/W
	 Iq+Oa90DaC7lDrz/q3QOz/N6m2yRzdic7yI3ppxIwACvoyyn9CYDbik5clmxKJyYunEl7
	 Oq22t5DzMNb9ca46CbmWFzwk5u8oHVcAe+bkcje1U96y654HyvzroyiVjRmIXU+yiLcnU
	 K64S3QjLGX0X2n+24KLusO+bre7i6eiaDfNfQPSiHH9L3KiOGmCdFlBN33ZPSoPeehHDH
	 MSyj/OQwBb6Jr2i2QMVG0Lz3XYiZd+yb9PRSV8lAgsKO8vf8z573hKuF5lZ5wxwLPjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=abr2fYaA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5709606A5BC;
	Mon,  2 Nov 2026 14:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=abr2fYaA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468741F00A17;
	Mon,  2 Nov 2026 14:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630565;
	bh=84a1TUwT5CfvLKlYCqTDixbPk9CE31NUcTVunVWGd+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abr2fYaA+C0HHHJ+dnu2nRMbYkyKN3dOarxKCY2Uf1NfAtYNmDJgB2pPaBH4j617B
	 ASkdb2EnZAH3ux0zJH/luPinzWop+WnUicBIHya3YrbcWYAzBOeOV8BiEhURJMSo0L
	 JZ0alTeCoBhbduzeRrGtlvRAFx8QFN48Sb0P5K7OO/9cq2cbKUyQx+rGGbedXCddHY
	 FrNrH/c+g0dj+o2B8DTlFSLXfrLDwirBaUqxEovCX8ng2hcppKIFrFLrxF6bUFxHEI
	 sRjgjku4GUpPQ38S0MWVJ3dDwlafpYrocydOkAPmXSw5oLzOD8ccnvB3HAYhMOGWg3
	 ErqpgZqG01FoQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v18 14/15] xfs: introduce health state for corrupted fsverity metadata
Date: Mon,  2 Nov 2026 15:41:44 +0100
Message-ID: <20261102144147.2393369-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
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

Report corrupted fsverity descriptor through health system.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |  1 +
 fs/xfs/libxfs/xfs_health.h |  4 +++-
 fs/xfs/xfs_fsverity.c      | 25 +++++++++++++++++++------
 fs/xfs/xfs_health.c        |  1 +
 4 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c80133784419..84d62b7506a9 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -422,6 +422,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
+#define XFS_BS_SICK_FSVERITY	(1 << 9)  /* fsverity metadata */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 1d45cf5789e8..932b447190da 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -104,6 +104,7 @@ struct xfs_rtgroup;
 /* Don't propagate sick status to ag health summary during inactivation */
 #define XFS_SICK_INO_FORGET	(1 << 12)
 #define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
+#define XFS_SICK_INO_FSVERITY	(1 << 14)  /* fsverity metadata */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -140,7 +141,8 @@ struct xfs_rtgroup;
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT | \
-				 XFS_SICK_INO_DIRTREE)
+				 XFS_SICK_INO_DIRTREE | \
+				 XFS_SICK_INO_FSVERITY)
 
 #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
 				 XFS_SICK_INO_BMBTA_ZAPPED | \
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index 441251b36073..9b83a0735dc0 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -89,13 +89,17 @@ xfs_fsverity_get_descriptor(
 	if (error)
 		return error;
 
-	if (is_empty)
+	if (is_empty) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ENODATA;
+	}
 
 	last_block_offset =
 		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
-	if (last_block_offset <= xfs_fsverity_metadata_offset(ip))
+	if (last_block_offset <= xfs_fsverity_metadata_offset(ip)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ENODATA;
+	}
 
 	desc_size_pos = last_block_offset - sizeof(__be32);
 	error = fsverity_pagecache_read(inode, (char *)&d_desc_size,
@@ -104,20 +108,29 @@ xfs_fsverity_get_descriptor(
 		return error;
 
 	desc_size = be32_to_cpu(d_desc_size);
-	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
+	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
-	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos))
+	}
+
+	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
+	}
 
 	if (!buf_size)
 		return desc_size;
 
-	if (XFS_IS_CORRUPT(mp, desc_size > buf_size))
+	if (XFS_IS_CORRUPT(mp, desc_size > buf_size)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
+	}
 
 	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
-	if (desc_pos < xfs_fsverity_metadata_offset(ip))
+	if (desc_pos < xfs_fsverity_metadata_offset(ip)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
+	}
 
 	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
 	if (error)
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 239b843e83d4..be66760fb120 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -625,6 +625,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
+	{ XFS_SICK_INO_FSVERITY,	XFS_BS_SICK_FSVERITY },
 };
 
 /* Fill out bulkstat health info. */
-- 
2.54.0

