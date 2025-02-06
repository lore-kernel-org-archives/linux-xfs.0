Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C2D226876
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824399; cv=none; b=SjcZ1ys14B1tPpPzD70u6pHEIKD/NNm7XbhS2SPSQ35EBlaQGNeBPxlGRyIvq2+paz5K7bbcA76VuAfubnRbUYI15qrsvjBf1oERqNipGY/jm4buQiF6oIzcdLHeFtL10AoLbpJ9OyoTnbbE3FIpRWi1+chiiadrRFh5a0hdbhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824399; c=relaxed/simple;
	bh=G1ZL9jl94oN3AucbMIBlnRrkdV5sL+cbwDaNBKtU+lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqrFV1b1TuZHo0vIdim7pimYXh0bcL4TumO1AMgsd7clK5IIS9nbOq8Zxgn/uX7XRjPQNZxrGjajXXMiXKTzwqtn9w40I24aNQylnF6Zu5/VvjnRag0n+Xk04lCJiiGPweNwnlPRI9WiTdAq6Xq+WYptTjPqiHW0f3kH5LMQLNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XtgiXpl4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XtgiXpl4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZWABWFKx826Yci8ZkfyZyj/Bik2drkWSczVCAq1FuaU=; b=XtgiXpl40HXOEWCCNhYOKEclcZ
	0BhxpEmAMDEtD14kd4LTnqTyxcydRguGg7aRJV9pKEHbmF7Exae5175IXerTIPPdH+Fl110CwOwv2
	Wd31A0V91xH59fHqE1TEa2hzvnv7mJDkrUscTnxSpoY7FW8lRNdNBuQF5N7mX2rKlupsym3kgjwJW
	Bx14fyxt6U+bHOdXJCPcwg0s/+nQDni9Fp/VjhM4uf6pcsPgVXEDsy8IE5jWNQ5TvICLglHOHtOJN
	SwQbINz9AGvKftxBWZfqF+J52M8LOEGKHoBeitnw2HHUeStB725aGNv0h0U/OGFa5AiO1yItTn+oy
	TbYLndJw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfven-00000005Qgu-0Z1G;
	Thu, 06 Feb 2025 06:46:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 29/43] xfs: support growfs on zoned file systems
Date: Thu,  6 Feb 2025 07:44:45 +0100
Message-ID: <20250206064511.2323878-30-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace the inner loop growing one RT bitmap block at a time with
one just modifying the superblock counters for growing an entire
zone (aka RTG).  The big restriction is just like at mkfs time only
a RT extent size of a single FSB is allowed, and the file system
capacity needs to be aligned to the zone size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 121 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 101 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6a45749daf57..8bfdd8d6fab1 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -860,6 +860,84 @@ xfs_growfs_rt_init_rtsb(
 	return error;
 }
 
+static void
+xfs_growfs_rt_sb_fields(
+	struct xfs_trans	*tp,
+	const struct xfs_mount	*nmp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	if (nmp->m_sb.sb_rextsize != mp->m_sb.sb_rextsize)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSIZE,
+			nmp->m_sb.sb_rextsize - mp->m_sb.sb_rextsize);
+	if (nmp->m_sb.sb_rbmblocks != mp->m_sb.sb_rbmblocks)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RBMBLOCKS,
+			nmp->m_sb.sb_rbmblocks - mp->m_sb.sb_rbmblocks);
+	if (nmp->m_sb.sb_rblocks != mp->m_sb.sb_rblocks)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RBLOCKS,
+			nmp->m_sb.sb_rblocks - mp->m_sb.sb_rblocks);
+	if (nmp->m_sb.sb_rextents != mp->m_sb.sb_rextents)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTENTS,
+			nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents);
+	if (nmp->m_sb.sb_rextslog != mp->m_sb.sb_rextslog)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSLOG,
+			nmp->m_sb.sb_rextslog - mp->m_sb.sb_rextslog);
+	if (nmp->m_sb.sb_rgcount != mp->m_sb.sb_rgcount)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RGCOUNT,
+			nmp->m_sb.sb_rgcount - mp->m_sb.sb_rgcount);
+}
+
+static int
+xfs_growfs_rt_zoned(
+	struct xfs_rtgroup	*rtg,
+	xfs_rfsblock_t		nrblocks)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_mount	*nmp;
+	struct xfs_trans	*tp;
+	xfs_rtbxlen_t		freed_rtx;
+	int			error;
+
+	/*
+	 * Calculate new sb and mount fields for this round.  Also ensure the
+	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
+	 */
+	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks,
+			mp->m_sb.sb_rextsize);
+	if (!nmp)
+		return -ENOMEM;
+	freed_rtx = nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents;
+
+	xfs_rtgroup_calc_geometry(nmp, rtg, rtg_rgno(rtg),
+			nmp->m_sb.sb_rgcount, nmp->m_sb.sb_rextents);
+
+	error = xfs_trans_alloc(mp, &M_RES(nmp)->tr_growrtfree, 0, 0, 0, &tp);
+	if (error)
+		goto out_free;
+
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
+
+	xfs_growfs_rt_sb_fields(tp, nmp);
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, freed_rtx);
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_free;
+
+	/*
+	 * Ensure the mount RT feature flag is now set, and compute new
+	 * maxlevels for rt btrees.
+	 */
+	mp->m_features |= XFS_FEAT_REALTIME;
+	xfs_rtrmapbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
+	xfs_zoned_add_available(mp, freed_rtx);
+out_free:
+	kfree(nmp);
+	return error;
+}
+
 static int
 xfs_growfs_rt_bmblock(
 	struct xfs_rtgroup	*rtg,
@@ -945,24 +1023,7 @@ xfs_growfs_rt_bmblock(
 	/*
 	 * Update superblock fields.
 	 */
-	if (nmp->m_sb.sb_rextsize != mp->m_sb.sb_rextsize)
-		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTSIZE,
-			nmp->m_sb.sb_rextsize - mp->m_sb.sb_rextsize);
-	if (nmp->m_sb.sb_rbmblocks != mp->m_sb.sb_rbmblocks)
-		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RBMBLOCKS,
-			nmp->m_sb.sb_rbmblocks - mp->m_sb.sb_rbmblocks);
-	if (nmp->m_sb.sb_rblocks != mp->m_sb.sb_rblocks)
-		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RBLOCKS,
-			nmp->m_sb.sb_rblocks - mp->m_sb.sb_rblocks);
-	if (nmp->m_sb.sb_rextents != mp->m_sb.sb_rextents)
-		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTENTS,
-			nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents);
-	if (nmp->m_sb.sb_rextslog != mp->m_sb.sb_rextslog)
-		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTSLOG,
-			nmp->m_sb.sb_rextslog - mp->m_sb.sb_rextslog);
-	if (nmp->m_sb.sb_rgcount != mp->m_sb.sb_rgcount)
-		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RGCOUNT,
-			nmp->m_sb.sb_rgcount - mp->m_sb.sb_rgcount);
+	xfs_growfs_rt_sb_fields(args.tp, nmp);
 
 	/*
 	 * Free the new extent.
@@ -1129,6 +1190,11 @@ xfs_growfs_rtg(
 			goto out_rele;
 	}
 
+	if (xfs_has_zoned(mp)) {
+		error = xfs_growfs_rt_zoned(rtg, nrblocks);
+		goto out_rele;
+	}
+
 	error = xfs_growfs_rt_alloc_blocks(rtg, nrblocks, rextsize, &bmblocks);
 	if (error)
 		goto out_rele;
@@ -1148,8 +1214,7 @@ xfs_growfs_rtg(
 
 	if (old_rsum_cache)
 		kvfree(old_rsum_cache);
-	xfs_rtgroup_rele(rtg);
-	return 0;
+	goto out_rele;
 
 out_error:
 	/*
@@ -1197,6 +1262,22 @@ xfs_growfs_check_rtgeom(
 
 	if (min_logfsbs > mp->m_sb.sb_logblocks)
 		return -EINVAL;
+
+	if (xfs_has_zoned(mp)) {
+		uint32_t	gblocks = mp->m_groups[XG_TYPE_RTG].blocks;
+		uint32_t	rem;
+
+		if (rextsize != 1)
+			return -EINVAL;
+		div_u64_rem(mp->m_sb.sb_rblocks, gblocks, &rem);
+		if (rem) {
+			xfs_warn(mp,
+"new RT volume size (%lld) not aligned to RT group size (%d)",
+				mp->m_sb.sb_rblocks, gblocks);
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.45.2

