Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F62CC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWex1ydc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFC6C433C8;
	Sun, 31 Dec 2023 23:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066657;
	bh=rOIGPq+34GBiBEuWKu+or9Dc8O15YQHSeWoypZgYins=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cWex1ydcnedxA7dTGqMUTmpC8o40f+nzmL62xFrPsDeCWKPlrCIN6OHZ17UuIcW7E
	 rhOxdYrAefCxj7aTglJyyKaVfpfjCflSZX06vmFxHL52ZCwq4QPDwWjy6sJECXI6Kr
	 ZrcdMsvBnwHtQ2WysSO55bMYSUiZhaszQHDdj/kr5e8qWexcGvaUteAdHmnXyVfKn6
	 ExXb13VARVOwb4h8ghf4+BRX5OymVACAtI7lyIYV8EjCFO9B2AgACl1bZ8VF8tBqXV
	 v6GtUnmyxWlMVBzRhiSgvBIKLO+Vd/RSNnKOhYBOJbcZIArDwwxoILv7Zjb2b//jNd
	 ul0qdP7/rooZw==
Date: Sun, 31 Dec 2023 15:50:57 -0800
Subject: [PATCH 13/52] xfs: add block headers to realtime bitmap blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012343.1811243.2668472766360541897.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Upgrade rtbitmap blocks to have self describing metadata like most every
other thing in XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h   |    3 +
 libxfs/xfs_format.h   |   14 ++++++
 libxfs/xfs_ondisk.h   |    1 
 libxfs/xfs_rtbitmap.c |  106 +++++++++++++++++++++++++++++++++++++++++++++----
 libxfs/xfs_rtbitmap.h |   33 +++++++++++++++
 libxfs/xfs_sb.c       |   18 ++++++--
 libxfs/xfs_shared.h   |    1 
 7 files changed, 161 insertions(+), 15 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 184e7a38fb3..ecee4ccc0b7 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -83,7 +83,8 @@ typedef struct xfs_mount {
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
index 43e66740e2a..7178bd463c1 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1300,6 +1300,20 @@ static inline bool xfs_dinode_has_large_extent_counts(
 /*
  * RT bit manipulation macros.
  */
+#define XFS_RTBITMAP_MAGIC	0x424D505A	/* BMPZ */
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
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 65219d4cf99..70b96efa269 100644
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
index c2970b78ce8..3aa2c163725 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -21,23 +21,77 @@
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
+	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
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
+	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
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
@@ -46,6 +100,14 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
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
 /* Release cached rt bitmap and summary buffers. */
 void
 xfs_rtbuf_cache_relse(
@@ -123,13 +185,26 @@ xfs_rtbuf_get(
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, args->tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+				   mp->m_bsize, 0, &bp,
+				   xfs_rtblock_ops(mp, issum));
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
 					     XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 
+	if (xfs_has_rtgroups(mp) && !issum) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
+			xfs_buf_mark_corrupt(bp);
+			xfs_trans_brelse(args->tp, bp);
+			xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+						     XFS_SICK_RT_BITMAP);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	xfs_trans_buf_set_type(args->tp, bp, type);
 	*cbpp = bp;
 	*coffp = block;
@@ -1123,6 +1198,19 @@ xfs_rtalloc_extent_is_free(
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
@@ -1132,7 +1220,7 @@ xfs_rtbitmap_blockcount(
 	struct xfs_mount	*mp,
 	xfs_rtbxlen_t		rtextents)
 {
-	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
+	return howmany_64(rtextents, xfs_rtbitmap_rtx_per_rbmblock(mp));
 }
 
 /*
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 3de0ec2d241..e1cf47d2a92 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -148,6 +148,9 @@ xfs_rtx_to_rbmblock(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
+	if (xfs_has_rtgroups(mp))
+		return div_u64(rtx, mp->m_rtx_per_rbmblock);
+
 	return rtx >> mp->m_blkbit_log;
 }
 
@@ -157,6 +160,13 @@ xfs_rtx_to_rbmword(
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
 
@@ -166,6 +176,9 @@ xfs_rbmblock_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_fileoff_t		rbmoff)
 {
+	if (xfs_has_rtgroups(mp))
+		return rbmoff * mp->m_rtx_per_rbmblock;
+
 	return rbmoff << mp->m_blkbit_log;
 }
 
@@ -175,7 +188,14 @@ xfs_rbmblock_wordptr(
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
@@ -277,6 +297,16 @@ xfs_suminfo_add(
 	return info->old;
 }
 
+static inline const struct xfs_buf_ops *
+xfs_rtblock_ops(
+	struct xfs_mount	*mp,
+	bool			issum)
+{
+	if (xfs_has_rtgroups(mp) && !issum)
+		return &xfs_rtbitmap_buf_ops;
+	return &xfs_rtbuf_ops;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
@@ -365,6 +395,7 @@ xfs_validate_rtextents(
 	return true;
 }
 
+xfs_rtxnum_t xfs_rtbitmap_rtx_per_rbmblock(struct xfs_mount *mp);
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 0ded5220161..d04a8e15331 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -575,10 +575,15 @@ xfs_validate_sb_common(
 	} else {
 		uint64_t	rexts;
 		uint64_t	rbmblocks;
+		unsigned int	rbmblock_bytes = sbp->sb_blocksize;
 
 		rexts = div_u64(sbp->sb_rblocks, sbp->sb_rextsize);
-		rbmblocks = howmany_64(sbp->sb_rextents,
-				       NBBY * sbp->sb_blocksize);
+
+		if (xfs_sb_is_v5(sbp) &&
+		    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTGROUPS))
+			rbmblock_bytes -= sizeof(struct xfs_rtbuf_blkinfo);
+
+		rbmblocks = howmany_64(sbp->sb_rextents, NBBY * rbmblock_bytes);
 
 		if (!xfs_validate_rtextents(rexts) ||
 		    sbp->sb_rextents != rexts ||
@@ -1091,8 +1096,13 @@ xfs_sb_mount_common(
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
 	mp->m_blockmask = sbp->sb_blocksize - 1;
-	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
-	mp->m_blockwmask = mp->m_blockwsize - 1;
+	if (xfs_has_rtgroups(mp))
+		mp->m_blockwsize = (sbp->sb_blocksize -
+					sizeof(struct xfs_rtbuf_blkinfo)) >>
+					XFS_WORDLOG;
+	else
+		mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
+	mp->m_rtx_per_rbmblock = mp->m_blockwsize << XFS_NBWORDLOG;
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 	mp->m_rgblklog = log2_if_power2(sbp->sb_rgblocks);
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 65691af0488..f57788164a7 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -38,6 +38,7 @@ extern const struct xfs_buf_ops xfs_inode_buf_ops;
 extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;

