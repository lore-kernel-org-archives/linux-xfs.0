Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DD315CD74
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479555; cv=none; b=tlvo0UQVM6rVMGZl5iH9533pFw5PlhdNw2cRtCkHiuZmZ808JkQDG4G+QeNQeiZExM6zu0kr6sXe+A1EefrC2coCF0aHq1kuoVdup0VqOecYv0U3ToIFbMlDBcHBdBize4WfzztlZDs+LRfrAEUPEun1oGiFZG2qlwHK/0XkOdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479555; c=relaxed/simple;
	bh=Q2WwOg9+DJLtNjg+TkowiEs/XtD9AbIQjmY7592fRHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+AMd0VyrceIJ04ud4smfTJ/uIC6SRLzHzzKyAajg4O+Wd8GeyjJF4XK+MuviW4KaRNyEiw+X4TmtBY7Zeo3CQKHt2cB0HnAKaQ2GH3MgGdHfmAtQfmryLj41EX3cSdcC5rFHV4pwJ61ZPi7U/ORAnrCCQu4iq+zZg3wnFkWU+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SrZ0XsXv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SrZ0XsXv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7CFSQTd34Wiy7tERJmFVlaLJFpO5L40TLXgtta4Tg/w=;
	b=SrZ0XsXvnXZO60Q3DnM1Ty8Te6/xjB2JYfEj6/gKLz/DKnMovsgXuUE4DDMycCSAor1rX1
	OMcv7DhV1u6o4UE6qtUvGb+bHUeFsowcQJcAehrZBbHkMpwBCDoWc1s+7/qRaWgLyT+mbD
	Afuc+c4sHOGm9y/EN199VbTSueM1t1Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-Oem9gmsQP7-4uZHSyRnJ5A-1; Sun, 29 Dec 2024 08:39:11 -0500
X-MC-Unique: Oem9gmsQP7-4uZHSyRnJ5A-1
X-Mimecast-MFC-AGG-ID: Oem9gmsQP7-4uZHSyRnJ5A
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361a8fc3bdso46048155e9.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479549; x=1736084349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7CFSQTd34Wiy7tERJmFVlaLJFpO5L40TLXgtta4Tg/w=;
        b=pVPVwnZixRzDZrqz8M1Txd0uwdwU4UwQdjeeCfAzR/bFd5NpoMeU3X3zC6MmDeBsdn
         ZUdZAlfJQugoyaSC1p7gcyBQdcLb7xslAp49LW7oBqFekk+CF0E7dKAiChCLRf15+k2u
         3RMQxDrFZpnD+TFN4oNkOYVn6PlGHr92m2QEHJSnKQ++T/FaM21U66nzd0G/+DX/RGKK
         ow755g9xsoaD8VAHcv5DH6+6q0jQk7ci4M/Ev/wxesSuSUOL6QEyhH2aEmcGt+U7whro
         n0e8ftgm31wVwRUwPKjGFi09kB1nnC9NuXo7WicznoxXh/3lRWbylP40apzW68BnUkq8
         r8lw==
X-Gm-Message-State: AOJu0YznVnw5fd/Y9Q3dNhofTuzPVp4u+/TJ2fhV2jGOh2uDWezGPJVM
	YwGUmbZ4OouaX7Fd85gUSoC4eaTf9kRsDGI3RNrpNi9NtJGdz99cZo3NFa5Q+um+bSZlMf3W37I
	D5HIMAujUXXJCSoTOy6nfon0qM82bW8KK9lDuYn8JprIEJZyHkQOc2E5SN+hPECV8pxL45gU+if
	VNgb69RsYxDrqiEISpfMInwyBZ8CGnIqFyMNWBvNHB
X-Gm-Gg: ASbGnctQEhr3t8deyk6BbYJJHHRwZ6IShvavIYkOIIww7rIOWZC3hyWH5auE0fO2KXd
	F3VsCRP9PEVCseA99N6TRxtx56z9qkejqBirPu6zKdkkdzDTe+TgOMj3v9TZ6qo843xIkSX5EN6
	6KkPMehb8cW1q1i0U2t2q9nojMYfMTlYy4jVOtfZGsUGCzDeSmUTsJ+ZdcftUzH6xgk63lTpgAC
	ujNJx5LcZhc72bAwbw8kr63POdwpFLW+f3BpBr/EWufpy7GGka/qhPOI+3PxFLg6CBtGxGBF/Lp
	1xCb7c+hKjRP19s=
X-Received: by 2002:a05:600c:4f09:b0:434:a711:ace4 with SMTP id 5b1f17b1804b1-4366864636dmr292044755e9.17.1735479549461;
        Sun, 29 Dec 2024 05:39:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGDyXbTgo4zFyG4Patn2rJGpCuCowlFQQ365rQGhKTGSsk50nZmGwx6JfIgv39SqZCgrscBZg==
X-Received: by 2002:a05:600c:4f09:b0:434:a711:ace4 with SMTP id 5b1f17b1804b1-4366864636dmr292044595e9.17.1735479548976;
        Sun, 29 Dec 2024 05:39:08 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:07 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 13/14] xfs: do not use xfs_attr3_rmt_hdr for remote value blocks for dxattr
Date: Sun, 29 Dec 2024 14:38:35 +0100
Message-ID: <20241229133836.1194272-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Don't try to use xfs_attr3_rmt_hdr for directly mapped attribute's
data blocks as it's not there. These blocks don't have header. The
CRC is located in the btree structure and are verified on
io-completion.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        |  6 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |  5 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 91 ++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_attr_remote.h |  8 ++-
 fs/xfs/libxfs/xfs_da_format.h   |  2 +-
 fs/xfs/libxfs/xfs_shared.h      |  1 +
 fs/xfs/xfs_attr_inactive.c      |  2 +-
 7 files changed, 94 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d357405f22ee..e452ca55241f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -321,7 +321,8 @@ xfs_attr_calc_size(
 		 * Out of line attribute, cannot double split, but
 		 * make room for the attribute value itself.
 		 */
-		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
+		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->attr_filter,
+						       args->valuelen);
 		nblks += dblocks;
 		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
 	}
@@ -1263,7 +1264,8 @@ xfs_attr_set(
 		}
 
 		if (!local)
-			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
+			rmt_blks = xfs_attr3_rmt_blocks(mp, args->attr_filter,
+					args->valuelen);
 
 		tres = xfs_attr_set_resv(args);
 		total = args->total;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 409c91827b47..7e3577a8e5de 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1573,7 +1573,8 @@ xfs_attr3_leaf_add_work(
 		name_rmt->valuelen = 0;
 		name_rmt->valueblk = 0;
 		args->rmtblkno = 1;
-		args->rmtblkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
+		args->rmtblkcnt = xfs_attr3_rmt_blocks(mp, args->attr_filter,
+				args->valuelen);
 		args->rmtvaluelen = args->valuelen;
 	}
 	xfs_trans_log_buf(
@@ -2512,6 +2513,7 @@ xfs_attr3_leaf_lookup_int(
 			args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
 			args->rmtblkcnt = xfs_attr3_rmt_blocks(
 							args->dp->i_mount,
+							args->attr_filter,
 							args->rmtvaluelen);
 			return -EEXIST;
 		}
@@ -2561,6 +2563,7 @@ xfs_attr3_leaf_getvalue(
 	args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
 	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
 	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
+					       args->attr_filter,
 					       args->rmtvaluelen);
 	return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);
 }
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 17125e2e6c51..e90a62c61f28 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -43,14 +43,23 @@
  * the logging system and therefore never have a log item.
  */
 
+static inline bool
+xfs_attr3_rmt_has_header(
+	struct xfs_mount	*mp,
+	unsigned int		attrns)
+{
+	return xfs_has_crc(mp) && !xfs_has_dxattr(mp);
+}
+
 /* How many bytes can be stored in a remote value buffer? */
 inline unsigned int
 xfs_attr3_rmt_buf_space(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	unsigned int		attrns)
 {
 	unsigned int		blocksize = mp->m_attr_geo->blksize;
 
-	if (xfs_has_crc(mp))
+	if (xfs_attr3_rmt_has_header(mp, attrns))
 		return blocksize - sizeof(struct xfs_attr3_rmt_hdr);
 
 	return blocksize;
@@ -60,8 +69,16 @@ xfs_attr3_rmt_buf_space(
 unsigned int
 xfs_attr3_rmt_blocks(
 	struct xfs_mount	*mp,
+	unsigned int		attrns,
 	unsigned int		attrlen)
 {
+	/*
+	 * Each contiguous block has a header, so it is not just a simple
+	 * attribute length to FSB conversion.
+	 */
+	if (xfs_attr3_rmt_has_header(mp, attrns))
+		return howmany(attrlen, xfs_attr3_rmt_buf_space(mp, attrns));
+
 	return XFS_B_TO_FSB(mp, attrlen);
 }
 
@@ -241,6 +258,42 @@ const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
 	.verify_struct = xfs_attr3_rmt_verify_struct,
 };
 
+static void
+xfs_attr3_rmtdxattr_read_verify(
+	struct xfs_buf	*bp)
+{
+}
+
+static xfs_failaddr_t
+xfs_attr3_rmtdxattr_verify_struct(
+	struct xfs_buf	*bp)
+{
+	return NULL;
+}
+
+static void
+xfs_attr3_rmtdxattr_write_verify(
+	struct xfs_buf	*bp)
+{
+}
+
+const struct xfs_buf_ops xfs_attr3_rmtdxattr_buf_ops = {
+	.name = "xfs_attr3_remote_dxattr",
+	.magic = { 0, 0 },
+	.verify_read = xfs_attr3_rmtdxattr_read_verify,
+	.verify_write = xfs_attr3_rmtdxattr_write_verify,
+	.verify_struct = xfs_attr3_rmtdxattr_verify_struct,
+};
+
+inline const struct xfs_buf_ops *
+xfs_attr3_remote_buf_ops(
+	struct xfs_mount	*mp)
+{
+	if (xfs_has_dxattr(mp))
+		return &xfs_attr3_rmtdxattr_buf_ops;
+	return &xfs_attr3_rmt_buf_ops;
+}
+
 STATIC int
 xfs_attr3_rmt_hdr_set(
 	struct xfs_mount	*mp,
@@ -286,6 +339,7 @@ xfs_attr_rmtval_copyout(
 	struct xfs_buf		*bp,
 	struct xfs_inode	*dp,
 	xfs_ino_t		owner,
+	unsigned int		attrns,
 	unsigned int		*offset,
 	unsigned int		*valuelen,
 	uint8_t			**dst)
@@ -299,11 +353,11 @@ xfs_attr_rmtval_copyout(
 
 	while (len > 0 && *valuelen > 0) {
 		unsigned int hdr_size = 0;
-		unsigned int byte_cnt = xfs_attr3_rmt_buf_space(mp);
+		unsigned int byte_cnt = xfs_attr3_rmt_buf_space(mp, attrns);
 
 		byte_cnt = min(*valuelen, byte_cnt);
 
-		if (xfs_has_crc(mp)) {
+		if (xfs_attr3_rmt_has_header(mp, attrns)) {
 			if (xfs_attr3_rmt_hdr_ok(src, owner, *offset,
 						  byte_cnt, bno)) {
 				xfs_alert(mp,
@@ -335,6 +389,7 @@ xfs_attr_rmtval_copyin(
 	struct xfs_mount *mp,
 	struct xfs_buf	*bp,
 	xfs_ino_t	ino,
+	unsigned int	attrns,
 	unsigned int	*offset,
 	unsigned int	*valuelen,
 	uint8_t		**src)
@@ -347,12 +402,13 @@ xfs_attr_rmtval_copyin(
 	ASSERT(len >= blksize);
 
 	while (len > 0 && *valuelen > 0) {
-		unsigned int hdr_size;
-		unsigned int byte_cnt = xfs_attr3_rmt_buf_space(mp);
+		unsigned int hdr_size = 0;
+		unsigned int byte_cnt = xfs_attr3_rmt_buf_space(mp, attrns);
 
 		byte_cnt = min(*valuelen, byte_cnt);
-		hdr_size = xfs_attr3_rmt_hdr_set(mp, dst, ino, *offset,
-						 byte_cnt, bno);
+		if (xfs_attr3_rmt_has_header(mp, attrns))
+			hdr_size = xfs_attr3_rmt_hdr_set(mp, dst, ino, *offset,
+					byte_cnt, bno);
 
 		memcpy(dst + hdr_size, *src, byte_cnt);
 
@@ -400,6 +456,7 @@ xfs_attr_rmtval_get(
 	unsigned int		blkcnt = args->rmtblkcnt;
 	int			i;
 	unsigned int		offset = 0;
+	const struct xfs_buf_ops *ops = xfs_attr3_remote_buf_ops(mp);
 
 	trace_xfs_attr_rmtval_get(args);
 
@@ -425,14 +482,15 @@ xfs_attr_rmtval_get(
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
-					0, &bp, &xfs_attr3_rmt_buf_ops);
+					0, &bp, ops);
 			if (xfs_metadata_is_sick(error))
 				xfs_dirattr_mark_sick(args->dp, XFS_ATTR_FORK);
 			if (error)
 				return error;
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp,
-					args->owner, &offset, &valuelen, &dst);
+					args->owner, args->attr_filter,
+					&offset, &valuelen, &dst);
 			xfs_buf_relse(bp);
 			if (error)
 				return error;
@@ -460,7 +518,12 @@ xfs_attr_rmt_find_hole(
 	unsigned int		blkcnt;
 	xfs_fileoff_t		lfileoff = 0;
 
-	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
+	/*
+	 * Because CRC enable attributes have headers, we can't just do a
+	 * straight byte to FSB conversion and have to take the header space
+	 * into account.
+	 */
+	blkcnt = xfs_attr3_rmt_blocks(mp, args->attr_filter, args->rmtvaluelen);
 	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
 						   XFS_ATTR_FORK);
 	if (error)
@@ -519,10 +582,10 @@ xfs_attr_rmtval_set_value(
 		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, &bp);
 		if (error)
 			return error;
-		bp->b_ops = &xfs_attr3_rmt_buf_ops;
+		bp->b_ops = xfs_attr3_remote_buf_ops(mp);
 
-		xfs_attr_rmtval_copyin(mp, bp, args->owner, &offset, &valuelen,
-				&src);
+		xfs_attr_rmtval_copyin(mp, bp, args->owner, args->attr_filter,
+				       &offset, &valuelen, &src);
 
 		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index e3c6c7d774bf..2e2b3489a6cb 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -6,12 +6,13 @@
 #ifndef __XFS_ATTR_REMOTE_H__
 #define	__XFS_ATTR_REMOTE_H__
 
-unsigned int xfs_attr3_rmt_blocks(struct xfs_mount *mp, unsigned int attrlen);
+unsigned int xfs_attr3_rmt_blocks(struct xfs_mount *mp, unsigned int attrns,
+		unsigned int attrlen);
 
 /* Number of rmt blocks needed to store the maximally sized attr value */
 static inline unsigned int xfs_attr3_max_rmt_blocks(struct xfs_mount *mp)
 {
-	return xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+	return xfs_attr3_rmt_blocks(mp, 0, XFS_XATTR_SIZE_MAX);
 }
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
@@ -23,4 +24,7 @@ int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_blk(struct xfs_attr_intent *attr);
 int xfs_attr_rmtval_find_space(struct xfs_attr_intent *attr);
+
+const struct xfs_buf_ops *xfs_attr3_remote_buf_ops(struct xfs_mount *mp);
+
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 4034530ad023..48bebcd1e226 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -892,7 +892,7 @@ struct xfs_attr3_rmt_hdr {
 
 #define XFS_ATTR3_RMT_CRC_OFF	offsetof(struct xfs_attr3_rmt_hdr, rm_crc)
 
-unsigned int xfs_attr3_rmt_buf_space(struct xfs_mount *mp);
+unsigned int xfs_attr3_rmt_buf_space(struct xfs_mount *mp, unsigned int attrns);
 
 /* Number of bytes in a directory block. */
 static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index e7efdb9ceaf3..59921c12ed15 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -26,6 +26,7 @@ extern const struct xfs_buf_ops xfs_agfl_buf_ops;
 extern const struct xfs_buf_ops xfs_agi_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
+extern const struct xfs_buf_ops xfs_attr3_rmtdxattr_buf_ops;
 extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
 extern const struct xfs_buf_ops xfs_bnobt_buf_ops;
 extern const struct xfs_buf_ops xfs_cntbt_buf_ops;
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 2495ff76acec..d7a7f250d1c0 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -110,7 +110,7 @@ xfs_attr3_leaf_inactive(
 		if (!name_rmt->valueblk)
 			continue;
 
-		blkcnt = xfs_attr3_rmt_blocks(dp->i_mount,
+		blkcnt = xfs_attr3_rmt_blocks(dp->i_mount, entry->flags,
 				be32_to_cpu(name_rmt->valuelen));
 		error = xfs_attr3_rmt_stale(dp,
 				be32_to_cpu(name_rmt->valueblk), blkcnt);
-- 
2.47.0

