Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE7026A0A7
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291795; cv=none; b=M96SHsGsDSmkB2C5RzhM7PrSy8pPpmQzcpE6WG36WBIunVddROkI+ICJPRvZAyCcKjnKYMMtbKxA5nhlgtKjSvP37Al1PCJCZh5nzDYVeUxXBexoQe0XZJ1qc89s7nZK+d8DqRRxxExLnoTBTOXC3peFPMVXi8pTNN9krz5lVAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291795; c=relaxed/simple;
	bh=7yKUnmuRtM/IY3yXYDfjJ9HtPUKM1QeuDszBDFh1GPI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfUrjuDiwLhjoA+yNeFIpPNku70ent+Hh/PiOmLac1dcmqxy/1NUD1mo2zulgnq3iaCyt4IwniiYmVbB2RKjpMNeDKhUiH4hTyZ+6IL74he1xf0jM0RF8FRd7e3TxkEIhG9a8P0vrmFJFF6fGRYoPmO9P/fSxB8i6cJ8XIt2X64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ix3DEggk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ix3DEggk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1DCC4CEF7;
	Mon, 23 Mar 2026 18:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291795;
	bh=7yKUnmuRtM/IY3yXYDfjJ9HtPUKM1QeuDszBDFh1GPI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ix3DEggk8ofDARAf0Io0UsxxOHGDJfu7w1b+QFJGleEWmtRgeflYLb18qmq1+Zv/9
	 7Pt+SoLASJcvgIo7+XaDZ4uMyCVZFB6igdpzUFNgU/j88wNExQDg7+v71dDCNI7Hng
	 N+GXE2KF30NnFEp8iqYwNVSgXFTqneWPkLZgiGN4D6uArG+AWLh5Mbc95zF0ezPaS1
	 k1Z3FKlsR1q1LwE03RIBC0JLvJF9W8yyoxmIHkSZZ/Th3yK8IeJAuEYHWvxPliuugB
	 qQQZpDZfzqM6183ogDX7iWsdqOL2v2wd3XAnR5RtXKhrLVCA29vMDcuduFTmnzGnmz
	 2O5b4YZTgf9Gg==
Date: Mon, 23 Mar 2026 11:49:54 -0700
Subject: [PATCH 33/40] xfs: Refactoring the nagcount and delta calculation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, nirjhar.roy.lists@gmail.com,
 linux-xfs@vger.kernel.org
Message-ID: <177429121347.2266274.6741891264280602934.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Source kernel commit: a49b7ff63f98ba1c4503869c568c99ecffa478f2

Introduce xfs_growfs_compute_delta() to calculate the nagcount
and delta blocks and refactor the code from xfs_growfs_data_private().
No functional changes.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.h |    3 +++
 libxfs/xfs_ag.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 1f24cfa2732172..3cd4790768ff91 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -331,6 +331,9 @@ struct aghdr_init_data {
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
+void
+xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
+			int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 5742d59a2659da..fd5f902b052435 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -870,6 +870,34 @@ xfs_ag_shrink_space(
 	return err2;
 }
 
+void
+xfs_growfs_compute_deltas(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		nb,
+	int64_t			*deltap,
+	xfs_agnumber_t		*nagcountp)
+{
+	xfs_rfsblock_t	nb_div, nb_mod;
+	int64_t		delta;
+	xfs_agnumber_t	nagcount;
+
+	nb_div = nb;
+	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
+	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
+		nb_div++;
+	else if (nb_mod)
+		nb = nb_div * mp->m_sb.sb_agblocks;
+
+	if (nb_div > XFS_MAX_AGNUMBER + 1) {
+		nb_div = XFS_MAX_AGNUMBER + 1;
+		nb = nb_div * mp->m_sb.sb_agblocks;
+	}
+	nagcount = nb_div;
+	delta = nb - mp->m_sb.sb_dblocks;
+	*deltap = delta;
+	*nagcountp = nagcount;
+}
+
 /*
  * Extent the AG indicated by the @id by the length passed in
  */

