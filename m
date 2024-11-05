Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9B11CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846341; cv=none; b=YFqq5+eyOQDsg6C6gw6mDz4Gep14Roo0GM0flyoCsWPhTiboKdBfqtKRCdSSgvN2ViP/iXZkS7GAdDwhjbjx1syyKgQU44GycTbl2ytGhXLUyu+/iED7yXj7ckfIPH/oBgD2Ym/LXNbGEYsNW+vD0LFcpsjExM6k+ZcjNGo48bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846341; c=relaxed/simple;
	bh=Ghg8E08pjCYzdcD2fnG9nduoTiOPZud0RlUBIwmjog4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qOhGM738Uj1mopR0ZEkYN7ckuqAVBvXfsxkVJT1KwRE5+KzDsXVS4H1a9czb1+uyyKeCvcVg4Qr9v4g1cZ/5L4q/PBdsUKCw6wMNiasIQhPozTUZvIJjKO/Ma0586rxBYBJW+SGOVZCNY1dDgqc3enughsgu5zwjc+L/EaGtodM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXDPtxX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXDPtxX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2289AC4CECF;
	Tue,  5 Nov 2024 22:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846341;
	bh=Ghg8E08pjCYzdcD2fnG9nduoTiOPZud0RlUBIwmjog4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NXDPtxX+r1wXOFdXi5X5gO6JNMR46aQly2BRBLQiU3hJMicKXwQBA6qfdqNsh2vLp
	 qCt+RJps/p/ut/FKmpNZXZQrJ1+k3IbpQpQZuHaQ71+NYdLWMSPkJMNLrUZ3oTD4TD
	 waLgxX5PWYv3mjkVifeQZ5jDBknzhM/42BCqZE/P50EoGLRC2i4XKUz9hagE6e01ou
	 VeSSeLsfffIY63/mSESPVsVNX3nwm7MNetlle64htSr8NbGwZO2CMozs9FJ4w94eoD
	 M8AT3ghbIZdzz4H1sPIJ9WdpE9GOPvkCBCIvzzARGlo2F5qWUi4f49eEgGuGJBGDbO
	 kFyruustUmfgQ==
Date: Tue, 05 Nov 2024 14:39:00 -0800
Subject: [PATCH 1/4] xfs: refactor xfs_qm_destroy_quotainos
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399144.1873039.16522849456439468829.stgit@frogsfrogsfrogs>
In-Reply-To: <173084399117.1873039.18256038294248428421.stgit@frogsfrogsfrogs>
References: <173084399117.1873039.18256038294248428421.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Reuse this function instead of open-coding the logic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c |   53 ++++++++++++++++++++---------------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 28b1420bac1dd2..b37e80fe7e86a6 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -40,7 +40,6 @@
 STATIC int	xfs_qm_init_quotainos(struct xfs_mount *mp);
 STATIC int	xfs_qm_init_quotainfo(struct xfs_mount *mp);
 
-STATIC void	xfs_qm_destroy_quotainos(struct xfs_quotainfo *qi);
 STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
 /*
  * We use the batch lookup interface to iterate over the dquots as it
@@ -226,6 +225,24 @@ xfs_qm_unmount_rt(
 	xfs_rtgroup_rele(rtg);
 }
 
+STATIC void
+xfs_qm_destroy_quotainos(
+	struct xfs_quotainfo	*qi)
+{
+	if (qi->qi_uquotaip) {
+		xfs_irele(qi->qi_uquotaip);
+		qi->qi_uquotaip = NULL; /* paranoia */
+	}
+	if (qi->qi_gquotaip) {
+		xfs_irele(qi->qi_gquotaip);
+		qi->qi_gquotaip = NULL;
+	}
+	if (qi->qi_pquotaip) {
+		xfs_irele(qi->qi_pquotaip);
+		qi->qi_pquotaip = NULL;
+	}
+}
+
 /*
  * Called from the vfsops layer.
  */
@@ -250,20 +267,8 @@ xfs_qm_unmount_quotas(
 	/*
 	 * Release the quota inodes.
 	 */
-	if (mp->m_quotainfo) {
-		if (mp->m_quotainfo->qi_uquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_uquotaip);
-			mp->m_quotainfo->qi_uquotaip = NULL;
-		}
-		if (mp->m_quotainfo->qi_gquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_gquotaip);
-			mp->m_quotainfo->qi_gquotaip = NULL;
-		}
-		if (mp->m_quotainfo->qi_pquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_pquotaip);
-			mp->m_quotainfo->qi_pquotaip = NULL;
-		}
-	}
+	if (mp->m_quotainfo)
+		xfs_qm_destroy_quotainos(mp->m_quotainfo);
 }
 
 STATIC int
@@ -1712,24 +1717,6 @@ xfs_qm_init_quotainos(
 	return error;
 }
 
-STATIC void
-xfs_qm_destroy_quotainos(
-	struct xfs_quotainfo	*qi)
-{
-	if (qi->qi_uquotaip) {
-		xfs_irele(qi->qi_uquotaip);
-		qi->qi_uquotaip = NULL; /* paranoia */
-	}
-	if (qi->qi_gquotaip) {
-		xfs_irele(qi->qi_gquotaip);
-		qi->qi_gquotaip = NULL;
-	}
-	if (qi->qi_pquotaip) {
-		xfs_irele(qi->qi_pquotaip);
-		qi->qi_pquotaip = NULL;
-	}
-}
-
 STATIC void
 xfs_qm_dqfree_one(
 	struct xfs_dquot	*dqp)

