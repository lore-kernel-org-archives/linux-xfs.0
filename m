Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B429306776
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022671; cv=none; b=U4ku1WBTB3CnpO4mkodpfedKKzB8YbN7EDGkEebbZQA6dnn0G3bKLC6CHgzISqd0zy/ZiZyK3Sp8ENezBZ2xTVNlq318bLkPSp4ohOakBI2db7rID1TiCPKVVV25L+Rw3UVjWMJ/yi0vUib2nlIXdYdXudfYxfa7jlov0Wc/cg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022671; c=relaxed/simple;
	bh=C1pPCpl8oRFBjEisQPNpfXBUSEA6lbsEHeFs+OsCXM8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/w2hfjB5rKp75NoHBTNaLGzJmUEEJcy1vxH+LgXmNSA0aF4TcBnEStE5bLDmE2DfQdMQooAj9X05B1MWZy/ebUfK/jlOgRStNFOFbnKVQozgj6LVgPA3KDD5bTvzEF/aa+XDYDOLtrYzC2OmU1PNH2o6N/y5OlelSRzzldjeVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8iIROs+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8iIROs+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 355451F000E9;
	Thu,  2 Jul 2026 20:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022670;
	bh=RH8CCqxkJT4aIO+N+rJ/cYQN/IbQlQ9be0XsqUafYH0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=b8iIROs+gU3PtgwoG01QiyKlNZ34R9yW+F3VPeYO1iapVBKYUDFBfOq9CBRNjwlgm
	 PmL14vYbDwCHUqppKdyblgKOTtf6qD2h7c0AYsi4cH2ocCDHlCxfbs1DRc/z/XA6n+
	 d5Vg+QUj3OJ7HF4Iywc55YRRlj6KeF2GA7BMr7yl5d4LWZOFKBOsT83nnZyrpe8GHp
	 Z8nr9HvBzk5qa7z7zDhWCBYX9O82PO61tzL4sdZwDR0ctyk/KEdTcwzP2XxBoXRgG7
	 kdkgVnjx/7v8Zo6Pvrn7nPIAHldg2S++hEVp2w3F+17LDQhR+AojQfiV59ZsP5obKY
	 y0TJd9QDtIs6w==
Date: Thu, 02 Jul 2026 13:04:29 -0700
Subject: [PATCH 16/18] xfs: pass back updated nb from
 xfs_growfs_compute_deltas
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226602.845537.14399721478326718559.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 4cb6e89a3d901d4da515977e55f9a9a779238660

xfs_growfs_compute_deltas can update nb for corner cases like a number
of blocks that would create a less the minimal sized AG, or running
past the max AG limit.  Pass back the calculated value to the caller,
as it relies on to calculate the new number of perag structures.

Note that the grown file system size is not affected by this
miscalculation as it uses the passed back delta value.

Fixes: a49b7ff63f98 ("xfs: Refactoring the nagcount and delta calculation")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.h |    2 +-
 libxfs/xfs_ag.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 16a9b43a3c270c..8aa4266c55714d 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -330,7 +330,7 @@ int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
 void
-xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
+xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t *nb,
 			int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1c75ef51056789..fb8c9bb3df82ed 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -864,7 +864,7 @@ xfs_ag_shrink_space(
 void
 xfs_growfs_compute_deltas(
 	struct xfs_mount	*mp,
-	xfs_rfsblock_t		nb,
+	xfs_rfsblock_t		*nb,
 	int64_t			*deltap,
 	xfs_agnumber_t		*nagcountp)
 {
@@ -872,19 +872,19 @@ xfs_growfs_compute_deltas(
 	int64_t		delta;
 	xfs_agnumber_t	nagcount;
 
-	nb_div = nb;
+	nb_div = *nb;
 	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
 	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
 		nb_div++;
 	else if (nb_mod)
-		nb = nb_div * mp->m_sb.sb_agblocks;
+		*nb = nb_div * mp->m_sb.sb_agblocks;
 
 	if (nb_div > XFS_MAX_AGNUMBER + 1) {
 		nb_div = XFS_MAX_AGNUMBER + 1;
-		nb = nb_div * mp->m_sb.sb_agblocks;
+		*nb = nb_div * mp->m_sb.sb_agblocks;
 	}
 	nagcount = nb_div;
-	delta = nb - mp->m_sb.sb_dblocks;
+	delta = *nb - mp->m_sb.sb_dblocks;
 	*deltap = delta;
 	*nagcountp = nagcount;
 }

