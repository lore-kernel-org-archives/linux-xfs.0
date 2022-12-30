Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC4FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbiLaCdM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiLaCdL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:33:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC0426D9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:33:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD8F861D12
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43431C433EF;
        Sat, 31 Dec 2022 02:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453989;
        bh=CACEG00g6GqQTFzjjpwlDX9faRW2vViRojHtq4YPNkY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UJ5+xdbZvOCcef/S7FZ/x0zg6ufvfbQmaG+4ZZr1nK6c7N885OK5rXl09MMJLsB1P
         reRkpAmVBfr7KI9IMOiUd85UTnUu9XinsYdeLPz9oMAqWe2KIuadB2VdbRdNzGV+wG
         jLx2/SqOI9/QYEZfOvqtGI00jg5tppc8YBo1uN4Nz4OYXsofUMKmnmVP7jPrBAhYws
         3aJqwrPx8n0EC6HSkNjMPigiu2eCCR/0gqvDKXVAJ/FOYS3FsxfalRKpfCC3fiIQ8l
         ngDtNltXUwW/GdEhmP6X/FrVeKb1B3cQI57dwh+TL9UUY30/41qnA6KDR7vD75jSeJ
         bVjgwosU6HyVA==
Subject: [PATCH 12/45] xfs: add block headers to realtime bitmap blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878522.731133.693459915401734066.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Upgrade rtbitmap blocks to have self describing metadata like most every
other thing in XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h   |    3 +-
 libxfs/xfs_format.h   |   14 +++++++
 libxfs/xfs_rtbitmap.c |   98 +++++++++++++++++++++++++++++++++++++++++++++----
 libxfs/xfs_rtbitmap.h |   30 +++++++++++++++
 libxfs/xfs_sb.c       |   18 +++++++--
 libxfs/xfs_shared.h   |    1 +
 6 files changed, 149 insertions(+), 15 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index ed19b15fcb5..040e594f721 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -72,7 +72,8 @@ typedef struct xfs_mount {
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
index a38e1499bd4..4096d3f069a 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1284,6 +1284,20 @@ static inline bool xfs_dinode_has_large_extent_counts(
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
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 5d402b250c8..2e286a22196 100644
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
 /*
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
@@ -79,13 +141,26 @@ xfs_rtbuf_get(
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
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
+		struct xfs_rtbuf_blkinfo *hdr = bp->b_addr;
+
+		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
+			xfs_buf_mark_corrupt(bp);
+			xfs_trans_brelse(tp, bp);
+			xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+						     XFS_SICK_RT_BITMAP);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	xfs_trans_buf_set_type(tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
 					     : XFS_BLFT_RTBITMAP_BUF);
 	*bpp = bp;
@@ -1203,7 +1278,12 @@ xfs_rtbitmap_blockcount(
 	struct xfs_mount	*mp,
 	xfs_rtbxlen_t		rtextents)
 {
-	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
+	unsigned int		rbmblock_bytes = mp->m_sb.sb_blocksize;
+
+	if (xfs_has_rtgroups(mp))
+		rbmblock_bytes -= sizeof(struct xfs_rtbuf_blkinfo);
+
+	return howmany_64(rtextents, NBBY * rbmblock_bytes);
 }
 
 /*
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index f6a2a48973a..c1f740fd27b 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -100,6 +100,9 @@ xfs_rtx_to_rbmblock(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
+	if (xfs_has_rtgroups(mp))
+		return div_u64(rtx, mp->m_rtx_per_rbmblock);
+
 	return rtx >> mp->m_blkbit_log;
 }
 
@@ -109,6 +112,13 @@ xfs_rtx_to_rbmword(
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
 
@@ -118,16 +128,24 @@ xfs_rbmblock_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_fileoff_t		rbmoff)
 {
+	if (xfs_has_rtgroups(mp))
+		return rbmoff * mp->m_rtx_per_rbmblock;
+
 	return rbmoff << mp->m_blkbit_log;
 }
 
 /* Return a pointer to a bitmap word within a rt bitmap block buffer. */
 static inline union xfs_rtword_ondisk *
 xfs_rbmbuf_wordptr(
+	struct xfs_mount	*mp,
 	void			*buf,
 	unsigned int		rbmword)
 {
 	union xfs_rtword_ondisk	*wordp = buf;
+	struct xfs_rtbuf_blkinfo *hdr = buf;
+
+	if (xfs_has_rtgroups(mp))
+		wordp = (union xfs_rtword_ondisk *)(hdr + 1);
 
 	return &wordp[rbmword];
 }
@@ -138,7 +156,7 @@ xfs_rbmblock_wordptr(
 	struct xfs_buf		*bp,
 	unsigned int		rbmword)
 {
-	return xfs_rbmbuf_wordptr(bp->b_addr, rbmword);
+	return xfs_rbmbuf_wordptr(bp->b_mount, bp->b_addr, rbmword);
 }
 
 /*
@@ -200,6 +218,16 @@ xfs_rsumblock_infoptr(
 	return xfs_rsumbuf_infoptr(bp->b_addr, infoword);
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 1bcffb24761..94dc93ed5dc 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -516,10 +516,15 @@ xfs_validate_sb_common(
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
 
 		if (sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents) ||
@@ -1030,8 +1035,13 @@ xfs_sb_mount_common(
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
index bcdf298889a..1c86163915c 100644
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

