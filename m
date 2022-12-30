Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B90EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbiLaBbJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbiLaBbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:31:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6492197
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:31:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18AE961C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D05FC433D2;
        Sat, 31 Dec 2022 01:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450266;
        bh=x8+Hy5puTuW68AR/R6ztJMZZ7mDuT6mo/Gq/DyDEEjs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bO24sjFDWGK25RwRHW2cRkzWVGFrRKpLA+nBQSZ88r2hIj5gZEZxmmwlgNQQzo7Ap
         uMJUp1i5R50E0wjdTVbpiiU/lNfquTWXX5HKrSO4Fz19rUvspWboRVzzg4KcWBQ+ax
         MrHPKoKI51Ap5lZc8ECHmhNo+Y1qA8aB5/C2t0AQ7yIEFNe0llzeDZNRbGIpQp8Cz2
         Snz8/SZhwt6a3U8bspWK/ziyLc1svpKZdafyxAHU/bQjyJY9yf4M1H0Up4hHECKk6d
         MIC0CkKf/IdKjvMP/XyfQfwWy4d/h4ZXJrQNd+KHfT/c8RpSNWW9/n4TbPI3dAqaOG
         fCfmMstuCDt4g==
Subject: [PATCH 14/22] xfs: add block headers to realtime bitmap blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:54 -0800
Message-ID: <167243867467.712847.13563897655051444408.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_format.h    |   14 ++++++
 fs/xfs/libxfs/xfs_rtbitmap.c  |  100 +++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_rtbitmap.h  |   30 ++++++++++++
 fs/xfs/libxfs/xfs_sb.c        |   18 ++++++-
 fs/xfs/libxfs/xfs_shared.h    |    1 
 fs/xfs/xfs_buf_item_recover.c |   20 +++++++-
 fs/xfs/xfs_mount.h            |    3 +
 fs/xfs/xfs_ondisk.h           |    1 
 fs/xfs/xfs_rtalloc.c          |   60 ++++++++++++++++++-------
 9 files changed, 213 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index a38e1499bd4b..4096d3f069a3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 4237b5703a64..05b0e4e92a0a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -18,28 +18,84 @@
 #include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_log.h"
+#include "xfs_buf_item.h"
 
 /*
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
@@ -48,6 +104,14 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
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
@@ -81,13 +145,26 @@ xfs_rtbuf_get(
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
@@ -1205,7 +1282,12 @@ xfs_rtbitmap_blockcount(
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index f6a2a48973ab..c1f740fd27b8 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ee4e59453edc..dbbea5b86f27 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -518,10 +518,15 @@ xfs_validate_sb_common(
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
@@ -1032,8 +1037,13 @@ xfs_sb_mount_common(
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
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index bcdf298889af..1c86163915cf 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -38,6 +38,7 @@ extern const struct xfs_buf_ops xfs_inode_buf_ops;
 extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 6587d18b21c3..4dcd5d9d2c7c 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -23,6 +23,7 @@
 #include "xfs_dir2.h"
 #include "xfs_quota.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -391,9 +392,15 @@ xlog_recover_validate_buf_type(
 		break;
 #ifdef CONFIG_XFS_RT
 	case XFS_BLFT_RTBITMAP_BUF:
+		if (xfs_has_rtgroups(mp) && magic32 != XFS_RTBITMAP_MAGIC) {
+			warnmsg = "Bad rtbitmap magic!";
+			break;
+		}
+		bp->b_ops = xfs_rtblock_ops(mp, false);
+		break;
 	case XFS_BLFT_RTSUMMARY_BUF:
 		/* no magic numbers for verification of RT buffers */
-		bp->b_ops = &xfs_rtbuf_ops;
+		bp->b_ops = xfs_rtblock_ops(mp, true);
 		break;
 #endif /* CONFIG_XFS_RT */
 	default:
@@ -728,11 +735,20 @@ xlog_recover_get_buf_lsn(
 	 * UUIDs, so we must recover them immediately.
 	 */
 	blft = xfs_blft_from_flags(buf_f);
-	if (blft == XFS_BLFT_RTBITMAP_BUF || blft == XFS_BLFT_RTSUMMARY_BUF)
+	if (!xfs_has_rtgroups(mp) && blft == XFS_BLFT_RTBITMAP_BUF)
+		goto recover_immediately;
+	if (blft == XFS_BLFT_RTSUMMARY_BUF)
 		goto recover_immediately;
 
 	magic32 = be32_to_cpu(*(__be32 *)blk);
 	switch (magic32) {
+	case XFS_RTBITMAP_MAGIC: {
+		struct xfs_rtbuf_blkinfo	*hdr = blk;
+
+		lsn = be64_to_cpu(hdr->rt_lsn);
+		uuid = &hdr->rt_uuid;
+		break;
+	}
 	case XFS_ABTB_CRC_MAGIC:
 	case XFS_ABTC_CRC_MAGIC:
 	case XFS_ABTB_MAGIC:
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7f0a80a8dcd4..176b2e71da9e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -123,7 +123,8 @@ typedef struct xfs_mount {
 	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
-	uint			m_blockwmask;	/* blockwsize-1 */
+	/* number of rt extents per rt bitmap block if rtgroups enabled */
+	unsigned int		m_rtx_per_rbmblock;
 	uint			m_alloc_mxr[2];	/* max alloc btree records */
 	uint			m_alloc_mnr[2];	/* min alloc btree records */
 	uint			m_bmap_dmxr[2];	/* max bmap btree records */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 61909355731d..17e541d35194 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -76,6 +76,7 @@ xfs_check_ondisk_structs(void)
 	/* realtime structures */
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_ondisk,		4);
 	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_ondisk,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9d8d91fa0ecf..9e013a8e3149 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -791,6 +791,42 @@ xfs_rtallocate_extent_size(
 	return 0;
 }
 
+/* Get a buffer for the block. */
+static int
+xfs_growfs_init_rtbuf(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		fsbno,
+	enum xfs_blft		buf_type)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		d;
+	int			error;
+
+	d = XFS_FSB_TO_DADDR(mp, fsbno);
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0,
+			&bp);
+	if (error)
+		return error;
+
+	xfs_trans_buf_set_type(tp, bp, buf_type);
+	bp->b_ops = xfs_rtblock_ops(mp, buf_type == XFS_BLFT_RTSUMMARY_BUF);
+	memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
+
+	if (xfs_has_rtgroups(mp) && buf_type == XFS_BLFT_RTBITMAP_BUF) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
+		hdr->rt_owner = cpu_to_be64(ip->i_ino);
+		hdr->rt_blkno = cpu_to_be64(d);
+		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
+	}
+
+	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
+	return 0;
+}
+
 /*
  * Allocate space to the bitmap or summary file, and zero it, for growfs.
  */
@@ -802,8 +838,6 @@ xfs_growfs_rt_alloc(
 	struct xfs_inode	*ip)		/* inode (bitmap/summary) */
 {
 	xfs_fileoff_t		bno;		/* block number in file */
-	struct xfs_buf		*bp;	/* temporary buffer for zeroing */
-	xfs_daddr_t		d;		/* disk block address */
 	int			error;		/* error return value */
 	xfs_fsblock_t		fsbno;		/* filesystem block for bno */
 	struct xfs_bmbt_irec	map;		/* block map output */
@@ -878,19 +912,11 @@ xfs_growfs_rt_alloc(
 			 */
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-			/*
-			 * Get a buffer for the block.
-			 */
-			d = XFS_FSB_TO_DADDR(mp, fsbno);
-			error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					mp->m_bsize, 0, &bp);
+
+			error = xfs_growfs_init_rtbuf(tp, ip, fsbno, buf_type);
 			if (error)
 				goto out_trans_cancel;
 
-			xfs_trans_buf_set_type(tp, bp, buf_type);
-			bp->b_ops = &xfs_rtbuf_ops;
-			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
-			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 			/*
 			 * Commit the transaction.
 			 */
@@ -1159,10 +1185,10 @@ xfs_growfs_rt(
 	 * Skip the current block if it is exactly full.
 	 * This also deals with the case where there were no rtextents before.
 	 */
-	for (bmbno = sbp->sb_rbmblocks -
-		     ((sbp->sb_rextents & ((1 << mp->m_blkbit_log) - 1)) != 0);
-	     bmbno < nrbmblocks;
-	     bmbno++) {
+	bmbno = sbp->sb_rbmblocks;
+	if (xfs_rtx_to_rbmword(mp, sbp->sb_rextents) != 0)
+		bmbno--;
+	for (; bmbno < nrbmblocks; bmbno++) {
 		struct xfs_trans	*tp;
 		struct xfs_rtgroup	*rtg;
 		xfs_rfsblock_t		nrblocks_step;
@@ -1177,7 +1203,7 @@ xfs_growfs_rt(
 		nsbp->sb_rextsize = in->extsize;
 		nmp->m_rtxblklog = -1; /* don't use shift or masking */
 		nsbp->sb_rbmblocks = bmbno + 1;
-		nrblocks_step = (bmbno + 1) * NBBY * nsbp->sb_blocksize *
+		nrblocks_step = (bmbno + 1) * mp->m_rtx_per_rbmblock *
 				nsbp->sb_rextsize;
 		nsbp->sb_rblocks = min(nrblocks, nrblocks_step);
 		nsbp->sb_rextents = xfs_rtb_to_rtxt(nmp, nsbp->sb_rblocks);

