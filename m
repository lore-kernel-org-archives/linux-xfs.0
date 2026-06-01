Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126DC352031
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2026 11:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780312118; cv=none; b=FvIsFqML48ZudRq8h5XPbZy9xjQaWHDAzj9CtO3cxPkMWfLC4HexQ9i0ql17iQf9Jsj2UyAItA/Wbn20pbGc15nrqMa5htRLhC/patV26vb+9PCeUHp1ht23QFZ7TSs/SbD1nNWyCmHOPkLpc7H+qnN6GQHtIBzmYjBHPNP3REQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780312118; c=relaxed/simple;
	bh=nNl47rjFfgj2D1mswSid99S0Z8Oa/Wkh74G5YwAHNWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XneoPN31sLz8F2XoPfSJNYg7THr8i6N8EZuU5Qu5EUFMfckSD4g/CJntgHu2/i1hd4JErgUsMPAxmYk6HFRkSVkLb9AnGVSFbtUSkl9f4rai7PVhxNHWrP6kVbagmv7Bepwf5yojGU8mkiAotgBbkgfU9squzlhtibYTPqlNKJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sf8OLmE5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sf8OLmE5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rizL+X4Lpcde1vOezDbo/1Oe3uiCxFEThgoyhB6H6qs=; b=sf8OLmE57a57kjmQpyqNnRY6Ov
	pWIZApn6s3klCSyp+vMfJT+aeF3/n04qo9tgYK0I/Kaw1pKMXaUZnVmtwabkd73trS7eBfrh3dFOA
	qAFHVpoGbHPSoxSaoccmSsgtodyhe456jNBQkEfPT/xcom6Yjcgbiev2bbyusH3xRaTo7CWKuHSft
	tJcBHePbM6aMxK61Dsc0BWMrpduATPX+MFJpVg/ftaIZZUjgfSF1yWrgbAQ++KF6A1DjK8n8YLMC9
	Rmqkx6uQexf9dB17L+WVt0YxhTB0bqRUqTrjQH7o7Uu6TJ7+7WQvLWz/mkuatXhKqP5r8DlINTIDW
	+gUikQyw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU0VX-0000000Aht2-1VeD;
	Mon, 01 Jun 2026 11:08:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Nirjhar Roy <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: cleanup xfs_growfs_compute_deltas
Date: Mon,  1 Jun 2026 13:07:53 +0200
Message-ID: <20260601110824.3392683-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601110824.3392683-1-hch@lst.de>
References: <20260601110824.3392683-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_growfs_compute_deltas has an odd calling conventions, and looks
very convoluted due to the use of do_div and strangely named and typed
variables.

Rename it, make it return the agcount and let the caller calculate the
delta.  The internally use the better div_u64_rem helper and descriptive
variable names and types.  Also add a comment describing what the
function is used for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c | 44 ++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_ag.h |  5 ++---
 fs/xfs/xfs_fsops.c     |  4 +++-
 3 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 0c5f0548021f..095af128d2fb 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -863,32 +863,30 @@ xfs_ag_shrink_space(
 	return err2;
 }
 
-void
-xfs_growfs_compute_deltas(
+/*
+ * Return the agcount for the new file system size passed in *nb and adjust *nb
+ * when it has to be reduced because of maximum AG count or because it would
+ * create a below minimum size AG.
+ */
+xfs_agnumber_t
+xfs_growfs_compute_agcount(
 	struct xfs_mount	*mp,
-	xfs_rfsblock_t		*nb,
-	int64_t			*deltap,
-	xfs_agnumber_t		*nagcountp)
+	xfs_rfsblock_t		*nb)
 {
-	xfs_rfsblock_t	nb_div, nb_mod;
-	int64_t		delta;
-	xfs_agnumber_t	nagcount;
-
-	nb_div = *nb;
-	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
-	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
-		nb_div++;
-	else if (nb_mod)
-		*nb = nb_div * mp->m_sb.sb_agblocks;
-
-	if (nb_div > XFS_MAX_AGNUMBER + 1) {
-		nb_div = XFS_MAX_AGNUMBER + 1;
-		*nb = nb_div * mp->m_sb.sb_agblocks;
+	xfs_agnumber_t		agcount;
+	xfs_extlen_t		remainder;
+
+	agcount = div_u64_rem(*nb, mp->m_sb.sb_agblocks, &remainder);
+	if (agcount > XFS_MAX_AGNUMBER + 1) {
+		agcount = XFS_MAX_AGNUMBER + 1;
+		remainder = 0;
+	}
+	*nb = (xfs_rfsblock_t)agcount * mp->m_sb.sb_agblocks;
+	if (remainder >= XFS_MIN_AG_BLOCKS) {
+		*nb += remainder;
+		agcount++;
 	}
-	nagcount = nb_div;
-	delta = *nb - mp->m_sb.sb_dblocks;
-	*deltap = delta;
-	*nagcountp = nagcount;
+	return agcount;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 8aa4266c5571..fd22fe598931 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -329,12 +329,11 @@ struct aghdr_init_data {
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
-void
-xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t *nb,
-			int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+xfs_agnumber_t xfs_growfs_compute_agcount(struct xfs_mount *mp,
+		xfs_rfsblock_t *nb);
 
 static inline xfs_fsblock_t
 xfs_agbno_to_fsb(
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 436857356a0a..67624a804a7f 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -124,7 +124,9 @@ xfs_growfs_data_private(
 			mp->m_sb.sb_rextsize);
 	if (error)
 		return error;
-	xfs_growfs_compute_deltas(mp, &nb, &delta, &nagcount);
+
+	nagcount = xfs_growfs_compute_agcount(mp, &nb);
+	delta = nb - mp->m_sb.sb_dblocks;
 
 	/*
 	 * Reject filesystems with a single AG because they are not
-- 
2.53.0

