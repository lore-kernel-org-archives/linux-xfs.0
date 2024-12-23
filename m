Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D2164A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991406; cv=none; b=PPdXITvV7JPYdXG/7aKVJPctWs2ZiMC1ePHUGuhp4U04L6Ms/WXZknBR8KcmNIjhVdVIPawN2iCIrujpRzuZzkaw1ktUtcLFvyqickcFEGs/R8dKebue7Uq01DWp67p1C2nzs/tQJKhmKNkcBh3kYUSyjhLTfkFAgRIIoTEeqng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991406; c=relaxed/simple;
	bh=bIKkvgb7Ou+BR+ozeEU6hYVd1XqS0rXw5hoIlAza8W0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLRTfggw8mvZWEGXDv0ZfLNu36A0RRU4H8/62PlMmK2zO67pkoVfBUWezsq/3ynQBYzgw7DQw6S3SuCp/PkvFHr8jSzz76OI4at94kHafhxNHZi20DEN87NH4PBRqpoaxBEU2XBEL5Cgvmb2p7JvMmZTATIazHo4iG8pDW3JPeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dg3/hWX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dg3/hWX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F58C4CED3;
	Mon, 23 Dec 2024 22:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991406;
	bh=bIKkvgb7Ou+BR+ozeEU6hYVd1XqS0rXw5hoIlAza8W0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dg3/hWX2gUD3eS1CGIMN/k6QXPR2lA4R/qCmfmufVLiJS/ifLzpW/7ovA2pZ8hxhT
	 8DSux2KvSKoE/acSBN4fUXDpGZr/GXx4a8EbwNUFxbcxICQ09KtS+IgkkeqhtUM378
	 mA/kBVS96pl0PpuGyj0WQ88kkF+7GHler8m34PnHpIvbVefrZXBLeE08/14kJchNBY
	 SHyHpqTixcI6mkiKuzWlGvCsFWwkkr3RIiVr5LWCvFrl10Yel3ZroFCX3Fhsq73fTf
	 vpDAJ6P0v0zadqJ4C8CvrfS+M1LeDe4Yqqw++JEtAVEBylwscB/mqRfHrVfFASRFc7
	 Mtsw57APuwzPg==
Date: Mon, 23 Dec 2024 14:03:26 -0800
Subject: [PATCH 20/52] xfs: add block headers to realtime bitmap and summary
 blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942801.2295836.12902135875585859556.stgit@frogsfrogsfrogs>
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

Source kernel commit: 118895aa9513412b9077a8cae0bc63df8956f9b2

Upgrade rtbitmap and rtsummary blocks to have self describing metadata
like most every other thing in XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h   |    3 +
 libxfs/xfs_format.h   |   18 ++++++
 libxfs/xfs_ondisk.h   |    1 
 libxfs/xfs_rtbitmap.c |  144 ++++++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_rtbitmap.h |   50 ++++++++++++++++-
 libxfs/xfs_sb.c       |   21 ++++++-
 libxfs/xfs_shared.h   |    2 +
 7 files changed, 218 insertions(+), 21 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index c03246a08a4af3..92c01c52e99e4a 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -101,7 +101,8 @@ typedef struct xfs_mount {
 	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
-	uint			m_blockwmask;	/* blockwsize-1 */
+	/* number of rt extents per rt bitmap block if rtgroups enabled */
+	unsigned int		m_rtx_per_rbmblock;
 	uint			m_alloc_mxr[2];	/* XFS_ALLOC_BLOCK_MAXRECS */
 	uint			m_alloc_mnr[2];	/* XFS_ALLOC_BLOCK_MINRECS */
 	uint			m_bmap_dmxr[2];	/* XFS_BMAP_BLOCK_DMAXRECS */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 3cf044a2d5f2a9..016ee4ff537440 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1278,6 +1278,24 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
 #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
+/*
+ * RT bit manipulation macros.
+ */
+#define XFS_RTBITMAP_MAGIC	0x424D505A	/* BMPZ */
+#define XFS_RTSUMMARY_MAGIC	0x53554D59	/* SUMY */
+
+struct xfs_rtbuf_blkinfo {
+	__be32		rt_magic;	/* validity check on block */
+	__be32		rt_crc;		/* CRC of block */
+	__be64		rt_owner;	/* inode that owns the block */
+	__be64		rt_blkno;	/* first block of the buffer */
+	__be64		rt_lsn;		/* sequence number of last write */
+	uuid_t		rt_uuid;	/* filesystem we belong to */
+};
+
+#define XFS_RTBUF_CRC_OFF \
+	offsetof(struct xfs_rtbuf_blkinfo, rt_crc)
+
 /*
  * Dquot and dquot block format definitions
  */
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 38b314113d8f24..6a2bcbc392842c 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -76,6 +76,7 @@ xfs_check_ondisk_structs(void)
 	/* realtime structures */
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
 	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 5e63340668a03d..580e74b7d317db 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -24,23 +24,77 @@
  * Realtime allocator bitmap functions shared with userspace.
  */
 
-/*
- * Real time buffers need verifiers to avoid runtime warnings during IO.
- * We don't have anything to verify, however, so these are just dummy
- * operations.
- */
+static xfs_failaddr_t
+xfs_rtbuf_verify(
+	struct xfs_buf			*bp)
+{
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+	if (!xfs_verify_magic(bp, hdr->rt_magic))
+		return __this_address;
+	if (!xfs_has_rtgroups(mp))
+		return __this_address;
+	if (!xfs_has_crc(mp))
+		return __this_address;
+	if (!uuid_equal(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid))
+		return __this_address;
+	if (hdr->rt_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
+		return __this_address;
+	return NULL;
+}
+
 static void
 xfs_rtbuf_verify_read(
-	struct xfs_buf	*bp)
+	struct xfs_buf			*bp)
 {
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+	xfs_failaddr_t			fa;
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+
+	if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr->rt_lsn))) {
+		fa = __this_address;
+		goto fail;
+	}
+
+	if (!xfs_buf_verify_cksum(bp, XFS_RTBUF_CRC_OFF)) {
+		fa = __this_address;
+		goto fail;
+	}
+
+	fa = xfs_rtbuf_verify(bp);
+	if (fa)
+		goto fail;
+
 	return;
+fail:
+	xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 }
 
 static void
 xfs_rtbuf_verify_write(
 	struct xfs_buf	*bp)
 {
-	return;
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+	struct xfs_buf_log_item		*bip = bp->b_log_item;
+	xfs_failaddr_t			fa;
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+
+	fa = xfs_rtbuf_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+
+	if (bip)
+		hdr->rt_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+	xfs_buf_update_cksum(bp, XFS_RTBUF_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_rtbuf_ops = {
@@ -49,6 +103,22 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
 	.verify_write = xfs_rtbuf_verify_write,
 };
 
+const struct xfs_buf_ops xfs_rtbitmap_buf_ops = {
+	.name		= "xfs_rtbitmap",
+	.magic		= { 0, cpu_to_be32(XFS_RTBITMAP_MAGIC) },
+	.verify_read	= xfs_rtbuf_verify_read,
+	.verify_write	= xfs_rtbuf_verify_write,
+	.verify_struct	= xfs_rtbuf_verify,
+};
+
+const struct xfs_buf_ops xfs_rtsummary_buf_ops = {
+	.name		= "xfs_rtsummary",
+	.magic		= { 0, cpu_to_be32(XFS_RTSUMMARY_MAGIC) },
+	.verify_read	= xfs_rtbuf_verify_read,
+	.verify_write	= xfs_rtbuf_verify_write,
+	.verify_struct	= xfs_rtbuf_verify,
+};
+
 /* Release cached rt bitmap and summary buffers. */
 void
 xfs_rtbuf_cache_relse(
@@ -128,12 +198,24 @@ xfs_rtbuf_get(
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, args->tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+				   mp->m_bsize, 0, &bp,
+				   xfs_rtblock_ops(mp, type));
 	if (xfs_metadata_is_sick(error))
 		xfs_rtginode_mark_sick(args->rtg, type);
 	if (error)
 		return error;
 
+	if (xfs_has_rtgroups(mp)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
+			xfs_buf_mark_corrupt(bp);
+			xfs_trans_brelse(args->tp, bp);
+			xfs_rtginode_mark_sick(args->rtg, type);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	xfs_trans_buf_set_type(args->tp, bp, buf_type);
 	*cbpp = bp;
 	*coffp = block;
@@ -1144,6 +1226,19 @@ xfs_rtalloc_extent_is_free(
 	return 0;
 }
 
+/* Compute the number of rt extents tracked by a single bitmap block. */
+xfs_rtxnum_t
+xfs_rtbitmap_rtx_per_rbmblock(
+	struct xfs_mount	*mp)
+{
+	unsigned int		rbmblock_bytes = mp->m_sb.sb_blocksize;
+
+	if (xfs_has_rtgroups(mp))
+		rbmblock_bytes -= sizeof(struct xfs_rtbuf_blkinfo);
+
+	return rbmblock_bytes * NBBY;
+}
+
 /*
  * Compute the number of rtbitmap blocks needed to track the given number of rt
  * extents.
@@ -1153,7 +1248,7 @@ xfs_rtbitmap_blockcount_len(
 	struct xfs_mount	*mp,
 	xfs_rtbxlen_t		rtextents)
 {
-	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
+	return howmany_64(rtextents, xfs_rtbitmap_rtx_per_rbmblock(mp));
 }
 
 /* How many rt extents does each rtbitmap file track? */
@@ -1190,11 +1285,12 @@ xfs_rtsummary_blockcount(
 	struct xfs_mount	*mp,
 	unsigned int		*rsumlevels)
 {
+	xfs_rtbxlen_t		rextents = xfs_rtbitmap_bitcount(mp);
 	unsigned long long	rsumwords;
 
-	*rsumlevels = xfs_compute_rextslog(xfs_rtbitmap_bitcount(mp)) + 1;
-	rsumwords = xfs_rtbitmap_blockcount(mp) * (*rsumlevels);
-	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
+	*rsumlevels = xfs_compute_rextslog(rextents) + 1;
+	rsumwords = xfs_rtbitmap_blockcount_len(mp, rextents) * (*rsumlevels);
+	return howmany_64(rsumwords, mp->m_blockwsize);
 }
 
 static int
@@ -1246,6 +1342,7 @@ xfs_rtfile_initialize_block(
 	struct xfs_inode	*ip = rtg->rtg_inodes[type];
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
+	void			*bufdata;
 	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
 	enum xfs_blft		buf_type;
 	int			error;
@@ -1269,13 +1366,30 @@ xfs_rtfile_initialize_block(
 		xfs_trans_cancel(tp);
 		return error;
 	}
+	bufdata = bp->b_addr;
 
 	xfs_trans_buf_set_type(tp, bp, buf_type);
-	bp->b_ops = &xfs_rtbuf_ops;
+	bp->b_ops = xfs_rtblock_ops(mp, type);
+
+	if (xfs_has_rtgroups(mp)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		if (type == XFS_RTGI_BITMAP)
+			hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
+		else
+			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
+		hdr->rt_owner = cpu_to_be64(ip->i_ino);
+		hdr->rt_blkno = cpu_to_be64(XFS_FSB_TO_DADDR(mp, fsbno));
+		hdr->rt_lsn = 0;
+		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
+
+		bufdata += sizeof(*hdr);
+	}
+
 	if (data)
-		memcpy(bp->b_addr, data, copylen);
+		memcpy(bufdata, data, copylen);
 	else
-		memset(bp->b_addr, 0, copylen);
+		memset(bufdata, 0, copylen);
 	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 	return xfs_trans_commit(tp);
 }
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index b2b9e59a87a278..2286a98ecb32bb 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -150,6 +150,9 @@ xfs_rtx_to_rbmblock(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
+	if (xfs_has_rtgroups(mp))
+		return div_u64(rtx, mp->m_rtx_per_rbmblock);
+
 	return rtx >> mp->m_blkbit_log;
 }
 
@@ -159,6 +162,13 @@ xfs_rtx_to_rbmword(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
+	if (xfs_has_rtgroups(mp)) {
+		unsigned int	mod;
+
+		div_u64_rem(rtx >> XFS_NBWORDLOG, mp->m_blockwsize, &mod);
+		return mod;
+	}
+
 	return (rtx >> XFS_NBWORDLOG) & (mp->m_blockwsize - 1);
 }
 
@@ -168,6 +178,9 @@ xfs_rbmblock_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_fileoff_t		rbmoff)
 {
+	if (xfs_has_rtgroups(mp))
+		return rbmoff * mp->m_rtx_per_rbmblock;
+
 	return rbmoff << mp->m_blkbit_log;
 }
 
@@ -177,7 +190,14 @@ xfs_rbmblock_wordptr(
 	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_rtword_raw	*words = args->rbmbp->b_addr;
+	struct xfs_mount	*mp = args->mp;
+	union xfs_rtword_raw	*words;
+	struct xfs_rtbuf_blkinfo *hdr = args->rbmbp->b_addr;
+
+	if (xfs_has_rtgroups(mp))
+		words = (union xfs_rtword_raw *)(hdr + 1);
+	else
+		words = args->rbmbp->b_addr;
 
 	return words + index;
 }
@@ -227,6 +247,9 @@ xfs_rtsumoffs_to_block(
 	struct xfs_mount	*mp,
 	xfs_rtsumoff_t		rsumoff)
 {
+	if (xfs_has_rtgroups(mp))
+		return rsumoff / mp->m_blockwsize;
+
 	return XFS_B_TO_FSBT(mp, rsumoff * sizeof(xfs_suminfo_t));
 }
 
@@ -241,6 +264,9 @@ xfs_rtsumoffs_to_infoword(
 {
 	unsigned int		mask = mp->m_blockmask >> XFS_SUMINFOLOG;
 
+	if (xfs_has_rtgroups(mp))
+		return rsumoff % mp->m_blockwsize;
+
 	return rsumoff & mask;
 }
 
@@ -250,7 +276,13 @@ xfs_rsumblock_infoptr(
 	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_suminfo_raw	*info = args->sumbp->b_addr;
+	union xfs_suminfo_raw	*info;
+	struct xfs_rtbuf_blkinfo *hdr = args->sumbp->b_addr;
+
+	if (xfs_has_rtgroups(args->mp))
+		info = (union xfs_suminfo_raw *)(hdr + 1);
+	else
+		info = args->sumbp->b_addr;
 
 	return info + index;
 }
@@ -279,6 +311,19 @@ xfs_suminfo_add(
 	return info->old;
 }
 
+static inline const struct xfs_buf_ops *
+xfs_rtblock_ops(
+	struct xfs_mount	*mp,
+	enum xfs_rtg_inodes	type)
+{
+	if (xfs_has_rtgroups(mp)) {
+		if (type == XFS_RTGI_SUMMARY)
+			return &xfs_rtsummary_buf_ops;
+		return &xfs_rtbitmap_buf_ops;
+	}
+	return &xfs_rtbuf_ops;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
@@ -324,6 +369,7 @@ int xfs_rtfree_extent(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 int xfs_rtfree_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		xfs_fsblock_t rtbno, xfs_filblks_t rtlen);
 
+xfs_rtxnum_t xfs_rtbitmap_rtx_per_rbmblock(struct xfs_mount *mp);
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp);
 xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 88fb4890d95a72..87be47083aa571 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -243,11 +243,26 @@ xfs_extents_per_rbm(
 	return sbp->sb_rextents;
 }
 
+/*
+ * Return the payload size of a single rt bitmap block (without the metadata
+ * header if any).
+ */
+static inline unsigned int
+xfs_rtbmblock_size(
+	struct xfs_sb		*sbp)
+{
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR))
+		return sbp->sb_blocksize - sizeof(struct xfs_rtbuf_blkinfo);
+	return sbp->sb_blocksize;
+}
+
 static uint64_t
 xfs_expected_rbmblocks(
 	struct xfs_sb		*sbp)
 {
-	return howmany_64(xfs_extents_per_rbm(sbp), NBBY * sbp->sb_blocksize);
+	return howmany_64(xfs_extents_per_rbm(sbp),
+			  NBBY * xfs_rtbmblock_size(sbp));
 }
 
 /* Validate the realtime geometry */
@@ -1109,8 +1124,8 @@ xfs_sb_mount_common(
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
 	mp->m_blockmask = sbp->sb_blocksize - 1;
-	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
-	mp->m_blockwmask = mp->m_blockwsize - 1;
+	mp->m_blockwsize = xfs_rtbmblock_size(sbp) >> XFS_WORDLOG;
+	mp->m_rtx_per_rbmblock = mp->m_blockwsize << XFS_NBWORDLOG;
 
 	ags->blocks = mp->m_sb.sb_agblocks;
 	ags->blklog = mp->m_sb.sb_agblklog;
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 552365d212ea26..9363f918675ac0 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -38,6 +38,8 @@ extern const struct xfs_buf_ops xfs_inode_buf_ops;
 extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
+extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;

