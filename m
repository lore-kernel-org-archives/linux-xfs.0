Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868B0BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljxUSdQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5325BC433C8;
	Sun, 31 Dec 2023 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057603;
	bh=NMudRqQsATVukR8CZgrvUnd0IKc5A2hzlwaNRSauDQs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ljxUSdQWmeIsG1OPowzkV5Ei/uD6rVeVIAH9O3IgZIuO4Ex/MG4saHkJ1U0QKenC2
	 JPwRslaEkSrUfQp0Fd3PRqnV1J5jbIpdhWS8xHiq5I4SOhPZUwl6WPvxJbD79m+70w
	 3tTTtuUpNJfplMa27ZNpuN5L4xBRQN+V+ScBEkLhkjI6nSRNAjgtoQ/Crk71hq7J2S
	 HEXOamc0+mjKmoJtYpd4WG26QvJNRS4KaE9CfhZAY+eJBRJl1+0TqfK2/wLJEQ2+uR
	 3X02Jdd5pewECUMr22567HQ/xZxqKULQSh5xTdub4gTDKP6eOOMxTfZOEL3UhJ6VtY
	 LQ4wMBXpZLhdg==
Date: Sun, 31 Dec 2023 13:20:02 -0800
Subject: [PATCH 17/24] xfs: add block headers to realtime summary blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846512.1763124.5719004400299158627.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

Upgrade rtsummary blocks to have self describing metadata like most
every other thing in XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h      |    1 +
 fs/xfs/libxfs/xfs_rtbitmap.c    |   18 +++++++++++++++---
 fs/xfs/libxfs/xfs_rtbitmap.h    |   19 +++++++++++++++++--
 fs/xfs/libxfs/xfs_shared.h      |    1 +
 fs/xfs/scrub/rtsummary_repair.c |   15 +++++++++++++--
 fs/xfs/xfs_buf_item_recover.c   |   11 +++++++----
 fs/xfs/xfs_rtalloc.c            |    7 +++++--
 7 files changed, 59 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 77422fbd3372e..f2c70e1027ed7 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1303,6 +1303,7 @@ static inline bool xfs_dinode_has_large_extent_counts(
  * RT bit manipulation macros.
  */
 #define XFS_RTBITMAP_MAGIC	0x424D505A	/* BMPZ */
+#define XFS_RTSUMMARY_MAGIC	0x53554D59	/* SUMY */
 
 struct xfs_rtbuf_blkinfo {
 	__be32		rt_magic;	/* validity check on block */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 4d85b8ea9a861..3530524b3fc2b 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -53,7 +53,7 @@ xfs_rtbuf_verify_read(
 	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 	xfs_failaddr_t			fa;
 
-	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
+	if (!xfs_has_rtgroups(mp))
 		return;
 
 	if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr->rt_lsn))) {
@@ -84,7 +84,7 @@ xfs_rtbuf_verify_write(
 	struct xfs_buf_log_item		*bip = bp->b_log_item;
 	xfs_failaddr_t			fa;
 
-	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
+	if (!xfs_has_rtgroups(mp))
 		return;
 
 	fa = xfs_rtbuf_verify(bp);
@@ -112,6 +112,14 @@ const struct xfs_buf_ops xfs_rtbitmap_buf_ops = {
 	.verify_struct	= xfs_rtbuf_verify,
 };
 
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
@@ -197,7 +205,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (xfs_has_rtgroups(mp) && !issum) {
+	if (xfs_has_rtgroups(mp)) {
 		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
 		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
@@ -1277,6 +1285,10 @@ xfs_rtsummary_blockcount(
 	unsigned long long	rsumwords;
 
 	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+
+	if (xfs_has_rtgroups(mp))
+		return howmany_64(rsumwords, mp->m_blockwsize);
+
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 588689e53ba39..e8558db14b9b7 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -250,6 +250,9 @@ xfs_rtsumoffs_to_block(
 	struct xfs_mount	*mp,
 	xfs_rtsumoff_t		rsumoff)
 {
+	if (xfs_has_rtgroups(mp))
+		return rsumoff / mp->m_blockwsize;
+
 	return XFS_B_TO_FSBT(mp, rsumoff * sizeof(xfs_suminfo_t));
 }
 
@@ -264,6 +267,9 @@ xfs_rtsumoffs_to_infoword(
 {
 	unsigned int		mask = mp->m_blockmask >> XFS_SUMINFOLOG;
 
+	if (xfs_has_rtgroups(mp))
+		return rsumoff % mp->m_blockwsize;
+
 	return rsumoff & mask;
 }
 
@@ -273,7 +279,13 @@ xfs_rsumblock_infoptr(
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
@@ -307,8 +319,11 @@ xfs_rtblock_ops(
 	struct xfs_mount	*mp,
 	bool			issum)
 {
-	if (xfs_has_rtgroups(mp) && !issum)
+	if (xfs_has_rtgroups(mp)) {
+		if (issum)
+			return &xfs_rtsummary_buf_ops;
 		return &xfs_rtbitmap_buf_ops;
+	}
 	return &xfs_rtbuf_ops;
 }
 
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index f57788164a702..8ad4b67d6febb 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -39,6 +39,7 @@ extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
+extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index 058c5ebabf9a2..c66373eec436d 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -87,12 +87,23 @@ xrep_rtsummary_prep_buf(
 	ondisk = xfs_rsumblock_infoptr(&rts->args, 0);
 	rts->args.sumbp = NULL;
 
-	bp->b_ops = &xfs_rtbuf_ops;
-
 	error = xfsum_copyout(sc, rts->prep_wordoff, ondisk, mp->m_blockwsize);
 	if (error)
 		return error;
 
+	if (xfs_has_rtgroups(sc->mp)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
+		hdr->rt_owner = cpu_to_be64(sc->ip->i_ino);
+		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
+		hdr->rt_lsn = 0;
+		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
+		bp->b_ops = &xfs_rtsummary_buf_ops;
+	} else {
+		bp->b_ops = &xfs_rtbuf_ops;
+	}
+
 	rts->prep_wordoff += mp->m_blockwsize;
 	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTSUMMARY_BUF);
 	return 0;
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 448df616e975e..2e617041161e0 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -399,7 +399,10 @@ xlog_recover_validate_buf_type(
 		bp->b_ops = xfs_rtblock_ops(mp, false);
 		break;
 	case XFS_BLFT_RTSUMMARY_BUF:
-		/* no magic numbers for verification of RT buffers */
+		if (xfs_has_rtgroups(mp) && magic32 != XFS_RTSUMMARY_MAGIC) {
+			warnmsg = "Bad rtsummary magic!";
+			break;
+		}
 		bp->b_ops = xfs_rtblock_ops(mp, true);
 		break;
 #endif /* CONFIG_XFS_RT */
@@ -735,13 +738,13 @@ xlog_recover_get_buf_lsn(
 	 * UUIDs, so we must recover them immediately.
 	 */
 	blft = xfs_blft_from_flags(buf_f);
-	if (!xfs_has_rtgroups(mp) && blft == XFS_BLFT_RTBITMAP_BUF)
-		goto recover_immediately;
-	if (blft == XFS_BLFT_RTSUMMARY_BUF)
+	if (!xfs_has_rtgroups(mp) && (blft == XFS_BLFT_RTBITMAP_BUF ||
+				      blft == XFS_BLFT_RTSUMMARY_BUF))
 		goto recover_immediately;
 
 	magic32 = be32_to_cpu(*(__be32 *)blk);
 	switch (magic32) {
+	case XFS_RTSUMMARY_MAGIC:
 	case XFS_RTBITMAP_MAGIC: {
 		struct xfs_rtbuf_blkinfo	*hdr = blk;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 924266978ca27..ff08c1d997fdb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -784,10 +784,13 @@ xfs_growfs_init_rtbuf(
 	bp->b_ops = xfs_rtblock_ops(mp, buf_type == XFS_BLFT_RTSUMMARY_BUF);
 	memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 
-	if (xfs_has_rtgroups(mp) && buf_type == XFS_BLFT_RTBITMAP_BUF) {
+	if (xfs_has_rtgroups(mp)) {
 		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
-		hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
+		if (buf_type == XFS_BLFT_RTBITMAP_BUF)
+			hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
+		else
+			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
 		hdr->rt_owner = cpu_to_be64(ip->i_ino);
 		hdr->rt_blkno = cpu_to_be64(d);
 		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);

